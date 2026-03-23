# Structural Integrity Review: Universal Marketing Engine Restructure

**Reviewer**: code-reviewer (Claude Opus 4.6)
**Date**: 2026-03-13
**Scope**: Verify all wiring between CLAUDE.md (202-line universal engine), companies/voidai/ configs, engine/ modules, and .claude/skills/queue-manager/SKILL.md
**Verdict**: Structurally sound with 2 critical issues, 4 warnings, and 5 suggestions

---

## 1. Path Consistency (CLAUDE.md Loading Instructions)

### Files Referenced in Loading Instructions (Lines 18-36)

| # | Referenced Path | Resolves To | Exists? |
|---|----------------|-------------|:-------:|
| 2 | `companies/{ACTIVE_COMPANY}/company.md` | `companies/voidai/company.md` | YES |
| 3 | `companies/{ACTIVE_COMPANY}/voice.md` | `companies/voidai/voice.md` | YES |
| 4 | `companies/{ACTIVE_COMPANY}/accounts.md` | `companies/voidai/accounts.md` | YES |
| 5 | `companies/{ACTIVE_COMPANY}/compliance.md` | `companies/voidai/compliance.md` | YES |
| 6 | `engine/compliance/base-rules.md` | `engine/compliance/base-rules.md` | YES |
| 7 | `engine/compliance/modules/` | all 4 modules referenced in compliance.md | YES |
| 8 | `companies/{ACTIVE_COMPANY}/pillars.md` | `companies/voidai/pillars.md` | YES |
| 9 | `companies/{ACTIVE_COMPANY}/cadence.md` | `companies/voidai/cadence.md` | YES |
| 10 | `companies/{ACTIVE_COMPANY}/competitors.md` | `companies/voidai/competitors.md` | YES |
| 11 | `companies/{ACTIVE_COMPANY}/metrics.md` | `companies/voidai/metrics.md` | YES |
| 12 | `companies/{ACTIVE_COMPANY}/crisis.md` | `companies/voidai/crisis.md` | YES |
| -- | `companies/{ACTIVE_COMPANY}/brand/voice-learnings.md` | `companies/voidai/brand/voice-learnings.md` | YES |
| -- | `companies/{ACTIVE_COMPANY}/design-system.md` | `companies/voidai/design-system.md` | YES |
| -- | `engine/frameworks/voice-calibration-loop.md` | `engine/frameworks/voice-calibration-loop.md` | YES |

### Expected File Structure (Lines 155-174)

All files and directories listed in the expected structure block exist for voidai:
- company.md, competitors.md, metrics.md, voice.md, accounts.md, compliance.md, pillars.md, cadence.md, crisis.md, design-system.md: ALL PRESENT
- brand/voice-learnings.md: PRESENT
- research/: PRESENT (15 files)
- queue/: PRESENT with all 8 subdirectories + manifest.json + assets/
- automations/: PRESENT
- roadmap/: PRESENT
- reviews/: PRESENT

**ACTIVE_COMPANY resolution**: Line 7 sets `ACTIVE_COMPANY: voidai`. The directory `companies/voidai/` exists and contains all required files. Resolution is correct.

**Result: PASS -- all paths resolve correctly.**

---

## 2. Queue Manager Skill Wiring

### Queue Path Resolution

All `companies/{ACTIVE_COMPANY}/queue/*` paths in SKILL.md correctly resolve:
- `companies/{ACTIVE_COMPANY}/queue/drafts/` through `cancelled/`: All 8 subdirectories exist
- `companies/{ACTIVE_COMPANY}/queue/manifest.json`: Exists
- `companies/{ACTIVE_COMPANY}/queue/assets/`: Exists

### Template Path

SKILL.md line 31 references `engine/templates/` -- this is the correct new path. No references to the old `queue/templates/` path exist in the SKILL.md.

**Result: PASS**

### Hardcoded VoidAI References in SKILL.md

Searched for: `v0idai`, `voidai_memes`, `voidai_tao`, `voidai_defi`, `VoidAI`

**Result: ZERO matches. PASS -- fully company-agnostic.**

### Hardcoded VoidAI References in engine/templates/

Searched all 15 template files in `engine/templates/` for the same terms.

**Result: ZERO matches. PASS -- templates are fully company-agnostic.**

