# Wave 3 Documentation and Kill Switch Challenge Report

**Challenger:** Security Auditor (Claude, Challenger Mode)
**Date:** 2026-03-15
**Scope:** Wave 3 documentation updates (n8n-workflow-specs.md, pipeline-architecture.md, crisis.md) and workflow JSON files
**Prior context:** phase2-n8n-workflow-audit.md, phase2-n8n-challenge.md, phase2-security-challenge.md
**Classification:** Internal

---

## Executive Summary

The Wave 3 documentation updates are a significant improvement over the pre-audit state. The DRY_RUN fail-safe logic, n8n Cloud compatibility notes, Merge node pattern documentation, credential setup checklist, crisis kill switch procedure, and credential rotation runbook address the most urgent findings from the Phase 2 audits. However, this challenge review identifies **8 gaps, 4 inconsistencies, and 6 operational risks** that should be addressed before the pipeline moves to DRY_RUN=false.

**Overall assessment:** The documentation is 80% production-ready. The remaining 20% includes one critical gap (EMERGENCY_STOP not in workflow JSONs), one high-severity inconsistency (DST math errors), and several medium-severity operational gaps.

---

## 1. EMERGENCY_STOP: Not Embedded in Workflow JSONs [CRITICAL GAP]

### The Problem

The EMERGENCY_STOP kill switch is documented in three places:
- `crisis.md` (activation procedure, JS code node, insertion points table)
- `n8n-workflow-specs.md` (environment variable table, line 36)
- `pipeline-architecture.md` (Section 9.1)

However, **not a single one of the 7 workflow JSON files contains an EMERGENCY_STOP check node.** I verified every workflow JSON: `workflow-1-daily-metrics.json` through `workflow-7-blog-distribution.json`. None of them include a node named "Emergency Stop Check" or any reference to the `EMERGENCY_STOP` environment variable in their node definitions or JavaScript code.

The crisis.md document provides the JavaScript code and a table of insertion points (line 109-117) telling the operator where to add the node manually:

```
| WF1: Daily Metrics | Insert After: Node 1 (Cron Trigger) | Connect To: Node 2 (Taostats API) |
```

This is a documentation-only kill switch. The code snippet exists on paper but not in the actual workflow files that will be imported into n8n.

### Why This Is Critical

1. **Import-and-forget risk.** The most likely deployment scenario: the operator imports the 7 JSON files, configures credentials per the checklist, and activates WF1-5. At no point does the import workflow force the operator to add the EMERGENCY_STOP node. The credential setup checklist in the specs doc (line 162-207) does not include "Add EMERGENCY_STOP check node to each workflow" as a step.

2. **Crisis response failure.** If a bridge exploit occurs and the operator sets `EMERGENCY_STOP=true` in n8n variables, nothing happens. The workflows do not check this variable. The operator would need to fall back to deactivating workflows manually (Method C in pipeline-architecture.md), which is slower and may miss in-progress executions.

3. **False sense of security.** The crisis.md document states (line 26): "Every n8n workflow checks the EMERGENCY_STOP environment variable before making any external API call." This statement is currently false. No workflow checks this variable.

### What Should Be Done

**Option A (Recommended):** Add the Emergency Stop Check code node to every workflow JSON file, positioned as the first node after the trigger, with connections wired appropriately. This ensures the kill switch is present in every import.

**Option B (Minimum):** Add an explicit step to the Credential Setup Checklist (specs doc, line 162) requiring the operator to manually add the Emergency Stop Check node to each workflow after import, with a verification step (set EMERGENCY_STOP=true, run workflow, confirm it halts).

Option A is strongly preferred because Option B relies on human diligence during a deployment that may be hurried.

### Additional Concern: Kill Switch Coverage Gap During Execution

Even when the EMERGENCY_STOP node is added, it only checks at the start of a workflow execution. If EMERGENCY_STOP is set to `true` while WF1 is mid-execution (for example, the API calls have completed and the workflow is at the Format Tweet node), the kill switch does nothing. The tweet will still be posted.

