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
| TAO Price | Check CoinGecko for live data | Rolling | CoinGecko, CoinMarketCap |
| TAO Market Cap | $2.77B (Mar 15, 2026 snapshot; check CoinGecko for live data) | 2026-03-15 | CoinGecko |
| CMC Rank | #36 | 2026-03 | CoinMarketCap |
| 24h Trading Volume | Check CoinGecko for live data | Rolling | CoinGecko, CoinMarketCap |
| Circulating Supply | 10,757,669 TAO | 2026-03 | CoinMarketCap |
| Max Supply | 21,000,000 TAO (fixed, Bitcoin-like) | -- | Protocol spec |
| % of Max Supply Circulating | ~51% | 2026-03 | Calculated |
| Fully Diluted Valuation | $4.90B | 2026-03 | CoinMarketCap |
| % TAO Staked | High staking participation rate (76.27% as of Mar 15, 2026; check Taostats for live data) | 2026-03-15 | Taostats |
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

### SN106 Automated Metrics (from collect-metrics.sh)

These fields are collected daily from the Taostats API and stored in `automations/data/daily-metrics-YYYY-MM-DD.json`.

| JSON Field | Description | Source |
|-----------|-------------|--------|
| `sn106.validators` | Total validator count | Taostats subnet endpoint |
| `sn106.active_validators` | Active validator count | Taostats subnet endpoint |
| `sn106.active_miners` | Active miner count | Taostats subnet endpoint |
| `sn106.active_keys` | Total registered keys (UIDs) | Taostats subnet endpoint |
| `sn106.max_neurons` | Max neuron slots | Taostats subnet endpoint |
| `sn106.emission_rao` | Current emission (rao) | Taostats subnet endpoint |
| `sn106.projected_emission_rao` | Projected emission (rao) | Taostats subnet endpoint |
| `sn106.tempo` | Subnet tempo (blocks per epoch) | Taostats subnet endpoint |
| `sn106.fee_rate` | Subnet fee rate (exchange rate proxy) | Taostats subnet endpoint |
| `sn106.registration_cost_rao` | Subnet registration cost (rao) | Taostats subnet endpoint |
| `sn106.neuron_registration_cost_rao` | Neuron registration cost (rao) | Taostats subnet endpoint |
| `sn106.net_flow_1_day_rao` | Net TAO flow, 1 day (rao) | Taostats subnet endpoint |
| `sn106.net_flow_7_days_rao` | Net TAO flow, 7 days (rao) | Taostats subnet endpoint |
| `sn106.net_flow_30_days_rao` | Net TAO flow, 30 days (rao) | Taostats subnet endpoint |
| `sn106.recycled_lifetime_rao` | Total TAO recycled lifetime (rao) | Taostats subnet endpoint |
| `sn106.recycled_24h_rao` | TAO recycled last 24h (rao) | Taostats subnet endpoint |
| `sn106.alpha_price_tao_estimate` | Alpha token price estimate (TAO) | Derived from fee_rate |
| `sn106.alpha_price_usd_estimate` | Alpha token price estimate (USD) | Derived from fee_rate * TAO price |
| `tao.price_usd` | TAO price in USD | Taostats price endpoint |
| `tao.price_change_24h_pct` | TAO 24h price change % | Taostats price endpoint |
| `tao.price_change_7d_pct` | TAO 7d price change % | Taostats price endpoint |
| `tao.price_change_30d_pct` | TAO 30d price change % | Taostats price endpoint |
| `tao.market_cap_usd` | TAO market cap (USD) | Taostats price endpoint |
| `tao.volume_24h_usd` | TAO 24h trading volume (USD) | Taostats price endpoint |
| `network.total_staked_rao` | Total TAO staked across network (rao) | Taostats stats endpoint |
| `network.total_subnets` | Total active subnets | Taostats stats endpoint |

**Note on alpha token price**: The Taostats API does not have a dedicated alpha/dTAO token price endpoint. The `fee_rate` field from the subnet endpoint is used as an exchange rate proxy. For precise token pricing, check CoinGecko (listed as "Liquidity Provisioning").

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

