# VoidAI Phase 1a: System Testing Results (Static Verification)

**Executed by:** Claude Agent (static/structural validation)
**Date:** 2026-03-13
**Scope:** All tests verifiable by reading files and checking structure. Interactive tests documented but not executed.

---

## Summary

| Category | Passed | Failed | Skipped (Interactive) | Notes |
|----------|:------:|:------:|:---------------------:|-------|
| Template Validation (TV) | 5 | 1 | 0 | TV-05 confirmed as known inconsistency |
| Compliance Rules Static Check (CS) | 5 | 0 | 0 | All static checks pass |
| Queue Directory Structure (QD) | 3 | 1 | 0 | Manifest stale |
| Cadence Rules Static Check (CD) | 2 | 1 | 0 | Test plan references non-existent limits |
| Regression Static Checks (RG) | 5 | 0 | 2 | Env var checks need interactive session |
| Queue System Commands (QS) | 0 | 0 | 42 | Require interactive /queue execution |
| Compliance Check Validation (CC) | 0 | 0 | 20 | Require interactive /queue check |
| Cadence Rule Testing (CR) | 0 | 0 | 8 | Require interactive scheduling |
| Edge Case Testing (EC) | 0 | 0 | 9 | Require interactive operations |
| SHOULD FIX Testing (SF) | 1 | 0 | 6 | Most require interactive testing |
| End-to-End Testing (E2E) | 0 | 0 | 6 | Require full interactive lifecycle |
| **TOTAL** | **21** | **3** | **93** | |

---

## 1. Template Validation (Static -- Executed)

### TV-01: All templates have correct status field
- **Result: PASS**
- All 15 templates (note: 15, not 13 as originally planned -- x-reply.md and x-quote-tweet.md were added post-audit) have `status: "drafts"` (plural, not "draft" singular).
- Verified templates: x-single.md, x-thread.md, x-reply.md, x-quote-tweet.md, blog-post.md, linkedin-post.md, discord-announcement.md, podcast-notebooklm.md, video-script.md, video-google-veo.md, image-social-graphic.md, image-content-hero.md, infographic.md, data-card.md, slide-deck.md
- **Note:** Test plan references "13 templates" but SKILL.md table lists 15 and the templates directory contains 15 files. The x-reply.md and x-quote-tweet.md templates were created as part of audit fix #14 (SF-07). Update the test plan count from 13 to 15.

### TV-02: Account field correctness
- **Result: PASS**
- All X templates (x-single, x-thread, x-reply, x-quote-tweet) have `account: ""` -- correct, filled at creation time.
- image-social-graphic.md: `account: ""` -- correct.
- data-card.md: `account: ""` -- correct.
- All other non-X templates (blog-post, linkedin-post, discord-announcement, podcast-notebooklm, video-script, video-google-veo, image-content-hero, infographic, slide-deck) have `account: ""` -- correct.
- **Finding:** The test plan expected non-X templates to have `account: "v0idai"` hardcoded (per audit W6), but all templates actually have `account: ""`. This is the BETTER configuration -- it means `/queue add --account` always works correctly regardless of template. No hardcoding issue exists.

### TV-03: Required frontmatter fields present in all templates
- **Result: PASS (with notes)**
- **Required field checklist** (37 fields from SKILL.md schema):
  `id`, `created_at`, `updated_at`, `status`, `previous_status`, `platform`, `account`, `content_type`, `priority`, `scheduled_post_at`, `earliest_post_at`, `latest_post_at`, `pillar`, `character_count`, `has_media`, `thread_count`, `source_workflow`, `generated_by`, `review_tier`, `compliance_passed`, `prohibited_language`, `disclaimer_included`, `risk_level`, `howey_risk`, `red_flags_found`, `compliance_checked_at`, `requires_approval`, `reviewed_by`, `reviewed_at`, `review_notes`, `rejection_reason`, `posted_at`, `post_id`, `failure_reason`, `dry_run`, `stagger_group`, `stagger_order`

