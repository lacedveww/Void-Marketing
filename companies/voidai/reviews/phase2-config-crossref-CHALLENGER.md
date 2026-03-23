# Phase 2: Config Cross-Reference Audit -- CHALLENGER REPORT

**Date**: 2026-03-15
**Challenger**: Claude Opus 4.6 (automated)
**Audit under review**: `reviews/phase2-config-crossref-audit.md`
**Method**: Independently read all referenced files, verified each finding, searched for issues the auditor missed, applied fixes to confirmed issues

---

## 1. Critical Finding: C1 -- Em-Dash Conflict

### Verdict: VERIFIED. Fix Applied.

The auditor correctly identified that voice-learnings.md line 546 states: "Em-dash usage is a Vew signature. Use em-dashes for parenthetical insertions and clause separation." This directly contradicts:

- CLAUDE.md line 45: "NEVER use em dashes"
- voice.md line 32: "Em dashes are banned across all platforms and accounts"
- base-rules.md line 78: "Never use em dashes anywhere in content"

This is a Priority Hierarchy violation (level 4 file attempting to override levels 1-3).

### Fixes Applied

1. **voice-learnings.md line 546**: Rewrote recommendation #5 from "Em-dash usage is a Vew signature. Use em-dashes..." to "Em-dash usage was a Vew signature historically... However, em dashes are banned per CLAUDE.md (compliance level). Use commas, periods, colons, or line breaks instead. Double hyphens (--) may be used for the same clause-separation effect."

2. **voice-learnings.md line 580**: Added compliance note to the "Approved transition patterns" em-dash template: "(Note: use -- not em dashes, per compliance rules)"

3. **voice-learnings.md line 268**: Replaced Unicode em-dash in section header "Expanded @v0idai Voice Calibration -- March 2026"

4. **staged-implementation-breakdown.md line 113**: Replaced Unicode em-dash with double hyphen

5. **engagement-frameworks.md**: Replaced ALL Unicode em-dashes (U+2014) with double hyphens (--). This file had **31 occurrences** across reply templates, DM templates, and usage notes. This is especially important because these are content-facing templates that would be used to generate actual posts.

### Em-Dash Audit -- Challenger's Assessment of the "17 Files" Claim

The auditor claimed "17 files across reviews/, research/, roadmap/, brand/, queue/" contain Unicode em-dashes. My independent search found exactly 17 files in `companies/voidai/` and 0 in `engine/`. Breakdown:

| Directory | Files with em-dashes | Content-facing? |
|-----------|---------------------|-----------------|
| brand/ | 2 (voice-learnings.md, engagement-frameworks.md) | YES -- templates, directly used in content generation |
| roadmap/ | 1 (staged-implementation-breakdown.md) | Partially -- operational doc but contains content examples |
| queue/ | 1 (rejected test item, in HTML comment only) | NO -- rejected item, comment only |
| reviews/ | 5 files | NO -- internal audit reports |
| research/ | 8 files | NO -- reference/research data |

**Files fixed**: voice-learnings.md, staged-implementation-breakdown.md, engagement-frameworks.md (the 3 content-facing files).

**Files NOT fixed**: reviews/ and research/ files. These are internal reference documents, not content templates. Fixing them is cosmetic. The auditor correctly categorized this as "nice to have" (M6).

**Auditor oversight**: The auditor identified the em-dashes in voice-learnings.md and staged-implementation-breakdown.md but did NOT flag engagement-frameworks.md, which had **the highest concentration** (31 occurrences) and is directly content-facing (reply templates and DM templates used in real-time engagement). This was the most practically dangerous file and was missed.

---

## 2. Significant Findings

### S1: Broken queue/templates Reference -- VERIFIED. Fix Applied.

staged-implementation-breakdown.md line 118 referenced `queue/templates/` which does not exist. Templates live at `engine/templates/`.

**Fix applied**: Changed to `engine/templates/`.

**Verification**: engine/templates/ contains 15 template files including x-single.md, x-thread.md, linkedin-post.md, and discord-announcement.md -- matching the content types listed on line 118.

### S2: Manifest compliance_passed Mismatch -- VERIFIED. Not Fixed (handled by queue integrity challenger).