### Hardcoded VoidAI References in engine/ (all .md files)

Searched all markdown files under `engine/` for `v0idai`, `voidai_memes`, `voidai_tao`, `voidai_defi`.

**Result: ZERO matches. PASS -- engine layer is fully company-agnostic.**

### Compliance Path References in SKILL.md

- Line 13: `companies/{ACTIVE_COMPANY}/compliance.md` -- CORRECT
- Line 15: `engine/compliance/base-rules.md` -- CORRECT
- Line 342: references `companies/{ACTIVE_COMPANY}/compliance.md`, `engine/compliance/base-rules.md`, and loaded engine compliance modules -- CORRECT
- Line 414: references `engine/frameworks/review-tier-system.md` -- CORRECT

**Result: PASS -- no references to old `compliance/` root paths.**

---

## 3. Cross-Reference Completeness

### 3.1 Compliance Module References

`companies/voidai/compliance.md` lines 9-12 list these Active Compliance Modules:
- `crypto-sec` --> `engine/compliance/modules/crypto-sec.md` EXISTS
- `crypto-fca` --> `engine/compliance/modules/crypto-fca.md` EXISTS
- `crypto-mica` --> `engine/compliance/modules/crypto-mica.md` EXISTS
- `crypto-ofac` --> `engine/compliance/modules/crypto-ofac.md` EXISTS

Additional modules exist in `engine/compliance/modules/` that are NOT referenced by VoidAI (expected -- they are for other company types):
- `app-store.md` (for App Store companies)
- `saas-gdpr.md` (for SaaS companies)

**Result: PASS -- all referenced modules exist, extra modules are correctly unused.**

### 3.2 Voice Priority Hierarchy

`companies/voidai/voice.md` lines 74-78 define hierarchy:
1. Engine compliance rules -- resolves to `engine/compliance/base-rules.md` + loaded modules
2. `companies/voidai/compliance.md` -- EXISTS
3. `companies/voidai/voice.md` (this file) -- EXISTS
4. `brand/voice-learnings.md` -- relative path, resolves to `companies/voidai/brand/voice-learnings.md` -- EXISTS
5. `research/x-voice-analysis.md` -- relative path, resolves to `companies/voidai/research/x-voice-analysis.md` -- EXISTS

**Result: PASS -- all hierarchy paths resolve.**

### 3.3 Account Definitions

`companies/voidai/accounts.md` defines all 6 accounts:
1. Account 1: @v0idai (Main) -- line 23
2. Account 2: VoidAI Fanpage Satellite -- line 32
3. Account 3: Bittensor Ecosystem Satellite -- line 55
4. Account 4: DeFi / Cross-Chain Satellite -- line 80
5. Account 5: AI x Crypto Intersection Satellite -- line 105
6. Account 6: Meme / Culture Satellite -- line 127

Plus 2 owned accounts (SubnetSummerT, gordonfrayne) at line 182.

**Result: PASS -- all 6 accounts defined with full persona details.**

### 3.4 Pillar Weights

`companies/voidai/pillars.md` lines 5-10:
- Bridge & Build: 40%
- Ecosystem Intelligence: 25%
- Alpha & Education: 25%
- Community & Culture: 10%
- **Total: 100%**

**Result: PASS -- 4 pillars, weights sum to 100%.**

---

## 4. Template Coverage

### Templates on Disk (engine/templates/)

15 files:
1. `blog-post.md`
2. `data-card.md`
3. `discord-announcement.md`
4. `image-content-hero.md`
5. `image-social-graphic.md`
6. `infographic.md`
7. `linkedin-post.md`
8. `podcast-notebooklm.md`
9. `slide-deck.md`
10. `video-google-veo.md`
11. `video-script.md`
12. `x-quote-tweet.md`
13. `x-reply.md`
14. `x-single.md`
15. `x-thread.md`

### Templates Listed in SKILL.md Available Templates Table (Lines 47-61)

13 templates listed in the table:
1. `x-single.md`
2. `x-thread.md`
3. `linkedin-post.md`
4. `discord-announcement.md`
5. `blog-post.md`
6. `podcast-notebooklm.md`
7. `video-script.md`
8. `video-google-veo.md`
9. `image-social-graphic.md`
10. `image-content-hero.md`
11. `infographic.md`
12. `data-card.md`
13. `slide-deck.md`

