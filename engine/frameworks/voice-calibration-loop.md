# Framework: Self-Improving Voice Calibration Loop
# Scope: Universal process for continuously calibrating brand voice based on engagement data.
# Usage: Implement this loop for any company. Replace {PLACEHOLDER} values with company specifics.
# The brand voice is NOT static. It evolves based on what actually performs.

## How to Configure

Fill in these placeholders in your tenant config:
- {COMPANY_DIR}: Root directory of the company project (e.g., `/path/to/project/`)
- {COMPANY_NAME}: Company name
- {VOICE_LEARNINGS_FILE}: Path to voice learnings file (default: `{COMPANY_DIR}/brand/voice-learnings.md`)
- {VOICE_ANALYSIS_FILE}: Path to community voice analysis (default: `{COMPANY_DIR}/research/voice-analysis.md`)
- {BRAND_RULES_FILE}: Path to brand rules / CLAUDE.md equivalent
- {REVIEW_AUTHORITY}: Person who approves voice weight changes

## 1. The Loop

### Before Generating Content

1. Read `{BRAND_RULES_FILE}` (brand rules + compliance, highest authority, non-negotiable)
2. Read `{VOICE_LEARNINGS_FILE}` (latest performance data, may override default voice/format preferences but NEVER compliance rules)
3. Read `{VOICE_ANALYSIS_FILE}` (community voice baseline, reference data, refresh monthly)

### After Posting Cycle

1. Scrape engagement data on recent posts (all accounts)
2. Analyze: compare engagement rates across content types, hooks, formats, tone variations
3. Append findings to `{VOICE_LEARNINGS_FILE}` with structured entries
4. If patterns shift significantly, propose voice weight updates to `{BRAND_RULES_FILE}`

## 2. File Priority Hierarchy

When files contradict each other, this hierarchy determines which source is authoritative (highest to lowest):

1. `{BRAND_RULES_FILE}` compliance rules: NEVER overridden by any other file
2. `{BRAND_RULES_FILE}` voice and format rules: default brand rules
3. `{VOICE_LEARNINGS_FILE}`: latest performance data may override default voice/format preferences (but never compliance)
4. `{VOICE_ANALYSIS_FILE}`: community baseline reference, lowest priority

If you encounter a conflict between files, follow the higher-priority file and flag the conflict in `{VOICE_LEARNINGS_FILE}` for resolution.

## 3. Voice Calibration Triggers

Update voice weights in `{BRAND_RULES_FILE}` ONLY when ANY of these quantitative conditions are met:

| Trigger | Threshold | Action |
|---------|-----------|--------|
| Voice register outperforms target weight | >50% above target engagement rate for 4+ weeks | Propose weight increase |
| Voice register underperforms target weight | >50% below target for 4+ weeks | Propose weight decrease |
| Engagement drops across the board | >30% drop over a 2-week period | Full voice weight review |
| Community language baseline shifts | >20% new slang terms in monthly scrape vs. prior month | Update terminology guidance |
| Content format achieves breakout performance | 3x average engagement for 3+ consecutive uses | Propose increasing that format's weight |
| Competitor voice shift | Noticeable shift detected in weekly monitoring | Evaluate and adapt |

## 4. Process for Weight Updates

1. Document the trigger condition and supporting data in `{VOICE_LEARNINGS_FILE}`
2. Propose specific weight changes with rationale
3. {REVIEW_AUTHORITY} approves before `{BRAND_RULES_FILE}` is edited
4. Log the change in the Changelog section of `{BRAND_RULES_FILE}`
5. NEVER auto-update compliance sections. Compliance rules are human-reviewed only

## 5. Voice Learnings File Structure

`{VOICE_LEARNINGS_FILE}` is a living feedback log. Every content generation session MUST read it. Structure:

```markdown
## Entry: {DATE}

### Performance Data
- Post ID / link: ...
- Account: ...
- Format: ...
- Hook used: ...
- Engagement: likes/views ratio, reply quality, RT ratio
- vs. average: +X% / -X%

### Patterns Observed
- What worked: ...
- What flopped: ...
- Slang/terminology that landed or failed: ...

### Recommendations
- Proposed adjustments: ...
- Trigger threshold met? (yes/no, which one): ...
```

## 6. Weekly Voice Calibration Workflow

Run this weekly (suggested: Friday) as part of the optimization cycle:

1. Scrape top-performing posts from {COMPANY_NAME} accounts + competitors + community
2. Run engagement analysis (likes/views ratio, reply quality, RT ratio)
3. Extract new patterns, slang, hook formulas
4. Append findings to `{VOICE_LEARNINGS_FILE}`
5. Flag any voice drift or community language shifts
6. If any trigger threshold is met, initiate weight update process (Section 4)

## 7. Voice Register Template

Define voice registers with weights in `{BRAND_RULES_FILE}`:

```markdown
| Register | Weight | When to Use |
|----------|--------|-------------|
| {REGISTER_1} | {WEIGHT_1}% | {DESCRIPTION_1} |
| {REGISTER_2} | {WEIGHT_2}% | {DESCRIPTION_2} |
| {REGISTER_3} | {WEIGHT_3}% | {DESCRIPTION_3} |
| {REGISTER_4} | {WEIGHT_4}% | {DESCRIPTION_4} |
```

Weights must sum to 100%. Adjust based on calibration loop findings.