The crisis.md acknowledges this partially (line 45): "The variable stops any workflow that is mid-execution from completing its publish step." But the JavaScript code at line 61-99 only runs once at the workflow start, not before the publish step. The code returns `$input.all()` if EMERGENCY_STOP is false, and the workflow proceeds without any further checks. There is no second EMERGENCY_STOP check before the actual posting API call.

**Recommendation:** Add a second EMERGENCY_STOP check node immediately before every posting/publishing node (before "Post via OpenTweet" in WF1, before "Post Tweet" in WF2, before WF5's schedule-and-move step). This provides true mid-execution halt capability as documented.

---

## 2. DST Correction: Partially Correct, Remaining Errors [HIGH]

### What Was Fixed

The WF1 cron schedule was changed from `0 9 * * *` to `0 10 * * *` (10 AM ET). This is correct and addresses the original challenger finding (MISSED-1 in phase2-n8n-challenge.md).

### UTC Math Verification

The key claim appears in multiple locations:

**n8n-workflow-specs.md, line 225:**
> 10:00 AM ET falls within the 14:00-16:00 UTC peak window per cadence.md in both seasons (10 AM EDT = 14:00 UTC in summer, 10 AM EST = 15:00 UTC in winter).

**workflow-1-daily-metrics.json, line 20 (cron trigger notes):**
> 10 AM EDT = 14:00 UTC (summer), 10 AM EST = 15:00 UTC (winter)

**pipeline-architecture.md, Section 8.3, line 757:**
> 10 AM ET = 14:00 UTC in summer, 15:00 UTC in winter

**Verification:**
- EDT (Eastern Daylight Time) = UTC-4. So 10:00 AM EDT = 14:00 UTC. **CORRECT.**
- EST (Eastern Standard Time) = UTC-5. So 10:00 AM EST = 15:00 UTC. **CORRECT.**

All three documents are consistent and mathematically correct.

### Remaining DST Issue: WF5 Time Slots Hardcoded in UTC

WF5 (Content Calendar Scheduler) assigns posting times using hardcoded UTC slots (specs doc, line 1587-1593 and workflow-5-content-scheduler.json, assign-times node):

```javascript
const timeSlots = [
  { hour: 14, minute: 0 },  // 10:00 AM ET (primary)
  { hour: 15, minute: 30 }, // 10:30 AM ET
  { hour: 17, minute: 0 },  // 12:00 PM ET
  { hour: 20, minute: 0 },  // 3:00 PM ET (secondary peak)
  { hour: 21, minute: 30 }, // 4:30 PM ET
];
```

The comments claim these UTC times correspond to specific ET times, but the comments are only correct during EDT (summer). During EST (winter):
- 14:00 UTC = 9:00 AM EST (not 10:00 AM ET as commented)
- 15:30 UTC = 10:30 AM EST (correct)
- 17:00 UTC = 12:00 PM EST (correct)
- 20:00 UTC = 3:00 PM EST (correct)
- 21:30 UTC = 4:30 PM EST (correct)

The first slot's comment is wrong for winter. More importantly, 14:00 UTC = 9:00 AM EST falls within the cadence.md peak window (14:00-16:00 UTC is defined in UTC, not ET), so the actual scheduling is fine. But the human-readable comment "10:00 AM ET" is misleading because the slot fires at 9 AM local time in winter.

**The deeper problem:** The code comments use "AM ET" as if ET is a fixed offset, but ET alternates between EDT and EST. The comments should say "10:00 AM EDT / 9:00 AM EST" or simply state the UTC time without an ET conversion.

### WF3 Trigger Time: No DST Concern

WF3 triggers at `0 14 * * 5` with timezone `America/New_York`. This means 2:00 PM ET, which is:
- 2:00 PM EDT = 18:00 UTC (summer)
- 2:00 PM EST = 19:00 UTC (winter)

Neither falls within the cadence.md peak window of 14:00-16:00 UTC. The docs do not claim WF3 targets the peak window, so this is not an error, but it is worth noting that the weekly recap thread posts outside peak engagement hours in both seasons.

---

## 3. Credential Rotation Runbook: Gaps [MEDIUM]

### What the Runbook Covers

The rotation runbook at pipeline-architecture.md Section 9.2 (lines 932-979) covers 14 credentials with rotation methods, verification steps, and a tracking table. This is a solid foundation.

### Gaps Identified

**Gap 3a: OpenTweet API Key Expiry Not Flagged**

The memory file `reference_opentweet_api.md` notes that the OpenTweet API key is on a 7-day trial. The CLAUDE.md session handoff references the key expiring 2026-03-22 (one week from today). The rotation runbook lists `OPENTWEET_API_KEY` at row 3 but does not flag the imminent expiry. There is no alert, no calendar reminder set, and no documented fallback procedure for when the trial expires.

When the OpenTweet trial expires on 2026-03-22, all posting workflows (WF1, WF2, WF5 in production mode) will start returning authentication errors. The only documented fallback is to switch `POSTING_API` to `x_api` (requires $200/mo X API Basic subscription) or `outstand` (not yet available).

**Recommendation:** Add an explicit entry to the operational checklist for 2026-03-21: "Renew OpenTweet subscription ($6/mo) or switch POSTING_API to x_api. If neither, all posting stops on 2026-03-22."

**Gap 3b: `CANVA_API_TOKEN` and `SLACK_TOKEN` Missing from Runbook**

Pipeline-architecture.md Section 8.2 lists `CANVA_API_TOKEN` (row: MCP server config) and `SLACK_TOKEN` (row: MCP server config) as active credentials. Neither appears in the rotation runbook at Section 9.2. While both are used via MCP servers (not n8n), they are still API credentials that need rotation tracking.

**Gap 3c: n8n `N8N_ENCRYPTION_KEY` Not Covered**

Pipeline-architecture.md Section 8.4 mentions: "n8n credentials store is encrypted with N8N_ENCRYPTION_KEY." This key is not in the rotation runbook. If this key is lost or reset, all stored credentials in n8n become unreadable. This is not a rotation item but a backup item: the key should be documented in a secure backup location.

**Gap 3d: No Emergency Rotation Procedure**

The runbook describes a methodical 6-step rotation process (generate new key, update n8n, test, verify, revoke old, log). But during an API key compromise (Section 10.5), the first action is "Revoke key in [provider] Portal. Pause all n8n workflows." This contradicts the rotation procedure which says "Revoke the old key only after confirming the new key works" (step 5). The emergency procedure revokes first (correct for compromise), but the runbook does not distinguish between routine rotation and emergency rotation.

**Recommendation:** Add a subsection titled "Emergency Rotation (Compromise)" with the sequence: (1) Revoke immediately at provider, (2) Generate new key, (3) Update n8n, (4) Test, (5) Resume workflows.

---

## 4. DRY_RUN Documentation vs. Implementation [LOW, MOSTLY CORRECT]

### Specs Document DRY_RUN Fail-Safe Logic

The specs doc (lines 74-94) documents the fail-safe pattern:

```javascript
const isDryRun = String($env.DRY_RUN).toLowerCase().trim() !== 'false';
```

### Workflow JSON DRY_RUN Implementation

All workflow JSON files use an IF node (not a Code node) for the DRY_RUN check. The IF node condition in every workflow is:

```json
{
  "leftValue": "={{ $env.DRY_RUN }}",
  "rightValue": "false",
  "operator": { "type": "string", "operation": "equals" }
}
```

This checks if DRY_RUN exactly equals the string `"false"`. If DRY_RUN is undefined, empty, `"true"`, `"TRUE"`, or any other value, the condition evaluates to false, and the workflow routes to the dry-run path. This is fail-safe behavior.

### Discrepancy

The specs doc describes a Code node pattern with `String().toLowerCase().trim()`, but the actual implementation uses an IF node with a strict string equals check. The two approaches produce the same result for all documented cases:
- `DRY_RUN=true` -> dry-run path (both approaches)
- `DRY_RUN=false` -> publish path (both approaches)
- `DRY_RUN=FALSE` -> dry-run path (Code approach would treat as false because of toLowerCase; IF approach treats as dry-run because "FALSE" !== "false")
- `DRY_RUN=undefined` -> dry-run path (both approaches)

There is one behavioral difference: the IF node approach is STRICTER than the Code node approach. `DRY_RUN=FALSE` or `DRY_RUN=False` would result in dry-run mode in the JSON but publish mode in the spec's Code pattern. This is actually safer. The IF node approach is the correct one. The spec doc should be updated to match the actual implementation, or at minimum note that the IF node approach is equivalent and slightly stricter.

### WF5 DRY_RUN Routing

The WF5 JSON has an interesting DRY_RUN routing discrepancy with the spec. The spec says (line 1745-1747): "Files are NOT moved from approved/ to scheduled/ (they stay for the next test run)." But the WF5 JSON's DRY_RUN check routes to:
- True output (DRY_RUN=false, publish): `Schedule + Move Items` node
- False output (DRY_RUN=true, dry-run): `DRY_RUN Log` node

The connections are (line 196-199):
```json
"DRY_RUN?": {
  "main": [
    [{ "node": "Schedule + Move Items" }],  // Output 0: condition TRUE (DRY_RUN === 'false')
    [{ "node": "DRY_RUN Log" }]             // Output 1: condition FALSE (dry-run)
  ]
}
```

This is correct. The IF node's true output fires when the condition matches (DRY_RUN equals "false"), routing to the publish path. The false output fires when DRY_RUN is anything else, routing to the log. Consistent with the documentation.

---

## 5. n8n Cloud Compatibility: Documented But Incomplete [MEDIUM]

### What Is Documented

The specs doc (lines 96-130) covers:
- Filesystem ephemeral storage (write succeeds, persistence fails)
- Deduplication via `$getWorkflowStaticData('global')` instead of filesystem
- 256KB static data size limit
- Queue file management limitation

The workflow JSONs have been updated to match:
- WF2 deduplication uses `$getWorkflowStaticData('global')` (confirmed in JSON, line 99)
- WF5 reads queue from static data instead of filesystem (confirmed in JSON, line 24)
- WF1 and WF2 dry-run logs go to Discord instead of filesystem (confirmed in JSONs)

### Undocumented n8n Cloud Limitations

**5a: Execution Time Limits**

n8n Cloud (free tier) has a maximum execution time per workflow. On the free plan, this is typically 5 minutes. WF3 (Weekly Recap) makes 5 parallel HTTP requests, then a Claude API call, then writes a file. Under normal conditions this completes in 10-30 seconds. But if CoinGecko rate-limits (30-second delay per retry) and Claude API is slow (15-second timeout), this could approach 2-3 minutes. If multiple APIs retry with backoff, the 5-minute limit could be hit.

WF4 (Ecosystem News Monitor) processes an unbounded number of RSS items through sequential Claude API calls with 1-second delays between them. If 20 news items match the keyword filter, that is 20 Claude API calls at 1-5 seconds each plus 1-second delays = potentially 120 seconds of sequential processing. This is within limits but could grow.

**Recommendation:** Document the execution time limit and add a safeguard: cap the number of items processed per WF4 execution (e.g., max 10 items per run, defer the rest).

**5b: Concurrent Execution Limits**

n8n Cloud free tier limits concurrent executions (typically 2 active executions at once). If WF1 (10 AM), WF4 (every 4 hours), and WF2 (webhook, any time) all trigger within the same window, the third execution may be queued or dropped. This is not documented anywhere.

**5c: Webhook Timeout**

n8n Cloud webhooks have a response timeout (typically 30 seconds for the initial response). WF2's webhook trigger has `"responseMode": "responseNode"` but no Response node (identified in the original audit as WF2-L1 / WF7-L1). On n8n Cloud, this means the webhook caller (Tracker/FastAPI) will receive a timeout error even though the workflow executed successfully.

This was already flagged as LOW in the original audit and upgraded to MEDIUM by the challenger. The n8n Cloud context makes this more relevant because Cloud may enforce stricter webhook timeouts than self-hosted.

**5d: Static Data Concurrency**

The challenger report (MISSED-2) identified TOCTOU race conditions in filesystem-based deduplication. The migration to `$getWorkflowStaticData('global')` partially resolves this because n8n serializes static data access within a single workflow. However, the docs do not clarify whether concurrent webhook-triggered executions of WF2 share the same static data lock. If two webhooks arrive simultaneously, both executions may read the same static data snapshot before either writes.

---

## 6. Crisis Procedure: Edge Cases Not Covered [HIGH]

### 6a: Mid-Execution Kill Switch for WF3 (Thread Posting)

The crisis.md recovery procedure (Step 4, line 134) says to reactivate workflows with DRY_RUN=true. But consider this scenario:

1. WF3 (Weekly Recap) fires at 2:00 PM Friday
2. WF3 generates a thread and writes it to the drafts queue
3. The human approves the thread
4. WF5 (Content Scheduler) picks up the thread and begins posting it as a multi-tweet thread via OpenTweet
5. After tweet 3 of 8, a bridge exploit is discovered
6. Operator sets EMERGENCY_STOP=true

**What happens:** If EMERGENCY_STOP is only checked at workflow start (as currently coded), WF5 has already started posting and will complete all 8 tweets. The kill switch does not intercept mid-thread. The operator must also deactivate WF5 (Method C), but even that does not stop the currently-executing workflow instance.

**What should happen:** Either (a) the posting loop in WF5 checks EMERGENCY_STOP before each individual tweet in the thread, or (b) the crisis procedure explicitly documents that thread posting is not interruptible and the operator must manually delete the remaining tweets.

### 6b: Already-Queued OpenTweet Scheduled Posts

If WF5 has already scheduled posts via OpenTweet's scheduling API (`POST /v1/tweets/schedule`), those posts exist in OpenTweet's queue, not n8n's. Setting EMERGENCY_STOP=true or deactivating n8n workflows has no effect on posts that have already been sent to OpenTweet for future scheduling.

The crisis procedure does not mention this. The operator needs to:
1. Log into the OpenTweet dashboard
2. Cancel all scheduled tweets

This step should be added to the crisis activation procedure between Step 2 and Step 3 of crisis.md.

**The same applies to any future Outstand integration.** Any posts submitted to external scheduling APIs exist outside n8n's control once submitted.

### 6c: Recovery Procedure Lists 5 Workflows, Crisis.md Lists 5

The recovery procedure (crisis.md, line 134-141) lists 5 workflows to reactivate:
1. WF1: Daily Metrics Post
2. WF2: Bridge Transaction Alerts
3. WF3: Weekly Recap Thread
4. WF4: Ecosystem News Monitor
5. WF5: Content Calendar Scheduler

The crisis activation procedure (crisis.md, line 34) says "Deactivate all 5 active workflows" and lists the same 5. This is consistent. However, the activation procedure calls WF5 "Content Calendar Scheduler" while the pipeline-architecture.md Section 6 (line 560) calls it "Scheduler/Publisher." The workflow JSON names it "VoidAI - Content Calendar Scheduler." Minor naming inconsistency, but during a crisis, clarity matters.

### 6d: No Procedure for Satellite Account Kill

The crisis protocol (crisis.md, Per-Account Crisis Behavior table, line 177-187) states that satellite accounts should go SILENT during a crisis. But the n8n workflows only manage the @v0idai main account. There is no automated mechanism to silence satellite accounts because they are managed separately (per accounts.md). The crisis procedure does not document HOW to silence them: are they posting via OpenTweet too? Via manual posting? Via separate n8n workflows?

If satellite accounts are posting via OpenTweet using separate API calls, the operator needs to log into OpenTweet and cancel those separately. If they are posting manually, the operator needs to notify anyone managing those accounts. Neither procedure is documented.

---

## 7. Cross-Document Consistency [MEDIUM]

### 7a: Environment Variable Table Discrepancies

The specs doc env var table (lines 34-63) lists these variables. The pipeline-architecture.md Section 8 (lines 714-760) lists variables in multiple subsections. Comparison:

| Variable | In Specs? | In Pipeline Arch? | Notes |
|----------|-----------|-------------------|-------|
| `EMERGENCY_STOP` | Yes (line 36) | Yes (Section 8.1, line 718) | Consistent |
| `DRY_RUN` | Yes (line 37) | Yes (Section 8.1, line 719) | Consistent |
| `BRIDGE_TX_THRESHOLD` | Yes (line 56, as `BRIDGE_TX_THRESHOLD`) | Yes (Section 8.3, line 752, as `BRIDGE_TX_ALERT_THRESHOLD`) | **INCONSISTENT: different variable names** |
| `MAX_POSTS_PER_DAY` | Yes (line 62) | Not listed in Section 8.3 | **Missing from pipeline arch** |
| `MIN_POST_GAP_MINUTES` | Yes (line 63) | Not listed in Section 8.3 | **Missing from pipeline arch** |
| `BRIDGE_ALERTS_MAX_PER_DAY` | Not listed | Yes (Section 8.3, line 753) | **Missing from specs** |
| `NEWS_RELEVANCE_THRESHOLD` | Not listed | Yes (Section 8.3, line 754) | **Missing from specs** |
| `WEEKLY_RECAP_DAY` | Not listed | Yes (Section 8.3, line 755) | **Missing from specs** |
| `WEEKLY_RECAP_TIME` | Not listed | Yes (Section 8.3, line 756) | **Missing from specs** |
| `DAILY_METRICS_TIME` | Not listed | Yes (Section 8.3, line 757) | **Missing from specs** |
| `SCHEDULER_INTERVAL_MIN` | Not listed | Yes (Section 8.3, line 758) | **Missing from specs** |
| `MAX_RETRIES` | Not listed | Yes (Section 8.3, line 759) | **Missing from specs** |
| `V0IDAI_X_USER_ID` | Not listed | Yes (Section 8.3, line 760) | **Missing from specs** |
| `OUTSTAND_API_KEY` | Yes (line 48) | Yes (Section 8.2) | Consistent |
| `OUTSTAND_API_BASE` | Yes (line 49) | Not listed | **Missing from pipeline arch** |

The most operationally significant discrepancy: `BRIDGE_TX_THRESHOLD` (specs) vs. `BRIDGE_TX_ALERT_THRESHOLD` (pipeline arch). The WF2 JSON uses `$env.BRIDGE_TX_THRESHOLD`. If the operator reads pipeline-architecture.md and sets `BRIDGE_TX_ALERT_THRESHOLD`, WF2 will not find it and the threshold check will fail or use a default.

### 7b: Workflow Numbering Inconsistency

The pipeline-architecture.md Section 6 (line 552-570) lists:
- WF1-5: Active Phase 2 workflows
- WF5a: Blog Distribution
- WF6: Competitor Monitor
- WF7: Email Campaign (Mautic)

The specs doc and workflow JSON files number them:
- WF1-5: Active
- WF6: Competitor Monitor
- WF7: Blog Distribution Pipeline

The pipeline arch calls Blog Distribution "WF5a" and adds an "Email Campaign" as WF7 that does not exist in the specs or as a JSON file. The specs call Blog Distribution "WF7" and Competitor Monitor "WF6." This is confusing.

Additionally, the pipeline-architecture.md diagram (line 73-79) labels WF5 as "Blog Distro" instead of "Content Calendar Scheduler":

```
|  | WF5: Blog Distro     |  (Phase 3+)            |
```

This is the most misleading inconsistency. In the workflow diagram, "WF5" appears to be Blog Distribution, but the actual WF5 is the Content Calendar Scheduler. Anyone reading the diagram without reading the full workflow map table below it would get the wrong mental model.

### 7c: Workflow Count Consistency

- Specs doc: 7 workflows documented (WF1-WF7)
- Pipeline arch Section 6: 7 workflows in Phase 1-3+ tables, plus 7 more for Phase 4 (WF8-14)
- Workflow JSON files on disk: 7 files
- Crisis.md: References "5 active workflows" (correct for Phase 2)

All consistent at the "7 total, 5 active" level.

---

## 8. Operational Gaps [MEDIUM]

### 8a: No Alerting for Workflow Failures

The pipeline-architecture.md mentions (Section 10.4, line 1019): "n8n Cloud: Platform outage: n8n status page, workflows stop firing." But there is no automated alerting when workflows fail. The operator must manually check the n8n dashboard.

n8n has a "Global Error Workflow" feature (mentioned in the credential setup checklist at specs doc line 206). The checklist says: "Global error workflow is configured (Settings > Workflows > Error Workflow) to send notifications to a separate channel (e.g., email or Telegram) as a failsafe if Discord is down." But this is listed as a checkbox item, not as a specific workflow to build. No JSON file for the error workflow exists. No specification for what this error workflow should look like is provided.

**Recommendation:** Create a `workflow-0-error-handler.json` that accepts error webhook from n8n's global error handler and sends notifications to both Discord and a secondary channel (email or Telegram). This should be specified and included in the JSON file set.

### 8b: No On-Call or Escalation Procedure

The crisis.md assumes a single operator (Vew). There is no documented procedure for:
- What happens if Vew is unavailable during a crisis?
- Who else has access to the n8n dashboard?
- Who else has credentials to the provider dashboards (X, OpenTweet, Anthropic)?
- Is there a shared password manager? A backup access procedure?

For a single-operator system this is somewhat expected, but for a project managing a cross-chain bridge with real user funds, at least a documented backup access procedure should exist.

### 8c: No Monitoring Dashboard

The system produces notifications via Discord, but there is no consolidated monitoring view showing:
- Which workflows ran successfully today
- Current queue depth (drafts, approved, scheduled)
- API error rates over the last 24 hours
- Daily post count vs. limits
- Static data utilization (how close to the 256KB limit)

The n8n Cloud execution log provides some of this, but it requires manual checking. A simple daily digest workflow (e.g., a "WF0: System Health" that runs at 11 PM ET and summarizes the day's execution results) would be valuable.

### 8d: No Queue Depth Alerting

If the queue grows beyond a threshold (e.g., 100+ items in `drafts/` or `approved/` with no human review), no alert is generated. Content can pile up indefinitely during periods when Vew is not reviewing. For a system that depends on human review as a primary security control, the absence of "content waiting for review" alerts is a gap.

### 8e: No Automated Testing of Kill Switch

There is no scheduled test of the EMERGENCY_STOP mechanism. The operational checklists (Section 11.1-11.3) do not include "Test EMERGENCY_STOP: set to true, run workflow, verify halt, set back to false." Kill switches that are never tested often fail when needed. Military and aviation practices require periodic testing of emergency shutoff systems.

**Recommendation:** Add to the Monthly Review (Section 11.3): "Test EMERGENCY_STOP: set to true, manually trigger WF1, verify it halts, verify Discord notification is received, set back to false."

### 8f: Spec Doc Still Contains Filesystem Code

The specs doc contains the original filesystem-based dedup code for WF2 (lines 681-708) and WF4 (lines 1244-1257), using `require('fs')` and `readFileSync/writeFileSync`. The workflow JSONs have been updated to use `$getWorkflowStaticData('global')`. But the specs doc was not updated to match. An operator reading the specs doc for WF2's Node 5 (Deduplicate) would see the old filesystem-based code, while the actual JSON uses static data.

Similarly, WF4's Node 3 (Filter RSS for Relevance) in the specs doc (line 1244) still uses filesystem-based deduplication, but the workflow JSON may or may not have been updated (I was unable to read the full WF4 JSON to verify).

The specs doc's WF1 Node 11 (DRY_RUN Log) still uses `require('fs')` and `writeFileSync` (lines 447-467), while the WF1 JSON uses Discord notifications for logging.

**This is a documentation-implementation divergence.** The specs doc should be updated to reflect the actual JSON implementations.

---

## Findings Summary Table

| # | Finding | Severity | Category |
|---|---------|----------|----------|
| 1 | EMERGENCY_STOP not in any workflow JSON | CRITICAL | Implementation gap |
| 1b | No mid-execution EMERGENCY_STOP check before posting | HIGH | Design gap |
| 2a | WF5 time slot comments wrong for EST | LOW | DST inconsistency |
| 2b | WF3 posts outside peak window in both seasons | INFO | Scheduling |
| 3a | OpenTweet key expiry 2026-03-22 not flagged | MEDIUM | Credential management |
| 3b | CANVA_API_TOKEN, SLACK_TOKEN missing from rotation runbook | LOW | Credential management |
| 3c | N8N_ENCRYPTION_KEY not backed up or documented | MEDIUM | Credential management |
| 3d | No emergency rotation procedure (compromise scenario) | MEDIUM | Operational |
| 4 | Specs doc Code pattern vs. JSON IF pattern (minor) | LOW | Docs inconsistency |
| 5a | n8n Cloud execution time limits undocumented | MEDIUM | Platform limitations |
| 5b | n8n Cloud concurrent execution limits undocumented | MEDIUM | Platform limitations |
| 5c | Webhook response timeout on Cloud | LOW | Platform limitations |
| 5d | Static data concurrency not clarified | LOW | Platform limitations |
| 6a | WF3/WF5 thread posting not interruptible mid-thread | HIGH | Crisis procedure |
| 6b | OpenTweet scheduled posts survive EMERGENCY_STOP | HIGH | Crisis procedure |
| 6c | Naming inconsistency for WF5 in crisis docs | LOW | Naming |
| 6d | No procedure for silencing satellite accounts | MEDIUM | Crisis procedure |
| 7a | BRIDGE_TX_THRESHOLD vs. BRIDGE_TX_ALERT_THRESHOLD | HIGH | Variable naming |
| 7b | WF5 labeled as "Blog Distro" in pipeline arch diagram | MEDIUM | Document error |
| 7c | Email Campaign (WF7) in pipeline arch not in specs | MEDIUM | Document inconsistency |
| 8a | No error handler workflow JSON exists | MEDIUM | Operational |
| 8b | No backup operator or escalation path | MEDIUM | Operational |
| 8c | No monitoring dashboard | LOW | Operational |
| 8d | No queue depth alerting | LOW | Operational |
| 8e | EMERGENCY_STOP never tested in operational checklist | MEDIUM | Operational |
| 8f | Specs doc still has filesystem code, JSONs use static data | MEDIUM | Docs inconsistency |

## Recommended Fix Priority

**Before import/deployment (blockers):**
1. Add EMERGENCY_STOP check node to all 7 workflow JSONs (Finding 1)
2. Fix BRIDGE_TX_THRESHOLD variable name inconsistency (Finding 7a)
3. Update specs doc code examples to match JSON implementations (Finding 8f)

**Before DRY_RUN=false (high priority):**
4. Document OpenTweet expiry and renewal plan (Finding 3a)
5. Add "Cancel OpenTweet scheduled posts" to crisis procedure (Finding 6b)
6. Add second EMERGENCY_STOP check before publish nodes (Finding 1b)
7. Add n8n Cloud limits to documentation (Findings 5a, 5b)

**Before Phase 3 go-live (medium priority):**
8. Fix WF5 diagram labeling in pipeline-architecture.md (Finding 7b)
9. Add EMERGENCY_STOP test to monthly operational checklist (Finding 8e)
10. Create error handler workflow (Finding 8a)
11. Add emergency rotation procedure (Finding 3d)
12. Document satellite account silencing procedure (Finding 6d)

**Nice to have (low priority):**
13. Fix WF5 time slot comments for EST/EDT (Finding 2a)
14. Add remaining credentials to rotation runbook (Finding 3b)
15. Document N8N_ENCRYPTION_KEY backup (Finding 3c)
16. Add queue depth alerts (Finding 8d)

---

## Final Assessment

The Wave 3 updates address the core audit findings well. The DRY_RUN fail-safe, the Merge node pattern, the credential rotation runbook, and the crisis kill switch procedure are all substantive improvements. The documentation quality is high: procedures are step-by-step, tables are clear, and the reasoning behind design decisions is explained.

The critical gap is that the EMERGENCY_STOP kill switch exists as documentation but not as deployed code. For a crypto bridge project, this must be fixed before any workflow is imported into n8n. Everything else is addressable within a few hours of work.

---

*Challenge review completed 2026-03-15.*
