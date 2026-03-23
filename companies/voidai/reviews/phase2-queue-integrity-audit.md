# Phase 2 Queue Integrity Audit (Full Re-Audit)

**Auditor:** Claude Opus 4.6 (1M context), Code Reviewer Agent
**Date:** 2026-03-15
**Supersedes:** Previous audit of same filename (51-item, manifest v2 audit)
**Scope:** Full manifest v3 + all 64 content files in queue/ (63 approved + 1 rejected)
**Config files cross-referenced:** manifest.json, cadence.md, pillars.md, accounts.md, voice.md, voice-learnings.md, base-rules.md, canva-designs-manifest.md

---

## Executive Summary

| Metric | Value |
|--------|-------|
| Total manifest items | 64 (63 approved, 1 rejected) |
| Total content files found | 64 |
| Manifest-to-file match rate | 100% |
| Unique IDs | 64/64 (no duplicates) |
| Banned AI phrase violations | 0 |
| Em dash violations | 0 |
| Double hyphen violations | 1 (in data table, non-content context) |
| Stale data instances requiring refresh | 8 |
| Human review gate violations | 13 (approved without reviewed_by) |
| Content type mismatches (manifest vs file) | 6 |
| Disclaimer missing on approved content | 2 |
| Overall queue readiness | **NOT READY** for production. 13 items need human sign-off. 8 items need data refresh. 6 content_type mismatches should be reconciled. |

---

## 1. Manifest Integrity

### 1a. File-to-Manifest Correspondence

**PASS.** Every manifest entry maps to exactly one content file, and every content file in the approved/ and rejected/ directories has a corresponding manifest entry. No orphaned files. No phantom entries.

### 1b. ID Uniqueness

**PASS.** All 64 IDs are unique across the manifest. No collisions.

### 1c. Status Field Consistency

**PASS.** All 63 items in approved/ have `status: "approved"` in both the manifest and their file frontmatter. The 1 rejected item in rejected/ has `status: "rejected"` in both locations.

### 1d. Manifest Count Accuracy

**PASS.** The manifest header shows `"approved": 63, "rejected": 1`. The actual file count matches: 63 files in approved/, 1 in rejected/.

---

## 2. Platform Consistency

### 2a. Platform Value Standardization

**PASS.** All platform values in manifest v3 use standardized lowercase strings:
- "x" (not "twitter" or "Twitter" or "x-twitter")
- "discord" (not "Discord")
- "linkedin" (not "LinkedIn")
- "blog" (not "Blog")

Note: The previous audit (v2 manifest) identified a "x" vs "x-twitter" inconsistency. This has been resolved in manifest v3. All X platform items now use "x".

### 2b. Platform-to-Account Mapping

**PASS.** All platform/account combinations align with accounts.md:
- v0idai: x, blog, linkedin, discord
- fanpage-satellite: x
- bittensor-ecosystem-satellite: x
- defi-crosschain-satellite: x
- ai-crypto-satellite: x
- meme-culture-satellite: x

### 2c. Content Type Mismatches (Manifest vs File)

**WARNING.** 6 LinkedIn items have `content_type: "article"` in the manifest but `content_type: "post"` in their file frontmatter:

| Manifest ID | Manifest content_type | File content_type |
|-------------|----------------------|-------------------|
| l1-company-intro | article | post |
| l2-bridge-technical | article | post |
| l3-halving-analysis | article | post |
| l4-chainlink-ccip-choice | article | post |
| l5-developer-case | article | post |
| l6-sn106-subnet | article | post |

**Impact:** Could cause automation errors if the posting workflow uses content_type for LinkedIn format selection (LinkedIn articles and posts use different APIs).

**Fix:** Reconcile by updating either the manifest or the files. Given the character counts (2200-2850 chars), these are more accurately "post" than "article" on LinkedIn.

---

## 3. Content Quality

### 3a. Banned AI Phrases

**PASS.** Zero instances of any banned AI phrase found across all 64 content files. Full banned list checked:
- "It's worth noting" / "In the ever-evolving landscape of" / "At its core" / "This is a game-changer" / "This underscores the importance of" / "Without further ado" / "In today's rapidly changing" / "Revolutionizing the way" / "Paving the way for" / "Paradigm shift" / "Synergy/synergies" / "Holistic approach" / "Cutting-edge" / "Seamless integration" / "Robust ecosystem" / "Additionally/Furthermore/Moreover" at sentence start / "It is important to note that" / "In conclusion" / "As we navigate"

