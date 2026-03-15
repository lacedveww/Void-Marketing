# Phase 2: Data Fixes Changelog

**Date:** 2026-03-15
**Scope:** Fix verified data issues identified in phase2-data-verification.md
**Source data:** fresh-data-march2026.md

---

## Fix 1: LayerZero Competitor Claim (CRITICAL)

**Issue:** Content claimed "Wormhole/LayerZero don't support Bittensor natively." This is now false. LayerZero announced native Bittensor EVM integration and vTAO (liquid staked TAO) is live.

**Fix applied:** Rewrote all competitor comparison sections to factually position LayerZero's vTAO for EVM chains alongside VoidAI's Solana+EVM approach with native Raydium DEX integration via SN106. No attacks, purely factual differentiation.

**Files modified:**

| File | Change |
|------|--------|
| b1 (blog-what-is-voidai) | Replaced "General-purpose bridges (Wormhole, LayerZero, Axelar) do not support Bittensor natively..." paragraph with factual LayerZero vTAO vs VoidAI comparison |
| t1 (thread-what-is-voidai) | Rewrote Part 7. Replaced "Wormhole/LayerZero don't support Bittensor natively" with "LayerZero's vTAO bridges to EVM chains. VoidAI bridges to Solana + EVM with native Raydium DEX integration via SN106." |
| l1 (linkedin-company-intro) | Replaced "General-purpose bridges (Wormhole, LayerZero, Axelar) do not support Bittensor natively" with factual three-way comparison (Rubicon/LayerZero/VoidAI) |
| l4 (linkedin-chainlink-ccip-choice) | Verified: Wormhole mentioned only in bridge exploit context ($320M loss). No false claim. Editor note updated to confirm. |

**Files checked but no change needed:**
- b3: No explicit "don't support Bittensor" claim in body. Editor note updated.
- l2: Wormhole mentioned in bridge exploit context only. Editor note updated.

---

## Fix 2: Stale TAO Price/Market Data

**Issue:** Content used $221 / $2.39B market cap / #36 CMC rank / $231.3M volume. All stale as of March 15, 2026.

**Fix applied:** Removed all specific price/market cap figures. Replaced with generic references ("multi-billion dollar market cap", "top-40 CMC rank", "hundreds of millions in daily trading volume") or directed readers to check CoinGecko/CoinMarketCap for current data. This prevents content from becoming stale again.

**Files modified:**

| File | Change |
|------|--------|
| b3 (blog-bittensor-cross-chain-defi) | Removed $2.39B market cap (5 instances), $231.3M volume, #36 rank. Replaced with generic references. Updated seo_description. Updated subtitle and header image comments. |
| t3 (thread-bittensor-post-halving) | Part 4: replaced "$TAO at ~$221, $2.39B market cap, ranked 36th on CMC. 24h volume: $231M" with generic market position reference |
| l3 (linkedin-halving-analysis) | Replaced bullet list with generic TAO market position. Removed specific price, cap, rank, and volume |
| l2 (linkedin-bridge-technical) | Replaced "$2.39B market cap, 68% staked" with "Multi-billion dollar market cap, majority of supply staked" |
| l5 (linkedin-developer-case) | Replaced "$2.39B market cap" with "multi-billion dollar market cap" |
| t5 (thread-crosschain-defi) | Replaced "$2.39B market cap" and "68% staked" in Part 1 (appears in both content and thread parts) |
| b2 (blog-how-to-bridge-tao) | Replaced "$2.39B market cap" and "68% of the supply staked" |
| s10 (satellite-aicrypto-compute) | Replaced "$2.39B market cap" and "68% of $TAO staked" |
| s17 (satellite-defi-bridge-volume) | Replaced "$2.4B" with "multi-billion dollars" |

---

## Fix 3: Ocean Protocol / ASI Alliance

**Issue:** Content stated Fetch.ai "merged with SingularityNET and Ocean Protocol" to form ASI. Ocean Protocol withdrew from the ASI Alliance on October 9, 2025.

**Fix applied:** Updated the merger description to reflect Ocean's withdrawal.

**Files modified:**

| File | Change |
|------|--------|
| b3 (blog-bittensor-cross-chain-defi) | Changed "merged with SingularityNET and Ocean Protocol to form the Artificial Superintelligence Alliance" to "merged with SingularityNET to form the Artificial Superintelligence (ASI) Alliance...Ocean Protocol was initially part of the alliance but withdrew in October 2025." |

**Files checked but no change needed:**
- b1: No Ocean Protocol reference in content body. Editor note updated.

---

## Fix 4: Mindshare Data (2.01% / #5 ranking)

**Issue:** The "2.01% mindshare, #5 ranking" data is from a September 2025 Altcoin Buzz article, presented as current. The actual current figure cannot be verified externally.

**Fix applied:** Added "as of September 2025" qualifier wherever the specific figure appears, or replaced with "top-5 Kaito mindshare among Bittensor subnets" without specific percentage.

**Files modified:**

