# Compliance Module: SEC / Securities Law (US)
# Scope: Loads ONLY for companies operating in crypto/DeFi/token ecosystems.
# Usage: This module extends `base-rules.md`. It adds crypto-specific prohibitions,
# required language substitutions, and Howey Test avoidance guidance.
# Load when: {COMPANY_INDUSTRY} includes "crypto", "defi", "token", or "blockchain"

## 1. Absolute Prohibitions

NEVER use any of the following in marketing content for {COMPANY_NAME} products:

| Prohibited Phrase | Why |
|------------------|-----|
| "guaranteed returns" | Securities law, implies certain financial outcome |
| "risk-free" / "no risk" | Securities law, no crypto product is risk-free |
| "safe investment" / "secure investment" | Conflates security features with investment safety |
| "get rich" / "financial freedom" | FTC deceptive marketing + implies guaranteed outcome |
| "passive income" | SEC: frames participation as earning without effort (Howey prong 3) |
| "to the moon" / "100x" (or any specific multiple) | Explicit or implied price prediction |
| "guaranteed" (in any financial context) | False promise |
| "SEC-approved" / "SEC-registered" / "CFTC-approved" | False regulatory claim (unless verifiably true with citation) |
| "government-backed" / "FDIC-insured" | False safety claim |
| "investment" (describing token purchase/staking) | Howey Test trigger (prong 1) |
| "earn" (describing staking/lending/participation) | Howey Test trigger, use "receive" or "be allocated" |
| "yield" (without "variable" qualifier) | Howey Test trigger, use "variable rate rewards" |
| "profit" (describing protocol participation) | Howey Test trigger, use "network-generated rewards" |
| "high APY" (without specific rate + disclaimer) | Misleading, use "current estimated rate of X%, subject to change" |
| "allocation" (in context of rewards/airdrops) | Implies securities distribution, requires legal review |
| "airdrop" (as incentive for user actions) | Regulatory risk, SEC enforcement precedent |
| Payment stablecoin claims | Cannot market as "payment stablecoin" unless issued under the GENIUS Act |

## 2. Required Language Substitutions

When describing {COMPANY_NAME}'s own products, services, staking, bridge rewards, or lending:

| Instead of | Use |
|------------|-----|
| "invest" | "participate" or "interact with" |
| "returns" | "network rewards" or "protocol incentives" |
| "yield" | "variable rate rewards" or "network compensation" |
| "earn" | "receive" or "be allocated" |
| "profit" | "network-generated rewards" |
| "safe" | "audited" or "open-source" (if true) |
| "guaranteed" | "variable" or "estimated" |
| "passive income" | "participation rewards" |
| "high APY" | "current estimated rate of X%, subject to change" |

### Context-Dependent Language Rules

The substitution table applies STRICTLY when describing {COMPANY_NAME}'s own products.

When writing ecosystem analysis, third-party commentary, or educational content about DeFi concepts generally, standard industry terminology (yield, APY, earn, farming) MAY be used if ALL of:
1. The content is clearly educational or informational, not promotional
2. The language is NEVER applied to describe {COMPANY_NAME}-specific rewards or returns
3. Appropriate disclaimers are attached
4. The content does not link industry terms to {COMPANY_NAME} in a way that implies {COMPANY_NAME} offers "yield" or "earnings"

## 3. Required Disclaimers

### Social posts (short form)
> Not financial advice. Digital assets are volatile and carry risk of loss. DYOR.

### Blog posts / long-form (full disclaimer)
> This content is for informational and educational purposes only and does not constitute financial, investment, legal, or tax advice. Digital assets are highly volatile and carry significant risks including potential total loss. Past performance does not guarantee future results. {COMPANY_NAME} does not custody user funds. Consult qualified advisors before making decisions.

### When discussing rates/APY
> Rates are variable, not guaranteed, and subject to change. Past performance does not guarantee future results.

### When discussing lending/bridging
> Participation involves risks including smart contract vulnerabilities, market volatility, impermanent loss, liquidation risk, and potential total loss of funds.

### When discussing staking
Always frame as "network participation" or "protocol validation," not "earning" or "investing."

### Video scripts (spoken)
> This content is for informational purposes only and does not constitute financial advice. Digital assets are volatile and carry risk of total loss. Not financial advice. Do your own research.

### Podcast episodes (spoken)
> This podcast is for informational and educational purposes only. Nothing discussed constitutes financial, investment, or legal advice. Digital assets carry significant risks including potential total loss. Always do your own research and consult qualified advisors.

## 4. Howey Test Language Avoidance

The Howey test determines whether a transaction qualifies as an "investment contract" (security). Four prongs:
1. An investment of money
2. In a common enterprise
3. With an expectation of profit
4. Derived from the efforts of others

Marketing must avoid language that strengthens ANY prong.

### Writing Guide

| Howey Prong | Language to AVOID | Language to USE |
|-------------|-------------------|-----------------|
| Prong 1 (investment of money) | "invest," "deposit," "put money into" | "participate," "interact with," "supply" |
| Prong 2 (common enterprise) | "pool," "fund," "our platform grows your..." | "protocol mechanics," "network-level" |
| Prong 3 (expectation of profit) | "earn," "returns," "yield," "passive income," "profit" | "receive variable rewards," "network compensation" |
| Prong 4 (efforts of others) | "our team works to maximize...," "we manage..." | "protocol-determined," "algorithmically calculated" |

### Review Checklist Addition (crypto-specific)

Add these checks to the base review checklist:
- [ ] Could this trigger Howey Test concerns (profit from others' efforts)?
- [ ] No price predictions or implied price appreciation?
- [ ] Non-custodial nature stated where applicable?
- [ ] Staking/lending framed as network participation, not investment?
- [ ] All rates described as variable?

## 5. Context-Dependent Review Triggers

These words require human review to determine if usage is compliant:

| Word/Phrase | When OK | When NOT OK |
|-------------|---------|-------------|
| "APY" / "APR" | Reporting current rate with disclaimer | "High APY available!" or comparing favorably |
| "TVL" | Factual reporting with number | Celebration: "$1M TVL reached! LFG!" |
| "alpha" | Ecosystem analysis | Implying insider info about own token |
| "yield farming" | Educational: "What is yield farming?" | Promotional: "Farm yields on {COMPANY_NAME}" |
| "stake" / "staking" | Educational: "How network validation works" | Promotional: "Stake and earn rewards" |
| "rewards" | Factual: "Participants receive variable rewards" | Promotional: "Huge rewards for staking" |
| "opportunity" | Generic: "An opportunity to learn about DeFi" | Financial: "Don't miss this investment opportunity" |
| "bullish" / "bearish" | Market commentary | Price prediction tied to own token |
| "undervalued" | NEVER for own token | General market education only |
| "gem" / "hidden gem" | NEVER for own token or products | General ecosystem commentary only |

## 6. Competitor Mention Rules

- Never disparage competitors by name
- Never make unverifiable claims about competitor products
- Use only publicly available, verifiable data when comparing
- Frame strengths on own merits, not by attacking others
- All competitor mentions require Tier 1 human review
- Direct comparison tables: verifiable metrics only. No subjective language ("better," "faster," "superior")
