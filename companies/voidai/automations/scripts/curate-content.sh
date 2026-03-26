#!/usr/bin/env bash
# curate-content.sh
#
# Generates content variants via Gemini API and saves them to a file.
# Tweets: 8 variants (top 4 presented). Threads: 6 variants (top 3 presented).
# OpenClaw (Gemini) reads the file, scores them, picks the top options,
# and presents only those to Vew. Variants are hidden from chat.
#
# Usage:
#   ./curate-content.sh --account v0idai --type tweet --topic "lending update"
#   ./curate-content.sh --account bittensor --type thread --topic "subnet analysis"
#
# Output to stdout: the file path containing the 8 variants JSON
# The calling agent should then: cat <filepath> to read and score them

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
DATA_DIR="$PROJECT_ROOT/companies/voidai/automations/data"
LOG_DIR="$DATA_DIR/preference-log"

if [[ -f "$PROJECT_ROOT/.env" ]]; then
  set -a; source "$PROJECT_ROOT/.env"; set +a
fi

GEMINI_API_KEY="${GEMINI_API_KEY:-}"
GEMINI_URL="https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${GEMINI_API_KEY}"

if command -v curl.exe &>/dev/null; then CURL_BIN="curl.exe"; else CURL_BIN="curl"; fi

ACCOUNT="v0idai"
CONTENT_TYPE="tweet"
TOPIC=""
SLOT_NUM=1

while [[ $# -gt 0 ]]; do
  case "$1" in
    --account) ACCOUNT="$2"; shift 2 ;;
    --type) CONTENT_TYPE="$2"; shift 2 ;;
    --topic) TOPIC="$2"; shift 2 ;;
    --slot) SLOT_NUM="$2"; shift 2 ;;
    *) shift ;;
  esac
done

log() { echo "[curate] $*" >&2; }
mkdir -p "$LOG_DIR"

# Persona lookup
case "$ACCOUNT" in
  v0idai)     PERSONA="Builder talking to builders. Technical, accessible, confident. Lead with data. VoidAI = Bittensor DeFi Infrastructure (bridge + staking + lending). Lending is current focus. Terms: subnet, alpha token, dTAO, SN106, emissions, TVL, LTV, collateral. Sound like a founder." ;;
  daily-info) PERSONA="Factual news wire. Facts first. Minimal editorializing. Hooks: VoidAI daily, Bridge stats (24h), Lending update, SN106 today. 50% product updates, 30% ecosystem news, 20% educational. Specific numbers. Never editorialize." ;;
  bittensor)  PERSONA="Data-driven ecosystem analyst. Subnet spotlights. Cashtags \$TAO, \$dTAO. Neutral, factual. Alpha-sharing. VoidAI mention MAX 1-2x/week. Cover whole ecosystem not just SN106." ;;
  *) PERSONA="Professional crypto/DeFi voice." ;;
esac

# Sweep context
SWEEP_FILE=$(ls -t "$DATA_DIR"/sweep-$(date +%Y-%m-%d)*.json 2>/dev/null | head -1)
SWEEP_CONTEXT=""
if [[ -n "$SWEEP_FILE" && -f "$SWEEP_FILE" ]]; then
  SWEEP_CONTEXT=$(jq -c '{tao_price: .metrics_snapshot.tao.price_usd, tao_24h: .metrics_snapshot.tao.price_change_24h_pct, sn106_validators: .metrics_snapshot.sn106.validators, subnets: .metrics_snapshot.network.total_subnets, top_posts: [.x_accounts.posts | sort_by(-.engagement.likes) | .[0:3] | .[] | {account, text: .tweet_text[0:100], likes: .engagement.likes}]}' "$SWEEP_FILE" 2>/dev/null || echo "")
fi

# Load preference learning context
PREFERENCE_CONTEXT=""
PREF_LOG_DIR="$DATA_DIR/preference-log"
LATEST_PREF_LOG=$(ls -t "$PREF_LOG_DIR"/preference-log-*.json 2>/dev/null | head -1)
if [[ -n "$LATEST_PREF_LOG" && -f "$LATEST_PREF_LOG" ]]; then
  PREF_SELECTED=$(jq -r '[.entries[]? | select(.user_selection.skipped != true and .user_selection.selected_variant_id != null) | "- \(.user_selection.selected_variant_id): score \(.user_selection.selected_composite_score // "?")"] | .[0:5] | join("\n")' "$LATEST_PREF_LOG" 2>/dev/null || echo "")
  if [[ -n "$PREF_SELECTED" ]]; then
    PREFERENCE_CONTEXT="PREFERENCE LEARNING: Recent curator selections: ${PREF_SELECTED}. Generate variants aligned with these preferences."
  fi
fi

