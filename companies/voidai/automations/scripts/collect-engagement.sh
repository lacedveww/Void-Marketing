#!/usr/bin/env bash
# collect-engagement.sh
#
# Collects engagement data (likes, retweets, replies, bookmarks, views) for
# recently posted tweets. This is the FEEDBACK LOOP script that closes the gap
# between "post content" and "learn from performance."
#
# Inspired by the Larry/OpenClaw playbook: generate -> post -> track -> learn -> generate better.
#
# Usage:
#   ./collect-engagement.sh                   # Collect for posts from last 7 days
#   ./collect-engagement.sh --days 3          # Collect for posts from last 3 days
#   ./collect-engagement.sh --post-id 12345   # Collect for a specific post
#   DRY_RUN=true ./collect-engagement.sh      # Use mock data
#
# Output files:
#   data/engagement-YYYY-MM-DD.json           # Raw engagement data
#   data/top-performers.json                  # Rolling top performers (updated each run)
#   data/performance-summary.json             # Aggregated performance summary for prompt injection
#
# The performance-summary.json file is designed to be injected into content generation
# prompts so the AI learns from what actually worked.
#
# Environment:
#   OPENTWEET_API_KEY    OpenTweet API key (for fetching post analytics)
#   OPENTWEET_API_BASE   Base URL (default: https://opentweet.io/api/v1/)
#   X_BEARER_TOKEN       X API bearer token (alternative to OpenTweet for analytics)
#   DRY_RUN              If "true", uses mock engagement data
#   HTTP_TIMEOUT         Curl timeout in seconds (default: 30)
#   LOOKBACK_DAYS        Days to look back for posts (default: 7)
#   TOP_N                Number of top performers to track (default: 10)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
DATA_DIR="$PROJECT_ROOT/companies/voidai/automations/data"
QUEUE_DIR="$PROJECT_ROOT/companies/voidai/queue"
VOICE_LEARNINGS="$PROJECT_ROOT/companies/voidai/brand/voice-learnings.md"

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
HTTP_TIMEOUT="${HTTP_TIMEOUT:-30}"
OPENTWEET_API_BASE="${OPENTWEET_API_BASE:-https://opentweet.io/api/v1/}"
LOOKBACK_DAYS="${LOOKBACK_DAYS:-7}"
TOP_N="${TOP_N:-10}"

TODAY=$(date '+%Y-%m-%d')
ENGAGEMENT_FILE="$DATA_DIR/engagement-${TODAY}.json"
TOP_PERFORMERS_FILE="$DATA_DIR/top-performers.json"
PERFORMANCE_SUMMARY_FILE="$DATA_DIR/performance-summary.json"

log() {
  echo "[collect-engagement] $(date '+%Y-%m-%d %H:%M:%S') $*" >&2
}

# Check dependencies
for cmd in jq curl; do
  command -v "$cmd" >/dev/null 2>&1 || { log "ERROR: $cmd is required but not installed"; exit 1; }
done

mkdir -p "$DATA_DIR"

# Parse arguments
SPECIFIC_POST_ID=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --days)
      LOOKBACK_DAYS="$2"
      shift 2
      ;;
    --post-id)
      SPECIFIC_POST_ID="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

# Helper: fetch URL with error handling
fetch() {
  local url="$1"
  local description="$2"
  local auth_header="${3:-}"

  log "Fetching $description..."

  local curl_args=(-s -f --max-time "$HTTP_TIMEOUT" -H "Accept: application/json")
  if [[ -n "$auth_header" ]]; then
    curl_args+=(-H "$auth_header")
  fi

  local response
  response=$(curl "${curl_args[@]}" -w "\n%{http_code}" "$url" 2>/dev/null) || {
    log "ERROR: Failed to fetch $description from $url"
    echo "{}"
    return 1
  }

  local http_code
  http_code=$(echo "$response" | tail -1)
  local body
  body=$(echo "$response" | sed '$d')

  if [[ "$http_code" -ge 200 && "$http_code" -lt 300 ]]; then
    if echo "$body" | jq empty 2>/dev/null; then
      echo "$body"
      return 0
    else
      log "ERROR: Invalid JSON response from $description"
      echo "{}"
      return 1
    fi
  else
    log "ERROR: HTTP $http_code from $description"
    echo "{}"
    return 1
  fi
}

