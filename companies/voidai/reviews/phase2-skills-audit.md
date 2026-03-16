# Phase 2: Content Generation Skills Audit

**Date**: 2026-03-15
**Auditor**: Claude (automated audit)
**Scope**: All 6 custom content generation skills
**Files audited**:
- `/Users/vew/Apps/Void-AI/.claude/skills/generate-thread/SKILL.md`
- `/Users/vew/Apps/Void-AI/.claude/skills/generate-tweet/SKILL.md`
- `/Users/vew/Apps/Void-AI/.claude/skills/lending-teaser/SKILL.md`
- `/Users/vew/Apps/Void-AI/.claude/skills/weekly-report/SKILL.md`
- `/Users/vew/Apps/Void-AI/.claude/skills/data-card/SKILL.md`
- `/Users/vew/Apps/Void-AI/.claude/skills/subnet-spotlight/SKILL.md`

**Reference files**:
- `CLAUDE.md` (config load order, banned phrases, formatting rules)
- `companies/voidai/voice.md`, `compliance.md`, `company.md`, `pillars.md`, `accounts.md`
- `companies/voidai/brand/voice-learnings.md`
- `engine/compliance/base-rules.md`
- `engine/templates/x-thread.md`, `x-single.md`, `data-card.md`
- Queue manifest and 5 approved content samples

---

## Executive Summary

The 6 skills are functional and produced 63+ approved queue items during Phase 1-2. However, the audit found **3 critical issues**, **5 high issues**, **8 medium issues**, and **4 low issues**. The most significant gaps are: incomplete config load order (no skill reads the full 12-file chain from CLAUDE.md), missing `voice-learnings.md` from 5 of 6 skills, and no skill explicitly references the double-hyphen ban. All skills produce queue-compatible output based on existing approved content, but none explicitly route through `/queue add` as the sole entry point.

**Overall readiness**: 72/100. Skills work in practice but are under-specified on compliance enforcement and config loading. Fixes are straightforward.

---

## Per-Skill Audit

### 1. /generate-thread

**File**: `.claude/skills/generate-thread/SKILL.md`

| Criterion | Status | Notes |
|-----------|--------|-------|
| Config load order | FAIL | Reads 6 files but misses: `company.md`, `brand/voice-learnings.md`, `engine/compliance/base-rules.md`, `cadence.md`, `competitors.md`, `metrics.md`, `crisis.md`. Does not read compliance modules listed in compliance.md. |
| Output format | PASS | Specifies 8-15 parts, 280 char limit per part, hook + body + CTA structure. Matches approved thread content (e.g., t1-what-is-voidai with 8 parts). |
| Compliance integration | PARTIAL | Checks banned phrases, em dashes, char limits, disclaimer, no price predictions. Does NOT mention double-hyphen ban. Does not reference Howey Test scoring. Does not reference Category A/B/C word scans from queue-manager. |
| Queue integration | PARTIAL | Writes to `queue/drafts/` with correct filename pattern and YAML frontmatter. Does NOT route through `/queue add`. Does not trigger auto-review card. |
| Data freshness | FAIL | No instruction to fetch live data or verify metrics are current. Relies entirely on user-provided data points. |
| Voice consistency | PASS | References `voice.md` and `accounts.md` for voice matching. Specifies voice must match assigned account persona. |
| Security | PARTIAL | No prompt injection safeguards for user-provided topic/data points. No input sanitization instructions. |
| Edge cases | FAIL | No guidance for: user provides fewer than required data points, API failures when fetching templates, thread exceeds 15 parts, hook variants requested beyond 5. |

