#!/usr/bin/env bash
# generate-weekly-thread.sh
#
# Generates a 5-7 tweet thread from weekly metrics data using claude -p.
# Designed for the Friday weekly recap (WF3 in the pipeline architecture).
#
# Usage:
#   ./generate-weekly-thread.sh /path/to/weekly-metrics.json
#   ./generate-weekly-thread.sh --variants 8 /path/to/weekly-metrics.json
#   DRY_RUN=true ./generate-weekly-thread.sh /path/to/weekly-metrics.json
#
# Input:  JSON file with aggregated weekly metrics (7-day TAO price trend,
#         SN106 rank changes, bridge volume, GitHub activity, etc.)
# Output: JSON array of tweets to stdout:
#         [{ "position": 1, "tweet": "...", "is_hook": true }, ...]
#
# Environment:
#   DRY_RUN       If "true", skips the claude call and outputs a placeholder.
#   CLAUDE_PATH   Optional path to claude binary (default: claude)
#
# Must be run from the Void-AI project root so CLAUDE.md is loaded.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPANY_DIR="$PROJECT_ROOT/companies/voidai"

# Preserve caller's DRY_RUN before sourcing .env
_CALLER_DRY_RUN="${DRY_RUN:-}"
# Source .env if present
if [[ -f "$PROJECT_ROOT/.env" ]]; then
  set -a
  # shellcheck source=/dev/null
  source "$PROJECT_ROOT/.env"
  set +a
fi

CLAUDE_BIN="${CLAUDE_PATH:-claude}"
# Caller's explicit DRY_RUN takes precedence over .env
DRY_RUN="${_CALLER_DRY_RUN:-${DRY_RUN:-true}}"

log() {
  echo "[generate-weekly-thread] $(date '+%Y-%m-%d %H:%M:%S') $*" >&2
}

usage() {
  echo "Usage: $0 [--variants N] [--account NAME] <weekly-metrics-json-file>" >&2
  echo "  --account: v0idai (default), daily-info, bittensor, defi" >&2
  exit 1
}

# Parse optional flags before positional args
VARIANTS=1
ACCOUNT="v0idai"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --variants) VARIANTS="$2"; shift 2 ;;
    --account) ACCOUNT="$2"; shift 2 ;;
    *) break ;;
  esac
done

if [[ $# -lt 1 ]]; then
  usage
fi

METRICS_FILE="$1"

if [[ ! -f "$METRICS_FILE" ]]; then
  log "ERROR: Metrics file not found: $METRICS_FILE"
  exit 1
fi

if ! jq empty "$METRICS_FILE" 2>/dev/null; then
  log "ERROR: Invalid JSON in metrics file: $METRICS_FILE"
  exit 1
fi

METRICS_DATA=$(cat "$METRICS_FILE")
log "Loaded weekly metrics from $METRICS_FILE"

# Load account persona from accounts.md
ACCOUNTS_FILE="$COMPANY_DIR/accounts.md"
if [[ -f "$ACCOUNTS_FILE" ]]; then
  case "$ACCOUNT" in
    v0idai)      ACCOUNT_SECTION="Account 1" ; ACCOUNT_NAME="@v0idai (Main)" ;;
    daily-info)  ACCOUNT_SECTION="Account 2" ; ACCOUNT_NAME="VoidAI Daily/Informational" ;;
    bittensor)   ACCOUNT_SECTION="Account 3" ; ACCOUNT_NAME="Bittensor Ecosystem Analyst" ;;
    defi)        ACCOUNT_SECTION="Account 4" ; ACCOUNT_NAME="DeFi / Cross-Chain Alpha" ;;
    *)           ACCOUNT_SECTION="Account 1" ; ACCOUNT_NAME="@v0idai (Main)" ;;
  esac
  # Extract from "## Account N:" to next "## Account" or "---" separator
  ACCOUNT_PERSONA=$(sed -n "/^## ${ACCOUNT_SECTION}:/,/^## Account [0-9]/p" "$ACCOUNTS_FILE" | sed '$d')
  if [[ -z "$ACCOUNT_PERSONA" ]]; then
    # Fallback: try extracting to end of file (for last account)
    ACCOUNT_PERSONA=$(sed -n "/^## ${ACCOUNT_SECTION}:/,\$p" "$ACCOUNTS_FILE")
  fi
  log "Loaded persona for $ACCOUNT_NAME"
