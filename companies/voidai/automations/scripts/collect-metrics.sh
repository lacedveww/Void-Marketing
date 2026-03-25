#!/usr/bin/env bash
# collect-metrics.sh
#
# Collects daily metrics from Taostats API (price + subnet + network stats),
# combines them into a single JSON file for use by generate-daily-tweet.sh
# and generate-weekly-thread.sh.
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
#   TAOSTATS_API_KEY    API key for Taostats (no Bearer prefix)
#   TAOSTATS_API_BASE   Base URL for Taostats API (default: https://api.taostats.io/api)
#   DRY_RUN             If "true", uses mock data instead of real API calls
#   HTTP_TIMEOUT        Curl timeout in seconds (default: 30)
#
# Windows note: uses curl.exe to avoid PowerShell curl alias.

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

TODAY=$(date '+%Y-%m-%d')
OUTPUT_FILE="$DATA_DIR/daily-metrics-${TODAY}.json"

# Use curl.exe on Windows to avoid PowerShell alias; fall back to curl
if command -v curl.exe &>/dev/null; then
  CURL_BIN="curl.exe"
else
  CURL_BIN="curl"
fi

log() {
  echo "[collect-metrics] $(date '+%Y-%m-%d %H:%M:%S') $*" >&2
}

# Ensure data directory exists
mkdir -p "$DATA_DIR"

# Helper: fetch URL with error handling
fetch() {
  local url="$1"
  local description="$2"
  local auth_header="${3:-}"

  log "Fetching $description..."

  local curl_args=(-s --max-time "$HTTP_TIMEOUT" -H "Accept: application/json")
  if [[ -n "$auth_header" ]]; then
    curl_args+=(-H "$auth_header")
  fi

  local response
  response=$("$CURL_BIN" "${curl_args[@]}" -w "\n%{http_code}" "$url" 2>/dev/null) || {
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
        "price_usd": 348.97,
        "price_change_1h_pct": -1.96,
        "price_change_24h_pct": 3.39,
        "price_change_7d_pct": 30.73,
        "price_change_30d_pct": 107.32,
        "market_cap_usd": 3758237847,
        "fully_diluted_market_cap_usd": 7328315642,
        "volume_24h_usd": 1211537033,
        "circulating_supply": 10769595
      },
      "sn106": {
        "subnet_id": 106,
        "name": "VoidAI / Liquidity Provisioning",
        "validators": 11,
        "active_validators": 11,
        "active_miners": 1,
        "active_keys": 256,
        "max_neurons": 256,
        "emission_rao": "0",
        "projected_emission_rao": "0",
        "tempo": 360,
        "fee_rate": "0.00050354772259098192",
        "registration_cost_rao": "133585556570",
        "neuron_registration_cost_rao": "500000",
        "net_flow_1_day_rao": "-188226065369",
        "net_flow_7_days_rao": "-532469113960",
        "net_flow_30_days_rao": "-1230442212340",
        "recycled_lifetime_rao": "43257550282",
        "recycled_24h_rao": "0",
        "alpha_price_tao_estimate": 0.00050354772259098192
      },
      "network": {
        "total_staked_rao": "7353067603457808",
        "total_issued_rao": "10770389433224995",
        "total_subnets": 129
      },
      "bridge": {
        "chains_supported": ["Bittensor", "Solana", "Ethereum", "Base"]
      }
    }')

  echo "$MOCK_DATA" | tee "$OUTPUT_FILE"
  log "Mock metrics saved to $OUTPUT_FILE"
  exit 0
fi

# Check for required env vars
if [[ -z "${TAOSTATS_API_KEY:-}" ]]; then
  log "ERROR: TAOSTATS_API_KEY not set. Cannot fetch Taostats data."
  exit 1
fi

# Auth header: Taostats uses "Authorization: <key>" with NO Bearer prefix
TAOSTATS_HEADER="Authorization: $TAOSTATS_API_KEY"

# --- Fetch TAO price from Taostats ---
TAO_PRICE_DATA=$(fetch \
  "$TAOSTATS_API_BASE/price/latest/v1?asset=tao" \
  "Taostats TAO price" \
  "$TAOSTATS_HEADER") || true

TAO_PRICE=$(echo "$TAO_PRICE_DATA" | jq -r '.data[0].price // "null"')
TAO_CHANGE_1H=$(echo "$TAO_PRICE_DATA" | jq -r '.data[0].percent_change_1h // "null"')
TAO_CHANGE_24H=$(echo "$TAO_PRICE_DATA" | jq -r '.data[0].percent_change_24h // "null"')
TAO_CHANGE_7D=$(echo "$TAO_PRICE_DATA" | jq -r '.data[0].percent_change_7d // "null"')
TAO_CHANGE_30D=$(echo "$TAO_PRICE_DATA" | jq -r '.data[0].percent_change_30d // "null"')
TAO_MCAP=$(echo "$TAO_PRICE_DATA" | jq -r '.data[0].market_cap // "null"')
TAO_FDV=$(echo "$TAO_PRICE_DATA" | jq -r '.data[0].fully_diluted_market_cap // "null"')
TAO_VOLUME=$(echo "$TAO_PRICE_DATA" | jq -r '.data[0].volume_24h // "null"')
TAO_SUPPLY=$(echo "$TAO_PRICE_DATA" | jq -r '.data[0].circulating_supply // "null"')

