# Code Review: CLAUDE.new.md (Universal Marketing Engine Router)

**Reviewer**: code-reviewer agent
**Date**: 2026-03-13
**Files reviewed**:
- `/Users/vew/Apps/Void-AI/CLAUDE.new.md` (proposed replacement, 191 lines)
- `/Users/vew/Apps/Void-AI/CLAUDE.md` (current version, 595 lines)
- `/Users/vew/Apps/Void-AI/companies/voidai/company.md`
- `/Users/vew/Apps/Void-AI/companies/voidai/accounts.md`
- `/Users/vew/Apps/Void-AI/companies/voidai/voice.md`
- `/Users/vew/Apps/Void-AI/companies/voidai/compliance.md`
- `/Users/vew/Apps/Void-AI/companies/voidai/pillars.md`
- `/Users/vew/Apps/Void-AI/companies/voidai/cadence.md`
- `/Users/vew/Apps/Void-AI/companies/voidai/design-system.md`
- `/Users/vew/Apps/Void-AI/engine/compliance/base-rules.md`
- `/Users/vew/Apps/Void-AI/engine/frameworks/crisis-protocol-template.md`

---

## What's Good

1. **Clean separation of concerns.** The 595-line monolith has been decomposed into logical, well-scoped files. Each file has a single responsibility. The router CLAUDE.new.md is 191 lines and contains only universal rules, routing logic, and security safeguards. All VoidAI-specific content (voice, accounts, compliance, pillars, cadence) lives in `companies/voidai/`.

2. **Company-agnostic routing.** The `ACTIVE_COMPANY` variable and `{ACTIVE_COMPANY}` path templating pattern is clean and simple. Switching tenants is a single-line change. The onboarding section at lines 164-174 provides a clear checklist for adding new companies.

3. **No critical rules lost from the original.** Every "Absolute Prohibition" from the original CLAUDE.md (lines 362-374) is present in `companies/voidai/compliance.md`. The banned AI phrases list (21 items) is preserved both in CLAUDE.new.md (universal) and in `companies/voidai/voice.md` (company-level). The em dash ban is in CLAUDE.new.md line 68. The human review gate is in CLAUDE.new.md line 75. Required language substitutions are in compliance.md. Context-dependent language rules are in compliance.md. Jurisdictional requirements are in compliance.md. All 6 account definitions with full personas, voice patterns, content mixes, and DO/DO NOT lists are in accounts.md.

4. **Priority hierarchy correctly restructured.** The voice file priority hierarchy in CLAUDE.new.md (lines 79-86) is properly company-agnostic, referencing `companies/{ACTIVE_COMPANY}/` paths. The VoidAI voice.md (lines 72-80) has its own version that adds engine compliance as the top tier -- correctly splitting the hierarchy to show that engine rules sit above company rules.

5. **Prompt injection safeguards preserved in full.** Lines 101-136 of CLAUDE.new.md contain the complete safeguard section from the original, with input sanitization, detection layer, and output validation all intact. The only change is generalizing `<user_tweet>` to `<user_content>` -- an improvement for multi-platform use.

6. **Content generation routing preserved.** The `/queue add` as canonical entry point rule is at CLAUDE.new.md line 34, matching the original.

7. **Compliance modules properly structured.** The `engine/compliance/modules/` directory contains all 4 crypto-specific modules referenced in `companies/voidai/compliance.md` (crypto-sec, crypto-fca, crypto-mica, crypto-ofac), plus non-crypto modules (app-store, saas-gdpr) for future tenants.

---

## Critical Issues (Must Fix)

### C1: Crisis protocol missing from VoidAI company config

The original CLAUDE.md contains a full, VoidAI-specific crisis protocol (lines 476-535) with:
- VoidAI-specific triggers (bridge exploit, SN106 deregistration, etc.)
- Per-account crisis behavior table naming all 6 specific accounts
- Post-crisis satellite resumption order (Bittensor Ecosystem first, Meme/Culture last)

This content does NOT exist in any VoidAI company file. `accounts.md` has no crisis section. CLAUDE.new.md line 150 claims accounts.md contains "crisis protocol" but it does not. The engine has a generic template at `engine/frameworks/crisis-protocol-template.md`, but the VoidAI-specific instantiation of that template is missing entirely.

**Fix**: Create `/Users/vew/Apps/Void-AI/companies/voidai/crisis-protocol.md` containing the VoidAI-specific crisis protocol from the original CLAUDE.md (lines 476-535). Add it to the loading instructions in CLAUDE.new.md. Alternatively, add a crisis section to accounts.md since the per-account behavior is already described there. Either way, the VoidAI-specific triggers and per-account behavior table must exist somewhere in the company directory.

Also update CLAUDE.new.md line 150 -- if crisis protocol stays separate from accounts.md, correct the inline comment:

```
# Current (line 150):
  accounts.md         # Account personas, coordination rules, crisis protocol

# Fix (either add crisis to accounts.md, or change to):
  accounts.md         # Account personas, coordination rules
  crisis-protocol.md  # Crisis triggers, per-account behavior, post-crisis recovery
```

### C2: voice-learnings.md does not exist

CLAUDE.new.md line 28 instructs every session to read `companies/{ACTIVE_COMPANY}/brand/voice-learnings.md` before generating any content. Line 30 says "If any file is missing, STOP and notify the user before proceeding." But this file does not exist at `/Users/vew/Apps/Void-AI/companies/voidai/brand/voice-learnings.md`. The brand directory contains only a README.md.

This will cause every content generation session to halt immediately.

**Fix**: Create `/Users/vew/Apps/Void-AI/companies/voidai/brand/voice-learnings.md` with an initial baseline entry, even if it just says "No performance data yet. Use default voice weights from voice.md." This was likely part of the content that was supposed to be created during the extraction but was missed.

### C3: Expected file structure in CLAUDE.new.md does not match actual VoidAI directory

CLAUDE.new.md lines 146-162 define the expected file structure per company. It lists:
```
company.md          # Identity, products, competitors, metrics
```

But VoidAI actually has these as separate files:
- `company.md` (identity and products)
- `competitors.md` (competitor landscape)
- `metrics.md` (anchor metrics and KPIs)
- `design-system.md` (exists but listed under `brand/design-system.md` in the template)

The expected structure shows `brand/design-system.md` but VoidAI has it at the root level: `companies/voidai/design-system.md`.

**Fix**: Update the expected file structure in CLAUDE.new.md to match reality:

```
companies/{slug}/
  company.md          # Identity, products, key people
  competitors.md      # Competitor landscape and differentiation
  metrics.md          # KPIs, anchor metrics, performance tracking
  voice.md            # Voice registers, tone rules, platform adjustments
  accounts.md         # Account personas, coordination rules
  compliance.md       # Prohibitions, language substitutions, disclaimers
  pillars.md          # Content pillars, weights, anchor metrics
  cadence.md          # Posting frequency, timing, spacing
  design-system.md    # Colors, typography, visual identity
  brand/
    voice-learnings.md  # Living performance feedback log
  research/            # Voice analysis, competitor intel, SEO data
  queue/               # Content queue (drafts, review, approved, posted, etc.)
  automations/         # n8n workflows, scheduled tasks
  roadmap/             # Content roadmap and phase planning
  reviews/             # Audit results and review history
```

---

## Warnings (Should Fix)

### W1: Loading instructions don't mention competitors.md or metrics.md

CLAUDE.new.md lines 15-28 list the files to read when starting a session. Neither `competitors.md` nor `metrics.md` appears in this list, even though both exist and contain information that the original CLAUDE.md embedded inline (competitor landscape at line 11, anchor metrics at lines 106-114).

**Fix**: Add to the loading instructions:

```
# After line 23 (pillars.md), add:
8. `companies/{ACTIVE_COMPANY}/competitors.md` (who we compete with, differentiation strategy)
9. `companies/{ACTIVE_COMPANY}/metrics.md` (anchor metrics, KPIs, performance tracking)
```

### W2: Loading instructions don't mention design-system.md

The design system reference from the original CLAUDE.md (lines 350-356) is now in `companies/voidai/design-system.md` but is not mentioned in the loading instructions. Any image or visual content generation will miss brand guidelines.

**Fix**: Add to the "Before generating ANY content" block or make it a conditional load:

```
For visual/image content, also read:
- `companies/{ACTIVE_COMPANY}/design-system.md` (colors, typography, visual identity)
```

### W3: Several project context details dropped from CLAUDE.new.md

The original CLAUDE.md (lines 586-595) included these operational details:
- "Blog scope: Posts on existing voidai.com only -- NOT building/editing website"
- "SEO: seomachine (off-page/strategic), Composio (on-page/technical)"
- "Email/Leads: Mautic (self-hosted)"
- "Automation: n8n (13 workflows planned)"
- "AI Agents: Hermes Agent (content orchestrator), ElizaOS (Web3 community bot)"

CLAUDE.new.md line 181 only retains Tools and Strategy. These details ARE present in `companies/voidai/company.md` (lines 51-56), so they are not lost from the system. But the blog scope restriction is an important guard rail that should be visible at the router level to prevent any new company session from accidentally trying to build a website.

**Fix**: The company.md has these details, so they are technically accessible. However, consider adding the "blog scope" restriction as a universal rule or noting it at the router level if it applies to all companies. If it is VoidAI-specific, it is fine where it is, but ensure it is read early in the session.

### W4: Banned AI phrases duplicated across 3 files

The same 21 banned phrases appear in:
1. `CLAUDE.new.md` (lines 42-64) -- universal rules
2. `companies/voidai/voice.md` (lines 34-58) -- VoidAI voice
3. `engine/compliance/base-rules.md` (lines 50-74) -- base compliance

