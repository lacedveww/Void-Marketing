#!/usr/bin/env bash
# build-sweep.sh
#
# Master sweep builder: runs all collection scripts and merges their outputs
# into a single sweep JSON file. Called by the Intelligence Sweep cron job.
#
# Runs these scripts in sequence:
#   1. collect-x-accounts.sh  -- X/Twitter account monitoring (Apify)
#   2. collect-news.sh        -- RSS feeds from crypto news sources
#   3. collect-metrics.sh     -- Taostats API (TAO price, SN106, network stats)
#
# All data flows through temp files (not bash variables) to handle large payloads.
#
# Output:
#   companies/voidai/automations/data/sweep-YYYY-MM-DD-HHMM.json
#
# Usage:
#   ./build-sweep.sh                    # default: 12h window, both tiers
#   ./build-sweep.sh --hours 24         # passed to collect-x-accounts.sh
#   ./build-sweep.sh --tier content     # passed to collect-x-accounts.sh
#
# Environment:
#   DRY_RUN      If "true", all sub-scripts use mock data (default from .env)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
DATA_DIR="$PROJECT_ROOT/companies/voidai/automations/data"

# Preserve caller's DRY_RUN before sourcing .env
_CALLER_DRY_RUN="${DRY_RUN:-}"

if [[ -f "$PROJECT_ROOT/.env" ]]; then
  set -a
  source "$PROJECT_ROOT/.env"
  set +a
fi

DRY_RUN="${_CALLER_DRY_RUN:-${DRY_RUN:-true}}"
export DRY_RUN

TIMESTAMP=$(date '+%Y-%m-%d-%H%M')
HOUR=$(date '+%H')
if [[ "$HOUR" -lt 12 ]]; then
  SWEEP_TYPE="morning"
else
  SWEEP_TYPE="evening"
fi
SWEEP_FILE="$DATA_DIR/sweep-${TIMESTAMP}.json"

# Pass-through args for collect-x-accounts.sh
X_ARGS=("$@")

log() {
  echo "[build-sweep] $(date '+%Y-%m-%d %H:%M:%S') $*" >&2
}

mkdir -p "$DATA_DIR"

# Temp files for each data source (avoids bash variable size limits)
X_FILE=$(mktemp)
NEWS_FILE=$(mktemp)
METRICS_FILE=$(mktemp)
trap 'rm -f "$X_FILE" "$NEWS_FILE" "$METRICS_FILE"' EXIT

EMPTY_X='{"collected_at":"'$(date -u '+%Y-%m-%dT%H:%M:%SZ')'","accounts_checked":0,"total_posts":0,"posts":[]}'
EMPTY_NEWS='{"collected_at":"'$(date -u '+%Y-%m-%dT%H:%M:%SZ')'","items":[],"total_matched":0}'
EMPTY_METRICS='{"tao":{},"sn106":{},"network":{}}'

log "Starting sweep build (type=$SWEEP_TYPE, DRY_RUN=$DRY_RUN)"
log "Output: $SWEEP_FILE"

# ---------------------------------------------------------------------------
# Step 1: Collect X account data (output goes to file)
# ---------------------------------------------------------------------------
log "--- Step 1/3: X Account Collection ---"
"$SCRIPT_DIR/collect-x-accounts.sh" "${X_ARGS[@]}" > "$X_FILE" 2>/dev/null || {
  log "WARNING: collect-x-accounts.sh failed. Using empty fallback."
  echo "$EMPTY_X" > "$X_FILE"
}

if ! jq empty "$X_FILE" 2>/dev/null; then
  log "WARNING: X data is not valid JSON. Using empty fallback."
  echo "$EMPTY_X" > "$X_FILE"
fi

X_POST_COUNT=$(jq '.total_posts // (.posts | length) // 0' "$X_FILE" 2>/dev/null) || X_POST_COUNT=0
log "X accounts: $X_POST_COUNT posts collected"