log "TAO price: \$$TAO_PRICE, 24h change: ${TAO_CHANGE_24H}%"

# --- Fetch SN106 subnet data ---
SN106_DATA=$(fetch \
  "$TAOSTATS_API_BASE/subnet/latest/v1?netuid=106" \
  "Taostats SN106 subnet data" \
  "$TAOSTATS_HEADER") || true

# Extract all SN106 fields from .data[0]
SN106_VALIDATORS=$(echo "$SN106_DATA" | jq '.data[0].validators // null')
SN106_ACTIVE_VALIDATORS=$(echo "$SN106_DATA" | jq '.data[0].active_validators // null')
SN106_ACTIVE_MINERS=$(echo "$SN106_DATA" | jq '.data[0].active_miners // null')
SN106_ACTIVE_KEYS=$(echo "$SN106_DATA" | jq '.data[0].active_keys // null')
SN106_MAX_NEURONS=$(echo "$SN106_DATA" | jq '.data[0].max_neurons // null')
SN106_EMISSION=$(echo "$SN106_DATA" | jq -r '.data[0].emission // "0"')
SN106_PROJECTED_EMISSION=$(echo "$SN106_DATA" | jq -r '.data[0].projected_emission // "0"')
SN106_TEMPO=$(echo "$SN106_DATA" | jq '.data[0].tempo // null')
SN106_FEE_RATE=$(echo "$SN106_DATA" | jq -r '.data[0].fee_rate // "0"')
SN106_REG_COST=$(echo "$SN106_DATA" | jq -r '.data[0].registration_cost // "0"')
SN106_NEURON_REG_COST=$(echo "$SN106_DATA" | jq -r '.data[0].neuron_registration_cost // "0"')
SN106_NET_FLOW_1D=$(echo "$SN106_DATA" | jq -r '.data[0].net_flow_1_day // "0"')
SN106_NET_FLOW_7D=$(echo "$SN106_DATA" | jq -r '.data[0].net_flow_7_days // "0"')
SN106_NET_FLOW_30D=$(echo "$SN106_DATA" | jq -r '.data[0].net_flow_30_days // "0"')
SN106_RECYCLED_LIFETIME=$(echo "$SN106_DATA" | jq -r '.data[0].recycled_lifetime // "0"')
SN106_RECYCLED_24H=$(echo "$SN106_DATA" | jq -r '.data[0].recycled_24_hours // "0"')
SN106_EMA_TAO_FLOW=$(echo "$SN106_DATA" | jq -r '.data[0].ema_tao_flow // "0"')
SN106_TAO_FLOW=$(echo "$SN106_DATA" | jq -r '.data[0].tao_flow // "0"')

log "SN106 validators: $SN106_VALIDATORS, active miners: $SN106_ACTIVE_MINERS, fee_rate: $SN106_FEE_RATE"

# --- Fetch network stats ---
STATS_DATA=$(fetch \
  "$TAOSTATS_API_BASE/stats/latest/v1" \
  "Taostats network stats" \
  "$TAOSTATS_HEADER") || true

TOTAL_STAKED=$(echo "$STATS_DATA" | jq -r '.data[0].staked // "0"')
TOTAL_ISSUED=$(echo "$STATS_DATA" | jq -r '.data[0].issued // "0"')
TOTAL_SUBNETS=$(echo "$STATS_DATA" | jq '.data[0].subnets // null')

log "Network: staked=$TOTAL_STAKED, issued=$TOTAL_ISSUED, subnets=$TOTAL_SUBNETS"

# --- Compute alpha price estimate ---
# fee_rate from subnet endpoint serves as an exchange rate proxy (TAO per alpha token).
# Multiply by TAO price to get USD estimate.
ALPHA_PRICE_TAO="$SN106_FEE_RATE"
if [[ "$TAO_PRICE" != "null" && "$ALPHA_PRICE_TAO" != "0" ]]; then
  ALPHA_PRICE_USD=$(echo "$ALPHA_PRICE_TAO $TAO_PRICE" | awk '{printf "%.6f", $1 * $2}')
else
  ALPHA_PRICE_USD="null"
fi

