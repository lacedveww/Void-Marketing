#!/usr/bin/env bash
# post-to-x.sh
#
# Posts a tweet or thread to X/Twitter via OpenTweet API.
#
# Usage:
#   Single tweet:
#     ./post-to-x.sh "Your tweet text here"
#     echo "Your tweet text" | ./post-to-x.sh -
#
#   Thread from JSON file:
#     ./post-to-x.sh --thread /path/to/thread.json
#
#   Schedule for later:
#     ./post-to-x.sh --schedule "2026-03-20T14:00:00Z" "Your tweet text"
#
#   Thread JSON format (array of tweet objects):
#     [{"position": 1, "tweet": "First tweet"}, {"position": 2, "tweet": "Reply"}]
#
#   DRY_RUN mode:
#     DRY_RUN=true ./post-to-x.sh "Test tweet"
#
# Environment:
#   OPENTWEET_API_KEY    OpenTweet API key (required)
#   OPENTWEET_API_BASE   Base URL (default: https://opentweet.io/api/v1/)
#   DRY_RUN              If "true", logs what would be posted without calling the API
#   HTTP_TIMEOUT         Curl timeout in seconds (default: 30)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

# Preserve caller's DRY_RUN before sourcing .env
_CALLER_DRY_RUN="${DRY_RUN:-}"
# Source .env if present
if [[ -f "$PROJECT_ROOT/.env" ]]; then
  set -a
  # shellcheck source=/dev/null
  source "$PROJECT_ROOT/.env"
  set +a
fi

# Caller's explicit DRY_RUN takes precedence over .env
DRY_RUN="${_CALLER_DRY_RUN:-${DRY_RUN:-true}}"
OPENTWEET_API_BASE="${OPENTWEET_API_BASE:-https://opentweet.io/api/v1/}"
HTTP_TIMEOUT="${HTTP_TIMEOUT:-30}"

log() {
  echo "[post-to-x] $(date '+%Y-%m-%d %H:%M:%S') $*" >&2
}

usage() {
  echo "Usage:" >&2
  echo "  $0 \"tweet text\"                        Post a single tweet" >&2
  echo "  $0 -                                    Read tweet text from stdin" >&2
  echo "  $0 --thread file.json                   Post a thread from JSON array" >&2
  echo "  $0 --schedule \"ISO_DATE\" \"tweet text\"   Schedule a tweet" >&2
  exit 1
}

# Post via OpenTweet API
opentweet_post() {
  local body="$1"

  if [[ "$DRY_RUN" == "true" ]]; then
    log "[DRY_RUN] Would POST to ${OPENTWEET_API_BASE}posts"
    log "[DRY_RUN] Body: $body"
    echo '{"id": "dry_run_mock", "status": "dry_run"}'
    return 0
  fi

  if [[ -z "${OPENTWEET_API_KEY:-}" ]]; then
    log "ERROR: OPENTWEET_API_KEY not set"
    return 1
  fi

  local response
  response=$(curl -s --max-time "$HTTP_TIMEOUT" \
    -X POST "${OPENTWEET_API_BASE}posts" \
    -H "Authorization: Bearer ${OPENTWEET_API_KEY}" \
    -H "Content-Type: application/json" \
    -d "$body" \
    -w "\n%{http_code}" 2>/dev/null) || {
    log "ERROR: API call failed"
    return 1
  }

  local http_code
  http_code=$(echo "$response" | tail -1)
  local response_body
  response_body=$(echo "$response" | sed '$d')

  if [[ "$http_code" -ge 200 && "$http_code" -lt 300 ]]; then
    local post_id
    post_id=$(echo "$response_body" | jq -r '.posts[0].id // .id // empty')
    log "Tweet posted via OpenTweet (ID: $post_id, status: $(echo "$response_body" | jq -r '.posts[0].status // .status // "unknown"'))"
    echo "$response_body"
    return 0
  else
    log "ERROR: HTTP $http_code from OpenTweet"
    log "Response: $response_body"
    echo "$response_body"
    return 1
  fi
}

# Parse arguments
MODE="single"
TWEET_TEXT=""
THREAD_FILE=""
SCHEDULE_DATE=""

