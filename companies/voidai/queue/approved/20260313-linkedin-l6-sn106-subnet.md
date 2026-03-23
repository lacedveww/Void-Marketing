---
id: "l6-sn106-subnet"
created_at: "2026-03-13"
updated_at: "2026-03-15"

# Status
status: "approved"
previous_status: "review"

# Target
platform: "linkedin"
account: "v0idai"
content_type: "post"

# Scheduling
priority: 3
scheduled_post_at: ""
earliest_post_at: ""
latest_post_at: ""

# Content metadata
pillar: "bridge-build"
character_count: 2830
has_media: false
thread_count: 1

# Source
source_workflow: "manual"
generated_by: "claude"

# Compliance
review_tier: 1
compliance_passed: true
prohibited_language: "pass"
disclaimer_included: true
risk_level: "medium"
howey_risk: "none"
red_flags_found: ["alpha", "rewards"]
compliance_checked_at: "2026-03-14T02:57:46Z"

# Approval
requires_approval: true
reviewed_by: "vew"
reviewed_at: "2026-03-13"
review_notes: "Batch approved after 4-pass review pipeline (review agents + verification agents + challenger agents + voice audit)"
rejection_reason: ""

# Execution
posted_at: ""
post_id: ""
failure_reason: ""
dry_run: true

# Coordination
stagger_group: "content-stockpile"
stagger_order: 7
---

## Content

**SN106: Building a Liquidity Provisioning Subnet on Bittensor**

Most of Bittensor's 128+ subnets produce AI computation: inference, training, storage, search. SN106 does something structurally different: it coordinates on-chain liquidity provisioning for Bittensor tokens across DeFi.

**The Problem**

Under Dynamic TAO (dTAO), each subnet has its own alpha token directing network incentives. Most alpha tokens lack liquid trading markets. Without liquidity: inefficient pricing, high slippage, and the economic signaling dTAO relies on breaks down.

Illiquid alpha tokens weaken the entire dTAO mechanism. SN106 exists to solve this.

**How It Works**

SN106 turns liquidity provisioning into a Bittensor-native mining operation.

Miners deploy concentrated liquidity positions on Raydium CLMM pools for wTAO and wAlpha pairs on Solana. They select price ranges, rebalance as markets move, and optimize capital efficiency.

Validators score miner performance: range selection accuracy, capital utilization, position uptime, liquidity depth. Bittensor's yuma consensus aggregates scores into final rankings that determine emission distribution.

The incentive loop: Bittensor emits TAO to SN106 (post-halving: 3,600 TAO/day across all 128+ subnets, shares determined by staked TAO under dTAO). Better LPs receive more emissions. Market participants benefit from deeper liquidity.

**Why Concentrated Liquidity**

Standard AMMs spread liquidity uniformly across all prices. Capital focused in active price ranges provides dramatically more depth per dollar. For traders: lower slippage. SN106 miners compete to provide the most efficient positions. Bittensor's emissions distribute to top performers.

**Current Metrics**

- Only Bittensor subnet focused on coordinating on-chain liquidity provisioning
- Check live token metrics at app.voidai.com
- CoinGecko listed as "Liquidity Provisioning"

Point-in-time metrics. Outcomes are variable, not guaranteed.

**The VoidAI Stack**

Bridge (Chainlink CCIP) moves tokens cross-chain. SN106 ensures those tokens have liquid markets. SDK makes it programmable. Lending protocol (in development) adds another DeFi primitive. Each layer builds on the last.

Participate: app.voidai.com/stake
Bridge: app.voidai.com/bridge-chains
Docs: docs.voidai.com
Source: github.com/v0idai

#Bittensor #SN106 #DeFi

---
This content is for informational and educational purposes only and does not constitute financial, investment, legal, or tax advice. Digital assets carry significant risks including potential total loss. Network participation involves risks including smart contract vulnerabilities, impermanent loss, and market volatility. Rates are variable, not guaranteed. VoidAI does not custody user funds. Consult qualified advisors before making decisions.

## Editor Notes

<!-- FIXED 2026-03-15: Mindshare now qualified as "top-5 as of September 2025". Removed specific 2.01% figure. Changed "128 subnets" to "128+ subnets". -->
<!-- FIXED 2026-03-15: Replaced hardcoded SN106 token price/market cap/volume with generic "Check live token metrics at app.voidai.com". -->
<!-- FIXED 2026-03-15: Removed Kaito mindshare reference from Current Metrics. Replaced with factual positioning ("Only Bittensor subnet focused on coordinating on-chain liquidity provisioning"). Kaito reference consolidated to L1 only. -->
<!-- Human review notes. NOT posted. -->
<!-- COMPLIANCE NOTES:
- "Participate" not "invest" ✓
- "Variable, not guaranteed" for network outcomes ✓
- No "yield," "earn," "returns," "passive income" for VoidAI products ✓
- Impermanent loss disclosed ✓
- Disclaimer included ✓
- Non-custodial ✓
- No price predictions ✓
- Original metrics replaced with generic references to avoid stale data ✓
- Post-halving emissions (3,600 TAO/day) ✓
- Professional LinkedIn tone ✓
- Trimmed to post format (<3,000 chars) ✓
-->
