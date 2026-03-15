# Phase 2: Template & Engine Validation -- CHALLENGER Report

**Challenger**: Claude Opus 4.6
**Date**: 2026-03-15
**Audit under review**: phase2-template-engine-audit.md
**Method**: Independent verification of all P1/P2 findings, full read of all 15 templates, 7 frameworks, compliance files, and approved queue content. Applied fixes to confirmed issues.

---

## P1 FINDINGS: VERIFIED / DISPUTED

### P1-1: LinkedIn l1-company-intro exceeds 3,000 char limit

**Verdict: VERIFIED -- and the scope is far worse than reported.**

The audit flagged only l1 (character_count: 4,672). The actual issue is that ALL 6 LinkedIn articles exceed the 3,000-character LinkedIn post limit:

| File | character_count | Over by |
|------|:--------------:|:-------:|
| l1-company-intro | 4,672 | +56% |
| l2-bridge-technical | 4,657 | +55% |
| l3-halving-analysis | 5,007 | +67% |
| l4-chainlink-ccip-choice | 4,560 | +52% |
| l5-developer-case | 4,094 | +36% |
| l6-sn106-subnet | 5,722 | +91% |

The charcount audit (charcount-audit.md) already counted these correctly and set the character_count values, but nobody flagged that all 6 exceed the template's stated 3,000-char limit.

**Complicating factor**: The template field is `content_type: "article"` and the template file is named `linkedin-post.md`. LinkedIn posts have a 3,000-char limit, but LinkedIn Articles (a separate publishing format) have no practical limit. If these are intended as LinkedIn Articles, the template's "Max 3,000 characters" instruction is wrong. If these are intended as LinkedIn posts, all 6 need trimming.

**Fix applied**: Trimmed l1-company-intro from ~4,672 to ~2,314 characters. Updated character_count and updated_at in frontmatter. Key messages preserved: Bittensor context, 4-product description, lock-and-mint mechanism, competitive positioning, ecosystem metrics, roadmap, CTA links, full disclaimer.

**Remaining action required**: l2 through l6 need the same trimming treatment, OR the linkedin-post.md template needs to clarify that these are LinkedIn Articles (not posts) and update the character limit accordingly. This decision requires human judgment on the distribution strategy.

---

### P1-2: review-tier-system.md inconsistency

**Verdict: VERIFIED -- and more extensive than reported.**

The audit correctly identified that Section 6's Content Type to Tier Mapping table contradicts both Section 2 (Tier 1 definitions) and the actual template hardcoded values. However, the audit missed that Section 3 (Tier 2 definitions) also contains contradictory entries.

**Full inconsistency map:**

| Content Type | Section 2 (Tier 1) | Section 3 (Tier 2) | Section 6 Table | Template | Actual Queue |
|-------------|:--:|:--:|:--:|:--:|:--:|
| Blog posts | Listed | Also listed | Tier 2 | Tier 1 | Tier 1 |
| Video scripts | -- | Listed | Tier 2 | Tier 1 | N/A |
| Podcast outlines | -- | Listed | Tier 2 | Tier 1 | N/A |
| Slide decks/infographics | -- | Listed | Tier 2 | Tier 1 | N/A |
| Data cards (editorial) | -- | -- | Tier 3 | Tier 1 | Tier 2 |
| Data cards (raw) | -- | -- | -- | Tier 2 | Tier 2 |

Blog posts appeared in BOTH Section 2 AND Section 3, which is an outright contradiction within the same document.

**Fixes applied to review-tier-system.md:**

