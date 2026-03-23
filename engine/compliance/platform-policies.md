# Universal Platform Policy Compliance
# Scope: Platform-specific automation rules that apply regardless of industry.
# Usage: Always loaded. Contains X/Twitter, LinkedIn, Discord, Telegram, and Google/SEO
# automation rules. Company-specific platform accounts are configured in tenant config.

## 1. X/Twitter Automation Rules

### 1.1 Allowed

**Automated posting (via X API):**
- Scheduling and publishing original tweets from owned accounts
- Posting automated data-driven content that is clearly factual
- Automated thread publishing (sequential tweets)
- Deleting your own tweets programmatically

**API-based reading:**
- Monitoring mentions via the X API
- Reading public timeline data for engagement scoring
- Searching public tweets for ecosystem keywords
- Pulling engagement metrics on your own tweets

**Account management:**
- Updating profile information via the API
- Managing lists programmatically

### 1.2 Prohibited

**Automated replies without opt-in:**
- X's automation rules state: "Don't send automated replies to other people unless they've clearly opted in to receive them."
- Action: Restrict automated engagement to likes only until an opt-in mechanism is in place.

**Coordinated inauthentic behavior:**
- X prohibits using multiple accounts "to artificially amplify or disrupt conversations."
- Action: Each account must operate independently with its own content calendar. Cross-account lead assignment coordination (Account A engages a user, then Account B follows up) is prohibited.

**Bulk actions:**
- Mass following, mass unfollowing, mass liking, mass retweeting are prohibited.
- Action: Respect per-account rate limits. Never use automation to accelerate engagement beyond natural human pace.

**Duplicate content:**
- Posting the same or substantially similar content across multiple accounts simultaneously.
- Action: Each account posts unique content matching its persona. No cross-posting identical content.

**Trending topic manipulation:**
- Using automation to post about trending topics to gain visibility.
- Action: Engagement with trending topics must be genuine, manual, and relevant.

### 1.3 Rate Limits and Technical Compliance

| Endpoint | Free Tier | Basic Tier | Pro Tier | Action |
|----------|-----------|------------|----------|--------|
| POST tweet | 1,500/month | 3,000/month | 300,000/month | Monitor daily. Alert at 80% of monthly limit. |
| GET mentions | 500/month | 10,000/month | 1,000,000/month | Cache responses. Min 15-min polling interval. |
| GET user lookup | Varies | Varies | Varies | Cache user data. No re-fetch within 24 hours unless triggered. |
| Rate limit headers | Always check `x-rate-limit-remaining` | Same | Same | Exponential backoff on 429. Max 3 retries. |

**Multi-account API setup:** Each account requires its own API credentials under a SEPARATE developer application. This prevents a ban on one application from affecting all accounts.

### 1.4 Automated Likes

- X does not explicitly prohibit automated likes at moderate volume, but excessive automated liking triggers spam detection.
- Recommendation: Limit automated likes to 50/day/account maximum. Monitor for rate limit warnings.

### 1.5 Bot Disclosure

- Consider including "Automated posts by {COMPANY_NAME} team" in account bios even if not required by the platform.

### 1.6 Consequences of Violation

| Violation Level | X Response | Impact |
|----------------|------------|--------|
| Rate limit exceeded | Temporary API lockout (15 min to 24 hours) | Automated posting paused. Manual still works. |
| Spam detection | Account temporarily locked. May require verification. | Account offline until verified. |
| Coordinated inauthentic behavior | Account(s) permanently suspended. May cascade to shared dev app. | Permanent loss if accounts share developer application. |
| TOS violation | Permanent suspension. Appeal unlikely for automation violations. | Permanent loss of account, followers, history. |

## 2. X/Twitter Advertising Policies

### 2.1 Pre-Approval

X may require pre-approval for advertising in regulated industries (crypto, finance, healthcare, etc.). Check X's current advertising policy for your industry before running paid ads.

### 2.2 General Prohibitions

- Ads with misleading claims about product capabilities or results
- Ads targeting users under 18 for age-restricted products
- Ads without appropriate disclaimers for regulated industries

### 2.3 Action

Do NOT run any X paid advertising until pre-approval is confirmed for your industry. Running ads without approval can result in permanent account suspension affecting organic posting.

## 3. Discord Bot Rules

### 3.1 Allowed