Confirmed: all 50 approved items in manifest.json have `compliance_passed: false`, while the one rejected item's individual file (20260313-180000-x-v0idai-bridge-test.md) shows `compliance_passed: true` in its frontmatter.

This is being handled by the queue integrity challenger per the task description. Tracked but not actioned here.

### S3: Wrong Crisis Protocol Reference -- VERIFIED. Fix Applied.

competitors.md line 72 stated: "See crisis communication protocol in engine-level CLAUDE.md" -- this is wrong. CLAUDE.md contains no crisis protocol. The VoidAI crisis protocol is in `companies/voidai/crisis.md`. The engine-level template is at `engine/frameworks/crisis-protocol-template.md`.

**Fix applied**: Changed to: "See `companies/voidai/crisis.md` for full per-account crisis behavior rules."

---

## 3. Minor Findings

### M1: Lending Timeline Discrepancy -- VERIFIED. Not Fixed (needs human decision).

- company.md: "Upcoming (~5 weeks)" with no date qualifier
- staged-implementation-breakdown.md: "3-8 weeks (as of 2026-03-12)"
- voidai-marketing-roadmap.md: "3-8 weeks" in 5 separate locations

company.md's "~5 weeks" falls within the roadmap's "3-8 weeks" range, so this is not strictly contradictory. However, company.md lacks the "as of" date qualifier, which means the estimate will become stale. As of 2026-03-15 (today), the "as of 2026-03-12" qualifier means the lending platform is now ~2.5-7.5 weeks out.

**Recommendation**: Add "(as of 2026-03-13)" to company.md's ~5 weeks estimate, or update to match the roadmap's 3-8 week range. This needs Vew's input on the actual current timeline.

### M2: Account Name Inconsistencies -- VERIFIED. Fix Applied.

voice-learnings.md used "Bittensor Community" (4 occurrences) and "DeFi Community" (4 occurrences) instead of the canonical names from accounts.md: "Bittensor Ecosystem" and "DeFi / Cross-Chain".

**Fix applied**: All 8 occurrences updated to match accounts.md naming convention.

### M3: UTC vs. ET Timezone Mixing -- VERIFIED. Not Fixed (needs human decision).

- cadence.md: All times in UTC (14:00-16:00, 20:00-22:00, etc.)
- roadmap Section 7: "9-11 AM ET"
- staged-implementation-breakdown.md: "9 AM ET daily" (Workflow 1), "2 PM ET" (Workflow 3)

The time ranges are not contradictory (14:00 UTC = ~10:00 AM EDT during March 2026), but the inconsistency creates room for confusion. Cadence.md is the canonical scheduling file and correctly uses UTC. The roadmap/implementation files use ET for human-readable context.

**Recommendation**: Add a note to cadence.md: "All times UTC. For ET conversion during EDT (March-November): subtract 4 hours." Or add ET equivalents in parentheses next to UTC times.

### M4: VOID vs. SN106 Ticker -- Verified as noted. No fix needed.

The auditor's observation is correct: company.md defines it as "VOID (listed as SN106)" while all operational files use SN106. This is actually well-documented in company.md itself. No action needed beyond the auditor's recommendation to formalize the convention.

### M5: Hashtag Advice Conflict -- VERIFIED. Not Fixed (needs human decision).

- roadmap Section 7: "2-3 per post: #Bittensor, $TAO, #DeFi, #CrossChain, #SN106, #VoidAI"
- voice-learnings.md line 457: "Hashtags used: Zero. No #Bittensor, no #DeFi"

The auditor's recommended resolution is correct: the voice-learnings data describes Vew's historical @v0idai behavior (zero hashtags on main account), while the roadmap gives general guidance that applies more to satellite accounts. The roadmap should clarify this is per-account.

### M6: Unicode Em-Dashes in Non-Config Files -- PARTIALLY ADDRESSED.

See Section 1 above. Content-facing files fixed. Internal review/research files left as-is (cosmetic only).

---

## 4. MISSED ISSUES FOUND BY CHALLENGER

### MISSED-1: engagement-frameworks.md Em-Dash Saturation (SIGNIFICANT)

**Severity**: SIGNIFICANT (should fix)

The auditor's C1 finding focused on voice-learnings.md line 546 and mentioned em-dashes in 2 specific files. It completely missed `companies/voidai/brand/engagement-frameworks.md`, which had **31 Unicode em-dashes** across:

- Reply template examples (R1-R5): used in quotes that would be adapted into real posts
- DM templates (D1-D2): used in message drafts
- Usage notes and section headers

This file is explicitly labeled as a "Reference guide for real-time engagement on X" and templates from it would be directly adapted into published content. An AI assistant reading this file during content generation would see em-dashes in approved template examples and might reproduce them.

**Fix applied**: All 31 Unicode em-dashes replaced with double hyphens (--).

### MISSED-2: metrics.md Does Not Include Social Media KPIs (MINOR)

**Severity**: MINOR

metrics.md is designated as the KPI/metrics reference file but contains only product and market metrics. Social media KPIs (follower targets, engagement rate targets, impressions targets, posting frequency targets) exist only in the roadmap's Section 14. The CLAUDE.md Config Load Order points to metrics.md for "KPIs, anchor metrics" but these social KPIs are not there.

**Recommendation**: Either add a "Social Media KPIs" section to metrics.md cross-referencing the roadmap Section 14 targets, or add a note in metrics.md clarifying that social media KPIs are tracked in the roadmap.

### MISSED-3: Platform Field Inconsistency Claim is INCORRECT (DISPUTE)

**Severity**: N/A -- Auditor error

The auditor stated in Section 6: "Platform field inconsistency: Some items use 'x' and some use 'x-twitter' as the platform value." I searched every `"platform"` field in manifest.json. All X/Twitter items use `"x"` consistently. There are no `"x-twitter"` entries. The platforms used are: `x`, `blog`, `discord`, `linkedin`. This finding is incorrect and should be removed from the audit report.

### MISSED-4: Stale Timeline Estimates (MINOR)

**Severity**: MINOR

Multiple files contain timeline estimates anchored to 2026-03-12 or 2026-03-13 that will become progressively stale:

- staged-implementation-breakdown.md: "Lending platform launches in 3-8 weeks (as of 2026-03-12)" -- already 3 days old
- company.md: "Upcoming (~5 weeks)" -- no date qualifier at all
- roadmap: "DGX Spark is expected in ~1 week" (as of 2026-03-13) -- should have arrived by now or soon

These are not critical, but estimates without "as of" dates will cause confusion. company.md's "~5 weeks" is the worst case since it has no date qualifier.

### MISSED-5: References to Tools/Services Not Yet Deployed (INFORMATIONAL)

**Severity**: INFORMATIONAL (no fix needed, but worth tracking)

Multiple config and roadmap files reference tools and services that do not yet exist:

| Tool/Service | Status | Referenced In |
|-------------|--------|---------------|
| n8n Workflows 1-13 | Not yet built | competitors.md, staged-implementation-breakdown.md, roadmap |
| Mautic (self-hosted) | Not yet deployed | staged-implementation-breakdown.md, company.md |
| ElizaOS | Not yet deployed | staged-implementation-breakdown.md, company.md, roadmap |
| Hermes Agent | Not yet deployed | staged-implementation-breakdown.md, company.md, roadmap |
| Composio skills | Not yet installed | staged-implementation-breakdown.md, company.md |
| DGX Spark | Delivery pending | Multiple files |

This is expected for a pre-launch project. The roadmap explicitly marks these as Phase 3-4 items. No fix needed, but competitors.md line 76 referencing "n8n Workflow 6 (Competitor Monitor)" as if it exists could be confusing to someone reading the file in isolation. A "(planned)" qualifier would help.

### MISSED-6: Config Load Order Verification -- ALL FILES FOUND

I verified every file path in the CLAUDE.md Config Load Order:

| # | Path | Exists? |
|---|------|---------|
| 1 | CLAUDE.md | YES |
| 2 | companies/voidai/company.md | YES |
| 3 | companies/voidai/voice.md | YES |
| 4 | companies/voidai/accounts.md | YES |
| 5 | companies/voidai/compliance.md | YES |
| 6 | engine/compliance/base-rules.md | YES |
| 7 | engine/compliance/modules/ (4 active) | YES |
| 8 | companies/voidai/pillars.md | YES |
| 9 | companies/voidai/cadence.md | YES |
| 10 | companies/voidai/competitors.md | YES |
| 11 | companies/voidai/metrics.md | YES |
| 12 | companies/voidai/crisis.md | YES |
| + | companies/voidai/brand/voice-learnings.md | YES |
| + | companies/voidai/design-system.md | YES |
| + | engine/frameworks/voice-calibration-loop.md | YES |
| + | companies/_template/ | YES |

