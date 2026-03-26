# Content Pillars: VoidAI

## Pillar Definitions

| Pillar | Weight | Content Types |
|--------|--------|---------------|
| Lending & DeFi Banking | 30% | Lending platform development, collateral models, LTV ratios, borrow/supply rates, utilization metrics, TVL growth, liquidation thresholds, DeFi banking education |
| Bridge & Infrastructure | 20% | Bridge volume metrics, new chain integrations, SDK releases, staking updates, shipped product maintenance |
| Ecosystem Intelligence | 25% | Bittensor network analysis, dTAO insights, emissions trends, cross-chain DeFi commentary, lending ecosystem coverage |
| Alpha & Education | 20% | Technical deep-dives, lending tutorials, staking guides, LP tutorials, yield comparisons, DeFi banking explainers |
| Community & Culture | 5% | Community milestones, partner celebrations, Spaces, AMAs |

## Audience Personas

VoidAI's content must speak to specific audiences, not a generic "crypto audience." Each persona has different motivations, knowledge levels, and content needs. Map every piece of content to at least one primary persona.

### Persona 1: Validators & Miners (SN106 Participants)

- **Who they are**: Technical participants running SN106 infrastructure. Validators stake TAO and evaluate miner performance. Miners provide concentrated liquidity on Raydium CLMM pools.
- **What they care about**: Emissions, incentive mechanisms, subnet performance, APY, technical requirements, uptime, hardware costs
- **Knowledge level**: High. They understand Bittensor architecture, yuma consensus, metagraph mechanics
- **Content needs**: Technical updates on SN106 mechanics, emissions data, miner/validator guides, infrastructure requirements, performance benchmarks
- **Primary pillars**: Bridge & Build (60%), Alpha & Education (30%), Ecosystem Intelligence (10%)
- **Where they are**: X, Discord, Bittensor forums
- **Tone**: Builder-to-builder. Skip the basics. Lead with data and technical specifics.

### Persona 2: TAO Holders & Delegators

- **Who they are**: People who hold TAO and delegate/stake to subnets including SN106. May not run infrastructure themselves but actively manage their TAO allocation across subnets.
- **What they care about**: Staking returns, subnet selection, risk assessment, dTAO dynamics, which subnets are gaining/losing mindshare, how to move TAO across chains
- **Knowledge level**: Medium-high. Understand dTAO and staking basics but may not know LP mechanics deeply
- **Content needs**: Staking guides, yield comparisons, SN106 performance updates, bridge tutorials, risk analysis
- **Primary pillars**: Alpha & Education (40%), Bridge & Build (30%), Ecosystem Intelligence (30%)
- **Where they are**: X, Discord, Taostats
- **Tone**: Informative, data-backed. Explain the "so what" for their TAO allocation.

### Persona 3: DeFi Power Users & Yield Farmers

- **Who they are**: Cross-chain DeFi participants who want to use TAO in Solana/Ethereum/Base DeFi. May or may not know Bittensor well but know DeFi deeply.
- **What they care about**: TVL, APY, slippage, liquidity depth, bridge security, new yield opportunities, impermanent loss, LP strategies
- **Knowledge level**: High in DeFi, variable on Bittensor. They speak in TVL and APY, not emissions and metagraphs.
- **Content needs**: Bridge tutorials, yield opportunity analysis, LP strategy guides, security model explainers, cross-chain liquidity updates
- **Primary pillars**: Alpha & Education (40%), Bridge & Build (35%), Ecosystem Intelligence (25%)
- **Where they are**: X (DeFi Twitter), Discord, DeFi dashboards
- **Tone**: DeFi-native language. Lead with yield data and protocol comparisons. Translate Bittensor concepts into DeFi terms.

### Persona 4: Degens & Speculators

