#!/usr/bin/env bash
# collect-x-accounts.sh
#
# Fetches recent tweets from monitored X/Twitter accounts using the Apify
# Tweet Scraper V2 (apidojo/tweet-scraper) with OR-batched search queries.
#
# Actor: apidojo/tweet-scraper
# Pricing: $0.0004 per tweet (Bronze tier), plus CU compute
# Strategy: Batch 10 accounts per search query using Twitter's "from:" OR syntax.
#   e.g. "from:bittensor_ OR from:opentensor OR from:TheBittensorHub"
#   This means ~5-10 API calls for 100+ accounts instead of 100+ individual calls.
#
# Budget: Starter plan $29/month prepaid. Target: <$0.50/sweep, <$1.00/day, <$27/month.
#
# Usage:
#   ./collect-x-accounts.sh                      # both tiers, 12h window
#   ./collect-x-accounts.sh --hours 24            # 24h window
#   ./collect-x-accounts.sh --tier content        # Tier 1 only (~45 accounts)
#   ./collect-x-accounts.sh --tier marketing      # Tier 2 only (~60 accounts)
#   ./collect-x-accounts.sh --max-per-account 5   # limit tweets kept per account
#
# Output:
#   JSON to stdout (for piping to build-sweep.sh)
#   Also saves to: data/x-accounts-YYYY-MM-DD-HHMM.json
#
# Environment:
#   APIFY_API_TOKEN        Apify API token (required for live mode)
#   DRY_RUN                If "true", outputs mock data (default from .env)
#   MAX_APIFY_DAILY_COST   Daily spend cap in USD (default: 1.00)
#   MAX_APIFY_MONTHLY_COST Monthly spend cap in USD (default: 27.00)
#   APIFY_COST_PER_RUN     Cost cap per actor run in USD (default: 0.50)
#   HTTP_TIMEOUT           Curl timeout per API call in seconds (default: 300)
#
# Windows note: uses curl.exe to avoid PowerShell curl alias.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
DATA_DIR="$PROJECT_ROOT/companies/voidai/automations/data"
MONITORING_DIR="$PROJECT_ROOT/companies/voidai/monitoring"

# Apify actor ID (tilde format for API URLs)
ACTOR_ID="apidojo~tweet-scraper"
APIFY_API_BASE="https://api.apify.com/v2"

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
HTTP_TIMEOUT="${HTTP_TIMEOUT:-300}"
APIFY_API_TOKEN="${APIFY_API_TOKEN:-}"
MAX_APIFY_DAILY_COST="${MAX_APIFY_DAILY_COST:-1.00}"
MAX_APIFY_MONTHLY_COST="${MAX_APIFY_MONTHLY_COST:-27.00}"
APIFY_COST_PER_RUN="${APIFY_COST_PER_RUN:-0.50}"

# ---------------------------------------------------------------------------
# Parse arguments
# ---------------------------------------------------------------------------
HOURS=12
TIER="all"
MAX_PER_ACCOUNT=5
ACCOUNTS_PER_QUERY=10

while [[ $# -gt 0 ]]; do
  case "$1" in
    --hours) HOURS="$2"; shift 2 ;;
    --tier) TIER="$2"; shift 2 ;;
    --max-per-account) MAX_PER_ACCOUNT="$2"; shift 2 ;;
    --accounts-per-query) ACCOUNTS_PER_QUERY="$2"; shift 2 ;;
    -h|--help)
      echo "Usage: $0 [--hours N] [--tier content|marketing|all] [--max-per-account N] [--accounts-per-query N]"
      exit 0
      ;;
    *) shift ;;
  esac
done

TIMESTAMP=$(date '+%Y-%m-%d-%H%M')
OUTPUT_FILE="$DATA_DIR/x-accounts-${TIMESTAMP}.json"
TODAY=$(date '+%Y-%m-%d')
THIS_MONTH=$(date '+%Y-%m')

# Use curl.exe on Windows to avoid PowerShell alias; fall back to curl
if command -v curl.exe &>/dev/null; then
  CURL_BIN="curl.exe"