- Responding to user messages in channels where the bot is deployed
- Providing automated FAQ responses from a pre-approved knowledge base
- Sending announcements to designated announcement channels
- Role assignment automation, welcome messages, reaction-based roles

### 3.2 Prohibited

- Scraping user data from Discord servers for marketing purposes beyond the server
- Sending unsolicited DMs to server members
- Harvesting email addresses or other contact information
- Automating user actions (joining servers, sending messages on behalf of users)
- Using self-bots (automating a regular user account)

### 3.3 Data Logging

- If logging bot interactions for compliance review, users should be informed
- Include a statement in #rules or bot description: "Bot interactions are logged for quality and compliance purposes. Data handling: {COMPANY_URL}/privacy"

### 3.4 Consequences

| Violation | Response | Impact |
|-----------|----------|--------|
| Minor TOS violation | Bot temporarily disabled. Warning issued. | Bot offline temporarily. |
| Major TOS violation | Bot permanently banned. API access revoked. | Must rebuild bot. |
| Data misuse | Server banned from partnership program. Legal action possible. | Reputational damage. |
| Spam/unsolicited DMs | Bot and associated accounts banned. | Cascading bans. |

## 4. Telegram Bot Rules

### 4.1 Allowed

- Responding to commands and messages in groups where the bot is added
- Providing automated FAQ responses
- Broadcasting announcements to channels
- Welcome messages, basic moderation, scheduled announcements

### 4.2 Prohibited

- Sending unsolicited messages to users who have not started a conversation with the bot
- Spamming groups with promotional messages
- Scraping user data for external marketing
- Impersonating other bots, users, or official Telegram services

### 4.3 Frequency

- Limit proactive bot messages (announcements, scheduled posts) to 3-5 per day per group
- Responsive messages (answering questions) are unlimited

### 4.4 Consequences

| Violation | Response | Impact |
|-----------|----------|--------|
| Spam reports | Bot temporarily restricted. May require re-verification. | Temporary loss of functionality. |
| TOS violation | Bot permanently banned. Token revoked. | Must create new bot. |
| Bulk unsolicited messaging | Bot and phone numbers banned. | Cascading impact. |

## 5. Google/SEO Guidelines

### 5.1 Content Quality

- Publish original, high-quality content with genuine expertise
- Content about regulated industries (finance, health, legal) falls under Google's YMYL (Your Money or Your Life) category with heightened quality scrutiny
- Demonstrate E-E-A-T: Experience, Expertise, Authoritativeness, Trustworthiness
- All blog content should be AI-assisted but human-reviewed. Include author bios with relevant experience.
- Substantive content: 1,000+ words for pillar content. No thin/doorway pages.

### 5.2 SEO Prohibitions

- Cloaking (different content for search engines vs. users)
- Keyword stuffing
- Link schemes (buying links, link exchanges)
- Scraped or auto-generated content published without review
- Hidden text or links

### 5.3 Meta and Schema

- Meta descriptions and title tags must not contain misleading claims
- Use appropriate schema markup (Article, HowTo). Avoid Product schema for non-tangible products
- If creating region-specific pages, implement hreflang tags correctly
- Do not create region-specific pages for restricted jurisdictions

## 6. Website Disclosure Requirements

### Every Page
- Link to privacy policy (footer)
- Link to terms of service (footer)
- Copyright notice (footer)

### Blog Posts
- Full disclaimer per company policy
- Author attribution
- Date of publication and last update
- If sponsored: "Paid partnership with [name]" above the fold
- If containing affiliate links: "This post contains affiliate links" above the fold

### Landing Pages Collecting Data
- Privacy policy link at point of data collection
- GDPR consent checkbox (not pre-ticked) for EU visitors
- Clear statement of what data is collected and how it is used
- Double opt-in confirmation for email subscriptions

### Cookie and Tracking Disclosure
- Cookie consent banner on first visit
- Offer: Accept All, Reject All, Manage Preferences
- Essential cookies may be set without consent
- Analytics and marketing cookies require affirmative consent
- Consent preference must be persistently stored and respected

## 7. Platform Policy Monitoring

Platform policies change frequently. {COMPANY_NAME} should:

1. Monthly: Review X automation rules and developer agreement
2. Monthly: Review advertising policies for your industry
3. Quarterly: Review Discord and Telegram terms of service
4. As needed: Monitor platform developer accounts for policy announcements

Any policy change affecting operations should trigger an update to this document and a review of all active automation workflows.