# ---------------------------------------------------------------------------
# Step 2: Collect news (output goes to file)
# ---------------------------------------------------------------------------
log "--- Step 2/3: News Collection ---"
"$SCRIPT_DIR/collect-news.sh" > "$NEWS_FILE" 2>/dev/null || {
  log "WARNING: collect-news.sh failed. Using empty fallback."
  echo "$EMPTY_NEWS" > "$NEWS_FILE"
}

if ! jq empty "$NEWS_FILE" 2>/dev/null; then
  log "WARNING: News data is not valid JSON. Using empty fallback."
  echo "$EMPTY_NEWS" > "$NEWS_FILE"
fi

NEWS_COUNT=$(jq '.total_matched // (.items | length) // 0' "$NEWS_FILE" 2>/dev/null) || NEWS_COUNT=0
log "News: $NEWS_COUNT items matched"

# ---------------------------------------------------------------------------
# Step 3: Collect metrics (output goes to file)
# ---------------------------------------------------------------------------
log "--- Step 3/3: Metrics Collection ---"
"$SCRIPT_DIR/collect-metrics.sh" > "$METRICS_FILE" 2>/dev/null || {
  log "WARNING: collect-metrics.sh failed. Using empty fallback."
  echo "$EMPTY_METRICS" > "$METRICS_FILE"
}

if ! jq empty "$METRICS_FILE" 2>/dev/null; then
  log "WARNING: Metrics data is not valid JSON. Using empty fallback."
  echo "$EMPTY_METRICS" > "$METRICS_FILE"
fi

TAO_PRICE=$(jq -r '.tao.price_usd // "unknown"' "$METRICS_FILE" 2>/dev/null) || TAO_PRICE="unknown"
log "Metrics: TAO price = \$$TAO_PRICE"

# ---------------------------------------------------------------------------
# Step 4: Merge into sweep file (all file-based, no large variables)
# ---------------------------------------------------------------------------
log "--- Merging into sweep file ---"

COLLECTED_AT=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
IS_DRY_RUN="false"
[[ "$DRY_RUN" == "true" ]] && IS_DRY_RUN="true"

jq -n \
  --arg ts "$COLLECTED_AT" \
  --arg sweep_type "$SWEEP_TYPE" \
  --argjson dry_run "$IS_DRY_RUN" \
  --slurpfile x_accounts "$X_FILE" \
  --slurpfile ecosystem_news "$NEWS_FILE" \
  --slurpfile metrics_snapshot "$METRICS_FILE" \
  '{
    collected_at: $ts,
    sweep_type: $sweep_type,
    dry_run: $dry_run,
    metadata: {
      x_accounts_checked: ($x_accounts[0].accounts_checked // 0),
      x_posts_found: ($x_accounts[0].total_posts // 0),
      news_items_matched: ($ecosystem_news[0].total_matched // 0),
      tao_price_usd: ($metrics_snapshot[0].tao.price_usd // null),
      sn106_validators: ($metrics_snapshot[0].sn106.validators // null)
    },
    x_accounts: $x_accounts[0],
    ecosystem_news: $ecosystem_news[0],
    metrics_snapshot: $metrics_snapshot[0]
  }' > "$SWEEP_FILE"

# Verify
if [[ -f "$SWEEP_FILE" ]]; then
  FILE_SIZE=$(wc -c < "$SWEEP_FILE" | tr -d ' ')
  log "Sweep file written: $SWEEP_FILE ($FILE_SIZE bytes)"
else
  log "ERROR: Failed to write sweep file!"
  exit 1
fi

# Output the file path (for the cron job to reference)
echo "$SWEEP_FILE"

log "Sweep build complete."
log "  X posts: $X_POST_COUNT"
log "  News items: $NEWS_COUNT"
log "  TAO price: \$$TAO_PRICE"
log "  Sweep type: $SWEEP_TYPE"
log "  DRY_RUN: $DRY_RUN"
