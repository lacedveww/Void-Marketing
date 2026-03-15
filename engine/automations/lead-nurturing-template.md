# Automation: Lead Nurturing Template
# Scope: Universal lead nurturing framework for email, DM, and social engagement sequences.
# Usage: Configure stages, timing, content, and triggers per company. Replace {{PLACEHOLDER}}
# values with company specifics. This template covers the nurturing logic; see company-specific
# automation architecture docs for infrastructure details (databases, workflows, APIs).
# Prerequisite: satellite-account-pattern.md (defines accounts used for social nurturing),
# engagement-framework-template.md (defines reply templates R1-R5)

## 1. Overview

Lead nurturing is the process of building relationships with potential users/customers at every stage of their journey. This template defines a universal, multi-channel nurturing system that adapts to any company's product and audience.

### Core Principles

- **Value first**: Every touch provides genuine value. No empty follow-ups or "just checking in" messages.
- **Respect frequency**: Leads have a maximum contact frequency. Exceeding it damages the relationship.
- **Channel-appropriate**: Match the message to the channel. DMs are personal. Emails are detailed. Social is public.
- **Score-driven**: Lead score determines what content they receive and when.
- **Compliance-first**: All nurturing content passes through the review tier system before sending.
- **Incremental deployment**: Start manual (Phase A), semi-automate (Phase B), then fully automate (Phase C).

### Channels

| Channel | Use For | Frequency Cap |
|---------|---------|:-------------:|
| Email ({{EMAIL_TOOL}}) | Detailed educational content, product updates, onboarding sequences | {{EMAIL_FREQUENCY_CAP}} per week |
| Social DM | Support, direct relationship building (only if user initiated first) | {{DM_FREQUENCY_CAP}} per week |
| Social engagement (replies, likes, QTs) | Public relationship building, community presence | {{SOCIAL_FREQUENCY_CAP}} per day per account |
| Community (Discord/Telegram) | Group engagement, announcements, support | No cap (organic participation) |

## 2. Lead Scoring

### 2.1 Score Tiers

| Tier | Score Range | Definition | Nurturing Approach |
|------|:----------:|-----------|-------------------|
| Cold | 0-{{COLD_MAX}} | New or low engagement. May have liked once or followed. | Awareness stage content. Broad, educational. |
| Warm | {{WARM_MIN}}-{{WARM_MAX}} | Repeated engagement. Multiple touchpoints. Shows interest. | Consideration stage content. Product-specific education. |
| Hot | {{HOT_MIN}}-{{HOT_MAX}} | High engagement. Engages with product content. Asks questions. | Decision stage content. Direct CTAs, onboarding support. |
| Whale | {{WHALE_MIN}}+ | High-value lead. Large following, industry influence, or verified high-value user. | VIP treatment. Personal outreach. Priority support. |

### 2.2 Scoring Events

Configure point values per tenant. Recommended starting values:

| Event | Points | Notes |
|-------|:------:|-------|
| Follow | +{{FOLLOW_POINTS}} | One-time event |
| Like | +{{LIKE_POINTS}} | Per occurrence |
| Reply | +{{REPLY_POINTS}} | Higher intent than like |
| Retweet/Repost | +{{RETWEET_POINTS}} | Public endorsement signal |
| Quote tweet | +{{QT_POINTS}} | Highest public engagement |
| DM initiation | +{{DM_POINTS}} | Direct interest signal |
| Email open | +{{EMAIL_OPEN_POINTS}} | Shows continued interest |
| Email click | +{{EMAIL_CLICK_POINTS}} | High intent |
| Product page visit | +{{PAGE_VISIT_POINTS}} | Requires tracking integration |
| Product action (sign-up, trial, etc.) | +{{PRODUCT_ACTION_POINTS}} | Conversion signal |

### 2.3 Profile-Based Multipliers