None found in any content body, thread part, or accompanying text.

### 3b. Em Dash Violations

**PASS.** Zero em dash characters (U+2014) found in any content file.

### 3c. Double Hyphen Violations

**WARNING (minor).** 2 instances of " -- " found in `20260313-datacard-dc1-daily-metrics.md`, lines 74-75, inside a data table "Change" column indicating "no change." These are in a structured template, not published prose. The Canva-rendered visual will not show them literally.

| File | Line | Context |
|------|------|---------|
| dc1-daily-metrics.md | 74 | Bridge Uptime Change column: " -- " |
| dc1-daily-metrics.md | 75 | Chains Supported Change column: " -- " |

**Recommendation:** Replace " -- " with "N/A" or "static" for consistency with the formatting ban, even in non-published template context.

### 3d. Character Limit Compliance

**X platform (280 char limit):** All single tweets and thread Part 1 entries have declared character counts within 280 chars. Highest: satellite-s9-defi-flows at 277, within limit. All thread parts were individually reviewed during the content read and are within 280 chars each.

**LinkedIn (3000 char limit):** All 6 LinkedIn posts range 2289-2850 chars. **PASS.**

**Discord (2000 char limit):** d1-welcome (1137 chars), d2-what-is-voidai (1427 chars). **PASS.**

**Blog:** No hard limit. b1 (12592), b2 (10640), b3 (11926). **PASS.**

### 3e. "So What" Test

**PASS.** All approved content provides specific data, metrics, or actionable insights. The one rejected item was correctly rejected for this exact reason ("Too general, no information or value").

### 3f. Stale Data Instances

**CRITICAL.** 8 content items contain hardcoded data that is confirmed stale or flagged as needing refresh:

| # | File | Stale Data | Current Value | Location |
|---|------|-----------|---------------|----------|
| 1 | x12-post-halving | "~68% of $TAO staked" | 76.27% per Coinbase 2026-03-15 | Line 65 (content body) |
| 2 | x16-staking-explainer | "~68% of $TAO is staked" | 76.27% | Line 61 (content body) |
| 3 | satellite-s5-ecosystem-halving | "~68% of supply staked" | 76.27% | Line 63 (content body) |
| 4 | l3-halving-analysis | "68% staking rate" | 76.27% | Line 90 (content body) |
| 5 | t3-bittensor-post-halving | "68% of $TAO is now staked" | 76.27% | Line 87 (thread Part 4) |
| 6 | b3-bittensor-cross-chain-defi | "68% of the circulating supply (~7.3M TAO out of 10.76M)" | 76.27% | Lines 100, 168 (body), Line 28 (SEO description) |
| 7 | b3-bittensor-cross-chain-defi (SEO) | "68% of TAO is staked" in seo_description | 76.27% | Line 28 (frontmatter) |
| 8 | l6-sn106-subnet | "Token price: $1.01 / Market cap: $3.02M / 24h volume: ~$153K" | Needs fresh pull from CoinGecko | Lines 88-89 (content body) |

Items 1-5 already have "DATA REFRESH NEEDED" editor notes. Items 6-7 have a "FIXED" note but the content body and SEO description still contain "68%". Item 8 has an explicit refresh note.

**Fix:** Before publishing any of these items, refresh staking percentages and SN106 token metrics from live data sources.

---

## 4. Pillar Distribution Analysis

### Target vs Actual

| Pillar | Target | Manifest Count | Manifest % | Delta |
|--------|:------:|:--------------:|:----------:|:-----:|
| Bridge & Build | 40% | 24 | 38.1% | -1.9% |
| Ecosystem Intelligence | 25% | 19 | 30.2% | +5.2% |
| Alpha & Education | 25% | 14 | 22.2% | -2.8% |
| Community & Culture | 10% | 6 | 9.5% | -0.5% |

