# Framework: Satellite Account Pattern
# Scope: Universal pattern for operating a main account + N satellite accounts on social platforms.
# Usage: Replace {PLACEHOLDER} values with company specifics. Define each satellite's persona,
# voice, and content mix in the tenant config. This framework covers naming, disclosure,
# coordination, and anti-detection rules.

## 1. Pattern Overview

One main account ({MAIN_ACCOUNT}) serves as the official presence. Satellite accounts ({ACCOUNT_1} through {ACCOUNT_N}) each target a distinct audience niche with a unique voice and content focus. Satellite accounts drive awareness and engagement that funnels back to the main account organically.

## 2. Account Naming and Disclosure Requirements

All satellite accounts MUST comply with these requirements:

1. **Random, organic-sounding handles.** NO "{COMPANY_NAME}" in the handle or display name. Handles should look like independent accounts in the space.
2. **Bio MUST mention {MAIN_ACCOUNT} affiliation.** Clearly visible on every profile visit. This satisfies FTC Section 5 disclosure requirements.
3. **Pinned post MUST disclose**: "This account is run by a member of the {COMPANY_NAME} community ({MAIN_ACCOUNT})."
4. Must not contain "official" (implies verification status)
5. Must not be easily confused with existing accounts in the space
6. Should be memorable in 2-3 syllables
7. Check availability on the platform before finalizing
8. Avoid numbers unless part of brand identity

### FTC Compliance Approach

Affiliation is clearly visible in bio (shown on profile visits and when users hover over the account name on X). Combined with pinned post disclosure, this provides clear, accessible disclosure without compromising the organic feel of the handle.

## 3. Satellite Account Definition Template

For each satellite, define in the tenant config:

```markdown
### {ACCOUNT_N}: {PERSONA_NAME}
- Handle: TBD (random, organic handle)
- Bio: "{BIO_TEXT} | Powered by {COMPANY_NAME} ({MAIN_ACCOUNT})"
- Audience: {TARGET_AUDIENCE}
- Voice: {VOICE_DESCRIPTION}
- Voice patterns: {SPECIFIC_PATTERNS_FROM_COMMUNITY_DATA}
- Content mix: {PILLAR_1} X%, {PILLAR_2} X%, {PILLAR_3} X%
- Content format ratios: {FORMAT_1} X%, {FORMAT_2} X%, ...
- Hook formulas: {HOOK_1}, {HOOK_2}, ...
- Cadence: {POSTS_PER_DAY}
- DO: {POSITIVE_GUIDELINES}
- DO NOT: {NEGATIVE_GUIDELINES}
- Compliance adaptation: {DISCLAIMER_FORMAT_FOR_THIS_PERSONA}
```

## 4. Posting Cadence Template

| Account | Posts/Day | Peak Windows (UTC) | Thread Frequency | Min Gap Between Posts |
|---------|-----------|--------------------|--------------------|----------------------|
| {MAIN_ACCOUNT} | {N} | {WINDOWS} | {FREQ} | {GAP} hours |
| {ACCOUNT_1} | {N} | {WINDOWS} | {FREQ} | {GAP} hours |
| {ACCOUNT_2} | {N} | {WINDOWS} | {FREQ} | {GAP} hours |

### Cadence Rules

- Never post more than 6 times/day from any single account (spam signal)
- Space posts by the minimum gap listed per account
- Peak windows are initial estimates. Update based on voice learnings engagement data after 2 weeks
- Minimum viable cadence: at least 4 posts/week per satellite to maintain algorithmic momentum
- Content calendar rhythm: plan weekly on Monday, review Friday
- Weekends: reduce to 1 post/day max per account (lower engagement, save content for weekdays)

## 5. Inter-Account Coordination Rules

These rules prevent satellite accounts from appearing coordinated or astroturfed.

### Hard Rules

- Satellite accounts must NEVER retweet each other directly (reveals shared operation)
- Satellite accounts MAY quote-tweet the {MAIN_ACCOUNT} (natural fan/community behavior)
- Never use identical phrasing across accounts for the same event or announcement
- If one account goes viral, other accounts must NOT pile on or amplify (looks coordinated)

### Timing Rules

Stagger the same news across accounts with minimum gaps and different angles:
- {MAIN_ACCOUNT}: Official announcement (posts first)
- {ACCOUNT_1}: {ANGLE_1} (2+ hours after main)
- {ACCOUNT_2}: {ANGLE_2} (3+ hours after main)
- {ACCOUNT_3}: {ANGLE_3} (4+ hours after main)
- Continue staggering with 1+ hour increments per additional account
- Never have more than 2 satellite accounts active in the same 30-minute window

### Content Differentiation

- Each account must have a unique pinned post reflecting its persona
- Different content formats for the same topic (e.g., main posts thread, {ACCOUNT_1} posts meme, {ACCOUNT_2} posts data card)
- Satellite accounts should have different reply patterns

### Cross-Promotion Limits

- Main account may RT satellite content maximum 1x/week per satellite
- Satellite accounts may mention {MAIN_ACCOUNT} maximum 2x/week (organic behavior, not shilling)

## 6. Per-Account Crisis Behavior

During a crisis, satellite behavior changes:

| Account | During Crisis |
|---------|--------------|
| {MAIN_ACCOUNT} | ONLY account that posts official updates. Factual, transparent, no spin. |
| Satellite (informational personas) | May share ONLY official {MAIN_ACCOUNT} updates via quote-tweet. No independent commentary. |
| Satellite (culture/meme personas) | SILENT. No memes, no engagement, no posts. Resume only after all-clear from {REVIEW_AUTHORITY}. |

Resume satellite activity gradually after crisis resolution. Informational accounts first, culture/meme accounts last.

## 7. Getting Started

1. Define your main account and satellite count (recommended: start with 2-3 satellites)
2. Fill in the satellite account template (Section 3) for each
3. Set up posting cadence (Section 4)
4. Implement coordination rules in your automation system (Section 5)
5. Run all satellite content through the review tier system for the first 30 days
6. After 30 days with no compliance issues, graduate to the standard tier system