| Factor | Multiplier | Rationale |
|--------|:---------:|-----------|
| Followers > {{INFLUENCER_THRESHOLD}} | 1.5x | Influencer potential |
| Followers > {{HIGH_REACH_THRESHOLD}} | 2.0x | High-reach amplifier |
| Bio contains {{INDUSTRY_KEYWORDS}} | 1.3x | Domain relevance |
| Bio contains "developer" or "building" | 1.4x | Potential product user |
| Verified / Premium | 1.2x | Higher visibility |
| Account age < 30 days | 0.5x | Bot risk |
| Following/follower ratio > 10 | 0.3x | Likely spam |

### 2.4 Score Decay

| Condition | Action |
|-----------|--------|
| No engagement in 14 days | Score decays 10% |
| No engagement in 30 days | Score decays 25%, tier drops one level |
| No engagement in 60 days | Lead moved to paused status |
| Any new engagement | Full score restored, decay timer resets |

## 3. Nurturing Stages

### Stage 1: Awareness

**Goal**: Introduce {{COMPANY_NAME}} and establish credibility. The lead should understand what {{COMPANY_NAME}} does and why it matters.

**Target**: Cold leads (score 0-{{COLD_MAX}})

#### Awareness Touches

| Touch | Channel | Timing | Content |
|:-----:|---------|--------|---------|
| A1 | Social engagement | Within {{A1_TIMING}} of first engagement | Acknowledge their engagement. Substantive reply per engagement framework (R1 or R3 template). Do NOT be promotional. |
| A2 | Email (if opted in) | {{A2_TIMING}} after A1 | Welcome email. Who is {{COMPANY_NAME}}? What problem do we solve? Include one educational resource. No product pitch. |
| A3 | Social engagement | {{A3_TIMING}} after A1 | Engage with THEIR content (not about {{COMPANY_NAME}}). Provide genuine value. Build relationship. |
| A4 | Email (if opted in) | {{A4_TIMING}} after A2 | Educational content related to their interests (from lead profile). Industry insight, not product pitch. |
| A5 | Social engagement | {{A5_TIMING}} after A3 | Second engagement with their content. Different angle. Show pattern of genuine interest. |

#### Awareness Email Templates

**A2: Welcome Email**
```
Subject: {{A2_SUBJECT_LINE}}

Hi {{LEAD_NAME}},

{{A2_OPENING_LINE}}

{{COMPANY_VALUE_PROP_BRIEF}}

Here's a resource you might find useful: {{EDUCATIONAL_RESOURCE_LINK}}

{{A2_SIGN_OFF}}

{{SHORT_DISCLAIMER}}
```

**A4: Educational Follow-Up**
```
Subject: {{A4_SUBJECT_LINE}}

{{A4_OPENING_LINE}}

{{EDUCATIONAL_CONTENT_BODY}}

{{A4_SIGN_OFF}}

{{SHORT_DISCLAIMER}}
```

#### Awareness Exit Conditions

- Lead reaches Warm tier (score >= {{WARM_MIN}}) --> advance to Stage 2
- Lead opts out --> move to Excluded
- No engagement for {{AWARENESS_TIMEOUT}} --> move to Re-engagement (Stage 4)

#### Awareness Content Guidelines

- 80% educational, 20% brand awareness
- No product CTAs in awareness stage
- Focus on the problem space, not the solution
- Reference {{ANCHOR_METRICS}} only if naturally relevant
- All email content must include unsubscribe link

### Stage 2: Consideration

**Goal**: The lead is aware of {{COMPANY_NAME}} and exploring whether it is relevant to them. Nurture with product education, use cases, and social proof.

**Target**: Warm leads (score {{WARM_MIN}}-{{WARM_MAX}})

#### Consideration Touches

