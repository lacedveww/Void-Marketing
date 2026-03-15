# Phase 2: Data Verification Report

**Date:** 2026-03-15
**Scope:** All 63 content items in `/companies/voidai/queue/approved/`
**Method:** Web search, URL fetch, cross-reference against metrics-baseline.md

---

## CRITICAL FINDINGS SUMMARY

### RED FLAGS (Publish-Blocking)

1. **GitHub repo count: WRONG.** Content claims "34 public repositories" across 18+ files. Actual count on github.com/v0idai: **2 repositories** (SN106 and SubnetsBot). This is a 17x overstatement and must be corrected before any content publishes.

2. **TAO price/market cap: STALE.** Content uses $221 / $2.39B. Current (March 15, 2026): ~$268-289 / ~$2.77-2.89B. CMC rank has moved from #36 to #30. All price-sensitive content needs refresh.

3. **Competitor claim about LayerZero: NOW FALSE.** Content states "Wormhole/LayerZero don't support Bittensor natively." LayerZero announced native Bittensor EVM integration and vTAO (liquid staked TAO) is live, bridging to 8+ chains. This claim is now factually incorrect.

4. **SN106 mindshare data: 6 MONTHS STALE.** The #5 at 2.01% data is from an Altcoin Buzz article dated September 2025. Content presents it as current. This is a ~6-month-old data point that may have changed significantly.

5. **Fetch.ai/Ocean merger description: PARTIALLY OUTDATED.** Content says FET "merged with SingularityNET and Ocean Protocol." Ocean Protocol withdrew from the ASI Alliance on October 9, 2025. The merger description is now inaccurate.

### AMBER FLAGS (Needs Refresh Before Posting)

6. **TAO staking percentage:** Content uses "68%". Current data shows 68% (CaptainAltcoin) vs 76.27% (Coinbase). The figure may be stale depending on calculation method.

7. **SN106 token price/cap/volume:** Content uses $1.01 / $3.02M / $153K. These are from CoinGecko as of early March 2026. Need live refresh before posting.

8. **24h trading volume:** Content uses $231.3M. Current volume appears significantly higher (~$320-468M). Stale.

9. **Lending timeline "~5 weeks":** Content created March 13, 2026. If posted later, the "5 weeks" figure needs updating relative to posting date.

10. **Halving date: December 14 or 15?** Content consistently says December 15, 2025. Some sources say December 14, 2025. The MEXC source says "December 14." Bittensor halving sites confirm it was supply-triggered, so exact date varies by source. Minor inconsistency but should be verified.

---

## DETAILED CLAIM VERIFICATION TABLE

### VoidAI Product Claims

| File(s) | Claim | Current Value | Status | Action Needed |
|---------|-------|---------------|--------|---------------|
| b1, b2, b3, d1, d2, l1, l2, l4, l5, l6, t1, t2, t4, x7, x9, s1, s6, s8, s12, s20 | "34 public repositories on github.com/v0idai" / "34 repos" | **2 repositories** (SN106, SubnetsBot) | **WRONG** | **CRITICAL: Update all 18+ files. Verify actual repo count with team. Either repos are private, or this number is fabricated.** |
| b1, b2, d1, l1, l2, t1, t2, t5, x7, e3 | "4 chains: Bittensor, Solana, Ethereum, Base" | 4 chains confirmed per VoidAI docs | verified | None |
| b1, b2, l2, l4, t1, t2 | "Non-custodial bridge" | Confirmed per docs, Systango article, SubnetEdge | verified | None |
| b1, b2, l2, l4, t1, t2, x8 | "Secured by Chainlink CCIP" | Confirmed. Both VoidAI and Rubicon use CCIP | verified | None |
| b1, b2, l2 | "Lock-and-mint model" | Confirmed per VoidAI docs | verified | None |
| b1, b2, l2 | "wTAO:TAO at 1:1" | Confirmed per VoidAI docs | verified | None |
| d2 | "CCIP same cross-chain protocol used by Aave, Synthetix" | Confirmed. Aave and Synthetix are early CCIP adopters | verified | None |
| b1, l1, l6 | "Lending platform approximately 5 weeks from launch" | Unverified. No public timeline found | unverified | Verify with team. If posting delayed, update timeline. |
| l2 | "Solana bridge (V1) has been audited" | Confirmed per Systango article and metrics-baseline | verified | None |
| l2 | "Ethereum contracts pending audit post-finalization" | Confirmed per Systango article | verified | None |
| d2, s20 | "Python and TypeScript SDK" | TypeScript confirmed (SN106 repo). Python SDK not independently verified | unverified | Verify Python SDK exists and is public |
| b1, b2 | app.voidai.com/bridge-chains URL | Could not fetch (WebFetch denied). URL format is valid per docs | unverified | Manually verify URL resolves |
| b1, b2 | app.voidai.com/stake URL | Could not fetch. URL format valid per docs | unverified | Manually verify URL resolves |
| b1, b2 | docs.voidai.com URL | URL exists per web search results (docs.voidai.com pages appear in results) | verified | None |
| d1 | voidai.com URL | Could not fetch directly | unverified | Manually verify |

