# Phase 2 Final Test Challenge Report

**Reviewer**: Code Reviewer (claude-opus-4-6)
**Date**: 2026-03-15
**Verdict**: CONDITIONAL PASS (1 critical blocker, 3 warnings, 3 suggestions)

---

## Test Results Verification

### collect-metrics.sh LIVE test: PASS

File: `/Users/vew/Apps/Void-AI/companies/voidai/automations/data/daily-metrics-2026-03-15.json`

- TAO price $274.49, 7d change 49.50%, market cap $2.63B: all present and plausible
- SN106: 12 validators, 1 miner, 256 active keys: all non-null
- Network staked/issued rao values: present as strings (correct for large ints)
- `dry_run: false` confirms real API data
- No null critical fields (tao.price_usd, sn106.validators, sn106.active_keys all populated)

### claude -p tests: PASS (per user report)

- Basic, content, and piped data tests all passed as described.

### post-to-x.sh tests: PASS (per user report)

- DRY_RUN single/thread outputs confirmed correct
- Live OpenTweet post created (ID: 69b774f89ed4480bced1b928) then deleted

---

## Script Review: 6 Scripts

### Check 1: DRY_RUN Precedence Fix

All 6 scripts implement the same correct pattern:

```
_CALLER_DRY_RUN="${DRY_RUN:-}"
source "$PROJECT_ROOT/.env"
DRY_RUN="${_CALLER_DRY_RUN:-${DRY_RUN:-true}}"
```

Caller env overrides .env. Default is `true` (safe). **PASS** on all 6.

### Check 2: Error Handling

- `set -euo pipefail` on all 6 scripts: **PASS**
- collect-metrics.sh: `fetch()` returns `{}` on failure, logs error, uses `|| true` so pipeline continues with partial data. Validates null count at end. **PASS**
- collect-news.sh: RSS fetch failures logged and skipped with `continue`. **PASS**
- generate-daily-tweet.sh: validates file exists, validates JSON, validates claude output, checks tweet length, checks banned phrases. **PASS**
- generate-news-tweet.sh: same validation chain. **PASS**
- generate-weekly-thread.sh: validates each tweet in thread individually. **PASS**
- post-to-x.sh: checks API key, validates HTTP status, validates thread JSON. **PASS**

### Check 3: No Hardcoded Secrets in Scripts

All 6 scripts read secrets from environment variables sourced from .env. No API keys, tokens, or passwords appear in any script. **PASS**

### Check 4: No Em Dashes or Double Hyphens (in content/prose)

The `--` occurrences in scripts are all CLI flags (`--arg`, `--thread`, `--schedule`, `--max-time`, etc.) and grep patterns, not prose content. No em dashes (unicode U+2013 or U+2014) found. **PASS**

### Check 5: jq Field Paths Match API Responses

- CoinGecko: `.market_data.current_price.usd`, `.market_data.price_change_percentage_24h`, etc. These are standard CoinGecko `/coins/{id}` response fields. **PASS**
- Taostats: `.data[0].validators`, `.data[0].active_miners`, `.data[0].active_keys`, `.data[0].emission`, `.data[0].tempo`, `.data[0].neuron_registration_cost`. The `.data[0]` prefix is correct for Taostats `v1` endpoints. Confirmed by live output showing real values. **PASS**
- Taostats stats: `.data[0].staked`, `.data[0].issued`, `.data[0].subnets`. **PASS**

### Check 6: OpenTweet Response Parsing (.posts[0].id)

In `opentweet_post()` at line 96: `jq -r '.posts[0].id // .id // empty'`. Uses `.posts[0].id` as primary with `.id` as fallback. **PASS**

However, the callers at lines 172 and 234 use `jq -r '.id // "none"'` to extract the post ID from the function's output. Since `opentweet_post()` echoes the raw API response body (line 98), these callers should also use `.posts[0].id` as the primary path. See Warning W1 below.

---

## Issues

### CRITICAL (must fix before push)

**C1: Secrets hardcoded in openclaw-setup.md**

File: `/Users/vew/Apps/Void-AI/companies/voidai/automations/openclaw-setup.md`, lines 233-238

The "Environment Variables" section contains plaintext API keys, tokens, and webhook URLs:
- Gemini API key
- Taostats API key
- GitHub PAT
- OpenTweet API key
- Telegram bot token
- Discord webhook URL

This file is NOT in `.gitignore`. Pushing to GitHub will expose all credentials publicly. This is a **blocker**.

**Fix**: Replace section 7 with placeholder references:

```
export GEMINI_API_KEY="<from .env>"
export TAOSTATS_API_KEY="<from .env>"
export GITHUB_TOKEN="<from .env>"
export OPENTWEET_API_KEY="<from .env>"
export TELEGRAM_BOT_TOKEN="<from .env>"
export DISCORD_WEBHOOK_URL="<from .env>"
```

Or add the file to `.gitignore`. Or both.

---

### WARNINGS (should fix)

**W1: post-to-x.sh post_id extraction mismatch between function and callers**

File: `/Users/vew/Apps/Void-AI/companies/voidai/automations/scripts/post-to-x.sh`

