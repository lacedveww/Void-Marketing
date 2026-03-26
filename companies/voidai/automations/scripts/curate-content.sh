#!/usr/bin/env bash
# curate-content.sh
#
# Generates 8 content variants via Gemini API and saves them to a file.
# OpenClaw (Gemini) then reads the file, scores them, picks top 4, and
# presents only those 4 to Vew. This keeps the 8 variants hidden from chat.
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

# Build prompt
if [[ "$CONTENT_TYPE" == "thread" ]]; then
  TYPE_INST="Generate exactly 8 THREAD variants. Each thread: 5-7 tweets, each max 280 chars. Vary structure across: educational explainer, builder narrative, data story, ecosystem lens (2 variants each)."
  FORMAT='Each variant: {"id":"v1","hook_type":"data-lead","tone":"analytical","thread":[{"pos":1,"text":"..."},{"pos":2,"text":"..."}]}'
else
  TYPE_INST="Generate exactly 8 TWEET variants. Max 280 characters each. Count carefully. If over 280, rewrite shorter."
  FORMAT='Each variant: {"id":"v1","content":"tweet text here","hook_type":"data-lead","tone":"analytical","word_count":42}'
fi

PROMPT="Generate content for the ${ACCOUNT} X account.

PERSONA: ${PERSONA}

TOPIC: ${TOPIC:-Today's Bittensor/VoidAI developments based on the data below}

${TYPE_INST}

HOOK DIVERSITY (mandatory):
- v1,v2: data-lead hooks (open with specific number/metric)
- v3,v4: builder/conversational hooks (personal builder perspective)
- v5,v6: curiosity-gap hooks (question or teaser)
- v7,v8: alpha-leak/contrarian hooks (non-obvious insight)
Within each pair: one analytical tone, one conversational tone.

RULES: No hashtags. No em dashes. No double hyphens. No banned phrases: game-changer, paradigm shift, cutting-edge, seamless integration, robust ecosystem, revolutionizing, paving the way, it is worth noting, ever-evolving landscape, at its core, in conclusion, as we navigate. Every tweet needs specific data.

${SWEEP_CONTEXT:+TODAY'S DATA: ${SWEEP_CONTEXT}}

Output a JSON array of 8 objects. No markdown fences. No explanation. Just the array.
${FORMAT}"

# Call Gemini API
log "Generating 8 ${CONTENT_TYPE} variants for @${ACCOUNT}..."

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