# Scan the queue/posted/ directory to find recently posted items
scan_posted_queue() {
  local cutoff_date
  cutoff_date=$(date -d "$LOOKBACK_DAYS days ago" '+%Y-%m-%d' 2>/dev/null || date -v-${LOOKBACK_DAYS}d '+%Y-%m-%d' 2>/dev/null || echo "2026-01-01")

  local posted_dir="$QUEUE_DIR/posted"
  local items="[]"

  if [[ ! -d "$posted_dir" ]]; then
    log "No posted/ directory found at $posted_dir"
    echo "[]"
    return 0
  fi

  for file in "$posted_dir"/*.md "$posted_dir"/*.yaml "$posted_dir"/*.yml; do
    [[ -f "$file" ]] || continue

    # Extract YAML frontmatter fields
    local post_id posted_at pillar content_type account platform
    post_id=$(sed -n 's/^id: *//p' "$file" | head -1 | tr -d '"' || echo "")
    posted_at=$(sed -n 's/^posted_at: *//p' "$file" | head -1 | tr -d '"' || echo "")
    pillar=$(sed -n 's/^pillar: *//p' "$file" | head -1 | tr -d '"' || echo "unknown")
    content_type=$(sed -n 's/^content_type: *//p' "$file" | head -1 | tr -d '"' || echo "single")
    account=$(sed -n 's/^account: *//p' "$file" | head -1 | tr -d '"' || echo "v0idai")
    platform=$(sed -n 's/^platform: *//p' "$file" | head -1 | tr -d '"' || echo "x")

    # Extract the content body (everything after the second ---)
    local content
    content=$(awk '/^---$/{c++;next}c>=2' "$file" | head -5 | tr '\n' ' ' | head -c 300 || echo "")

    if [[ -n "$post_id" ]]; then
      items=$(echo "$items" | jq \
        --arg id "$post_id" \
        --arg posted "$posted_at" \
        --arg pillar "$pillar" \
        --arg type "$content_type" \
        --arg account "$account" \
        --arg platform "$platform" \
        --arg content "$content" \
        '. + [{
          "post_id": $id,
          "posted_at": $posted,
          "pillar": $pillar,
          "content_type": $type,
          "account": $account,
          "platform": $platform,
          "content_preview": $content
        }]')
    fi
  done

  echo "$items"
}

