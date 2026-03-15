# Compliance Module: SaaS-Specific GDPR Marketing
# Scope: Loads for SaaS companies marketing to EU/EEA residents.
# Usage: Extends `data-handling-base.md` and `base-rules.md`. Adds SaaS-specific
# GDPR marketing requirements covering email marketing, cookie consent,
# data personalization, and right to erasure in marketing databases.
# Load when: {COMPANY_INDUSTRY} includes "saas" and {COMPANY_MARKETS} includes EU

## 1. Email Marketing Consent

### 1.1 Double Opt-In (Required)

All email marketing to EU residents must use double opt-in:
1. User submits email via form
2. Confirmation email sent with verification link
3. User clicks verification link to confirm subscription
4. Only after confirmation is the user added to active marketing lists

### 1.2 Consent Specificity

- Consent for email marketing must be separate from consent for product terms of service
- Do not bundle marketing consent with account creation consent
- Each type of marketing (product updates, promotional offers, partner emails, newsletters) should have separate consent options
- Pre-ticked checkboxes are NOT valid consent under GDPR

### 1.3 Consent Records

For each subscriber, store and maintain:
- Timestamp of consent
- Source of consent (which form, which page, which campaign)
- IP address at time of consent (for verification, not marketing)
- Exact text of the consent statement shown to the user
- Double opt-in confirmation timestamp

Retain consent records for the duration of the relationship plus 3 years.

### 1.4 Unsubscribe Mechanism

- Every marketing email must include a one-click unsubscribe link
- Unsubscribe must take effect within 10 business days (FTC CAN-SPAM) or "without undue delay" (GDPR)
- Do not require login, account creation, or multi-step processes to unsubscribe
- Do not send a "sorry to see you go" marketing email after unsubscribe
- Suppression list: maintain a list of unsubscribed addresses to prevent re-enrollment

## 2. Cookie Consent

### 2.1 Cookie Categories

| Category | Consent Required | Examples |
|----------|-----------------|----------|
| Essential | No (legitimate interest) | Session cookies, security tokens, load balancers |
| Analytics | Yes (explicit consent) | Google Analytics, Mixpanel, Amplitude, Hotjar |
| Marketing | Yes (explicit consent) | Meta Pixel, Google Ads remarketing, LinkedIn Insight Tag |
| Personalization | Yes (explicit consent) | A/B testing cookies, user preference cookies |

### 2.2 Cookie Consent Banner Requirements

- Must appear on first visit before any non-essential cookies are set
- Must offer three clear options: Accept All, Reject All, Manage Preferences
- "Reject All" must be as easy to click as "Accept All" (no dark patterns)
- Must NOT use pre-selected checkboxes
- Must NOT use confusing language ("legitimate interest" toggle patterns)
- Cookie wall (blocking access until consent is given) is generally NOT acceptable under GDPR
- Consent must be as easy to withdraw as it was to give

### 2.3 Post-Consent Behavior

- If user rejects non-essential cookies, do NOT set them. Verify implementation
- If user later changes preference, honor the new preference immediately
- Consent expiry: re-prompt for consent every 12 months (or per local DPA guidance)
- Document consent preferences server-side, not just in browser cookies

## 3. Right to Erasure in Marketing Databases

### 3.1 Scope of Erasure

When a user requests deletion, remove their data from ALL marketing systems:
- CRM contact records (HubSpot, Salesforce, Mautic, etc.)
- Email marketing lists (Mailchimp, SendGrid, etc.)
- Marketing automation workflows and triggers
- Lead scoring databases
- Retargeting/remarketing audience lists
- Analytics user-level data (where identifiable)
- A/B test participation records (where identifiable)
- Customer support tickets used for marketing segmentation

### 3.2 Erasure Process

1. Receive deletion request via {PRIVACY_EMAIL} or in-product mechanism
2. Verify identity of requestor (email match, account verification)
3. Delete from all marketing systems within 30 days
4. Add to suppression list (email address only) to prevent re-enrollment
5. Send confirmation of deletion to requestor
6. Log the deletion event (timestamp, systems cleared) for audit

### 3.3 Exceptions

Data that may be retained after erasure request:
- Suppression list entry (email address only, to prevent re-enrollment)
- Anonymized aggregate data that cannot be traced to the individual
- Data required for legal compliance (e.g., financial records for tax purposes)
- Data required to resolve ongoing disputes

## 4. Data Processing for Personalization

### 4.1 Lawful Basis

Personalization of marketing content (product recommendations, dynamic content, behavioral targeting) requires either:
- Explicit consent (preferred for EU), OR
- Legitimate interest with a documented balancing test

### 4.2 Personalization Transparency

- Inform users that personalization is occurring (privacy policy and/or in-product notice)
- Explain what data is used for personalization
- Provide a mechanism to opt out of personalized marketing while still receiving non-personalized communications

### 4.3 Automated Decision-Making

If personalization involves fully automated decisions that significantly affect the user (e.g., pricing, access to features, credit scoring):
- GDPR Article 22 applies: user has the right not to be subject to such decisions
- Provide a mechanism for human review of automated decisions
- Inform users about the logic involved (at a high level)

### 4.4 Profiling Restrictions

- Do not profile users based on sensitive data categories (health, religion, political opinions, sexual orientation, etc.)
- If profiling involves minors, additional protections apply
- Document all profiling activities in the Data Protection Impact Assessment (DPIA)

## 5. International Email Marketing

### 5.1 CAN-SPAM (US)

If also marketing to US residents:
- From address must be accurate
- Subject line must not be misleading
- Content must be identifiable as advertising
- Physical mailing address must be included
- Unsubscribe mechanism required, honored within 10 business days

### 5.2 CASL (Canada)

If marketing to Canadian residents:
- Express consent required (implied consent has limited scope and duration)
- Identification of sender required
- Unsubscribe mechanism required, honored within 10 business days
- CASL penalties are among the highest globally

### 5.3 Best Practice

Default to the most restrictive standard (typically GDPR double opt-in) for all email marketing. This ensures compliance across all jurisdictions.

## 6. Implementation Checklist

- [ ] Double opt-in implemented for all email marketing?
- [ ] Consent records stored with timestamp, source, and exact consent text?
- [ ] One-click unsubscribe in every marketing email?
- [ ] Cookie consent banner meets GDPR requirements (Reject All as easy as Accept All)?
- [ ] No non-essential cookies set before consent?
- [ ] Erasure process documented and tested across all marketing systems?
- [ ] Suppression list maintained to prevent re-enrollment?
- [ ] Personalization transparency in privacy policy?
- [ ] DPIA completed for profiling activities?
- [ ] Consent re-prompted every 12 months?
