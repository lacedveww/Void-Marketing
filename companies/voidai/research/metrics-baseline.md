# VoidAI Metrics Baseline
**Date:** 2026-03-13

> **Data freshness note**: Metrics below are compiled from web search results as of March 13, 2026. Some data points come from search result summaries rather than live dashboards. For real-time data, check the primary sources linked in each section. A full Taostats API pull or dashboard scrape should be run to update these numbers.

---

## SN106 Metrics

| Metric | Value | Source |
|--------|-------|--------|
| Subnet Number | 106 (NETUID 106) | Taostats |
| Subnet Name | Liquidity Provisioning / VoidAI | Taostats |
| Mindshare Rank | #5 | Altcoin Buzz (Sep 2025) |
| Mindshare Percentage | 2.01% | Altcoin Buzz (Sep 2025) |
| SN106 Token Price | $1.01 | CoinGecko (March 2026) |
| 24h Price Change | -4.60% | CoinGecko |
| 7d Price Change | +5.10% | CoinGecko |
| 24h Trading Volume | $152,996 | CoinGecko |
| Circulating Supply | ~3,000,000 SN106 | CoinGecko |
| Market Cap | $3,020,240 | CoinGecko |
| All-Time High | $7.91 | CoinGecko |
| All-Time Low | $0.6922 | CoinGecko |
| Primary Trading Pair | SN106/SN0 | Subnet Tokens exchange |
| Registration Date | ~May 2025 | On-chain data |
| Subnet Type | Liquidity provisioning (miners = LPs) | VoidAI docs |
| Key Mechanism | Concentrated liquidity on Raydium CLMM | VoidAI docs |

### SN106 Positioning Among Top Subnets

Based on Altcoin Buzz's "Top 10 Bittensor Subnets by Mindshare" (September 2025):
- VoidAI (SN106) ranked #5 at 2.01% mindshare
- Notable peers: Chutes (SN64, serverless inference), Nineteen (SN19, low-latency inference), Targon (SN4, deterministic verification), OpenKaito (SN5, decentralized search)

> **Note**: Mindshare rankings are dynamic. Check taostats.io/subnets for current rankings. The #5 position is from September 2025 data.

---

## Bittensor Ecosystem Metrics

| Metric | Value | Source / Date |
|--------|-------|---------------|
| TAO Price | $221.74 | CoinMarketCap (March 2026) |
| Market Cap | $2.39B | CoinMarketCap |
| CMC Rank | #36 | CoinMarketCap |
| 24h Trading Volume | $231.3M | CoinMarketCap |
| Circulating Supply | 10,757,669 TAO | CoinMarketCap |
| Max Supply | 21,000,000 TAO | Fixed (Bitcoin-like) |
| % of Max Supply Circulating | ~51% | Calculated |
| Fully Diluted Valuation | $4.90B | CoinMarketCap |
| % TAO Staked | ~68% | CaptainAltcoin / Taostats |
| Active Subnets | ~128-129 | Taostats (cap at 128, competitive replacement) |
| Subnet Cap | 128 (with 4-month immunity for new subnets) | OpenTensor Foundation |

### Halving Event

| Metric | Value |
|--------|-------|
| First Halving Date | December 15, 2025 |
| Pre-Halving Daily Emissions | 7,200 TAO/day |
| Post-Halving Daily Emissions | 3,600 TAO/day |
| Pre-Halving Inflation Rate | ~26% |
| Post-Halving Inflation Rate | ~13% |
| Halving Trigger | Supply-based (10.5M TAO threshold), not time-based |
| Next Halving | When 15,750,000 TAO issued (~2029 estimated) |

### Dynamic TAO (dTAO)

- Full implementation rolling out in 2026
- Allows token holders to direct incentives toward highest-performing subnets
- Rewards smoothed over 30-day average
- Subnets that attract and retain more staked TAO receive larger share of emissions

### Network Growth (Q2 2025 Reference)

| Metric | Growth |
|--------|--------|
| Subnet Growth | +50% |
| Miner Growth | +16% |
| Non-Zero Wallets | +28% |
| Staked TAO | +21.5% |

### TAO as AI Coin

- $TAO ranks as the 2nd most mentioned AI coin (LunarCrush, March 2026)
- Mindshare breakdown: 45% Subnet Growth + Dev, 30% Positive Sentiment, 15% Tech + Innovation, 10% Volatility Concerns

