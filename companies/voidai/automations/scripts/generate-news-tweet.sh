#!/usr/bin/env bash
# generate-news-tweet.sh
#
# Generates a tweet about a single news item using claude -p.
# Designed for the news monitoring pipeline (WF4 in the architecture).
#
# Usage:
#   ./generate-news-tweet.sh /path/to/news-item.json
#   echo '{"title":"...","summary":"...","source":"...","url":"..."}' | ./generate-news-tweet.sh -
#   DRY_RUN=true ./generate-news-tweet.sh /path/to/news-item.json
#
# Input JSON format:
#   {
#     "title": "Bittensor Surpasses 100 Active Subnets",
#     "summary": "The Bittensor network now has over 100 active subnets...",
#     "source": "CoinDesk",
#     "url": "https://coindesk.com/...",
#     "published_at": "2026-03-15T10:00:00Z"
#   }
#
# Output: JSON to stdout:
#   { "tweet": "...", "platform": "x", "account": "v0idai", "status": "pending_review",
#     "news_source": "...", "news_title": "..." }
#
# Environment:
#   DRY_RUN       If "true", skips the claude call.
#   CLAUDE_PATH   Optional path to claude binary (default: claude)

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
  echo "[generate-news-tweet] $(date '+%Y-%m-%d %H:%M:%S') $*" >&2
}

usage() {
  echo "Usage: $0 <news-item-json-file | ->" >&2
  echo "  Use - to read from stdin" >&2
  exit 1
}