else
  ACCOUNT_PERSONA=""
  ACCOUNT_NAME="@v0idai (Main)"
  log "WARNING: accounts.md not found, using default persona"
fi

# Load performance summary (feedback loop)
PERFORMANCE_SUMMARY_FILE="$PROJECT_ROOT/companies/voidai/automations/data/performance-summary.json"
TOP_PERFORMERS_FILE="$PROJECT_ROOT/companies/voidai/automations/data/top-performers.json"
PERFORMANCE_CONTEXT=""
if [[ -f "$PERFORMANCE_SUMMARY_FILE" ]]; then
  PERF_DATA=$(cat "$PERFORMANCE_SUMMARY_FILE")
  TOP_DATA=""
  if [[ -f "$TOP_PERFORMERS_FILE" ]]; then
    TOP_DATA=$(cat "$TOP_PERFORMERS_FILE" | jq -r '[.[:3][] | "- \(.content_preview[:100])... (engagement: \(.engagement_rate_pct)%)"] | join("\n")' 2>/dev/null || echo "")
  fi
  PERFORMANCE_CONTEXT="
PERFORMANCE FEEDBACK (use to guide hook selection and thread structure):
Average engagement rate: $(echo "$PERF_DATA" | jq -r '.avg_engagement_rate_pct // "unknown"')%

Top performing posts this period:
${TOP_DATA:-No top performer data yet.}

Patterns from engagement data:
$(echo "$PERF_DATA" | jq -r '.patterns // [] | .[:4][] // empty' 2>/dev/null || echo "No patterns yet.")

Recommendations:
$(echo "$PERF_DATA" | jq -r '.recommendations // [] | .[:3][] // empty' 2>/dev/null || echo "No recommendations yet.")

Use these insights to choose hook style, thread pacing, and emphasis areas.
"
  log "Loaded performance feedback data for thread generation"
else
  log "No performance-summary.json found. Generating thread without feedback data."
  PERFORMANCE_CONTEXT="
PERFORMANCE FEEDBACK: No engagement data available yet. Use default voice and hook strategies.
"
fi

# Load voice and compliance files
VOICE_FILE="$COMPANY_DIR/voice.md"
COMPLIANCE_FILE="$COMPANY_DIR/compliance.md"
PILLARS_FILE="$COMPANY_DIR/pillars.md"

for required_file in "$VOICE_FILE" "$COMPLIANCE_FILE" "$PILLARS_FILE"; do
  if [[ ! -f "$required_file" ]]; then
    log "ERROR: Required file not found: $required_file"
    exit 1
  fi
done

VOICE_RULES=$(cat "$VOICE_FILE")
COMPLIANCE_RULES=$(cat "$COMPLIANCE_FILE")
PILLARS=$(cat "$PILLARS_FILE")