# Performance context
PERF_CONTEXT=""
PERF_FILE="$DATA_DIR/performance-summary.json"
if [[ -f "$PERF_FILE" ]]; then
  PERF_CONTEXT=$(jq -r '"POST ANALYTICS: Avg engagement " + (.avg_engagement_rate_pct // "?" | tostring) + "%. Patterns: " + ([.patterns[]? | .[0:80]] | .[0:3] | join("; "))' "$PERF_FILE" 2>/dev/null || echo "")
fi

# Determine variant count by content type
if [[ "$CONTENT_TYPE" == "thread" ]]; then
  VARIANT_COUNT=6
  TYPE_INST="Generate exactly ${VARIANT_COUNT} THREAD variants. Each thread: 5-7 tweets, each max 280 chars."
  FORMAT='Each variant: {"id":"v1","thread":[{"pos":1,"text":"..."},{"pos":2,"text":"..."}]}'
else
  VARIANT_COUNT=8
  TYPE_INST="Generate exactly ${VARIANT_COUNT} TWEET variants. Max 280 characters each. Count carefully. If over 280, rewrite shorter."
  FORMAT='Each variant: {"id":"v1","content":"tweet text here","word_count":42}'
fi

PROMPT="Generate content for the ${ACCOUNT} X account.

PERSONA: ${PERSONA}

TOPIC: ${TOPIC:-Today's Bittensor/VoidAI developments based on the data below}

${TYPE_INST}

CONTENT STRATEGY: Base each variant on the monitoring data, trending topics, post analytics, and preference learning below. Each variant should take a DIFFERENT angle on the data. Vary hook style and narrative organically based on what the data suggests. Do NOT use predefined categories.

RULES: No hashtags. No em dashes. No double hyphens. No banned phrases: game-changer, paradigm shift, cutting-edge, seamless integration, robust ecosystem, revolutionizing, paving the way, it is worth noting, ever-evolving landscape, at its core, in conclusion, as we navigate. Every tweet needs specific data.

${SWEEP_CONTEXT:+TODAY'S DATA: ${SWEEP_CONTEXT}}
${PERF_CONTEXT:+${PERF_CONTEXT}}
${PREFERENCE_CONTEXT:+${PREFERENCE_CONTEXT}}

Output a JSON array of ${VARIANT_COUNT} objects. No markdown fences. No explanation. Just the array.
${FORMAT}"

# Call Gemini API
log "Generating ${VARIANT_COUNT} ${CONTENT_TYPE} variants for @${ACCOUNT}..."

BODY_FILE=$(mktemp)
RESPONSE_FILE=$(mktemp)
trap 'rm -f "$BODY_FILE" "$RESPONSE_FILE"' EXIT

jq -n --arg prompt "$PROMPT" '{contents:[{parts:[{text:$prompt}]}],generationConfig:{temperature:1.0,maxOutputTokens:8192}}' > "$BODY_FILE"

$CURL_BIN -s --max-time 90 "$GEMINI_URL" \
  -H "Content-Type: application/json" \
  -d @"$BODY_FILE" \
  -o "$RESPONSE_FILE" 2>/dev/null

RAW_TEXT=$(jq -r '.candidates[0].content.parts[0].text // empty' "$RESPONSE_FILE" 2>/dev/null)

if [[ -z "$RAW_TEXT" ]]; then
  log "ERROR: Gemini returned no text"
  exit 1
fi

# Extract JSON array
VARIANTS=$(python -c "
import sys, json
text = sys.stdin.read()
start = text.find('[')
end = text.rfind(']')
if start >= 0 and end > start:
    try:
        arr = json.loads(text[start:end+1])
        print(json.dumps(arr))
    except: print('[]')
else: print('[]')
" <<< "$RAW_TEXT" 2>/dev/null || echo "[]")

COUNT=$(echo "$VARIANTS" | jq 'length' 2>/dev/null || echo 0)
log "Generated $COUNT variants"

if [[ "$COUNT" -lt 4 ]]; then
  log "ERROR: Only $COUNT variants"
  exit 1
fi

# Save to file for Gemini to read, score, and select
OUTPUT_FILE="$DATA_DIR/variants-${ACCOUNT}-${CONTENT_TYPE}-${SLOT_NUM}-$(date +%H%M%S).json"
jq -n \
  --arg account "$ACCOUNT" \
  --arg type "$CONTENT_TYPE" \
  --argjson slot "$SLOT_NUM" \
  --arg topic "${TOPIC:-auto}" \
  --argjson variants "$VARIANTS" \
  '{account: $account, content_type: $type, slot: $slot, topic: $topic, variant_count: ($variants | length), variants: $variants}' > "$OUTPUT_FILE"

# Output the file path so the calling agent can cat it
echo "$OUTPUT_FILE"
log "Variants saved to $OUTPUT_FILE"
