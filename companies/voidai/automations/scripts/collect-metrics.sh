#!/usr/bin/env bash
# collect-metrics.sh
#
# Collects daily metrics from Taostats API and CoinGecko API, combines them
# into a single JSON file for use by generate-daily-tweet.sh and
# generate-weekly-thread.sh.
#
# Usage:
#   ./collect-metrics.sh
#   DRY_RUN=true ./collect-metrics.sh
#
# Output file:
#   companies/voidai/automations/data/daily-metrics-YYYY-MM-DD.json
#
# Also outputs the JSON to stdout for piping to other scripts.
#
# Environment:
#   TAOSTATS_API_KEY    API key for Taostats
#   TAOSTATS_API_BASE   Base URL for Taostats API (default: https://api.taostats.io)
#   COINGECKO_API_BASE  Base URL for CoinGecko (default: https://api.coingecko.com/api/v3)
#   DRY_RUN             If "true", uses mock data instead of real API calls
#   HTTP_TIMEOUT        Curl timeout in seconds (default: 30)

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
TAOSTATS_API_BASE="${TAOSTATS_API_BASE:-https://api.taostats.io/api}"
COINGECKO_API_BASE="${COINGECKO_API_BASE:-https://api.coingecko.com/api/v3}"

TODAY=$(date '+%Y-%m-%d')
OUTPUT_FILE="$DATA_DIR/daily-metrics-${TODAY}.json"

log() {
  echo "[collect-metrics] $(date '+%Y-%m-%d %H:%M:%S') $*" >&2
}

# Ensure data directory exists
mkdir -p "$DATA_DIR"

