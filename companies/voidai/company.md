# Company Identity: VoidAI

## Core Identity

- **Company name**: VoidAI
- **One-liner**: "The economic infrastructure layer that connects Bittensor's intelligence to the world's liquidity."
- **Industry**: Crypto / DeFi / Bittensor
- **Org**: github.com/v0idai
- **Repo count**: 34 total (2 public: SN106, SubnetsBot; 32 private)

## Products

| Product | Status | URL | Description |
|---------|--------|-----|-------------|
| Cross-chain Bridge | Live | app.voidai.com/bridge-chains | Bittensor <> Solana/EVM bridge via Chainlink CCIP |
| SN106 Staking | Live | app.voidai.com/stake | Subnet 106 staking and liquidity provisioning |
| SDK | Live | @voidaisdk/bridge-sdk | Developer SDK for bridge integrations |
| Lending Platform | Upcoming (target: late April 2026) | TBD | DeFi lending for TAO ecosystem |
| Documentation | Live | docs.voidai.com | Developer and user documentation |

## Token / Asset

- **Token name**: VoidAI / Liquidity Provisioning
- **Token ticker**: VOID (listed as SN106)
- **Token type**: Bittensor subnet alpha token (SN106)

## Architecture & Security

- Non-custodial: we never hold user funds
- Bridge mechanism: Lock-and-mint / Burn-and-release (TAO locked on Bittensor, wTAO minted on destination)
- wTAO:TAO rate: 1:1 fixed peg
- Security: Chainlink CCIP (V2), audited Solana bridge (V1), migrating all to CCIP
- Chains supported: Bittensor, Solana, Ethereum, Base
- DeFi integrations: Raydium CLMM, Uniswap, Aerodrome, plus lending protocols (upcoming)

## Competitor Landscape

- **Primary competitor**: Project Rubicon (@gtaoventures, Base/Coinbase pathway). We differentiate with Solana DeFi access, multi-chain bridge, lending platform (upcoming), and non-custodial architecture.
- **Category competitors**: Tensorplex Bridge (different approach), TaoFi (USDC bridge via Hyperlane), Wormhole, LayerZero, Axelar (general-purpose bridges)

## Key People

| Name | Role | Public Handles |
|------|------|---------------|
| Hansel Melo | Founder | @v0idai (X) |
| Vew | Marketing Lead | -- |

## Project Context

- **Marketing lead**: Vew (sole marketing lead, AI-first automation approach)
- **Tools**: Claude Max, Google AI Pro, Canva, Figma, Loom, Screen Studio, DGX Spark
- **Strategy**: Build > Test > Soft Launch > Deploy (nothing goes public until system tested)
- **Blog scope**: Posts on existing voidai.com only. NOT building/editing website.
- **SEO tools**: seomachine (off-page/strategic), Composio (on-page/technical)
- **Email/Leads**: Mautic (self-hosted)
- **Automation**: n8n (13 workflows planned)
- **AI Agents**: Hermes Agent (content orchestrator), ElizaOS (Web3 community bot)

---

## Changelog

| Date | Change | Approved by |
|------|--------|-------------|
| 2026-03-13 | Initial company config extracted from CLAUDE.md | Vew |
| 2026-03-13 | Added docs.voidai.com to product table (config audit remediation) | Vew |
