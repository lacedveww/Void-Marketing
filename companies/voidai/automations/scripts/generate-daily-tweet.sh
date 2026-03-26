#!/usr/bin/env bash
# generate-daily-tweet.sh
#
# Generates a single daily metrics tweet using claude -p (non-interactive mode).
# Reads daily metrics JSON (from Gemini data collection or collect-metrics.sh),
# injects voice rules, compliance rules, and banned phrase checks, then outputs
# structured JSON to stdout.
#
# Usage:
#   ./generate-daily-tweet.sh /path/to/daily-metrics.json
#   ./generate-daily-tweet.sh --variants 8 /path/to/daily-metrics.json
#   DRY_RUN=true ./generate-daily-tweet.sh /path/to/daily-metrics.json
#
# Input:  JSON file with daily metrics (TAO price, SN106 rank, bridge volume, etc.)
# Output: JSON to stdout: { "tweet": "...", "platform": "x", "account": "v0idai", "status": "pending_review" }
#
# Environment:
#   DRY_RUN       If "true", skips the claude call and outputs a placeholder.
#   CLAUDE_PATH   Optional path to claude binary (default: claude)
#
# Must be run from the Void-AI project root so CLAUDE.md is loaded by claude -p.

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
  echo "[generate-daily-tweet] $(date '+%Y-%m-%d %H:%M:%S') $*" >&2
}