# Helper: fetch URL with error handling
fetch() {
  local url="$1"
  local description="$2"
  local headers="${3:-}"

  log "Fetching $description..."

  local curl_args=(-s -f --max-time "$HTTP_TIMEOUT" -H "Accept: application/json")
  if [[ -n "$headers" ]]; then
    curl_args+=(-H "$headers")
  fi

  local response
  local http_code

  response=$(curl "${curl_args[@]}" -w "\n%{http_code}" "$url" 2>/dev/null) || {
    log "ERROR: Failed to fetch $description from $url"
    echo "{}"
    return 1
  }

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

# DRY_RUN mode: use mock data
if [[ "$DRY_RUN" == "true" ]]; then
  log "DRY_RUN is true. Using mock data."

  MOCK_DATA=$(jq -n \
    --arg date "$TODAY" \
    --arg ts "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" \
    '{
      "collected_at": $ts,
      "date": $date,
      "dry_run": true,
      "tao": {
        "price_usd": 425.50,
        "price_change_24h_pct": 3.2,
        "price_change_7d_pct": 12.5,
        "market_cap_usd": 3200000000,
        "volume_24h_usd": 45000000,
        "circulating_supply": 7520000
      },
      "sn106": {
        "subnet_id": 106,
        "name": "VoidAI / Liquidity Provisioning",
        "rank": 5,
        "mindshare_pct": 2.01,
        "emissions_daily_tao": 12.5,
        "total_stake_tao": 45000,
        "validators": 24,
        "miners": 48,
        "alpha_price_tao": 0.85
      },
      "bridge": {
        "volume_24h_usd": 125000,
        "volume_7d_usd": 890000,
        "transactions_24h": 42,
        "unique_wallets_24h": 28,
        "chains_supported": ["Bittensor", "Solana", "Ethereum", "Base"]
      }
    }')

  echo "$MOCK_DATA" | tee "$OUTPUT_FILE"
  log "Mock metrics saved to $OUTPUT_FILE"
  exit 0
fi

# Check for required env vars
if [[ -z "${TAOSTATS_API_KEY:-}" ]]; then
  log "WARNING: TAOSTATS_API_KEY not set. Taostats data will be empty."
fi

# Fetch CoinGecko TAO data (free, no key needed)
COINGECKO_DATA=$(fetch \
  "$COINGECKO_API_BASE/coins/bittensor?localization=false&tickers=false&community_data=false&developer_data=false" \
  "CoinGecko TAO data") || true

TAO_PRICE=$(echo "$COINGECKO_DATA" | jq '.market_data.current_price.usd // null')
TAO_CHANGE_24H=$(echo "$COINGECKO_DATA" | jq '.market_data.price_change_percentage_24h // null')
TAO_CHANGE_7D=$(echo "$COINGECKO_DATA" | jq '.market_data.price_change_percentage_7d // null')
TAO_MCAP=$(echo "$COINGECKO_DATA" | jq '.market_data.market_cap.usd // null')
TAO_VOLUME=$(echo "$COINGECKO_DATA" | jq '.market_data.total_volume.usd // null')
TAO_SUPPLY=$(echo "$COINGECKO_DATA" | jq '.market_data.circulating_supply // null')

log "TAO price: $TAO_PRICE, 24h change: $TAO_CHANGE_24H%"

# Fetch Taostats SN106 data
TAOSTATS_HEADER=""
if [[ -n "${TAOSTATS_API_KEY:-}" ]]; then
  TAOSTATS_HEADER="Authorization: $TAOSTATS_API_KEY"
fi

SN106_DATA=$(fetch \
  "$TAOSTATS_API_BASE/subnet/latest/v1?netuid=106" \
  "Taostats SN106 data" \
  "$TAOSTATS_HEADER") || true

# Extract SN106 fields from Taostats response (data is in .data[0])
SN106_VALIDATORS=$(echo "$SN106_DATA" | jq '.data[0].validators // .data[0].active_validators // null')
SN106_MINERS=$(echo "$SN106_DATA" | jq '.data[0].active_miners // null')
SN106_ACTIVE_KEYS=$(echo "$SN106_DATA" | jq '.data[0].active_keys // null')
SN106_EMISSION=$(echo "$SN106_DATA" | jq -r '.data[0].emission // "0"')
SN106_TEMPO=$(echo "$SN106_DATA" | jq '.data[0].tempo // null')
SN106_REG_COST=$(echo "$SN106_DATA" | jq -r '.data[0].neuron_registration_cost // "0"')

# Fetch Taostats network stats for staking data
STATS_DATA=$(fetch \
  "$TAOSTATS_API_BASE/stats/latest/v1" \
  "Taostats network stats" \
  "$TAOSTATS_HEADER") || true

TOTAL_STAKED=$(echo "$STATS_DATA" | jq -r '.data[0].staked // "0"')
TOTAL_ISSUED=$(echo "$STATS_DATA" | jq -r '.data[0].issued // "0"')
TOTAL_SUBNETS=$(echo "$STATS_DATA" | jq '.data[0].subnets // null')

# Build combined metrics JSON
TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

COMBINED=$(jq -n \
  --arg date "$TODAY" \
  --arg ts "$TIMESTAMP" \
  --argjson tao_price "$TAO_PRICE" \
  --argjson tao_change_24h "$TAO_CHANGE_24H" \
  --argjson tao_change_7d "$TAO_CHANGE_7D" \
  --argjson tao_mcap "$TAO_MCAP" \
  --argjson tao_volume "$TAO_VOLUME" \
  --argjson tao_supply "$TAO_SUPPLY" \
  --argjson sn106_validators "$SN106_VALIDATORS" \
  --argjson sn106_miners "$SN106_MINERS" \
  --argjson sn106_active_keys "$SN106_ACTIVE_KEYS" \
  --arg sn106_emission "$SN106_EMISSION" \
  --argjson sn106_tempo "$SN106_TEMPO" \
  --arg sn106_reg_cost "$SN106_REG_COST" \
  --arg total_staked "$TOTAL_STAKED" \
  --arg total_issued "$TOTAL_ISSUED" \
  --argjson total_subnets "$TOTAL_SUBNETS" \
  '{
    "collected_at": $ts,
    "date": $date,
    "dry_run": false,
    "tao": {
      "price_usd": $tao_price,
      "price_change_24h_pct": $tao_change_24h,
      "price_change_7d_pct": $tao_change_7d,
      "market_cap_usd": $tao_mcap,
      "volume_24h_usd": $tao_volume,
      "circulating_supply": $tao_supply
    },
    "network": {
      "total_staked_rao": $total_staked,
      "total_issued_rao": $total_issued,
      "total_subnets": $total_subnets
    },
    "sn106": {
      "subnet_id": 106,
      "name": "VoidAI / Liquidity Provisioning",
      "validators": $sn106_validators,
      "miners": $sn106_miners,
      "active_keys": $sn106_active_keys,
      "emission": $sn106_emission,
      "tempo": $sn106_tempo,
      "registration_cost_rao": $sn106_reg_cost
    },
    "bridge": {
      "chains_supported": ["Bittensor", "Solana", "Ethereum", "Base"]
    }
  }')

# Save and output
echo "$COMBINED" | tee "$OUTPUT_FILE"
log "Metrics saved to $OUTPUT_FILE"

# Validate the output has at least some data
NULL_COUNT=$(echo "$COMBINED" | jq '[.. | nulls] | length')
if [[ "$NULL_COUNT" -gt 5 ]]; then
  log "WARNING: $NULL_COUNT null fields in metrics. Some API calls may have failed."
fi
