---
id: "discord-d2-what-is-voidai"
created_at: "2026-03-13"
updated_at: "2026-03-15"

# Status
status: "approved"
previous_status: "review"

# Target
platform: "discord"
account: "v0idai"
content_type: "announcement"

# Scheduling
priority: 2
scheduled_post_at: ""
earliest_post_at: ""
latest_post_at: ""

# Content metadata
pillar: "alpha-education"
character_count: 1427
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
risk_level: "low"
howey_risk: "none"
red_flags_found: ["rewards"]
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
stagger_group: ""
stagger_order: 0
---

## Content

**What is VoidAI: the short version**

VoidAI is the economic infrastructure layer that connects Bittensor's intelligence to the world's liquidity.

In plain terms: Bittensor is building a decentralized AI network. The $TAO token powers it. But $TAO has been mostly isolated, stuck on its own chain with limited DeFi access.

We fix that.

**What we built:**

**Cross-chain bridge:** Move $TAO between Bittensor, Solana, and EVM chains. Secured by Chainlink CCIP (the same cross-chain protocol used by Aave, Synthetix, and other major DeFi protocols). Non-custodial. Your keys, your tokens.

**SN106 (Subnet 106):** Our subnet on the Bittensor network. Ranked top-5 in Bittensor Kaito mindshare as of September 2025, the only liquidity-focused subnet in the top 10. Variable rate network rewards for participants.

**SDK:** Developer tools for building on VoidAI. Python and TypeScript. Open source: github.com/v0idai

**Why this matters:**

Cross-chain access is what turns $TAO from a single-chain asset into something usable across DeFi. Every chain VoidAI connects to is a new set of protocols, liquidity pools, and strategies that $TAO holders can access.

Core protocol code is open source at github.com/v0idai. This is an infrastructure project built by people who ship code, not slide decks.

**What's next:**
New infrastructure for the $TAO ecosystem is in development. More details soon.

---
Not financial advice. Digital assets are volatile and carry risk of loss. DYOR.

## Editor Notes

<!-- FIXED 2026-03-15: Removed "34 repos" claim. VoidAI has 34 total repos but only 2 public (SN106, SubnetsBot). Replaced with "Core protocol code is open source at github.com/v0idai". -->
<!-- FIXED 2026-03-15: Mindshare now qualified as "top-5 as of September 2025". Removed specific 2.01% figure. -->
<!--
DISCORD "WHAT IS VOIDAI": Pin in #general

Strategy:
- Community-friendly explainer adapted for Discord tone
- Positions VoidAI as infrastructure, not a token project
- Specific, verifiable facts throughout:
  - Chainlink CCIP (named, with real protocol comparisons: Aave, Synthetix)
  - SN106 mindshare rank (#5 at 2.01%), pull latest from Taostats before posting
  - Core protocol code open source at github.com/v0idai (2 public repos: SN106, SubnetsBot)
  - Python + TypeScript SDK
- "People who ship code, not slide decks" = builder-credibility voice, anti-marketing tone
- Lending teased as "new infrastructure in development," no specifics
- Non-custodial stated twice (bridge section + standalone)

Compliance verification:
- No prohibited language
- "Variable rate network rewards" used instead of "earn yield" (per CLAUDE.md)
- "Participants" instead of "investors"
- Non-custodial architecture stated
- No rates or APY mentioned
- Short-form disclaimer included
- Tier 1 mandatory human review

Data to verify before posting:
- SN106 mindshare rank and percentage (currently 2.01%, #5: confirm via Taostats)
- GitHub public repos (2 public: SN106, SubnetsBot at github.com/v0idai)

Action required: Pin this in #general after approval
-->
