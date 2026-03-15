# Framework: Review Tier System
# Scope: Universal content review framework with four tiers of review intensity.
# Usage: Configure trigger words, reviewer assignments, and escalation rules per company.
# This framework provides the structure; specific triggers come from loaded compliance modules.

## 1. Overview

All content falls into one of four review tiers based on its risk level. Higher-risk content requires more human oversight before publishing.

| Tier | Review Level | Publishing Flow |
|------|-------------|-----------------|
| Tier 1 | Legal review | Requires legal counsel ({{LEGAL_REVIEWER}}) sign-off in addition to dual review. Highest scrutiny. |
| Tier 2 | Dual review | Two independent reviewers must approve. {{PRIMARY_REVIEWER}} + {{SECONDARY_REVIEWER}}. |
| Tier 3 | Single review | One reviewer ({{PRIMARY_REVIEWER}}) approves before publishing. |
| Tier 4 | Auto-approve | Pre-approved templates only. No per-post review. Weekly audit for drift. |

**Convention: Lower tier number = higher risk = more scrutiny.** Tier 1 is the most restrictive.

## 2. Tier 1: Legal Review (Highest Scrutiny)

Content in this category requires legal counsel review in addition to dual review. This is the highest level of scrutiny.

### What Qualifies for Tier 1

- Any content involving legal or regulatory statements or compliance claims
- Content directed at specific jurisdictions, regions, or regulatory environments
- Partnership or investment announcements
- Claims about regulatory status, licensing, or government approval
- Content that could trigger securities law concerns (e.g., Howey Test implications)
- Crisis communication and incident response statements
- Terms of service or policy-related communications
- Any content where legal liability is a concern
- Content mentioning: returns, yields, rates, APY, rewards, staking rewards, lending rates
- Content mentioning: lending platform, borrow, collateral, liquidation
- Content mentioning: token value/price, market cap, trading volume
- Content mentioning: TVL, bridge volume milestones, growth metrics
- Content involving: influencer partnerships, paid collaborations, sponsored posts
- Content involving: smart contract audit status, security claims
- Content mentioning: competitor projects by name
- All blog posts and long-form content
- Video scripts and podcast outlines (cannot be edited after production)
- Slide decks and infographics with data claims (multi-element, hard to correct post-publish)
- Data cards with editorial framing (editorial interpretation of financial data)
- All content for first 30 days of any new account
- Any red flags from Category B or C scans

### Reviewer Assignment

- **First reviewer**: {{PRIMARY_REVIEWER}} (content quality and brand voice)
- **Second reviewer**: {{SECONDARY_REVIEWER}} (compliance and accuracy)
- **Legal reviewer**: {{LEGAL_REVIEWER}} (legal risk assessment, if available)
- All must approve. Any rejection sends content back to drafting with detailed notes.
- **Turnaround SLA**: {{LEGAL_REVIEW_SLA_HOURS}} hours (legal review may take longer; do NOT rush)

### Legal Review Checklist (in addition to standard review)

1. [ ] Could this content create legal liability for {{COMPANY_NAME}}?
2. [ ] Are all regulatory claims accurate and verifiable with specific citations?
3. [ ] Does this content comply with all applicable jurisdictional requirements?
4. [ ] Could this be interpreted as a solicitation, offer, or professional advice?
5. [ ] Are all required disclosures and disclaimers present and correctly worded?
6. [ ] Have all paid relationships been properly disclosed?
7. [ ] Does this content reference any pending legal matters or ongoing investigations?

### Company-Specific Tier 1 Triggers

Configure these per tenant based on loaded compliance modules:

```
{{COMPANY_TIER1_TRIGGERS}}
```

Examples for different industries:
- **Crypto**: mentions of returns, yields, rates, APY, token price, TVL, staking rewards, lending rates, smart contract audit status
- **SaaS**: pricing claims, uptime guarantees, security certifications, data handling claims
- **Healthcare**: treatment claims, FDA references, clinical outcomes, patient testimonials
- **Finance**: interest rates, investment returns, insurance claims, regulatory status