| Template | All 37 Base Fields | Extra Fields |
|----------|--------------------|--------------|
| x-single.md | All present | -- |
| x-thread.md | All present | -- |
| x-reply.md | All present | `reply_to_url`, `reply_to_account`, `engagement_intent` |
| x-quote-tweet.md | All present | `quoted_url`, `quoted_account`, `quote_angle` |
| linkedin-post.md | All present | -- |
| discord-announcement.md | All present | -- |
| blog-post.md | All present | `word_count`, `seo_title`, `seo_description`, `seo_slug`, `seo_keywords`, `derivatives_needed`, `derivative_formats` |
| podcast-notebooklm.md | All present | `estimated_duration`, `tool`, `derivative_formats` |
| video-script.md | All present | `video_duration`, `video_format`, `aspect_ratio`, `tool` |
| video-google-veo.md | All present | `video_duration`, `video_format`, `aspect_ratio`, `tool` |
| image-social-graphic.md | All present | `image_variant`, `image_dimensions`, `image_count`, `tool` |
| image-content-hero.md | All present | `image_variant`, `image_dimensions`, `image_count`, `tool` |
| infographic.md | All present | `dimensions`, `tool` |
| data-card.md | All present | `data_source`, `data_freshness`, `tool` |
| slide-deck.md | All present | `slide_count`, `deck_purpose`, `tool` |

### TV-04: Disclaimer text present in template body
- **Result: PASS**
- Verified disclaimer presence in each template body:

| Template | Disclaimer Present | Location | Type |
|----------|:-----------------:|----------|------|
| x-single.md | Yes | Content section | Short form |
| x-thread.md | Yes | Part N (final) | Short form |
| x-reply.md | Yes | Content section | Short form |
| x-quote-tweet.md | Yes | Content section | Short form |
| linkedin-post.md | Yes | Footer comment | Placeholder for long-form ("Insert company-specific long-form disclaimer") |
| discord-announcement.md | Yes | Footer | Short form |
| blog-post.md | Yes | Disclaimer section | Placeholder for long-form + risk disclosures |
| podcast-notebooklm.md | Yes | X Promo Post section | Short form in promo post; compliance pre-check section for audio |
| video-script.md | Yes | Disclaimer Frame section + Accompanying Post Text | Short form in both |
| video-google-veo.md | Yes | Accompanying Post Text | Short form |
| image-social-graphic.md | Yes | Accompanying Post Text | Short form |
| image-content-hero.md | No (N/A) | N/A | Content hero images don't contain post text with disclaimers -- the associated blog/content handles it |
| infographic.md | Yes | Footer + Accompanying Post Text | Short "Not financial advice. DYOR." on graphic + full short form in post text |
| data-card.md | Yes | Accompanying Post Text | Short form |
| slide-deck.md | Yes | Final slide + Accompanying Post Text | Short form in both |

### TV-05: Dimensions field naming inconsistency
- **Result: FAIL (confirmed inconsistency, P2)**
- infographic.md uses: `dimensions: ""` (line 26)
- image-social-graphic.md uses: `image_dimensions: ""` (line 29)
- image-content-hero.md uses: `image_dimensions: ""` (line 29)
- **Impact:** Automated processing (n8n workflows, Notion export) would need to handle both field names. Inconsistent for the same concept.
- **Recommendation:** Standardize to `image_dimensions` in infographic.md for consistency.

### TV-06: ${SKILL_DIR} variable references in templates
- **Result: PASS**
- Searched all 15 templates for `${SKILL_DIR}` references. **None found.** The templates contain no shell variable references.
- The audit finding (W11) may have been about a different file (e.g., a skill script, not the templates themselves), or the reference was removed in a prior fix.

---

## 2. Compliance Rules Static Check (Executed)

### CS-01: Prohibited term lists completeness
- **Result: PASS**
- SKILL.md Category A terms (authoritative compliance scanner):
  - "guaranteed returns", "risk-free", "no risk", "safe investment", "secure investment"
  - "get rich", "financial freedom", "passive income", "to the moon", "100x"
  - "SEC-approved", "SEC-registered", "CFTC-approved", "government-backed", "FDIC-insured"
  - "investment" (context: token purchase/staking/protocol)
  - "earn" (context: staking/lending)
  - "yield" (without "variable" qualifier)
  - "profit" (describing protocol participation)
  - "high APY" (without specific rate/disclaimer)
  - "allocation" (context: token rewards/airdrops)
  - "airdrop" (as incentive for user actions)