All paths resolve. No broken references in the Config Load Order.

### MISSED-7: No Circular References Detected

I checked for circular dependencies between config files. The reference graph is a clean DAG:

- CLAUDE.md references all company config files (one-way)
- voice.md references voice-learnings.md and research/x-voice-analysis.md (one-way)
- pillars.md references metrics.md (one-way)
- crisis.md references voice-learnings.md (one-way, for post-crisis lessons)
- voice-learnings.md references research/x-voice-analysis.md (one-way)

No circular dependencies found.

---

## 5. Design-System.md Completeness Assessment

The auditor noted design-system.md is "PARTIAL -- minimal." Confirmed. The file has:

| Section | Status |
|---------|--------|
| Background color | Present (#0A0A0F) |
| Typography | Present (Space Grotesk, Inter) |
| Primary accent color | **MISSING** -- says "VoidAI primary accent" with no hex code |
| Success color | Vague ("Green" -- no hex) |
| Warning color | Vague ("Amber" -- no hex) |
| Error color | **MISSING** |
| Secondary accent color | **MISSING** |
| Logo usage rules | **MISSING** |
| Partner badges | Present |
| Image guidelines | Present |
| Social media formats | Present |

The file is functional for basic content generation (background, fonts, image sizes) but insufficient for visual design work. This is pre-launch acceptable but should be completed before Phase 3 (Soft Launch) when visual assets will be created.

---

## 6. Config System Health Score

| Category | Score | Notes |
|----------|-------|-------|
| File completeness | 9/10 | Only design-system.md is partial |
| Cross-reference accuracy | 8/10 | 3 broken/incorrect refs fixed (queue/templates, crisis ref, em-dash recommendation) |
| Internal consistency | 8/10 | Minor naming and timeline discrepancies remain |
| Priority hierarchy compliance | 9/10 | One violation fixed (em-dash in voice-learnings.md) |
| Config Load Order integrity | 10/10 | All files exist and are accessible |

**Overall: 8.8/10 -- Production-ready after fixes applied in this session.**

---

## 7. Summary of Fixes Applied in This Session

| Fix | File | Type |
|-----|------|------|
| Rewrote em-dash recommendation | voice-learnings.md (line 546) | Critical |
| Added compliance note to em-dash template | voice-learnings.md (line 580) | Critical |
| Replaced Unicode em-dash in header | voice-learnings.md (line 268) | Critical |
| Replaced Unicode em-dash | staged-implementation-breakdown.md (line 113) | Significant |
| Fixed queue/templates reference | staged-implementation-breakdown.md (line 118) | Significant |
| Fixed crisis protocol reference | competitors.md (line 72) | Significant |
| Standardized account names (8 occurrences) | voice-learnings.md | Minor |
| Replaced 31 Unicode em-dashes | engagement-frameworks.md | Significant (missed by auditor) |

**Total: 8 fixes across 4 files.**

---

## 8. Remaining Items for Human Review

These items require Vew's decision and cannot be automated:

1. **Lending timeline**: Decide whether to standardize on "~5 weeks" or "3-8 weeks" and add "as of" date qualifier to company.md
2. **Hashtag policy**: Clarify in roadmap Section 7 that hashtag guidance is per-account (main @v0idai = no hashtags per voice-learnings data, satellites may use hashtags)
3. **Timezone standard**: Decide whether to add ET equivalents to cadence.md or add UTC equivalents to roadmap
4. **Design-system.md**: Provide actual hex color codes for primary accent, success, warning, and error colors. Add logo usage rules.
5. **VOID vs. SN106**: Formalize the convention (VOID = project name, SN106 = trading ticker) in a brief note in company.md or compliance.md
6. **Manifest compliance_passed sync**: Handled by queue integrity challenger, but Vew should verify the final resolution

---

## Changelog

| Date | Change |
|------|--------|
| 2026-03-15 | Challenger review of Phase 2 config cross-reference audit completed. 8 fixes applied across 4 files. 7 missed/disputed issues documented. |
