# Brand & Voice Fix Changelog

**Date**: 2026-03-13
**Source audits**: `brand-voice-audit.md`, `security-compliance-audit.md`
**Files modified**: `CLAUDE.md`, `brand/voice-learnings.md`, `research/x-voice-analysis.md`

---

## CLAUDE.md Changes (10 fixes applied)

### 1. Voice File Priority Hierarchy (new section)
- Added explicit 4-level priority hierarchy: CLAUDE.md compliance > CLAUDE.md voice > voice-learnings.md > x-voice-analysis.md
- Addresses: Brand audit L4 (implicit hierarchy), task item #10

### 2. Context-Dependent Language Rules (new subsection)
- Added after Required Language Substitutions table
- Resolves conflict between compliance banning "yield"/"earn" and DeFi satellite persona using them
- Strict substitution for VoidAI promotional content; industry-standard terms allowed for ecosystem commentary with disclaimers
- Includes per-satellite-account guidance and concrete examples
- Addresses: Brand audit C1, Security audit HIGH-05

### 3. Crisis Communication Protocol (new section)
- Added full crisis protocol: trigger conditions, immediate response steps, response templates for 3 crisis types (technical, reputational, regulatory), per-account crisis behavior table, NEVER-do list, post-crisis recovery steps
- Addresses: Brand audit C2, Security audit MEDIUM-01

### 4. Posting Cadence (new section)
- Added per-account posts/day, peak windows (UTC), thread frequency, minimum gaps
- Added cadence rules: max 6 posts/day, minimum 4 posts/week, weekend reduction, content calendar rhythm
- Addresses: Brand audit C3

### 5. Inter-Account Coordination Rules (new section)
- Hard rules: no satellite-to-satellite RTs, satellites may QT main account, no identical phrasing, no pile-ons
- Timing rules: 2-4 hour stagger per account with different angles, no 30-minute overlap
- Content differentiation rules and cross-promotion limits
- Addresses: Brand audit H4

### 6. Satellite Account Naming & Disclosure Requirements (new subsection)
- VoidAI disclosure required in handle OR display name (not just bio)
- 7-point naming criteria including pinned tweet disclosure requirement
- Updated all three TBD handle examples to include "VoidAI" prefix
- Addresses: Security audit CRITICAL-01, Brand audit H1

### 7. Content Format Ratio Fix (Account 1)
- Changed from "40% memes/shitposts, 25% hot takes, 20% VoidAI hype, 15% engagement bait"
- Changed to: "30% hot takes/conviction posts, 20% memes/shitposts, 15% engagement bait, 15% VoidAI hype moments, 10% self-deprecating humor, 10% subtle VoidAI content"
- Aligned with the more granular, data-derived ratios from x-voice-analysis.md
- Addresses: Brand audit M1

### 8. Voice Calibration Triggers (new subsection)
- Added 6 quantitative trigger conditions with specific thresholds (>50% over/underperformance, >30% engagement drop, >20% slang shift, 3x format outperformance)
- Added 5-step update process requiring Vew approval and changelog entry
- Explicit prohibition on auto-updating compliance section
- Addresses: Brand audit H3

### 9. Jurisdictional Compliance Specifics (expanded)
- Replaced vague "UK (FCA), EU (MiCA), UAE, and Singapore have additional requirements" with specific requirements per jurisdiction
- Added OFAC-sanctioned countries prohibition
- Added default-to-most-restrictive fallback rule
- Addresses: Brand audit H5, Security audit HIGH-06

### 10. Prompt Injection Safeguards (new section)
- Input sanitization: strip instructions, remove URLs, XML delimiter wrapping, 500-char limit, Unicode filtering
- Detection layer: flag patterns for human review
- Output validation: URL checking, system prompt leak prevention, persona deviation detection
- Addresses: Security audit HIGH-07

### 11. Fanpage DO NOT Expansion
- Added prohibition on slurs, ableist language, aggressive hostility
- Added guidance to translate "aggressive confidence" to "bold conviction"
- Addresses: Brand audit M3

### 12. Changelog Section (new)
- Added changelog table at bottom of CLAUDE.md for version tracking
- Addresses: Brand audit L3

---

## voice-learnings.md Changes (3 fixes applied)

### 1. "When to Read" and "How to Apply" Sections (new)
- Added explicit guidance on when this file must be read (before content generation, before weekly/monthly calibration, after crisis)
- Added 5-point "How to Apply" section covering individual entries, weekly summaries, monthly calibrations, A/B tests, and competitor watch
- Added authority level note with cross-reference to CLAUDE.md priority hierarchy
- Addresses: Task item "CLARIFY how learnings feed back"

### 2. Weekly/Monthly Summary Templates (new)
- Weekly summary: total posts, best/worst performers, per-account engagement table, pattern observations, voice drift check, adjustments
- Monthly calibration: engagement trend, top/bottom formats, voice register performance table with target vs. actual, calibration trigger checklist (mirroring CLAUDE.md thresholds), CLAUDE.md update recommendations
- Addresses: Brand audit H2

### 3. Enhanced Entry Template and New Sections
- Added Platform and Account fields to individual entry template
- Added "Engagement baseline comparison" field
- Added Engagement Rate Baselines section with initial targets per account
- Added A/B Testing template section
- Added Competitor Watch section with observation template
- Replaced duplicated baseline patterns with cross-reference pointer to x-voice-analysis.md
- Addresses: Brand audit L2, Brand audit M2

---

## x-voice-analysis.md Changes (3 fixes applied)

### 1. Authority Note (new, top of file)
- Added blockquote stating this file is reference data, CLAUDE.md is authoritative
- Clarified unique value of this file (raw data, engagement metrics, community patterns)
- Addresses: Task item "ADD a note at top"

### 2. Methodology Section (new)
- Added tool, date range, sample size, communities, thresholds, exclusions, limitations
- Addresses: Brand audit L1

### 3. Section 5 Redundancy Reduction
- Added cross-reference note at top of Section 5 directing to CLAUDE.md for authoritative rules
- For all 3 accounts: replaced duplicated hook formulas, emoji strategies, and content format ratios with "See CLAUDE.md Account N section" cross-references
- Kept unique value: extended slang lists (with additional terms not in CLAUDE.md), detailed sentence structure patterns, tone distributions (marked as reference only), example calibrated tweets
- Added compliance note on Account 3 slang list clarifying yield/farming usage rules per CLAUDE.md
- Addresses: Brand audit compaction items 4.1-4.4

---

## Consistency Verification

- CLAUDE.md content format ratios for Account 1 now match the data-derived analysis (previously 40% memes vs 20% in x-voice-analysis.md -- now aligned at 20% memes)
- All three files reference the same priority hierarchy
- Compliance language rules are clear and unambiguous across all files
- x-voice-analysis.md defers to CLAUDE.md on all prescriptive rules
- voice-learnings.md defers to CLAUDE.md on compliance, references x-voice-analysis.md for baseline data only
- No circular references or contradictions remain between files
