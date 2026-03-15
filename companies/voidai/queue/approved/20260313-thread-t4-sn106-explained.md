---
id: "t4-sn106-explained"
created_at: "2026-03-13"
updated_at: "2026-03-15"

# Status
status: "approved"
previous_status: "review"

# Target
platform: "x"
account: "v0idai"
content_type: "thread"

# Scheduling
priority: 3
scheduled_post_at: ""
earliest_post_at: ""
latest_post_at: ""

# Content metadata
pillar: "bridge-build"
character_count: 214
has_media: false
thread_count: 8

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
red_flags_found: ["alpha"]
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
stagger_order: 2
---

## Content

Most Bittensor subnets run inference, training, or storage. SN106 does something different: it coordinates on-chain liquidity for TAO across DeFi. Here's how the liquidity engine works.

Not financial advice. DYOR.

## Thread Parts

### Part 1

Most Bittensor subnets run inference, training, or storage. SN106 does something different: it coordinates on-chain liquidity for TAO across DeFi. Here's how the liquidity engine works.

Not financial advice. DYOR.

### Part 2

SN106: a liquidity provisioning subnet on Bittensor. Registered ~May 2025. Miners act as LPs on @RaydiumProtocol CLMM pools for wTAO and wAlpha pairs.

Not a trading bot. Not a yield aggregator. An incentive coordination layer.

### Part 3

How it works: Miners deploy concentrated liquidity on Raydium. Validators score LP performance: range selection, capital efficiency, uptime.

Yuma Consensus aggregates scores. Emissions are distributed based on validator assessments.

### Part 4

Why concentrated liquidity? Standard AMM pools spread liquidity across all prices. CLMM lets LPs focus capital in active trading ranges. Tighter ranges = more capital efficiency = deeper liquidity where it matters.

SN106 miners are scored on how well they execute this.

### Part 5

Emission flow: 3,600 $TAO/day across all subnets (post-halving). Each subnet's share depends on staked TAO under dTAO. SN106 converts emissions into liquidity coordination.

Variable rate. Changes with network conditions. Not guaranteed.

### Part 6

SN106: top-5 Kaito mindshare among Bittensor subnets as of September 2025. Listed on CoinGecko. Primary pair: SN106/SN0. Check current token metrics on CoinGecko.

128+ subnets competing for emissions. Perform or get replaced.

### Part 7

Why it matters: alpha tokens need liquid markets. Without liquidity, subnet tokens can't be priced or traded efficiently. dTAO's signaling mechanism breaks down.

SN106 bootstraps and maintains that liquidity on Solana. Infrastructure, not speculation.

### Part 8

🔗 Participate: app.voidai.com/stake
🔗 Bridge TAO: app.voidai.com/bridge-chains
🔗 Docs: docs.voidai.com

Open source: github.com/v0idai. Non-custodial. Risks include smart contract vulnerabilities, impermanent loss, and volatility. DYOR.

## Editor Notes

<!-- FIXED 2026-03-15: Removed "34 open-source repos" claim from Part 8. VoidAI has 34 total repos but only 2 public (SN106, SubnetsBot). Now says "Open source: github.com/v0idai". -->
<!-- FIXED 2026-03-15: Part 6 mindshare now qualified as "top-5 as of September 2025". Removed specific 2.01%, token price ($1.01), cap ($3.02M), and volume ($153K). Directs to CoinGecko for current data. Changed "128 subnets" to "128+ subnets". -->
<!-- Human review notes. NOT posted. -->
<!-- COMPLIANCE NOTES:
- Short disclaimer on Part 1 ✓
- "Variable rate" not "yield" or "APY" for SN106 rewards ✓
- "Participate" not "invest" or "stake" as investment ✓
- "Not guaranteed" explicit in Part 5 ✓
- Risk disclosure on final tweet (smart contract, IL, volatility) ✓
- Non-custodial ✓
- No price predictions ✓
- Each part under 280 chars ✓
- Real metrics from baseline: mindshare #5/2.01%, token $1.01, cap $3.02M, volume $153K ✓
- CLMM mechanics explained accurately ✓
- Post-halving emissions figure (3,600 TAO/day) ✓
-->
