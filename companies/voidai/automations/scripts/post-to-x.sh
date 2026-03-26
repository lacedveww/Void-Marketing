#!/usr/bin/env bash
# post-to-x.sh
#
# Posts a tweet or thread to X/Twitter via OpenTweet API.
#
# KEY BEHAVIOR (OpenTweet API):
#   - Creating a post WITHOUT scheduled_date -> always creates a DRAFT (never publishes)
#   - Creating a post WITH scheduled_date -> status "scheduled", OpenTweet publishes at that time
#   - To post "now": set scheduled_date to ~2 minutes from now
#   - share_with_followers and status fields are IGNORED by the API
#
# Usage:
#   Single tweet (posts ~2 min from now):
#     ./post-to-x.sh "Your tweet text here"
#     echo "Your tweet text" | ./post-to-x.sh -
#
#   Thread from JSON file (posts ~2 min from now):
#     ./post-to-x.sh --thread /path/to/thread.json
#
#   Schedule for later:
#     ./post-to-x.sh --schedule "2026-03-20T14:00:00Z" "Your tweet text"
#     ./post-to-x.sh --schedule "2026-03-20T14:00:00Z" --thread /path/to/thread.json
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

# Posting account: currently @flowerncoins (Vew's personal) until @v0idai access granted
# Switch to @v0idai after end-of-month presentation
POSTING_ACCOUNT="${POSTING_ACCOUNT:-flowerncoins}"

log() {
  echo "[post-to-x] $(date '+%Y-%m-%d %H:%M:%S') $*" >&2
}

# Log effective mode on startup for debugging
log "DRY_RUN=$DRY_RUN, posting_account=@$POSTING_ACCOUNT (caller=${_CALLER_DRY_RUN:-<unset>})"

usage() {
  echo "Usage:" >&2
  echo "  $0 \"tweet text\"                                    Post a single tweet (~2 min from now)" >&2
  echo "  $0 -                                                Read tweet text from stdin" >&2
  echo "  $0 --thread file.json                               Post a thread (~2 min from now)" >&2
  echo "  $0 --schedule \"ISO_DATE\" \"tweet text\"               Schedule a tweet" >&2
  echo "  $0 --schedule \"ISO_DATE\" --thread file.json         Schedule a thread" >&2
  exit 1
}

# Compute a scheduled_date 2 minutes from now in ISO 8601 UTC
schedule_now() {
  # Try GNU date first, then fall back to BSD/macOS date, then Python
  if date -u -d "+2 minutes" '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null; then
    return
  fi
  if date -u -v+2M '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null; then
    return
  fi
  python3 -c "from datetime import datetime,timedelta;print((datetime.utcnow()+timedelta(minutes=2)).strftime('%Y-%m-%dT%H:%M:%SZ'))" 2>/dev/null && return
  python -c "from datetime import datetime,timedelta;print((datetime.utcnow()+timedelta(minutes=2)).strftime('%Y-%m-%dT%H:%M:%SZ'))" 2>/dev/null && return
  log "ERROR: Cannot compute date +2 minutes (no compatible date/python found)"
  exit 1
}

# Post via OpenTweet API
# Returns: 0 = scheduled successfully, 1 = error, 2 = dry-run (no API call)
opentweet_post() {
  local body="$1"

  if [[ "$DRY_RUN" == "true" ]]; then
    log "[DRY_RUN] Would POST to ${OPENTWEET_API_BASE}posts"
    log "[DRY_RUN] Body: $body"
    echo '{"success": true, "posts": [{"id": "dry_run_mock", "status": "scheduled"}]}'
    return 2
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
    log "ERROR: API call failed (curl error)"
    return 1
  }

  local http_code
  http_code=$(echo "$response" | tail -1)
  local response_body
  response_body=$(echo "$response" | sed '$d')

  if [[ "$http_code" -ge 200 && "$http_code" -lt 300 ]]; then
    # Validate the response: must have success=true and status="scheduled"
    local api_success
    api_success=$(echo "$response_body" | jq -r '.success // false')
    local post_status
    post_status=$(echo "$response_body" | jq -r '.posts[0].status // "unknown"')
    local post_id
    post_id=$(echo "$response_body" | jq -r '.posts[0].id // .id // empty')
    local post_failed
    post_failed=$(echo "$response_body" | jq -r '.posts[0].failed // false')
    local failed_reason
    failed_reason=$(echo "$response_body" | jq -r '.posts[0].failed_reason // .error // .details // empty')

    if [[ "$post_failed" == "true" || "$post_status" == "failed" ]]; then
      log "ERROR: OpenTweet accepted the request but post FAILED"
      log "ERROR: Post ID: $post_id, Reason: $failed_reason"
      echo "$response_body"
      return 1
    fi

    if [[ "$api_success" != "true" ]]; then
      log "ERROR: API returned success=$api_success (expected true)"
      log "Response: $response_body"
      echo "$response_body"
      return 1
    fi

    if [[ "$post_status" == "draft" ]]; then
      log "ERROR: Post created as DRAFT instead of SCHEDULED - scheduling failed"
      log "ERROR: Post ID: $post_id. This means scheduled_date was missing or invalid."
      log "ERROR: Response: $response_body"
      echo "$response_body"
      return 1
    fi

    if [[ "$post_status" != "scheduled" ]]; then
      log "WARNING: Unexpected post status '$post_status' (expected 'scheduled')"
    fi

    log "Tweet scheduled via OpenTweet (ID: $post_id, status: $post_status)"
    echo "$response_body"
    return 0
  else
    log "ERROR: HTTP $http_code from OpenTweet"
    local error_detail
    error_detail=$(echo "$response_body" | jq -r '.error // .details // .message // empty' 2>/dev/null)
    log "Response: $response_body"
    if [[ -n "$error_detail" ]]; then
      log "Detail: $error_detail"
    fi
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