else
  CURL_BIN="curl"
fi

log() {
  echo "[collect-x] $(date '+%Y-%m-%d %H:%M:%S') $*" >&2
}

mkdir -p "$DATA_DIR"

# Compute start date for Apify date filter
if date -d "now" '+%s' &>/dev/null 2>&1; then
  START_DATE=$(date -u -d "-${HOURS} hours" '+%Y-%m-%d')
else
  START_DATE=$(date -u -v-${HOURS}H '+%Y-%m-%d' 2>/dev/null || date -u '+%Y-%m-%d')
fi
END_DATE=$(date -u '+%Y-%m-%d')

log "Config: tier=$TIER, window=${HOURS}h, max_per_account=$MAX_PER_ACCOUNT, accounts_per_query=$ACCOUNTS_PER_QUERY"
log "Date range: $START_DATE to $END_DATE"
log "Cost caps: \$${APIFY_COST_PER_RUN}/run, \$${MAX_APIFY_DAILY_COST}/day, \$${MAX_APIFY_MONTHLY_COST}/month"

# ---------------------------------------------------------------------------
# Parse X handles from monitoring markdown files
# ---------------------------------------------------------------------------
parse_handles() {
  local file="$1"
  local tier="$2"
  if [[ ! -f "$file" ]]; then
    log "WARNING: $file not found, skipping"
    return
  fi
  grep -oE '@[A-Za-z0-9_]+' "$file" | sed 's/^@//' | sort -u | while read -r handle; do
    echo "${handle}|${tier}"
  done
}

declare -a RAW_HANDLES=()

if [[ "$TIER" == "all" || "$TIER" == "content" ]]; then
  while IFS= read -r line; do
    [[ -n "$line" ]] && RAW_HANDLES+=("$line")
  done < <(parse_handles "$MONITORING_DIR/content-accounts.md" "content")
fi

if [[ "$TIER" == "all" || "$TIER" == "marketing" ]]; then
  while IFS= read -r line; do
    [[ -n "$line" ]] && RAW_HANDLES+=("$line")
  done < <(parse_handles "$MONITORING_DIR/marketing-accounts.md" "marketing")
fi

# Deduplicate handles (keep first occurrence's tier)
declare -A SEEN_HANDLES=()
declare -A HANDLE_TIER=()
UNIQUE_HANDLES_LIST=()
for entry in "${RAW_HANDLES[@]}"; do
  handle="${entry%%|*}"
  tier="${entry#*|}"
  lower=$(echo "$handle" | tr '[:upper:]' '[:lower:]')
  if [[ -z "${SEEN_HANDLES[$lower]:-}" ]]; then
    SEEN_HANDLES[$lower]=1
    HANDLE_TIER[$lower]="$tier"
    UNIQUE_HANDLES_LIST+=("$handle")
  fi
done