`opentweet_post()` (line 96) correctly parses `.posts[0].id // .id`, but the callers at line 172 and line 234 parse the returned response with only `.id // "none"`. Since `opentweet_post()` returns the raw API body, these callers will get `"none"` for the post_id in the final JSON output when the API returns the `.posts[0].id` format. This means the reported `post_id` in the output JSON will be wrong even though the post succeeded.

**Fix**: Change lines 172 and 234 from:
```
POST_ID=$(echo "$RESULT" | jq -r '.id // "none"')
```
to:
```
POST_ID=$(echo "$RESULT" | jq -r '.posts[0].id // .id // "none"')
```

**W2: generate-news-tweet.sh missing em-dash unicode check**

File: `/Users/vew/Apps/Void-AI/companies/voidai/automations/scripts/generate-news-tweet.sh`, line 218

Only checks for double hyphens (`\-\-`), not unicode em-dashes. Compare with `generate-daily-tweet.sh` line 239 which checks both: `grep -qP '\x{2014}|\x{2013}'`. The weekly thread script at line 211 also only checks double hyphens.

**Fix**: Add the same em-dash check from generate-daily-tweet.sh to both generate-news-tweet.sh and generate-weekly-thread.sh.

**W3: generate-news-tweet.sh missing banned-phrase scan**

File: `/Users/vew/Apps/Void-AI/companies/voidai/automations/scripts/generate-news-tweet.sh`

Only checks for double hyphens (line 218). Does NOT check for any of the banned phrases list ("It's worth noting", "paradigm shift", etc.) that generate-daily-tweet.sh checks at lines 213-236. A news tweet could pass with a banned phrase and only show `pending_review` instead of `flagged_banned_phrase`.

**Fix**: Add the same banned-phrase loop from generate-daily-tweet.sh.

---

### SUGGESTIONS (consider improving)

**S1: collect-metrics.sh fetch() uses `-f` with `-w` causing unreachable code**

File: `/Users/vew/Apps/Void-AI/companies/voidai/automations/scripts/collect-metrics.sh`, lines 65-96

`curl -f` causes curl to fail silently on HTTP errors (4xx/5xx), which triggers the `|| {` error handler at line 73. This means the HTTP status code parsing at lines 79-96 will never see a non-2xx code because curl already failed. The `if [[ "$http_code" -ge 200 ...]]` branch at line 83 is the only reachable path. Not a bug (errors are still caught), but the status-code validation logic is dead code.

**S2: collect-news.sh RSS parser is fragile with multiline fields**

File: `/Users/vew/Apps/Void-AI/companies/voidai/automations/scripts/collect-news.sh`, lines 117-190

The awk parser only captures `<title>`, `<link>`, `<description>`, and `<pubDate>` when the opening and closing tags are on the same line. Multiline `<description>` blocks (common in RSS) will be truncated. This is acknowledged in the comment ("intentionally simple") but worth noting for Phase 3 if news coverage seems incomplete.

**S3: generate-weekly-thread.sh thread JSON extraction is greedy**

File: `/Users/vew/Apps/Void-AI/companies/voidai/automations/scripts/generate-weekly-thread.sh`, line 178

`grep -oE '\[.*\]'` is greedy and will match from the first `[` to the last `]` on the line. After `tr '\n' ' '` this is one line, so if Claude's output contains any extra brackets, it could grab too much. Not likely to cause issues in practice since the output is validated with `jq empty` immediately after, but a more precise extraction (like using `python -c` or `jq -R`) would be more robust.

---

## OpenClaw Setup Guide Review

File: `/Users/vew/Apps/Void-AI/companies/voidai/automations/openclaw-setup.md`

Apart from the critical secret exposure (C1 above), the guide is complete and accurate:

- Prerequisites: correct list of required tokens/keys
- Messaging architecture: dual approach (OpenClaw two-way + webhooks one-way) clearly explained
- Config structure: valid json5 for openclaw.json
- All 5 cron jobs defined with correct script paths and sequencing
- Emergency stop procedure included
- Testing instructions included
- Migration checklist is thorough (18 items)
- Quick reference table accurate

One minor note: the cron job messages reference `$(date +%Y-%m-%d)` which needs to be evaluated at cron runtime, not at `openclaw cron add` time. Verify that OpenClaw's cron runner evaluates shell substitutions in `--message` strings. If not, this would need to be handled differently (e.g., the script itself determines the date, which it already does).

---

## Summary

| Area | Verdict |
|------|---------|
| collect-metrics.sh | PASS |
| collect-news.sh | PASS |
| generate-daily-tweet.sh | PASS |
| generate-news-tweet.sh | PASS (W2, W3 recommended) |
| generate-weekly-thread.sh | PASS (W2 recommended) |
| post-to-x.sh | PASS (W1 recommended) |
| Test data verification | PASS |
| openclaw-setup.md | FAIL (C1: secrets exposed) |

**Overall: CONDITIONAL PASS. Fix C1 (remove secrets from openclaw-setup.md) before pushing to GitHub. W1 through W3 are recommended but not blockers.**
