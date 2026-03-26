#!/usr/bin/env bash
# publish-telegraph.sh
#
# Creates a Telegraph (telegra.ph) preview page from thread variant JSON.
# Auto-creates and caches TELEGRAPH_TOKEN in .env on first run.
#
# Usage:
#   ./publish-telegraph.sh <variant-json-file> <variant-id> [--title "Custom Title"]
#   echo '{"thread":[...]}' | ./publish-telegraph.sh - v1
#
# Input:  JSON file with thread variant data (from generate-weekly-thread.sh)
#         variant-id: which variant to publish (v1, v2, etc.)
# Output: Telegraph page URL to stdout
#
# Environment:
#   TELEGRAPH_TOKEN   Access token for Telegraph API (auto-created if missing)
#   DRY_RUN           If "true", outputs a mock URL

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

# Preserve caller's DRY_RUN before sourcing .env
_CALLER_DRY_RUN="${DRY_RUN:-}"

if [[ -f "$PROJECT_ROOT/.env" ]]; then
  set -a; source "$PROJECT_ROOT/.env"; set +a
fi

if command -v curl.exe &>/dev/null; then CURL_BIN="curl.exe"; else CURL_BIN="curl"; fi

TELEGRAPH_TOKEN="${TELEGRAPH_TOKEN:-}"
# Caller's explicit DRY_RUN takes precedence over .env
DRY_RUN="${_CALLER_DRY_RUN:-${DRY_RUN:-false}}"

log() { echo "[publish-telegraph] $(date '+%Y-%m-%d %H:%M:%S') $*" >&2; }

# Parse args
TITLE=""
INPUT_FILE=""
VARIANT_ID=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --title) TITLE="$2"; shift 2 ;;
    *)
      if [[ -z "$INPUT_FILE" ]]; then
        INPUT_FILE="$1"
      elif [[ -z "$VARIANT_ID" ]]; then
        VARIANT_ID="$1"
      fi
      shift ;;
  esac
done

if [[ -z "$INPUT_FILE" || -z "$VARIANT_ID" ]]; then
  echo "Usage: $0 <variant-json-file> <variant-id> [--title \"Title\"]" >&2
  exit 1
fi

# DRY_RUN mode (check early, before any network calls or complex parsing)
if [[ "$DRY_RUN" == "true" ]]; then
  log "DRY_RUN: Would publish thread to telegra.ph"
  echo "https://telegra.ph/dry-run-preview-$(date +%H%M%S)"
  exit 0
fi

# Read input
if [[ "$INPUT_FILE" == "-" ]]; then
  INPUT_JSON=$(cat)
else
  if [[ ! -f "$INPUT_FILE" ]]; then
    log "ERROR: File not found: $INPUT_FILE"
    exit 1
  fi
  INPUT_JSON=$(cat "$INPUT_FILE")
fi

# Extract the specific variant's thread content
# Supports both formats:
#   { "variants": [{ "id": "v1", "content": [...] }] }
#   { "thread": [...] }
THREAD_JSON=""
if echo "$INPUT_JSON" | jq -e '.variants' &>/dev/null; then
  THREAD_JSON=$(echo "$INPUT_JSON" | jq -r --arg vid "$VARIANT_ID" \
    '[.variants[] | select(.id == $vid)][0].content // empty')
  if [[ -z "$THREAD_JSON" || "$THREAD_JSON" == "null" ]]; then
    # Try .thread field inside variant
    THREAD_JSON=$(echo "$INPUT_JSON" | jq -r --arg vid "$VARIANT_ID" \
      '[.variants[] | select(.id == $vid)][0].thread // empty')
  fi
elif echo "$INPUT_JSON" | jq -e '.thread' &>/dev/null; then
  THREAD_JSON=$(echo "$INPUT_JSON" | jq '.thread')
elif echo "$INPUT_JSON" | jq -e '.[0].tweet' &>/dev/null; then
  THREAD_JSON="$INPUT_JSON"
fi

if [[ -z "$THREAD_JSON" || "$THREAD_JSON" == "null" ]]; then
  log "ERROR: Could not extract thread content for variant $VARIANT_ID"
  exit 1
fi