- **Who they are**: High-risk-tolerance crypto participants. Trade subnet alpha tokens. Follow momentum and narrative plays. May be interested in SN106 token dynamics.
- **What they care about**: Alpha, narrative momentum, what's moving, subnet token performance, mindshare trends, "what to ape next"
- **Knowledge level**: Variable. Some are sophisticated traders, others follow hype. All move fast.
- **Content needs**: Mindshare updates, narrative analysis, ecosystem momentum signals, milestone celebrations, community energy
- **Primary pillars**: Ecosystem Intelligence (40%), Community & Culture (30%), Bridge & Build (20%), Alpha & Education (10%)
- **Where they are**: X (Crypto Twitter), Telegram, meme channels
- **Tone**: Fast, punchy, data-forward. Do NOT pander with price hype. Earn their attention with alpha they can't get elsewhere. Route most degen-friendly content to satellite accounts, not @v0idai.

### Persona 5: Builders & Developers

- **Who they are**: Developers integrating VoidAI SDK, building on Bittensor, or exploring cross-chain infrastructure for their own projects.
- **What they care about**: API documentation, SDK capabilities, integration guides, architecture decisions, security model, code examples
- **Knowledge level**: High technical. They want specifics, not hand-waving.
- **Content needs**: SDK releases, API updates, architecture deep-dives, developer tutorials, integration case studies, GitHub activity
- **Primary pillars**: Bridge & Build (50%), Alpha & Education (40%), Ecosystem Intelligence (10%)
- **Where they are**: X (Dev Twitter), GitHub, Discord, docs.voidai.com
- **Tone**: Technical, concise, reference-oriented. Link to docs. Show code snippets. Respect their time.

### Persona-to-Account Routing

| Persona | Primary Account | Secondary Accounts |
|---------|----------------|-------------------|
| Validators & Miners | @v0idai (main) | Bittensor Ecosystem satellite, Daily/Info |
| TAO Holders & Delegators | @v0idai (main) | Daily/Info, Bittensor Ecosystem, DeFi satellite |
| DeFi Power Users | DeFi / Cross-Chain satellite | @v0idai (main), Daily/Info |
| Degens & Speculators | Bittensor Ecosystem satellite | Daily/Info, DeFi satellite |
| Builders & Developers | @v0idai (main) | Daily/Info |

## Pillar Descriptions

### Lending & DeFi Banking (30%)

The new core pillar. VoidAI's current primary focus. Everything related to the lending platform: development updates, architecture decisions, market analysis, educational content about DeFi lending. This pillar positions VoidAI as a serious DeFi infrastructure builder, not just a bridge.

**Best formats**: Development update threads, lending market analysis, collateral model explainers, DeFi banking comparison tables
**Key topics**: Lending platform development milestones, collateral models (TAO, wTAO, subnet alpha tokens), LTV ratios, liquidation thresholds, borrow/supply rates, utilization rates, TVL growth, security audit progress, lending competitor analysis (Sturdy SN10, BitQuant SN15, Aave, Compound, Morpho)

### Bridge & Infrastructure (20%)

Shipped products that prove execution. Bridge and staking are the foundation VoidAI has already delivered. Content here maintains awareness of live products and reinforces the "we ship" narrative.

**Best formats**: Product update threads, data cards, announcement tweets, SDK release notes
**Key topics**: Bridge volume milestones, new chain integrations, Chainlink CCIP updates, SDK releases, security audits, staking performance, uptime metrics

### Ecosystem Intelligence (25%)

Positioning VoidAI as an informed participant in the Bittensor ecosystem, not just a product. Analysis of what is happening across subnets, dTAO dynamics, emissions trends, and cross-chain capital flows.

**Best formats**: Data threads, subnet spotlights, emissions analysis posts, weekly ecosystem recaps
**Key topics**: Subnet rankings and mindshare, dTAO flow analysis, cross-chain liquidity trends, Bittensor network upgrades, halving impact analysis
**High-priority content topics (March 2026):**
- Covenant-72B: largest decentralized LLM training run (72B params, ~1.1T tokens on SN3). See `research/covenant-72b-decentralized-training.md`
- On-device AI trend (Qwen3.5 35B on iPhone, Perplexity local AI) and narrative synergy with Bittensor's decentralized approach. See `research/on-device-ai-decentralized-narrative.md`

