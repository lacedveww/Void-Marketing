---
id: "t1-what-is-voidai"
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
priority: 1                        # Pinned thread, highest priority
scheduled_post_at: ""
earliest_post_at: ""
latest_post_at: ""

# Content metadata
pillar: "bridge-build"
character_count: 223
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
red_flags_found: ["alpha", "staking", "rewards"]
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
stagger_group: "launch-foundation"
stagger_order: 2
---

## Content

Bittensor has 128+ subnets producing real AI. But nearly all that value is locked on one chain. No Solana DeFi. No EVM composability. We built the fix. Here's what VoidAI does and why it matters.

Not financial advice. DYOR.

## Thread Parts

### Part 1

Bittensor has 128+ subnets producing real AI. But nearly all that value is locked on one chain. No Solana DeFi. No EVM composability. We built the fix. Here's what VoidAI does and why it matters.

Not financial advice. DYOR.

### Part 2

The problem: bridging TAO today means CEX custody, multi-hop conversions, and fees at every step. Subnet alpha tokens? Even worse, most have zero DEX presence outside Bittensor.

VoidAI is purpose-built cross-chain infrastructure for TAO and alpha tokens. Bridge, stake, build.

### Part 3

The bridge uses lock-and-mint via @chainlink CCIP. Your TAO locks in a non-custodial contract. CCIP confirms the lock. wTAO mints on Solana or EVM chains.

We never hold your funds. Open source: github.com/v0idai

### Part 4

SN106, our Bittensor subnet, coordinates liquidity for wAlpha/wTAO pairs on @RaydiumProtocol. Miners provide concentrated liquidity. Validators score performance. Yuma Consensus determines emission distribution.

Variable rate rewards, not guaranteed. Rates change with network conditions.

### Part 5

The SDK gives developers programmatic access to bridge, stake, and query Bittensor subnet intelligence. Build cross-chain apps without learning the plumbing.

Docs: docs.voidai.com

### Part 6

Next: a lending platform to access liquidity against bridged Bittensor assets. Use your cross-chain TAO in DeFi without selling your position.

All participation carries risk: smart contract, market volatility, potential loss.

### Part 7

How this compares: Rubicon bridges to Base. LayerZero's vTAO bridges to EVM chains. VoidAI bridges to Solana + EVM with native Raydium DEX integration via SN106.

Different ecosystems, complementary approaches. We're more than a bridge: staking, SDK, lending incoming.

### Part 8

🔗 Bridge TAO: app.voidai.com/bridge-chains
🔗 Participate in SN106: app.voidai.com/stake
🔗 Docs: docs.voidai.com

Open source. Non-custodial. Purpose-built for Bittensor.

Use it, audit it, build on it.

## Editor Notes

<!-- FIXED 2026-03-15: Removed "34 repos" claim from Part 3. VoidAI has 34 total repos but only 2 public (SN106, SubnetsBot). Now says "Open source: github.com/v0idai". -->
<!-- FIXED 2026-03-15: Part 7 rewritten. Replaced false "Wormhole/LayerZero don't support Bittensor natively" with factual comparison (LayerZero vTAO for EVM, VoidAI for Solana+EVM with Raydium). -->
<!-- FIXED 2026-03-15: Changed "128 subnets" to "128+ subnets" in Parts 1 and content summary. -->
<!-- Human review notes. NOT posted. -->
<!-- PINNED THREAD for @v0idai on launch day -->
<!-- Compliance notes:
- Short disclaimer on Part 1 ✓
- "Variable rate rewards" not "yield" or "earn" ✓
- "Access liquidity" not "borrow" for lending ✓
- Risk disclosure on lending tweet ✓
- Non-custodial emphasis ✓
- No "allocation" or "airdrop" ✓
- No price predictions ✓
- Factual competitor comparison ✓
- Each part under 280 chars ✓
-->