| Touch | Channel | Timing | Content |
|:-----:|---------|--------|---------|
| C1 | Email | Triggered on tier upgrade | "Here's what {{COMPANY_NAME}} actually does": product overview tailored to their interests. |
| C2 | Social engagement | {{C2_TIMING}} after C1 | Share a relevant data card, thread, or insight related to their interest area. |
| C3 | Email | {{C3_TIMING}} after C1 | Deep-dive: how-to guide or technical walkthrough relevant to their profile. |
| C4 | Social engagement | {{C4_TIMING}} after C2 | Engage with their content again. Reference something specific they said/posted. |
| C5 | Email | {{C5_TIMING}} after C3 | Social proof: case study, community milestone, or third-party coverage. |
| C6 | Social engagement | {{C6_TIMING}} after C4 | Share ecosystem insight relevant to their interests. Position {{COMPANY_NAME}} as infrastructure. |

#### Consideration Email Templates

**C1: Product Overview**
```
Subject: {{C1_SUBJECT_LINE}}

Hi {{LEAD_NAME}},

{{C1_OPENING_LINE}}

Here's what {{COMPANY_NAME}} does:

{{PRODUCT_OVERVIEW_BODY}}

Learn more: {{PRODUCT_DOCS_LINK}}

{{C1_SIGN_OFF}}

{{SHORT_DISCLAIMER}}
```

**C3: How-To Guide**
```
Subject: {{C3_SUBJECT_LINE}}

Hi {{LEAD_NAME}},

{{C3_OPENING_LINE}}

{{HOW_TO_GUIDE_BODY}}

Full guide: {{GUIDE_LINK}}

{{C3_SIGN_OFF}}

{{SHORT_DISCLAIMER}}
```

**C5: Social Proof**
```
Subject: {{C5_SUBJECT_LINE}}

Hi {{LEAD_NAME}},

{{C5_OPENING_LINE}}

{{SOCIAL_PROOF_BODY}}

{{C5_SIGN_OFF}}

{{SHORT_DISCLAIMER}}
```

#### Consideration Exit Conditions

- Lead reaches Hot tier (score >= {{HOT_MIN}}) --> advance to Stage 3
- Lead takes a product action --> advance to Stage 3 immediately
- Lead opts out --> move to Excluded
- Score drops below {{COLD_MAX}} --> move back to Stage 1
- No engagement for {{CONSIDERATION_TIMEOUT}} --> move to Re-engagement (Stage 4)

#### Consideration Content Guidelines

- 50% educational, 30% product-specific, 20% social proof
- CTAs should be soft: "Learn more," "See how it works," "Explore docs"
- Address common objections and concerns transparently
- Reference {{ANCHOR_METRICS}} to establish credibility
- Include appropriate disclaimers per loaded compliance modules

### Stage 3: Decision / Conversion

**Goal**: The lead is actively evaluating {{COMPANY_NAME}}. Remove friction, answer questions, and provide clear pathways to action.

**Target**: Hot leads (score {{HOT_MIN}}-{{HOT_MAX}})

#### Decision Touches

| Touch | Channel | Timing | Content |
|:-----:|---------|--------|---------|
| D1 | Email | Triggered on tier upgrade | Direct product CTA. "Ready to try {{PRODUCT_NAME}}? Here's how to get started." Step-by-step onboarding. |
| D2 | Social DM (only if they initiated prior) | {{D2_TIMING}} after D1 | Personal outreach: "Saw you've been exploring {{PRODUCT_NAME}}. Happy to answer any questions." |
| D3 | Email | {{D3_TIMING}} after D1 | Address top 3 common objections/concerns. Link to support resources. |
| D4 | Social engagement | {{D4_TIMING}} after D2 | Share relevant product update or milestone. Show momentum. |
| D5 | Email | {{D5_TIMING}} after D3 | Final conversion push: specific benefit + CTA. Include risk disclosures per compliance modules. |

#### Decision Email Templates

**D1: Onboarding CTA**
```
Subject: {{D1_SUBJECT_LINE}}

Hi {{LEAD_NAME}},

{{D1_OPENING_LINE}}

Here's how to get started with {{PRODUCT_NAME}}:

{{ONBOARDING_STEPS}}

Start here: {{PRODUCT_CTA_LINK}}

{{D1_SIGN_OFF}}

{{FULL_DISCLAIMER}}
```