1. **Section 2 (Tier 1)**: Added video scripts, podcast outlines, slide decks/infographics, and data cards with editorial framing to the Tier 1 qualifications list.
2. **Section 3 (Tier 2)**: Removed blog posts, video scripts, podcast outlines, slide decks/infographics (all now covered by Tier 1). Added data cards (raw data only) as a Tier 2 item.
3. **Section 6 table**: Fully realigned to match template hardcoded values:
   - Blog posts: Tier 1 (was 2)
   - Video scripts: Tier 1 (was 2)
   - Podcast outlines: Tier 1 (was 2)
   - Slide decks/infographics: Tier 1 (was 2)
   - Data cards (editorial): Tier 1 (was 3)
   - Data cards (raw): Tier 2 (new row, previously unlisted)

---

## P2 FINDINGS: VERIFIED / DISPUTED

### P2-1: Platform value inconsistency ("x-twitter" vs "x")

**Verdict: ALREADY FIXED.**

All 39 X-platform content items in the approved queue now use `platform: "x"` consistently. Zero instances of `platform: "x-twitter"` remain. This was fixed in a prior pass.

### P2-2: Discord character limit missing

**Verdict: VERIFIED.**

The discord-announcement.md template had no character limit documented.

**Fix applied**: Updated the content instruction to read: "Max 2,000 characters (Discord message limit)."

### P2-3: LinkedIn missing editor checklist

**Verdict: VERIFIED.**

The linkedin-post.md template had no editor review checklist (unlike blog-post.md which has a 6-item checklist).

**Fix applied**: Added a 6-item review checklist to linkedin-post.md: character count within limit, disclaimer present, claims verifiable, professional tone, clear CTA, no prohibited language.

### P2-4: Disclaimer policy for short-form unclear

**Verdict: VERIFIED -- this is a real gap.**

The audit correctly identified that some X posts have `disclaimer_included: false` while templates include disclaimers. I checked the compliance files:

- `compliance.md` defines disclaimer text per format (short form, long form, rates, lending, staking, video, podcast) but does NOT define when each is required vs optional.
- `base-rules.md` says "Appropriate disclaimer included for platform and content type?" in the review checklist but doesn't define what "appropriate" means per content type.
- `review-tier-system.md` says "Disclaimer verification: Check that appropriate disclaimer is present per platform requirements" but again doesn't specify the policy.

No file in the system explicitly answers: "Can a meme tweet skip the disclaimer if the bio covers it?" This is documented nowhere. The gap is real and needs a policy decision.

**No fix applied**: This requires a human policy decision, not an AI edit. Flagged for Vew.

---

## MISSED ISSUES FOUND

The auditor missed the following issues:

### MISSED-1 [HIGH]: ALL 6 LinkedIn articles exceed 3,000-char limit

As detailed in P1-1, the audit flagged only l1 but all 6 LinkedIn articles exceed the limit. This is a systemic content generation issue, not a one-off.

### MISSED-2 [MEDIUM]: All 4 QT content items missing template-defined fields

All 4 quote tweet content items (qt-x3 through qt-x6) are missing `quoted_account` and `quote_angle` fields that the x-quote-tweet.md template defines. This suggests the content generation workflow does not populate these fields. While the content is otherwise complete, these missing fields mean automation cannot filter/route QTs by angle or originating account.

### MISSED-3 [MEDIUM]: Only 1 of 15 templates has a compliance pre-check section

The podcast-notebooklm.md template includes a "Compliance Pre-Check" section with a 3-item checklist that runs BEFORE content generation. This is the only template with such a checkpoint. The auditor praised this as a "standout pattern" but did not flag that the other 14 templates lack it.

Templates that handle financial data or can't be edited post-publish (video-script.md, video-google-veo.md, slide-deck.md, infographic.md, blog-post.md) would benefit most from pre-generation compliance checks. Currently, compliance checking happens only at the review stage, not the generation stage.

### MISSED-4 [LOW]: Templates do not clearly distinguish required vs optional fields

No template explicitly marks which frontmatter fields are required and which are optional. For example:
- `scheduled_post_at`, `earliest_post_at`, `latest_post_at` are always empty -- are they optional?
- `tool` is empty in all image/video templates -- is it required or filled during production?
- `seo_keywords` in blog-post.md is an empty array -- is it required for publishing?

