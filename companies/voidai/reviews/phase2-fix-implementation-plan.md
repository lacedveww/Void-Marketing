# Phase 2 Fix Implementation Plan

**Date**: 2026-03-15
**Status**: READY TO EXECUTE
**Total Agents**: 12 (organized in 3 waves for dependency order)
**Estimated Fixes**: 45+ individual changes across 30+ files

---

## Wave 1: Root Cause Fixes (Deploy First)
Config file contamination must be fixed before skills/content, because skills read these files and will copy banned patterns.

---

### Agent 1: Config File Double Hyphen Purge
**Type**: code-reviewer (edit mode)
**Priority**: P0 (root cause)
**Files**:
- `companies/voidai/accounts.md` lines 68, 72, 97, 101, 112, 119 — Replace ` -- ` with `: ` or `, ` in all satellite hook formulas and disclaimers
- `companies/voidai/compliance.md` line 96 — Replace `"Not financial advice -- do your own research."` with `"Not financial advice. Do your own research."`
- `companies/voidai/voice.md` lines 74-78 — Replace ` -- ` with `: ` in priority hierarchy list
- `companies/voidai/company.md` — Add date qualifier to "~5 weeks" lending timeline

**Prompt**:
> Fix double hyphens in VoidAI config template files. These are ROOT CAUSE fixes — skills copy from these templates, so banned patterns here contaminate all generated content.
>
> Read and fix these files:
> 1. `/Users/vew/Apps/Void-AI/companies/voidai/accounts.md` — Find ALL instances of ` -- ` (space-hyphen-hyphen-space) and replace with appropriate punctuation (colon, comma, or period depending on context). There are at least 6 instances at lines 68, 72, 97, 101, 112, 119. These are in hook formula templates and disclaimer templates. Do NOT change YAML separators (---) or HTML comments.
> 2. `/Users/vew/Apps/Void-AI/companies/voidai/compliance.md` — Line 96: Replace `"Not financial advice -- do your own research."` with `"Not financial advice. Do your own research."`
> 3. `/Users/vew/Apps/Void-AI/companies/voidai/voice.md` — Lines 74-78: Replace ` -- ` with `: ` in priority hierarchy entries.
> 4. `/Users/vew/Apps/Void-AI/companies/voidai/company.md` — Find the "~5 weeks" lending timeline reference and add a date qualifier (e.g., "~5 weeks from March 2026" or replace with target date).
>
> After fixing, grep the entire `companies/voidai/` directory for ` -- ` to confirm zero remaining violations (excluding YAML --- separators and HTML comment delimiters <!-- -->).
>
> Read CLAUDE.md first for the full formatting rules. NEVER use em dashes either.

---