**D3: Objection Handler**
```
Subject: {{D3_SUBJECT_LINE}}

Hi {{LEAD_NAME}},

{{D3_OPENING_LINE}}

{{OBJECTION_1_HEADING}}
{{OBJECTION_1_RESPONSE}}

{{OBJECTION_2_HEADING}}
{{OBJECTION_2_RESPONSE}}

{{OBJECTION_3_HEADING}}
{{OBJECTION_3_RESPONSE}}

Need help? {{SUPPORT_LINK}}

{{D3_SIGN_OFF}}

{{FULL_DISCLAIMER}}
```

**D5: Conversion Push**
```
Subject: {{D5_SUBJECT_LINE}}

Hi {{LEAD_NAME}},

{{D5_OPENING_LINE}}

{{CONVERSION_BENEFIT_BODY}}

{{PRODUCT_CTA_LINK}}

{{RISK_DISCLOSURES}}

{{FULL_DISCLAIMER}}
```

#### Decision Exit Conditions

- Lead converts (product action) --> move to Post-Conversion (Stage 5)
- Lead reaches Whale tier --> advance to VIP track (Stage 6)
- Lead opts out --> move to Excluded
- Score drops below {{WARM_MIN}} --> move back to Stage 2
- No engagement for {{DECISION_TIMEOUT}} --> move to Re-engagement (Stage 4)

#### Decision Content Guidelines

- 40% product-specific, 30% onboarding support, 30% social proof
- CTAs should be direct: "Start now," "Try it," specific product actions
- All product-related content MUST include appropriate disclaimers
- Risk disclosures are mandatory in this stage (per loaded compliance modules)
- DM outreach only when lead has previously initiated a DM conversation

### Stage 4: Re-engagement

**Goal**: Revive interest from leads who have gone cold. Light touches to re-establish relevance without being pushy.

**Target**: Any lead inactive for {{REENGAGEMENT_TRIGGER_DAYS}}+ days

#### Re-engagement Touches

| Touch | Channel | Timing | Content |
|:-----:|---------|--------|---------|
| R1 | Email | Day 0 (re-engagement trigger) | "What's new at {{COMPANY_NAME}}": highlight 2-3 recent developments. No hard sell. |
| R2 | Social engagement | {{R2_TIMING}} after R1 | Engage with their recent content (if any). No mention of {{COMPANY_NAME}}. Pure relationship. |
| R3 | Email | {{R3_TIMING}} after R1 | Educational content: industry insight or trend analysis. Provide standalone value. |

#### Re-engagement Email Templates

**R1: What's New**
```
Subject: {{R1_SUBJECT_LINE}}

Hi {{LEAD_NAME}},

Here's what's been happening at {{COMPANY_NAME}}:

{{RECENT_DEVELOPMENT_1}}

{{RECENT_DEVELOPMENT_2}}

{{RECENT_DEVELOPMENT_3}}

{{R1_SIGN_OFF}}

{{SHORT_DISCLAIMER}}
{{UNSUBSCRIBE_LINK}}
```

**R3: Value-First Educational**
```
Subject: {{R3_SUBJECT_LINE}}

Hi {{LEAD_NAME}},

{{R3_OPENING_LINE}}

{{EDUCATIONAL_CONTENT_BODY}}

{{R3_SIGN_OFF}}

{{SHORT_DISCLAIMER}}
{{UNSUBSCRIBE_LINK}}
```

#### Re-engagement Exit Conditions

- Lead re-engages (any scoring event) --> return to appropriate stage based on current score
- No response after all 3 touches --> move to Dormant
- Lead opts out --> move to Excluded

#### Re-engagement Content Guidelines

- 90% value, 10% brand mention
- NEVER guilt-trip ("We miss you," "Where did you go?")
- NEVER create false urgency ("Limited time," "Don't miss out")
- Maximum 3 re-engagement attempts per {{REENGAGEMENT_COOLDOWN_DAYS}}-day period
- After 3 failed re-engagement cycles, move to Dormant permanently (do not keep contacting)