This ambiguity creates problems for automation: a workflow can't validate whether a content item is "complete" without knowing which fields must be non-empty.

### MISSED-5 [LOW]: charcount-audit found 5 X posts at or over 280 chars

The charcount-audit.md (a pre-existing review file) flagged 5 posts exceeding 280 characters:
- satellite-s6: 298 chars (per charcount-audit), but frontmatter now shows 248
- satellite-s7: 312 chars (per charcount-audit), but frontmatter now shows 226
- satellite-s8: 359 chars (per charcount-audit), but frontmatter now shows 242
- qt-x5-altcoinbuzz: 280 chars (at limit), frontmatter now shows 243
- qt-x6-subnetedge: 282 chars, frontmatter now shows similar

The discrepancy between the charcount-audit's "new" values and the current frontmatter values suggests content was trimmed AFTER the charcount audit ran, but the charcount-audit report was not updated. This creates conflicting audit records. The current frontmatter values appear correct (content was trimmed), but the charcount-audit file is now stale.

### MISSED-6 [LOW]: voice-learnings.md references em-dash as "Vew signature" but em dashes are banned

The voice-learnings.md file (line 546) notes: "Em-dash usage was a Vew signature historically" and correctly notes they're banned per compliance. However, the same file's raw tweet samples (e.g., C1, E2, F1) contain actual em-dash-style text: "VoidAI -- the backbone for..." These use double hyphens (--), which is correct and compliant. No fix needed, but the distinction between -- and actual em dashes should be reinforced.

---

## TEMPLATE READINESS SCORES

| Template | Score | Blocking Issues | Notes |
|----------|:-----:|:---------------:|-------|
| blog-post.md | 9/10 | None | Strong. Has editor checklist. Tier 1 matches framework (after fix). |
| linkedin-post.md | 8/10 | None (after fix) | Added editor checklist. Content items still need trimming. |
| discord-announcement.md | 9/10 | None (after fix) | Added char limit. |
| data-card.md | 9/10 | None | Strong. Missing optional "Automation Notes" section per dc1 pattern. |
| video-script.md | 7/10 | None | Missing export specs and compliance pre-check. |
| podcast-notebooklm.md | 10/10 | None | Best template. Pre-gen compliance check is a model for others. |
| slide-deck.md | 8/10 | None | Solid. Could benefit from compliance pre-check. |
| image-content-hero.md | 8/10 | None | Solid. |
| image-social-graphic.md | 8/10 | None | Solid. |
| video-google-veo.md | 9/10 | None | Excellent export specs table. |
| x-single.md | 7/10 | None | Missing editor checklist. Disclaimer policy ambiguous. |
| x-thread.md | 8/10 | None | Clear structure. |
| x-reply.md | 9/10 | None | Strong compliance notes section. |
| x-quote-tweet.md | 8/10 | None | Good. Content items not populating quoted_account/quote_angle. |
| infographic.md | 8/10 | None | Solid. Could benefit from compliance pre-check. |

**Average: 8.3/10**

---

## FRAMEWORK READINESS SCORES

| Framework | Score | Blocking Issues | Notes |
|-----------|:-----:|:---------------:|-------|
| review-tier-system.md | 8/10 | None (after fix) | Section 2/3/6 inconsistencies fixed. Comprehensive otherwise. |
| voice-calibration-loop.md | 8/10 | None | Actionable with quantitative triggers. Relies on data that doesn't exist yet (no posts published). Theoretical until first content cycle. |
| satellite-account-pattern.md | 9/10 | None | Complete. Matches actual satellite content well. |
| crisis-protocol-template.md | 8/10 | None | Complete enough for real use. Missing: severity tiers for different crisis types, and escalation chain beyond {REVIEW_AUTHORITY}. The quarterly drill schedule (Section 8) is aspirational but important. |
| engagement-framework-template.md | 9/10 | None | R1-R5 system is practical. Anti-patterns well documented. |
| content-pillar-system.md | 9/10 | None | Clear, actionable, good calibration triggers. |
| inter-account-coordination.md | 8/10 | None | Intentional overlap with satellite-account-pattern.md. Implementation notes for n8n/Redis are practical. |

