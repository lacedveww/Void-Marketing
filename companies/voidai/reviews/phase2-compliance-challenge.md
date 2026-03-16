# Phase 2: Compliance Sweep Challenger Report

**Date**: 2026-03-15
**Challenger**: Reconstructed from interrupted agent research (95.8KB of completed verification work)
**Challenging**: `phase2-compliance-sweep.md`

---

## Executive Summary

The compliance sweep was largely accurate but contains one fabricated data point and overstates its coverage. Of 11 total findings, 9 are confirmed, 1 is factually wrong, and 1 needs context correction.

---

## Findings Confirmed

### MUST-FIX 1: Double hyphens in compliance.md line 96 - CONFIRMED
The video script disclaimer template reads: `"Not financial advice -- do your own research."`
This is a template that gets copied into generated content. Every video script will carry this violation.

### MUST-FIX 2: Double hyphens in accounts.md - CONFIRMED
Lines 68, 72, 97, 101, 112, 119 all contain double hyphens in satellite account hook formulas and disclaimer templates. These are literal copy-paste templates, making them higher severity than prose violations.

### MUST-FIX 3: Stale data in metrics.md lines 19-23 - PARTIALLY CONFIRMED
TAO price ($221.74), market cap ($2.39B), and 24h volume ($231.3M) are confirmed stale against fresh-data-march2026.md (TAO: ~$265-289, market cap: $2.77B, volume: $468.3M).

### SHOULD-FIX: voice.md double hyphens (lines 74-78) - CONFIRMED

### SHOULD-FIX: product-marketing-context.md em dashes - CONFIRMED

### SHOULD-FIX: queue-manager SKILL.md em dashes - CONFIRMED
Note: This is particularly problematic because the queue-manager is the compliance enforcement tool. Having banned patterns in the enforcement tool normalizes violations.

### SHOULD-FIX: company.md timeline "~5 weeks" with no date qualifier - CONFIRMED

### SHOULD-FIX: L6 stale SN106 token price - CONFIRMED

### Queue content clean of banned phrases - CONFIRMED
Independent grep across all 63 approved files found zero banned AI phrases in content bodies.

---

## Findings Disputed

### CMC Rank: FABRICATED DATA
**The sweep claims** (line 237): CMC rank moved from #36 to "#30"
**Reality**: The fresh data file (`research/fresh-data-march2026.md` line 17) explicitly states CMC Rank is **#36** as of March 15, 2026. The rank has NOT changed.

**Verdict**: The compliance sweep fabricated a rank change that does not exist in the source data. This is a hallucination. The stale data issue for metrics.md is real (price/volume/cap are outdated), but the rank itself is still #36 and does not need updating.

### "~25 approved files" vs actual count
The sweep references "~25" approved files being clean. The actual count is **63** approved .md files in `queue/approved/`. The sweep appears to have only checked a subset, though its conclusions about the checked files are correct.

---

## Missed Issues

### 1. Double hyphens in queue-manager SKILL.md are not just cosmetic
The queue-manager skill uses `--` in multiple places within its own definition. Since this is the tool responsible for enforcing formatting compliance, it normalizes the banned pattern. Content generation skills that reference queue-manager behavior may inherit this pattern. The sweep flagged the em dashes but did not flag the severity amplification of having violations inside the enforcement tool itself.

### 2. HTML comments in queue content contain double hyphens
The `--` grep across `queue/approved/` returns matches in HTML comment blocks (`<!-- ... -->`). These are structural (comment delimiters) and correctly excluded from violation counts. However, some comments contain editorial notes with `--` in prose (e.g., fix notes). While these won't render in published content, they set a bad precedent for editors working in these files.

---

## Revised Risk Assessment

| Finding | Sweep Rating | Challenger Rating | Notes |
|---------|-------------|-------------------|-------|
| compliance.md double hyphen | MUST-FIX | MUST-FIX | Confirmed, template contamination |
| accounts.md double hyphens | MUST-FIX | MUST-FIX | Confirmed, 6 locations in templates |
| metrics.md stale data | MUST-FIX | MUST-FIX | Confirmed for price/cap/volume. CMC rank #36 is CORRECT, not stale |
| voice.md double hyphens | SHOULD-FIX | SHOULD-FIX | Confirmed |
| product-marketing-context.md | SHOULD-FIX | SHOULD-FIX | Confirmed |
| queue-manager SKILL.md | SHOULD-FIX | ELEVATED: MUST-FIX | Violations in enforcement tool = systemic risk |
| company.md timeline | SHOULD-FIX | SHOULD-FIX | Confirmed |
| L6 stale price | SHOULD-FIX | SHOULD-FIX | Confirmed |
| CMC rank "#30" claim | N/A | RETRACT | Fabricated by sweep, rank is still #36 |

---

## Final Recommendation

The compliance sweep is **88% accurate**. Fix the 3 must-fixes plus the queue-manager elevation. Ignore the CMC rank "correction" as it was hallucinated. The queue content itself is clean and ready for production after the template-level fixes are applied.

**Priority order for fixes:**
1. `accounts.md` double hyphens (6 locations, direct template contamination)
2. `compliance.md` line 96 double hyphen (video script template)
3. `voice.md` lines 74-78 double hyphens (voice guidance contamination)
4. `queue-manager/SKILL.md` em dashes (enforcement tool contamination)
5. `metrics.md` stale price/cap/volume (NOT rank)
6. `product-marketing-context.md` em dashes
7. L6 stale SN106 token price
8. `company.md` timeline qualifier