---

## Bridge Metrics

| Metric | Value | Notes |
|--------|-------|-------|
| Total Value Bridged | Not publicly indexed | Not found on DefiLlama or public dashboards |
| Bridge Uptime | Not publicly tracked | No third-party monitoring found |
| Chains Supported | 4 | Bittensor, Solana, Ethereum, Base |
| Bridge Mechanism | Lock-and-mint / Burn-and-release | TAO locked on Bittensor, wTAO minted on destination |
| wTAO:TAO Rate | 1:1 | Fixed peg |
| Security | Chainlink CCIP (V2), audited Solana bridge (V1) | Migrating all to CCIP |
| Unique Wallets Served | Not publicly indexed | Track via on-chain analytics |
| Bridge DeFi Integrations | Raydium CLMM, Uniswap, Aerodrome | + lending protocols (upcoming) |
| Bridge Audit Status | Solana bridge audited; Ethereum contracts audit pending post-finalization | Per Systango article |

### Bridge Positioning

- VoidAI claims "first trust-less bridge connecting Bittensor and Solana"
- VoidAI claims "first bridge connecting Bittensor and Ethereum"
- Competitor: Tensorplex Bridge (different approach), TaoFi (USDC bridge via Hyperlane)
- VoidAI differentiator: Chainlink CCIP for cross-chain security, concentrated liquidity integration

---

## VOID Token Data (SN106 Alpha Token)

| Metric | Value |
|--------|-------|
| Token Name | VoidAI / Liquidity Provisioning |
| Ticker | SN106 |
| Type | Bittensor subnet alpha token |
| Current Price | $1.01 |
| Market Cap | $3.02M |
| All-Time High | $7.91 (87.2% below ATH) |
| All-Time Low | $0.6922 (45.8% above ATL) |
| Primary Venue | Subnet Tokens exchange (SN106/SN0 pair) |
| CoinGecko Listed | Yes (as "Liquidity Provisioning") |

---

## Notes

### Data Freshness Caveats

1. **Mindshare rank (#5 at 2.01%)**: From September 2025 Altcoin Buzz article. May have shifted. Check taostats.io for current position.
2. **TAO price and market data**: Snapshot from March 2026 search results. Prices change continuously.
3. **SN106 token price ($1.01)**: Point-in-time from CoinGecko. Check live at coingecko.com/en/coins/liquidity-provisioning.
4. **Bridge volume data**: Not found in any public indexer (DefiLlama, Dune). VoidAI may need to self-report or build a dashboard for this metric.
5. **Unique wallets**: Not publicly tracked. Consider building an on-chain analytics dashboard or Dune query.
6. **Subnet count (128-129)**: The cap is 128 with competitive replacement. The exact number fluctuates as low-performing subnets are replaced.
7. **Post-halving emission data**: Verified across multiple sources. The halving occurred December 15, 2025.

### Key Metrics to Track Going Forward

These are the anchor metrics from CLAUDE.md that should be updated regularly:

1. **Total value bridged (cumulative)** -- currently not publicly available. Priority: build tracking.
2. **SN106 mindshare rank** -- check taostats.io/subnets weekly.
3. **Unique wallets served** -- needs on-chain analytics setup.
4. **Bridge uptime** -- needs monitoring infrastructure.
5. **Chains supported** -- currently 4 (Bittensor, Solana, Ethereum, Base). Track additions.

### Primary Data Sources

- **Taostats**: https://taostats.io/subnets/106/chart -- SN106 subnet data
- **CoinGecko**: https://www.coingecko.com/en/coins/liquidity-provisioning -- SN106 token price
- **CoinMarketCap**: https://coinmarketcap.com/currencies/bittensor/ -- TAO price and market data
- **SubnetAlpha**: https://subnetalpha.ai/subnet/liquidityprovisioning/ -- Subnet analytics
- **Backprop Finance**: https://backprop.finance/dtao/subnets/106-voidai-liquidity-provisioning -- dTAO subnet data
- **DefiLlama**: https://defillama.com/bridges -- Bridge volume rankings (VoidAI not yet indexed)
- **TaoMarketCap**: https://taomarketcap.com/ -- Bittensor ecosystem overview