TOTAL_HANDLES=${#UNIQUE_HANDLES_LIST[@]}
log "Found $TOTAL_HANDLES unique handles to check"

# ---------------------------------------------------------------------------
# DRY_RUN mode
# ---------------------------------------------------------------------------
if [[ "$DRY_RUN" == "true" ]]; then
  log "DRY_RUN=true. Generating mock X account data (Apify not called)."

  MOCK=$(jq -n \
    --arg ts "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" \
    --arg window "${HOURS}h" \
    --argjson checked "$TOTAL_HANDLES" \
    '{
      collected_at: $ts,
      sweep_window: $window,
      dry_run: true,
      source: "apify/apidojo~tweet-scraper",
      accounts_checked: $checked,
      accounts_with_activity: 8,
      accounts_empty: ($checked - 12),
      accounts_failed: 4,
      total_posts: 14,
      apify_cost_usd: 0,
      posts: [
        {
          account: "@opentensor",
          tier: "content",
          tweet_text: "[MOCK] Bittensor protocol update v4.3 rolling out: improved subnet incentive mechanism for validators.",
          tweet_url: "https://x.com/opentensor/status/mock001",
          timestamp: "2026-03-25T06:00:00Z",
          engagement: { likes: 342, retweets: 89, replies: 23, views: 15000, quotes: 12 },
          is_thread: false,
          is_reply: false,
          mentions_voidai: false,
          mentions_competitor: false,
          priority: "high"
        },
        {
          account: "@const_reborn",
          tier: "content",
          tweet_text: "[MOCK] Targon SN4 just crossed 1B tokens processed. The compute revolution is compounding.",
          tweet_url: "https://x.com/const_reborn/status/mock002",
          timestamp: "2026-03-25T05:30:00Z",
          engagement: { likes: 567, retweets: 134, replies: 45, views: 28000, quotes: 23 },
          is_thread: false,
          is_reply: false,
          mentions_voidai: false,
          mentions_competitor: false,
          priority: "high"
        },
        {
          account: "@SturdyFinance",
          tier: "content",
          tweet_text: "[MOCK] Sturdy v2 is live. AI-optimized yields now available on 12 new pools.",
          tweet_url: "https://x.com/SturdyFinance/status/mock003",
          timestamp: "2026-03-25T04:15:00Z",
          engagement: { likes: 189, retweets: 42, replies: 15, views: 8500, quotes: 8 },
          is_thread: false,
          is_reply: false,
          mentions_voidai: false,
          mentions_competitor: true,
          priority: "high"
        },
        {
          account: "@chutes_ai",
          tier: "content",
          tweet_text: "[MOCK] SN64 inference costs down 40% this week. Running Llama 3.3 at 2x speed of centralized providers.",
          tweet_url: "https://x.com/chutes_ai/status/mock004",
          timestamp: "2026-03-25T03:00:00Z",
          engagement: { likes: 234, retweets: 67, replies: 18, views: 12000, quotes: 11 },
          is_thread: false,
          is_reply: false,
          mentions_voidai: false,
          mentions_competitor: false,
          priority: "high"
        },
        {
          account: "@AaveAave",
          tier: "marketing",
          tweet_text: "[MOCK] Aave v4 governance proposal: cross-chain lending pools with unified liquidity.",
          tweet_url: "https://x.com/AaveAave/status/mock005",
          timestamp: "2026-03-25T07:00:00Z",
          engagement: { likes: 1245, retweets: 312, replies: 89, views: 95000, quotes: 56 },
          is_thread: false,
          is_reply: false,
          mentions_voidai: false,
          mentions_competitor: false,
          priority: "high"
        },
        {
          account: "@AnthropicAI",
          tier: "marketing",
          tweet_text: "[MOCK] Claude 4 now available for enterprise. 1M context, tool use, and computer use in one model.",
          tweet_url: "https://x.com/AnthropicAI/status/mock006",
          timestamp: "2026-03-25T06:30:00Z",
          engagement: { likes: 4523, retweets: 1234, replies: 456, views: 320000, quotes: 234 },
          is_thread: false,
          is_reply: false,
          mentions_voidai: false,
          mentions_competitor: false,
          priority: "high"
        }
      ]
    }')

  echo "$MOCK" | tee "$OUTPUT_FILE"
  log "Mock data saved to $OUTPUT_FILE"
  exit 0
fi

# ---------------------------------------------------------------------------
# Pre-flight checks
# ---------------------------------------------------------------------------
if [[ -z "$APIFY_API_TOKEN" ]]; then
  log "ERROR: APIFY_API_TOKEN not set. Add it to .env or export it."
  log "Get your token from: https://console.apify.com/account/integrations"
  jq -n '{"error": "APIFY_API_TOKEN not set", "posts": [], "total_posts": 0}' | tee "$OUTPUT_FILE"
  exit 1
fi

# ---------------------------------------------------------------------------
# Budget checks: daily and monthly spend tracking
# ---------------------------------------------------------------------------
DAILY_SPEND_FILE="$DATA_DIR/apify-daily-spend-${TODAY}.txt"
MONTHLY_SPEND_FILE="$DATA_DIR/apify-monthly-spend-${THIS_MONTH}.txt"

# Read current spend
DAILY_SPEND="0.00"
MONTHLY_SPEND="0.00"
[[ -f "$DAILY_SPEND_FILE" ]] && DAILY_SPEND=$(cat "$DAILY_SPEND_FILE" | tr -d '[:space:]')
[[ -f "$MONTHLY_SPEND_FILE" ]] && MONTHLY_SPEND=$(cat "$MONTHLY_SPEND_FILE" | tr -d '[:space:]')

# Check daily budget
OVER_DAILY=$(awk "BEGIN {print ($DAILY_SPEND >= $MAX_APIFY_DAILY_COST) ? 1 : 0}")
if [[ "$OVER_DAILY" == "1" ]]; then
  log "WARNING: Daily Apify budget reached (\$${DAILY_SPEND} >= \$${MAX_APIFY_DAILY_COST}). Skipping sweep."
  jq -n --arg ts "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" --arg r "Daily budget cap reached (\$${DAILY_SPEND}/\$${MAX_APIFY_DAILY_COST})" \
    '{collected_at: $ts, error: $r, accounts_checked: 0, total_posts: 0, posts: []}' | tee "$OUTPUT_FILE"
  exit 0
fi

# Check monthly budget
OVER_MONTHLY=$(awk "BEGIN {print ($MONTHLY_SPEND >= $MAX_APIFY_MONTHLY_COST) ? 1 : 0}")
if [[ "$OVER_MONTHLY" == "1" ]]; then
  log "WARNING: Monthly Apify budget reached (\$${MONTHLY_SPEND} >= \$${MAX_APIFY_MONTHLY_COST}). Skipping sweep."
  jq -n --arg ts "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" --arg r "Monthly budget cap reached (\$${MONTHLY_SPEND}/\$${MAX_APIFY_MONTHLY_COST})" \
    '{collected_at: $ts, error: $r, accounts_checked: 0, total_posts: 0, posts: []}' | tee "$OUTPUT_FILE"
  exit 0
fi

log "Budget: daily \$${DAILY_SPEND}/\$${MAX_APIFY_DAILY_COST}, monthly \$${MONTHLY_SPEND}/\$${MAX_APIFY_MONTHLY_COST}"

# ---------------------------------------------------------------------------
# Build OR-batched search queries
# ---------------------------------------------------------------------------
# Group handles into batches of ACCOUNTS_PER_QUERY, each becoming one search term:
#   "from:handle1 OR from:handle2 OR from:handle3 ... OR from:handle10"
# All search terms go into one API call to minimize CU overhead.

SEARCH_TERMS="[]"
BATCH_QUERY=""
BATCH_COUNT=0

for handle in "${UNIQUE_HANDLES_LIST[@]}"; do
  if [[ -n "$BATCH_QUERY" ]]; then
    BATCH_QUERY="${BATCH_QUERY} OR from:${handle}"
  else
    BATCH_QUERY="from:${handle}"
  fi
  BATCH_COUNT=$((BATCH_COUNT + 1))

  if [[ $BATCH_COUNT -ge $ACCOUNTS_PER_QUERY ]]; then
    SEARCH_TERMS=$(echo "$SEARCH_TERMS" | jq --arg q "$BATCH_QUERY" '. + [$q]')
    BATCH_QUERY=""
    BATCH_COUNT=0
  fi
done

# Add remaining handles
if [[ -n "$BATCH_QUERY" ]]; then
  SEARCH_TERMS=$(echo "$SEARCH_TERMS" | jq --arg q "$BATCH_QUERY" '. + [$q]')
fi

QUERY_COUNT=$(echo "$SEARCH_TERMS" | jq 'length')
MAX_ITEMS=$(( TOTAL_HANDLES * MAX_PER_ACCOUNT ))

log "Built $QUERY_COUNT search queries (${ACCOUNTS_PER_QUERY} accounts each)"
log "Max items: $MAX_ITEMS ($TOTAL_HANDLES accounts x $MAX_PER_ACCOUNT tweets)"

# ---------------------------------------------------------------------------
# Call Apify Tweet Scraper V2
# ---------------------------------------------------------------------------
POSTS_TMPFILE=$(mktemp)
BODY_FILE=$(mktemp)
trap 'rm -f "$POSTS_TMPFILE" "$BODY_FILE"' EXIT

# Build Apify actor input and write to file (avoids arg length limits)
INPUT_FILE=$(mktemp)
trap 'rm -f "$POSTS_TMPFILE" "$BODY_FILE" "$INPUT_FILE"' EXIT
jq -n \
  --argjson searchTerms "$SEARCH_TERMS" \
  --argjson maxItems "$MAX_ITEMS" \
  --arg start "$START_DATE" \
  --arg end "$END_DATE" \
  '{
    searchTerms: $searchTerms,
    maxItems: $maxItems,
    sort: "Latest",
    start: $start,
    end: $end,
    includeSearchTerms: true
  }' > "$INPUT_FILE"