### Stage 5: Post-Conversion

**Goal**: Retain converted users. Help them succeed with the product. Turn them into advocates.

**Target**: Leads who have completed the primary product action

#### Post-Conversion Onboarding Sequence

| Touch | Channel | Timing | Content |
|:-----:|---------|--------|---------|
| PC1 | Email | Immediately on conversion | Welcome + next steps. What they can do now. Link to docs/tutorials. |
| PC2 | Email | {{PC2_TIMING}} after conversion | "Getting the most out of {{PRODUCT_NAME}}": tips, best practices, power user features. |
| PC3 | Social engagement | {{PC3_TIMING}} after conversion | Engage with their content. Acknowledge them as part of the community. |
| PC4 | Email | {{PC4_TIMING}} after conversion | Feature spotlight: something they have not tried yet. Based on usage profile if available. |
| PC5 | Email | {{PC5_TIMING}} after conversion | Ask for feedback. What is working? What could be better? Link to feedback form or community. |

#### Post-Conversion Ongoing Retention

After the onboarding sequence, converted leads receive:
- Monthly product update emails (new features, metrics, milestones)
- Community engagement at normal frequency
- Priority support access
- Re-engagement sequence if inactive for {{CONVERTED_REENGAGEMENT_DAYS}} days

#### Post-Conversion Content Guidelines

- 40% product education (advanced features), 30% community, 30% updates
- Ask for feedback genuinely (and act on it)
- Celebrate their milestones and achievements with the product
- Never take converted users for granted. Retention is ongoing

### Stage 6: VIP / Whale Track

Leads that reach Whale tier (score {{WHALE_MIN}}+) or are manually flagged as high-value get a separate nurturing track.

#### VIP Identification Criteria

- Follower count above {{WHALE_FOLLOWER_THRESHOLD}}
- Industry influencer or KOL
- Verified high-value user (large transaction volume, institutional)
- Media or press contacts
- Manually flagged by {{PRIMARY_REVIEWER}}

#### VIP Nurturing Rules

- **Personal outreach**: {{PRIMARY_REVIEWER}} or designated team member handles directly
- **No automated content**: All VIP touches are manually crafted and reviewed
- **Priority support**: VIP support questions answered within {{VIP_RESPONSE_SLA}}
- **Exclusive content**: Early access to announcements, alpha previews, beta invites
- **Event invitations**: AMAs, Spaces, partner events, advisory opportunities
- **Frequency**: Maximum {{VIP_FREQUENCY_CAP}} touches per week unless lead initiates more

## 4. Multi-Account / Satellite Coordination

When operating multiple social accounts, lead nurturing engagement must be coordinated to avoid detection as a coordinated operation.

### Assignment Rules

- Each lead is assigned to a maximum of {{MAX_SATELLITE_ASSIGNMENTS}} satellite accounts
- Assignment is based on the lead's interests and the satellite's persona/topic alignment
- Satellite accounts engage with the LEAD'S content (not {{COMPANY_NAME}} content) to provide genuine value
- Never assign all satellites to the same lead on the same day

### Timing Rules

- If multiple satellites are assigned to the same lead, stagger engagements by minimum {{SATELLITE_STAGGER_HOURS}} hours
- Never have more than 1 satellite engage with the same lead's post
- Rotate which satellite engages first to avoid predictable patterns
- Add random jitter to scheduled engagement times

### Coordination Rules

- Satellites must NEVER reference each other when engaging the same lead
- If a lead directly asks one satellite about another, respond honestly about {{COMPANY_NAME}} affiliation
- Engagement content must match each satellite's persona and voice (per loaded account configurations)

## 5. Compliance Requirements

### Consent

- Email nurturing requires explicit opt-in (double opt-in recommended)
- Social engagement on public posts does not require consent but must respect opt-out requests
- DM engagement requires prior conversation initiated by the lead
- Privacy policy must disclose engagement tracking practices
- DPIA (Data Protection Impact Assessment) required before deploying automated scoring and profiling