# DRY_RUN mode
if [[ "$DRY_RUN" == "true" ]]; then
  log "DRY_RUN is true. Outputting placeholder."
  TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
  if [[ "$VARIANTS" -gt 1 ]]; then
    # Generate mock thread variant data for multi-variant dry run
    STRUCTURE_TYPES=("educational" "educational" "builder-narrative" "builder-narrative" "data-story" "data-story" "ecosystem-lens" "ecosystem-lens")
    TONES=("analytical" "conversational" "analytical" "conversational" "analytical" "conversational" "analytical" "conversational")
    MOCK_VARIANTS="["
    for i in $(seq 1 "$VARIANTS"); do
      IDX=$(( (i - 1) % 8 ))
      [[ $i -gt 1 ]] && MOCK_VARIANTS+=","
      MOCK_VARIANTS+="{\"id\":\"v${i}\",\"content\":[{\"position\":1,\"tweet\":\"[DRY_RUN] Variant ${i} hook tweet\",\"is_hook\":true},{\"position\":2,\"tweet\":\"[DRY_RUN] Variant ${i} data tweet\",\"is_hook\":false},{\"position\":3,\"tweet\":\"[DRY_RUN] Variant ${i} insight tweet\",\"is_hook\":false},{\"position\":4,\"tweet\":\"[DRY_RUN] Variant ${i} CTA tweet\",\"is_hook\":false}],\"hook_type\":\"${STRUCTURE_TYPES[$IDX]}\",\"tone\":\"${TONES[$IDX]}\",\"format\":\"thread\",\"content_type\":\"thread\",\"account\":\"${ACCOUNT}\",\"pillar\":\"ecosystem-intelligence\",\"topic\":\"weekly recap\",\"word_count\":20}"
    done
    MOCK_VARIANTS+="]"
    jq -n \
      --argjson variants "$MOCK_VARIANTS" \
      --arg ts "$TIMESTAMP" \
      '{
        "variants": $variants,
        "status": "dry_run",
        "created_at": $ts
      }'
  else
    jq -n \
      --arg ts "$TIMESTAMP" \
      --arg account "$ACCOUNT" \
      '{
        "thread": [
          {"position": 1, "tweet": "[DRY_RUN] Hook tweet placeholder", "is_hook": true},
          {"position": 2, "tweet": "[DRY_RUN] Data tweet placeholder", "is_hook": false},
          {"position": 3, "tweet": "[DRY_RUN] Data tweet placeholder", "is_hook": false},
          {"position": 4, "tweet": "[DRY_RUN] Insight tweet placeholder", "is_hook": false},
          {"position": 5, "tweet": "[DRY_RUN] CTA tweet placeholder", "is_hook": false}
        ],
        "platform": "x",
        "account": $account,
        "pillar": "ecosystem-intelligence",
        "content_type": "thread",
        "status": "dry_run",
        "created_at": $ts
      }'
  fi
  exit 0
fi

# Build the prompt
if [[ "$VARIANTS" -gt 1 ]]; then
  # --- Multi-variant thread prompt ---
  PROMPT="You are generating weekly recap THREAD variants for the ${ACCOUNT_NAME} X account.
VoidAI is Bittensor DeFi Infrastructure (bridge + staking + lending). The lending platform is the current primary focus.
VoidAI operates 3 X accounts (1 main + 2 satellites: Daily/Informational, Bittensor Ecosystem).

Generate exactly $VARIANTS thread variants based on the weekly metrics data below for the ${ACCOUNT_NAME} account.

