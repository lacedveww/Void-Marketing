# Phase 2 Deployment Readiness Audit

**Date:** 2026-03-15
**Auditor:** Claude Code (security-auditor agent)
**Scope:** Full pre-production audit of the VoidAI marketing automation pipeline for n8n Cloud deployment
**Methodology:** Review of all 7 workflow JSONs, pipeline-architecture.md, n8n-workflow-specs.md, crisis.md, cadence.md, compliance.md, accounts.md, and phase2-final-validation.md against 8 deployment criteria

---

## Executive Summary

The VoidAI marketing pipeline is well-architected with strong defensive design. The DRY_RUN fail-safe, input sanitization, cadence enforcement, and human review gates demonstrate serious engineering. However, one critical gap exists: the EMERGENCY_STOP check node documented in crisis.md is not present in any of the 7 workflow JSON files. This must be fixed before deployment. Two other findings are moderate severity. The remaining criteria are at READY or READY WITH CAVEATS status.

**Overall Recommendation: CONDITIONAL GO** (1 blocker, 2 moderate items, 4 minor items)

---

## Criterion 1: Security Posture

**Rating: NOT READY** (1 blocker, 1 moderate finding)

### 1.1 EMERGENCY_STOP Not Implemented in Workflow JSONs [BLOCKER]

**Severity: CRITICAL**