### Content Compliance

- All nurturing content passes through the review tier system before sending
- Email sequences are pre-approved as templates (Tier 2+ per review-tier-system.md)
- Personalized/dynamic content elements are auto-checked by quality gate
- All product-related content includes appropriate disclaimers per loaded compliance modules

### Data Protection

- Lead data retention: {{DATA_RETENTION_MONTHS}} months from last engagement, then auto-purged
- Engagement event retention: {{EVENT_RETENTION_MONTHS}} months, then auto-purged
- Implement data subject access request (DSAR) process (target response: 30 days per GDPR)
- Opt-out mechanism must be clearly accessible in all communications
- Score data is not shared with third parties
- Lead nurturing database must be separate from any product/financial databases

### Anti-Spam

- Email: comply with CAN-SPAM / GDPR / applicable local laws
- Social: do not send unsolicited DMs for marketing purposes
- Respect platform rate limits and terms of service
- Include unsubscribe mechanism in all emails
- Maintain suppression lists across all channels

## 6. Deployment Phases

This system MUST be deployed incrementally. Building full automation before establishing organic presence is premature.

### Phase A: Manual / Lightweight (0 to {{PHASE_A_FOLLOWER_TARGET}} followers)

- No automation infrastructure. Manual engagement from {{MAIN_ACCOUNT}} and satellites.
- Track leads in a shared spreadsheet: Handle, First Engagement Date, Tier, Notes, Last Engaged, Assigned Account.
- Manual engagement: {{DAILY_REPLY_TARGET}} quality replies/day, {{WEEKLY_ORGANIC_TARGET}} organic posts/week per satellite.
- Human reviews all outbound content before posting.
- Email sequences managed manually or via basic email tool.
- **Transition trigger**: Consistent {{PHASE_A_ENGAGEMENT_THRESHOLD}}+ inbound engagements/day for 2+ weeks.

### Phase B: Semi-Automated ({{PHASE_A_FOLLOWER_TARGET}} to {{PHASE_B_FOLLOWER_TARGET}} followers)

- Deploy workflow automation with Engagement Poller and Daily Reset workflows.
- Database deployed (leads + engagements tables).
- CRM integration for contact management and scoring.
- Email sequences automated, content still human-composed with AI assistance.
- Approval gate on ALL outbound social content.
- **Transition trigger**: {{PHASE_B_ENGAGEMENT_THRESHOLD}}+ inbound engagements/day for 4+ weeks.

### Phase C: Full Automation ({{PHASE_B_FOLLOWER_TARGET}}+ followers)

- Full system: all database tables, caching layer, all workflows, AI content generation, approval gate progression.
- Auto-approve for likes and organic posts; human review for replies and QTs initially, graduated auto-approval based on confidence scores.
- Full email automation with dynamic personalization.

## 7. Metrics and Optimization

### Stage Metrics

| Metric | What It Measures | Target |
|--------|-----------------|--------|
| Stage advancement rate | % of leads that move to the next stage | >{{STAGE_ADVANCEMENT_TARGET}}% |
| Average time in stage | Days before advancement or dropout | <{{MAX_STAGE_DAYS}} days |
| Touch response rate | % of touches that generate a response | >{{TOUCH_RESPONSE_TARGET}}% |
| Conversion rate | % of leads that reach product action | >{{CONVERSION_TARGET}}% |
| Opt-out rate | % of leads that opt out | <{{OPT_OUT_MAX}}% |
| Re-engagement success rate | % of dormant leads re-engaged | >{{REENGAGEMENT_TARGET}}% |
| Email open rate | % of emails opened | >{{EMAIL_OPEN_TARGET}}% |
| Email click-through rate | % of emails clicked | >{{EMAIL_CTR_TARGET}}% |

### Optimization Cadence