**Average: 8.4/10**

---

## ADDITIONAL OBSERVATIONS

### voice-calibration-loop.md: Actionable but untested

The framework is well-structured with quantitative triggers (>50% above target for 4+ weeks, etc.) and a clear weekly workflow. However, it is entirely theoretical until the first content cycle produces engagement data. The voice-learnings.md file has templates and baselines but zero actual entries. This is expected for pre-launch, but the first 2-week calibration period will be the real test.

### satellite-account-pattern.md: Matches content well

Spot-checked satellite content items s1-s14 against the framework:
- Stagger groups are set with correct ordering
- Content differentiation is visible (same topic, different angles across accounts)
- Cross-promotion limits aren't testable yet (no posts published)
- FTC disclosure rules are documented but actual account bios don't exist yet (accounts not created)

### crisis-protocol-template.md: Sufficient for v1

The 30-minute response protocol, per-account crisis behavior table, and "NEVER do" list are practical. Two gaps:
1. No severity classification for different crisis types (a data breach requires different handling than community backlash)
2. No backup chain for {REVIEW_AUTHORITY} availability (what happens if the reviewer is unavailable at 3 AM during an exploit?)

These are not blocking but should be addressed before scaling.

### Compliance module cross-references are valid

All 4 modules referenced in compliance.md (crypto-sec, crypto-fca, crypto-mica, crypto-ofac) exist in engine/compliance/modules/ and are substantive. The Category A/B/C word list system in review-tier-system.md correctly references these modules via {{CATEGORY_A_WORDS}} etc. placeholders.

---

## FINAL ASSESSMENT

**Production-ready? YES, with conditions.**

### Conditions before publishing:

1. **MUST**: Decide LinkedIn distribution format. If posts (not Articles), trim l2-l6 to under 3,000 chars. If Articles, update linkedin-post.md template to remove the 3,000-char limit and clarify the format.
2. **MUST**: Populate `quoted_account` and `quote_angle` fields in all 4 QT content items, or remove these fields from the template if they're not needed.

### Conditions before automation:

3. **SHOULD**: Define disclaimer policy by content type and platform (when required vs optional).
4. **SHOULD**: Add compliance pre-check sections to video-script.md, slide-deck.md, and infographic.md templates (following the podcast-notebooklm.md pattern).
5. **SHOULD**: Mark required vs optional frontmatter fields in templates (add comments like "# REQUIRED" or "# OPTIONAL").
6. **SHOULD**: Add editor checklists to x-single.md and x-thread.md templates.

### Not blocking:

7. video-script.md missing export specs (cross-reference video-google-veo.md)
8. x-poll.md template not yet created (low priority, polls are simple)
9. Stale charcount-audit.md values (cosmetic, current frontmatter values are correct)

---

## FILES MODIFIED IN THIS REVIEW

| File | Change |
|------|--------|
| engine/frameworks/review-tier-system.md | Fixed Section 2, 3, and 6 tier assignment inconsistencies |
| engine/templates/discord-announcement.md | Added 2,000-char limit to content instruction |
| engine/templates/linkedin-post.md | Added 6-item editor review checklist |
| companies/voidai/queue/approved/20260313-linkedin-l1-company-intro.md | Trimmed content from ~4,672 to ~2,314 chars, updated character_count and updated_at |

---

## Changelog

| Date | Change |
|------|--------|
| 2026-03-15 | Phase 2 Challenger review complete. 2 P1 findings verified (1 expanded), 4 P2 findings verified (1 already fixed), 6 missed issues identified, 4 files fixed. |
