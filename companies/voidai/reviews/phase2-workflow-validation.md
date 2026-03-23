# Phase 2: Workflow Validation Report

**Date:** 2026-03-15
**Reviewer:** Code Review Agent (Claude Opus 4.6)
**Scope:** Pre-import gate check for all 7 n8n workflow JSON files
**Files:** `/companies/voidai/automations/workflows/workflow-{1..7}-*.json`

---

## Pass/Fail Matrix

| Check | WF1 Daily Metrics | WF2 Bridge Alerts | WF3 Weekly Recap | WF4 Ecosystem News | WF5 Content Scheduler | WF6 Competitor Monitor | WF7 Blog Distribution |
|-------|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| 1. JSON validity | PASS | PASS | PASS | PASS | PASS | PASS | PASS |
| 2. Node graph integrity | PASS | PASS | PASS | PASS | PASS | PASS | PASS |
| 3. No require('fs')/require('path') | PASS | PASS | PASS | PASS | PASS | PASS | PASS |
| 4. $env vars documented | PASS | PASS | PASS | PASS | PASS | PASS | PASS |
| 5. DRY_RUN fail-safe | PASS | PASS | PASS | PASS | PASS | PASS | PASS |
| 6. No hardcoded credentials | PASS | PASS | PASS | PASS | PASS | PASS | PASS |
| 7. Node version compatibility | PASS | PASS | PASS | PASS | PASS | **FAIL** | **FAIL** |
| 8. Trigger type check | PASS | PASS | PASS | PASS | PASS | PASS | PASS |

**Overall: 5 of 7 workflows fully pass. WF6 and WF7 have Merge node configuration issues (see Critical Issues).**

---

## Check 1: JSON Validity

All 7 files parse as valid JSON with no syntax errors.

| File | Status |
|------|--------|
| workflow-1-daily-metrics.json | PASS |
| workflow-2-bridge-alerts.json | PASS |
| workflow-3-weekly-recap.json | PASS |
| workflow-4-ecosystem-news.json | PASS |
| workflow-5-content-scheduler.json | PASS |
| workflow-6-competitor-monitor.json | PASS |
| workflow-7-blog-distribution.json | PASS |

---

## Check 2: Node Graph Integrity

For every connection source and target, verified the corresponding node name exists in the `nodes` array.

### WF1 - Daily Metrics Post
- **Nodes (20):** Daily 10AM ET, Taostats Subnet 106, Taostats Pool, CoinGecko TAO, CoinGecko SN106, Wait For All APIs, Merge Data, Too Many API Failures?, Error: Discord Notify, Format Tweet, DRY_RUN?, DRY_RUN Log, DRY_RUN: Discord Log, Which Posting API?, Post via OpenTweet, Post via X API, Post via Outstand, Check Post Result, Post Succeeded?, Success: Discord Notify, Failure: Discord Notify
- **Connection sources (15):** All match nodes. PASS.
- **Connection targets (21):** All match nodes. PASS.
- **Orphaned references:** None.

### WF2 - Bridge Transaction Alerts
- **Nodes (17):** Webhook: Bridge TX, Cron: Every 15min, Fetch Recent Txs, Amount >= Threshold?, Deduplicate, Rate Limit Check, Rate Limit OK?, Rate Limit: Discord Notify, Format Alert Tweet, Input Valid?, Rejected: Discord Notify, DRY_RUN?, DRY_RUN Log, DRY_RUN: Discord Log, Post Tweet, Discord Notify
- **Connection sources (11):** All match nodes. PASS.
- **Connection targets (14):** All match nodes. PASS.
- **Orphaned references:** None.

### WF3 - Weekly Recap Thread
- **Nodes (14):** Friday 2PM ET, Taostats 7d History, CoinGecko TAO 7d, CoinGecko SN106 7d, Bridge Volume 7d, GitHub Repos, Wait For All APIs, Merge All Data, DRY_RUN?, DRY_RUN Log, DRY_RUN: Discord Log, Claude: Generate Thread, Parse Thread, Write to Drafts Queue, Discord: Review Needed
- **Connection sources (12):** All match nodes. PASS.
- **Connection targets (14):** All match nodes. PASS.
- **Orphaned references:** None.

