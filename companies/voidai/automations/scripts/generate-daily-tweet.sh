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
  echo "Usage: $0 <metrics-json-file>" >&2
  exit 1
}

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
  jq -n \
    --arg ts "$TIMESTAMP" \
    --arg metrics "$METRICS_DATA" \
    '{
      "tweet": "[DRY_RUN] Would generate tweet from metrics data",
      "platform": "x",
      "account": "v0idai",
      "pillar": "bridge-build",
      "status": "dry_run",
      "created_at": $ts,
      "metrics_input": ($metrics | fromjson)
    }'
  exit 0
fi

# Build the prompt for claude -p
PROMPT=$(cat <<'PROMPT_HEADER'
You are generating a single tweet for the @v0idai X account (VoidAI main account).

TASK: Generate exactly ONE tweet (max 280 characters) based on the daily metrics data below.

VOICE RULES:
PROMPT_HEADER
)

PROMPT="$PROMPT

$VOICE_RULES

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

DAILY METRICS DATA:
$METRICS_DATA

OUTPUT FORMAT:
Return ONLY valid JSON, nothing else. No markdown code fences. No explanation.
{
  \"tweet\": \"<the tweet text, max 280 chars>\"
}

Generate the tweet now."

log "Calling claude -p to generate tweet..."

# Run claude from the project root so CLAUDE.md is loaded
CLAUDE_OUTPUT=$(cd "$PROJECT_ROOT" && echo "$PROMPT" | "$CLAUDE_BIN" -p 2>/dev/null) || {
  log "ERROR: claude -p failed"
  exit 1
}

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
  --argjson len "$TWEET_LEN" \
  '{
    "tweet": $tweet,
    "platform": "x",
    "account": "v0idai",
    "pillar": "bridge-build",
    "content_type": "single",
    "status": $status,
    "char_count": $len,
    "created_at": $ts
  }'

log "Tweet generated successfully (status: $STATUS, length: $TWEET_LEN)"