### SN106 Metrics

| File(s) | Claim | Current Value | Status | Action Needed |
|---------|-------|---------------|--------|---------------|
| b1, b3, d2, l1, l3, l6, t3, t4, x18, s4, s5 | "SN106 ranked #5 in mindshare at 2.01%" | Source: Altcoin Buzz, **September 2025**. ~6 months old | **stale** | **Refresh from taostats.io before posting any content with this claim** |
| l6, t4 | "SN106 token price: $1.01" | $1.01 per CoinGecko (March 2026 snapshot) | stale | Refresh at time of posting. Token prices change constantly |
| l6, t4 | "SN106 market cap: $3.02M" | $3,020,240 per CoinGecko snapshot | stale | Refresh at time of posting |
| l6, t4 | "SN106 24h volume: ~$153K" | $152,996 per CoinGecko snapshot | stale | Refresh at time of posting |
| l6, t4 | "Primary trading pair: SN106/SN0" | Confirmed per CoinGecko | verified | None |
| l6 | "SN106 registered ~May 2025" | Per on-chain data in metrics-baseline | unverified | Verify via taostats |
| l6 | "CoinGecko listing: Yes (as Liquidity Provisioning)" | Confirmed. CoinGecko page exists | verified | None |

### Bittensor Ecosystem Claims

| File(s) | Claim | Current Value | Status | Action Needed |
|---------|-------|---------------|--------|---------------|
| b1, b2, b3, l1, l2, l3, l5, t3, s10 | "TAO price ~$221" | **~$268-$289** as of March 15, 2026 | **stale** | **Update in all content. Price has risen ~20-30%.** |
| b1, b2, b3, l1, l2, l3, l5, t3, s10, s17 | "TAO market cap $2.39B" | **~$2.77-$2.89B** as of March 15, 2026 | **stale** | **Update in all content.** |
| b3, l3, t3 | "CMC rank #36" | **#30** per CoinMarketCap, #36 per CoinGecko | **stale** | **Update. CMC rank has improved to #30.** |
| b3, l3 | "24h trading volume $231.3M" | **~$320-$468M** currently | **stale** | Update before posting |
| b1, b2, b3, l1, l2, l3, l5, l6, t1, t3, t4, t5, x12, x14, s4, s5, s10, s16, s18, e2, e4 | "128 active subnets" | 128 confirmed (cap with competitive replacement) | verified | None. Dynamic but 128 is the cap |
| b1, b2, b3, l3, t3, t5, x12, x16 | "68% of TAO staked" | 68% (CaptainAltcoin) to 76.27% (Coinbase) | stale | Verify current staking ratio. May have increased to ~76% |
| b3, l3, t3 | "Circulating supply 10.76M TAO" | ~10.77M per CoinMarketCap | verified | Minor rounding difference, acceptable |
| b3 | "Max supply 21M TAO" | 21,000,000 confirmed | verified | None |
| b3 | "~51% of max supply circulating" | ~51.3% currently | verified | None |
| b3, l3, t3, t4, x12, s5, s16, s18, e4 | "Halving December 15, 2025" | Some sources say December 14, 2025 (MEXC, BingX). Others say December 15 | unverified | Minor discrepancy. Verify exact date. Supply-triggered, so exact day may vary by timezone |
| b3, l3, t3, t4, x12, s5, s16 | "Pre-halving: 7,200 TAO/day, Post-halving: 3,600 TAO/day" | Confirmed across multiple sources | verified | None |
| b3, l3, t3 | "Inflation ~26% to ~13%" | Confirmed | verified | None |
| l3, t3 | "Halving supply-based, triggered at 10.5M TAO" | Confirmed | verified | None |
| l3, t3 | "Next halving ~2029, at 15.75M TAO" | Confirmed | verified | None |
| b1, b3, l3, t3 | "Grayscale filed for Bittensor Trust in December 2025" | S-1 filed **December 30, 2025** | verified | Accurate. December 2025 is correct. |
| b3, l3, t3, l5 | "TAO 2nd most mentioned AI coin (LunarCrush)" | Confirmed via LunarCrush tweet (March 2026) | verified | None |
| b3, l3, t3 | "Q2 2025: +50% subnets, +16% miners, +28% wallets, +21.5% staked TAO" | Confirmed via CoinDesk/Yuma "State of Bittensor" report | verified | None |
| l3, t3 | "4-month immunity period for new subnets" | Confirmed via OpenTensor Foundation announcement | verified | None |

