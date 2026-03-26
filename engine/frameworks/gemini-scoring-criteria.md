# Gemini Content Scoring Criteria

Used by OpenClaw (Gemini) to evaluate Claude-generated content variants before presenting the top options to Vew for final selection.

## When This Runs

After each content generation step in the morning reply-gated chain.
Claude generates: 8 variants (tweets), 6 variants (threads), or 4 variants (articles).
Gemini scores all variants. Top 4 (tweets), top 3 (threads), or top 2 (articles) are presented to Vew.

## Scoring Dimensions (1-10 each)

### 1. Voice Match
Does the content match the target account's persona from accounts.md?
- 10: Perfectly on-brand. Could not tell it was AI-generated. Matches hook formulas, slang, tone, and content mix.
- 7-9: On-brand with minor adjustments needed.
- 4-6: Somewhat matches but noticeable drift from persona.
- 1-3: Wrong account voice entirely. Sounds like a different account.

Reference: accounts.md -> target account's voice patterns section.

### 2. Relevance
Does the content connect to today's intelligence sweep data?
- 10: Directly tied to today's hottest topic from the sweep. Timely and specific.
- 7-9: References current events but could be more specific.
- 4-6: Topically relevant but not tied to anything from today's sweep.
- 1-3: Could have been posted any day. No connection to current events.

Reference: latest sweep JSON data provided in the generation context.

### 3. Hook Quality
How strong is the opening line? Would it stop a scroll?
- 10: Impossible to scroll past. Specific, compelling, creates urgency or curiosity.
- 7-9: Strong hook, would catch attention in a busy feed.
- 4-6: Decent but generic. "Good enough" but not remarkable.
- 1-3: Forgettable. Bland opener that blends into the feed.

Reference: voice.md hook formulas, accounts.md per-account hook formulas.

### 4. Compliance (pass/fail + score)
Does the content pass all rules?
- AUTO-FAIL (score = 0): Contains ANY banned AI phrase from voice.md.
- AUTO-FAIL (score = 0): Violates any rule in compliance.md.
- AUTO-FAIL (score = 0): Contains em dashes (banned across all content).
- AUTO-FAIL (score = 0): Makes price predictions or guarantees returns.
- 10: Clean. No compliance concerns whatsoever.
- 7-9: Clean but borderline on one rule (e.g., slightly hype-adjacent language).
- 4-6: Technically compliant but feels like it's testing the limits.

Reference: voice.md DO NOT section, compliance.md, banned AI phrases list.

### 5. Uniqueness
How different is this variant from the others in this batch?
- 10: Completely unique angle, hook, and structure. No overlap with others.
- 7-9: Distinct from most but shares minor elements with one other variant.
- 4-6: Overlaps significantly with another variant in hook or angle.
- 1-3: Essentially a rephrased version of another variant.

Reference: compare against all other variants in the current batch.

### 6. Data Density
Does the content include specific, concrete information?
- 10: Packed with specific numbers, metrics, names, protocol references. Every claim is substantiated.
- 7-9: Has specific data but could include more. 1-2 concrete data points.
- 4-6: Mix of specific and vague. Some data but also generic claims.
- 1-3: All vibes, no substance. Generic statements without data.

Reference: daily-metrics JSON, sweep data, metrics.md anchor metrics.

## Composite Score

Composite = (voice_match + relevance + hook_quality + compliance + uniqueness + data_density) / 6

If compliance = 0, composite = 0 regardless of other scores.

## Selection Rules

1. Rank all variants by composite score (highest first)
2. Select: top 4 (tweets), top 3 (threads), or top 2 (articles)
3. DIVERSITY CHECK: selected options should cover different angles/topics. If two options are too similar (same angle, similar phrasing), drop the lower-scored one and pull in the next highest-scored variant with a different angle
4. Compliance-failed variants (score 0) are NEVER presented
5. If fewer options pass compliance than needed, present however many passed and flag the issue
6. RANDOMIZE the presentation order (letter labels do not correspond to score rank)

## What Gets Logged

ALL variants (presented and filtered) with ALL scores.
See preference-log format in preference-learning.md.

## Weight Calibration (Phase 2)

Initial weights: all equal (1/6 each).
After 1-2 weeks of preference data, the weekly calibration can recommend adjusted weights based on which dimensions best predict Vew's selections. Weight changes require Vew's approval before being applied.

---

## Changelog

| Date | Change |
|------|--------|
| 2026-03-25 | Initial creation. 6 scoring dimensions, composite formula, selection rules, diversity enforcement. |