- **Weekly**: Review touch response rates. Identify underperforming content. A/B test subject lines, hooks, CTAs.
- **Monthly**: Review stage advancement rates. Adjust scoring thresholds if leads advance too fast or too slowly. Update content based on performance data.
- **Quarterly**: Full funnel review. Are the right leads converting? Is the scoring model accurate? Review and adjust timing intervals. Feed findings into voice calibration loop.

## 8. Configuration Guide

To set up lead nurturing for a new company:

1. **Define scoring model**: Set point values for each engagement type and tier thresholds
2. **Configure channels**: Set up {{EMAIL_TOOL}} integration, social API access, community connections
3. **Set frequency caps**: Define maximum contact frequency per channel
4. **Write stage content**: Draft all touch content per stage, following brand voice guidelines
5. **Configure timing**: Set intervals between touches for each stage
6. **Set up compliance**: Load compliance modules, configure disclaimers, set up consent mechanisms
7. **Define VIP criteria**: Set whale thresholds and VIP identification rules
8. **Assign reviewers**: Configure who reviews nurturing content per review tier system
9. **Build automation**: Implement workflows in {{AUTOMATION_TOOL}}
10. **Deploy Phase A**: Start manual, track leads in spreadsheet, run for minimum 4 weeks
11. **Monitor and optimize**: Track metrics from day 1. Adjust after 30, 60, and 90 days of data
12. **Graduate to Phase B/C**: Only when transition triggers are met

## 9. Template Variables Reference

All configurable variables used in this template:

| Variable | Description | Example Value |
|----------|-------------|---------------|
| {{COMPANY_NAME}} | Company name | "Acme Corp" |
| {{PRODUCT_NAME}} | Primary product name | "Acme Platform" |
| {{MAIN_ACCOUNT}} | Main social account handle | "@acme" |
| {{EMAIL_TOOL}} | Email marketing platform | "Mautic" |
| {{AUTOMATION_TOOL}} | Workflow automation platform | "n8n" |
| {{PRIMARY_REVIEWER}} | Primary content reviewer | "Marketing Lead" |
| {{SECONDARY_REVIEWER}} | Secondary reviewer | "Content Manager" |
| {{ANCHOR_METRICS}} | Key metrics to reference | "Users, revenue, uptime" |
| {{COLD_MAX}} | Max score for cold tier | "20" |
| {{WARM_MIN}} / {{WARM_MAX}} | Warm tier range | "21 / 50" |
| {{HOT_MIN}} / {{HOT_MAX}} | Hot tier range | "51 / 80" |
| {{WHALE_MIN}} | Min score for whale | "81" |
| {{EMAIL_FREQUENCY_CAP}} | Max emails/week | "2" |
| {{DM_FREQUENCY_CAP}} | Max DMs/week | "1" |
| {{SOCIAL_FREQUENCY_CAP}} | Max social touches/day/account | "3" |
| {{MAX_SATELLITE_ASSIGNMENTS}} | Max satellites per lead | "2" |
| {{SATELLITE_STAGGER_HOURS}} | Min hours between satellite engagements | "4" |
| {{DATA_RETENTION_MONTHS}} | Lead data retention | "12" |
| {{EVENT_RETENTION_MONTHS}} | Event data retention | "6" |
| {{AWARENESS_TIMEOUT}} | Days before awareness stage timeout | "30" |
| {{CONSIDERATION_TIMEOUT}} | Days before consideration stage timeout | "45" |
| {{DECISION_TIMEOUT}} | Days before decision stage timeout | "30" |
| {{REENGAGEMENT_TRIGGER_DAYS}} | Days inactive before re-engagement | "30" |
| {{REENGAGEMENT_COOLDOWN_DAYS}} | Days between re-engagement cycles | "60" |
| {{WHALE_FOLLOWER_THRESHOLD}} | Follower count for whale ID | "10000" |
| {{VIP_RESPONSE_SLA}} | VIP support SLA | "1 hour" |
| {{VIP_FREQUENCY_CAP}} | Max VIP touches/week | "3" |
