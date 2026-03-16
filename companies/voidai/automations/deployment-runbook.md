# n8n Deployment Runbook: VoidAI Marketing Automation

**Status:** CURRENT
**Created:** 2026-03-15
**Target Instance:** https://vew.app.n8n.cloud
**Canonical for:** Importing, configuring, testing, and going live with n8n workflows
**Dependencies:** `n8n-workflow-specs.md` (workflow specs), `pipeline-architecture.md` (system design), `crisis.md` (kill switch), `cadence.md` (timing rules)
**Constraint:** n8n Cloud FREE tier = max 5 active workflows. WF1 through WF5 are active. WF6 and WF7 stay inactive until Phase 3+.

---

## Table of Contents

1. [Pre-Deployment Checklist](#1-pre-deployment-checklist)
2. [Environment Variables](#2-environment-variables)
3. [Import Order](#3-import-order)
4. [Step-by-Step Import](#4-step-by-step-import)
5. [Credential Configuration](#5-credential-configuration)
6. [DRY_RUN Testing Phase](#6-dry_run-testing-phase)
7. [Go-Live Procedure](#7-go-live-procedure)
8. [Rollback Plan](#8-rollback-plan)
9. [Post-Deploy Monitoring](#9-post-deploy-monitoring)
10. [EMERGENCY_STOP Quick Reference](#10-emergency_stop-quick-reference)

---

## 1. Pre-Deployment Checklist

Complete every item below before importing any workflow into n8n Cloud. Check them off in order.

### 1.1 Git State

- [ ] All 7 workflow JSON files are committed to the repo under `companies/voidai/automations/workflows/`
- [ ] `n8n-workflow-specs.md` is committed and matches the current workflow JSON files
- [ ] `pipeline-architecture.md` is committed and up to date
- [ ] `crisis.md` is committed (contains EMERGENCY_STOP procedure)
- [ ] No uncommitted changes that would affect workflow behavior

### 1.2 Workflow Validation

- [ ] Each workflow JSON file opens without errors in a JSON validator
- [ ] Every workflow contains the DRY_RUN check node with fail-safe logic (only publishes when DRY_RUN is strictly the string `false`)
- [ ] WF2 and WF7 webhook triggers have `"authentication": "headerAuth"` set
- [ ] WF1 contains the Merge node ("Wait For All APIs") between the 4 API calls and the Merge Data code node
- [ ] WF3 contains the Merge node between the 5 API calls and the Merge All Data code node
- [ ] WF6 contains the Merge node between the 3 data sources and the Merge Intelligence code node
- [ ] WF7 contains the Merge node between the 3 Claude API calls and the Write All Drafts code node
- [ ] WF4's X API Search node is set to `"disabled": true` (requires X API Basic, Phase 3)
- [ ] WF2's Cron trigger is set to `"disabled": true` (webhook is the preferred trigger)

### 1.3 Credentials Ready

Before import, confirm you have the following credentials accessible:

- [ ] Taostats API key (`ts_xxxx`) from https://taostats.io
- [ ] CoinGecko API key (optional for free tier; needed for demo key)
- [ ] OpenTweet API key (`ot_xxxx`) from https://opentweet.com (7-day trial active). **WARNING: Current key expires 2026-03-22.** Renew or migrate to X API Basic before that date.
- [ ] Anthropic Claude API key (`sk-ant-xxxx`) from https://console.anthropic.com
- [ ] Discord webhook URL for the Vew notifications channel
- [ ] GitHub Personal Access Token (`ghp_xxxx`) with `repo` scope for the VoidAI org
- [ ] Bridge Monitor URL confirmed reachable (or a placeholder if not yet deployed)
- [ ] Header Auth secret value generated (minimum 32 random characters) for WF2 and WF7 webhooks

### 1.4 n8n Instance Configuration

- [ ] You can log into https://vew.app.n8n.cloud
- [ ] Instance timezone is set to `America/New_York` (Settings > General)
- [ ] You know where Settings > Variables is located (this is where all env vars go)
- [ ] You know where Settings > Workflows > Error Workflow is located

---

## 2. Environment Variables

Every variable listed below must be set in n8n Cloud at Settings > Variables before activating any workflow.

### 2.1 Complete Variable Matrix

#### Phase 2 Variables (Required for WF1 through WF5)

| Variable | Used By | Where to Get Value | Initial Value |
|----------|---------|-------------------|---------------|
| `EMERGENCY_STOP` | All workflows (checked in crisis.md Emergency Stop code node) | Set manually | `false` |
| `DRY_RUN` | WF1, WF2, WF3, WF4, WF5, WF6, WF7 | Set manually | `true` |
| `POSTING_API` | WF1 (Switch node routes to posting endpoint) | Set manually | `opentweet` |
| `TAOSTATS_API_BASE` | WF1, WF3, WF6 | Taostats docs: `https://api.taostats.io/api` | `https://api.taostats.io/api` |
| `TAOSTATS_API_KEY` | WF1, WF3, WF6 | Taostats account dashboard | `ts_xxxx` (your key) |
| `COINGECKO_API_BASE` | WF1, WF3 | CoinGecko docs | `https://api.coingecko.com/api/v3` |
| `COINGECKO_API_KEY` | WF1 (optional header) | CoinGecko demo key page (empty for free tier) | (empty string or demo key) |
| `OPENTWEET_API_KEY` | WF1, WF2 | OpenTweet dashboard. **Expires 2026-03-22.** | `ot_xxxx` (your key) |
| `CLAUDE_API_KEY` | WF3, WF4, WF6, WF7 | Anthropic Console > API Keys | `sk-ant-xxxx` (your key) |
| `DISCORD_WEBHOOK_URL` | WF1, WF2, WF3, WF4, WF5, WF6, WF7 | Discord > Server Settings > Integrations > Webhooks | Full webhook URL |
| `GITHUB_TOKEN` | WF3 | GitHub > Settings > Developer > PATs | `ghp_xxxx` (your PAT) |
| `GITHUB_ORG` | WF3 | Your GitHub org name | `voidai` |
| `BRIDGE_MONITOR_URL` | WF2, WF3 | Your Tracker/FastAPI deployment | `http://localhost:8000/api/bridge/recent` (update when deployed) |
| `BRIDGE_TX_THRESHOLD` | WF2 | Set per business rules | `100` |
| `LOG_FILE_PATH` | Spec reference (not used by Cloud-adapted workflows; kept for compatibility) | N/A | `/data/n8n/dry-run-logs/` |
| `QUEUE_DRAFTS_PATH` | Spec reference (static data used instead on Cloud) | N/A | `/data/voidai/queue/drafts/` |
| `QUEUE_APPROVED_PATH` | Spec reference (static data used instead on Cloud) | N/A | `/data/voidai/queue/approved/` |
| `QUEUE_SCHEDULED_PATH` | Spec reference (static data used instead on Cloud) | N/A | `/data/voidai/queue/scheduled/` |
| `MAX_POSTS_PER_DAY` | WF5 | Per cadence.md | `6` |
| `MIN_POST_GAP_MINUTES` | Spec reference (cadence enforcement) | Per cadence.md | `180` |

#### Phase 3+ Variables (Required for WF6, WF7, and production posting)

| Variable | Used By | Where to Get Value | Initial Value |
|----------|---------|-------------------|---------------|
| `X_API_BEARER_TOKEN` | WF4 (disabled node), WF6 | X Developer Portal > Project > Keys | `AAAA...` (your bearer token) |
| `X_API_KEY` | WF1 (X API posting path) | X Developer Portal > Project > Consumer Keys | (your consumer key) |
| `X_API_SECRET` | WF1 (X API posting path) | X Developer Portal > Project > Consumer Keys | (your consumer secret) |
| `X_ACCESS_TOKEN` | WF1 (X API posting path) | X Developer Portal > OAuth 1.0a | (your access token) |
| `X_ACCESS_SECRET` | WF1 (X API posting path) | X Developer Portal > OAuth 1.0a | (your access token secret) |
| `OUTSTAND_API_KEY` | WF1 (Outstand posting path) | Outstand dashboard (when available) | (placeholder) |
| `OUTSTAND_API_BASE` | WF1 (Outstand posting path) | Outstand docs (when available) | `https://api.outstand.com/v1` |
| `DISCORD_ANNOUNCE_WEBHOOK` | WF7 (Discord announcement channel) | Discord > Announcements channel webhook | Full webhook URL |

### 2.2 Setting Variables in n8n Cloud

1. Log into https://vew.app.n8n.cloud
2. Click the gear icon (bottom left) to open Settings
3. Click "Variables" in the left sidebar
4. For each variable in the table above:
   a. Click "Add Variable"
   b. Enter the variable name exactly as shown (case-sensitive)
   c. Enter the value
   d. Click Save
5. After adding all variables, scroll through the list to verify every variable has a value (no blanks except for intentionally empty ones like `COINGECKO_API_KEY`)

**Critical safety check:** Confirm `EMERGENCY_STOP` is `false` and `DRY_RUN` is `true` before proceeding.

---

## 3. Import Order

Workflows must be imported in a specific order due to dependencies, naming references, and risk levels.

### 3.1 Dependency Map

```
WF5 (Content Scheduler) depends on: WF3 and WF4 drafts in static data
WF3 (Weekly Recap) depends on: Same APIs as WF1 (Taostats, CoinGecko)
WF4 (News Monitor) depends on: No other workflows
WF2 (Bridge Alerts) depends on: External webhook sender (Tracker/FastAPI)
WF1 (Daily Metrics) depends on: No other workflows
WF6 (Competitor Monitor) depends on: X API Basic (Phase 3+)
WF7 (Blog Distribution) depends on: External webhook sender (CMS)
```

### 3.2 Recommended Import Order

| Order | Workflow | File | Reason |
|-------|----------|------|--------|
| 1 | WF1: Daily Metrics Post | `workflow-1-daily-metrics.json` | Simplest workflow, no external dependencies, best for validating env vars and API connectivity |
| 2 | WF4: Ecosystem News Monitor | `workflow-4-ecosystem-news.json` | RSS feeds are public, no auth needed for data fetch. Good second validation of Claude API key |
| 3 | WF3: Weekly Recap Thread | `workflow-3-weekly-recap.json` | Uses same Taostats/CoinGecko APIs as WF1 (already validated), plus GitHub API |
| 4 | WF2: Bridge Transaction Alerts | `workflow-2-bridge-alerts.json` | Webhook-triggered, requires Header Auth credential setup. Import after simpler workflows pass |
| 5 | WF5: Content Calendar Scheduler | `workflow-5-content-scheduler.json` | Depends on drafts from WF3 and WF4 being in static data. Import last among the active five |
| 6 | WF6: Competitor Monitor | `workflow-6-competitor-monitor.json` | Phase 3+. Import and leave INACTIVE. Requires X API Basic ($200/mo) |
| 7 | WF7: Blog Distribution Pipeline | `workflow-7-blog-distribution.json` | Phase 3+. Import and leave INACTIVE. Requires webhook sender (CMS) |

---

## 4. Step-by-Step Import

Repeat this procedure for each workflow in the order specified in Section 3.

### 4.1 Import a Single Workflow

1. Open https://vew.app.n8n.cloud in your browser
2. Click "Workflows" in the left sidebar
3. Click the "Add Workflow" button (top right, or the + icon)
4. In the new empty workflow editor, click the three-dot menu (top right corner of the canvas area)
5. Select "Import from File..."
6. Navigate to the workflow JSON file on your local machine:
   - Path: `companies/voidai/automations/workflows/workflow-N-name.json`
7. Select the file and click Open
8. The workflow canvas should populate with all nodes and connections
9. Verify the workflow name appears correctly in the top bar (e.g., "VoidAI - Daily Metrics Post")

### 4.2 Post-Import Verification (Per Workflow)

After importing each workflow, verify these items before moving on:

- [ ] All nodes are visible on the canvas (no missing node errors)
- [ ] No red error badges appear on any node
- [ ] Click on each HTTP Request node and verify the URL field shows the `{{ $env.VARIABLE_NAME }}` expression (not a hardcoded URL)
- [ ] Click on the DRY_RUN? IF node and verify the condition checks `{{ $env.DRY_RUN }}` equals `false`
- [ ] Check the trigger node (Cron or Webhook) configuration matches the spec
- [ ] For WF2 and WF7: verify the webhook trigger shows "Header Auth" in the authentication field (credential will be assigned in Section 5)
- [ ] Save the workflow (Ctrl+S or Cmd+S)

### 4.3 Activation Rules

| Workflow | Activate After Import? | Why |
|----------|----------------------|-----|
| WF1 | NO, not yet | Wait until all 5 workflows are imported and tested per Section 6 |
| WF2 | NO, not yet | Same as above |
| WF3 | NO, not yet | Same as above |
| WF4 | NO, not yet | Same as above |
| WF5 | NO, not yet | Same as above |
| WF6 | NO, never during Phase 2 | Phase 3+ only. Leave inactive. |
| WF7 | NO, never during Phase 2 | Phase 3+ only. Leave inactive. |

Do NOT activate any workflow until Section 6 (DRY_RUN Testing) is complete.

---

## 5. Credential Configuration

After all 7 workflows are imported, configure the credentials they reference.

### 5.1 Header Auth Credential (WF2 and WF7)

Both WF2 (Bridge Transaction Alerts) and WF7 (Blog Distribution Pipeline) use `headerAuth` on their webhook triggers to prevent unauthorized callers from invoking the workflow.

**Steps:**

1. In n8n, go to the Credentials page (left sidebar, key icon)
2. Click "Add Credential"
3. Search for and select "Header Auth"
4. Configure:
   - **Name:** `VoidAI Webhook Secret`
   - **Header Name:** `X-Webhook-Secret`
   - **Header Value:** Generate a random 32+ character string. Example method: open a terminal and run `openssl rand -hex 32`. Copy the output.
5. Save the credential
6. Open WF2 ("VoidAI - Bridge Transaction Alerts") in the editor
7. Click on the "Webhook: Bridge TX" trigger node
8. In the "Credential for Header Auth" dropdown, select "VoidAI Webhook Secret"
9. Save the workflow
10. Open WF7 ("VoidAI - Blog Distribution Pipeline") in the editor
11. Click on the "Webhook: Blog Published" trigger node
12. In the "Credential for Header Auth" dropdown, select "VoidAI Webhook Secret"
13. Save the workflow

**Important:** Store the header value securely. You will need to configure the sending services (Tracker/FastAPI for WF2, CMS for WF7) to include this exact header and value in every POST request. Without it, n8n will reject the request with HTTP 401.

### 5.2 OAuth 1.0a Credential (WF1, Phase 3+ only)

WF1's "Post via X API" node requires OAuth 1.0a credentials. This is only needed when `POSTING_API=x_api` (Phase 3+). For Phase 2 testing with OpenTweet, this step can be deferred.

**Steps (when ready for Phase 3):**

1. Go to Credentials > Add Credential
2. Search for "Twitter OAuth API" (or "Header Auth" depending on n8n version)
3. Configure:
   - **Consumer Key:** Value of `X_API_KEY` env var
   - **Consumer Secret:** Value of `X_API_SECRET` env var
   - **Access Token:** Value of `X_ACCESS_TOKEN` env var
   - **Access Token Secret:** Value of `X_ACCESS_SECRET` env var
4. Save the credential
5. Open WF1, click the "Post via X API" node, assign this credential
6. Save the workflow

### 5.3 Global Error Workflow

Configure a global error handler so workflow failures send notifications even if the workflow's own error handling fails.

1. Go to Settings > Workflows
2. Under "Error Workflow," select or create a simple workflow that sends an HTTP POST to `DISCORD_WEBHOOK_URL` with the error details
3. Alternatively, configure email notifications if Discord is down (belt-and-suspenders approach)

### 5.4 Credential Verification Checklist

After setup, verify:

- [ ] Header Auth credential "VoidAI Webhook Secret" exists and is assigned to WF2 and WF7 webhook triggers
- [ ] All environment variables from Section 2 are set (spot-check by opening any workflow and confirming `{{ $env.DISCORD_WEBHOOK_URL }}` resolves without error in the expression editor)
- [ ] Instance timezone is `America/New_York`
- [ ] Global error workflow is configured

---

## 6. DRY_RUN Testing Phase

Before going live, test every workflow in DRY_RUN mode. This ensures all API connections work, data flows correctly, and Discord notifications arrive, without posting anything publicly.

### 6.1 Prerequisites

- [ ] All 7 workflows imported per Section 4
- [ ] All environment variables set per Section 2
- [ ] `EMERGENCY_STOP` = `false`
- [ ] `DRY_RUN` = `true`
- [ ] Credentials configured per Section 5
- [ ] Discord notifications channel is open so you can watch for messages

### 6.2 Test WF1: Daily Metrics Post

1. Open WF1 in the n8n editor
2. Click "Execute Workflow" (the play button, or "Test Workflow" in some versions)
3. Watch the execution flow through each node. Nodes turn green on success.
4. **Verify each node:**
   - Cron Trigger: fires (manual execution bypasses the cron schedule)
   - Taostats Subnet 106: returns JSON with `emission`, `registration_cost`, or similar fields
   - Taostats Pool: returns JSON with `tao_reserve`, `alpha_reserve`, `price`
   - CoinGecko TAO: returns JSON with `bittensor.usd`, `bittensor.usd_24h_change`
   - CoinGecko SN106: returns JSON with `liquidity-provisioning.usd`
   - Wait For All APIs: passes through all 4 inputs
   - Merge Data: outputs a single item with all fields populated (check for `N/A` values, which indicate API failures)
   - Too Many API Failures?: should take the False path (2 or fewer failures)
   - Format Tweet: outputs tweet text under 280 characters
   - DRY_RUN?: should take the False (right) path because DRY_RUN is `true`, which does NOT equal `false`
   - DRY_RUN Log: prepares the log entry
   - DRY_RUN: Discord Log: sends the dry-run tweet to Discord
5. **Check Discord:** You should see a message like "[DRY_RUN] Daily Metrics Draft" with the tweet text
6. **Record result:** Note the tweet text, character count, and any N/A fields

### 6.3 Test WF4: Ecosystem News Monitor

1. Open WF4 and click "Execute Workflow"
2. **Verify each node:**
   - Every 4 Hours: fires
   - RSS feeds (CoinDesk, The Block, CoinTelegraph, DL News): each should return XML/JSON data (some may fail, that is OK with continueOnFail)
   - Sanitize RSS Input: processes all feeds, strips injection patterns
   - Filter + Deduplicate: filters for Bittensor keywords, deduplicates
   - New Items?: if no Bittensor news found, the workflow stops here (this is normal)
   - If items found: DRY_RUN? routes to Discord log
3. **Check Discord:** If items were found, you should see "[DRY_RUN] Ecosystem News Found" messages
4. **Note:** It is normal for this workflow to find zero items if there is no current Bittensor news in RSS feeds

### 6.4 Test WF3: Weekly Recap Thread

1. Open WF3 and click "Execute Workflow"
2. **Verify each node:**
   - Friday 2PM ET: fires
   - All 5 API calls: check for non-error responses
   - Wait For All APIs: passes through all 5 inputs
   - Merge All Data: produces a single merged data object
   - DRY_RUN?: routes to DRY_RUN Log (right path)
   - DRY_RUN: Discord Log: sends data summary to Discord
3. **Check Discord:** Message shows "[DRY_RUN] Weekly Recap Data Collected" with TAO price, Alpha price, bridge volume, and GitHub repo count
4. **Note:** Claude generation is skipped entirely in DRY_RUN mode. This is by design. The Claude API key will be tested when DRY_RUN is set to `false`.

### 6.5 Test WF2: Bridge Transaction Alerts

WF2 has two triggers: a webhook and a disabled cron. Testing the webhook requires sending a manual HTTP request.

1. Open WF2 in the n8n editor
2. Click the "Webhook: Bridge TX" node to view its URL. Copy the test webhook URL (n8n shows a "Test URL" that works only during manual execution)
3. Click "Execute Workflow" to put it in listening mode
4. From a separate terminal or HTTP client (Postman, curl), send a test POST:

```
POST [test-webhook-url]
Headers:
  Content-Type: application/json
  X-Webhook-Secret: [your-header-auth-value]

Body:
{
  "tx_hash": "0xTEST123456789abcdef",
  "amount_tao": 250.5,
  "source_chain": "Bittensor",
  "dest_chain": "Solana",
  "timestamp": "2026-03-15T14:30:00Z",
  "explorer_url": "https://taostats.io/tx/0xTEST123456789abcdef"
}
```

5. **Verify each node:**
   - Webhook fires and receives the payload
   - Amount >= Threshold?: passes (250.5 >= 100)
   - Deduplicate: passes (first time seeing this hash)
   - Rate Limit Check: passes (under 6/day)
   - Rate Limit OK?: takes the True path
   - Format Alert Tweet: outputs formatted tweet with validated chain names
   - Input Valid?: takes the True path
   - DRY_RUN?: routes to DRY_RUN Log
   - DRY_RUN: Discord Log: sends the draft alert to Discord
6. **Check Discord:** Message shows "[DRY_RUN] Bridge Alert Draft" with the tweet and transaction details
7. **Test rejection:** Send a second POST with `"source_chain": "FakeChain"` and verify the "Rejected: Discord Notify" node fires
8. **Test dedup:** Send the same `tx_hash` again and verify the Deduplicate node returns empty (workflow halts)

### 6.6 Test WF5: Content Calendar Scheduler

1. Open WF5 and click "Execute Workflow"
2. **Expected result:** Since the approved queue (in static data) is empty, the workflow should stop at "Items to Schedule?" (no items to schedule). This is correct.
3. **Check Discord:** You should NOT receive a message (workflow exits silently when no items exist)
4. **To test the full flow:** You would need to manually add items to static data. This is optional during initial deployment. The full flow will be tested after WF3 and WF4 have generated drafts that get approved.

### 6.7 Test WF6: Competitor Monitor (Phase 3+ only)

1. Open WF6 and click "Execute Workflow"
2. **Expected result:** The X API search nodes will fail (X API Basic not yet activated). Taostats node should succeed.
3. Verify the workflow handles failures gracefully (continueOnFail is set)
4. **Do NOT activate this workflow.** Leave it inactive.

### 6.8 Test WF7: Blog Distribution Pipeline (Phase 3+ only)

1. Open WF7 and put it in listening mode
2. Send a test POST to its webhook URL with a sample blog payload
3. Verify DRY_RUN mode catches the execution and sends to Discord
4. **Do NOT activate this workflow.** Leave it inactive.

### 6.9 DRY_RUN Test Summary

| Workflow | Expected Discord Message | Pass Criteria |
|----------|------------------------|---------------|
| WF1 | "[DRY_RUN] Daily Metrics Draft" with tweet text | Tweet under 280 chars, data fields populated |
| WF2 | "[DRY_RUN] Bridge Alert Draft" with tx details | Correct chain names, amount formatted |
| WF3 | "[DRY_RUN] Weekly Recap Data Collected" with summary | All data sources show values (N/A is OK for bridge if not deployed) |
| WF4 | "[DRY_RUN] Ecosystem News Found" (or no message if no news) | Sanitization runs, no errors on RSS nodes |
| WF5 | No message (empty queue) | Workflow exits cleanly at "Items to Schedule?" |
| WF6 | X API failures, Taostats succeeds | Graceful failure handling |
| WF7 | "[DRY RUN] Blog Distribution Pipeline" | Webhook receives payload, DRY_RUN catches it |

---

## 7. Go-Live Procedure

Only proceed here after all DRY_RUN tests in Section 6 pass.

### 7.1 Pre-Go-Live Checklist

- [ ] All 5 active workflows (WF1 through WF5) passed DRY_RUN testing
- [ ] All Discord notifications arrived as expected
- [ ] No unexpected errors in any node execution
- [ ] Crisis.md EMERGENCY_STOP procedure is bookmarked and understood
- [ ] This runbook is bookmarked for quick rollback reference

### 7.2 Activate Workflows (DRY_RUN still true)

Activate workflows one at a time. Wait for each to complete one scheduled execution before activating the next. This confirms the cron schedules fire correctly.

**Step 1.** Activate WF1 (Daily Metrics Post)
- Wait for the next 10:00 AM ET execution
- Verify Discord receives the DRY_RUN log
- If it fires and logs correctly, proceed

**Step 2.** Activate WF4 (Ecosystem News Monitor)
- Wait for the next 4-hour cycle (00:00, 04:00, 08:00, 12:00, 16:00, or 20:00 UTC)
- Verify Discord receives the DRY_RUN log (if items found) or the execution completes without error (if no items)
- Proceed

**Step 3.** Activate WF3 (Weekly Recap Thread)
- This triggers only on Fridays at 2:00 PM ET
- If today is not Friday, you can either wait or do one more manual test execution
- Proceed

**Step 4.** Activate WF2 (Bridge Transaction Alerts)
- This is webhook-triggered, so it will only fire when the Tracker/FastAPI sends a POST
- If the bridge monitor is not yet deployed, activation is safe (no triggers will arrive)
- Proceed

**Step 5.** Activate WF5 (Content Calendar Scheduler)
- This triggers daily at 7:00 AM ET
- With an empty approved queue, it will exit silently
- Proceed

### 7.3 Switch from DRY_RUN to Live

After all 5 workflows have been activated and verified in DRY_RUN mode:

1. Go to Settings > Variables
2. Change `DRY_RUN` from `true` to `false`
3. Save
4. **Immediately verify** the change by opening any workflow, clicking an IF node that checks DRY_RUN, and confirming the expression evaluates correctly

**What changes:**
- WF1 will now post tweets via the configured `POSTING_API` (default: OpenTweet)
- WF2 will now post bridge alert tweets when triggered
- WF3 will now call Claude API and generate thread drafts (still requires human review before posting)
- WF4 will now call Claude API to score news items and create drafts (still requires human review)
- WF5 will now move items from approved to scheduled queue

**What does NOT change:**
- WF3 and WF4 always require human review. They write drafts, they do not publish.
- WF5 depends on approved queue items, which require manual approval.
- WF6 and WF7 remain inactive.

### 7.4 First Live Post Verification

After switching DRY_RUN to `false`:

1. Wait for WF1's next scheduled execution (10:00 AM ET)
2. Monitor Discord for the success notification ("Daily metrics posted successfully")
3. Check X (@v0idai) to confirm the tweet was actually posted
4. Verify the tweet content matches what you saw in DRY_RUN testing
5. If the post fails, Discord will show "ALERT: Daily Metrics Post FAILED" with the draft tweet for manual posting

---

## 8. Rollback Plan

If something goes wrong at any stage, follow the appropriate rollback procedure.

### 8.1 Rollback During DRY_RUN Testing

**Problem:** A workflow throws errors during manual execution.

**Fix:**
1. Identify the failing node by checking the execution log in the n8n editor
2. Check the node's output for error details
3. Common causes: incorrect env var name (typo), API key invalid, API endpoint changed
4. Fix the variable or credential, re-run the test

### 8.2 Rollback After Activation (DRY_RUN still true)

**Problem:** A scheduled workflow fires but produces wrong output.

**Fix:**
1. Deactivate the specific workflow (toggle the Active switch off in the workflow list)
2. Review the execution log (Executions page in n8n)
3. Fix the issue in the workflow editor
4. Re-test manually
5. Reactivate

### 8.3 Rollback After Go-Live (DRY_RUN = false)

**Problem:** A live workflow posts incorrect or unwanted content.

**Immediate actions (under 60 seconds):**
1. Go to Settings > Variables
2. Set `DRY_RUN` to `true`
3. Save
4. This immediately prevents all further posting across all workflows

**If the situation is a crisis (see crisis.md):**
1. Set `EMERGENCY_STOP` to `true` (this halts mid-execution workflows too)
2. Deactivate all 5 workflows
3. Follow the full EMERGENCY_STOP procedure in Section 10

**Post-incident:**
1. Review execution logs to understand what happened
2. If a tweet was posted incorrectly, decide whether to delete it manually from X
3. Fix the root cause in the workflow
4. Re-test with DRY_RUN = `true`
5. Set DRY_RUN back to `false` only after confirming the fix

### 8.4 Full Rollback (Remove All Workflows)

If you need to start over completely:

1. Set `EMERGENCY_STOP` to `true`
2. Deactivate all workflows
3. Delete each workflow from n8n (Workflows list > three-dot menu > Delete)
4. The original JSON files remain in git and can be re-imported at any time
5. Environment variables and credentials persist in n8n and do not need to be re-entered

---

## 9. Post-Deploy Monitoring

### 9.1 First 24 Hours

Monitor actively. Check Discord notifications after every scheduled trigger.

| Time | What to Check |
|------|--------------|
| After first WF1 execution (10 AM ET) | Did the tweet post? Check X and Discord notification. |
| After first WF4 cycle | Did RSS feeds return data? Any news items found? |
| After first WF5 execution (7 AM ET) | Did it report "no items" (expected if queue is empty)? |
| Throughout the day | Are WF2 bridge alerts arriving if bridge transactions happen? |
| End of day | Review all execution logs in n8n (Executions page). Look for failed executions (red). |

### 9.2 First 48 Hours

| Check | Where to Look |
|-------|--------------|
| API rate limits | CoinGecko free tier allows 10-30 calls/min. WF1 makes 2 calls/day. Should be fine. If errors appear, check CoinGecko status. |
| Discord notification delivery | Confirm every expected notification arrived. Missing notifications may indicate webhook URL issues. |
| Tweet quality | Read every posted tweet. Verify data accuracy against Taostats and CoinGecko manually. |
| Static data size | Open any workflow with static data (WF2, WF3, WF4, WF5), check the execution data for signs of the arrays growing too large (unlikely this early). |

### 9.3 First 72 Hours (Week 1)

| Check | What to Look For |
|-------|-----------------|
| WF3 Friday execution | The weekly recap should fire on Friday at 2 PM ET. This is the first Claude API call in production. Verify the thread draft is reasonable. |
| Claude API costs | Check Anthropic Console for API usage. WF3 and WF4 use `claude-sonnet-4-20250514`. Expected cost: under $1/week at current usage levels. |
| OpenTweet trial | The 7-day trial started when you first used the key. Track remaining days. Plan migration to X API Basic or continued OpenTweet subscription. |
| Cadence compliance | Verify no more than 2 posts/day from @v0idai on weekdays, 1/day on weekends. WF5 enforces this, but verify manually. |
| Weekend behavior | On Saturday/Sunday, WF1 still fires daily. Verify the tweet posts correctly on weekends. WF5 should limit to 1 post/day. |

### 9.4 Ongoing Monitoring Cadence

After the first week, shift to a lighter monitoring cadence:

- **Daily:** Glance at Discord notifications channel. Confirm WF1 posted. Check for any error notifications.
- **Weekly:** Review all execution logs. Check API usage (Anthropic, CoinGecko, OpenTweet). Review posted tweets for quality.
- **Monthly:** Audit static data sizes. Rotate API keys if needed (see pipeline-architecture.md Section 9.2). Review voice-learnings.md for performance data.

---

## 10. EMERGENCY_STOP Quick Reference

**Cut out this section and keep it accessible at all times.**

### Purpose

Halt ALL automated publishing within 60 seconds. No content goes out. Every workflow checks `EMERGENCY_STOP` before making external API calls. When set to `true`, workflows log a halt message to Discord and exit immediately.

### Activation (Target: Under 60 Seconds)

**Step 1.** Open https://vew.app.n8n.cloud (bookmark this now).

**Step 2.** Go to Settings > Variables. Change `EMERGENCY_STOP` to `true`. Click Save.

**Step 3.** Go to Workflows list. Deactivate all 5 active workflows:
  - WF1: VoidAI - Daily Metrics Post
  - WF2: VoidAI - Bridge Transaction Alerts
  - WF3: VoidAI - Weekly Recap Thread
  - WF4: VoidAI - Ecosystem News Monitor
  - WF5: VoidAI - Content Calendar Scheduler

**Step 4.** Post a manual hold message to Discord:

> **ALL PUBLISHING HALTED.** EMERGENCY_STOP activated at [time UTC]. All 5 workflows deactivated. Reason: [brief description]. Updates to follow.

### Why Both the Variable AND Deactivation?

The variable stops any workflow that is mid-execution from completing its publish step. Deactivating workflows prevents new executions from starting. Together, they provide a complete halt with no race conditions.

### What Happens Per Workflow

| Workflow | Effect When EMERGENCY_STOP = true |
|----------|----------------------------------|
| WF1: Daily Metrics | Halts before posting. Data fetch may still complete (read-only). |
| WF2: Bridge Alerts | Halts before posting. Webhook still fires but exits at the check node. |
| WF3: Weekly Recap | Halts before writing drafts and sending Discord notifications. |
| WF4: News Monitor | Halts before writing news drafts and sending Discord notifications. |
| WF5: Content Scheduler | Halts before scheduling or posting any approved content. |

### Recovery (After Incident is Resolved)

Follow this sequence exactly. Do not skip steps.

1. **Verify the incident is resolved.** Confirm root cause is addressed, no ongoing risk.

2. **Audit the content queue.** Review and purge any stale or incident-related content from static data.

3. **Set `EMERGENCY_STOP` to `false`.** Settings > Variables. Save.

4. **Set `DRY_RUN` to `true`.** This ensures workflows resume in safe mode first.

5. **Reactivate workflows one at a time.** Order:
   - WF1 (lowest risk, read-only data)
   - WF2 (verify bridge data accuracy)
   - WF3 (outputs to drafts only)
   - WF4 (outputs to drafts only)
   - WF5 (controls publishing, last)

6. **Test each workflow.** Execute manually in the editor. Inspect every node's output. Confirm Discord notifications arrive.

7. **Set `DRY_RUN` to `false`.** Only after all 5 workflows pass dry-run testing.

8. **Post recovery confirmation to Discord:**

> **PUBLISHING RESUMED.** All 5 workflows reactivated and tested at [time UTC]. EMERGENCY_STOP=false, DRY_RUN=false. Normal operations restored.

---

## Changelog

| Date | Change | Approved by |
|------|--------|-------------|
| 2026-03-15 | Initial deployment runbook created. Covers all 7 workflows, full env var matrix, import/test/go-live procedures, rollback, and EMERGENCY_STOP. | Vew |