This creates a maintenance burden. If a phrase is added or removed, it must be updated in all 3 locations.

**Fix**: Keep the canonical list in exactly one place -- `engine/compliance/base-rules.md` is the right home since it is universal. CLAUDE.new.md should reference it rather than duplicating it. The company voice.md should either reference the engine list or be removed from there entirely, since it already loads via the compliance chain. For example, replace the list in CLAUDE.new.md with:

```
### Banned AI Phrases (Auto-Fail)

See `engine/compliance/base-rules.md` Section 3 for the full list of banned AI phrases. Content containing ANY of these fails voice authenticity check and must be rewritten. This list is loaded automatically as part of the compliance chain.
```

However, if the concern is that CLAUDE.md must be self-contained as the primary instruction file (since Claude reads it first), keeping the list inline is defensible despite the duplication. Flag this as a known tradeoff and pick one canonical source for additions/removals.

### W5: voice.md has a 5-level priority hierarchy, CLAUDE.new.md has a 4-level hierarchy

The voice file priority hierarchy in CLAUDE.new.md (lines 79-84) lists 4 levels:
1. Company compliance rules
2. Company voice rules
3. Company voice-learnings.md
4. Company research files

But `companies/voidai/voice.md` (lines 72-79) lists 5 levels, inserting "Engine compliance rules" as level 1 above "companies/voidai/compliance.md" at level 2.

The voice.md version is more accurate because engine-level compliance (base-rules.md + modules) should indeed sit above company-level compliance. CLAUDE.new.md's hierarchy conflates engine and company compliance into one tier.

**Fix**: Update CLAUDE.new.md lines 79-84 to match the 5-level hierarchy:

```
1. **Engine compliance rules** (from `engine/compliance/base-rules.md` and loaded modules). NEVER overridden.
2. **Company compliance rules** (from `companies/{ACTIVE_COMPANY}/compliance.md`). NEVER overridden by voice or learnings.
3. **Company voice rules** (from `companies/{ACTIVE_COMPANY}/voice.md`). Default brand rules.
4. **Company voice-learnings.md** (from `companies/{ACTIVE_COMPANY}/brand/voice-learnings.md`). Performance data may override voice defaults, but NEVER compliance rules.
5. **Company research files** (from `companies/{ACTIVE_COMPANY}/research/`). Baseline reference data, lowest priority.
```

---

## Suggestions (Consider Improving)

### S1: Add loading instruction for engine/compliance/base-rules.md

CLAUDE.new.md line 22 says "For each module listed in compliance.md, read from `engine/compliance/modules/`" but never explicitly tells the session to read `engine/compliance/base-rules.md`. The base rules file is the universal compliance foundation and should be loaded before any modules.

**Suggested fix**: Add between lines 21 and 22:

```
6. `engine/compliance/base-rules.md` (universal compliance: FTC, banned phrases, quality standards, prompt injection)
7. For each module listed in compliance.md, read from `engine/compliance/modules/`
```

### S2: Add the _template directory to CLAUDE.new.md's onboarding instructions

Line 168 says "Copy `companies/_template/` to `companies/{new-company-slug}/`". The template directory exists and contains template files, which is good. Consider adding a note that the template files contain `{PLACEHOLDER}` values that must be filled in, matching the pattern used in `engine/frameworks/crisis-protocol-template.md`.

### S3: Consider adding a version number

The original CLAUDE.md had no version identifier, and neither does CLAUDE.new.md. Given that this is now a multi-tenant system where company configs may be created at different points in the engine's evolution, adding a version number (e.g., `ENGINE_VERSION: 1.0`) would help track compatibility.

### S4: Changelog entry should note what moved where

The changelog entry at line 190 says content was "moved to companies/voidai/*.md" but does not mention that crisis protocol content was dropped. When the crisis protocol is restored (see C1), update the changelog to reflect that all sections were accounted for.

---

## Summary

| Category | Count | Items |
|----------|-------|-------|
| Critical | 3 | C1 (crisis protocol missing), C2 (voice-learnings.md missing), C3 (file structure mismatch) |
| Warning | 5 | W1-W5 (missing loads, dropped context, duplication, hierarchy mismatch) |
| Suggestion | 4 | S1-S4 (base-rules load, template docs, versioning, changelog) |

**Overall assessment**: The restructuring is well-executed. The new CLAUDE.new.md is genuinely company-agnostic, the separation of concerns is clean, and all critical compliance and security rules are preserved. The three critical issues are all straightforward to fix -- the crisis protocol needs to be extracted into a company file (it was likely overlooked during extraction), voice-learnings.md needs to be bootstrapped, and the expected file structure needs to match reality. None of these require architectural changes. After fixing C1-C3 and addressing W1-W5, this is ready to replace the current CLAUDE.md.