### WF4 - Ecosystem News Monitor
- **Nodes (15):** Every 4 Hours, RSS: CoinDesk, RSS: The Block, RSS: CoinTelegraph, RSS: DL News, X API Search (disabled), Sanitize RSS Input, Filter + Deduplicate, New Items?, DRY_RUN?, DRY_RUN: Discord Log, Claude: Score + Draft, Parse Score, Score >= 7?, Write to Drafts, Discord: News Alert
- **Connection sources (11):** All match nodes. PASS.
- **Connection targets (12):** All match nodes. PASS.
- **Note:** X API Search node exists in nodes array but is disabled and has no connections. This is intentional (Phase 3).
- **Orphaned references:** None.

### WF5 - Content Calendar Scheduler
- **Nodes (11):** Daily 7AM ET, Read Approved Queue, Filter Today's Items, Items to Schedule?, Enforce Cadence Rules, Assign Posting Times, DRY_RUN?, DRY_RUN Log, Schedule + Move Items, Discord: Schedule Summary
- **Connection sources (9):** All match nodes. PASS.
- **Connection targets (9):** All match nodes. PASS.
- **Orphaned references:** None.

### WF6 - Competitor Monitor
- **Nodes (12):** Daily 8AM ET, X: Competitor Tweets, X: VoidAI Mentions, Taostats: SN106, Wait For All APIs, Merge Intelligence, Claude: Daily Digest, Format Digest, DRY_RUN?, DRY_RUN Log, Discord: DRY_RUN Log, Discord: Intel Digest
- **Connection sources (9):** All match nodes. PASS.
- **Connection targets (10):** All match nodes. PASS.
- **Orphaned references:** None.

### WF7 - Blog Distribution Pipeline
- **Nodes (15):** Webhook: Blog Published, Validate Input, Valid Input?, Sanitize Content, Response: Error, DRY_RUN?, DRY_RUN Log, Discord: DRY_RUN Log, Response: DRY_RUN, Claude: X Thread, Claude: LinkedIn Post, Claude: Discord Announcement, Wait For All Claude, Write All Drafts, Discord: Derivatives Ready, Response: Success
- **Connection sources (11):** All match nodes. PASS.
- **Connection targets (15):** All match nodes. PASS.
- **Orphaned references:** None.

---

## Check 3: No require('fs') or require('path')

Searched all 7 workflow files for `require('fs')`, `require("fs")`, `require('path')`, `require("path")`.

**Result: ZERO matches across all 7 files.** All workflows use n8n static data (`$getWorkflowStaticData`) and Discord webhooks instead of filesystem operations. This is correct for n8n Cloud compatibility.

---

## Check 4: $env Variable Cross-Reference

### Variables found in workflows

| $env Variable | WF1 | WF2 | WF3 | WF4 | WF5 | WF6 | WF7 | In Spec? |
|---------------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:--------:|
| TAOSTATS_API_BASE | x | | x | | | x | | YES |
| TAOSTATS_API_KEY | x | | x | | | x | | YES |
| COINGECKO_API_BASE | x | | x | | | | | YES |
| DRY_RUN | x | x | x | x | x | x | x | YES |
| DISCORD_WEBHOOK_URL | x | x | x | x | x | x | x | YES |
| POSTING_API | x | | | | | | | YES |
| OPENTWEET_API_KEY | x | x | | | | | | YES |
| OUTSTAND_API_BASE | x | | | | | | | YES |
| OUTSTAND_API_KEY | x | | | | | | | YES |
| BRIDGE_MONITOR_URL | | x | x | | | | | YES |
| BRIDGE_TX_THRESHOLD | | x | | | | | | YES |
| GITHUB_ORG | | | x | | | | | YES |
| GITHUB_TOKEN | | | x | | | | | YES |
| CLAUDE_API_KEY | | | x | x | | x | x | YES |
| X_API_BEARER_TOKEN | | | | x | | x | | YES |
| MAX_POSTS_PER_DAY | | | | | x | | | YES |

**Result: All $env variables used in workflows are documented in the spec table.** No undocumented variables found.

### Documented variables NOT used in any workflow