log "Calling Apify tweet-scraper: $QUERY_COUNT queries, max $MAX_ITEMS items"
log "Cost cap: \$${APIFY_COST_PER_RUN} per run"

APIFY_URL="${APIFY_API_BASE}/acts/${ACTOR_ID}/run-sync-get-dataset-items?token=${APIFY_API_TOKEN}&format=json&clean=true&maxTotalChargeUsd=${APIFY_COST_PER_RUN}"

# Write response body directly to file (avoids bash variable size limits)
HTTP_CODE=$("$CURL_BIN" -s --max-time "$HTTP_TIMEOUT" \
  -X POST \
  -H "Content-Type: application/json" \
  -w "%{http_code}" \
  -o "$BODY_FILE" \
  -d @"$INPUT_FILE" \
  "$APIFY_URL" 2>/dev/null) || {
  log "ERROR: Apify API call failed"
  jq -n --arg ts "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" \
    '{collected_at: $ts, error: "Apify API call failed", accounts_checked: 0, total_posts: 0, posts: []}' | tee "$OUTPUT_FILE"
  exit 1
}

if [[ "$HTTP_CODE" -lt 200 || "$HTTP_CODE" -ge 300 ]]; then
  log "ERROR: Apify returned HTTP $HTTP_CODE"
  log "Response: $(head -c 500 "$BODY_FILE")"
  jq -n --arg ts "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" --arg e "Apify HTTP $HTTP_CODE" \
    '{collected_at: $ts, error: $e, accounts_checked: 0, total_posts: 0, posts: []}' | tee "$OUTPUT_FILE"
  exit 1