## Community Sentiment Tracking

Community expectations are a leading indicator. Sentiment shifts precede engagement drops. Track these signals proactively, especially around the lending platform launch (target: late April 2026).

### Sentiment Signals to Monitor

| Signal | Source | Frequency | Action Trigger |
|--------|--------|-----------|---------------|
| "wen lending" frequency | X mentions, Discord, Telegram | Daily | If mentions spike >3x weekly average, post a builder update with progress details |
| Negative sentiment ratio | X replies to @v0idai posts | Weekly | If >20% of replies are negative/critical (vs. baseline), investigate cause and address |
| Community questions about roadmap | Discord, X replies | Daily | If the same question appears 5+ times in a week, create a dedicated content piece answering it |
| Competitor comparison mentions | X search "VoidAI vs [competitor]" | Weekly | If comparisons increase, post differentiation content (see competitors.md frameworks) |
| "is VoidAI dead" or similar | X search, Discord | Daily | Immediate response needed. Post builder update within 24 hours showing active development |

### Lending Platform Launch Expectations Management

The lending platform (target: late April 2026) is the highest-expectation event on VoidAI's roadmap. Mismanaging expectations here could damage credibility significantly.

**Pre-launch (now through launch):**
- Use "late April" or "Q2 2026," never a specific date (see voice.md Deadline Communication Policy)
- Post regular builder updates showing lending development progress (1x/week minimum)
- Set realistic expectations about initial capabilities: which assets, which chains, initial limits
- Do NOT overpromise on launch-day features. Under-promise, over-deliver

**At launch:**
- Follow the Announcement Framing Guidelines in voice.md
- Be transparent about any limitations in v1 (limited assets, gradual rollout, caps)
- Monitor community feedback in real-time for the first 48 hours
- Have a response ready for: "why can't I do X?" where X is a feature planned for later phases

**Post-launch:**
- Track adoption metrics: unique users, TVL in lending, most-requested features
- Respond to community feedback within 24 hours
- Post a "Week 1" update thread with real data on lending usage

### Sentiment Health Baseline

| Metric | Healthy Range | Warning | Critical |
|--------|:------------:|:-------:|:--------:|
| Reply sentiment (% positive) | >60% | 40-60% | <40% |
| "Wen" question frequency | <5/week | 5-15/week | >15/week |
| Discord daily active users | Stable or growing | -10% WoW | -25% WoW |
| Unanswered community questions | <3 open | 3-10 open | >10 open |

## Content Performance Metrics (Feedback Loop)

These metrics are collected automatically by `collect-engagement.sh` (daily, 10PM ET) and stored in `automations/data/`. They feed directly into content generation prompts via `performance-summary.json`.

### Per-Post Engagement Tracking

| Metric | Source | Purpose |
|--------|--------|---------|
| Likes | OpenTweet API / X API | Core engagement signal |
| Retweets | OpenTweet API / X API | Amplification signal (shareable content) |
| Replies | OpenTweet API / X API | Conversation signal (engaging/provocative content) |
| Bookmarks | OpenTweet API / X API | Save-for-later signal (high-value content) |
| Views (impressions) | OpenTweet API / X API | Reach signal |
| Quotes | OpenTweet API / X API | Thought-leader signal (people building on your take) |
| Engagement rate | Calculated: (likes + RTs + replies + bookmarks + quotes) / views * 100 | Primary performance metric |

### Content Pillar Performance Comparison

Track per content pillar (from pillars.md) to identify which themes resonate:

| Pillar | Metrics to Track | Decision It Informs |
|--------|-----------------|-------------------|
| bridge-build | Avg engagement rate, total views, bookmark rate | Should we increase bridge content frequency? |
| ecosystem-intelligence | Avg engagement rate, reply count, quote count | Is ecosystem commentary driving conversation? |
| lending-teaser | Engagement rate, view count, click-through (UTM) | Is lending teaser generating anticipation? |
| community-growth | Reply rate, follower delta after posts | Is community content converting to followers? |
| subnet-alpha | Bookmark rate, view count | Is technical subnet content reaching builders? |