if [[ $# -lt 1 ]]; then
  usage
fi

# Read input from file or stdin
if [[ "$1" == "-" ]]; then
  NEWS_DATA=$(cat)
else
  if [[ ! -f "$1" ]]; then
    log "ERROR: News file not found: $1"
    exit 1
  fi
  NEWS_DATA=$(cat "$1")
fi

# Validate JSON
if ! echo "$NEWS_DATA" | jq empty 2>/dev/null; then
  log "ERROR: Invalid JSON input"
  exit 1
fi

# Extract fields for validation
NEWS_TITLE=$(echo "$NEWS_DATA" | jq -r '.title // empty')
NEWS_SUMMARY=$(echo "$NEWS_DATA" | jq -r '.summary // empty')
NEWS_SOURCE=$(echo "$NEWS_DATA" | jq -r '.source // empty')
NEWS_URL=$(echo "$NEWS_DATA" | jq -r '.url // empty')

if [[ -z "$NEWS_TITLE" ]]; then
  log "ERROR: News item missing 'title' field"
  exit 1
fi

if [[ -z "$NEWS_SUMMARY" ]]; then
  log "ERROR: News item missing 'summary' field"
  exit 1
fi

log "Processing news: \"$NEWS_TITLE\" from $NEWS_SOURCE"

# Load performance summary (feedback loop)
PERFORMANCE_SUMMARY_FILE="$PROJECT_ROOT/companies/voidai/automations/data/performance-summary.json"
PERFORMANCE_CONTEXT=""
if [[ -f "$PERFORMANCE_SUMMARY_FILE" ]]; then
  PERF_DATA=$(cat "$PERFORMANCE_SUMMARY_FILE")
  PERFORMANCE_CONTEXT="
PERFORMANCE FEEDBACK (guide hook and framing choices):
Recent avg engagement: $(echo "$PERF_DATA" | jq -r '.avg_engagement_rate_pct // "unknown"')%
$(echo "$PERF_DATA" | jq -r '.recommendations // [] | .[:2][] // empty' 2>/dev/null || echo "")
"
  log "Loaded performance feedback for news tweet"
fi

# Load voice and compliance
VOICE_FILE="$COMPANY_DIR/voice.md"
COMPLIANCE_FILE="$COMPANY_DIR/compliance.md"

for required_file in "$VOICE_FILE" "$COMPLIANCE_FILE"; do
  if [[ ! -f "$required_file" ]]; then
    log "ERROR: Required file not found: $required_file"
    exit 1
  fi
done

VOICE_RULES=$(cat "$VOICE_FILE")
COMPLIANCE_RULES=$(cat "$COMPLIANCE_FILE")

# DRY_RUN mode
if [[ "$DRY_RUN" == "true" ]]; then
  log "DRY_RUN is true. Outputting placeholder."
  TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
  jq -n \
    --arg title "$NEWS_TITLE" \
    --arg source "$NEWS_SOURCE" \
    --arg ts "$TIMESTAMP" \
    '{
      "tweet": "[DRY_RUN] Would generate news commentary tweet",
      "platform": "x",
      "account": "v0idai",
      "pillar": "ecosystem-intelligence",
      "content_type": "single",
      "status": "dry_run",
      "news_title": $title,
      "news_source": $source,
      "created_at": $ts
    }'
  exit 0
fi

# Sanitize user content for prompt injection protection.
# Strip instruction-like patterns, remove URLs, truncate.
SAFE_TITLE=$(echo "$NEWS_TITLE" | sed -E 's/(ignore previous|system prompt|act as|forget|override)//gi' | head -c 200)
SAFE_SUMMARY=$(echo "$NEWS_SUMMARY" | sed -E 's/(ignore previous|system prompt|act as|forget|override)//gi' | sed 's|https\?://[^ ]*||g' | head -c 500)

# Build the prompt
PROMPT="You are generating a single tweet for the @v0idai X account about a news item.

TASK: Generate ONE tweet (max 280 characters) that adds genuine commentary or insight
about this news from VoidAI's perspective as Bittensor DeFi infrastructure builders.

Do NOT just summarize the headline. Add value: connect it to VoidAI's ecosystem,
explain why it matters for TAO holders or subnet builders, or share a unique take.

VOICE RULES:
$VOICE_RULES

COMPLIANCE RULES (mandatory):
$COMPLIANCE_RULES

BANNED PHRASES (any = auto-fail):
\"It's worth noting\", \"In the ever-evolving landscape of\", \"At its core\",
\"This is a game-changer\", \"This underscores the importance of\", \"Without further ado\",
\"In today's rapidly changing\", \"Revolutionizing the way\", \"Paving the way for\",
\"Paradigm shift\", \"Synergy/synergies\", \"Holistic approach\", \"Cutting-edge\",
\"Seamless integration\", \"Robust ecosystem\", \"It is important to note that\",
\"In conclusion\", \"As we navigate\"

FORMATTING RULES:
- NEVER use em dashes or double hyphens. Use commas, periods, colons, or line breaks.
- Max 280 characters.
- Must add genuine insight, not just \"interesting!\" or a headline repost.
- Sound like a builder talking to other builders.
- Do NOT include the news URL in the tweet (it will be added separately as a quote tweet or link).
- Do NOT include disclaimers in the tweet body.

$PERFORMANCE_CONTEXT

NEWS ITEM:
<user_content>
Title: $SAFE_TITLE
Summary: $SAFE_SUMMARY
Source: $NEWS_SOURCE
</user_content>

OUTPUT FORMAT:
Return ONLY valid JSON, no markdown fences, no explanation:
{\"tweet\": \"<the tweet text>\"}

Generate the tweet now."

log "Calling claude -p to generate news tweet..."

CLAUDE_OUTPUT=$(cd "$PROJECT_ROOT" && echo "$PROMPT" | "$CLAUDE_BIN" -p 2>/dev/null) || {
  log "ERROR: claude -p failed"
  exit 1
}

# Extract JSON from output
CLEAN_OUTPUT=$(echo "$CLAUDE_OUTPUT" | sed 's/^```json//; s/^```//; s/```$//' | tr -d '\n' | grep -oE '\{[^}]+\}' | head -1)

if [[ -z "$CLEAN_OUTPUT" ]]; then
  log "ERROR: Could not extract valid JSON from claude output"
  log "Raw output: $CLAUDE_OUTPUT"
  exit 1
fi

if ! echo "$CLEAN_OUTPUT" | jq empty 2>/dev/null; then
  log "ERROR: Extracted output is not valid JSON"
  exit 1
fi

TWEET_TEXT=$(echo "$CLEAN_OUTPUT" | jq -r '.tweet // empty')

if [[ -z "$TWEET_TEXT" ]]; then
  log "ERROR: No tweet field in output"
  exit 1
fi

TWEET_LEN=${#TWEET_TEXT}
if [[ $TWEET_LEN -gt 280 ]]; then
  log "WARNING: Tweet is $TWEET_LEN chars (over 280 limit)"
fi

# Check for double hyphens
STATUS="pending_review"
if echo "$TWEET_TEXT" | grep -q '\-\-'; then
  STATUS="flagged_format"
  log "Tweet flagged: contains double hyphens"
fi

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

jq -n \
  --arg tweet "$TWEET_TEXT" \
  --arg status "$STATUS" \
  --arg ts "$TIMESTAMP" \
  --arg title "$NEWS_TITLE" \
  --arg source "$NEWS_SOURCE" \
  --arg url "$NEWS_URL" \
  --argjson len "$TWEET_LEN" \
  '{
    "tweet": $tweet,
    "platform": "x",
    "account": "v0idai",
    "pillar": "ecosystem-intelligence",
    "content_type": "single",
    "status": $status,
    "char_count": $len,
    "news_title": $title,
    "news_source": $source,
    "news_url": $url,
    "created_at": $ts
  }'

log "News tweet generated successfully (status: $STATUS, length: $TWEET_LEN)"