# DRY_RUN mode: generate realistic mock engagement data
if [[ "$DRY_RUN" == "true" ]]; then
  log "DRY_RUN is true. Using mock engagement data."

  TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

  MOCK_ENGAGEMENT=$(jq -n \
    --arg date "$TODAY" \
    --arg ts "$TIMESTAMP" \
    --argjson lookback "$LOOKBACK_DAYS" \
    '{
      "collected_at": $ts,
      "date": $date,
      "dry_run": true,
      "lookback_days": $lookback,
      "posts": [
        {
          "post_id": "mock-metrics-001",
          "posted_at": "2026-03-20T14:00:00Z",
          "account": "v0idai",
          "pillar": "bridge-build",
          "content_type": "single",
          "content_preview": "TAO at $425. SN106 emissions holding steady at 12.5 TAO/day. 42 bridge transactions in 24h.",
          "engagement": {
            "likes": 47,
            "retweets": 12,
            "replies": 8,
            "bookmarks": 15,
            "views": 3200,
            "quotes": 3
          },
          "engagement_rate_pct": 2.66,
          "hook_type": "data-lead",
          "format": "metrics-update"
        },
        {
          "post_id": "mock-thread-002",
          "posted_at": "2026-03-19T14:00:00Z",
          "account": "v0idai",
          "pillar": "ecosystem-intelligence",
          "content_type": "thread",
          "content_preview": "SN106 just crossed 50 validators. Here is what that means for TAO liquidity.",
          "engagement": {
            "likes": 89,
            "retweets": 34,
            "replies": 22,
            "bookmarks": 41,
            "views": 8500,
            "quotes": 7
          },
          "engagement_rate_pct": 2.27,
          "hook_type": "milestone",
          "format": "thread"
        },
        {
          "post_id": "mock-news-003",
          "posted_at": "2026-03-18T10:00:00Z",
          "account": "v0idai",
          "pillar": "ecosystem-intelligence",
          "content_type": "single",
          "content_preview": "Bittensor crosses 100 active subnets. SN106 liquidity provisioning has been live since May 2025.",
          "engagement": {
            "likes": 23,
            "retweets": 5,
            "replies": 3,
            "bookmarks": 7,
            "views": 1800,
            "quotes": 1
          },
          "engagement_rate_pct": 2.17,
          "hook_type": "news-commentary",
          "format": "single-news"
        },
        {
          "post_id": "mock-teaser-004",
          "posted_at": "2026-03-17T20:00:00Z",
          "account": "v0idai",
          "pillar": "lending-teaser",
          "content_type": "single",
          "content_preview": "What if you could borrow against your TAO without selling? Something is coming to SN106.",
          "engagement": {
            "likes": 112,
            "retweets": 45,
            "replies": 31,
            "bookmarks": 67,
            "views": 12400,
            "quotes": 11
          },
          "engagement_rate_pct": 2.15,
          "hook_type": "curiosity-gap",
          "format": "teaser"
        },
        {
          "post_id": "mock-defi-005",
          "posted_at": "2026-03-16T14:00:00Z",
          "account": "v0idai",
          "pillar": "bridge-build",
          "content_type": "single",
          "content_preview": "VoidAI bridge now processes $125K daily volume across 4 chains.",
          "engagement": {
            "likes": 31,
            "retweets": 8,
            "replies": 4,
            "bookmarks": 9,
            "views": 2100,
            "quotes": 2
          },
          "engagement_rate_pct": 2.57,
          "hook_type": "data-lead",
          "format": "metrics-update"
        }
      ],
      "summary": {
        "total_posts_analyzed": 5,
        "avg_engagement_rate_pct": 2.36,
        "best_performing_post": "mock-teaser-004",
        "best_engagement_rate": 2.15,
        "best_raw_engagement": 266,
        "worst_performing_post": "mock-news-003",
        "worst_engagement_rate": 2.17,
        "total_likes": 302,
        "total_retweets": 104,
        "total_replies": 68,
        "total_views": 28000,
        "by_pillar": {
          "bridge-build": {"posts": 2, "avg_engagement_rate": 2.62, "total_views": 5300},
          "ecosystem-intelligence": {"posts": 2, "avg_engagement_rate": 2.22, "total_views": 10300},
          "lending-teaser": {"posts": 1, "avg_engagement_rate": 2.15, "total_views": 12400}
        },
        "by_content_type": {
          "single": {"posts": 4, "avg_engagement_rate": 2.39},
          "thread": {"posts": 1, "avg_engagement_rate": 2.27}
        },
        "by_hook_type": {
          "data-lead": {"posts": 2, "avg_engagement_rate": 2.62},
          "milestone": {"posts": 1, "avg_engagement_rate": 2.27},
          "news-commentary": {"posts": 1, "avg_engagement_rate": 2.17},
          "curiosity-gap": {"posts": 1, "avg_engagement_rate": 2.15}
        },
        "top_hooks": [
          "Data-lead hooks (metrics first) averaged 2.62% engagement",
          "Curiosity-gap hooks drove highest raw engagement (266 interactions on 12.4K views)",
          "Milestone hooks performed well for threads (2.27% on 8.5K views)"
        ],
        "patterns": [
          "Teaser content with curiosity gaps gets 4x the views of standard metrics posts",
          "Threads outperform singles on raw engagement but have lower engagement rate",
          "Data-lead hooks consistently hit above baseline engagement rate",
          "Bridge-build pillar has highest engagement rate, ecosystem-intelligence has highest reach"
        ],
        "recommendations": [
          "REPEAT: curiosity-gap hooks for product teasers (highest views and raw engagement)",
          "REPEAT: data-lead hooks for metrics posts (highest engagement rate)",
          "TEST: combine data-lead hook with thread format",
          "AVOID: pure news commentary without VoidAI angle (lowest engagement)"
        ]
      }
    }')

  echo "$MOCK_ENGAGEMENT" | tee "$ENGAGEMENT_FILE"

  # Also write the performance summary (this is what gets injected into generation prompts)
  echo "$MOCK_ENGAGEMENT" | jq '.summary' > "$PERFORMANCE_SUMMARY_FILE"

  # Update top performers file
  echo "$MOCK_ENGAGEMENT" | jq '[.posts[] | {post_id, content_preview, engagement_rate_pct, hook_type, format, pillar, engagement}] | sort_by(-.engagement_rate_pct) | .[0:10]' > "$TOP_PERFORMERS_FILE"

  log "Mock engagement data saved to $ENGAGEMENT_FILE"
  log "Performance summary saved to $PERFORMANCE_SUMMARY_FILE"
  log "Top performers saved to $TOP_PERFORMERS_FILE"
  exit 0