**Assessment:** Bridge & Build and Community & Culture are within acceptable tolerance. Alpha & Education is slightly underweight at -2.8%. Ecosystem Intelligence is overweight by +5.2%, driven by Phase 2 additions (3 subnet spotlights, dTAO analysis, engagement content).

**Recommendation:** Next content batch should lean toward Alpha & Education (tutorials, how-to content) to rebalance.

---

## 5. Cadence Compliance

### 5a. Per-Account Post Counts

| Account | Items in Queue | Max/Day (cadence.md) | Days of Content at Max Rate |
|---------|:--------------:|:--------------------:|:---------------------------:|
| v0idai (main) | 43 | 1-2/day | 22-43 days |
| fanpage-satellite | 6 | 1-2/day | 3-6 days |
| bittensor-ecosystem-satellite | 5 | 1-2/day | 3-5 days |
| defi-crosschain-satellite | 4 | 1-2/day | 2-4 days |
| ai-crypto-satellite | 4 | 1/day | 4 days |
| meme-culture-satellite | 3 | 1-2/day | 2-3 days |

### 5b. Scheduling Assessment

**Cannot fully assess.** All scheduling fields (scheduled_post_at, earliest_post_at, latest_post_at) are empty strings across all 63 approved items. Cadence compliance, weekend rules, and inter-account timing gaps can only be verified once actual post times are assigned.

### 5c. Stagger Group Logic

**PASS.** Stagger groups and orders are logically consistent:
- "launch-foundation" (orders 1-5): Blog b1 > thread t1 > blog b2 > thread t2 > LinkedIn l2
- "lending-teasers" (orders 1-3): lt1 > lt2 > lt3 progressive reveal
- "launch-coverage" (orders 1-4): qt-x3 > qt-x4 > qt-x5 > qt-x6 media amplification
- "content-stockpile" (orders 1-7): Threads and LinkedIn staged in dependency order
- "subnet-spotlights" (orders 1-3): Chutes > Targon > OpenKaito
- Satellite groups with proper stagger orders per inter-account coordination rules

### 5d. Minimum Viable Cadence

cadence.md requires "at least 4 posts/week per satellite account." Satellite accounts have 3-6 items each, providing roughly 1-2 weeks at minimum cadence. Thin but acceptable as initial stockpile.

---

## 6. Compliance Flags

### 6a. Human Review Gate Violations

**CRITICAL.** 13 items have `status: "approved"` but `reviewed_by: ""`. Per base-rules.md Section 2: "ALL content must be reviewed by {REVIEW_AUTHORITY} before publishing. AI generates, human approves. No exceptions."

All 13 were created on 2026-03-15 by the "Phase 2 Challenger agent":

| # | ID | Content Type |
|---|-----|-------------|
| 1 | e1-defi-barrier-poll | poll |
| 2 | e2-hot-take-liquidity | single tweet |
| 3 | e3-next-chain-question | single tweet |
| 4 | e4-dtao-open-question | single tweet |
| 5 | satellite-s15-fanpage-lending-hype | single tweet |
| 6 | satellite-s16-ecosystem-dtao-flows | single tweet |
| 7 | satellite-s17-defi-bridge-volume | single tweet |
| 8 | satellite-s18-aicrypto-subnet-economics | single tweet |
| 9 | satellite-s19-meme-subnet-personality | single tweet |
| 10 | satellite-s20-fanpage-ecosystem-credibility | single tweet |
| 11 | ss1-subnet-spotlight-chutes-sn64 | thread (5 parts) |
| 12 | ss2-subnet-spotlight-targon-sn4 | thread (5 parts) |
| 13 | ss3-subnet-spotlight-openkaito-sn5 | single tweet |

**Impact:** These items MUST NOT be published until Vew reviews them.

**Fix:** Either change their status to "review" to accurately reflect their state, or have Vew review and populate reviewed_by/reviewed_at for each.

### 6b. Disclaimer Missing

**WARNING.** 2 items have `disclaimer_included: false`:

| ID | Account | Assessment |
|----|---------|-----------|
| e1-defi-barrier-poll | v0idai | Low risk. Pure opinion poll, no financial claims. Acceptable. |
| satellite-s19-meme-subnet-personality | meme-culture-satellite | Low risk. Humor, no financial claims. Bio-level disclaimer covers per meme account spec. Acceptable. |