| Variable | Reason |
|----------|--------|
| EMERGENCY_STOP | Documented in spec but NOT implemented in any workflow. See Warning W1 below. |
| COINGECKO_API_KEY | Optional (free tier has no key). CoinGecko requests in WF1/WF3 do not send an API key header. Acceptable. |
| X_API_KEY | Used for OAuth 1.0a credential setup in n8n UI, not in expressions. Acceptable. |
| X_API_SECRET | Same as above. |
| X_ACCESS_TOKEN | Same as above. |
| X_ACCESS_SECRET | Same as above. |
| DISCORD_ANNOUNCE_WEBHOOK | Documented but not used. WF7 Discord announcement uses DISCORD_WEBHOOK_URL. See Warning W2. |
| LOG_FILE_PATH | Replaced by Discord logging for n8n Cloud. Acceptable (legacy). |
| QUEUE_DRAFTS_PATH | Replaced by static data for n8n Cloud. Acceptable (legacy). |
| QUEUE_APPROVED_PATH | Same as above. |
| QUEUE_SCHEDULED_PATH | Same as above. |
| MIN_POST_GAP_MINUTES | Documented but not enforced in any workflow. See Warning W3. |

---

## Check 5: DRY_RUN Fail-Safe

Every workflow must have an IF node checking `$env.DRY_RUN` equals `"false"` (string comparison, not boolean).

| Workflow | IF Node Name | leftValue | operator | rightValue | Fail-Safe Logic |
|----------|-------------|-----------|----------|------------|----------------|
| WF1 | DRY_RUN? | `$env.DRY_RUN` | string equals | `"false"` | PASS: True path = live, False path = dry-run log |
| WF2 | DRY_RUN? | `$env.DRY_RUN` | string equals | `"false"` | PASS: True path = live, False path = dry-run log |
| WF3 | DRY_RUN? | `$env.DRY_RUN` | string equals | `"false"` | PASS: True path = Claude, False path = dry-run log |
| WF4 | DRY_RUN? | `$env.DRY_RUN` | string equals | `"false"` | PASS: True path = Claude, False path = dry-run log |
| WF5 | DRY_RUN? | `$env.DRY_RUN` | string equals | `"false"` | PASS: True path = schedule, False path = dry-run log |
| WF6 | DRY_RUN? | `$env.DRY_RUN` | string equals | `"false"` | PASS: True path = Discord intel, False path = dry-run log |
| WF7 | DRY_RUN? | `$env.DRY_RUN` | string equals | `"false"` | PASS: True path = Claude, False path = dry-run log |

**All 7 workflows correctly implement the DRY_RUN fail-safe.** When DRY_RUN is undefined, empty, or any value other than the exact string "false", the workflow routes to the dry-run path (no publishing).

---

## Check 6: No Hardcoded Credentials

Searched all 7 workflow files for:
- API key patterns (sk-ant-, ghp_, ts_xxxx, ot_xxxx, os_xxxx)
- Hardcoded webhook URLs (discord.com/api/webhooks/[digits])
- Generic credential patterns (api_key/token/secret/password followed by long alphanumeric strings)
- Hardcoded bearer tokens

**Result: ZERO hardcoded credentials found.** All secrets use `$env.VARIABLE_NAME` references.

**Note:** WF1 has one hardcoded URL: `https://api.opentweet.com/v1/tweets` in the "Post via OpenTweet" node. This is a public API endpoint, not a credential. Similarly, `https://api.twitter.com/2/tweets` (WF1 Post via X API) and `https://api.anthropic.com/v1/messages` (WF3, WF4, WF6, WF7) are public API endpoints. Acceptable.

---

## Check 7: Node Version Compatibility

### Node types and versions used

| Node Type | typeVersion | Used In | Standard n8n? |
|-----------|:-----------:|---------|:-------------:|
| n8n-nodes-base.scheduleTrigger | 1.2 | WF1,2,3,4,5,6 | YES |
| n8n-nodes-base.httpRequest | 4.2 | WF1-7 (all) | YES |
| n8n-nodes-base.merge | 3 | WF1,3,6,7 | YES |
| n8n-nodes-base.code | 2 | WF1-7 (all) | YES |
| n8n-nodes-base.if | 2 | WF1-7 (all) | YES |
| n8n-nodes-base.switch | 3 | WF1 | YES |
| n8n-nodes-base.webhook | 2 | WF2,7 | YES |
| n8n-nodes-base.respondToWebhook | 1 | WF7 | YES |

**All node types are standard n8n built-in nodes.** No community or custom nodes detected. All typeVersions are current n8n Cloud versions.

### CRITICAL: Merge Node Configuration Error (WF6, WF7)

**WF6 (Competitor Monitor) and WF7 (Blog Distribution)** have Merge nodes configured with `"combineBy": "waitForAll"`. This is NOT a valid value for the Merge node v3 `combineBy` parameter. The valid options are: `combineAll`, `mergeByFields`, `mergeByPosition`, `multiplex`.

