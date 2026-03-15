# Anchor Metrics: VoidAI

## Anchor Metrics

These are the key numbers to reference across all content. Pull latest data when generating content.

| # | Metric | Current Value | Last Updated | Data Source |
|---|--------|---------------|-------------|-------------|
| 1 | Total value bridged (cumulative) | Not publicly indexed | 2026-03-13 | Not found on DefiLlama or public dashboards. Priority: build tracking. |
| 2 | SN106 mindshare rank | #5 at 2.01% | 2025-09 | Altcoin Buzz (Sep 2025). Check taostats.io/subnets for current. |
| 3 | Unique wallets served | Not publicly indexed | 2026-03-13 | Needs on-chain analytics setup. |
| 4 | Bridge uptime | Not publicly tracked | 2026-03-13 | Needs monitoring infrastructure. |
| 5 | Chains supported | 4 (Bittensor, Solana, Ethereum, Base) | 2026-03-13 | Product data. Track additions. |

## Market Context Metrics: Bittensor Ecosystem

| Metric | Value | Last Updated | Source |
|--------|-------|-------------|--------|
| TAO Price | $221.74 | 2026-03 | CoinMarketCap |
| TAO Market Cap | $2.39B | 2026-03 | CoinMarketCap |
| CMC Rank | #36 | 2026-03 | CoinMarketCap |
| 24h Trading Volume | $231.3M | 2026-03 | CoinMarketCap |
| Circulating Supply | 10,757,669 TAO | 2026-03 | CoinMarketCap |
| Max Supply | 21,000,000 TAO (fixed, Bitcoin-like) | -- | Protocol spec |
| % of Max Supply Circulating | ~51% | 2026-03 | Calculated |
| Fully Diluted Valuation | $4.90B | 2026-03 | CoinMarketCap |
| % TAO Staked | ~68% | 2026-03 | CaptainAltcoin / Taostats |
| Active Subnets | ~128-129 | 2026-03 | Taostats (cap at 128, competitive replacement) |
| TAO AI Coin Rank | 2nd most mentioned AI coin | 2026-03 | LunarCrush |

### Halving Data

| Metric | Value |
|--------|-------|
| First Halving Date | December 15, 2025 |
| Pre-Halving Daily Emissions | 7,200 TAO/day |
| Post-Halving Daily Emissions | 3,600 TAO/day |
| Pre-Halving Inflation Rate | ~26% |
| Post-Halving Inflation Rate | ~13% |
| Halving Trigger | Supply-based (10.5M TAO threshold), not time-based |
| Next Halving | When 15,750,000 TAO issued (~2029 estimated) |

### Network Growth (Q2 2025 Reference)

| Metric | Growth |
|--------|--------|
| Subnet Growth | +50% |
| Miner Growth | +16% |
| Non-Zero Wallets | +28% |
| Staked TAO | +21.5% |

## Product-Specific Metrics

### Bridge

| Metric | Value | Notes |
|--------|-------|-------|
| Total Value Bridged | Not publicly indexed | Not on DefiLlama. Self-report or build dashboard. |
| Chains Supported | 4 | Bittensor, Solana, Ethereum, Base |
| Bridge Mechanism | Lock-and-mint / Burn-and-release | TAO locked on Bittensor, wTAO minted on destination |
| wTAO:TAO Rate | 1:1 fixed peg | |
| Security | Chainlink CCIP (V2), audited Solana bridge (V1) | Migrating all to CCIP |
| Unique Wallets Served | Not publicly indexed | Track via on-chain analytics |
| DeFi Integrations | Raydium CLMM, Uniswap, Aerodrome | + lending protocols (upcoming) |
| Audit Status | Solana bridge audited; Ethereum contracts audit pending | Per Systango article |

### Bridge Positioning

- VoidAI claims "first trust-less bridge connecting Bittensor and Solana"
- VoidAI claims "first bridge connecting Bittensor and Ethereum"
- Competitor: Tensorplex Bridge (different approach), TaoFi (USDC bridge via Hyperlane)
- Differentiator: Chainlink CCIP for cross-chain security, concentrated liquidity integration

