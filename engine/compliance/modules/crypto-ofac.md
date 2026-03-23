# Compliance Module: OFAC Sanctions Screening
# Scope: Loads for companies whose products or marketing could involve sanctioned jurisdictions.
# Usage: Extends `base-rules.md`. Critical for any company with international reach,
# especially crypto/DeFi where geographic restrictions are legally required.
# Load when: {COMPANY_INDUSTRY} includes "crypto", "defi", "fintech", or "payments"

## 1. OFAC-Sanctioned Countries

NEVER engage with users from, or target content at residents of, the following OFAC-sanctioned countries and regions:

- Iran
- North Korea (DPRK)
- Cuba
- Syria
- Russia (Crimea, Donetsk, Luhansk regions specifically; broader Russia sanctions may apply)

This list is subject to change. Check the OFAC Specially Designated Nationals (SDN) list and sanctions programs regularly: https://ofac.treasury.gov/

## 2. Marketing Restrictions

### Content Restrictions
- Do not create content specifically targeting audiences in sanctioned jurisdictions
- Do not translate marketing materials into languages primarily associated with sanctioned countries for the purpose of targeting those markets
- Include geographic disclaimers when content could reach restricted jurisdictions

### Engagement Restrictions
- Do not engage with social media accounts that clearly indicate they are located in sanctioned jurisdictions (check profile bio, location, language)
- If automated lead nurturing is active, add sanctioned jurisdiction filtering to the lead processing pipeline
- If uncertain about a user's jurisdiction, err on the side of non-engagement

### Advertising Restrictions
- Exclude sanctioned countries from all paid advertising geo-targeting
- If the advertising platform does not allow granular geo-exclusion for sanctioned regions (e.g., Crimea), exclude the entire parent country

## 3. Paid Advertising Geographic Exclusions

When running paid ads on any platform, the following must be excluded from targeting. This list is non-exhaustive. Verify with legal counsel.

**Always exclude:**
- OFAC-sanctioned countries (listed above)

**Exclude unless compliance confirmed:**
- EU member states (unless MiCA compliance confirmed)
- UK (unless FCA compliance confirmed)
- Singapore (MAS restrictions on public crypto promotion)
- UAE (VARA/SCA licensing required)
- China
- India (varies by product type)
- Other jurisdictions per legal counsel

## 4. Jurisdictional Disclaimer Template

When content could reach restricted jurisdictions, include:

> {COMPANY_NAME}'s services are not available in all jurisdictions. By accessing this content, you confirm that you are not a resident of a jurisdiction where such services are prohibited or restricted. Check local regulations before participating.

## 5. Lead Filtering Implementation

For automated lead nurturing or engagement systems:

1. Check user profile location/bio for sanctioned jurisdiction indicators during lead ingestion
2. Flag and exclude users from sanctioned jurisdictions before any engagement
3. Check language detection for content generated as replies (should not be in languages that suggest targeting sanctioned users)
4. Log all excluded leads for compliance audit

## 6. Monitoring and Updates

- OFAC updates its sanctions lists regularly. Subscribe to updates at: https://ofac.treasury.gov/
- Review this module monthly for any sanctions changes
- When sanctions are added or removed, update lead exclusion lists immediately
- Document all sanctions-related decisions and exclusions for compliance records