# Build page title
if [[ -z "$TITLE" ]]; then
  # Try to extract topic from variant metadata
  TOPIC=$(echo "$INPUT_JSON" | jq -r --arg vid "$VARIANT_ID" \
    '[.variants[] | select(.id == $vid)][0].topic // "Thread Preview"' 2>/dev/null || echo "Thread Preview")
  ACCOUNT=$(echo "$INPUT_JSON" | jq -r '.account // "v0idai"' 2>/dev/null || echo "v0idai")
  TITLE="@${ACCOUNT} Thread: ${TOPIC}"
fi

# Auto-create Telegraph account if no token
if [[ -z "$TELEGRAPH_TOKEN" ]]; then
  log "No TELEGRAPH_TOKEN found. Creating Telegraph account..."
  CREATE_RESPONSE=$($CURL_BIN -s "https://api.telegra.ph/createAccount" \
    -d "short_name=VoidAI" \
    -d "author_name=VoidAI Marketing" \
    -d "author_url=https://x.com/v0idai" 2>/dev/null)

  TELEGRAPH_TOKEN=$(echo "$CREATE_RESPONSE" | jq -r '.result.access_token // empty')

  if [[ -z "$TELEGRAPH_TOKEN" ]]; then
    log "ERROR: Failed to create Telegraph account"
    log "Response: $CREATE_RESPONSE"
    exit 1
  fi

  # Cache token in .env
  if grep -q "^TELEGRAPH_TOKEN=" "$PROJECT_ROOT/.env" 2>/dev/null; then
    sed -i "s|^TELEGRAPH_TOKEN=.*|TELEGRAPH_TOKEN=${TELEGRAPH_TOKEN}|" "$PROJECT_ROOT/.env"
  else
    echo "" >> "$PROJECT_ROOT/.env"
    echo "# Telegraph API token (auto-generated)" >> "$PROJECT_ROOT/.env"
    echo "TELEGRAPH_TOKEN=${TELEGRAPH_TOKEN}" >> "$PROJECT_ROOT/.env"
  fi
  log "Telegraph account created and token saved to .env"
fi

# Build Telegraph content nodes from thread tweets
# Each tweet becomes a paragraph, with the hook tweet bolded
CONTENT_NODES=$(echo "$THREAD_JSON" | jq '
  [.[] | {
    tag: "p",
    children: (
      if (.is_hook == true or .position == 1 or .pos == 1) then
        [{tag: "b", children: [(.tweet // .text)]}]
      else
        [(.tweet // .text)]
      end
    )
  }]
  # Add separator between tweets
  | [foreach .[] as $item (null;
    if . == null then [$item]
    else . + [{tag: "br"}, $item]
    end
  )] | last
')

if [[ -z "$CONTENT_NODES" || "$CONTENT_NODES" == "null" ]]; then
  log "ERROR: Failed to build content nodes"
  exit 1
fi

# Create the Telegraph page
BODY_FILE=$(mktemp)
RESPONSE_FILE=$(mktemp)
trap 'rm -f "$BODY_FILE" "$RESPONSE_FILE"' EXIT

jq -n \
  --arg token "$TELEGRAPH_TOKEN" \
  --arg title "$TITLE" \
  --argjson content "$CONTENT_NODES" \
  --arg author "VoidAI" \
  --arg author_url "https://x.com/v0idai" \
  '{
    access_token: $token,
    title: $title,
    author_name: $author,
    author_url: $author_url,
    content: $content,
    return_content: false
  }' > "$BODY_FILE"

$CURL_BIN -s "https://api.telegra.ph/createPage" \
  -H "Content-Type: application/json" \
  -d @"$BODY_FILE" \
  -o "$RESPONSE_FILE" 2>/dev/null

PAGE_URL=$(jq -r '.result.url // empty' "$RESPONSE_FILE")

if [[ -z "$PAGE_URL" ]]; then
  ERROR_MSG=$(jq -r '.error // "Unknown error"' "$RESPONSE_FILE")
  log "ERROR: Failed to create Telegraph page: $ERROR_MSG"
  exit 1
fi

log "Published: $PAGE_URL"
echo "$PAGE_URL"
