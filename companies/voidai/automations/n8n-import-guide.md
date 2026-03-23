# n8n Cloud Import Guide: VoidAI

**Target:** https://vew.app.n8n.cloud
**Date:** 2026-03-15
**Prerequisite:** Read your `.env` file at `/Users/vew/Apps/Void-AI/.env` to get the actual values for the table below.

---

## A. Environment Variables Checklist

Set every variable below in **Settings > Variables** before activating any workflow. One variable per row. Names are case-sensitive.

### Phase 2 Variables (set all of these now)

| Variable | Value | Used By |
|----------|-------|---------|
| `EMERGENCY_STOP` | `false` | All workflows |
| `DRY_RUN` | `true` | All workflows |
| `POSTING_API` | `opentweet` | WF1 |
| `TAOSTATS_API_BASE` | `https://api.taostats.io/api` | WF1, WF3, WF6 |
| `TAOSTATS_API_KEY` | (copy `ts_xxxx` from .env) | WF1, WF3, WF6 |
| `COINGECKO_API_BASE` | `https://api.coingecko.com/api/v3` | WF1, WF3 |
| `COINGECKO_API_KEY` | (copy from .env, or leave empty for free tier) | WF1 |
| `OPENTWEET_API_KEY` | (copy `ot_xxxx` from .env. EXPIRES 2026-03-22) | WF1, WF2 |
| `CLAUDE_API_KEY` | (copy `sk-ant-xxxx` from .env) | WF3, WF4, WF6, WF7 |
| `DISCORD_WEBHOOK_URL` | (copy full URL from .env) | All workflows |
| `GITHUB_TOKEN` | (copy `ghp_xxxx` from .env) | WF3 |
| `GITHUB_ORG` | `voidai` | WF3 |
| `BRIDGE_MONITOR_URL` | `http://localhost:8000/api/bridge/recent` | WF2, WF3 |
| `BRIDGE_TX_THRESHOLD` | `100` | WF2 |
| `MAX_POSTS_PER_DAY` | `6` | WF5 |
| `MIN_POST_GAP_MINUTES` | `180` | WF5 |
| `LOG_FILE_PATH` | `/data/n8n/dry-run-logs/` | Compatibility ref |
| `QUEUE_DRAFTS_PATH` | `/data/voidai/queue/drafts/` | Compatibility ref |
| `QUEUE_APPROVED_PATH` | `/data/voidai/queue/approved/` | Compatibility ref |
| `QUEUE_SCHEDULED_PATH` | `/data/voidai/queue/scheduled/` | Compatibility ref |

### Phase 3+ Variables (set these as placeholders or skip for now)

| Variable | Value | Used By |
|----------|-------|---------|
| `X_API_BEARER_TOKEN` | (placeholder until X API Basic) | WF4, WF6 |
| `X_API_KEY` | (placeholder) | WF1 |
| `X_API_SECRET` | (placeholder) | WF1 |
| `X_ACCESS_TOKEN` | (placeholder) | WF1 |
| `X_ACCESS_SECRET` | (placeholder) | WF1 |
| `OUTSTAND_API_KEY` | (placeholder) | WF1 |
| `OUTSTAND_API_BASE` | `https://api.outstand.com/v1` | WF1 |
| `DISCORD_ANNOUNCE_WEBHOOK` | (placeholder) | WF7 |

**Safety check after entering all variables:** Scroll the list. Confirm `EMERGENCY_STOP` = `false` and `DRY_RUN` = `true`.

---

## B. Import Order and File Paths

Import workflows one at a time in this order. For each: Workflows > Add Workflow > three-dot menu > Import from File.