- compliance.md Absolute Prohibitions: All the same terms are covered. "allocation" and "airdrop" confirmed present (lines 26-27).
- **No contradictions found.** The two files are aligned.

### CS-02: Category A, B, C properly defined
- **Result: PASS**
- Category A (absolute prohibitions): Defined in SKILL.md lines 346-362. Auto-fail.
- Category B (context-dependent): Defined in SKILL.md lines 364-378. Flags for review, does not auto-fail.
- Category C (competitor names): Defined in SKILL.md lines 380-384. Auto Tier 1, does not auto-fail.
- All three categories have clear and distinct trigger behavior. No overlap in action (A = block, B = flag, C = escalate tier).

### CS-03: Required Language Substitutions defined
- **Result: PASS**
- compliance.md contains the full substitution table (lines 29-44): invest->participate, returns->network rewards, yield->variable rate rewards, earn->receive, profit->network-generated rewards, safe->audited, guaranteed->variable, passive income->participation rewards, high APY->current estimated rate.
- SKILL.md references these substitutions in Category A context notes.

### CS-04: Required Disclaimers complete per platform
- **Result: PASS**
- compliance.md defines disclaimers for:
  - Social Posts (Short Form) -- line 76
  - Blog Posts / Long-Form (Full Disclaimer) -- lines 80-81
  - When Discussing Rates / APY -- line 84
  - When Discussing Lending / Bridging -- line 88
  - When Discussing Staking -- lines 92-93
  - Video Scripts (Spoken Disclaimer) -- lines 94-96
  - Podcast Episodes (Spoken Disclaimer) -- lines 98-100