## 3. Tier 2: Dual Review

Content in this category requires two independent reviewers to approve before publishing. This prevents single-point-of-failure approval on sensitive content.

### What Qualifies for Tier 2

- Any content mentioning competitor products or protocols by name
- All content for the first 30 days of any new account (calibration period)
- All new content templates before they enter the automated pipeline
- Any content flagged by the automated quality gate with `[REVIEW_NEEDED]`
- Content involving influencer/KOL partnerships, paid collaborations, sponsored posts
- Data cards with raw data only (no editorial framing)

### Reviewer Assignment

- **First reviewer**: {{PRIMARY_REVIEWER}}
- **Second reviewer**: {{SECONDARY_REVIEWER}}
- Both must independently approve. If either rejects, content goes back to drafting.
- **Turnaround SLA**: {{DUAL_REVIEW_SLA_HOURS}} hours from submission to decision

## 4. Tier 3: Single Review

Content in this category requires one reviewer to approve before publishing.

### What Qualifies for Tier 3

- Educational content explaining how {{COMPANY_NAME}} products work (no financial or health claims)
- Technical deep-dives and documentation summaries
- Ecosystem/industry news commentary (factual reporting only)
- Community engagement replies that do NOT mention {{COMPANY_NAME}} products directly
- Scheduled data posts (automated metrics with no editorial framing)
- Social posts using pre-approved templates with variable content filled in

### Reviewer Assignment

- **Reviewer**: {{PRIMARY_REVIEWER}}
- **Backup reviewer**: {{BACKUP_REVIEWER}} (if primary is unavailable for >{{MAX_REVIEW_WAIT_HOURS}} hours)
- **Turnaround SLA**: {{REVIEW_SLA_HOURS}} hours from submission to decision

### Requirements for Tier 3 Content

- Must pass automated quality gate (Section 7)
- Must include appropriate disclaimer (per loaded compliance modules)
- Must not contain any Tier 1 or Tier 2 trigger words
- Must have been generated from a reviewed and approved template
- Reviewer may approve, reject with notes, or escalate to Tier 2

## 5. Tier 4: Auto-Approve (Lowest Scrutiny)

Content in this category can be fully automated with no per-post human review, but templates and system prompts must be pre-approved.

### What Qualifies for Tier 4

- Memes and cultural content with NO regulated claims
- Community engagement: polls about non-regulated topics, greeting posts, community milestones
- Automated status posts that report only raw data with no editorial interpretation
- Standard FAQ responses from pre-approved answer sets
- Reshares/boosts of already-approved content

### Requirements for Tier 4 Content

- Template must be pre-approved by {{PRIMARY_REVIEWER}}
- Must pass automated quality gate (Section 7)
- Must not contain any Tier 1/2/3 trigger words
- Must include short-form disclaimer where applicable
- Weekly audit of all Tier 4 content for compliance drift

### Graduating Content to Tier 4

Content types can only be moved to Tier 4 after:
1. Running at Tier 3 for at least 30 days with zero compliance flags
2. {{PRIMARY_REVIEWER}} explicitly approves the graduation
3. A pre-approved template exists for the content type
4. The automated quality gate has been calibrated against at least 20 samples of that content type

## 6. Content Type to Tier Mapping

### Default Tier Assignments

This table provides the default tier for each content type. Companies should adjust based on their industry and risk profile.