| Order | Workflow Name | File Path | Activate? |
|-------|--------------|-----------|-----------|
| 1 | VoidAI - Daily Metrics Post | `/Users/vew/Apps/Void-AI/companies/voidai/automations/workflows/workflow-1-daily-metrics.json` | NO (wait for Section D) |
| 2 | VoidAI - Ecosystem News Monitor | `/Users/vew/Apps/Void-AI/companies/voidai/automations/workflows/workflow-4-ecosystem-news.json` | NO |
| 3 | VoidAI - Weekly Recap Thread | `/Users/vew/Apps/Void-AI/companies/voidai/automations/workflows/workflow-3-weekly-recap.json` | NO |
| 4 | VoidAI - Bridge Transaction Alerts | `/Users/vew/Apps/Void-AI/companies/voidai/automations/workflows/workflow-2-bridge-alerts.json` | NO |
| 5 | VoidAI - Content Calendar Scheduler | `/Users/vew/Apps/Void-AI/companies/voidai/automations/workflows/workflow-5-content-scheduler.json` | NO |
| 6 | VoidAI - Competitor Monitor [Phase 3+] | `/Users/vew/Apps/Void-AI/companies/voidai/automations/workflows/workflow-6-competitor-monitor.json` | NO, leave INACTIVE |
| 7 | VoidAI - Blog Distribution Pipeline [Phase 3+] | `/Users/vew/Apps/Void-AI/companies/voidai/automations/workflows/workflow-7-blog-distribution.json` | NO, leave INACTIVE |

**After all 7 are imported, create the Header Auth credential:**

1. Credentials > Add Credential > Header Auth
2. Name: `VoidAI Webhook Secret`
3. Header Name: `X-Webhook-Secret`
4. Header Value: generate with `openssl rand -hex 32` in terminal. Save this value.
5. Open WF2, click "Webhook: Bridge TX" node, assign credential. Save workflow.
6. Open WF7, click "Webhook: Blog Published" node, assign credential. Save workflow.

---

## C. Post-Import Verification

After importing each workflow, verify the following before saving.

### WF1: Daily Metrics Post

| Check | What to look for |
|-------|-----------------|
| Trigger | "Daily 10AM ET" node, scheduleTrigger, cron `0 10 * * *` |
| Node count | 17 nodes visible (Trigger, Emergency Stop, 4 API calls, Merge, Merge Data, API failure check, Error notification, Format Tweet, DRY_RUN IF, DRY_RUN Log, DRY_RUN Discord, Switch, OpenTweet, Success, Failure) |
| Key connection | 4 HTTP nodes feed into "Wait For All APIs" Merge node, then into "Merge Data" Code node |
| Env var check | Click any HTTP node. URL should show `{{ $env.TAOSTATS_API_BASE }}` or `{{ $env.COINGECKO_API_BASE }}`, not hardcoded URLs |
| DRY_RUN node | IF node checks `{{ $env.DRY_RUN }}` equals `false` |
| Red errors | None |

### WF2: Bridge Transaction Alerts

| Check | What to look for |
|-------|-----------------|
| Trigger | "Webhook: Bridge TX" (webhook, POST, headerAuth) AND "Cron: Every 15min" (disabled) |
| Node count | ~18 nodes (2 triggers, Emergency Stop, Fetch, Split, Filter, Deduplicate, Rate Limit, Format, Input Valid, DRY_RUN check, DRY_RUN Log, Discord, Switch, post nodes, result notification, reject notification) |
| Auth | Webhook node shows "Header Auth" in authentication field (credential assigned in step B) |
| Cron disabled | The cron trigger node should have `disabled: true` |
| Env var check | Click Filter node, should reference `{{ $env.BRIDGE_TX_THRESHOLD }}` |

### WF3: Weekly Recap Thread

| Check | What to look for |
|-------|-----------------|
| Trigger | "Friday 2PM ET" node, scheduleTrigger, cron `0 14 * * 5` |
| Node count | ~15 nodes (Trigger, Emergency Stop, 5 API calls, Merge, Merge All Data, DRY_RUN check, DRY_RUN Log, Discord, Claude API, Parse Thread, Write Drafts, Draft notification) |
| Key connection | 5 API/data nodes feed into "Wait For All APIs" Merge node |
| Env var check | GitHub node URL contains `{{ $env.GITHUB_ORG }}` and header has `{{ $env.GITHUB_TOKEN }}` |

### WF4: Ecosystem News Monitor