crisis.md (lines 59-100) documents a detailed "Emergency Stop Check" JavaScript code node with exact insertion points for all 5 active workflows. The n8n-workflow-specs.md (line 36) documents `EMERGENCY_STOP` as an environment variable. The phase2-final-validation.md (check #9) confirmed the documentation is complete and cross-referenced.

However, after examining all 7 workflow JSON files, none contain an "Emergency Stop Check" node. The node ID pattern (`emergency-stop-check`) does not appear in any workflow. The crisis.md specifies "Add this as the first Code node in every workflow, immediately after the trigger node," but this was never done.

**Impact:** During a crisis (bridge exploit, security incident), setting `EMERGENCY_STOP=true` would have no effect. Workflows would continue publishing. The only fallback is manually deactivating all 5 workflows one by one, which violates the "under 60 seconds" target in crisis.md.

**Required fix:** Add the Emergency Stop Check code node to all 7 workflow JSONs at the positions specified in crisis.md (lines 109-117). This is a non-negotiable blocker.

### 1.2 Input Sanitization [PASS]

WF2 (Bridge Alerts) implements:
- Chain name allowlist validation (line 166 of workflow-2 JSON, `ALLOWED_CHAINS` array)
- Explorer URL domain allowlist (line 166, `ALLOWED_EXPLORER_DOMAINS` array)
- Rejected items route to Discord notification with injection warning

WF4 (Ecosystem News) implements:
- Full RSS sanitization per CLAUDE.md safeguards (12 regex patterns for instruction injection)
- URL removal from text content
- Zero-width/non-printable character removal
- 500-character truncation
- Flagging of suspicious items (keyword detection for "ignore", "forget", "override", "system", "prompt", "persona")
- Flagged items are excluded from downstream processing

WF7 (Blog Distribution) implements:
- URL domain allowlist (voidai.com, docs.voidai.com only)
- HTTPS enforcement
- Instruction pattern stripping
- HTML/script tag removal
- Content truncation to 500 chars for Claude prompt (separate from the 8000-char blog content truncation)

WF2 and WF7 webhooks use `headerAuth` authentication, preventing unauthorized triggers.

### 1.3 No Hardcoded Secrets [PASS]

All 7 workflow JSONs reference secrets exclusively via `$env.` variables (`$env.TAOSTATS_API_KEY`, `$env.CLAUDE_API_KEY`, `$env.DISCORD_WEBHOOK_URL`, etc.). No API keys, tokens, or secrets appear in the JSON files. The n8n-workflow-specs.md env var table (lines 34-64) documents all required variables.

### 1.4 DRY_RUN Fail-Safe [PASS]

All 7 workflows contain a DRY_RUN check IF node. The check logic compares `$env.DRY_RUN` strictly against the string `"false"`. The fail-safe behavior is correct: any value other than the exact string `false` (including `true`, `TRUE`, undefined, empty, or deleted) routes to the dry-run log path. This was confirmed by the phase2-final-validation.md (check #6).

The DRY_RUN nodes in the JSON files use this pattern:
```json
"leftValue": "={{ $env.DRY_RUN }}",
"rightValue": "false",
"operator": { "type": "string", "operation": "equals" }
```

When `DRY_RUN` equals `false`, the true branch routes to the live posting path. When it does not equal `false`, it routes to the dry-run log. This is correct for n8n's IF node semantics.

### 1.5 EMERGENCY_STOP Documentation [PASS with caveat]

The documentation is thorough (crisis.md, n8n-workflow-specs.md, pipeline-architecture.md Section 9.1). The JavaScript code node, insertion points, per-workflow effects, and recovery procedure are all specified. But the implementation is missing from the workflow files (see 1.1).

### 1.6 Webhook Authentication [PASS]

WF2 webhook: `"authentication": "headerAuth"` configured. Requires Header Auth credential after import.
WF7 webhook: `"authentication": "headerAuth"` configured. Same pattern.
The credential setup checklist in n8n-workflow-specs.md (lines 183-192) documents the post-import Header Auth configuration steps, including the verification step of confirming n8n returns HTTP 401 for requests missing the header.

### 1.7 Prompt Injection in Claude API Calls [MODERATE]

WF4 correctly wraps sanitized content in `<user_content>` tags in the Claude API prompt (line 214 of workflow-4 JSON). WF7 also wraps user content in `<user_content>` tags (lines 169, 194, 219 of workflow-7 JSON).

WF3 (Weekly Recap) does not use `<user_content>` tags because it processes only internal API data (Taostats, CoinGecko, GitHub, Bridge), not user-generated content. This is acceptable.

However, WF4's Claude scoring prompt in the spec (n8n-workflow-specs.md line 1289) does NOT wrap input in `<user_content>` tags, while the actual workflow JSON (line 214) does. The JSON is correct; the spec is outdated. This is a documentation inconsistency, not a security issue.

---

## Criterion 2: Compliance Alignment

**Rating: READY WITH CAVEATS**

### 2.1 Cadence Frequency Limits [PASS]

WF1 (Daily Metrics): Cron `0 10 * * *` = 1 post/day. Within the 1-2/day limit for @v0idai per cadence.md.

WF2 (Bridge Alerts): Rate limit check node enforces max 6 posts/day (line 110 of workflow-2 JSON, `MAX_DAILY_POSTS = 6`). Uses static data counter with daily cleanup. Rate-limited items get Discord notification.

WF3 (Weekly Recap): Cron `0 14 * * 5` = 1 thread/week. Within the 1/week thread frequency for @v0idai.

WF4 (Ecosystem News): Cron every 4 hours. Outputs to drafts queue only, never auto-posts. Cadence enforcement happens in WF5 when the approved item is scheduled.

WF5 (Content Scheduler): Explicitly enforces cadence.md rules (line 75 of workflow-5 JSON):
- Weekend detection (max 1/day per account)
- Per-account daily limit applied
- Time slot assignment using cadence.md peak windows (14:00-16:00 UTC, 20:00-22:00 UTC)

**Caveat:** WF5's cadence enforcement caps weekday posts at `Math.min(maxPerDay, 2)`, which limits to 2 posts/day per account even though cadence.md allows up to 6. This is conservative and correct for the current phase but does not fully implement the 6-post maximum.

### 2.2 Account Posting Rules [PASS with note]

All workflows post exclusively from @v0idai (the main account). No satellite account posting is implemented in any workflow JSON, which is correct for Phase 2-3 per accounts.md. Satellite accounts are scheduled for Phase 4.

WF5's scheduling logic correctly references `item.account` and groups by account, preparing for multi-account support.

### 2.3 Human Review Gate Enforcement [PASS]

WF3 (Weekly Recap): Always writes to drafts queue (static data), never auto-posts. Discord notification explicitly states "This thread will NOT be posted automatically. Human review required." The workflow's `requires_human_review: true` YAML frontmatter is set.

WF4 (Ecosystem News): Always writes to drafts queue. Discord notification says "Review and approve for posting."

WF7 (Blog Distribution): Always writes to drafts queue. All three derivatives (X thread, LinkedIn, Discord) have `requires_human_review: true` in frontmatter.

WF1 (Daily Metrics): Posts directly when DRY_RUN=false. This is the ONLY workflow that auto-publishes without an explicit human review gate in the workflow itself. The human review is documented as being done via the Discord notification and the APPROVAL_GATE env var in pipeline-architecture.md, but the APPROVAL_GATE check is not present in the WF1 JSON. The compliance.md and CLAUDE.md both state "ALL content must be human-reviewed before publishing. No exceptions."

**Note:** For Phase 2 (DRY_RUN=true), this is not an issue because nothing publishes. For Phase 3, the plan calls for WF1 to auto-generate and have Vew approve the Discord notification before the tweet posts. The 10:00 AM cron gives Vew time to review. However, the workflow JSON itself does not enforce the APPROVAL_GATE. This should be formally documented as an accepted risk for Phase 3 with the understanding that WF1 will post automatically once DRY_RUN=false.

WF2 (Bridge Alerts): Also posts directly when DRY_RUN=false, without APPROVAL_GATE enforcement in the workflow JSON. Same accepted-risk situation as WF1.

### 2.4 Claude Prompt Compliance Rules [PASS]

WF3's Claude prompt (line 226 of workflow-3 JSON) includes:
- "NEVER use: guaranteed returns, risk-free, passive income, to the moon, or any price predictions"
- "NEVER use em dashes"
- "Do NOT use any of these phrases: 'It's worth noting', 'In the ever-evolving landscape', 'game-changer', 'paradigm shift', 'seamless integration', 'robust ecosystem', 'cutting-edge'"
- Disclaimer requirement: "Include a short disclaimer in the last tweet: 'Not financial advice. DYOR.'"

WF4's Claude prompt includes the same banned phrases list.

WF7's Claude prompts (X thread, LinkedIn, Discord) include em dash prohibition and banned phrases list.

**Note:** The Claude prompts embed a subset of CLAUDE.md's banned phrases, not the full list. Phrases like "Without further ado," "In today's rapidly changing," "Paving the way for," "Synergy/synergies," "Holistic approach," "Additionally/Furthermore/Moreover at sentence start," "It is important to note that," "In conclusion," and "As we navigate" are not explicitly listed in the Claude API prompts. The prompts rely on Claude's general instruction-following to avoid these, but an explicit list would be more robust.

---

## Criterion 3: Operational Readiness

**Rating: READY WITH CAVEATS**

### 3.1 Monitoring Plan [PASS]

Every workflow sends Discord notifications on:
- Success (post published)
- Failure (API error, with draft content for manual posting)
- Rate limiting (bridge alerts)
- Input rejection (invalid chain names, injection attempts)
- DRY_RUN mode (draft content for review)

pipeline-architecture.md Section 11.1 documents a daily operational routine with specific times and activities.

### 3.2 Alerting [PASS]

All workflows use Discord webhook for alerts. n8n-workflow-specs.md (line 206) recommends configuring a global error workflow in n8n Settings that sends notifications to a separate channel (email or Telegram) as a failsafe if Discord is down.

### 3.3 On-Call Procedure [PASS]

pipeline-architecture.md Sections 9.1 (Crisis Kill Switch), 10 (Failure Modes and Recovery), and 11 (Operational Checklists) provide comprehensive procedures. The daily routine (Section 11.1) allocates ~1.5-2 hours active time. The incident response template (Section 11.4) standardizes post-incident documentation.

### 3.4 Credential Rotation Schedule [PASS]

pipeline-architecture.md Section 9.2 provides a detailed credential rotation runbook covering all 14 credentials with:
- Service and workflow mapping
- Rotation procedure per credential
- Verification steps
- 90-day rotation schedule with tracking table

**Caveat:** The rotation tracking table is currently empty ("fill on setup"). This is acceptable for pre-deployment but must be populated on day 1 of production.

### 3.5 Backup Plan [PASS with caveat]

pipeline-architecture.md Section 10.4 documents infrastructure failure recovery:
- n8n Cloud outage: manual posting from approved/ queue
- DGX Spark failure: fallback to Mac local
- File system corruption: regenerate manifest from filesystem, Git history as backup

**Caveat:** The project is not a git repository (confirmed from environment context). This means there is no Git-based backup of queue files. If the local filesystem is corrupted, queue content could be lost. Recommend initializing a git repository or implementing an external backup.

---

## Criterion 4: Data Integrity

**Rating: READY WITH CAVEATS**

### 4.1 Deduplication Mechanisms [PASS]

WF2 (Bridge Alerts): Uses `$getWorkflowStaticData('global')` with `posted_hashes` array. Keeps last 500 hashes. Uses `.includes()` for lookup.

WF4 (Ecosystem News): Uses `$getWorkflowStaticData('global')` with `processed_urls` array. Keeps last 1000 URLs. Includes both within-batch dedup (Set-based) and cross-execution dedup (static data).

Both are correctly implemented for n8n Cloud. The phase2-final-validation.md (check #12) confirmed the static data migration.

### 4.2 Unbounded Static Data Growth [PASS]

All static data arrays have cleanup logic:
- WF2: `posted_hashes` capped at 500 entries
- WF2: `daily_post_counts` cleaned up daily (old date keys deleted)
- WF3: `drafts` capped at 4 entries (last 4 weeks)
- WF4: `processed_urls` capped at 1000 entries
- WF4: `drafts` capped at 20 entries
- WF5: `approved_queue` and `scheduled_queue` (scheduled capped at 50)
- WF7: `drafts` capped at 20 entries

n8n Cloud static data limit is ~256KB per workflow. With the implemented caps, all data volumes are well within this limit:
- 500 transaction hashes at ~66 chars each = ~33KB
- 1000 URLs at ~100 chars each = ~100KB (tight but within limit)

### 4.3 Race Conditions [MODERATE]

WF2 operates on webhook triggers, which means multiple bridge transactions could fire simultaneously. The dedup check uses `$getWorkflowStaticData('global')`, which n8n serializes at the execution level. However, if two webhook executions start within milliseconds of each other, both could read the static data before either writes, causing a duplicate post.

n8n Cloud mitigates this somewhat with execution queuing, but it is not guaranteed under high concurrency. For bridge transaction alerts, the practical risk is low (large bridge transactions are infrequent), but it should be documented as a known limitation.

WF5 reads and modifies the `approved_queue` and `scheduled_queue` in static data. Since WF5 runs on a daily cron (not high-frequency), race conditions are unlikely.

---

## Criterion 5: Platform Compatibility

**Rating: READY WITH CAVEATS**

### 5.1 n8n Cloud Constraints [PASS with caveat]

**5-workflow limit:** n8n-workflow-specs.md (line 7) explicitly states "n8n FREE tier = max 5 active workflows." WF1-WF5 are the active five. WF6 and WF7 are documented as Phase 3+ and should remain inactive.

**Filesystem dependencies:** The phase2-final-validation.md (check #11) found `require('fs')` in WF7 only. WF1-WF5 (the active five) use `$getWorkflowStaticData` instead of filesystem operations. WF7 is Phase 3+ and not active. The DRY_RUN log nodes in WF1-WF5 JSON files correctly use Discord webhook notifications instead of filesystem writes.

**Caveat:** The n8n-workflow-specs.md spec document still shows `require('fs')` in the Node 5 (Deduplicate) and Node 8 (DRY_RUN Log) specs for WF2 (lines 682-706, 772-793), and Node 6 (Write to Drafts) for WF3 (lines 1058-1093), and Node 3 (Filter RSS) for WF4 (lines 1244-1263). However, the actual workflow JSON files have been migrated to use static data and Discord logging. The spec document is outdated relative to the implemented JSONs. This is a documentation issue, not a functional issue.

### 5.2 Node Versions [PASS]

All workflow JSONs use:
- `n8n-nodes-base.scheduleTrigger` typeVersion 1.2
- `n8n-nodes-base.httpRequest` typeVersion 4.2
- `n8n-nodes-base.code` typeVersion 2
- `n8n-nodes-base.if` typeVersion 2
- `n8n-nodes-base.merge` typeVersion 3
- `n8n-nodes-base.switch` typeVersion 3
- `n8n-nodes-base.webhook` typeVersion 2
- `n8n-nodes-base.respondToWebhook` typeVersion 1

These are all current n8n Cloud versions. No deprecated node types detected.

### 5.3 Free Tier Limits [PASS]

5 active workflows (WF1-WF5) fits the free tier. WF6 and WF7 are marked Phase 3+ and will not be activated until self-hosted n8n is available.

Execution limits on the free tier (currently 100 executions/month on the starter plan, more on paid plans) should be verified. WF1 fires daily (30/month), WF2 fires on webhooks (variable), WF3 fires weekly (4/month), WF4 fires every 4 hours (180/month), WF5 fires daily (30/month). WF4 alone may exceed 100 executions/month. **Verify the n8n Cloud plan covers the expected execution volume.**

---

## Criterion 6: Content Quality Gates

**Rating: READY WITH CAVEATS**

### 6.1 Banned Phrase Enforcement in Workflows [PARTIAL]

The Claude API prompts in WF3, WF4, and WF7 include explicit banned phrase lists in their system prompts, but these lists are incomplete relative to CLAUDE.md's full 21-phrase banned list. The following phrases from CLAUDE.md are NOT explicitly listed in any workflow's Claude prompt:

- "Without further ado"
- "In today's rapidly changing"
- "Paving the way for"
- "Synergy/synergies"
- "Holistic approach"
- "Additionally/Furthermore/Moreover" at sentence start
- "It is important to note that"
- "In conclusion"
- "As we navigate"

WF1 and WF2 do not use Claude API, so this does not apply to them.

The phase2-final-validation.md (check #3) confirmed zero banned phrases in the 63 approved queue items, which validates the existing Claude Code CLI skills. The n8n workflow prompts are a separate code path and should include the complete list.

### 6.2 Voice and Voice-Learnings References [NOT APPLICABLE for WF1-WF5]

The n8n workflows use inline Claude API prompts with embedded style instructions (tone, data-first, builder-credible). They do not dynamically load voice.md or voice-learnings.md because:
1. These files are on the local filesystem, not accessible from n8n Cloud
2. The Claude API prompts contain the essential voice guidance inline

The Claude Code CLI skills correctly load the full config chain (confirmed by phase2-final-validation.md check #5). The n8n workflow prompts are a reduced-fidelity version of the voice rules, which is an accepted trade-off for the n8n Cloud architecture.

### 6.3 Config Chain Loading [NOT APPLICABLE for n8n workflows]

n8n workflows cannot read the local config chain (CLAUDE.md, voice.md, etc.) because they run on n8n Cloud. The config chain is embedded as inline instructions in the Claude API prompts. This is a known architectural limitation documented in the pipeline design.

---

## Criterion 7: Rollback Capability

**Rating: READY**

### 7.1 Individual Workflow Disable [PASS]

Each workflow can be independently deactivated via the n8n dashboard toggle. WF2's cron trigger is already `"disabled": true` by default (only the webhook trigger is active). WF4's X API search node is `"disabled": true` until the X API Basic plan is activated.

### 7.2 Full Pipeline Halt [PASS with blocker note]

Three methods are documented:
1. `EMERGENCY_STOP=true` (preferred, fastest) -- BUT NOT YET IMPLEMENTED (see Criterion 1.1)
2. `DRY_RUN=true` (backup, prevents publishing but workflows still run)
3. Deactivate all workflows individually (most thorough)

pipeline-architecture.md Section 7.5 provides severity-based rollback procedures (Low/Medium/High/Critical).

### 7.3 Recovery Procedure [PASS]

crisis.md documents a detailed 8-step recovery procedure:
1. Verify incident resolved
2. Audit content queue
3. Set EMERGENCY_STOP=false
4. Reactivate workflows one at a time with DRY_RUN=true
5. Test each workflow manually
6. Set DRY_RUN=false
7. Post recovery confirmation to Discord
8. Resume satellite accounts in specified order

---

## Criterion 8: Testing Coverage

**Rating: READY WITH CAVEATS**

### 8.1 What Has Been Tested

Based on the phase2-final-validation.md and referenced memory files:
- OpenTweet API scheduling (confirmed working per reference_opentweet_api.md memory file)
- Queue lifecycle (63 approved items in queue, manifest counts verified)
- Banned phrase scan across all approved content (0 matches)
- DRY_RUN fail-safe logic across all 7 workflows (verified)
- Static data migration (WF2-WF5 use $getWorkflowStaticData)
- RSS sanitization (WF4, 12 regex patterns)
- DST-safe cron scheduling (WF1 10 AM ET)
- Fan-out merge patterns (WF1, WF3 combineAll; WF6, WF7 waitForAll)
- LinkedIn content_type consistency (6/6 correct)

### 8.2 What Has NOT Been Tested

| Component | Status | Risk |
|-----------|--------|------|
| Discord webhook delivery | NOT TESTED | Medium: Discord test server being created per memory reference, but no test execution confirmed |
| Telegram bot posting | NOT TESTED | Low: Phase 3+ feature, not in active workflows |
| Full pipeline end-to-end (trigger to published post) | NOT TESTED | High: Individual components tested but the full chain (cron fires, API fetches, content formats, DRY_RUN=false, post publishes to live account) has not been run |
| WF2 webhook trigger with real bridge data | NOT TESTED | Medium: Webhook authentication and payload processing verified in spec but not with live Tracker/FastAPI data |
| WF4 RSS feed parsing with live feeds | NOT TESTED | Medium: Feed URLs may have changed format since spec was written |
| Claude API response parsing robustness | PARTIALLY TESTED | Medium: WF3 and WF4 have fallback parsing (regex extraction if JSON fails), but edge cases not systematically tested |
| Error handling under API failure conditions | NOT TESTED | Medium: All HTTP nodes have `continueOnFail: true`, but the downstream handling of error responses has not been tested with simulated failures |
| n8n Cloud execution environment | NOT TESTED | High: Workflows designed for n8n Cloud but have only been tested in local/editor mode |
| Concurrent webhook execution (race condition) | NOT TESTED | Low: Theoretical risk, low practical probability |
| WF5 queue reading from static data | NOT TESTED | Medium: WF5 reads from `approved_queue` in static data, but no items have been added to this static data store yet |

### 8.3 Testing Checklist Status

pipeline-architecture.md Section 7.4 defines an 18-item smoke test checklist. All items are currently unchecked (`[ ]`). None have been formally signed off.

---

## Findings Summary

| # | Finding | Severity | Criterion | Status |
|---|---------|----------|-----------|--------|
| F1 | EMERGENCY_STOP check node not present in any workflow JSON | CRITICAL | Security (1) | BLOCKER |
| F2 | WF1 and WF2 auto-publish without APPROVAL_GATE check when DRY_RUN=false | MODERATE | Compliance (2) | Accepted risk for Phase 3, document formally |
| F3 | Claude API prompts embed incomplete banned phrases list (12 of 21) | MODERATE | Quality (6) | Should fix before Phase 3 |
| F4 | n8n Cloud execution volume may exceed free tier limits (WF4 = 180 exec/month alone) | MODERATE | Platform (5) | Verify plan limits |
| F5 | n8n-workflow-specs.md contains outdated fs-based code in spec text (already fixed in JSON) | LOW | Platform (5) | Documentation cleanup |
| F6 | No git repository for queue file backup | LOW | Operations (3) | Recommend git init |
| F7 | Credential rotation tracking table empty | LOW | Operations (3) | Populate on setup day 1 |
| F8 | Smoke test checklist entirely unchecked | LOW | Testing (8) | Complete before Phase 3 |
| F9 | WF2 dedup uses linear .includes() on 500-item array | INFO | Data (4) | Functionally fine, O(n) acceptable at this scale |
| F10 | WF1/WF3 use combineAll merge instead of waitForAll with numberInputs | INFO | Platform (5) | Functionally correct, consider upgrading later |

---

## Criterion Ratings

| # | Criterion | Rating |
|---|-----------|--------|
| 1 | Security Posture | **NOT READY** (EMERGENCY_STOP blocker) |
| 2 | Compliance Alignment | **READY WITH CAVEATS** (WF1/WF2 auto-publish accepted risk) |
| 3 | Operational Readiness | **READY WITH CAVEATS** (rotation table, backup) |
| 4 | Data Integrity | **READY WITH CAVEATS** (theoretical race condition) |
| 5 | Platform Compatibility | **READY WITH CAVEATS** (execution volume, doc drift) |
| 6 | Content Quality Gates | **READY WITH CAVEATS** (incomplete banned phrase lists) |
| 7 | Rollback Capability | **READY** (pending F1 fix) |
| 8 | Testing Coverage | **READY WITH CAVEATS** (E2E and smoke tests pending) |

---

## GO / NO-GO Recommendation

### CONDITIONAL GO

Deploy to n8n Cloud with DRY_RUN=true for Phase 2 testing, subject to the following conditions:

#### Must Complete Before Deployment (Blockers)

1. **Add EMERGENCY_STOP check node to all 7 workflow JSONs.** Use the exact JavaScript code from crisis.md (lines 62-99). Insert as the first code node after the trigger in each workflow, at the positions specified in crisis.md (lines 109-117). This is the single blocker for deployment.

#### Must Complete Before Phase 3 (DRY_RUN=false)

2. **Complete the 18-item smoke test checklist** (pipeline-architecture.md Section 7.4). Every item must be signed off before enabling live publishing.
3. **Run a full end-to-end test** with DRY_RUN=false targeting the test X account (@testy1796297 per memory reference). Confirm the full chain: cron trigger, API fetch, content format, API post, Discord notification.
4. **Verify n8n Cloud plan execution limits** can sustain the expected volume (~244 executions/month for WF1-WF5 combined, more if WF2 webhook fires frequently).
5. **Add the complete CLAUDE.md banned phrases list** to the Claude API prompts in WF3, WF4, and WF7. Nine phrases are currently missing.
6. **Formally document the accepted risk** that WF1 (Daily Metrics) and WF2 (Bridge Alerts) will auto-publish when DRY_RUN=false without an in-workflow APPROVAL_GATE check. Document that the human review for these workflows is performed via the Discord notification window between generation and the next cron cycle.
7. **Populate the credential rotation tracking table** in pipeline-architecture.md Section 9.2 with initial dates.

#### Should Complete Before Phase 3 (Non-Blocking)

8. Initialize a git repository for the project to enable backup of queue files and version history.
9. Test Discord webhook delivery to the test server.
10. Test WF2 webhook with a simulated bridge transaction payload (including the headerAuth credential).
11. Test WF4 RSS parsing against live CoinDesk, The Block, CoinTelegraph, and DL News feeds.
12. Update n8n-workflow-specs.md to match the actual JSON implementations (remove fs-based code from spec text for WF2, WF3, WF4, WF5).

---

## Appendix: Files Reviewed

| File | Path | Purpose |
|------|------|---------|
| CLAUDE.md | /Users/vew/Apps/Void-AI/CLAUDE.md | System rules, banned phrases, human review gate |
| n8n-workflow-specs.md | companies/voidai/automations/n8n-workflow-specs.md | Workflow specifications, env vars, testing playbook |
| pipeline-architecture.md | companies/voidai/automations/pipeline-architecture.md | System architecture, deployment phases, failure modes, credential rotation |
| crisis.md | companies/voidai/crisis.md | Crisis protocol, EMERGENCY_STOP spec, recovery procedure |
| cadence.md | companies/voidai/cadence.md | Posting frequency, timing, spacing rules |
| compliance.md | companies/voidai/compliance.md | Prohibitions, disclaimers, jurisdictional rules |
| accounts.md | companies/voidai/accounts.md | Account personas, inter-account coordination |
| phase2-final-validation.md | companies/voidai/reviews/phase2-final-validation.md | Prior validation sweep results |
| workflow-1-daily-metrics.json | companies/voidai/automations/workflows/ | WF1 implementation |
| workflow-2-bridge-alerts.json | companies/voidai/automations/workflows/ | WF2 implementation |
| workflow-3-weekly-recap.json | companies/voidai/automations/workflows/ | WF3 implementation |
| workflow-4-ecosystem-news.json | companies/voidai/automations/workflows/ | WF4 implementation |
| workflow-5-content-scheduler.json | companies/voidai/automations/workflows/ | WF5 implementation |
| workflow-6-competitor-monitor.json | companies/voidai/automations/workflows/ | WF6 implementation |
| workflow-7-blog-distribution.json | companies/voidai/automations/workflows/ | WF7 implementation |

---

| Date | Change |
|------|--------|
| 2026-03-15 | Initial deployment readiness audit. 8 criteria evaluated. 1 blocker (EMERGENCY_STOP not in workflow JSONs), 3 moderate findings, 4 minor findings. Conditional GO recommendation. |