### SN106 Subnet

| Metric | Value | Source |
|--------|-------|--------|
| Subnet Number | 106 (NETUID 106) | Taostats |
| Subnet Name | Liquidity Provisioning / VoidAI | Taostats |
| Mindshare Rank | #5 | Altcoin Buzz (Sep 2025) |
| Mindshare Percentage | 2.01% | Altcoin Buzz (Sep 2025) |
| Subnet Type | Liquidity provisioning (miners = LPs) | VoidAI docs |
| Key Mechanism | Concentrated liquidity on Raydium CLMM | VoidAI docs |
| Registration Date | ~May 2025 | On-chain data |

## Token Metrics: VOID (SN106 Alpha Token)

| Metric | Value | Source |
|--------|-------|--------|
| Token Name | VoidAI / Liquidity Provisioning | CoinGecko |
| Ticker | SN106 | CoinGecko |
| Type | Bittensor subnet alpha token | -- |
| Current Price | $1.01 | CoinGecko (Mar 2026) |
| 24h Price Change | -4.60% | CoinGecko |
| 7d Price Change | +5.10% | CoinGecko |
| 24h Trading Volume | $152,996 | CoinGecko |
| Circulating Supply | ~3,000,000 SN106 | CoinGecko |
| Market Cap | $3,020,240 | CoinGecko |
| All-Time High | $7.91 | CoinGecko |
| All-Time Low | $0.6922 | CoinGecko |
| Primary Trading Pair | SN106/SN0 | Subnet Tokens exchange |
| CoinGecko Listed | Yes (as "Liquidity Provisioning") | CoinGecko |

## Primary Data Sources

- **Taostats**: https://taostats.io/subnets/106/chart -- SN106 subnet data
- **CoinGecko**: https://www.coingecko.com/en/coins/liquidity-provisioning -- SN106 token price
- **CoinMarketCap**: https://coinmarketcap.com/currencies/bittensor/ -- TAO price and market data
- **SubnetAlpha**: https://subnetalpha.ai/subnet/liquidityprovisioning/ -- Subnet analytics
- **Backprop Finance**: https://backprop.finance/dtao/subnets/106-voidai-liquidity-provisioning -- dTAO subnet data
- **DefiLlama**: https://defillama.com/bridges -- Bridge volume rankings (VoidAI not yet indexed)
- **TaoMarketCap**: https://taomarketcap.com/ -- Bittensor ecosystem overview

## Data Freshness Caveats

1. **Mindshare rank (#5 at 2.01%)**: From September 2025 Altcoin Buzz article. May have shifted. Check taostats.io for current position.
2. **TAO price and market data**: Snapshot from March 2026 search results. Prices change continuously.
3. **SN106 token price ($1.01)**: Point-in-time from CoinGecko. Check live at coingecko.com/en/coins/liquidity-provisioning.
4. **Bridge volume data**: Not found in any public indexer (DefiLlama, Dune). VoidAI may need to self-report or build a dashboard.
5. **Unique wallets**: Not publicly tracked. Consider building an on-chain analytics dashboard or Dune query.
6. **Subnet count (128-129)**: Cap is 128 with competitive replacement. Exact number fluctuates.
7. **Post-halving emission data**: Verified across multiple sources. Halving occurred December 15, 2025.

## Metrics Update Cadence

| Category | Update Frequency |
|----------|-----------------|
| Anchor metrics (bridge volume, wallets, uptime) | Weekly (when data available) |
| Market context (TAO price, ecosystem) | Weekly |
| Token data (SN106 price, volume) | Weekly |
| Mindshare rank | Weekly via taostats.io |

---

## Changelog

| Date | Change | Approved by |
|------|--------|-------------|
| 2026-03-13 | Initial metrics baseline created from research/metrics-baseline.md | Vew |