usage() {
  echo "Usage: $0 [--variants N] [--account NAME] <metrics-json-file>" >&2
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

# Validate input
if [[ $# -lt 1 ]]; then
  usage
fi

METRICS_FILE="$1"

if [[ ! -f "$METRICS_FILE" ]]; then
  log "ERROR: Metrics file not found: $METRICS_FILE"
  exit 1
fi

# Validate JSON
if ! jq empty "$METRICS_FILE" 2>/dev/null; then
  log "ERROR: Invalid JSON in metrics file: $METRICS_FILE"
  exit 1
fi

METRICS_DATA=$(cat "$METRICS_FILE")
log "Loaded metrics from $METRICS_FILE"

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

# Load performance summary (feedback loop: learn from past engagement data)
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
PERFORMANCE FEEDBACK (from recent post analytics, use this to guide style and hook choices):
Average engagement rate: $(echo "$PERF_DATA" | jq -r '.avg_engagement_rate_pct // "unknown"')%
Total posts analyzed: $(echo "$PERF_DATA" | jq -r '.total_posts_analyzed // "unknown"')

Top performing posts recently:
${TOP_DATA:-No top performer data available yet.}

Key patterns from data:
$(echo "$PERF_DATA" | jq -r '.patterns // [] | .[:3][] // empty' 2>/dev/null || echo "No pattern data yet.")

Recommendations based on performance:
$(echo "$PERF_DATA" | jq -r '.recommendations // [] | .[:3][] // empty' 2>/dev/null || echo "No recommendations yet.")
"
  log "Loaded performance feedback data for prompt injection"
else
  log "No performance-summary.json found. Generating without feedback loop data."
  PERFORMANCE_CONTEXT="
PERFORMANCE FEEDBACK: No engagement data available yet. Use default voice and hook strategies.
"
fi

# Load voice rules
VOICE_FILE="$COMPANY_DIR/voice.md"
if [[ ! -f "$VOICE_FILE" ]]; then
  log "ERROR: Voice file not found: $VOICE_FILE"
  exit 1
fi
VOICE_RULES=$(cat "$VOICE_FILE")

# Load compliance rules
COMPLIANCE_FILE="$COMPANY_DIR/compliance.md"
if [[ ! -f "$COMPLIANCE_FILE" ]]; then
  log "ERROR: Compliance file not found: $COMPLIANCE_FILE"
  exit 1
fi
COMPLIANCE_RULES=$(cat "$COMPLIANCE_FILE")

# Banned phrases list (from CLAUDE.md and voice.md)
BANNED_PHRASES='BANNED PHRASES (any of these = auto-fail, rewrite required):
- "It'\''s worth noting"
- "In the ever-evolving landscape of"
- "At its core"
- "This is a game-changer"
- "This underscores the importance of"
- "Without further ado"
- "In today'\''s rapidly changing"
- "Revolutionizing the way"
- "Paving the way for"
- "Paradigm shift"
- "Synergy" or "synergies"
- "Holistic approach"
- "Cutting-edge"
- "Seamless integration"
- "Robust ecosystem"
- "Additionally," at start of sentence
- "Furthermore," at start of sentence
- "Moreover," at start of sentence
- "It is important to note that"
- "In conclusion"
- "As we navigate"'

# DRY_RUN mode: skip the claude call
if [[ "$DRY_RUN" == "true" ]]; then
  log "DRY_RUN is true. Outputting placeholder."
  TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
  if [[ "$VARIANTS" -gt 1 ]]; then
    # Generate mock variant data for multi-variant dry run
    HOOK_TYPES=("data-lead" "data-lead" "builder-conversational" "builder-conversational" "curiosity-gap" "curiosity-gap" "alpha-leak-contrarian" "alpha-leak-contrarian")
    TONES=("analytical" "conversational" "analytical" "conversational" "analytical" "conversational" "analytical" "conversational")
    MOCK_VARIANTS="["
    for i in $(seq 1 "$VARIANTS"); do
      IDX=$(( (i - 1) % 8 ))
      [[ $i -gt 1 ]] && MOCK_VARIANTS+=","
      MOCK_VARIANTS+="{\"id\":\"v${i}\",\"content\":\"[DRY_RUN] Mock variant ${i} tweet text\",\"hook_type\":\"${HOOK_TYPES[$IDX]}\",\"tone\":\"${TONES[$IDX]}\",\"format\":\"single-stat-opener\",\"content_type\":\"tweet\",\"account\":\"${ACCOUNT}\",\"pillar\":\"bridge-build\",\"topic\":\"daily metrics\",\"word_count\":7}"
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
      --arg metrics "$METRICS_DATA" \
      --arg account "$ACCOUNT" \
      '{
        "tweet": "[DRY_RUN] Would generate tweet from metrics data",
        "platform": "x",
        "account": $account,
        "pillar": "bridge-build",
        "status": "dry_run",
        "created_at": $ts,
        "metrics_input": ($metrics | fromjson)
      }'
  fi
  exit 0
fi

# Build the prompt for claude -p
if [[ "$VARIANTS" -gt 1 ]]; then
  # --- Multi-variant prompt ---
  PROMPT="You are generating tweets for the ${ACCOUNT_NAME} X account.
VoidAI is Bittensor DeFi Infrastructure (bridge + staking + lending). The lending platform is the current primary focus.
VoidAI operates 4 X accounts (1 main + 3 satellites: Daily/Informational, Bittensor Ecosystem, DeFi/Cross-Chain).

Generate exactly $VARIANTS tweet variants about the topic below for the ${ACCOUNT_NAME} account.

MANDATORY DIVERSITY — each variant must use a DIFFERENT hook type:
- Variants 1-2: data-lead hooks (open with a specific number or metric)
- Variants 3-4: builder/conversational hooks (open with a builder perspective or personal tone)
- Variants 5-6: curiosity-gap hooks (open with a question or teaser)
- Variants 7-8: alpha-leak/contrarian hooks (open with a non-obvious insight or hot take)

Within each pair, vary the TONE:
- One analytical, one conversational (for each hook type pair)

Every variant must:
- Follow the voice rules provided
- Match the account persona
- Connect to today's intelligence data
- Answer \"so what\" for the reader
- Contain no banned AI phrases

VOICE RULES:
$VOICE_RULES

ACCOUNT PERSONA (match this voice exactly):
${ACCOUNT_PERSONA}

COMPLIANCE RULES (mandatory, override everything else):
$COMPLIANCE_RULES

$BANNED_PHRASES

FORMATTING RULES:
- NEVER use em dashes or double hyphens. Use commas, periods, colons, or line breaks instead.
- Every post must answer \"so what\" for the reader.
- No empty hype or vanity metrics without substance.
- Must include specific data, metrics, or actionable insight.
- Do NOT include any disclaimers in the tweet itself (they go in the thread or bio).
- Lead with results and data, not promises.
- Sound like a builder talking to other builders.
- Use Bittensor-native terminology: subnet, alpha token, dTAO, SN106, emissions, metagraph.
- Use DeFi terminology: TVL, bridge volume, liquidity depth.
- Use lending terminology where relevant: collateral, LTV, borrow rate, supply rate, utilization rate.

$PERFORMANCE_CONTEXT

DAILY METRICS DATA:
$METRICS_DATA

OUTPUT FORMAT:
Return ONLY valid JSON, nothing else. No markdown code fences. No explanation.
{
  \"variants\": [
    {
      \"id\": \"v1\",
      \"content\": \"<the full tweet text, max 280 chars>\",
      \"hook_type\": \"data-lead\",
      \"tone\": \"analytical\",
      \"format\": \"single-stat-opener\",
      \"content_type\": \"tweet\",
      \"account\": \"${ACCOUNT}\",
      \"pillar\": \"bridge-build\",
      \"topic\": \"<topic from input data>\",
      \"word_count\": <number>
    },
    ...
  ]
}

Generate all $VARIANTS variants now."

else
  # --- Single-variant prompt (original) ---
  PROMPT="You are generating a single tweet for the ${ACCOUNT_NAME} X account.
VoidAI is Bittensor DeFi Infrastructure (bridge + staking + lending). The lending platform is the current primary focus.
VoidAI operates 4 X accounts (1 main + 3 satellites: Daily/Informational, Bittensor Ecosystem, DeFi/Cross-Chain).

TASK: Generate exactly ONE tweet (max 280 characters) based on the daily metrics data below.

VOICE RULES:
$VOICE_RULES

ACCOUNT PERSONA (match this voice exactly):
${ACCOUNT_PERSONA}

COMPLIANCE RULES (mandatory, override everything else):
$COMPLIANCE_RULES

$BANNED_PHRASES

FORMATTING RULES:
- NEVER use em dashes or double hyphens. Use commas, periods, colons, or line breaks instead.
- Every post must answer \"so what\" for the reader.
- No empty hype or vanity metrics without substance.
- Must include specific data, metrics, or actionable insight.
- Do NOT include any disclaimers in the tweet itself (they go in the thread or bio).
- Lead with results and data, not promises.
- Sound like a builder talking to other builders.
- Use Bittensor-native terminology: subnet, alpha token, dTAO, SN106, emissions, metagraph.
- Use DeFi terminology: TVL, bridge volume, liquidity depth.
- Use lending terminology where relevant: collateral, LTV, borrow rate, supply rate, utilization rate.

$PERFORMANCE_CONTEXT

DAILY METRICS DATA:
$METRICS_DATA

OUTPUT FORMAT:
Return ONLY valid JSON, nothing else. No markdown code fences. No explanation.
{
  \"tweet\": \"<the tweet text, max 280 chars>\"
}

Generate the tweet now."
fi

log "Calling claude -p to generate tweet (variants=$VARIANTS)..."

# Run claude from the project root so CLAUDE.md is loaded
CLAUDE_OUTPUT=$(cd "$PROJECT_ROOT" && echo "$PROMPT" | "$CLAUDE_BIN" -p 2>/dev/null) || {
  log "ERROR: claude -p failed"
  exit 1
}

if [[ "$VARIANTS" -gt 1 ]]; then
  # --- Multi-variant JSON extraction ---
  # Extract everything between the first { and last } to handle nested JSON
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

  # Validate the variants array exists
  VARIANT_COUNT=$(echo "$CLEAN_OUTPUT" | jq '.variants | length')
  if [[ "$VARIANT_COUNT" -lt 1 ]]; then
    log "ERROR: No variants array in output"
    exit 1
  fi

  log "Extracted $VARIANT_COUNT variants from claude output"

  # Validate each variant's content for banned phrases and length
  FLAGGED=0
  for i in $(seq 0 $((VARIANT_COUNT - 1))); do
    VARIANT_CONTENT=$(echo "$CLEAN_OUTPUT" | jq -r ".variants[$i].content // empty")
    V_LEN=${#VARIANT_CONTENT}
    V_ID=$(echo "$CLEAN_OUTPUT" | jq -r ".variants[$i].id // \"v$((i+1))\"")

    if [[ $V_LEN -gt 280 ]]; then
      log "WARNING: Variant $V_ID is $V_LEN chars (over 280 limit)"
      FLAGGED=$((FLAGGED + 1))
    fi

    VARIANT_LOWER=$(echo "$VARIANT_CONTENT" | tr '[:upper:]' '[:lower:]')
    for phrase in \
      "it's worth noting" \
      "in the ever-evolving landscape" \
      "at its core" \
      "this is a game-changer" \
      "this underscores the importance" \
      "without further ado" \
      "in today's rapidly changing" \
      "revolutionizing the way" \
      "paving the way" \
      "paradigm shift" \
      "synergy" "synergies" \
      "holistic approach" \
      "cutting-edge" \
      "seamless integration" \
      "robust ecosystem" \
      "it is important to note" \
      "in conclusion" \
      "as we navigate"; do
      if echo "$VARIANT_LOWER" | grep -qi "$phrase"; then
        log "BANNED PHRASE in variant $V_ID: \"$phrase\""
        FLAGGED=$((FLAGGED + 1))
      fi
    done

    if echo "$VARIANT_CONTENT" | grep -qP '\x{2014}|\x{2013}' 2>/dev/null || echo "$VARIANT_CONTENT" | grep -q '\-\-'; then
      log "BANNED FORMAT in variant $V_ID: em dash or double hyphen"
      FLAGGED=$((FLAGGED + 1))
    fi
  done

  STATUS="pending_review"
  if [[ $FLAGGED -gt 0 ]]; then
    STATUS="flagged_banned_phrase"
    log "Variants flagged with $FLAGGED issues. Requires review."
  fi

  TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

  # Output the variants JSON with metadata
  echo "$CLEAN_OUTPUT" | jq \
    --arg status "$STATUS" \
    --arg ts "$TIMESTAMP" \
    '. + { "status": $status, "created_at": $ts }'

  log "Multi-variant generation complete ($VARIANT_COUNT variants, status: $STATUS)"

else
  # --- Single-variant JSON extraction (original) ---
  # Extract JSON from claude output (handle possible markdown fences)
  CLEAN_OUTPUT=$(echo "$CLAUDE_OUTPUT" | sed 's/^```json//; s/^```//; s/```$//' | tr -d '\n' | grep -oE '\{[^}]+\}' | head -1)

  if [[ -z "$CLEAN_OUTPUT" ]]; then
    log "ERROR: Could not extract valid JSON from claude output"
    log "Raw output: $CLAUDE_OUTPUT"
    exit 1
  fi

  # Validate the extracted JSON
  if ! echo "$CLEAN_OUTPUT" | jq empty 2>/dev/null; then
    log "ERROR: Extracted output is not valid JSON"
    log "Extracted: $CLEAN_OUTPUT"
    exit 1
  fi

  TWEET_TEXT=$(echo "$CLEAN_OUTPUT" | jq -r '.tweet // empty')

  if [[ -z "$TWEET_TEXT" ]]; then
    log "ERROR: No tweet field in output"
    exit 1
  fi

  # Validate tweet length
  TWEET_LEN=${#TWEET_TEXT}
  if [[ $TWEET_LEN -gt 280 ]]; then
    log "WARNING: Tweet is $TWEET_LEN chars (over 280 limit)"
  fi

  # Check for banned phrases (case-insensitive)
  TWEET_LOWER=$(echo "$TWEET_TEXT" | tr '[:upper:]' '[:lower:]')
  BANNED_CHECK_FAILED=false

  for phrase in \
    "it's worth noting" \
    "in the ever-evolving landscape" \
    "at its core" \
    "this is a game-changer" \
    "this underscores the importance" \
    "without further ado" \
    "in today's rapidly changing" \
    "revolutionizing the way" \
    "paving the way" \
    "paradigm shift" \
    "synergy" "synergies" \
    "holistic approach" \
    "cutting-edge" \
    "seamless integration" \
    "robust ecosystem" \
    "it is important to note" \
    "in conclusion" \
    "as we navigate"; do
    if echo "$TWEET_LOWER" | grep -qi "$phrase"; then
      log "BANNED PHRASE DETECTED: \"$phrase\" found in tweet"
      BANNED_CHECK_FAILED=true
    fi
  done

  # Check for em dashes and double hyphens
  if echo "$TWEET_TEXT" | grep -qP '\x{2014}|\x{2013}' 2>/dev/null || echo "$TWEET_TEXT" | grep -q '\-\-'; then
    log "BANNED FORMAT DETECTED: em dash or double hyphen found in tweet"
    BANNED_CHECK_FAILED=true
  fi

  STATUS="pending_review"
  if [[ "$BANNED_CHECK_FAILED" == "true" ]]; then
    STATUS="flagged_banned_phrase"
    log "Tweet flagged for banned phrase. Requires regeneration."
  fi

  TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

  # Output structured JSON
  jq -n \
    --arg tweet "$TWEET_TEXT" \
    --arg status "$STATUS" \
    --arg ts "$TIMESTAMP" \
    --arg account "$ACCOUNT" \
    --argjson len "$TWEET_LEN" \
    '{
      "tweet": $tweet,
      "platform": "x",
      "account": $account,
      "pillar": "bridge-build",
      "content_type": "single",
      "status": $status,
      "char_count": $len,
      "created_at": $ts
    }'

  log "Tweet generated successfully (status: $STATUS, length: $TWEET_LEN)"
fi
