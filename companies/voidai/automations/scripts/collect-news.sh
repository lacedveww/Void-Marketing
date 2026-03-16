#!/usr/bin/env bash
# collect-news.sh
#
# Fetches RSS feeds from crypto news sources and filters for Bittensor/TAO/subnet
# related items. Outputs filtered news as JSON to stdout and saves to data directory.
#
# Usage:
#   ./collect-news.sh
#   DRY_RUN=true ./collect-news.sh
#
# Output file:
#   companies/voidai/automations/data/news-YYYY-MM-DD.json
#
# Also outputs filtered news JSON to stdout for piping.
#
# RSS Sources:
#   - CoinDesk
#   - The Block
#   - CoinTelegraph
#   - DL News
#
# Environment:
#   DRY_RUN        If "true", uses mock data instead of fetching feeds
#   HTTP_TIMEOUT   Curl timeout in seconds (default: 30)
#   MAX_ITEMS      Maximum items to return (default: 20)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
DATA_DIR="$PROJECT_ROOT/companies/voidai/automations/data"

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
MAX_ITEMS="${MAX_ITEMS:-20}"

TODAY=$(date '+%Y-%m-%d')
OUTPUT_FILE="$DATA_DIR/news-${TODAY}.json"

log() {
  echo "[collect-news] $(date '+%Y-%m-%d %H:%M:%S') $*" >&2
}

mkdir -p "$DATA_DIR"

# Keywords to filter for (case-insensitive)
KEYWORDS="bittensor|\\btao\\b|subnet|dtao|voidai|void ai|sn106|decentralized ai|wTAO|taoflow|yuma consensus|cross-chain bridge|cross.chain.*bittensor"

# RSS feed URLs
declare -a RSS_FEEDS=(
  "https://www.coindesk.com/arc/outboundfeeds/rss/"
  "https://www.theblock.co/rss.xml"
  "https://cointelegraph.com/rss"
  "https://www.dlnews.com/arc/outboundfeeds/rss/"
)

declare -a FEED_NAMES=(
  "CoinDesk"
  "The Block"
  "CoinTelegraph"
  "DL News"
)

# DRY_RUN mode
if [[ "$DRY_RUN" == "true" ]]; then
  log "DRY_RUN is true. Using mock data."

  MOCK_NEWS=$(jq -n \
    --arg date "$TODAY" \
    --arg ts "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" \
    '{
      "collected_at": $ts,
      "date": $date,
      "dry_run": true,
      "keyword_filter": "bittensor|tao|subnet|dtao|voidai|sn106",
      "items": [
        {
          "title": "Bittensor Network Crosses 100 Active Subnets Milestone",
          "summary": "The Bittensor decentralized AI network now hosts over 100 active subnets, marking a significant growth phase for the TAO ecosystem.",
          "source": "CoinDesk",
          "url": "https://example.com/bittensor-100-subnets",
          "published_at": "2026-03-15T10:00:00Z",
          "matched_keywords": ["bittensor", "subnet", "tao"]
        },
        {
          "title": "TAO Price Surges 15% as dTAO Trading Volume Hits Record",
          "summary": "TAO token price jumped 15% in 24 hours as dTAO alpha token trading volume reached all-time highs across multiple subnets.",
          "source": "The Block",
          "url": "https://example.com/tao-price-surge",
          "published_at": "2026-03-15T08:30:00Z",
          "matched_keywords": ["tao", "dtao", "subnet"]
        }
      ],
      "total_fetched": 0,
      "total_matched": 2
    }')

  echo "$MOCK_NEWS" | tee "$OUTPUT_FILE"
  log "Mock news saved to $OUTPUT_FILE"
  exit 0
fi