| File | Change |
|------|--------|
| b1 (blog-what-is-voidai) | Changed "sits at #5 in Bittensor mindshare rankings at 2.01%, up from zero presence just months ago" to "sat at #5 in Bittensor Kaito mindshare rankings as of September 2025, the only liquidity-focused subnet in the top 10" |
| b3 (blog-bittensor-cross-chain-defi) | Changed "ranked #5 in Bittensor mindshare at 2.01%. At time of writing, its alpha token trades at $1.01 with a $3.02M market cap" to "ranked in the top 5 of Bittensor Kaito mindshare as of September 2025, the only liquidity-focused subnet in the top 10" |
| t3 (thread-bittensor-post-halving) | Part 8: changed "Ranked 5th in mindshare at 2.01%" to "Top-5 Kaito mindshare among Bittensor subnets as of September 2025" |
| t4 (thread-sn106-explained) | Part 6: removed specific price/cap/volume, qualified mindshare as "top-5 as of September 2025", directed to CoinGecko for current metrics |
| l1 (linkedin-company-intro) | Changed "ranks #5 in Bittensor mindshare at 2.01%" to "ranked top-5 in Bittensor Kaito mindshare as of September 2025, the only liquidity-focused subnet in the top 10" |
| l3 (linkedin-halving-analysis) | Changed "ranked #5 in Bittensor mindshare at 2.01%" to "ranked top-5 in Bittensor Kaito mindshare as of September 2025" |
| l6 (linkedin-sn106-subnet) | Changed "Mindshare: #5 at 2.01%" to "Mindshare: top-5 Kaito ranking among Bittensor subnets (as of September 2025)" |
| d2 (discord-what-is-voidai) | Changed "Currently ranked in the top 5 by mindshare at 2.01%" to "Ranked top-5 in Bittensor Kaito mindshare as of September 2025, the only liquidity-focused subnet in the top 10" |
| s4 (satellite-ecosystem-rankings) | Added "as of September 2025" qualifier to the "#5 at 2.01%" figure |
| x18 (tweet-sn106-rank) | Changed "SN106: #5 by mindshare at 2.01%" to "SN106: top-5 Kaito mindshare among Bittensor subnets (as of September 2025)" |
| qt-x5 (altcoinbuzz) | Added "Per this article" prefix to attribute the figure to the quoted source |

---

## Fix 5: GitHub Repo Count

**Status: NOT FIXED (per instructions)**

The "34 repos" claim needs human verification. All DATA REFRESH NEEDED editor notes remain in place across 18+ files. The actual github.com/v0idai count shows 2 public repositories.

---

## Fix 6: Subnet Count

**Issue:** "128 subnets" should be "128+ subnets" since the exact count may vary with competitive replacement, and expansion to 256 is planned for 2026.

**Fix applied:** Changed "128 subnets" / "128 active subnets" to "128+ subnets" / "128+ active subnets" across all content files.

**Files modified:**

| File | Change |
|------|--------|
| b1 (blog-what-is-voidai) | 2 instances: "128 active subnets" and "128 subnets" changed to "128+" |
| b2 (blog-how-to-bridge-tao) | 1 instance: "128 active subnets" |
| b3 (blog-bittensor-cross-chain-defi) | 7 instances across subtitle, intro, body sections |
| t1 (thread-what-is-voidai) | 2 instances (content + Part 1) |
| t3 (thread-bittensor-post-halving) | 2 instances (Parts 3 and 5) |
| t4 (thread-sn106-explained) | 1 instance (Part 6) |
| t5 (thread-crosschain-defi) | 2 instances (content + Part 1) |
| l1 (linkedin-company-intro) | 1 instance |
| l2 (linkedin-bridge-technical) | 1 instance |
| l3 (linkedin-halving-analysis) | 3 instances |
| l5 (linkedin-developer-case) | 2 instances |
| l6 (linkedin-sn106-subnet) | 2 instances |
| lt3 (lending-teaser-3) | 1 instance |
| s4 (satellite-ecosystem-rankings) | 1 instance |
| s5 (satellite-ecosystem-halving) | 1 instance |
| s10 (satellite-aicrypto-compute) | 1 instance |
| s16 (satellite-ecosystem-dtao-flows) | 1 instance |
| s18 (satellite-aicrypto-subnet-economics) | 1 instance |
| x13 (tweet-dtao-dynamics) | 1 instance |
| x18 (tweet-sn106-rank) | 1 instance |
| e2 (engagement-hot-take-liquidity) | 1 instance |
| e4 (engagement-dtao-open-question) | 1 instance |
| ss3 (subnet-spotlight-openkaito-sn5) | 1 instance |

---

## Additional Changes

### updated_at Timestamps
All modified files had their `updated_at` frontmatter field changed from "2026-03-13" to "2026-03-15".

### Editor Notes
All DATA REFRESH NEEDED comments related to fixed issues were replaced with FIXED 2026-03-15 comments documenting what was changed and why. GitHub repo count DATA REFRESH NEEDED notes were intentionally preserved per instructions.

---

## Files NOT Modified (confirmed no changes needed)

- l4 (linkedin-chainlink-ccip-choice): Wormhole reference is factual (bridge exploit context only)
- d1 (discord-welcome): No stale data found
- All subnet spotlight files (ss1, ss2, ss3): Only ss3 had subnet count update
- Most satellite files without stale data references
- All lending teaser files except lt3

---

## Summary

| Fix | Files Modified | Status |
|-----|---------------|--------|
| 1. LayerZero competitor claim | 4 (b1, t1, l1, l4) | COMPLETE |
| 2. Stale TAO price/market data | 9 (b2, b3, l2, l3, l5, s10, s17, t3, t5) | COMPLETE |
| 3. Ocean Protocol / ASI Alliance | 1 (b3) | COMPLETE |
| 4. Mindshare data qualification | 11 (b1, b3, d2, l1, l3, l6, qt-x5, s4, t3, t4, x18) | COMPLETE |
| 5. GitHub repo count | 0 | DEFERRED (human verification needed) |
| 6. Subnet count (128 to 128+) | 23 files | COMPLETE |

**Total unique files modified:** 27

**Prepared by:** Data Fixes Agent
**Date:** 2026-03-15