fi

# Validate JSON
if ! jq empty "$BODY_FILE" 2>/dev/null; then
  log "ERROR: Invalid JSON response from Apify"
  jq -n --arg ts "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" \
    '{collected_at: $ts, error: "Invalid JSON from Apify", accounts_checked: 0, total_posts: 0, posts: []}' | tee "$OUTPUT_FILE"
  exit 1
fi

RESULT_COUNT=$(jq 'length' "$BODY_FILE" 2>/dev/null) || RESULT_COUNT=0
log "Apify returned $RESULT_COUNT tweets"

# ---------------------------------------------------------------------------
# Track unique accounts with activity
# ---------------------------------------------------------------------------
if [[ "$RESULT_COUNT" -gt 0 ]]; then
  UNIQUE_AUTHORS=$(jq -r '[.[].author.userName // empty] | map(ascii_downcase) | unique | length' "$BODY_FILE" 2>/dev/null) || UNIQUE_AUTHORS=0
else
  UNIQUE_AUTHORS=0
fi

ACCOUNTS_WITH_ACTIVITY=$UNIQUE_AUTHORS
ACCOUNTS_EMPTY=$((TOTAL_HANDLES - ACCOUNTS_WITH_ACTIVITY))
if [[ $ACCOUNTS_EMPTY -lt 0 ]]; then ACCOUNTS_EMPTY=0; fi