fi

# --- LIVE MODE ---

log "Collecting engagement data for posts from the last $LOOKBACK_DAYS days..."

# Step 1: Find recently posted items from queue/posted/
POSTED_ITEMS=$(scan_posted_queue)
POST_COUNT=$(echo "$POSTED_ITEMS" | jq 'length')
log "Found $POST_COUNT posted items in queue"

# Step 2: Fetch engagement data via OpenTweet or X API
ENRICHED_POSTS="[]"

if [[ -n "${OPENTWEET_API_KEY:-}" ]]; then
  log "Using OpenTweet API for engagement data..."
  AUTH_HEADER="Authorization: Bearer ${OPENTWEET_API_KEY}"

  # Fetch recent posts from OpenTweet
  OPENTWEET_POSTS=$(fetch \
    "${OPENTWEET_API_BASE}posts?limit=50&sort=created_at:desc" \
    "OpenTweet recent posts" \
    "$AUTH_HEADER") || true

  if [[ -n "$OPENTWEET_POSTS" ]] && echo "$OPENTWEET_POSTS" | jq -e '.posts' >/dev/null 2>&1; then
    # Extract engagement data from each post
    ENRICHED_POSTS=$(echo "$OPENTWEET_POSTS" | jq '[.posts[] | {
      post_id: (.id // "unknown"),
      posted_at: (.created_at // .scheduled_date // "unknown"),
      engagement: {
        likes: (.metrics.like_count // .likes // 0),
        retweets: (.metrics.retweet_count // .retweets // 0),
        replies: (.metrics.reply_count // .replies // 0),
        bookmarks: (.metrics.bookmark_count // .bookmarks // 0),
        views: (.metrics.impression_count // .views // 0),
        quotes: (.metrics.quote_count // .quotes // 0)
      },
      content_preview: (.text // "" | .[0:300])
    }]')
    log "Fetched engagement for $(echo "$ENRICHED_POSTS" | jq 'length') posts from OpenTweet"
  else
    log "WARNING: Could not parse OpenTweet response. Falling back to queue data."
  fi

elif [[ -n "${X_BEARER_TOKEN:-}" ]]; then
  log "Using X API for engagement data..."
  # X API v2 endpoint for tweet metrics
  # This would use GET /2/tweets with tweet.fields=public_metrics
  log "X API engagement collection: implement when X API Basic is active (Phase 3)"

else
  log "WARNING: No API credentials available for engagement data."
  log "Set OPENTWEET_API_KEY or X_BEARER_TOKEN to enable live engagement tracking."
  log "Falling back to queue/posted/ directory scan only."
fi

# Step 3: Merge queue metadata with engagement data
# Cross-reference posted queue items with engagement data by matching content
FINAL_POSTS="$ENRICHED_POSTS"
if [[ $(echo "$FINAL_POSTS" | jq 'length') -eq 0 ]]; then
  # If no API data, use queue data with zero engagement (still useful for tracking)
  FINAL_POSTS=$(echo "$POSTED_ITEMS" | jq '[.[] | . + {
    engagement: {likes: 0, retweets: 0, replies: 0, bookmarks: 0, views: 0, quotes: 0},
    engagement_rate_pct: 0
  }]')
fi

# Step 4: Calculate engagement rates and build summary
TOTAL_POSTS=$(echo "$FINAL_POSTS" | jq 'length')

# Calculate engagement rate for each post: (likes + RTs + replies + bookmarks + quotes) / views * 100
FINAL_POSTS=$(echo "$FINAL_POSTS" | jq '[.[] | . + {
  engagement_rate_pct: (
    if (.engagement.views // 0) > 0 then
      (((.engagement.likes // 0) + (.engagement.retweets // 0) + (.engagement.replies // 0) + (.engagement.bookmarks // 0) + (.engagement.quotes // 0)) / (.engagement.views) * 100 | . * 100 | round / 100)
    else 0
    end
  )
}]')

# Build summary
TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

SUMMARY=$(echo "$FINAL_POSTS" | jq --arg date "$TODAY" --arg ts "$TIMESTAMP" --argjson lookback "$LOOKBACK_DAYS" '{
  total_posts_analyzed: length,
  avg_engagement_rate_pct: (if length > 0 then ([.[].engagement_rate_pct] | add / length | . * 100 | round / 100) else 0 end),
  best_performing_post: (sort_by(-.engagement_rate_pct) | .[0].post_id // "none"),
  best_engagement_rate: (sort_by(-.engagement_rate_pct) | .[0].engagement_rate_pct // 0),
  worst_performing_post: (sort_by(.engagement_rate_pct) | .[0].post_id // "none"),
  worst_engagement_rate: (sort_by(.engagement_rate_pct) | .[0].engagement_rate_pct // 0),
  total_likes: ([.[].engagement.likes] | add // 0),
  total_retweets: ([.[].engagement.retweets] | add // 0),
  total_replies: ([.[].engagement.replies] | add // 0),
  total_views: ([.[].engagement.views] | add // 0)
}')

# Build the complete output
OUTPUT=$(jq -n \
  --arg date "$TODAY" \
  --arg ts "$TIMESTAMP" \
  --argjson lookback "$LOOKBACK_DAYS" \
  --argjson posts "$FINAL_POSTS" \
  --argjson summary "$SUMMARY" \
  '{
    "collected_at": $ts,
    "date": $date,
    "dry_run": false,
    "lookback_days": $lookback,
    "posts": $posts,
    "summary": $summary
  }')

# Save outputs
echo "$OUTPUT" | tee "$ENGAGEMENT_FILE"
echo "$OUTPUT" | jq '.summary' > "$PERFORMANCE_SUMMARY_FILE"
echo "$OUTPUT" | jq '[.posts[] | {post_id, content_preview, engagement_rate_pct, engagement}] | sort_by(-.engagement_rate_pct) | .[0:'"$TOP_N"']' > "$TOP_PERFORMERS_FILE"

log "Engagement data saved to $ENGAGEMENT_FILE"
log "Performance summary saved to $PERFORMANCE_SUMMARY_FILE"
log "Top performers saved to $TOP_PERFORMERS_FILE"
log "Total posts analyzed: $TOTAL_POSTS"