- All platforms covered. Video and podcast disclaimers confirmed present (audit fix #7).

### CS-05: Compliance modules referenced in compliance.md exist on disk
- **Result: PASS**
- compliance.md references 4 modules: crypto-sec, crypto-fca, crypto-mica, crypto-ofac
- Files found on disk:
  - `/Users/vew/Apps/Void-AI/engine/compliance/modules/crypto-sec.md`
  - `/Users/vew/Apps/Void-AI/engine/compliance/modules/crypto-fca.md`
  - `/Users/vew/Apps/Void-AI/engine/compliance/modules/crypto-mica.md`
  - `/Users/vew/Apps/Void-AI/engine/compliance/modules/crypto-ofac.md`
- All 4 referenced modules exist. (Additional modules app-store.md and saas-gdpr.md exist but are not referenced by VoidAI's compliance.md -- these are for other companies.)

---

## 3. Queue Directory Structure (Executed)

### QD-01: Required subdirectories exist
- **Result: PASS**
- All 8 required subdirectories verified present:
  - `drafts/` -- 50 .md files + .gitkeep
  - `review/` -- empty (.gitkeep only)
  - `approved/` -- empty (.gitkeep only)
  - `scheduled/` -- empty (.gitkeep only)
  - `posted/` -- empty (.gitkeep only)
  - `rejected/` -- 1 .md file + .gitkeep
  - `cancelled/` -- empty (.gitkeep only)
  - `failed/` -- empty (.gitkeep only)
- `assets/` directory also exists (for generated media).

### QD-02: No stale files in wrong directories
- **Result: PASS**
- All 50 files in `drafts/` have `status: "drafts"` in frontmatter -- verified via grep.
- The 1 file in `rejected/` (`20260313-180000-x-v0idai-bridge-test.md`) has `status: "rejected"` -- verified by reading the file.
- No AUDIT-*.md or non-content files found in queue directories (audit fix #8 confirmed working).
- No status/directory mismatches detected.

### QD-03: manifest.json exists and is parseable
- **Result: FAIL (stale manifest)**
- manifest.json exists and is valid JSON.
- **However, the manifest is severely stale:**
  - manifest.json reports: `"drafts": 0` -- actual count: **50 .md files**
  - manifest.json reports: `"rejected": 1` -- actual count: **1 .md file** (correct)
  - manifest.json `items` array contains only 1 entry (the rejected test item)
  - The 50 draft files were created after the last manifest regeneration
- **Impact:** Any command relying on manifest.json (e.g., `/queue list`, `/queue stats`) will show incorrect data until `/queue rebuild` is run.
- **Action needed:** Run `/queue rebuild` in an interactive session before proceeding with other tests.
- **manifest.json `dry_run_mode: true`** -- confirmed correct for Phase 1a.

### QD-04: All draft files have correct frontmatter status
- **Result: PASS**
- All 50 files in `drafts/` verified as `status: "drafts"` (not "draft").

---

## 4. Cadence Rules Static Check (Executed)

### CD-01: Cadence rules internally consistent
- **Result: PASS**
- Per-account rules are consistent:
  - All accounts have Posts/Day, Peak Windows, Thread Frequency, and Min Gap defined.
  - Min Gap of "N/A" for AI x Crypto is acceptable since it only has 1 post/day.
  - Weekend rule (1/day max) is a global override that doesn't contradict any per-account daily limit.
  - Global spam cap of 6/day/account doesn't contradict any per-account limit (all are 1-2).
  - Reply cadence is tracked separately from posts -- no contradiction.

### CD-02: Cadence rules non-contradictory with SKILL.md
- **Result: PASS**
- SKILL.md cadence validation checks (lines 477-483) align with cadence.md rules:
  - Max posts/day check: cadence.md defines per-account limits
  - Minimum gap check: cadence.md defines per-account gaps
  - Stagger group check: defined in accounts.md (referenced by SKILL.md)
  - Weekend limits: cadence.md says "1 post/day max per account"
  - Peak window warning: cadence.md defines windows

### CD-03: Test plan cadence assumptions match cadence.md
- **Result: FAIL (test plan inconsistency)**
- **Test plan CR-02** states: "Fanpage account allows up to 4 posts/day" and expects "5th item blocked. First 4 accepted."
- **cadence.md** states: Fanpage Satellite = "1-2" posts/day.
- The test plan assumes a 4/day limit for Fanpage that does not exist in the cadence config. The actual limit is 2/day.
- **Impact:** CR-02 test case needs to be corrected to match the actual cadence rules (max 2/day for Fanpage, 3rd item blocked).
- Similarly, CR-08 references the "4/day limit" for fanpage -- also incorrect per cadence.md.

---

## 5. Regression Static Checks (Executed Where Possible)

### RG-05: "allocation" and "airdrop" in compliance prohibitions
- **Result: PASS**
- compliance.md lines 26-27: Both "allocation" and "airdrop" present in Absolute Prohibitions section.
- SKILL.md lines 359-360: Both present in Category A blocked terms list.

### RG-06: "My play today:" removed from DeFi persona
- **Result: PASS**
- Searched CLAUDE.md, voice.md, and accounts.md for "My play today" -- no matches found.
- Confirmed removed as per audit fix #6.

### RG-07: Video and podcast disclaimer templates added
- **Result: PASS**
- compliance.md lines 94-100: Both video and podcast disclaimer templates present.
- SKILL.md Step 4 (lines 394-395): Video/podcast disclaimer check logic defined.

### RG-08: Audit reports moved out of queue/drafts/
- **Result: PASS**
- No AUDIT-*.md files found in `queue/drafts/`.
- All 5 audit reports confirmed in `reviews/` directory:
  - AUDIT-challenger-verdict.md
  - AUDIT-compliance-brand.md
  - AUDIT-queue-templates.md
  - AUDIT-skills-review.md
  - AUDIT-mcp-integrations.md

### RG-09: Template status field fix (same as TV-01)
- **Result: PASS**
- All 15 templates verified as `status: "drafts"`.

### RG-01: Taostats API key rotated
- **Result: SKIP** -- Requires checking environment variables and .claude.json interactively.

### RG-02: GEMINI_API_KEY set
- **Result: SKIP** -- Requires checking environment variables interactively.

---

## 6. SHOULD FIX Static Check

### SF-07: Reply and quote_tweet template absence
- **Result: PASS (fixed)**
- x-reply.md and x-quote-tweet.md templates now exist in `engine/templates/`.
- Both have full frontmatter with all 37 required fields plus template-specific extra fields.
- x-reply.md adds: `reply_to_url`, `reply_to_account`, `engagement_intent`
- x-quote-tweet.md adds: `quoted_url`, `quoted_account`, `quote_angle`
- Both include disclaimer text in content body and compliance guidance in editor notes.

---

## 7. Interactive Tests (Skipped -- Require Interactive Session)

The following test categories require running `/queue` commands interactively and cannot be verified by file inspection alone.

### Queue System Commands (QS-01 through QS-42)
- **42 tests SKIPPED**
- Reason: Each test requires executing `/queue add`, `/queue list`, `/queue review`, `/queue approve`, `/queue reject`, `/queue schedule`, `/queue schedule-day`, `/queue calendar`, `/queue check`, `/queue batch-approve`, `/queue move`, `/queue stats`, `/queue rebuild`, `/queue stagger`, `/queue cleanup`, or `/queue export-batch` commands and observing their runtime behavior.

### Compliance Check Validation (CC-01 through CC-20)
- **20 tests SKIPPED**
- Reason: Each test requires running `/queue check` or `/queue add` with specific content to verify the 6-step compliance scanner behavior at runtime.

### Cadence Rule Testing (CR-01 through CR-08)
- **8 tests SKIPPED**
- Reason: Each test requires `/queue schedule` or `/queue schedule-day` operations to verify cadence enforcement at runtime.
- **NOTE:** CR-02 and CR-08 need correction before execution -- they reference a 4/day fanpage limit that doesn't exist in cadence.md (actual: 2/day).

### Edge Case Testing (EC-01 through EC-09)
- **9 tests SKIPPED**
- Reason: Each test requires interactive queue operations with specific edge-case scenarios.

### SHOULD FIX Testing (SF-01 through SF-06)
- **6 tests SKIPPED**
- Reason: SF-01 through SF-05 require interactive `/queue` operations. SF-06 requires checking .claude.json interactively.

### End-to-End Testing (E2E-01 through E2E-06)
- **6 tests SKIPPED**
- Reason: Each test requires a full interactive content lifecycle from creation through scheduling.
- **E2E-04 partial static result:** manifest.json confirmed `dry_run_mode: true`. All inspected content items confirmed `dry_run: true` in frontmatter. Full verification requires checking all 51 items.

---

## Findings Summary

### Critical Issues (3 Failures)

1. **QD-03: Stale manifest.json** -- The manifest reports 0 drafts when 50 exist. Must run `/queue rebuild` before any interactive testing. This is a P0 prerequisite for all further tests.

2. **TV-05: Dimensions field naming inconsistency** -- infographic.md uses `dimensions` while image templates use `image_dimensions`. P2 severity but should be fixed for consistency before n8n automation.

3. **CD-03: Test plan cadence assumptions incorrect** -- CR-02 and CR-08 reference a "4 posts/day" fanpage limit that doesn't match cadence.md ("1-2" posts/day). Update these test cases before execution.

### Observations

1. **Template count updated:** The system now has 15 templates (not 13). The x-reply.md and x-quote-tweet.md templates were added as part of audit fix #14. The test plan should be updated to reflect this.

2. **TV-02 better than expected:** The test plan expected several non-X templates to have `account: "v0idai"` hardcoded. All templates actually have `account: ""`, which is the correct multi-tenant behavior.

3. **TV-06 better than expected:** No `${SKILL_DIR}` references found in any template. The audit finding may have been addressed or applied to a different file.

4. **50 draft files awaiting review:** The queue contains 50 content items in `drafts/` that need to be processed through `/queue review`. These were likely batch-generated during Wave 2 content creation.

### Pre-Interactive-Testing Checklist

Before starting interactive tests, these actions are required:

- [ ] Run `/queue rebuild` to sync manifest.json with actual files (50 drafts + 1 rejected)
- [ ] Update test plan CR-02 and CR-08 to use correct fanpage daily limit (2/day, not 4/day)
- [ ] Update test plan TV-01 template count from 13 to 15
- [ ] Optionally: standardize `dimensions` -> `image_dimensions` in infographic.md (TV-05)

---

**Report generated:** 2026-03-13
**Tests executed:** 24 (21 passed, 3 failed)
**Tests skipped:** 93 (require interactive session)