### Competitor Claims

| File(s) | Claim | Current Value | Status | Action Needed |
|---------|-------|---------------|--------|---------------|
| b1, b3, l1 | "Rubicon bridges to Base (Coinbase L2)" | Confirmed. Project Rubicon launched Nov 19, 2025 on Base with Chainlink CCIP | verified | None |
| b1 | "Rubicon only for Base/Coinbase pathway" | Confirmed. Rubicon specifically bridges to Base | verified | None |
| b1, t1, l1 | "Wormhole/LayerZero don't support Bittensor natively" | **NOW FALSE.** LayerZero announced native Bittensor EVM integration. vTAO (liquid staked TAO) powered by LayerZero bridges to 8+ chains. | **WRONG** | **CRITICAL: Remove or rewrite this claim in all files (b1, t1, l1, and any others). LayerZero now supports Bittensor.** |
| b1 | "You cannot bridge TAO through Wormhole" | No evidence of native Wormhole TAO support found. Wormhole was used by Render but not TAO-specific | unverified | Research further. May still be accurate for native TAO (not wrapped/EVM TAO) |
| b3 | "Render migrated from Ethereum to Solana in November 2023" | Migration completed **November 2, 2023** | verified | None |
| b3 | "Fetch.ai merged with SingularityNET and Ocean Protocol to form ASI" | **Ocean Protocol withdrew from ASI Alliance on October 9, 2025** | **stale** | **Update: Note that Ocean has since left the alliance** |
| l2, s8 | "Over $2.5 billion / $2B+ lost to bridge exploits since 2020/2022" | Ronin $625M + Wormhole $320M + Nomad $190M + Harmony $100M = $1.235B in 2022 alone. Total since 2020 exceeds $2B with additional incidents | verified | Acceptable. Various sources confirm $2B+ total |
| l2, l4 | "Ronin ($625M), Wormhole ($320M), Nomad ($190M), Harmony ($100M)" | Ronin ~$624-625M, Wormhole ~$320-326M, Nomad ~$190M, Harmony ~$100M | verified | Minor rounding, acceptable |
| s10 | "GPT-4 training: $100M+" | Sam Altman confirmed >$100M. Various sources report $63-100M+ | verified | None |

### Third-Party Coverage Claims

| File(s) | Claim | Current Value | Status | Action Needed |
|---------|-------|---------------|--------|---------------|
| b1, qt-x3 | "Ainvest reported VoidAI 2.0 represents 'a shift from single-chain to multi-chain DeFi asset model'" | Confirmed. Ainvest article exists with this framing | verified | None |
| qt-x3 | ainvest.com/news/bittensor-tao-expands-multi-chain-access-voidai-2-0-2602/ URL | URL appears in search results | verified | None |
| b1, qt-x6 | "SubnetEdge called SN106 'Bittensor's Deflationary Liquidity Engine'" | Confirmed. SubnetEdge Substack article exists with this title | verified | None |
| qt-x6 | subnetedge.substack.com/p/voidai-sn106-bittensors-deflationary URL | URL confirmed in search results | verified | None |
| qt-x4 | systango.com/blog/inside-voidai article exists | Confirmed in search results | verified | None |
| qt-x5 | altcoinbuzz.io/cryptocurrency-news/top-10-bittensor-subnets-by-mindshare/ | Confirmed. Article exists | verified | Data in article is from September 2025 |