# Parse RSS XML into JSON items using sed/grep/awk (no external XML parser needed).
# This is intentionally simple: extract title, link, description, and pubDate from
# RSS <item> blocks.
parse_rss() {
  local xml="$1"
  local source_name="$2"

  # Extract items block by block.
  # Strategy: use awk to isolate <item>...</item> blocks, then extract fields.
  echo "$xml" | awk '
    BEGIN { in_item=0; title=""; link=""; desc=""; pubdate="" }
    /<item>/ { in_item=1; title=""; link=""; desc=""; pubdate=""; next }
    /<\/item>/ {
      in_item=0
      # Clean up CDATA and HTML tags
      gsub(/<!\[CDATA\[/, "", title); gsub(/\]\]>/, "", title)
      gsub(/<!\[CDATA\[/, "", desc); gsub(/\]\]>/, "", desc)
      gsub(/<[^>]*>/, "", desc)
      gsub(/"/, "\\\"", title)
      gsub(/"/, "\\\"", desc)
      # Truncate description
      if (length(desc) > 500) desc = substr(desc, 1, 500)
      printf "%s\t%s\t%s\t%s\n", title, link, desc, pubdate
      next
    }
    in_item && /<title>/ {
      gsub(/.*<title>/, ""); gsub(/<\/title>.*/, "")
      title = $0
    }
    in_item && /<link>/ {
      gsub(/.*<link>/, ""); gsub(/<\/link>.*/, "")
      link = $0
    }
    in_item && /<description>/ {
      gsub(/.*<description>/, ""); gsub(/<\/description>.*/, "")
      desc = $0
    }
    in_item && /<pubDate>/ {
      gsub(/.*<pubDate>/, ""); gsub(/<\/pubDate>.*/, "")
      pubdate = $0
    }
  ' | while IFS=$'\t' read -r title link desc pubdate; do
    # Filter: check if title or description matches keywords
    COMBINED_TEXT="$title $desc"
    MATCHED_KEYWORDS=""

    if echo "$COMBINED_TEXT" | grep -iqE "$KEYWORDS"; then
      # Identify which keywords matched
      for kw in bittensor tao subnet dtao voidai sn106 "decentralized ai" wTAO; do
        if echo "$COMBINED_TEXT" | grep -iq "$kw"; then
          if [[ -n "$MATCHED_KEYWORDS" ]]; then
            MATCHED_KEYWORDS="$MATCHED_KEYWORDS, \"$kw\""
          else
            MATCHED_KEYWORDS="\"$kw\""
          fi
        fi
      done

      # Output as JSON line
      jq -n \
        --arg title "$title" \
        --arg summary "$desc" \
        --arg source "$source_name" \
        --arg url "$link" \
        --arg pub "$pubdate" \
        --argjson keywords "[$MATCHED_KEYWORDS]" \
        '{
          "title": $title,
          "summary": $summary,
          "source": $source,
          "url": $url,
          "published_at": $pub,
          "matched_keywords": $keywords
        }'
    fi
  done
}

# Fetch and parse all feeds
ALL_ITEMS="[]"
TOTAL_FETCHED=0

for i in "${!RSS_FEEDS[@]}"; do
  FEED_URL="${RSS_FEEDS[$i]}"
  FEED_NAME="${FEED_NAMES[$i]}"

  log "Fetching $FEED_NAME RSS feed..."

  RSS_XML=$(curl -s -f --max-time "$HTTP_TIMEOUT" \
    -H "User-Agent: VoidAI-NewsBot/1.0" \
    "$FEED_URL" 2>/dev/null) || {
    log "WARNING: Failed to fetch $FEED_NAME feed. Skipping."
    continue
  }

  if [[ -z "$RSS_XML" ]]; then
    log "WARNING: Empty response from $FEED_NAME. Skipping."
    continue
  fi

  # Count raw items
  RAW_COUNT=$(echo "$RSS_XML" | grep -c '<item>' || true)
  TOTAL_FETCHED=$((TOTAL_FETCHED + RAW_COUNT))
  log "$FEED_NAME: $RAW_COUNT items found"

  # Parse and filter
  FILTERED_ITEMS=$(parse_rss "$RSS_XML" "$FEED_NAME")

  if [[ -n "$FILTERED_ITEMS" ]]; then
    MATCH_COUNT=$(echo "$FILTERED_ITEMS" | wc -l | tr -d ' ')
    log "$FEED_NAME: $MATCH_COUNT items matched keywords"

    # Merge into ALL_ITEMS array
    while IFS= read -r item; do
      ALL_ITEMS=$(echo "$ALL_ITEMS" | jq --argjson new "$item" '. + [$new]')
    done <<< "$FILTERED_ITEMS"
  else
    log "$FEED_NAME: 0 items matched keywords"
  fi
done

# Limit results
TOTAL_MATCHED=$(echo "$ALL_ITEMS" | jq 'length')
ALL_ITEMS=$(echo "$ALL_ITEMS" | jq ".[0:$MAX_ITEMS]")
RETURNED_COUNT=$(echo "$ALL_ITEMS" | jq 'length')

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

# Build final output
OUTPUT=$(jq -n \
  --arg date "$TODAY" \
  --arg ts "$TIMESTAMP" \
  --argjson items "$ALL_ITEMS" \
  --argjson total_fetched "$TOTAL_FETCHED" \
  --argjson total_matched "$TOTAL_MATCHED" \
  --argjson returned "$RETURNED_COUNT" \
  '{
    "collected_at": $ts,
    "date": $date,
    "dry_run": false,
    "keyword_filter": "bittensor|tao|subnet|dtao|voidai|sn106|decentralized ai|wTAO",
    "items": $items,
    "total_fetched": $total_fetched,
    "total_matched": $total_matched,
    "total_returned": $returned
  }')

echo "$OUTPUT" | tee "$OUTPUT_FILE"
log "News collection complete: $TOTAL_FETCHED total items, $TOTAL_MATCHED matched, $RETURNED_COUNT returned"
log "Saved to $OUTPUT_FILE"