These are intentional exemptions for low-risk content, not oversights.

### 6c. compliance_passed Accuracy

All 64 items have `compliance_passed: true` in manifest. This is accurate for the content as reviewed. The stale data items are not compliance failures per se (data was current at creation time) but need refresh before posting.

---

## 7. Sequencing Logic

### 7a. Stagger Group Dependencies

**PASS.** Foundation content ships first. Media amplification follows. Lending teasers progress vague to specific. Satellite posts are ordered to post after main account content.

### 7b. Conflicting Narratives

**PASS.** No contradictory claims, inconsistent competitor comparisons, or contradictory data points found across any content items. All content presents a consistent narrative.

### 7c. Cross-Account Phrasing Differentiation

**PASS.** The content team explicitly avoided identical phrasing. Editor notes document specific changes (e.g., s2 changed "generating protocol revenue" to "has live revenue streams" to differ from s4/s6).

### 7d. @v0idai Mention Limits

Per accounts.md: "Satellite accounts may mention @v0idai maximum 2x/week."

| Account | @v0idai Mentions | Within 2/week Limit? |
|---------|:----------------:|:-------------------:|
| fanpage-satellite | s1, s15 | YES (2) |
| bittensor-ecosystem | s4, s6 | YES (2) |
| defi-crosschain | s7, s8 | YES (2) |
| ai-crypto | s11, s12 | YES (2) |
| meme-culture | 0 | YES (0) |

**PASS.** Editor notes document where mentions were strategically removed to stay within limits.

---

## 8. Canva Assets

### 8a. Designs Manifest Coverage

7 saved Canva designs mapping to content:

| Design | Maps to |
|--------|---------|
| VoidAI Thread Header | t1-what-is-voidai |
| Lending Teaser | lt1/lt2/lt3 |
| Daily Metrics Data Card | dc1-daily-metrics |
| Bridge Infographic | b2, t2 |
| Subnet Spotlight Template | ss1/ss2/ss3 |
| LinkedIn Company Intro | l1-company-intro |
| Blog Hero "What is VoidAI" | b1-what-is-voidai |

### 8b. Missing Assets

Noted in the manifest "Still Needed" section:
- Quote tweet graphic template (for qt-x3 through qt-x6)
- Video thumbnails (Phase 4)
- Animated versions for engagement posts (Phase 4)

Additional gaps:
- lt2-lending-teaser-2 requires a blurred UI screenshot (`has_media: true`) with no Canva design listed
- Blog b3 header image has a placeholder but no Canva design
- LinkedIn posts l2-l6 have no visual assets (only l1 has a Canva design)

---

## 9. Additional Findings

### 9a. Voice Calibration Concern (e3-next-chain-question)

e3-next-chain-question uses a question format ("Which chain should VoidAI support next?") which contradicts Vew's documented declarative voice pattern. The editor notes flag this explicitly: "NOTE FOR VEW: This departs from Vew's typical declarative style." This is correctly flagged but should not be "approved" without Vew's review (it is among the 13 un-reviewed items).

### 9b. Data Card Template

dc1-daily-metrics has all values as [PLACEHOLDER] and `character_count: 0`. This is by design for the n8n automation template. Not a defect, but the template must not be posted without populating values.

### 9c. SEO Metadata

All 3 blog posts have complete SEO fields (seo_title, seo_description, seo_slug, seo_keywords). **PASS.**

### 9d. Thread Count Verification

All 9 thread-type items (t1-t5, lt3, ss1, ss2) have thread_count values matching their actual number of ### Part N sections. **PASS.**

---

## 10. Priority Actions

### CRITICAL (must fix before any publishing)

1. **Human review 13 items.** Phase 2 Challenger items (2026-03-15) have `reviewed_by: ""`. They cannot be published per compliance rules. Vew must review each, or their status must be changed to "review."

2. **Refresh stale 68% staking data.** 6 content items hardcode "68%" staking rate; actual is 76.27% as of 2026-03-15. Files to update: x12, x16, s5, l3, t3 (Part 4), b3 (body lines 100 and 168, plus SEO description line 28).

