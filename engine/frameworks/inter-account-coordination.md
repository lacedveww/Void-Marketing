# Framework: Inter-Account Coordination Rules
# Scope: Universal rules for coordinating multiple social accounts to avoid appearing
# astroturfed, coordinated, or inauthentic. Applies to any multi-account strategy.
# Usage: Replace {PLACEHOLDER} values with company specifics.
# Prerequisite: satellite-account-pattern.md (defines the accounts this coordinates)

## 1. Purpose

When operating multiple accounts ({MAIN_ACCOUNT} + satellite accounts), coordination rules prevent:
- Platform detection of coordinated inauthentic behavior (account suspension risk)
- Community perception of astroturfing (reputational risk)
- Content redundancy (audience fatigue)

## 2. Hard Rules

These are non-negotiable. Violating any of these risks account suspension.

| Rule | Rationale |
|------|-----------|
| Satellite accounts NEVER retweet/share each other directly | Reveals shared operation to both platforms and users |
| Satellite accounts MAY quote-tweet/share {MAIN_ACCOUNT} content | Natural fan/community behavior pattern |
| Never use identical phrasing across accounts for the same event | Duplicate content is a platform red flag |
| If one account goes viral, other accounts must NOT pile on | Coordinated amplification is the top detection signal |
| Each account has its own independent content calendar | Shared calendars create timing patterns |
| Each account uses separate API credentials under separate developer applications | Prevents a ban on one app from cascading to all accounts |

## 3. Timing Rules

Stagger the same news/announcement across accounts. Never post the same topic from multiple accounts simultaneously.

### Stagger Template

| Account | Delay After Main | Angle |
|---------|-----------------|-------|
| {MAIN_ACCOUNT} | Posts first (T+0) | Official announcement |
| {ACCOUNT_1} | T+2 hours minimum | {ACCOUNT_1_ANGLE}: e.g., community reaction |
| {ACCOUNT_2} | T+3 hours minimum | {ACCOUNT_2_ANGLE}: e.g., ecosystem impact |
| {ACCOUNT_3} | T+4 hours minimum | {ACCOUNT_3_ANGLE}: e.g., technical analysis |
| {ACCOUNT_N} | T+(N+1) hours minimum | {ACCOUNT_N_ANGLE}: e.g., culture/meme take |

### Timing Constraints

- Never have more than 2 satellite accounts active in the same 30-minute window
- Min gap between different satellite accounts engaging the same user: 2 hours
- Each account should have different peak posting hours to avoid timing pattern detection

### Timing Variation (Anti-Pattern Detection)

- Never post at exact intervals (every 2 hours on the dot)
- Add random jitter of -30 to +45 minutes to all scheduled post times
- Avoid posting at round minutes (:00, :15, :30, :45)
- Vary session lengths and idle periods between accounts
- Weekend posting should be reduced (1 post/day max per account)

## 4. Content Differentiation Rules

### Same Topic, Different Treatment

When multiple accounts cover the same topic, each must use a DIFFERENT:
- Content format (main: thread, {ACCOUNT_1}: single post with image, {ACCOUNT_2}: data card)
- Hook formula (main: announcement format, {ACCOUNT_1}: opinion/take format, {ACCOUNT_2}: data format)
- Tone register (main: official, {ACCOUNT_1}: casual, {ACCOUNT_2}: analytical)
- Supporting details (different metrics, quotes, or angles)

### Unique Identity Markers

Each account must have:
- A unique pinned post reflecting its persona
- Distinct reply patterns (one uses data, one uses humor, one uses questions)
- Different emoji usage patterns (or no emojis at all)
- Distinct hashtag habits
- Different content length tendencies

## 5. Cross-Promotion Limits

| Action | Limit | Rationale |
|--------|-------|-----------|
| Main account RTs satellite content | Max 1x/week per satellite | More looks like coordinated promotion |
| Satellite mentions {MAIN_ACCOUNT} | Max 2x/week | Organic fan behavior, not shill behavior |
| Satellite replies to {MAIN_ACCOUNT} posts | Max 1x/day per satellite | Normal engagement, not thread flooding |
| Satellite quotes {MAIN_ACCOUNT} | Max 1x/week per satellite | Quote-tweets are higher-signal than RTs |

## 6. Lead/User Engagement Coordination

If operating automated engagement across multiple accounts:

| Rule | Implementation |
|------|---------------|
| Never engage same user from all accounts in same day | Track daily engagement per user across accounts |
| Never engage same user's same post from 2+ accounts | Dedup check before engagement |
| Min 2 hours between different accounts engaging same user | Cooldown timer per user |
| Accounts never interact with each other's posts | Hardcoded exclusion list |
| Organic content never references same news item from 2+ accounts on same day | Content dedup across all queues |

## 7. Monitoring and Detection

### Weekly Audit Checklist

- [ ] No two accounts posted about the same topic within 1 hour
- [ ] No identical or near-identical phrasing across accounts
- [ ] Cross-promotion limits were respected
- [ ] No account was active during another account's designated quiet period
- [ ] Reply patterns are distinct across accounts
- [ ] No user received engagement from 3+ accounts in a single week

### Red Flags (investigate immediately)

- Platform warns about "coordinated behavior" or "suspicious activity"
- Community members publicly note similarities between accounts
- Engagement metrics suddenly drop across multiple accounts simultaneously
- Multiple accounts get rate-limited in the same time window

## 8. Implementation Notes

For n8n/automation implementations:
- Use Redis or equivalent for real-time coordination state (cooldowns, daily engagement sets)
- Each account's scheduler adds independent random jitter (do not share a jitter seed)
- Log all cross-account coordination decisions for audit
- Build a dashboard showing timing distribution per account to verify independence