log "SN106 alpha price estimate: $ALPHA_PRICE_TAO TAO (~\$$ALPHA_PRICE_USD USD)"

# --- Build combined metrics JSON ---
TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

COMBINED=$(jq -n \
  --arg date "$TODAY" \
  --arg ts "$TIMESTAMP" \
  --arg tao_price "$TAO_PRICE" \
  --arg tao_change_1h "$TAO_CHANGE_1H" \
  --arg tao_change_24h "$TAO_CHANGE_24H" \
  --arg tao_change_7d "$TAO_CHANGE_7D" \
  --arg tao_change_30d "$TAO_CHANGE_30D" \
  --arg tao_mcap "$TAO_MCAP" \
  --arg tao_fdv "$TAO_FDV" \
  --arg tao_volume "$TAO_VOLUME" \
  --arg tao_supply "$TAO_SUPPLY" \
  --argjson sn106_validators "$SN106_VALIDATORS" \
  --argjson sn106_active_validators "$SN106_ACTIVE_VALIDATORS" \
  --argjson sn106_active_miners "$SN106_ACTIVE_MINERS" \
  --argjson sn106_active_keys "$SN106_ACTIVE_KEYS" \
  --argjson sn106_max_neurons "$SN106_MAX_NEURONS" \
  --arg sn106_emission "$SN106_EMISSION" \
  --arg sn106_projected_emission "$SN106_PROJECTED_EMISSION" \
  --argjson sn106_tempo "$SN106_TEMPO" \
  --arg sn106_fee_rate "$SN106_FEE_RATE" \
  --arg sn106_reg_cost "$SN106_REG_COST" \
  --arg sn106_neuron_reg_cost "$SN106_NEURON_REG_COST" \
  --arg sn106_net_flow_1d "$SN106_NET_FLOW_1D" \
  --arg sn106_net_flow_7d "$SN106_NET_FLOW_7D" \
  --arg sn106_net_flow_30d "$SN106_NET_FLOW_30D" \
  --arg sn106_recycled_lifetime "$SN106_RECYCLED_LIFETIME" \
  --arg sn106_recycled_24h "$SN106_RECYCLED_24H" \
  --arg sn106_ema_tao_flow "$SN106_EMA_TAO_FLOW" \
  --arg sn106_tao_flow "$SN106_TAO_FLOW" \
  --arg alpha_price_tao "$ALPHA_PRICE_TAO" \
  --arg alpha_price_usd "$ALPHA_PRICE_USD" \
  --arg total_staked "$TOTAL_STAKED" \
  --arg total_issued "$TOTAL_ISSUED" \
  --argjson total_subnets "$TOTAL_SUBNETS" \
  '{
    "collected_at": $ts,
    "date": $date,
    "dry_run": false,
    "tao": {
      "price_usd": ($tao_price | tonumber? // null),
      "price_change_1h_pct": ($tao_change_1h | tonumber? // null),
      "price_change_24h_pct": ($tao_change_24h | tonumber? // null),
      "price_change_7d_pct": ($tao_change_7d | tonumber? // null),
      "price_change_30d_pct": ($tao_change_30d | tonumber? // null),
      "market_cap_usd": ($tao_mcap | tonumber? // null),
      "fully_diluted_market_cap_usd": ($tao_fdv | tonumber? // null),
      "volume_24h_usd": ($tao_volume | tonumber? // null),
      "circulating_supply": ($tao_supply | tonumber? // null)
    },
    "sn106": {
      "subnet_id": 106,
      "name": "VoidAI / Liquidity Provisioning",
      "validators": $sn106_validators,
      "active_validators": $sn106_active_validators,
      "active_miners": $sn106_active_miners,
      "active_keys": $sn106_active_keys,
      "max_neurons": $sn106_max_neurons,
      "emission_rao": $sn106_emission,
      "projected_emission_rao": $sn106_projected_emission,
      "tempo": $sn106_tempo,
      "fee_rate": $sn106_fee_rate,
      "registration_cost_rao": $sn106_reg_cost,
      "neuron_registration_cost_rao": $sn106_neuron_reg_cost,
      "net_flow_1_day_rao": $sn106_net_flow_1d,
      "net_flow_7_days_rao": $sn106_net_flow_7d,
      "net_flow_30_days_rao": $sn106_net_flow_30d,
      "recycled_lifetime_rao": $sn106_recycled_lifetime,
      "recycled_24h_rao": $sn106_recycled_24h,
      "ema_tao_flow": $sn106_ema_tao_flow,
      "tao_flow": $sn106_tao_flow,
      "alpha_price_tao_estimate": $alpha_price_tao,
      "alpha_price_usd_estimate": $alpha_price_usd
    },
    "network": {
      "total_staked_rao": $total_staked,
      "total_issued_rao": $total_issued,
      "total_subnets": $total_subnets
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