### Missing from SKILL.md Table

- **`x-quote-tweet.md`** -- exists on disk, NOT in table
- **`x-reply.md`** -- exists on disk, NOT in table

These correspond to the `quote_tweet` and `reply` content types listed in the `--type` parameter (SKILL.md line 81), which makes this a functional gap: a user can pass `--type quote_tweet` or `--type reply` but the SKILL.md template table does not map them to a file, so the "match by --type" logic has no entry to resolve.

---

## 5. Broken References

### Old `queue/templates/` References

Found in **10 files**, all within `companies/voidai/reviews/` (past audit reports) and `companies/voidai/roadmap/`:

| File | Reference |
|------|-----------|
| `companies/voidai/reviews/phase1a-plan-system-testing.md` | `queue/templates/` |
| `companies/voidai/reviews/phase1a-plan-content-strategy.md` | `/Users/vew/Apps/Void-AI/queue/templates/x-thread.md` |
| `companies/voidai/reviews/phase1a-challenger-strategy.md` | `queue/templates/` (2 occurrences) |
| `companies/voidai/reviews/AUDIT-skills-review.md` | `/Users/vew/Apps/Void-AI/queue/templates/` (3 occurrences) |
| `companies/voidai/reviews/AUDIT-compliance-brand.md` | `queue/templates/` |
| `companies/voidai/reviews/AUDIT-queue-templates.md` | `queue/templates/` |
| `companies/voidai/reviews/AUDIT-mcp-integrations.md` | `/Users/vew/Apps/Void-AI/queue/templates/` |
| `companies/voidai/reviews/AUDIT-challenger-verdict.md` | old paths |
| `companies/voidai/roadmap/staged-implementation-breakdown.md` | `queue/templates/` |

**Assessment**: These are all in historical review/audit documents and the roadmap. They describe the system AS IT WAS, not as operational instructions. They are not operationally harmful because no active skill or config file reads these paths for execution. However, the roadmap file could cause confusion if referenced for implementation.

### Old `compliance/content-review-rules.md` References

Found in **7 files**, all within `companies/voidai/reviews/`:

| File | Count |
|------|:-----:|
| `AUDIT-compliance-brand.md` | 3 |
| `security-hardening-changelog.md` | 1 |
| `challenger-report.md` | 3 |
| `AUDIT-queue-templates.md` | 2 |
| `AUDIT-challenger-verdict.md` | 1+ |

**Assessment**: Same as above -- historical audit references only. Not operationally harmful.

### `brand/voice-learnings.md` Without Company Prefix

Found in many files. Two categories:

**Operationally correct (relative paths within company context):** `companies/voidai/voice.md`, `companies/voidai/cadence.md`, `companies/voidai/crisis.md`, `companies/_template/voice.md`, `companies/_template/cadence.md` -- these use `brand/voice-learnings.md` as a relative path from within the company directory. This is correct usage when the reader is already in the company context.

**Potentially broken (absolute-looking paths from outside company context):**
- `.agents/product-marketing-context.md` line 233: `/brand/voice-learnings.md` -- This root-relative path does NOT resolve. Should be `companies/voidai/brand/voice-learnings.md`.
- `companies/voidai/brand/README.md` line 7: `../../brand/voice-learnings.md` -- This relative path points to a `brand/` directory TWO levels above the README, which would be at the project root. That path does NOT exist. This README appears to be a pre-restructure artifact.

### `CLAUDE.md` References to Sections That Only Exist in CLAUDE.md.bak

No operational files reference sections that exist only in CLAUDE.md.bak. The backup is self-contained.

**Result: No operational references are broken. Historical review files contain stale paths but are not read by any skill or config.**

---

## 6. Dead Files Check

### CLAUDE.new.md

`diff` between `CLAUDE.md` and `CLAUDE.new.md` shows **zero differences**. They are byte-for-byte identical. `CLAUDE.new.md` is the source file that was copied to become `CLAUDE.md` and serves no further purpose.

**Recommendation**: Delete `CLAUDE.new.md`.

### CLAUDE.md.bak

This is the 595-line monolithic original (39,759 bytes vs. 9,427 bytes for the new CLAUDE.md). It serves as a safety net if rollback is needed. It has no operational role.

