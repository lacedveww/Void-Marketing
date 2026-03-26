#!/usr/bin/env bash
# summarize-sweep.sh
#
# Reads the latest sweep JSON and outputs a condensed summary suitable for
# the Morning Summary cron job. Reduces 150KB+ sweep files to ~5KB by
# extracting only the top posts, metrics, and signals.
#
# Usage:
#   ./summarize-sweep.sh                    # auto-finds today's latest sweep
#   ./summarize-sweep.sh /path/to/sweep.json  # specific file
#
# Output: condensed JSON to stdout

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
DATA_DIR="$PROJECT_ROOT/companies/voidai/automations/data"

# Find sweep file
if [[ $# -ge 1 && -f "$1" ]]; then
  SWEEP_FILE="$1"
else
  SWEEP_FILE=$(ls -t "$DATA_DIR"/sweep-$(date +%Y-%m-%d)*.json 2>/dev/null | head -1)
  if [[ -z "$SWEEP_FILE" ]]; then
    SWEEP_FILE=$(ls -t "$DATA_DIR"/sweep-*.json 2>/dev/null | head -1)
  fi
fi

if [[ -z "$SWEEP_FILE" || ! -f "$SWEEP_FILE" ]]; then
  echo '{"error": "No sweep file found"}' >&2
  jq -n '{error: "No sweep file found", tao_price: null, top_posts: [], competitor_mentions: [], voidai_mentions: []}'
  exit 1
fi

echo "[summarize-sweep] Reading: $SWEEP_FILE" >&2

# Extract condensed summary: top 10 posts by likes, competitor/VoidAI mentions, metrics
jq '{
  sweep_file: input_filename,
  collected_at: .collected_at,
  sweep_type: .sweep_type,
  accounts_checked: .x_accounts.accounts_checked,
  accounts_with_activity: .x_accounts.accounts_with_activity,
  total_posts: .x_accounts.total_posts,
  top_posts_by_engagement: [.x_accounts.posts | sort_by(-.engagement.likes) | .[0:10] | .[] | {
    account,
    tweet_text: (.tweet_text[0:200]),
    likes: .engagement.likes,
    retweets: .engagement.retweets,
    replies: .engagement.replies,
    views: .engagement.views,
    mentions_voidai,
    mentions_competitor,
    priority,
    tier
  }],
  high_priority_posts: [.x_accounts.posts[] | select(.priority == "high") | {
    account,
    tweet_text: (.tweet_text[0:200]),
    likes: .engagement.likes
  }] | .[0:5],
  competitor_mentions: [.x_accounts.posts[] | select(.mentions_competitor == true) | {
    account,
    tweet_text: (.tweet_text[0:200]),
    likes: .engagement.likes
  }],
  voidai_mentions: [.x_accounts.posts[] | select(.mentions_voidai == true) | {
    account,
    tweet_text: (.tweet_text[0:200])
  }],
  market: {
    tao_price_usd: .metrics_snapshot.tao.price_usd,
    tao_24h_change_pct: .metrics_snapshot.tao.price_change_24h_pct,
    tao_7d_change_pct: .metrics_snapshot.tao.price_change_7d_pct,
    tao_30d_change_pct: .metrics_snapshot.tao.price_change_30d_pct,
    tao_volume_24h: .metrics_snapshot.tao.volume_24h_usd,
    tao_market_cap: .metrics_snapshot.tao.market_cap_usd
  },
  sn106: {
    validators: .metrics_snapshot.sn106.validators,
    active_miners: .metrics_snapshot.sn106.active_miners,
    fee_rate: .metrics_snapshot.sn106.fee_rate,
    alpha_price_tao: .metrics_snapshot.sn106.alpha_price_tao_estimate
  },
  network: {
    total_subnets: .metrics_snapshot.network.total_subnets
  },
  news_items_matched: (.ecosystem_news.total_matched // 0),
  news_items: [(.ecosystem_news.items // [])[] | {title, source, url}] | .[0:5]
}' "$SWEEP_FILE"