| Check | What to look for |
|-------|-----------------|
| Trigger | "Every 4 Hours" node, scheduleTrigger, cron `0 */4 * * *` |
| Node count | ~14 nodes (Trigger, Emergency Stop, 4 RSS feeds, Sanitize, Filter+Deduplicate, New Items check, Claude Score, DRY_RUN check, log/notify nodes) |
| X API node | The X API Search node should be `disabled: true` (requires X API Basic, Phase 3) |
| RSS feeds | CoinDesk, The Block, CoinTelegraph, DL News |

### WF5: Content Calendar Scheduler

| Check | What to look for |
|-------|-----------------|
| Trigger | "Daily 7AM ET" node, scheduleTrigger, cron `0 7 * * *` |
| Node count | ~12 nodes (Trigger, Emergency Stop, Read Queue, Items to Schedule check, Cadence check, DRY_RUN check, Schedule/Post nodes, Discord notifications) |
| Key behavior | With empty queue, workflow exits at "Items to Schedule?" |

### WF6: Competitor Monitor [Phase 3+]

| Check | What to look for |
|-------|-----------------|
| Trigger | "Daily 8AM ET", scheduleTrigger, cron `0 8 * * *` |
| Key connection | 3 data sources feed into Merge node |
| Status | Leave INACTIVE. Do not activate. |

### WF7: Blog Distribution Pipeline [Phase 3+]

| Check | What to look for |
|-------|-----------------|
| Trigger | "Webhook: Blog Published" (webhook, POST, headerAuth) |
| Auth | Webhook node shows "Header Auth" |
| Key connection | 3 Claude API calls feed into "Write All Drafts" Merge node |
| Status | Leave INACTIVE. Do not activate. |

---

## D. DRY_RUN Test Procedure

Prerequisites: All 7 workflows imported. All env vars set. `EMERGENCY_STOP` = `false`. `DRY_RUN` = `true`. Discord channel open.

### Test WF1: Daily Metrics Post

1. Open WF1 in editor. Click "Execute Workflow" (play button).
2. Watch nodes turn green left to right.
3. Verify:
   - Taostats Subnet 106: returns JSON with `emission` field
   - Taostats Pool: returns JSON with `tao_reserve`, `price` fields
   - CoinGecko TAO: returns JSON with `bittensor.usd`
   - CoinGecko SN106: returns JSON with `liquidity-provisioning.usd`
   - Merge Data: single output with all fields (check for `N/A` values)
   - Format Tweet: tweet text under 280 characters
   - DRY_RUN: routes to log path (NOT the posting path)
4. **Discord check:** Look for `[DRY_RUN] Daily Metrics Draft` with tweet text, character count, and data points.
5. PASS if: tweet is under 280 chars, data fields are populated, Discord message arrived.

### Test WF4: Ecosystem News Monitor

1. Open WF4. Click "Execute Workflow."
2. Verify:
   - RSS feeds return data (some may fail, that is OK with continueOnFail)
   - Sanitize node processes all feeds
   - Filter + Deduplicate runs
   - If no Bittensor news exists in RSS feeds, workflow stops at "New Items?" (this is normal)
3. **Discord check:** If items found, look for `[DRY_RUN] Ecosystem News Found`. If zero items, no Discord message is expected.
4. PASS if: no red error nodes, sanitization runs, workflow completes.

### Test WF3: Weekly Recap Thread

1. Open WF3. Click "Execute Workflow."
2. Verify:
   - All 5 API calls execute (some may show N/A for bridge if not deployed)
   - Merge All Data: produces single merged object
   - DRY_RUN routes to log path (Claude generation is skipped in DRY_RUN mode)
3. **Discord check:** Look for `[DRY_RUN] Weekly Recap Data Collected` with TAO price, Alpha price, and data summary.
4. PASS if: data summary is populated, Discord message arrived. Claude API is not tested yet (tested on go-live).

### Test WF2: Bridge Transaction Alerts

1. Open WF2. Click "Execute Workflow" to put it in listening mode.
2. Copy the **Test URL** shown on the webhook node.
3. In a separate terminal, send this curl:

```
curl -X POST "[TEST_URL_FROM_STEP_2]" \
  -H "Content-Type: application/json" \
  -H "X-Webhook-Secret: [YOUR_HEADER_AUTH_VALUE]" \
  -d '{
    "tx_hash": "0xTEST123456789abcdef",
    "amount_tao": 250.5,
    "source_chain": "Bittensor",
    "dest_chain": "Solana",
    "timestamp": "2026-03-15T14:30:00Z",
    "explorer_url": "https://taostats.io/tx/0xTEST123456789abcdef"
  }'
```