**Recommendation**: Keep for now (restructure is fresh, same day). Delete after confirming the restructured system is stable (suggest 1 week retention).

### .gitkeep Files in Directories With Content

The following directories contain both real files AND a `.gitkeep`:

| Directory | Real Files | .gitkeep? |
|-----------|:----------:|:---------:|
| `companies/voidai/queue/drafts/` | 37 draft files | YES |
| `companies/voidai/queue/rejected/` | 1 file | YES |
| `companies/voidai/reviews/` | 28 files | YES |
| `companies/voidai/roadmap/` | 2 files (+ .gitkeep) | YES |
| `companies/voidai/automations/` | 1 file (+ .gitkeep) | YES |

`.gitkeep` files are only needed to track empty directories in git. Once a directory has real content, the `.gitkeep` is no longer necessary. These are harmless but create noise.

**Recommendation**: Remove `.gitkeep` from directories that have real content. Keep them in directories that are still empty (queue/approved, queue/posted, queue/failed, queue/cancelled, queue/scheduled, queue/assets, queue/review).

---

## 7. Additional Findings

### 7.1 Review Tier Numbering Conflict (CRITICAL)

The queue-manager SKILL.md and the engine framework `engine/frameworks/review-tier-system.md` use **inverted tier numbering**:

| Tier | SKILL.md Meaning | Engine Framework Meaning |
|------|-----------------|-------------------------|
| Tier 1 | Mandatory human review (highest scrutiny) | Auto-approve (lowest scrutiny) |
| Tier 2 | Auto-queue, 20% spot-check | Single review |
| Tier 3 | Auto-post allowed (lowest scrutiny) | Dual review (high scrutiny) |
| Tier 4 | Not defined | Legal review (highest scrutiny) |

The SKILL.md says (line 416): "Tier 1 triggers (mandatory human review)" and lists high-risk content. The engine framework says (line 12): "Tier 1 | Auto-approve | Pre-approved templates only."

These are semantically opposite. If a content item is assigned "Tier 1" by the compliance check in the SKILL.md, the engine framework would interpret that as auto-approvable. This is a safety-critical conflict.

**Root cause**: The SKILL.md was written with a "Tier 1 = highest risk" convention (common in many systems). The engine framework was written with a "Tier 1 = lowest risk" convention (ascending severity). During the restructure, the SKILL.md's inline tier definitions were kept, and the engine framework was added separately with the opposite convention.

**Impact**: If both files are read in the same session, the AI agent will encounter contradictory instructions about what "Tier 1" means. The SKILL.md's compliance check assigns `review_tier: 1` to high-risk content, but `engine/frameworks/review-tier-system.md` says Tier 1 is auto-approve.

**Fix**: Align the numbering. Since the SKILL.md is the operational file that assigns tiers during the compliance pipeline, and the engine framework is a reference framework with template variables, the most practical fix is to update the engine framework to match the SKILL.md convention (Tier 1 = highest scrutiny, Tier 3 = lowest). Add Tier 4 for legal review if needed. Alternatively, update the SKILL.md to match the framework. Either way, they must agree.

### 7.2 .agents/product-marketing-context.md Stale Paths

The file at `.agents/product-marketing-context.md` contains Key References (lines 232-237) that use root-relative paths from the pre-restructure layout:

```
- **Voice learnings (read before generating content):** `/brand/voice-learnings.md`
- **Community voice baseline:** `/research/x-voice-analysis.md`
- **Marketing roadmap:** `/roadmap/voidai-marketing-roadmap.md`
- **Staged implementation:** `/roadmap/staged-implementation-breakdown.md`
- **X lead nurturing architecture:** `/automations/x-lead-nurturing-architecture.md`
```

None of these paths resolve. The correct paths are all under `companies/voidai/`. This file also lists only 3 satellite accounts (line 223) rather than 5, and references "CLAUDE.md Compliance Rules section" (line 171) which no longer contains inline compliance rules (they were moved to `companies/voidai/compliance.md`).

This file predates the restructure and was not updated.

### 7.3 companies/voidai/brand/README.md Stale Content