### Agent 2: Stale Data Refresh
**Type**: general-purpose
**Priority**: P0
**Files**:
- `companies/voidai/metrics.md` lines 19-23 — Update TAO price, market cap, volume (NOT rank, #36 is correct)
- 8 queue items with "68% staked" → use generic "majority staked" or fetch current (76.27%)
- `companies/voidai/queue/approved/20260313-linkedin-l6-sn106-subnet.md` lines 88-89 — Remove hardcoded $1.01 price, $3.02M cap, $153K volume

**Prompt**:
> Refresh stale data across VoidAI content and config files. The fresh data reference is at `/Users/vew/Apps/Void-AI/companies/voidai/research/fresh-data-march2026.md` — read it first for current numbers.
>
> Read CLAUDE.md first for formatting rules.
>
> Fixes needed:
>
> 1. `/Users/vew/Apps/Void-AI/companies/voidai/metrics.md` lines 19-23: Update TAO price ($221.74 → use generic "live via CoinGecko"), market cap ($2.39B → $2.77B or generic), 24h volume ($231.3M → use generic). Do NOT change CMC rank (#36 is correct and current).
>
> 2. Grep for "68% stak" across `/Users/vew/Apps/Void-AI/companies/voidai/queue/` — there are 8 items with this stale figure. Replace each with "majority staked" or a generic phrase. The actual figure is 76.27% but will go stale again. Prefer generic language. Affected files include: x12-post-halving, x16-staking-explainer, satellite-s5-ecosystem-halving, l3-halving-analysis, t3-bittensor-post-halving, b3-bittensor-cross-chain-defi.
>
> 3. `/Users/vew/Apps/Void-AI/companies/voidai/queue/approved/20260313-linkedin-l6-sn106-subnet.md` lines 88-89: The hardcoded token price ($1.01), market cap ($3.02M), and volume (~$153K) are stale. Replace with generic language like "Check live data at [CoinGecko link]" or remove the specific numbers entirely. Also on line 83: replace "emissions reward top performers" with "emissions distribute to top performers".
>
> 4. After all fixes, grep for "$221", "$2.39", "68% stak", "$1.01", "$3.02M" across the entire companies/voidai/ directory to confirm zero stale references remain.
>
> IMPORTANT: Do not introduce em dashes (—) or double hyphens ( -- ) in any replacement text.

---

### Agent 3: Queue Manager + Product Marketing Context Cleanup
**Type**: code-reviewer (edit mode)
**Priority**: P0
**Files**:
- `.claude/skills/queue-manager/SKILL.md` — Remove all em dashes (—) and double hyphens ( -- )
- `.agents/product-marketing-context.md` — Remove all 31 em dashes

**Prompt**:
> Clean em dashes and double hyphens from two critical files. These are the compliance enforcement tool and the marketing context file.
>
> Read CLAUDE.md first for the banned formatting rules.
>
> 1. Read `/Users/vew/Apps/Void-AI/.claude/skills/queue-manager/SKILL.md` — Find and replace ALL em dashes (—) and double hyphens ( -- ) with appropriate punctuation (colon, comma, period, or line break depending on context). There are approximately 30 em dashes and multiple double hyphens including: line 21 (`-- regenerated`), lines 48-51 (table columns), line 371 (`"yield farming" -- OK if educational`). This file is the COMPLIANCE ENFORCEMENT tool, so it must be spotless.
>
> 2. Read `/Users/vew/Apps/Void-AI/.agents/product-marketing-context.md` — Find and replace ALL em dashes (—) with appropriate punctuation. There are approximately 31 instances.
>
> After fixing both files, grep each for em dashes (—) and ` -- ` to confirm zero remaining.

---

## Wave 2: Skill + Content Fixes (Deploy After Wave 1)
These read from the config files fixed in Wave 1.

---

### Agent 4: Content Skills Config Chain Fix
**Type**: code-reviewer (edit mode)
**Priority**: P1
**Files**: All 6 content generation skills in `.claude/skills/`

**Prompt**:
> Update all 6 VoidAI content generation skills to properly reference the config chain and compliance rules.
>
> Read `/Users/vew/Apps/Void-AI/CLAUDE.md` first for the Config Load Order (items 1-12).
>
> For EACH of these 6 skill files, apply these fixes:
>
> 1. `.claude/skills/generate-thread/SKILL.md`
> 2. `.claude/skills/generate-tweet/SKILL.md`
> 3. `.claude/skills/lending-teaser/SKILL.md`
> 4. `.claude/skills/weekly-report/SKILL.md`
> 5. `.claude/skills/data-card/SKILL.md`
> 6. `.claude/skills/subnet-spotlight/SKILL.md`
>
> **Fix A — Config chain reference**: Find the section where the skill lists files to read. Add a line: `Read all config files per CLAUDE.md Config Load Order (items 1-8 minimum). Additionally read: companies/{ACTIVE_COMPANY}/brand/voice-learnings.md (mandatory for any content generation).` Do NOT duplicate the full 12-file list. Reference CLAUDE.md as the source of truth.
>
> **Fix B — Explicit compliance block**: Find any section that says "Standard checks" or has vague compliance language. Replace with:
> ```
> Compliance checks (all must pass):
> - Zero banned AI phrases (full list in CLAUDE.md)
> - Zero em dashes (—) or double hyphens ( -- )
> - Character count within platform limit
> - Appropriate disclaimer included per compliance.md
> - No price predictions or guaranteed returns
> - Voice matches assigned account register per voice.md
> ```
> For skills that already have explicit checks (generate-thread, generate-tweet), verify they include double hyphens in the ban and add if missing.
>
> **Fix C — lending-teaser example**: In `.claude/skills/lending-teaser/SKILL.md`, find the example that says `"What if you could borrow against your TAO?"` and change it to `"What if you could access liquidity without selling your TAO?"` — the skill's own compliance section says use "access liquidity" not "borrow".
>
> **Fix D — Queue check reminder**: Add to each skill's output/closing section: `After saving draft, remind user to run /queue check <id> for compliance validation.`
>
> IMPORTANT: Do NOT introduce any em dashes or double hyphens in your edits. Use colons, commas, or periods instead.

---

### Agent 5: LinkedIn Content Fixes
**Type**: code-reviewer (edit mode)
**Priority**: P1
**Files**: 6 LinkedIn content files in queue/approved/

**Prompt**:
> Fix all issues identified by the LinkedIn voice review and challenger reports for VoidAI LinkedIn content.
>
> Read these first:
> - `/Users/vew/Apps/Void-AI/CLAUDE.md` (formatting rules)
> - `/Users/vew/Apps/Void-AI/companies/voidai/voice.md` (voice rules)
> - `/Users/vew/Apps/Void-AI/companies/voidai/compliance.md` (compliance rules)
>
> Then apply these fixes:
>
> **L3** (`/Users/vew/Apps/Void-AI/companies/voidai/queue/approved/20260313-linkedin-l3-halving-analysis.md`):
> 1. Line 90: Replace "68% staking rate" with "majority staking rate" (the editor note at line 110 intended this but it was never applied)
> 2. Line 92: Rephrase "which subnets will capture value" to remove implicit buy signal near SN106 mention. Suggest: "which subnets will sustain real usage"
> 3. Line 96: Remove the Kaito mindshare reference entirely (will be kept in L1 only)
> 4. Verify total character count including disclaimer is under 3,000. If over, trim content (not disclaimer)
>
> **L6** (`/Users/vew/Apps/Void-AI/companies/voidai/queue/approved/20260313-linkedin-l6-sn106-subnet.md`):
> 1. Lines 88-89: Remove hardcoded price ($1.01), market cap ($3.02M), and volume (~$153K). Replace with generic: "Live metrics available at app.voidai.com" or similar
> 2. Line 83: Replace "emissions reward top performers" with "emissions distribute to top performers"
> 3. Line 87: Remove the Kaito mindshare reference (will be kept in L1 only)
> 4. Verify total character count including disclaimer is under 3,000
>
> **L5** (`/Users/vew/Apps/Void-AI/companies/voidai/queue/approved/20260313-linkedin-l5-developer-case.md`):
> 1. Find the LunarCrush "#2 AI coin by mindshare" claim and add date qualification: "as of [date from research file]"
>
> **L1** (`/Users/vew/Apps/Void-AI/companies/voidai/queue/approved/20260313-linkedin-l1-company-intro.md`):
> 1. Keep the Kaito reference (this will be the only item with it). No changes needed unless data is stale.
>
> **All 6 LinkedIn files**: Update frontmatter `content_type` from "article" to "post" if any still say "article"
>
> IMPORTANT: Do NOT introduce em dashes or double hyphens. Do NOT add banned AI phrases.

---

### Agent 6: Queue Human Review Flag
**Type**: code-reviewer (edit mode)
**Priority**: P1
**Files**: 13 items with `reviewed_by: ""`

**Prompt**:
> Flag 13 VoidAI queue items that were approved without human review. Per CLAUDE.md and base-rules.md, ALL content must be human-reviewed before publishing.
>
> These items have `reviewed_by: ""` in frontmatter:
> - e1, e2, e3, e4 (engagement items)
> - s15, s16, s17, s18, s19, s20 (satellite items)
> - ss1, ss2, ss3 (subnet spotlight items)
>
> Search in `/Users/vew/Apps/Void-AI/companies/voidai/queue/approved/` for files with `reviewed_by: ""` in their frontmatter.
>
> For EACH file found:
> 1. Change `status: "approved"` to `status: "review"` in frontmatter
> 2. Keep `reviewed_by: ""` as-is (human will fill this in)
> 3. Add an editor note at the bottom: `<!-- FLAGGED 2026-03-16: Moved back to review status. Requires human review before publishing per CLAUDE.md human review gate. -->`
>
> Also update the manifest file at `/Users/vew/Apps/Void-AI/companies/voidai/queue/manifest.json`:
> - For each flagged item, change status from "approved" to "review"
> - Update the count fields in the manifest header
>
> After all changes, count how many items were moved to review status and report the number.

---

### Agent 7: Queue Misc Fixes
**Type**: code-reviewer (edit mode)
**Priority**: P2
**Files**: Various queue items

**Prompt**:
> Fix miscellaneous queue issues identified in the VoidAI content audit.
>
> Read CLAUDE.md first for formatting rules.
>
> 1. **LinkedIn manifest content_type**: In `/Users/vew/Apps/Void-AI/companies/voidai/queue/manifest.json`, find all 6 LinkedIn entries (l1 through l6) and change `content_type: "article"` to `content_type: "post"`. (The files were already fixed by Agent 5, this syncs the manifest.)
>
> 2. **DC1 data card double hyphens**: Find the dc1 data card file in `/Users/vew/Apps/Void-AI/companies/voidai/queue/approved/` (search for files containing "dc1" or "data-card"). Check for double hyphens in table formatting. Replace ` -- ` with proper table separators or colons.
>
> 3. **Kaito mindshare cross-item**: Grep for "Kaito" across all files in `queue/approved/`. The references should only remain in L1 (company intro). If any other items besides L1 still have Kaito references after Agent 5's fixes, remove them or replace with different proof points.
>
> 4. **Stale "128 subnets"**: Grep for `"128 subnets"` (without +). Any instance should be `"128+ subnets"`. Fix any that are missing the +.
>
> Do NOT introduce em dashes or double hyphens.

---

## Wave 3: n8n Workflow + Pipeline Fixes (Deploy After Wave 2)
These are code-level fixes to the automation infrastructure.

---

### Agent 8: n8n Active Workflow Fixes (WF1-WF5)
**Type**: security-auditor (edit mode)
**Priority**: P1
**Files**: workflow-1 through workflow-5 JSON files

**Prompt**:
> Fix security and correctness issues in VoidAI's 5 active n8n workflow JSON files. These fixes are based on auditor + challenger findings.
>
> Read the audit and challenger reports first for context:
> - `/Users/vew/Apps/Void-AI/companies/voidai/reviews/phase2-n8n-workflow-audit.md`
> - `/Users/vew/Apps/Void-AI/companies/voidai/reviews/phase2-n8n-challenge.md`
>
> Then read and fix each workflow:
>
> **WF1** (`/Users/vew/Apps/Void-AI/companies/voidai/automations/workflows/workflow-1-daily-metrics.json`):
> 1. **Fan-out merge fix**: Add a Merge node (type: "merge", mode: "waitForAll") between the parallel HTTP Request nodes and the "Merge Data" Code node. This prevents the Code node from executing 4x.
> 2. **DRY_RUN fail-safe**: In the dry-run check node, change the condition logic so undefined/null/empty DRY_RUN defaults to dry-run mode (safe). Use: check if DRY_RUN strictly equals "false" to publish, otherwise dry-run.
> 3. **Switch node fix**: Verify the Switch node for POSTING_API correctly routes to opentweet vs x_api. The current index-based routing may silently fail.
> 4. **DST fix**: Change cron from `0 9 * * *` to `0 10 * * *` (America/New_York) so it hits 14:00 UTC in summer and 15:00 UTC in winter, within the cadence peak window.
> 5. **Success notification**: Add error checking after the post node — only send "success" Discord notification if the post API returned 2xx.
>
> **WF2** (`workflow-2-bridge-alerts.json`):
> 1. **Input validation**: In the "Format Alert Tweet" Code node, add a chain name allowlist. If `source_chain` or `dest_chain` is not in the allowlist, reject the item (don't use the raw value as fallback). Add explorer URL domain validation (only allow known block explorer domains).
> 2. **DRY_RUN fail-safe**: Same as WF1.
> 3. **Rate limiting**: Add rate limit check before posting (max 6 posts/day per cadence.md).
> 4. **Dedup → static data**: Replace `require('fs')` dedup with `$getWorkflowStaticData('global')` for cross-execution persistence on n8n Cloud.
>
> **WF3** (`workflow-3-weekly-recap.json`):
> 1. **Fan-out merge fix**: Same pattern as WF1.
> 2. **DRY_RUN fail-safe**: Same as WF1.
> 3. **Double hyphen**: Find `' -- OVER LIMIT'` string and replace with `: OVER LIMIT`.
>
> **WF4** (`workflow-4-ecosystem-news.json`):
> 1. **RSS input sanitization**: Add a Code node after RSS fetch that strips instruction-like patterns, removes URLs, truncates to 500 chars per CLAUDE.md safeguards. This is the only active workflow processing external text.
> 2. **DRY_RUN fail-safe**: Same as WF1.
> 3. **Dedup → static data**: Replace fs-based URL tracking with static data.
>
> **WF5** (`workflow-5-content-scheduler.json`):
> 1. **DRY_RUN fail-safe**: Same as WF1.
> 2. **File ops → static data**: Replace fs-based queue management with static data or HTTP-based approach.
>
> IMPORTANT: Maintain valid JSON throughout. Test that node connections remain intact after adding Merge nodes. Keep all $env references (never hardcode credentials).

---

### Agent 9: n8n Phase 3+ Workflow Fixes (WF6-WF7)
**Type**: security-auditor (edit mode)
**Priority**: P2 (not active yet)
**Files**: workflow-6, workflow-7

**Prompt**:
> Fix security issues in VoidAI's 2 Phase 3+ n8n workflow JSON files. These are not yet active but should be fixed before deployment.
>
> Read the audit/challenger reports:
> - `/Users/vew/Apps/Void-AI/companies/voidai/reviews/phase2-n8n-workflow-audit.md`
> - `/Users/vew/Apps/Void-AI/companies/voidai/reviews/phase2-n8n-challenge.md`
>
> **WF7** (`/Users/vew/Apps/Void-AI/companies/voidai/automations/workflows/workflow-7-blog-distribution.json`):
> 1. **Content sanitization**: Add a Code node after the webhook "Validate Input" node that sanitizes blog content per CLAUDE.md prompt injection safeguards: strip instruction-like patterns, remove URLs from content body (keep the url field), truncate to 500 chars per Claude prompt input, remove non-printable characters.
> 2. **URL validation**: Add domain validation for the `url` field (allow only known blog domains). The current code says "URL validated separately" but no validation exists.
> 3. **Fan-out merge fix**: Add Merge waitForAll before "Write All Drafts".
> 4. **Response node**: Add a Response node so webhook callers get confirmation/error status.
> 5. **DRY_RUN fail-safe**: Same pattern as WF1.
>
> **WF6** (`workflow-6-competitor-monitor.json`):
> 1. **DRY_RUN fail-safe**: Same pattern.
> 2. **Fan-out merge fix if applicable**: Check if fan-out pattern exists.
>
> Maintain valid JSON. Keep all $env references.

---

### Agent 10: n8n Workflow Spec Update
**Type**: code-reviewer (edit mode)
**Priority**: P2
**Files**: n8n-workflow-specs.md, pipeline-architecture.md

**Prompt**:
> Update VoidAI's n8n documentation to reflect all workflow fixes and add missing operational procedures.
>
> Read the current specs:
> - `/Users/vew/Apps/Void-AI/companies/voidai/automations/n8n-workflow-specs.md`
> - `/Users/vew/Apps/Void-AI/companies/voidai/automations/pipeline-architecture.md`
>
> And the fix reports:
> - `/Users/vew/Apps/Void-AI/companies/voidai/reviews/phase2-n8n-workflow-audit.md`
> - `/Users/vew/Apps/Void-AI/companies/voidai/reviews/phase2-n8n-challenge.md`
> - `/Users/vew/Apps/Void-AI/companies/voidai/reviews/phase2-security-challenge.md`
>
> Updates needed:
>
> 1. **DST correction in spec**: The spec says "9 AM ET = 14:00 UTC" for both summer and winter. This is wrong. 9 AM EDT = 13:00 UTC, 9 AM EST = 14:00 UTC. Update to reflect the new 10 AM ET cron and correct UTC equivalents.
>
> 2. **DRY_RUN documentation**: Add a note that DRY_RUN defaults to safe (dry-run) when undefined. Document the fail-safe logic.
>
> 3. **Merge node documentation**: Document the Wait For All merge pattern added to WF1, WF3, WF6, WF7.
>
> 4. **n8n Cloud compatibility notes**: Add a section documenting that fs operations don't persist between executions on n8n Cloud. Document the static data migration for dedup.
>
> 5. **Credential setup checklist**: Add a deployment checklist with all credentials that need to be configured post-import (headerAuth for WF2/WF7 webhooks, OAuth for WF1 X API, all env vars).
>
> 6. **Crisis kill switch procedure**: Add to pipeline-architecture.md Section 9: document how to immediately halt all publishing (set DRY_RUN=true in n8n, deactivate workflows).
>
> 7. **Credential rotation runbook**: Add a section to pipeline-architecture.md documenting which keys exist, how to rotate each one, and how to verify rotation was successful.
>
> Do NOT use em dashes or double hyphens in any text.

---

### Agent 11: Crisis Kill Switch Implementation
**Type**: security-auditor (edit mode)
**Priority**: P1
**Files**: pipeline-architecture.md, new crisis procedure section

**Prompt**:
> Design and document a crisis kill switch for VoidAI's marketing pipeline. This was identified as the highest-consequence gap: during a bridge exploit or security incident, there's currently no way to halt ALL publishing within seconds.
>
> Read:
> - `/Users/vew/Apps/Void-AI/companies/voidai/automations/pipeline-architecture.md`
> - `/Users/vew/Apps/Void-AI/companies/voidai/crisis.md`
> - `/Users/vew/Apps/Void-AI/companies/voidai/automations/n8n-workflow-specs.md`
>
> Design the kill switch:
>
> 1. **Immediate halt mechanism**: A single n8n environment variable `EMERGENCY_STOP=true` that every workflow checks BEFORE any external API call (posting, webhook sends). If true, workflow logs "EMERGENCY STOP ACTIVE" to Discord and exits without posting.
>
> 2. **Activation procedure**: Document step-by-step: (a) Log into vew.app.n8n.cloud, (b) Set EMERGENCY_STOP=true, (c) Deactivate all 5 active workflows, (d) Post manual hold message to Discord. Target: under 60 seconds.
>
> 3. **Recovery procedure**: Document how to safely resume after an incident: (a) Verify incident resolved, (b) Review and purge any queued content referencing the incident, (c) Set EMERGENCY_STOP=false, (d) Reactivate workflows one at a time with DRY_RUN=true, (e) Test each workflow, (f) Set DRY_RUN=false.
>
> 4. **Add EMERGENCY_STOP to the environment variables table** in n8n-workflow-specs.md.
>
> 5. **Update crisis.md** with the technical kill switch procedure (it currently has triggers and communication templates but no technical halt procedure).
>
> Write the EMERGENCY_STOP check as a JavaScript code snippet that can be added to each workflow's first Code node.
>
> Do NOT use em dashes or double hyphens.

---

### Agent 12: Final Validation Sweep
**Type**: code-reviewer
**Priority**: P3 (run after all other agents complete)
**Scope**: Full codebase re-scan

**Prompt**:
> Run a final validation sweep across the entire VoidAI codebase to confirm all fixes from Agents 1-11 were applied correctly. This is the gate check before production.
>
> Read CLAUDE.md first for all rules.
>
> Checks:
>
> 1. **Double hyphens**: Grep entire `companies/voidai/` for ` -- ` (excluding YAML --- and HTML <!-- -->). Must be ZERO.
>
> 2. **Em dashes**: Grep entire repo for — (U+2014). The only acceptable locations are review reports (phase2-*.md). Flag any in config, skills, queue, or automation files.
>
> 3. **Banned phrases**: Grep all queue/approved/ files for every phrase on the banned list in CLAUDE.md. Must be ZERO.
>
> 4. **Stale data**: Grep for "$221", "$2.39B", "68% stak", "$1.01", "$3.02M", "$153K" in any file outside of reviews/ and research/. Must be ZERO.
>
> 5. **Config chain in skills**: Read all 6 content skill files. Verify each now references the CLAUDE.md Config Load Order and voice-learnings.md.
>
> 6. **DRY_RUN fail-safe**: Read WF1-WF5 JSON files. Verify each has the fail-safe DRY_RUN check (defaults to dry-run on undefined).
>
> 7. **Fan-out merge**: Verify WF1, WF3, WF7 have Merge waitForAll nodes.
>
> 8. **Human review flags**: Verify the 13 items have been moved to "review" status.
>
> 9. **EMERGENCY_STOP**: Verify it's documented in n8n-workflow-specs.md env var table and crisis.md.
>
> 10. **LinkedIn content_type**: Verify manifest and files both say "post" not "article" for all 6 LinkedIn items.
>
> Write a pass/fail report to: `/Users/vew/Apps/Void-AI/companies/voidai/reviews/phase2-final-validation.md`

---

## Deployment Order

```
Wave 1 (parallel):  Agent 1 + Agent 2 + Agent 3
  ↓ (wait for completion)
Wave 2 (parallel):  Agent 4 + Agent 5 + Agent 6 + Agent 7
  ↓ (wait for completion)
Wave 3 (parallel):  Agent 8 + Agent 9 + Agent 10 + Agent 11
  ↓ (wait for completion)
Wave 4 (sequential): Agent 12 (final validation)
  ↓
Challengers deployed for any agent with fixes
  ↓
Fix cycle until Agent 12 passes clean
```

## After All Fixes
- Discord webhook e2e test (from main session)
- Telegram bot e2e test (from main session)
- Full daily metrics pipeline e2e (from main session)
- Import WF1-5 into n8n Cloud
- Set all environment variables
- Phase 3 prep