### Alpha & Education (20%)

Making Bittensor DeFi and lending accessible. Technical deep-dives for power users and step-by-step guides for newcomers. Shifted toward lending education as the platform approaches launch. The content that earns trust by teaching without gatekeeping.

**Best formats**: Tutorial threads, blog posts, explainer videos, comparison tables, step-by-step guides
**Key topics**: How to bridge TAO, staking mechanics, LP strategies, protocol architecture explainers, DeFi concept education, lending 101 (what is LTV, collateral, liquidation), how VoidAI lending will work, DeFi banking comparisons

### Community & Culture (5%)

Minimal touch. Community celebrations and engagement. With no dedicated meme account, this pillar is distributed lightly across all accounts. Keep it organic and infrequent.

**Best formats**: Polls, community milestone celebrations, Spaces/AMAs
**Key topics**: Community milestones, partner celebrations, Bittensor culture moments

## Pillar-to-Account Mapping

| Account | Lending & DeFi Banking | Bridge & Infrastructure | Ecosystem Intel | Alpha & Education | Community & Culture |
|---------|:-----------:|:-----------:|:-----------:|:-----------:|:-----------:|
| Main (@v0idai) | 30% | 20% | 25% | 20% | 5% |
| Daily/Informational | 35% | 30% | 20% | 10% | 5% |
| Bittensor Ecosystem | 15% | 10% | 50% | 20% | 5% |
| DeFi / Cross-Chain | 30% | 15% | 25% | 25% | 5% |

## Content Experimentation by Pillar

Each pillar should run at least one A/B experiment per week. The content experimentation loop (see `automations/pipeline-architecture.md` Section 13) defines the full process. Here are pillar-specific experiment priorities:

| Pillar | What to Experiment First | Why |
|--------|-------------------------|-----|
| Lending & DeFi Banking | Development update format: thread vs. single tweet | Lending updates are new; find what resonates |
| Bridge & Infrastructure | Data specificity: vague metrics vs. exact numbers in hooks | Builder credibility depends on perceived precision |
| Ecosystem Intelligence | Thread vs. single tweet for subnet analysis | Some analysis needs depth, but singles may get more impressions |
| Alpha & Education | Hook style: question ("How does TAO lending work?") vs. data lead ("Borrow rates at X% across DeFi") | Determines whether education or alpha framing resonates more |
| Community & Culture | Poll frequency and topics | With reduced weight (5%), find the highest-value engagement formats |

Track results in `brand/voice-learnings.md`. After 4+ data points per variant, declare a winner and update the pillar's "Best formats" guidance above.

## Anchor Metrics (Repeat Across All Content)

Always reference these numbers when available (pull latest data from `companies/voidai/metrics.md`):

1. Total value bridged (cumulative)
2. SN106 mindshare rank (e.g., #5 at 2.01%)
3. Unique wallets served
4. Bridge uptime (reliability signal)
5. Chains supported (Bittensor, Solana, Ethereum, Base, + expanding)
6. Lending TVL (once live)
7. Borrow/supply utilization rates (once live)
8. Lending development milestones completed

---

## Changelog

| Date | Change | Approved by |
|------|--------|-------------|
| 2026-03-13 | Initial pillars config extracted from CLAUDE.md | Vew |
| 2026-03-22 | Added 5 audience personas (validators/miners, TAO holders/delegators, DeFi users, degens, builders) with pillar mapping and account routing per X Playbook tip 7 | Vew |
| 2026-03-22 | Added high-priority content topics to Ecosystem Intelligence (Covenant-72B, on-device AI), added Content Experimentation by Pillar section with per-pillar A/B test priorities | Claude Code |
| 2026-03-25 | Lending pivot: reweighted pillars (Lending 30%, Bridge 20%, Ecosystem 25%, Alpha 20%, Culture 5%). Added Lending & DeFi Banking pillar. Updated pillar-to-account mapping for 4 accounts. Added lending anchor metrics. | Vew |