| Content Type | Default Tier | Notes |
|-------------|:------------:|-------|
| Regulatory/compliance claims | 1 | Legal review mandatory. |
| Jurisdictional content | 1 | Legal review mandatory. |
| Crisis communications | 1 | Legal review mandatory. |
| Partnership announcements | 1 | Legal review mandatory. |
| Terms/policy communications | 1 | Legal review mandatory. |
| Blog posts / long-form content | 1 | Cannot easily retract once indexed by search engines. |
| Video scripts | 1 | Cannot edit after rendering. |
| Podcast outlines | 1 | Cannot edit after production. |
| Slide decks / infographics | 1 | Multi-element content with data claims needs full review. |
| Data cards (editorial framing) | 1 | Editorial interpretation of financial data. |
| Influencer/sponsored content | 2 | Paid relationship disclosure required. |
| New account content (first 30 days) | 2 | Calibration period. |
| New templates (before pipeline entry) | 2 | Must be reviewed before automation. |
| Competitor mentions | 2 | Category C trigger. |
| Data cards (raw data only) | 2 | No editorial framing, verified data sources. |
| Educational social posts | 3 | No product-specific financial/health claims. |
| Community replies (non-product) | 3 | Must not reference {{COMPANY_NAME}} products. |
| Technical deep-dives | 3 | Factual, verifiable content. |
| Memes / polls / greetings | 4 | Only if template pre-approved. No regulated claims. |
| Automated data posts (raw metrics) | 4 | No editorial framing. Data only. |
| FAQ responses | 4 | From pre-approved answer sets only. |

## 7. Automated Quality Gate

The following checks run automatically on all content before it enters the publishing queue. Content failing any check is escalated to at minimum Tier 2 for human review.

### 7.1 Text Scanning

- **Category A detection**: Scan for all Category A words/phrases (case-insensitive, including common misspellings). Category A words are absolute prohibitions loaded from compliance modules.
- **Category B detection**: Flag all Category B words/phrases for context review. Category B words are context-dependent and may be acceptable in educational/factual contexts.
- **Category C detection**: Flag any competitor/sensitive names.
- **URL detection**: No URLs in automated engagement replies.
- **Disclaimer verification**: Check that appropriate disclaimer is present per platform requirements.
- **Length check**: Content fits platform character limits.
- **Banned phrases check**: Check against the company's banned phrases list.

### 7.2 Sentiment and Intent Analysis

- **Promotional intensity**: Flag content above threshold on promotional language density.
- **Advice detection**: Flag content that could be interpreted as professional advice (financial, legal, medical).
- **Urgency language**: Flag "limited time," "don't miss," "last chance," "act now."
- **Promise language**: Flag "will," "guaranteed to," "always," "never fails."

### 7.3 Output Anomalies

- Flag content that mentions {{COMPANY_NAME}} when the generation context prohibits it.
- Flag content containing URLs not in the approved whitelist.
- Flag content that appears to contain escaped characters, code blocks, or system-level text.
- Flag content with unusual character patterns or encoding (prompt injection indicator).

## 8. Escalation Rules

### Automatic Escalation

Content is automatically escalated to a higher tier when:

| Condition | Escalate To |
|-----------|:-----------:|
| Any trigger word detected from a higher-scrutiny tier | That tier (lower number) |
| Automated quality gate flags `[REVIEW_NEEDED]` | Tier 2 (minimum) |
| Content mentions a competitor or sensitive name | Tier 2 (minimum) |
| Content references regulatory status or legal claims | Tier 1 |
| Content targets a specific jurisdiction | Tier 1 |
| Content involves paid partnerships or sponsorships | Tier 2 (minimum) |
| Content is the first 20 posts for a new content type | Tier 2 (minimum) |

### Manual Escalation

- Any reviewer at any tier may escalate content to a higher tier by flagging it
- Escalation reason must be documented
- Content cannot be de-escalated (moved to higher tier number) without {{PRIMARY_REVIEWER}} approval

### Escalation Override

- {{PRIMARY_REVIEWER}} may override tier assignments on a per-item basis with documented justification
- Overrides must be logged in the review audit trail
- Legal review (Tier 1) cannot be overridden without {{LEGAL_REVIEWER}} consent

## 9. Review Process Flow