4. Verify:
   - Webhook fires
   - Amount >= Threshold passes (250.5 >= 100)
   - Deduplicate passes (first time)
   - Rate Limit OK
   - Format Alert Tweet outputs tweet with chain names
   - DRY_RUN routes to log path
5. **Discord check:** Look for `[DRY_RUN] Bridge Alert Draft` with tweet text and tx details.
6. **Rejection test:** Send again with `"source_chain": "FakeChain"`. Verify "Rejected: Discord Notify" fires.
7. **Dedup test:** Send the same `tx_hash` again. Verify workflow halts at Deduplicate.
8. PASS if: valid payload produces Discord alert, rejection works, dedup works.

### Test WF5: Content Calendar Scheduler

1. Open WF5. Click "Execute Workflow."
2. Expected: workflow stops at "Items to Schedule?" because the approved queue is empty.
3. **Discord check:** No Discord message expected (workflow exits silently).
4. PASS if: workflow completes without errors, no unexpected messages.

---

## E. Go-Live Checklist

Only proceed after all 5 DRY_RUN tests above pass.

### Step 1: Activate workflows (DRY_RUN still `true`)

Do these one at a time. Toggle the Active switch for each workflow in the Workflows list.

1. Activate WF1. Wait for the next 10:00 AM ET execution. Confirm Discord receives DRY_RUN log.
2. Activate WF4. Wait for the next 4-hour cycle. Confirm execution completes.
3. Activate WF3. This only fires Fridays at 2 PM ET. If not Friday, do one more manual test.
4. Activate WF2. Webhook-triggered, safe to activate (no triggers arrive unless bridge monitor sends them).
5. Activate WF5. Fires daily at 7 AM ET. With empty queue, exits silently.

### Step 2: Verify cron-triggered DRY_RUN executions

- [ ] WF1 fired on schedule and sent DRY_RUN log to Discord
- [ ] WF4 fired on schedule (message if news found, silent if not)
- [ ] WF5 fired on schedule (silent exit, no errors in execution log)
- [ ] WF2 standing by (no webhook received, no errors)
- [ ] WF3 standing by or fired on Friday

### Step 3: Switch to live

1. Go to Settings > Variables
2. Change `DRY_RUN` from `true` to `false`
3. Save
4. Verify: open any workflow, click the DRY_RUN IF node, confirm `{{ $env.DRY_RUN }}` resolves to `false`

### Step 4: Monitor first live execution

1. Wait for WF1's next 10:00 AM ET execution
2. Check Discord for "Daily metrics posted successfully"
3. Check X (@v0idai) to confirm the tweet appeared
4. If posting fails, Discord will show "ALERT: Daily Metrics Post FAILED" with draft text for manual posting

### Rollback (if anything goes wrong)

**Quick rollback (under 60 seconds):**
1. Settings > Variables > set `DRY_RUN` to `true` > Save

**Full emergency stop:**
1. Settings > Variables > set `EMERGENCY_STOP` to `true` > Save
2. Deactivate all 5 workflows
3. See `deployment-runbook.md` Section 10 for full procedure

---

## Quick Reference: Key Schedules

| Workflow | Schedule | Timezone |
|----------|----------|----------|
| WF1 | Daily 10:00 AM | America/New_York |
| WF2 | Webhook (on-demand) | N/A |
| WF3 | Friday 2:00 PM | America/New_York |
| WF4 | Every 4 hours | UTC |
| WF5 | Daily 7:00 AM | America/New_York |
| WF6 | Daily 8:00 AM (inactive) | America/New_York |
| WF7 | Webhook (inactive) | N/A |

## OpenTweet Key Expiry Warning

Your OpenTweet API key expires **2026-03-22** (7 days from today). Plan migration to X API Basic or renew the OpenTweet subscription before that date. When ready, change `POSTING_API` from `opentweet` to `x_api` and configure the OAuth 1.0a credential per the deployment runbook Section 5.2.