3. **Refresh SN106 token metrics in l6.** Token price ($1.01), market cap ($3.02M), 24h volume ($153K) are stale point-in-time snapshots.

### WARNINGS (should fix)

4. **Reconcile 6 content_type mismatches.** LinkedIn items show "article" in manifest but "post" in file frontmatter. Standardize to one value.

5. **Replace double hyphens in dc1 template.** " -- " in data table should be "N/A" for consistency.

6. **Create missing Canva assets.** lt2 needs blurred UI screenshot. Quote tweet template needed. Blog b3 header image needed.

### SUGGESTIONS (consider improving)

7. **Rebalance pillar weights.** Ecosystem Intelligence is +5.2% over target. Next batch should favor Alpha & Education.

8. **Add scheduling dates.** All 63 approved items have empty scheduled_post_at. Cadence compliance cannot be verified.

9. **Satellite content depth.** 3-6 items per satellite provides only 1-2 weeks at minimum cadence. Plan next cycle to deepen.

10. **b3 SEO description still references 68%.** Line 28 reads "68% of TAO is staked with limited DeFi access." Must match refreshed body.

---

## Appendix: Full Item Inventory

| # | ID | Platform | Account | Pillar | Type | Reviewed By |
|---|-----|----------|---------|--------|------|-------------|
| 1 | b1-what-is-voidai | blog | v0idai | bridge-build | article | vew |
| 2 | b2-how-to-bridge-tao | blog | v0idai | alpha-education | article | vew |
| 3 | b3-bittensor-cross-chain-defi | blog | v0idai | ecosystem-intelligence | article | vew |
| 4 | dc1-daily-metrics | x | v0idai | bridge-build | data-card | vew |
| 5 | discord-d1-welcome | discord | v0idai | community-culture | announcement | vew |
| 6 | discord-d2-what-is-voidai | discord | v0idai | alpha-education | announcement | vew |
| 7 | e1-defi-barrier-poll | x | v0idai | ecosystem-intelligence | poll | **MISSING** |
| 8 | e2-hot-take-liquidity | x | v0idai | ecosystem-intelligence | single | **MISSING** |
| 9 | e3-next-chain-question | x | v0idai | bridge-build | single | **MISSING** |
| 10 | e4-dtao-open-question | x | v0idai | ecosystem-intelligence | single | **MISSING** |
| 11 | l1-company-intro | linkedin | v0idai | bridge-build | post/article mismatch | vew |
| 12 | l2-bridge-technical | linkedin | v0idai | bridge-build | post/article mismatch | vew |
| 13 | l3-halving-analysis | linkedin | v0idai | ecosystem-intelligence | post/article mismatch | vew |
| 14 | l4-chainlink-ccip-choice | linkedin | v0idai | bridge-build | post/article mismatch | vew |
| 15 | l5-developer-case | linkedin | v0idai | alpha-education | post/article mismatch | vew |
| 16 | l6-sn106-subnet | linkedin | v0idai | bridge-build | post/article mismatch | vew |
| 17 | lt1-lending-teaser-1 | x | v0idai | bridge-build | single | vew |
| 18 | lt2-lending-teaser-2 | x | v0idai | bridge-build | single | vew |
| 19 | lt3-lending-teaser-3 | x | v0idai | bridge-build | thread | vew |
| 20 | qt-x3-ainvest | x | v0idai | bridge-build | quote_tweet | vew |
| 21 | qt-x4-systango | x | v0idai | bridge-build | quote_tweet | vew |
| 22 | qt-x5-altcoinbuzz | x | v0idai | bridge-build | quote_tweet | vew |
| 23 | qt-x6-subnetedge | x | v0idai | bridge-build | quote_tweet | vew |
| 24 | satellite-s1-fanpage-bridge | x | fanpage-satellite | bridge-build | single | vew |
| 25 | satellite-s2-fanpage-sn106 | x | fanpage-satellite | alpha-education | single | vew |
| 26 | satellite-s3-fanpage-culture | x | fanpage-satellite | community-culture | single | vew |
| 27 | satellite-s4-ecosystem-rankings | x | bittensor-ecosystem-satellite | ecosystem-intelligence | single | vew |
| 28 | satellite-s5-ecosystem-halving | x | bittensor-ecosystem-satellite | ecosystem-intelligence | single | vew |
| 29 | satellite-s6-ecosystem-sn106 | x | bittensor-ecosystem-satellite | alpha-education | single | vew |
| 30 | satellite-s7-defi-liquidity | x | defi-crosschain-satellite | alpha-education | single | vew |
| 31 | satellite-s8-defi-security | x | defi-crosschain-satellite | ecosystem-intelligence | single | vew |
| 32 | satellite-s9-defi-flows | x | defi-crosschain-satellite | ecosystem-intelligence | single | vew |
| 33 | satellite-s10-aicrypto-compute | x | ai-crypto-satellite | ecosystem-intelligence | single | vew |
| 34 | satellite-s11-aicrypto-bittensor | x | ai-crypto-satellite | alpha-education | single | vew |
| 35 | satellite-s12-aicrypto-agents | x | ai-crypto-satellite | bridge-build | single | vew |
| 36 | satellite-s13-meme-bridge | x | meme-culture-satellite | community-culture | single | vew |
| 37 | satellite-s14-meme-poll | x | meme-culture-satellite | community-culture | poll | vew |
| 38 | satellite-s15-fanpage-lending-hype | x | fanpage-satellite | bridge-build | single | **MISSING** |
| 39 | satellite-s16-ecosystem-dtao-flows | x | bittensor-ecosystem-satellite | ecosystem-intelligence | single | **MISSING** |
| 40 | satellite-s17-defi-bridge-volume | x | defi-crosschain-satellite | ecosystem-intelligence | single | **MISSING** |
| 41 | satellite-s18-aicrypto-subnet-economics | x | ai-crypto-satellite | alpha-education | single | **MISSING** |
| 42 | satellite-s19-meme-subnet-personality | x | meme-culture-satellite | community-culture | single | **MISSING** |
| 43 | satellite-s20-fanpage-ecosystem-credibility | x | fanpage-satellite | alpha-education | single | **MISSING** |
| 44 | ss1-subnet-spotlight-chutes-sn64 | x | v0idai | ecosystem-intelligence | thread | **MISSING** |
| 45 | ss2-subnet-spotlight-targon-sn4 | x | v0idai | ecosystem-intelligence | thread | **MISSING** |
| 46 | ss3-subnet-spotlight-openkaito-sn5 | x | v0idai | ecosystem-intelligence | single | **MISSING** |
| 47 | t1-what-is-voidai | x | v0idai | bridge-build | thread | vew |
| 48 | t2-bridge-tao-howto | x | v0idai | alpha-education | thread | vew |
| 49 | t3-bittensor-post-halving | x | v0idai | ecosystem-intelligence | thread | vew |
| 50 | t4-sn106-explained | x | v0idai | bridge-build | thread | vew |
| 51 | t5-crosschain-defi-possibilities | x | v0idai | alpha-education | thread | vew |
| 52 | x7-bridge-4chains | x | v0idai | bridge-build | single | vew |
| 53 | x8-ccip-security | x | v0idai | bridge-build | single | vew |
| 54 | x9-sdk-infra | x | v0idai | bridge-build | single | vew |
| 55 | x10-raydium-lp | x | v0idai | bridge-build | single | vew |
| 56 | x11-lending-teaser | x | v0idai | bridge-build | single | vew |
| 57 | x12-post-halving | x | v0idai | ecosystem-intelligence | single | vew |
| 58 | x13-dtao-dynamics | x | v0idai | ecosystem-intelligence | single | vew |
| 59 | x14-tao-ai-mindshare | x | v0idai | ecosystem-intelligence | single | vew |
| 60 | x15-bridge-howto | x | v0idai | alpha-education | single | vew |
| 61 | x16-staking-explainer | x | v0idai | alpha-education | single | vew |
| 62 | x17-crosschain-alpha | x | v0idai | alpha-education | single | vew |
| 63 | x18-sn106-rank | x | v0idai | community-culture | single | vew |
| 64 | 20260313-180000-x-v0idai-bridge-test | x | v0idai | bridge-build | single | vew (rejected) |

---

*Audit complete. Queue is structurally sound but NOT production-ready until the 13 human review gaps and 8 stale data instances are resolved.*