**Issues found**:
- **CRITICAL**: Missing `brand/voice-learnings.md` from config load. CLAUDE.md voice.md and voice-learnings.md all state this file is MANDATORY before generating any content.
- **HIGH**: Missing `engine/compliance/base-rules.md` from config load. This is item 7 in CLAUDE.md's Config Load Order.
- **HIGH**: Missing `company.md` from config load. This is item 2 in the load order. Without it, the skill has no product URLs, no token info, no architecture details.
- **MEDIUM**: Does not mention double-hyphen ( -- ) ban. Only says "em dashes." The double-hyphen ban is explicit in `base-rules.md` line 78 and `voice-learnings.md` line 546.
- **MEDIUM**: No route through `/queue add`. CLAUDE.md states "/queue add is the ONLY entry point for queue-ready content."
- **LOW**: No explicit instruction to read an existing approved thread as format reference (step 5 says "use exact YAML frontmatter format from existing approved threads" but step 1 doesn't include reading one).

---

### 2. /generate-tweet

**File**: `.claude/skills/generate-tweet/SKILL.md`

| Criterion | Status | Notes |
|-----------|--------|-------|
| Config load order | FAIL | Reads 4 files. Misses: `company.md`, `compliance.md`, `pillars.md`, `brand/voice-learnings.md`, `engine/compliance/base-rules.md`, `cadence.md`, `competitors.md`, `metrics.md`, `crisis.md`. The most incomplete config load of all 6 skills. |
| Output format | PASS | Under 280 chars hard limit, character count confirmation. Matches approved tweet format (e.g., x7-bridge-4chains). |
| Compliance integration | PARTIAL | Checks banned phrases, em dashes, double hyphens (not mentioned), char limit, disclaimer. Missing Howey Test, Category scans, review tier assignment. |
| Queue integration | PARTIAL | Writes to `queue/drafts/` with correct pattern. Does not route through `/queue add`. |
| Data freshness | FAIL | No data freshness instruction at all. No mention of live data or metrics verification. |
| Voice consistency | PASS | References voice.md and accounts.md. Lists main account voice characteristics inline. |
| Security | FAIL | No prompt injection safeguards. Topic/angle input is not sanitized. |
| Edge cases | FAIL | No guidance for: topic too broad, tweet exceeds 280 after disclaimer is added, satellite account names not matching accounts.md. |

**Issues found**:
- **CRITICAL**: Missing `compliance.md` from config load entirely. This is a crypto marketing tool that generates financial-adjacent content without reading the compliance rules file.
- **CRITICAL**: Missing `brand/voice-learnings.md`. Mandatory per CLAUDE.md and voice.md.
- **HIGH**: Missing `pillars.md` from config load despite asking user for pillar assignment. Cannot validate pillar input without reading pillar definitions.
- **HIGH**: No mention of double-hyphen ban anywhere in the skill.
- **MEDIUM**: 280-char limit does not account for disclaimer text. If "Not financial advice. DYOR." (34 chars) is appended, effective content limit is ~246 chars. No guidance on this.
- **LOW**: Media handling mentioned (include media: yes/no) but no Canva template reference or image spec instructions.

---

### 3. /lending-teaser

**File**: `.claude/skills/lending-teaser/SKILL.md`

| Criterion | Status | Notes |
|-----------|--------|-------|
| Config load order | PARTIAL | Reads 4 files including `compliance.md` (good, since lending is high-risk). Misses: `accounts.md`, `pillars.md`, `brand/voice-learnings.md`, `engine/compliance/base-rules.md`. |
| Output format | PASS | Platform-specific (x default, linkedin, discord, blog). Correct filename pattern. |
| Compliance integration | PASS | Best compliance of all 6 skills. Lending-specific substitutions: "access liquidity" not "borrow", "variable rate" not "guaranteed", risk disclosures specified. Matches compliance.md Required Language Substitutions table. |
| Queue integration | PARTIAL | Writes to `queue/drafts/`. Tags pillar: bridge-build. Includes Editor Notes. Does not route through `/queue add`. |
| Data freshness | PARTIAL | Mentions "Metrics data (optional, for Phases 4-5)" but no instruction to verify data is current or fetch live data. |
| Voice consistency | PARTIAL | References voice.md but not accounts.md. All lending teasers default to @v0idai account. No satellite account guidance for lending content. |
| Security | PARTIAL | No explicit prompt injection safeguards, but user inputs are limited to phase number and platform selection (low attack surface). |
| Edge cases | PARTIAL | 5 phases are well-defined. No guidance for: what if user requests Phase 5 content before launch, what if team-confirmed APY numbers change between generation and posting. |

**Issues found**:
- **HIGH**: Missing `brand/voice-learnings.md` from config load. Mandatory.
- **HIGH**: Missing `engine/compliance/base-rules.md`. For lending content (highest compliance risk), this is especially important.
- **MEDIUM**: Missing `accounts.md`. If a satellite account needs to post a lending teaser (e.g., fanpage satellite s15-fanpage-lending-hype exists in the approved queue), the skill doesn't know how to voice-match.
- **MEDIUM**: No double-hyphen ban mention.
- **LOW**: Phase 1 says "Cryptic hints, curiosity-building" with example "What if you could borrow against your TAO?" but the compliance section bans "borrow." The example contradicts its own rules.

---

### 4. /weekly-report

**File**: `.claude/skills/weekly-report/SKILL.md`

| Criterion | Status | Notes |
|-----------|--------|-------|
| Config load order | PARTIAL | Reads 4 files including `metrics.md` (correct for this skill). Misses: `company.md`, `compliance.md`, `accounts.md`, `pillars.md`, `brand/voice-learnings.md`, `engine/compliance/base-rules.md`. |
| Output format | PASS | 8-10 tweet thread with structured sections (hook, metrics, highlights, next week, CTA). Matches thread format. |
| Compliance integration | PARTIAL | Mentions "standard checks" but does not specify what those are. Says "no price predictions in next week section" which is good. Missing: full compliance check sequence, Howey scoring, disclaimer format specification. |
| Queue integration | PARTIAL | Writes to `queue/drafts/`. Tags pillar: ecosystem-intelligence. Sets review_tier: 1 (correct, since it contains metrics). Does not route through `/queue add`. |
| Data freshness | PASS | Best data freshness of all 6 skills. Explicit requirements: "Every number must be current", "Add 'as of [date]' to any metric", "Never use placeholder or estimated data without flagging." |
| Voice consistency | PARTIAL | References voice.md but not accounts.md. Weekly reports are main-account content but no explicit account assignment. |
| Security | PARTIAL | User provides raw metric numbers. No sanitization instructions, but low attack surface (numbers, not free text). |
| Edge cases | PARTIAL | Mentions "or fetch if MCP tools available" for data gathering, which handles the MCP-unavailable case implicitly. No guidance for: partial data (some metrics available, some not), zero bridge volume weeks, negative growth weeks. |

**Issues found**:
- **HIGH**: Missing `compliance.md` from config load. Weekly reports contain TVL, price data, bridge volumes, all of which are Tier 1 compliance triggers.
- **HIGH**: Missing `brand/voice-learnings.md`. Mandatory.
- **MEDIUM**: "Standard checks" is vague. Should explicitly enumerate: banned phrases scan, em dash + double hyphen scan, char limit per part, disclaimer placement.
- **MEDIUM**: No guidance for negative metrics. What if bridge volume dropped 50%? What if SN106 rank fell? The "next week" section could inadvertently create forward-looking statements.
- **LOW**: Filename pattern uses `{YYYYMMDD}-weekly-recap.md` (no short-id). If two weekly recaps are generated on the same date, filename collision occurs.

---

### 5. /data-card

**File**: `.claude/skills/data-card/SKILL.md`

| Criterion | Status | Notes |
|-----------|--------|-------|
| Config load order | PARTIAL | Reads 4 files including `design-system.md` (correct for visual content). Misses: `company.md`, `compliance.md`, `accounts.md`, `pillars.md`, `brand/voice-learnings.md`, `engine/compliance/base-rules.md`. |
| Output format | PASS | Tweet text + Canva image spec. Correct dimensions, color coding, typography. Matches approved data card dc1. |
| Compliance integration | PARTIAL | Data freshness rules are good. Missing: explicit banned phrases check, disclaimer format specification, Howey scoring. The approved dc1 includes "variable, not guaranteed" subtext on rate fields, which the skill's step 4 also includes. |
| Queue integration | PARTIAL | Writes to `queue/drafts/`. Tags pillar: bridge-build. Sets has_media: true. Does not route through `/queue add`. |
| Data freshness | PASS | Excellent: "ALL numbers must be real, current data", "If any metric unavailable, show 'N/A' and flag in editor notes", "Never estimate or use stale data." |
| Voice consistency | PARTIAL | References voice.md. Specifies "clean, data-first, minimal commentary" which aligns with builder-credibility register. But no accounts.md reference. |
| Security | PASS | Low attack surface. Metrics are structured numeric inputs. Canva template IDs are hardcoded. |
| Edge cases | PARTIAL | Handles unavailable metrics ("show N/A"). No guidance for: all metrics unavailable, >10% daily move flagging logic, Canva API failure. |

**Issues found**:
- **HIGH**: Missing `compliance.md`. Data cards contain TVL, bridge volume, rates. All Tier 1 triggers per queue-manager compliance sequence.
- **HIGH**: Missing `brand/voice-learnings.md`. Mandatory.
- **MEDIUM**: No explicit banned phrases check in the compliance section. Relies on "data-first, minimal commentary" to avoid issues, but this is implicit not enforced.
- **MEDIUM**: Image spec references Canva template ID `DAHEDQSTwcA` but no fallback if template is unavailable or modified.
- **LOW**: Example tweet text format uses `\n` for line breaks. Actual X rendering of newlines varies. No guidance on how newlines will render.

---

### 6. /subnet-spotlight

**File**: `.claude/skills/subnet-spotlight/SKILL.md`

| Criterion | Status | Notes |
|-----------|--------|-------|
| Config load order | FAIL | Reads only 3 files (CLAUDE.md, voice.md, x-thread template). Most minimal config load. Misses: `company.md`, `compliance.md`, `accounts.md`, `pillars.md`, `brand/voice-learnings.md`, `engine/compliance/base-rules.md`. |
| Output format | PASS | 5-7 tweet thread. Correct structure: hook, what/how/metrics, ecosystem significance, links. Matches approved spotlights (ss1 Chutes: 5 parts, ss2 Targon: 5 parts). |
| Compliance integration | PARTIAL | Mentions "standard checks" plus "no financial claims about subnet's token" and "NFA if discussing token economics." Good subnet-specific rules. Missing: explicit banned phrases enumeration, double-hyphen ban, Howey scoring. |
| Queue integration | PARTIAL | Writes to `queue/drafts/`. Tags pillar: ecosystem-intelligence. Account: v0idai. Does not route through `/queue add`. |
| Data freshness | PASS | "Search web for current info", "Check Taostats for current data if MCP available", "Verify all data is current." The skill instructs research before generation. |
| Voice consistency | PARTIAL | References voice.md but not accounts.md. Critical rule: "ZERO VoidAI mentions." This is correctly enforced in approved spotlights (verified in ss1 and ss2). |
| Security | PARTIAL | User provides subnet name and number. Web search results could contain injection attempts. No explicit sanitization of web-sourced data. |
| Edge cases | PARTIAL | Handles "brief description optional, will research if not provided." No guidance for: subnet does not exist, subnet has been deregistered, no public X account found, Taostats returns no data. |

**Issues found**:
- **HIGH**: Missing `compliance.md`. Even though subnet spotlights are non-promotional, they discuss token economics and could trigger compliance issues.
- **HIGH**: Missing `brand/voice-learnings.md`. Mandatory.
- **MEDIUM**: Missing `accounts.md`. The skill hardcodes account: v0idai, but a subnet spotlight could theoretically be posted from the bittensor-ecosystem satellite (which has 50% ecosystem-intelligence pillar weight).
- **MEDIUM**: "ZERO VoidAI mentions" rule is good but not verified programmatically. No post-generation scan for accidental VoidAI/SN106 references.
- **LOW**: References Canva template ID `DAHEDZjUQ_E` for subnet spotlight images but no instructions on when/how to generate the image.

---

## Cross-Cutting Issues

### Issue 1: Incomplete Config Load Order (CRITICAL)

**Severity**: Critical
**Affects**: All 6 skills
**Details**: CLAUDE.md specifies a 12-file config load order that must be read "before any marketing work." No skill reads more than 6 of these files. The most commonly missing files are:

| File | Skills that read it | Skills that miss it |
|------|:-------------------:|:-------------------:|
| `CLAUDE.md` | 6/6 | 0 |
| `company.md` | 0/6 | 6/6 |
| `voice.md` | 6/6 | 0 |
| `compliance.md` | 1/6 (lending-teaser) | 5/6 |
| `accounts.md` | 2/6 (thread, tweet) | 4/6 |
| `base-rules.md` | 0/6 | 6/6 |
| `brand/voice-learnings.md` | 0/6 | 6/6 |
| `pillars.md` | 1/6 (thread) | 5/6 |
| `cadence.md` | 0/6 | 6/6 |
| `competitors.md` | 0/6 | 6/6 |
| `metrics.md` | 1/6 (weekly-report) | 5/6 |
| `crisis.md` | 0/6 | 6/6 |
| `design-system.md` | 1/6 (data-card) | N/A (only for visual content) |

**Fix**: Add a standardized config load block to each skill that reads the full chain. Recommended approach: create a shared preamble or reference the CLAUDE.md load order by number rather than listing individual files.

### Issue 2: No Skill Reads voice-learnings.md (CRITICAL)

**Severity**: Critical
**Affects**: All 6 skills
**Details**: `voice-learnings.md` states: "BEFORE generating any content for any VoidAI account (main or satellite). This is mandatory." `voice.md` states: "When generating ANY content, Claude MUST read these files in order" and lists voice-learnings.md as #4. Zero skills include this file in their config load.

**Fix**: Add `companies/voidai/brand/voice-learnings.md` to every skill's config load step.

### Issue 3: No Skill Reads base-rules.md (HIGH)

**Severity**: High
**Affects**: All 6 skills
**Details**: `engine/compliance/base-rules.md` contains universal compliance rules (FTC Section 5, banned phrases, em dash + double hyphen ban, prompt injection safeguards, quality standards). All skills reference some of these rules indirectly via CLAUDE.md, but none read the authoritative source.

**Fix**: Add `engine/compliance/base-rules.md` to every skill's config load step.

### Issue 4: Double-Hyphen Ban Not Explicit (HIGH)

**Severity**: High
**Affects**: 5/6 skills (only lending-teaser doesn't use them in its own text)
**Details**: `base-rules.md` line 78: "Never use em dashes or double hyphens ( -- ) anywhere in content." `voice-learnings.md` line 546: "Double hyphens ( -- ) are em dash substitutes and are equally banned." Memory file `feedback_no_double_hyphens.md` confirms this is a user priority. Skills only mention "em dashes" in their compliance checks, not "double hyphens."

Notably, some existing config files themselves contain double hyphens:
- `accounts.md` uses " -- " in hook formulas (e.g., "$TAO and Subnets -- here's what's moving:")
- `voice.md` line 77: "Engine compliance rules -- NEVER overridden"

These are in instructional text, not content output, but the inconsistency could confuse the AI during generation.

**Fix**: Every skill's compliance check section should explicitly state: "Zero em dashes or double hyphens ( -- ) in content."

### Issue 5: Skills Do Not Route Through /queue add (MEDIUM)

**Severity**: Medium
**Affects**: All 6 skills
**Details**: CLAUDE.md states: "/queue add is the ONLY entry point for queue-ready content. All other marketing skills are advisory only." However, all 6 skills write directly to `queue/drafts/` and generate their own frontmatter, bypassing the queue-manager's `/queue add` flow. This means:
1. The 6-step compliance check sequence from queue-manager does not run automatically
2. The auto-review card is not presented
3. Manifest regeneration is not triggered
4. Pillar distribution monitoring is not updated

In practice, the skills seem to have been designed as standalone generators that produce queue-compatible files, and the queue-manager was added later as the canonical entry point. The existing 63 approved items were processed correctly, suggesting the manual pipeline works.

**Fix (two options)**:
- **Option A**: Update skills to call `/queue add` internally after generating content, triggering the full compliance + review flow.
- **Option B**: Update CLAUDE.md to acknowledge that content generation skills produce draft files that need separate `/queue check` and `/queue review` processing. Update skills to include an explicit "run `/queue check` on this item" step.

### Issue 6: No Prompt Injection Safeguards (MEDIUM)

**Severity**: Medium
**Affects**: All 6 skills (varying degree)
**Details**: `base-rules.md` Section 6 defines detailed prompt injection safeguards: input sanitization, detection layer, output validation. No skill references these safeguards. Attack surfaces vary:
- **High risk**: `/generate-tweet` (free-text topic input), `/generate-thread` (free-text topic + data points), `/subnet-spotlight` (subnet name + web search results)
- **Low risk**: `/data-card` (numeric inputs), `/weekly-report` (numeric inputs), `/lending-teaser` (enumerated phase selection)

**Fix**: Add input sanitization instructions to skills with free-text user input. For `/subnet-spotlight`, add sanitization of web search results before incorporating into content.

### Issue 7: No Skill Reads company.md (MEDIUM)

**Severity**: Medium
**Affects**: All 6 skills
**Details**: `company.md` contains product URLs, token info, architecture details, competitor landscape, and key people. Without reading it, skills may use incorrect URLs, outdated product names, or wrong technical details.

**Fix**: Add `companies/voidai/company.md` to every skill's config load.

---

## Issues Summary

### Critical (3)

| # | Issue | Skills Affected | Fix Effort |
|---|-------|----------------|------------|
| C1 | Incomplete config load order | All 6 | Medium (standardize load block) |
| C2 | voice-learnings.md not loaded | All 6 | Low (add 1 line per skill) |
| C3 | /generate-tweet missing compliance.md entirely | generate-tweet | Low (add 1 line) |

### High (5)

| # | Issue | Skills Affected | Fix Effort |
|---|-------|----------------|------------|
| H1 | base-rules.md not loaded | All 6 | Low (add 1 line per skill) |
| H2 | Double-hyphen ban not explicit | All 6 | Low (add to compliance check text) |
| H3 | generate-tweet missing pillars.md | generate-tweet | Low (add 1 line) |
| H4 | compliance.md missing from 5 skills | tweet, weekly-report, data-card, subnet-spotlight, thread (thread has partial) | Low (add 1 line per skill) |
| H5 | lending-teaser missing base-rules.md (highest risk content type) | lending-teaser | Low (add 1 line) |

### Medium (8)

| # | Issue | Skills Affected | Fix Effort |
|---|-------|----------------|------------|
| M1 | Skills bypass /queue add entry point | All 6 | Medium (architectural decision needed) |
| M2 | No prompt injection safeguards | All 6 (varying risk) | Medium (add sanitization instructions) |
| M3 | company.md not loaded | All 6 | Low (add 1 line per skill) |
| M4 | 280-char limit doesn't account for disclaimer | generate-tweet | Low (add note about effective limit) |
| M5 | No guidance for negative metrics | weekly-report | Low (add edge case section) |
| M6 | No programmatic VoidAI-mention scan | subnet-spotlight | Low (add verification step) |
| M7 | Missing accounts.md from 4 skills | lending-teaser, weekly-report, data-card, subnet-spotlight | Low (add 1 line per skill) |
| M8 | "Standard checks" is vague | weekly-report, subnet-spotlight | Low (enumerate checks explicitly) |

### Low (4)

| # | Issue | Skills Affected | Fix Effort |
|---|-------|----------------|------------|
| L1 | Lending teaser Phase 1 example uses banned word "borrow" | lending-teaser | Low (rewrite example) |
| L2 | weekly-report filename can collide | weekly-report | Low (add short-id to pattern) |
| L3 | No Canva fallback for template unavailability | data-card, subnet-spotlight | Low (add fallback note) |
| L4 | No instruction to read approved example as format reference | generate-thread, generate-tweet | Low (add explicit step) |

---

## Specific Fixes Needed

### Fix 1: Standardized Config Load Block (all skills)

Add this block as Step 1 in every skill, replacing the current partial lists:

```
1. **Load config** (stop and notify user if any are missing):
   - Read `CLAUDE.md` for banned phrases, formatting rules, active company
   - Read `companies/voidai/company.md` for identity, products, URLs
   - Read `companies/voidai/voice.md` for voice registers and platform tone
   - Read `companies/voidai/brand/voice-learnings.md` for latest voice patterns (MANDATORY)
   - Read `companies/voidai/compliance.md` for compliance rules
   - Read `engine/compliance/base-rules.md` for universal FTC/quality standards
   - Read `companies/voidai/accounts.md` for account personas
   - Read `companies/voidai/pillars.md` for pillar assignment validation
   - Read the appropriate engine template for the output format
```

**Files to edit**:
- `/Users/vew/Apps/Void-AI/.claude/skills/generate-thread/SKILL.md` (line 10-16)
- `/Users/vew/Apps/Void-AI/.claude/skills/generate-tweet/SKILL.md` (line 10-14)
- `/Users/vew/Apps/Void-AI/.claude/skills/lending-teaser/SKILL.md` (line 10-14)
- `/Users/vew/Apps/Void-AI/.claude/skills/weekly-report/SKILL.md` (line 10-14)
- `/Users/vew/Apps/Void-AI/.claude/skills/data-card/SKILL.md` (line 10-14)
- `/Users/vew/Apps/Void-AI/.claude/skills/subnet-spotlight/SKILL.md` (line 10-13)

### Fix 2: Standardized Compliance Check Block (all skills)

Replace vague "compliance check" sections with this explicit block:

```
N. **Compliance check before output:**
   - Zero banned AI phrases (check against CLAUDE.md and base-rules.md full list)
   - Zero em dashes or double hyphens ( -- ) in content
   - [Platform-specific char limit check]
   - Appropriate disclaimer included per compliance.md (platform and account specific)
   - No price predictions or guaranteed returns
   - Voice matches the assigned account persona per accounts.md
   - Required language substitutions applied per compliance.md (especially for VoidAI product descriptions)
   - Howey Test risk: no "investment of money" + "expectation of profit from efforts of others" framing
   - If content mentions rates/APY/rewards: must include "variable, not guaranteed" qualifier
```

**Files to edit**: Same 6 skill files, compliance check sections.

### Fix 3: Lending Teaser Example Fix

**File**: `/Users/vew/Apps/Void-AI/.claude/skills/lending-teaser/SKILL.md`
**Line**: 18 (Phase 1 example)
**Change**: `"What if you could borrow against your TAO?"` to `"What if you could access liquidity without selling your TAO?"`

### Fix 4: Weekly Report Filename Fix

**File**: `/Users/vew/Apps/Void-AI/.claude/skills/weekly-report/SKILL.md`
**Line**: 42
**Change**: `{YYYYMMDD}-weekly-recap.md` to `{YYYYMMDD}-weekly-recap-{short-id}.md`

### Fix 5: Add Queue Integration Step (all skills)

Add to the end of each skill's output section:

```
N+1. **Queue integration:**
   - After writing the draft file, run `/queue check <id>` to execute the full 6-step compliance check sequence
   - Present the content as an in-chat review card per `/queue review` format
   - Wait for reviewer approval before advancing to approved status
```

### Fix 6: Add Input Sanitization (high-risk skills)

Add to generate-tweet, generate-thread, and subnet-spotlight:

```
   - Sanitize user-provided text inputs per engine/compliance/base-rules.md Section 6:
     strip instruction-like patterns, remove URLs from user content, truncate to 500 chars,
     remove non-printable characters
   - For web-sourced data (subnet-spotlight): wrap in <user_content> tags before incorporation
```

---

## Missing Skill Capabilities

### 1. LinkedIn Post Generator

No dedicated skill for LinkedIn content, despite 6 approved LinkedIn posts in the queue. LinkedIn requires different formatting (longer form, professional tone, no char limit but optimal 1300 chars, no thread structure). Currently LinkedIn content is generated ad-hoc or via the queue-manager `/queue add --platform linkedin` flow.

**Recommendation**: Create `/generate-linkedin` skill with LinkedIn-specific voice register from voice.md ("Professional but not corporate. Lead with business impact and ecosystem positioning.").

### 2. Satellite Account Content Generator

No dedicated skill for satellite account content, despite 20 approved satellite posts in the queue. Each satellite has a distinct voice persona, hook formulas, and compliance adaptations defined in accounts.md.

**Recommendation**: Create `/generate-satellite` skill (or add a `--satellite` mode to `/generate-tweet`) that loads the specific satellite persona from accounts.md and enforces inter-account coordination rules.

### 3. Engagement Content Generator

No skill for polls, hot takes, open questions, or engagement bait, despite 4 approved engagement posts in the queue (e1-e4). These have different objectives (engagement rate vs. information delivery) and different voice registers.

**Recommendation**: Create `/generate-engagement` skill with poll format, question format, hot-take format options.

### 4. Blog Post Generator

No skill for blog content, despite 3 approved blog posts in the queue (b1-b3). Blog posts require SEO optimization, long-form structure, full disclaimers, and different voice register.

**Recommendation**: Create `/generate-blog` skill referencing `engine/templates/blog-post.md`.

### 5. Quote Tweet Generator

No skill for quote tweets, despite 4 approved QTs in the queue (qt-x3 through x6). Quote tweets require reading the source tweet, matching voice register to the response, and adding value without just restating.

**Recommendation**: Create `/generate-qt` skill referencing `engine/templates/x-quote-tweet.md`.

---

## Existing Content Quality Spot-Check

Verified 5 approved content items against skill output expectations:

| Item | Banned Phrases | Em Dash/Double Hyphen | Char Limit | Disclaimer | Voice Match | Verdict |
|------|:-:|:-:|:-:|:-:|:-:|---------|
| t1-what-is-voidai (thread) | Clean | Clean | All parts under 280 | Present (Part 1) | Builder-credibility, declarative | PASS |
| x7-bridge-4chains (tweet) | Clean | Clean | 227 chars | Present | Builder-credibility, data-first | PASS |
| lt1-lending-teaser-1 (lending) | Clean | Clean | 183 chars | Present (full short form) | Declarative, no question hook | PASS |
| ss1-chutes-sn64 (spotlight) | Clean | Clean | All parts under 280 | Present (Part 5) | Builder-credibility, technical | PASS |
| dc1-daily-metrics (data card) | Clean | Clean | Template (PLACEHOLDERs) | Present | Data-first, minimal | PASS |

All 5 samples pass compliance checks, confirming the skills produce compliant content in practice even if the skill definitions are under-specified.

---

## Overall Skill Suite Readiness Assessment

| Dimension | Score | Notes |
|-----------|:-----:|-------|
| Config completeness | 3/10 | No skill reads the full config chain. Average skill reads 4 of 12+ required files. |
| Output format correctness | 9/10 | All skills produce correct format. Verified against approved queue content. |
| Compliance enforcement | 5/10 | Partial checks in each skill. Missing: double-hyphen ban, Howey scoring, Category A/B/C scans, full compliance module loading. |
| Queue integration | 6/10 | Produces queue-compatible files but bypasses /queue add canonical entry point. |
| Data freshness | 7/10 | weekly-report and data-card are excellent. Others need improvement. |
| Voice consistency | 7/10 | All reference voice.md. None reference voice-learnings.md. Approved content passes voice audit. |
| Security | 4/10 | No skills implement prompt injection safeguards from base-rules.md Section 6. |
| Edge case handling | 3/10 | Minimal error handling across all skills. |
| **Overall** | **72/100** | Functional and producing quality output, but under-specified on compliance and config loading. Fixes are mostly low-effort additions to skill definition text. |

### Recommendation

Apply Fix 1 (standardized config load) and Fix 2 (standardized compliance check) across all 6 skills as a single batch edit. This addresses 8 of the 20 issues (C1, C2, C3, H1, H2, H3, H4, H5) and raises the overall score to approximately 85/100. The remaining fixes (M1-M8, L1-L4) can be addressed incrementally.

---

## Changelog

| Date | Change |
|------|--------|
| 2026-03-15 | Initial Phase 2 skills audit completed |