Additionally, these nodes include the parameter `"numberInputs": 3` which is not a standard Merge v3 parameter, and `"mergeByFields": {}` which is irrelevant when mode is `"combine"`.

**WF1 and WF3** correctly use `"combineBy": "combineAll"` with all inputs connected to index 0.

**WF6 and WF7** connect inputs to different indices (0, 1, 2), which is only valid for modes that accept multiple numbered inputs.

**Impact:** On import, n8n may silently fall back to default Merge behavior or throw an error. If it falls back, the Merge node may not wait for all branches, causing the downstream Code node to execute once per branch instead of once with all data. For WF6, this means 3 executions of the Claude API. For WF7, this means 3 executions of Write All Drafts, creating 9 drafts instead of 3.

See Critical Issue C1 below for the fix.

---

## Check 8: Trigger Type Check

| Workflow | Expected Trigger | Actual Trigger | Cron/Webhook | Schedule |
|----------|-----------------|----------------|:------------:|----------|
| WF1 Daily Metrics | Cron (scheduled) | scheduleTrigger | Cron | `0 10 * * *` (10AM daily) |
| WF2 Bridge Alerts | Webhook (event-driven) | webhook + scheduleTrigger (disabled) | Webhook | POST /bridge-tx-alert |
| WF3 Weekly Recap | Cron (scheduled) | scheduleTrigger | Cron | `0 14 * * 5` (Fri 2PM) |
| WF4 Ecosystem News | Cron (scheduled) | scheduleTrigger | Cron | `0 */4 * * *` (every 4h) |
| WF5 Content Scheduler | Cron (scheduled) | scheduleTrigger | Cron | `0 7 * * *` (7AM daily) |
| WF6 Competitor Monitor | Cron (scheduled) | scheduleTrigger | Cron | `0 8 * * *` (8AM daily) |
| WF7 Blog Distribution | Webhook (event-driven) | webhook | Webhook | POST /blog-published |

**All trigger types are appropriate.** WF2 correctly has dual triggers (webhook primary, cron fallback disabled by default).

---

## Critical Issues (Must Fix Before Import)

### C1: Merge node `combineBy: "waitForAll"` is invalid (WF6, WF7)

**Files:**
- `/Users/vew/Apps/Void-AI/companies/voidai/automations/workflows/workflow-6-competitor-monitor.json` (line ~104-118)
- `/Users/vew/Apps/Void-AI/companies/voidai/automations/workflows/workflow-7-blog-distribution.json` (line ~231-244)

**Problem:** `"combineBy": "waitForAll"` is not a valid Merge v3 parameter value. Additionally, `"numberInputs": 3` is not a standard parameter. On import, n8n may reject the node configuration or silently ignore it, causing the downstream Code node to execute once per incoming branch (3x instead of 1x).

**Fix:** Change the Merge node parameters to match WF1/WF3's working pattern:

```json
{
  "parameters": {
    "mode": "combine",
    "combineBy": "combineAll",
    "options": {}
  }
}
```

And change all connections to connect to input index 0 instead of separate indices (0, 1, 2).

For WF6, change:
```json
"X: Competitor Tweets": { "main": [[{ "node": "Wait For All APIs", "type": "main", "index": 0 }]] },
"X: VoidAI Mentions":   { "main": [[{ "node": "Wait For All APIs", "type": "main", "index": 0 }]] },
"Taostats: SN106":      { "main": [[{ "node": "Wait For All APIs", "type": "main", "index": 0 }]] }
```

For WF7, change:
```json
"Claude: X Thread":              { "main": [[{ "node": "Wait For All Claude", "type": "main", "index": 0 }]] },
"Claude: LinkedIn Post":         { "main": [[{ "node": "Wait For All Claude", "type": "main", "index": 0 }]] },
"Claude: Discord Announcement":  { "main": [[{ "node": "Wait For All Claude", "type": "main", "index": 0 }]] }
```

---

## Warnings (Should Fix)

### W1: EMERGENCY_STOP not implemented in any workflow

**Problem:** The spec documents `EMERGENCY_STOP` as a "crisis kill switch" that should halt ALL workflows immediately before any external API call. However, no workflow contains any node or expression that checks `$env.EMERGENCY_STOP`. The kill switch is documented but non-functional.

**Risk:** During a crisis (per `crisis.md`), setting `EMERGENCY_STOP=true` will have no effect. The operator would need to set `DRY_RUN=true` and also deactivate each workflow manually.