if [[ $# -lt 1 ]]; then
  usage
fi

case "$1" in
  --thread)
    MODE="thread"
    if [[ $# -lt 2 ]]; then
      log "ERROR: --thread requires a JSON file path"
      usage
    fi
    THREAD_FILE="$2"
    ;;
  --schedule)
    MODE="scheduled"
    if [[ $# -lt 3 ]]; then
      log "ERROR: --schedule requires a date and tweet text"
      usage
    fi
    SCHEDULE_DATE="$2"
    TWEET_TEXT="$3"
    ;;
  -)
    MODE="single"
    TWEET_TEXT=$(cat)
    ;;
  --help|-h)
    usage
    ;;
  *)
    MODE="single"
    TWEET_TEXT="$1"
    ;;
esac

# Execute based on mode
if [[ "$MODE" == "single" || "$MODE" == "scheduled" ]]; then
  if [[ -z "$TWEET_TEXT" ]]; then
    log "ERROR: Empty tweet text"
    exit 1
  fi

  TWEET_LEN=${#TWEET_TEXT}
  if [[ $TWEET_LEN -gt 280 ]]; then
    log "WARNING: Tweet is $TWEET_LEN characters (over 280 limit)"
  fi

  # Build request body
  if [[ "$MODE" == "scheduled" ]]; then
    BODY=$(jq -n --arg text "$TWEET_TEXT" --arg date "$SCHEDULE_DATE" \
      '{"text": $text, "scheduled_date": $date}')
    log "Scheduling tweet ($TWEET_LEN chars) for $SCHEDULE_DATE..."
  else
    BODY=$(jq -n --arg text "$TWEET_TEXT" '{"text": $text, "publish_now": true}')
    log "Posting tweet ($TWEET_LEN chars)..."
  fi

  RESULT=$(opentweet_post "$BODY")
  POST_ID=$(echo "$RESULT" | jq -r '.posts[0].id // .id // "none"')

  TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
  jq -n \
    --arg tweet "$TWEET_TEXT" \
    --arg id "$POST_ID" \
    --arg ts "$TIMESTAMP" \
    --arg mode "$MODE" \
    --argjson dry_run "$(if [[ "$DRY_RUN" == "true" ]]; then echo true; else echo false; fi)" \
    '{
      "type": $mode,
      "post_id": $id,
      "tweet": $tweet,
      "posted_at": $ts,
      "dry_run": $dry_run,
      "status": (if $dry_run then "dry_run" else "posted" end)
    }'

elif [[ "$MODE" == "thread" ]]; then
  if [[ ! -f "$THREAD_FILE" ]]; then
    log "ERROR: Thread file not found: $THREAD_FILE"
    exit 1
  fi

  if ! jq empty "$THREAD_FILE" 2>/dev/null; then
    log "ERROR: Invalid JSON in thread file"
    exit 1
  fi

  # Support both raw array and wrapped format (with .thread key)
  THREAD_DATA=$(jq 'if type == "array" then . else (.thread // .) end' "$THREAD_FILE")

  if ! echo "$THREAD_DATA" | jq -e 'type == "array"' >/dev/null 2>&1; then
    log "ERROR: Thread data must be a JSON array"
    exit 1
  fi

  TWEET_COUNT=$(echo "$THREAD_DATA" | jq 'length')
  log "Posting thread ($TWEET_COUNT tweets) via OpenTweet..."

  # Extract tweet texts into thread_tweets array for OpenTweet API
  FIRST_TWEET=$(echo "$THREAD_DATA" | jq -r '.[0].tweet')
  THREAD_TWEETS=$(echo "$THREAD_DATA" | jq '[.[1:][].tweet]')

  # Build OpenTweet thread request
  BODY=$(jq -n \
    --arg text "$FIRST_TWEET" \
    --argjson thread_tweets "$THREAD_TWEETS" \
    '{
      "text": $text,
      "is_thread": true,
      "thread_tweets": $thread_tweets,
      "publish_now": true
    }')

  if [[ "$DRY_RUN" == "true" ]]; then
    log "[DRY_RUN] Would post thread with $TWEET_COUNT tweets"
    RESULT='{"id": "dry_run_mock", "status": "dry_run"}'
  else
    RESULT=$(opentweet_post "$BODY")
  fi

  POST_ID=$(echo "$RESULT" | jq -r '.posts[0].id // .id // "none"')
  TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

  jq -n \
    --argjson thread "$THREAD_DATA" \
    --arg id "$POST_ID" \
    --arg ts "$TIMESTAMP" \
    --argjson total "$TWEET_COUNT" \
    --argjson dry_run "$(if [[ "$DRY_RUN" == "true" ]]; then echo true; else echo false; fi)" \
    '{
      "type": "thread",
      "post_id": $id,
      "tweets": $thread,
      "total_tweets": $total,
      "posted_at": $ts,
      "dry_run": $dry_run,
      "status": (if $dry_run then "dry_run" else "posted" end)
    }'

  log "Thread posting complete via OpenTweet"
fi