# Parse all arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --thread)
      MODE="thread"
      if [[ $# -lt 2 ]]; then
        log "ERROR: --thread requires a JSON file path"
        usage
      fi
      THREAD_FILE="$2"
      shift 2
      ;;
    --schedule)
      if [[ $# -lt 2 ]]; then
        log "ERROR: --schedule requires a date"
        usage
      fi
      SCHEDULE_DATE="$2"
      shift 2
      ;;
    -)
      TWEET_TEXT=$(cat)
      shift
      ;;
    --help|-h)
      usage
      ;;
    *)
      TWEET_TEXT="$1"
      shift
      ;;
  esac
done

# Determine the scheduled_date to use
if [[ -z "$SCHEDULE_DATE" ]]; then
  # No explicit schedule -> post "now" by scheduling 2 minutes out
  SCHEDULE_DATE=$(schedule_now)
  log "No --schedule provided; posting ~2 min from now: $SCHEDULE_DATE"
fi

# Execute based on mode
if [[ "$MODE" == "single" ]]; then
  if [[ -z "$TWEET_TEXT" ]]; then
    log "ERROR: Empty tweet text"
    exit 1
  fi

  TWEET_LEN=${#TWEET_TEXT}
  if [[ $TWEET_LEN -gt 280 ]]; then
    log "WARNING: Tweet is $TWEET_LEN characters (over 280 limit)"
  fi

  # Build request body - always include scheduled_date
  BODY=$(jq -n --arg text "$TWEET_TEXT" --arg date "$SCHEDULE_DATE" \
    '{"text": $text, "scheduled_date": $date}')
  log "Scheduling tweet ($TWEET_LEN chars) for $SCHEDULE_DATE..."

  RESULT=$(opentweet_post "$BODY") || POST_EXIT=$?
  POST_EXIT=${POST_EXIT:-0}
  POST_ID=$(echo "$RESULT" | jq -r '.posts[0].id // .id // "none"')

  if [[ "$POST_EXIT" -eq 1 ]]; then
    log "FAILED: Tweet was not scheduled (API error)"
    ACTUAL_STATUS="failed"
  elif [[ "$POST_EXIT" -eq 2 ]]; then
    ACTUAL_STATUS="dry_run"
  else
    ACTUAL_STATUS="scheduled"
  fi

  TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
  jq -n \
    --arg tweet "$TWEET_TEXT" \
    --arg id "$POST_ID" \
    --arg ts "$TIMESTAMP" \
    --arg scheduled_for "$SCHEDULE_DATE" \
    --arg actual_status "$ACTUAL_STATUS" \
    --argjson dry_run "$(if [[ "$DRY_RUN" == "true" ]]; then echo true; else echo false; fi)" \
    '{
      "type": "single",
      "post_id": $id,
      "tweet": $tweet,
      "posted_at": $ts,
      "scheduled_for": $scheduled_for,
      "dry_run": $dry_run,
      "status": $actual_status
    }'

  # Exit with the appropriate code so callers can distinguish outcomes
  exit "$POST_EXIT"

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
  log "Scheduling thread ($TWEET_COUNT tweets) via OpenTweet for $SCHEDULE_DATE..."

  # Extract first tweet text
  FIRST_TWEET=$(echo "$THREAD_DATA" | jq -r '.[0].tweet')

  # Build thread_tweets array for OpenTweet API: [{"text": "tweet 2"}, {"text": "tweet 3"}]
  THREAD_TWEETS=$(echo "$THREAD_DATA" | jq '[.[1:][] | {"text": .tweet}]')

  # Build OpenTweet thread request - always include scheduled_date
  BODY=$(jq -n \
    --arg text "$FIRST_TWEET" \
    --argjson thread_tweets "$THREAD_TWEETS" \
    --arg date "$SCHEDULE_DATE" \
    '{
      "text": $text,
      "is_thread": true,
      "thread_tweets": $thread_tweets,
      "scheduled_date": $date
    }')

  RESULT=$(opentweet_post "$BODY") || POST_EXIT=$?
  POST_EXIT=${POST_EXIT:-0}

  POST_ID=$(echo "$RESULT" | jq -r '.posts[0].id // .id // "none"')
  TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

  if [[ "$POST_EXIT" -eq 1 ]]; then
    log "FAILED: Thread was not scheduled (API error)"
    ACTUAL_STATUS="failed"
  elif [[ "$POST_EXIT" -eq 2 ]]; then
    ACTUAL_STATUS="dry_run"
  else
    ACTUAL_STATUS="scheduled"
  fi

  jq -n \
    --argjson thread "$THREAD_DATA" \
    --arg id "$POST_ID" \
    --arg ts "$TIMESTAMP" \
    --argjson total "$TWEET_COUNT" \
    --arg scheduled_for "$SCHEDULE_DATE" \
    --arg actual_status "$ACTUAL_STATUS" \
    --argjson dry_run "$(if [[ "$DRY_RUN" == "true" ]]; then echo true; else echo false; fi)" \
    '{
      "type": "thread",
      "post_id": $id,
      "tweets": $thread,
      "total_tweets": $total,
      "posted_at": $ts,
      "scheduled_for": $scheduled_for,
      "dry_run": $dry_run,
      "status": $actual_status
    }'

  log "Thread scheduling complete via OpenTweet (status: $ACTUAL_STATUS)"

  # Exit with the appropriate code so callers can distinguish outcomes
  exit "$POST_EXIT"
fi