**Recommendation:** Add an IF node at the very start of each workflow (right after the trigger) that checks `$env.EMERGENCY_STOP` equals `"true"` and routes to a Discord notification + stop. Alternatively, remove EMERGENCY_STOP from the spec to avoid confusion. Since WF6 and WF7 are Phase 3+ and not yet active, this can be deferred, but WF1-5 should be addressed before soft launch.

### W2: DISCORD_ANNOUNCE_WEBHOOK documented but unused

**Problem:** The spec documents `DISCORD_ANNOUNCE_WEBHOOK` as a separate webhook for the #announcements channel. However, all 7 workflows use only `DISCORD_WEBHOOK_URL` for all Discord notifications. Blog distribution announcements (WF7) go to the same webhook as dry-run logs and error alerts.

**Recommendation:** If you want Discord announcements separated from operational alerts, update the relevant nodes in WF7 (and potentially WF3 for weekly recap notifications) to use `$env.DISCORD_ANNOUNCE_WEBHOOK`.

### W3: MIN_POST_GAP_MINUTES not enforced

**Problem:** The spec documents `MIN_POST_GAP_MINUTES` (default 180, per cadence.md 3-hour gap for @v0idai). WF5's "Enforce Cadence Rules" node enforces daily limits but does not check the gap between posts. WF2's rate limiter counts daily posts but does not check timing gaps.

**Recommendation:** Add gap enforcement to WF5's "Enforce Cadence Rules" code node by checking the last post timestamp stored in static data.

---

## Suggestions (Consider Improving)

### S1: WF2 Bridge Alerts lacks posting API router (unlike WF1)

WF2 hardcodes OpenTweet as the posting API in the "Post Tweet" node. WF1 has a Switch node ("Which Posting API?") that routes to OpenTweet, X API, or Outstand based on `$env.POSTING_API`. If you switch posting APIs, you would need to update WF2 separately.

### S2: WF4 Ecosystem News has no Merge node for parallel RSS fetches

WF4 fans out to 4 RSS feeds in parallel, but all 4 connect directly to "Sanitize RSS Input" at index 0. The Code node inside "Sanitize RSS Input" uses `$(nodeName).first().json` to reference each RSS node by name, which works correctly because it is a named-reference rather than `$input`. However, without a Merge node, the Sanitize node may execute up to 4 times (once per branch). Since the Code node uses named references and produces the same output regardless, this results in 4 identical downstream executions. The deduplication in "Filter + Deduplicate" prevents duplicate posts, but it wastes 3 Claude API calls per cycle for items that score above 7.

**Recommendation:** Add a Merge node (combineAll) between the 4 RSS nodes and "Sanitize RSS Input" to ensure single execution, matching the pattern in WF1 and WF3.

### S3: WF5 references `$env.MAX_POSTS_PER_DAY` inside a jsCode string, not as n8n expression

In WF5's "Enforce Cadence Rules" node, the code references `$env.MAX_POSTS_PER_DAY` as `parseInt($env.MAX_POSTS_PER_DAY || '6', 10)`. This is valid in n8n Code nodes (they have access to `$env`), so it works correctly. No action required, just noting for documentation.

### S4: Consider adding error-handling nodes for Claude API failures in WF3, WF4, WF6, WF7

WF1 has comprehensive error handling (API failure count check, post result verification, failure Discord notify). The Claude-dependent workflows (WF3, WF4, WF6, WF7) set `continueOnFail: true` on their Claude HTTP nodes, but the downstream Code nodes don't always check for error responses before processing. If the Claude API returns a rate limit or error, the parse nodes may silently produce empty/broken drafts.

---

## Summary

| Category | Count |
|----------|------:|
| Critical Issues | 1 (affects WF6 + WF7) |
| Warnings | 3 |
| Suggestions | 4 |
| Workflows fully passing | 5/7 |
| Workflows with issues | 2/7 (WF6, WF7 -- both Phase 3+, not yet active) |

**Import readiness:**
- **WF1-5 (Phase 2 active set): READY FOR IMPORT.** All 5 pass every check.
- **WF6-7 (Phase 3+ designs): BLOCKED.** Fix the Merge node configuration (C1) before importing. Since these are Phase 3+ and will be imported inactive, the fix can be applied before Phase 3 activation, but it is safer to fix now.

---

*Report generated by Code Review Agent. All findings verified against n8n Merge node v3 documentation and workflow JSON source files.*