MANDATORY DIVERSITY — each variant must use a DIFFERENT structure type:
- Variants 1-2: educational structure (teach the reader something, break down a concept with data)
- Variants 3-4: builder narrative structure (tell the story from a builder's perspective, what was built/shipped/learned)
- Variants 5-6: data story structure (lead with the numbers, let metrics tell the narrative)
- Variants 7-8: ecosystem lens structure (zoom out to Bittensor ecosystem context, connect VoidAI's week to broader trends)

Within each pair, vary the TONE:
- One analytical, one conversational (for each structure type pair)

Each thread variant must contain 5 to 7 tweets with this structure:
1. Hook tweet: grabs attention, sets up the thread. Use a compelling data point or insight.
2. Data tweets (2-4 tweets): each covers one key metric or trend. Specific numbers required.
3. Insight tweet: connect the data to a \"so what\" for the reader.
4. CTA tweet: close with a clear call to action.

Every variant must:
- Follow the voice rules provided
- Match the account persona
- Connect to this week's data
- Answer \"so what\" for the reader
- Contain no banned AI phrases

VOICE RULES:
$VOICE_RULES

ACCOUNT PERSONA (match this voice exactly):
${ACCOUNT_PERSONA}

COMPLIANCE RULES (mandatory):
$COMPLIANCE_RULES

CONTENT PILLARS (for reference):
$PILLARS

BANNED PHRASES (any of these in any tweet = auto-fail):
- \"It's worth noting\", \"In the ever-evolving landscape of\", \"At its core\"
- \"This is a game-changer\", \"This underscores the importance of\", \"Without further ado\"
- \"In today's rapidly changing\", \"Revolutionizing the way\", \"Paving the way for\"
- \"Paradigm shift\", \"Synergy/synergies\", \"Holistic approach\", \"Cutting-edge\"
- \"Seamless integration\", \"Robust ecosystem\", \"It is important to note that\"
- \"In conclusion\", \"As we navigate\"
- \"Additionally,\" / \"Furthermore,\" / \"Moreover,\" at sentence start

FORMATTING RULES:
- NEVER use em dashes or double hyphens anywhere. Use commas, periods, colons, or line breaks.
- Each tweet max 280 characters.
- Every tweet must contribute specific data or actionable insight. No filler.
- Sound like a builder talking to other builders.
- Use Bittensor-native terminology: subnet, SN106, dTAO, emissions, metagraph.
- Use DeFi terminology where relevant: TVL, bridge volume, liquidity.
- Use lending terminology where relevant: collateral, LTV, borrow rate, supply rate, utilization rate.
- The hook tweet should NOT start with \"This week\" or \"Weekly update\". Open with the most compelling data point.

$PERFORMANCE_CONTEXT

WEEKLY METRICS DATA:
$METRICS_DATA

OUTPUT FORMAT:
Return ONLY valid JSON, no markdown fences, no explanation.
{
  \"variants\": [
    {
      \"id\": \"v1\",
      \"content\": [
        {\"position\": 1, \"tweet\": \"<hook tweet text>\", \"is_hook\": true},
        {\"position\": 2, \"tweet\": \"<data tweet>\", \"is_hook\": false},
        ...
      ],
      \"hook_type\": \"educational\",
      \"tone\": \"analytical\",
      \"format\": \"thread\",
      \"content_type\": \"thread\",
      \"account\": \"${ACCOUNT}\",
      \"pillar\": \"ecosystem-intelligence\",
      \"topic\": \"<topic from weekly data>\",
      \"word_count\": <total word count across all tweets>
    },
    ...
  ]
}

Generate all $VARIANTS thread variants now."

else
  # --- Single-variant prompt (original) ---
  PROMPT="You are generating a weekly recap THREAD for the ${ACCOUNT_NAME} X account.
VoidAI is Bittensor DeFi Infrastructure (bridge + staking + lending). The lending platform is the current primary focus.
VoidAI operates 3 X accounts (1 main + 2 satellites: Daily/Informational, Bittensor Ecosystem).

TASK: Generate a thread of 5 to 7 tweets based on the weekly metrics data below.

THREAD STRUCTURE (mandatory):
1. Hook tweet: grabs attention, sets up the thread. Use a compelling data point or insight as the hook.
2. Data tweets (2-4 tweets): each covers one key metric or trend from the week. Specific numbers required.
3. Insight tweet: connect the data to a \"so what\" for the reader. What does this mean for TAO holders, subnet builders, or DeFi users?
4. CTA tweet: close with a clear call to action (bridge, stake, learn more, follow for updates).

VOICE RULES:
$VOICE_RULES

ACCOUNT PERSONA (match this voice exactly):
${ACCOUNT_PERSONA}

COMPLIANCE RULES (mandatory):
$COMPLIANCE_RULES

CONTENT PILLARS (for reference):
$PILLARS

BANNED PHRASES (any of these in any tweet = auto-fail):
- \"It's worth noting\", \"In the ever-evolving landscape of\", \"At its core\"
- \"This is a game-changer\", \"This underscores the importance of\", \"Without further ado\"
- \"In today's rapidly changing\", \"Revolutionizing the way\", \"Paving the way for\"
- \"Paradigm shift\", \"Synergy/synergies\", \"Holistic approach\", \"Cutting-edge\"
- \"Seamless integration\", \"Robust ecosystem\", \"It is important to note that\"
- \"In conclusion\", \"As we navigate\"
- \"Additionally,\" / \"Furthermore,\" / \"Moreover,\" at sentence start

FORMATTING RULES:
- NEVER use em dashes or double hyphens anywhere. Use commas, periods, colons, or line breaks.
- Each tweet max 280 characters.
- Every tweet must contribute specific data or actionable insight. No filler.
- Sound like a builder talking to other builders.
- Use Bittensor-native terminology: subnet, SN106, dTAO, emissions, metagraph.
- Use DeFi terminology where relevant: TVL, bridge volume, liquidity.
- Use lending terminology where relevant: collateral, LTV, borrow rate, supply rate, utilization rate.
- The hook tweet should NOT start with \"This week\" or \"Weekly update\". Open with the most compelling data point.

$PERFORMANCE_CONTEXT

WEEKLY METRICS DATA:
$METRICS_DATA

OUTPUT FORMAT:
Return ONLY valid JSON, no markdown fences, no explanation. Array of tweet objects:
[
  {\"position\": 1, \"tweet\": \"<hook tweet text>\", \"is_hook\": true},
  {\"position\": 2, \"tweet\": \"<data tweet>\", \"is_hook\": false},
  ...
]

Generate the thread now."
fi

log "Calling claude -p to generate weekly thread (variants=$VARIANTS)..."

CLAUDE_OUTPUT=$(cd "$PROJECT_ROOT" && echo "$PROMPT" | "$CLAUDE_BIN" -p 2>/dev/null) || {
  log "ERROR: claude -p failed"
  exit 1
}

if [[ "$VARIANTS" -gt 1 ]]; then
  # --- Multi-variant JSON extraction ---
  CLEAN_OUTPUT=$(echo "$CLAUDE_OUTPUT" | sed 's/^```json//; s/^```//; s/```$//' | tr '\n' ' ')
  CLEAN_OUTPUT=$(echo "$CLEAN_OUTPUT" | sed 's/.*\({.*}\).*/\1/')

  if [[ -z "$CLEAN_OUTPUT" ]]; then
    log "ERROR: Could not extract valid JSON from claude output"
    log "Raw output: $CLAUDE_OUTPUT"
    exit 1
  fi

  if ! echo "$CLEAN_OUTPUT" | jq empty 2>/dev/null; then
    log "ERROR: Extracted output is not valid JSON"
    log "Extracted: $CLEAN_OUTPUT"
    exit 1
  fi

  VARIANT_COUNT=$(echo "$CLEAN_OUTPUT" | jq '.variants | length')
  if [[ "$VARIANT_COUNT" -lt 1 ]]; then
    log "ERROR: No variants array in output"
    exit 1
  fi

  log "Extracted $VARIANT_COUNT thread variants from claude output"

  # Validate each variant's thread tweets
  FLAGGED=0
  for v in $(seq 0 $((VARIANT_COUNT - 1))); do
    V_ID=$(echo "$CLEAN_OUTPUT" | jq -r ".variants[$v].id // \"v$((v+1))\"")
    THREAD_LEN=$(echo "$CLEAN_OUTPUT" | jq ".variants[$v].content | length")

    if [[ "$THREAD_LEN" -lt 5 || "$THREAD_LEN" -gt 7 ]]; then
      log "WARNING: Variant $V_ID has $THREAD_LEN tweets (expected 5-7)"
      FLAGGED=$((FLAGGED + 1))
    fi

    for t in $(seq 0 $((THREAD_LEN - 1))); do
      TWEET=$(echo "$CLEAN_OUTPUT" | jq -r ".variants[$v].content[$t].tweet // empty")
      TWEET_LEN=${#TWEET}

      if [[ $TWEET_LEN -gt 280 ]]; then
        log "WARNING: Variant $V_ID tweet $((t+1)) is $TWEET_LEN chars (over 280)"
        FLAGGED=$((FLAGGED + 1))
      fi

      if echo "$TWEET" | grep -q '\-\-'; then
        log "WARNING: Variant $V_ID tweet $((t+1)) contains double hyphens"
        FLAGGED=$((FLAGGED + 1))
      fi
    done
  done

  STATUS="pending_review"
  if [[ $FLAGGED -gt 0 ]]; then
    STATUS="flagged_validation"
    log "Thread variants flagged with $FLAGGED issues"
  fi

  TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

  echo "$CLEAN_OUTPUT" | jq \
    --arg status "$STATUS" \
    --arg ts "$TIMESTAMP" \
    '. + { "status": $status, "created_at": $ts }'

  log "Multi-variant thread generation complete ($VARIANT_COUNT variants, status: $STATUS)"

else
  # --- Single-variant extraction (original) ---
  # Extract JSON array from output
  CLEAN_OUTPUT=$(echo "$CLAUDE_OUTPUT" | sed 's/^```json//; s/^```//; s/```$//' | tr '\n' ' ')

  # Try to extract the JSON array
  THREAD_JSON=$(echo "$CLEAN_OUTPUT" | grep -oE '\[.*\]' | head -1) || true

  if [[ -z "$THREAD_JSON" ]]; then
    log "ERROR: Could not extract JSON array from claude output"
    log "Raw output: $CLAUDE_OUTPUT"
    exit 1
  fi

  if ! echo "$THREAD_JSON" | jq empty 2>/dev/null; then
    log "ERROR: Extracted output is not valid JSON"
    log "Extracted: $THREAD_JSON"
    exit 1
  fi

  # Validate thread structure
  TWEET_COUNT=$(echo "$THREAD_JSON" | jq 'length')

  if [[ "$TWEET_COUNT" -lt 5 || "$TWEET_COUNT" -gt 7 ]]; then
    log "WARNING: Thread has $TWEET_COUNT tweets (expected 5-7)"
  fi

  # Validate each tweet length and check for banned content
  VALIDATION_ISSUES=0
  for i in $(seq 0 $((TWEET_COUNT - 1))); do
    TWEET=$(echo "$THREAD_JSON" | jq -r ".[$i].tweet")
    TWEET_LEN=${#TWEET}

    if [[ $TWEET_LEN -gt 280 ]]; then
      log "WARNING: Tweet $((i + 1)) is $TWEET_LEN chars (over 280)"
      VALIDATION_ISSUES=$((VALIDATION_ISSUES + 1))
    fi

    # Check for em dashes and double hyphens
    if echo "$TWEET" | grep -q '\-\-'; then
      log "WARNING: Tweet $((i + 1)) contains double hyphens"
      VALIDATION_ISSUES=$((VALIDATION_ISSUES + 1))
    fi
  done

  STATUS="pending_review"
  if [[ $VALIDATION_ISSUES -gt 0 ]]; then
    STATUS="flagged_validation"
    log "Thread flagged with $VALIDATION_ISSUES validation issues"
  fi

  TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

  # Output structured JSON
  jq -n \
    --argjson thread "$THREAD_JSON" \
    --arg status "$STATUS" \
    --arg ts "$TIMESTAMP" \
    --arg account "$ACCOUNT" \
    --argjson count "$TWEET_COUNT" \
    '{
      "thread": $thread,
      "platform": "x",
      "account": $account,
      "pillar": "ecosystem-intelligence",
      "content_type": "thread",
      "tweet_count": $count,
      "status": $status,
      "created_at": $ts
    }'

  log "Thread generated successfully ($TWEET_COUNT tweets, status: $STATUS)"
fi
