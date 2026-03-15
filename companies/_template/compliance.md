# Compliance Rules: {COMPANY_NAME}

**These rules are MANDATORY and override all other instructions.**

## Active Compliance Modules

<!-- List which engine-level compliance modules this company loads. -->
<!-- Available modules are defined in the engine's compliance/ directory. -->

- {MODULE_1}
  <!-- e.g., "crypto-sec" for US SEC crypto marketing rules -->
- {MODULE_2}
  <!-- e.g., "crypto-fca" for UK FCA crypto promotion rules -->
- {MODULE_3}

## Absolute Prohibitions

<!-- Company-specific prohibited language. These auto-fail any content. -->

- NEVER use: {PROHIBITED_PHRASE_LIST}
  <!-- e.g., '"guaranteed returns," "risk-free," "no risk," "safe investment"' -->
- NEVER {PROHIBITION_2}
- NEVER {PROHIBITION_3}
- NEVER {PROHIBITION_4}
- NEVER {PROHIBITION_5}

## Required Language Substitutions

<!-- When describing THIS company's products, these substitutions are mandatory. -->

| Instead of | Use |
|------------|-----|
| "{TERM_1}" | "{REPLACEMENT_1}" |
| "{TERM_2}" | "{REPLACEMENT_2}" |
| "{TERM_3}" | "{REPLACEMENT_3}" |

<!-- Example for crypto:
| "invest"     | "participate" or "interact with" |
| "returns"    | "network rewards" or "protocol incentives" |
| "yield"      | "variable rate rewards" |
| "earn"       | "receive" or "be allocated" |
| "safe"       | "audited" or "open-source" (if true) |
-->

## Context-Dependent Language Rules

<!-- When do substitution rules apply strictly vs. when can standard industry terms be used? -->

The substitution table above applies STRICTLY when describing {COMPANY_NAME}'s own products, services, and mechanisms. This is non-negotiable for promotional content.

**When writing ecosystem analysis, third-party commentary, or educational content about {INDUSTRY} concepts generally**, standard industry terminology MAY be used PROVIDED all of the following:

1. The content is clearly educational or informational, not promotional of {COMPANY_NAME}
2. The language is NEVER applied to describe {COMPANY_NAME}-specific products or incentives
3. Appropriate disclaimers are attached (see Required Disclaimers below)
4. The content does not link industry terms to {COMPANY_NAME} in a way that implies {COMPANY_NAME} offers those things

### Per-Account Guidance

<!-- How each satellite account handles the context-dependent rules. -->

| Account | Guidance |
|---------|----------|
| {ACCOUNT_1} | {GUIDANCE} |
| {ACCOUNT_2} | {GUIDANCE} |

## Required Disclaimers

### Social Posts (Short Form)

> {SHORT_DISCLAIMER}
<!-- Example: "Not financial advice. Digital assets are volatile and carry risk of loss. DYOR." -->

### Blog Posts / Long-Form (Full Disclaimer)

> {LONG_DISCLAIMER}
<!-- Example: "This content is for informational and educational purposes only..." -->

### When Discussing Rates / Performance Metrics

> {RATES_DISCLAIMER}
<!-- Example: "Rates are variable, not guaranteed, and subject to change." -->

### Product-Specific Disclaimers

<!-- Add disclaimers specific to your products. -->

**When discussing {PRODUCT_1}:**
> {PRODUCT_1_DISCLAIMER}

**When discussing {PRODUCT_2}:**
> {PRODUCT_2_DISCLAIMER}

### Video Scripts (Spoken Disclaimer)

> {VIDEO_DISCLAIMER}

### Podcast Episodes (Spoken Disclaimer)

> {PODCAST_DISCLAIMER}

## Influencer / Partnership Content

- {INFLUENCER_RULE_1}
  <!-- e.g., "ALL sponsored content MUST be labeled: #ad, #sponsored" -->
- {INFLUENCER_RULE_2}
  <!-- e.g., "Disclose any token holdings or financial relationships" -->
- {INFLUENCER_RULE_3}

## Jurisdictional Compliance

<!-- Rules for geographic targeting and restricted jurisdictions. -->

- {JURISDICTION_RULE_1}
  <!-- e.g., "Do not target content at residents where marketing is prohibited" -->
- {JURISDICTION_RULE_2}
  <!-- e.g., "NEVER engage with users from OFAC-sanctioned countries" -->

### Key Jurisdictional Requirements

| Jurisdiction | Requirement |
|-------------|-------------|
| {JURISDICTION_1} | {REQUIREMENT} |
| {JURISDICTION_2} | {REQUIREMENT} |

**Default rule**: If unsure whether content targets a restricted jurisdiction, default to including the most restrictive disclaimer version.

## Human Review Gate

ALL content must be reviewed by {REVIEWER_NAME} before publishing. AI generates, human approves. No exceptions.

### Review Checklist

1. Contains no prohibited language?
2. Appropriate disclaimer included?
3. All rates/metrics described correctly?
4. Relevant risks disclosed?
5. Framed as educational/informational, not advisory?
6. All paid relationships disclosed?
7. No predictions or implied performance?
8. Aligns with brand voice?
9. {COMPANY_SPECIFIC_CHECK_1}
10. {COMPANY_SPECIFIC_CHECK_2}

---

## Changelog

| Date | Change | Approved by |
|------|--------|-------------|
| {DATE} | Initial compliance config created | {APPROVER} |