```
Content Created (AI or Human)
    |
    v
Automated Quality Gate (Section 7)
    |
    +-- PASS + Tier 4 --> Auto-publish
    |
    +-- PASS + Tier 3 --> Queue for {{PRIMARY_REVIEWER}} review
    |
    +-- PASS + Tier 2 --> Queue for dual review ({{PRIMARY_REVIEWER}} + {{SECONDARY_REVIEWER}})
    |
    +-- PASS + Tier 1 --> Queue for dual review + {{LEGAL_REVIEWER}} review
    |
    +-- FAIL (any tier) --> Escalate to Tier 2 (minimum) with failure reason
    |
    +-- [REVIEW_NEEDED] flag --> Escalate to Tier 2 (minimum) with flag details
```

## 10. Reviewer Checklist

Applied to all content at Tier 3 and below (Tier 1, 2, and 3):

1. [ ] Contains no Category A prohibited language?
2. [ ] Category B words used in compliant context?
3. [ ] Appropriate disclaimer included for platform?
4. [ ] All claims are substantiated and verifiable?
5. [ ] Relevant risks disclosed?
6. [ ] Could anyone interpret this as professional advice?
7. [ ] All paid relationships disclosed?
8. [ ] Aligns with {{COMPANY_NAME}} brand voice?
9. [ ] Not targeting restricted jurisdictions?
10. [ ] Competitor mentions are factual, verifiable, and fair?

Add industry-specific items from loaded compliance modules:
```
{{ADDITIONAL_REVIEW_ITEMS}}
```

## 11. Trigger Word Categories

### Category A: Absolute Prohibitions (content rejected, must be rewritten)

Loaded from the active compliance modules. Content containing Category A words is rejected and must be rewritten. These are NOT context-dependent.

```
{{CATEGORY_A_WORDS}}
```

### Category B: Context-Dependent Review Triggers (requires judgment)

These words trigger human review to determine if usage is compliant. They may be acceptable in educational/factual contexts but not in promotional ones.

```
{{CATEGORY_B_WORDS}}
```

### Category C: Competitor/Sensitive Names (always Tier 2 or higher scrutiny)

Any mention of these entities requires dual review at minimum:

```
{{CATEGORY_C_NAMES}}
```

## 12. Configuration Guide

To set up the tier system for a new company:

1. **Load compliance modules**: Identify the appropriate modules for the company's industry (crypto, SaaS, healthcare, finance, etc.)
2. **Extract word lists**: Populate Category A, B, and C word lists from the loaded modules
3. **Assign reviewers**: Set {{PRIMARY_REVIEWER}}, {{SECONDARY_REVIEWER}}, {{BACKUP_REVIEWER}}, and {{LEGAL_REVIEWER}}
4. **Configure SLAs**: Set {{REVIEW_SLA_HOURS}}, {{DUAL_REVIEW_SLA_HOURS}}, {{LEGAL_REVIEW_SLA_HOURS}}, and {{MAX_REVIEW_WAIT_HOURS}}
5. **Configure company-specific triggers**: Add any industry-specific Tier 3 triggers
6. **Set up the automated quality gate**: Configure with the combined word lists and company-specific checks
7. **Define additional review items**: Add industry-specific reviewer checklist items
8. **Run calibration period**: First 30 days, ALL content runs at Tier 2 minimum
9. **Graduate content types**: After calibration, move content types to their target tiers based on performance and compliance track record
10. **Audit cadence**: Weekly audit of Tier 4 auto-approved content, monthly audit of Tier 3 content, quarterly protocol review

## 13. Audit and Compliance Trail

### Required Records

All review decisions must be logged with:
- Content ID
- Assigned tier
- Reviewer(s) who approved/rejected
- Decision timestamp
- Any escalation history
- Rejection reasons (if applicable)
- Override justification (if applicable)

### Retention

Review audit trails should be retained for {{AUDIT_RETENTION_PERIOD}} (recommended minimum: 12 months).

### Reporting

Generate monthly compliance reports showing:
- Total content reviewed by tier
- Approval/rejection rates by tier
- Average review turnaround time vs. SLA
- Most common rejection reasons
- Escalation frequency and patterns
- Tier 1 audit findings