### Hook/Format Performance Tracking

Track which hooks and formats drive the best engagement to inform future content:

| Hook Type | Description | Tracked In |
|-----------|-------------|-----------|
| data-lead | Opens with a specific metric or data point | performance-summary.json `by_hook_type` |
| curiosity-gap | Opens with a question or teaser | performance-summary.json `by_hook_type` |
| milestone | Opens with an achievement or threshold crossed | performance-summary.json `by_hook_type` |
| news-commentary | Opens with a take on external news | performance-summary.json `by_hook_type` |
| builder-update | Opens with a shipping/building update | performance-summary.json `by_hook_type` |

| Format | Description | Tracked In |
|--------|-------------|-----------|
| single | Single tweet (max 280 chars) | performance-summary.json `by_content_type` |
| thread | Multi-tweet thread (5-7 tweets) | performance-summary.json `by_content_type` |
| data-card | Tweet with attached data visualization | performance-summary.json `by_content_type` |
| teaser | Product/feature teaser | performance-summary.json `by_content_type` |

### Conversion Metrics

Beyond engagement, track whether content drives action:

| Metric | Source | Status | Priority |
|--------|--------|--------|----------|
| UTM click-throughs | GA4 (requires setup on voidai.com) | NOT YET ACTIVE | HIGH |
| Bridge transactions post-tweet | Correlate bridge tx timestamps with tweet timestamps | NOT YET ACTIVE | MEDIUM |
| Follower growth delta | X Analytics or manual tracking | MANUAL | MEDIUM |
| Discord join rate | Discord server analytics | MANUAL | LOW |
| Email signups from UTM | Mautic (Phase 4) | NOT YET ACTIVE | LOW |

**Conversion tracking gap**: UTM parameters are defined in queue content but GA4 is not yet configured on voidai.com. This is the next infrastructure priority after the feedback loop is operational.

### Engagement Baselines

| Account | Target Engagement Rate | Source |
|---------|:----------------------:|--------|
| Main @v0idai | >1.29% | Existing performance data |
| Fanpage | >1.5% | Gen Z community average |
| Bittensor Ecosystem | >2.0% | Bittensor community average |

Performance alerts trigger when:
- Any post achieves >3x average engagement rate (flag as breakout performer)
- Average engagement drops >30% vs previous collection (flag for voice calibration)
- Any pillar drops below 50% of its baseline for 2+ consecutive weeks

## Metrics Update Cadence

| Category | Update Frequency |
|----------|-----------------|
| Anchor metrics (bridge volume, wallets, uptime) | Weekly (when data available) |
| Market context (TAO price, ecosystem) | Weekly |
| Token data (SN106 price, volume) | Weekly |
| Mindshare rank | Weekly via taostats.io |
| Community sentiment signals | Weekly (daily monitoring, weekly summary) |
| Content engagement (per-post) | Daily via collect-engagement.sh (10PM ET) |
| Content performance summary | Daily (auto-feeds into generation prompts) |
| Voice calibration (weekly summary) | Weekly via Friday 4PM ET cron job |
| Conversion tracking (UTM) | When GA4 is configured on voidai.com |

---

## Changelog

| Date | Change | Approved by |
|------|--------|-------------|
| 2026-03-13 | Initial metrics baseline created from research/metrics-baseline.md | Vew |
| 2026-03-22 | Added community sentiment tracking, lending platform expectations management, sentiment health baselines per X Playbook tips 10, 5 | Vew |
| 2026-03-22 | Added Content Performance Metrics section: per-post engagement tracking, pillar performance comparison, hook/format tracking, conversion metrics, engagement baselines. Feedback loop data from collect-engagement.sh. | Vew |
| 2026-03-25 | Added SN106 Automated Metrics table documenting all JSON fields from collect-metrics.sh. Resolved merge conflicts. | Vew |