log "$ACCOUNTS_WITH_ACTIVITY accounts had activity, $ACCOUNTS_EMPTY had none"

# ---------------------------------------------------------------------------
# Transform Apify output to sweep-compatible format
# ---------------------------------------------------------------------------
# apidojo/tweet-scraper output fields:
#   fullText, text, createdAt, likeCount, retweetCount, replyCount,
#   viewCount, quoteCount, bookmarkCount, author.userName,
#   isRetweet, isReply, twitterUrl, url, id

if [[ "$RESULT_COUNT" -gt 0 ]]; then
  # Step 1: Transform Apify output to sweep format (no tier info yet)
  JQ_FILTER='[.[] | select(.isRetweet != true) | {
    account: ("@" + (.author.userName // "unknown")),
    tier: "unknown",
    tweet_text: (.fullText // .text // ""),
    tweet_url: (.twitterUrl // .url // ("https://x.com/" + (.author.userName // "unknown") + "/status/" + (.id // ""))),
    timestamp: (.createdAt // ""),
    engagement: {
      likes: (.likeCount // 0),
      retweets: (.retweetCount // 0),
      replies: (.replyCount // 0),
      views: (.viewCount // 0),
      quotes: (.quoteCount // 0)
    },
    is_thread: false,
    is_reply: (.isReply // false),
    mentions_voidai: (((.fullText // .text // "") | test("(?i)voidai|void[.]ai|sn106|void ai")) // false),
    mentions_competitor: (((.fullText // .text // "") | test("(?i)sturdy|sturdyfinance|bitquant|gtao|tensorplex|taofi|rubicon")) // false),
    priority: (if (.likeCount // 0) > 100 then "high"
               elif (.likeCount // 0) > 20 then "medium"
               else "low" end)
  }]'

  # Write jq filter to a file to avoid arg length issues
  JQ_FILTER_FILE=$(mktemp)
  trap 'rm -f "$POSTS_TMPFILE" "$BODY_FILE" "$INPUT_FILE" "$JQ_FILTER_FILE"' EXIT
  printf '%s' "$JQ_FILTER" > "$JQ_FILTER_FILE"

  jq -f "$JQ_FILTER_FILE" "$BODY_FILE" > "$POSTS_TMPFILE" 2>/dev/null || {
    log "WARNING: jq transform failed. Trying simpler extraction."
    jq '[.[] | select(.isRetweet != true) | {account: ("@" + (.author.userName // "unknown")), tweet_text: (.fullText // .text // ""), timestamp: (.createdAt // ""), engagement: {likes: (.likeCount // 0), retweets: (.retweetCount // 0), replies: (.replyCount // 0), views: (.viewCount // 0)}}]' "$BODY_FILE" > "$POSTS_TMPFILE" 2>/dev/null || echo "[]" > "$POSTS_TMPFILE"
  }

  # Step 2: Patch tier info using bash loop (avoids large jq arg)
  PATCHED_TMPFILE=$(mktemp)
  trap 'rm -f "$POSTS_TMPFILE" "$BODY_FILE" "$INPUT_FILE" "$JQ_FILTER_FILE" "$PATCHED_TMPFILE"' EXIT

  jq -c '.[]' "$POSTS_TMPFILE" 2>/dev/null | while IFS= read -r post; do
    handle_lower=$(echo "$post" | jq -r '.account // ""' | sed 's/^@//' | tr '[:upper:]' '[:lower:]')
    tier_val="${HANDLE_TIER[$handle_lower]:-unknown}"
    echo "$post" | jq -c --arg t "$tier_val" '.tier = $t'
  done > "$PATCHED_TMPFILE"

  # Step 3: Limit to MAX_PER_ACCOUNT per account (keep top by likes)
  if [[ -s "$PATCHED_TMPFILE" ]]; then
    ALL_POSTS=$(jq -s --argjson max "$MAX_PER_ACCOUNT" '
      group_by(.account) |
      map(sort_by(-.engagement.likes) | .[0:$max]) |
      flatten
    ' "$PATCHED_TMPFILE" 2>/dev/null) || ALL_POSTS="[]"
  else
    ALL_POSTS="[]"
  fi
else
  ALL_POSTS="[]"
fi

# ---------------------------------------------------------------------------
# Estimate and track cost
# ---------------------------------------------------------------------------
# tweet-scraper: $0.0004 per tweet (Bronze). CU cost varies.
# Conservative estimate: $0.0004/tweet + ~$0.05 CU overhead per query
TWEET_COST=$(awk "BEGIN {printf \"%.4f\", $RESULT_COUNT * 0.0004}")
CU_ESTIMATE=$(awk "BEGIN {printf \"%.4f\", $QUERY_COUNT * 0.05}")
ESTIMATED_COST=$(awk "BEGIN {printf \"%.4f\", $TWEET_COST + $CU_ESTIMATE}")

# Update daily spend
NEW_DAILY=$(awk "BEGIN {printf \"%.4f\", $DAILY_SPEND + $ESTIMATED_COST}")
echo "$NEW_DAILY" > "$DAILY_SPEND_FILE"

# Update monthly spend
NEW_MONTHLY=$(awk "BEGIN {printf \"%.4f\", $MONTHLY_SPEND + $ESTIMATED_COST}")
echo "$NEW_MONTHLY" > "$MONTHLY_SPEND_FILE"

log "Estimated cost: \$${ESTIMATED_COST} (tweets: \$${TWEET_COST}, CU: ~\$${CU_ESTIMATE})"
log "Updated spend: daily \$${NEW_DAILY}/\$${MAX_APIFY_DAILY_COST}, monthly \$${NEW_MONTHLY}/\$${MAX_APIFY_MONTHLY_COST}"

# ---------------------------------------------------------------------------
# Build output JSON (file-based to avoid arg length limits)
# ---------------------------------------------------------------------------
# Write posts array to a file for --slurpfile
POSTS_FILE=$(mktemp)
trap 'rm -f "$POSTS_TMPFILE" "$BODY_FILE" "$INPUT_FILE" "$JQ_FILTER_FILE" "$PATCHED_TMPFILE" "$POSTS_FILE"' EXIT
echo "$ALL_POSTS" > "$POSTS_FILE" 2>/dev/null || echo "[]" > "$POSTS_FILE"

TOTAL_POSTS=$(jq 'length' "$POSTS_FILE" 2>/dev/null) || TOTAL_POSTS=0
COLLECTED_AT=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

jq -n \
  --arg ts "$COLLECTED_AT" \
  --arg window "${HOURS}h" \
  --arg source "apify/$ACTOR_ID" \
  --argjson checked "$TOTAL_HANDLES" \
  --argjson active "$ACCOUNTS_WITH_ACTIVITY" \
  --argjson empty "$ACCOUNTS_EMPTY" \
  --argjson failed 0 \
  --arg cost "$ESTIMATED_COST" \
  --arg daily_spend "$NEW_DAILY" \
  --arg monthly_spend "$NEW_MONTHLY" \
  --slurpfile posts "$POSTS_FILE" \
  '{
    collected_at: $ts,
    sweep_window: $window,
    source: $source,
    accounts_checked: $checked,
    accounts_with_activity: $active,
    accounts_empty: $empty,
    accounts_failed: $failed,
    total_posts: ($posts[0] | length),
    apify_cost_usd: ($cost | tonumber),
    budget: {
      daily_spend: ($daily_spend | tonumber),
      monthly_spend: ($monthly_spend | tonumber)
    },
    posts: $posts[0]
  }' | tee "$OUTPUT_FILE"
log "Complete: $TOTAL_HANDLES checked, $ACCOUNTS_WITH_ACTIVITY active, $TOTAL_POSTS posts"
log "Apify cost: ~\$${ESTIMATED_COST}"
log "Saved to $OUTPUT_FILE"