### Subnet Claims (Spotlights)

| File(s) | Claim | Current Value | Status | Action Needed |
|---------|-------|---------------|--------|---------------|
| b3, ss1, s19 | "Chutes (SN64): serverless GPU inference" | Confirmed per Altcoin Buzz, VoidAI docs, community sources | verified | None |
| b3, ss2 | "Targon (SN4): deterministic verification" | Confirmed per community sources | verified | None |
| b3, ss3 | "OpenKaito (SN5): decentralized search" | Confirmed per Altcoin Buzz | verified | None |
| b3 | "SN19: low-latency inference" | Confirmed per Altcoin Buzz (Nineteen) | verified | None |
| lt3 | "ETH: Aave, Compound. SOL: Marginfi, Kamino, Solend" as lending protocols | These are real, established lending protocols | verified | None |
| lt3 | "Bittensor has no lending" | No Bittensor-specific lending protocol found as of March 2026 | verified | None |

---

## CROSS-CONTENT CONSISTENCY CHECK

All content items use the same baseline data from metrics-baseline.md. Data is internally consistent across files. However, the baseline itself contains stale data as documented above.

Key internal consistency issues:
- **s8 says "$2B+ lost since 2022"** while **l2 says "$2.5 billion since 2020"**. Both are defensible but use different timeframes. Minor inconsistency.
- **l3 says "top-30 market cap"** in thread part 2, while other content says "#36." The current CMC rank is #30, so "top-30" is now accurate but "#36" is stale.
- **x12 says "128+ subnets"** (with plus sign) while most content says "128 subnets." Both are acceptable given competitive replacement, but "128" (the cap) is more precise.

---

## URL VERIFICATION SUMMARY

| URL | Status | Notes |
|-----|--------|-------|
| app.voidai.com/bridge-chains | unverified | WebFetch denied. Referenced in docs, appears legitimate. Manual check needed. |
| app.voidai.com/stake | unverified | WebFetch denied. Manual check needed. |
| docs.voidai.com | verified | Pages appear in web search results |
| github.com/v0idai | verified | **Only 2 repos, NOT 34** |
| x.com/v0idai | unverified | Standard X profile link. Likely valid. |
| voidai.com | unverified | WebFetch denied. Manual check needed. |
| taostats.io | verified | Live site confirmed in search results |

---

## FILES REQUIRING EDITOR NOTES

The following files need `<!-- DATA REFRESH NEEDED -->` editor notes added for stale or wrong data. Files are listed by priority:

### Priority 1: WRONG data (must fix before publishing)
- All files claiming "34 repos" (18+ files)
- All files claiming "Wormhole/LayerZero don't support Bittensor" (b1, t1, l1)

### Priority 2: STALE market data (refresh before publishing)
- All files with TAO price $221 / market cap $2.39B / CMC rank #36
- All files with SN106 mindshare #5 at 2.01% (September 2025 data)

### Priority 3: STALE secondary data (refresh at time of posting)
- SN106 token price/volume/cap
- TAO staking percentage
- 24h trading volume

---

## METHODOLOGY

1. Read all 63 approved content files
2. Cross-referenced claims against metrics-baseline.md and metrics.md
3. Performed 16 web searches to verify current data
4. Attempted 4 URL fetches (1 succeeded, 3 denied by WebFetch permissions)
5. Cataloged every verifiable claim and assessed against current sources

**Data sources used for verification:**
- CoinMarketCap (TAO price, rank, volume)
- CoinGecko (TAO and SN106 data)
- LunarCrush (AI coin mindshare)
- GitHub (repo count)
- Altcoin Buzz (subnet mindshare rankings)
- Grayscale (trust filing)
- OpenTensor Foundation (subnet mechanics)
- LayerZero (Bittensor EVM integration)
- Project Rubicon / General TAO Ventures (Base bridge)
- Render Foundation (migration details)
- Fetch.ai / ASI Alliance (merger details)
- CertiK, CNBC, Elliptic (bridge exploit data)
- Chainlink (CCIP adoption)

---

**Prepared by:** Data Verification Agent
**Date:** 2026-03-15
**Recommendation:** DO NOT PUBLISH any content until the "34 repos" claim and LayerZero competitor claim are corrected across all affected files. Market data should be refreshed to current values before any content goes live.