This README references `../../brand/voice-learnings.md` and `../../brand/engagement-frameworks.md` as paths to "original" files that will be "moved here in Phase 3." However, voice-learnings.md already lives at `companies/voidai/brand/voice-learnings.md` (same directory as the README), and `engagement-frameworks.md` lives at `companies/voidai/brand/engagement-frameworks.md` (also same directory). The relative paths in the README point to a non-existent `brand/` directory at the project root. The README's premise (files have not been moved yet) is factually incorrect -- the migration has already happened.

### 7.4 Voice Learnings CLAUDE.md Reference

`companies/voidai/brand/voice-learnings.md` line 5 says: "This file can override default voice/format preferences in CLAUDE.md based on performance data, but it can NEVER override CLAUDE.md compliance rules." This reference to "CLAUDE.md" is ambiguous post-restructure. Compliance rules now live in `companies/voidai/compliance.md` and `engine/compliance/base-rules.md`. The voice-learnings file should reference the specific compliance files rather than "CLAUDE.md" generically.

---

## Summary by Priority

### Critical (Must Fix)

| # | Issue | Location | Impact |
|---|-------|----------|--------|
| C1 | Review tier numbering is inverted between SKILL.md and engine framework | `.claude/skills/queue-manager/SKILL.md` lines 416-440 vs. `engine/frameworks/review-tier-system.md` lines 10-15 | High-risk content could be misclassified as auto-approvable. Safety-critical for compliance pipeline. |
| C2 | Two templates exist on disk but are missing from SKILL.md Available Templates table | `engine/templates/x-quote-tweet.md` and `engine/templates/x-reply.md` not in SKILL.md lines 47-61 | `/queue add --type quote_tweet` or `--type reply` will fail template resolution. Content types are listed as valid but have no mapped template. |

### Warnings (Should Fix)

| # | Issue | Location | Impact |
|---|-------|----------|--------|
| W1 | `.agents/product-marketing-context.md` has stale pre-restructure paths and outdated info | `.agents/product-marketing-context.md` lines 223, 232-237 | Any agent reading this file will attempt to load non-existent paths and has an incomplete account count. |
| W2 | `companies/voidai/brand/README.md` references pre-migration paths that no longer apply | `companies/voidai/brand/README.md` lines 7-9 | Confusing to any session that reads this file -- states migration has not happened when it has. |
| W3 | `CLAUDE.new.md` is an exact duplicate of `CLAUDE.md` | Root directory | Confusing -- which is the canonical file? Risk of editing the wrong one. |
| W4 | `companies/voidai/brand/voice-learnings.md` references "CLAUDE.md compliance rules" generically | `companies/voidai/brand/voice-learnings.md` line 5 | Post-restructure, compliance rules are split across multiple files. Generic reference is ambiguous. |

### Suggestions (Consider Improving)

| # | Issue | Location | Impact |
|---|-------|----------|--------|
| S1 | Remove `.gitkeep` from directories that now have real content | 5 directories listed in Section 6 | Cosmetic -- reduces noise in directory listings. |
| S2 | Delete `CLAUDE.md.bak` after 1-week stability period | Root directory | Cleanup -- 39KB file no longer needed once restructure is validated. |
| S3 | Update `companies/voidai/roadmap/staged-implementation-breakdown.md` path references | References `queue/templates/` | Could confuse implementation work if roadmap is referenced. |
| S4 | `companies/voidai/compliance.md` does not reference its modules by path | Lines 9-12 list module names but not full paths | Adding the explicit `engine/compliance/modules/{name}.md` paths would make the loading instruction unambiguous for new sessions. |
| S5 | Consider adding `crisis.md` to `companies/_template/` | `companies/_template/` has no crisis.md | Template directory is missing this file, which is listed in CLAUDE.md's expected structure. New company onboarding would miss this. |

---

## Conclusion

The restructure from the 595-line monolith to the multi-tenant architecture is well-executed. All primary operational paths resolve correctly. The engine layer is fully company-agnostic (zero hardcoded VoidAI references in engine/ or templates/). The queue manager skill correctly references `engine/templates/` and `companies/{ACTIVE_COMPANY}/` paths throughout.

The two critical issues (tier numbering inversion, missing template table entries) should be resolved before the system is used for content generation, as they directly affect the compliance pipeline and template resolution logic. The warnings are cleanup items from the restructure that could cause confusion but are not immediately dangerous.
