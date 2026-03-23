# Character Count Audit Report

**Auditor:** Claude Opus 4.6 (charcount-audit)
**Date:** 2026-03-13
**Scope:** All draft content files across queue/drafts/, queue/review/, and queue/approved/

## Summary

Audited `character_count` frontmatter values across all 50 content files. Found **45 files with incorrect character_count values** (90% error rate). Only 5 files had correct counts. This confirms the systemic problem identified by the challenger audit.

**Root causes identified:**
1. Blog and LinkedIn articles had `character_count: 0` as placeholder, never populated
2. Thread files had `character_count: 0` (should count the `## Content` summary, not thread parts)
3. One thread (lt3) had `character_count: 1540` which was the total thread length, not the summary
4. Tweet/satellite single posts had counts off by 1-89 characters (likely from edits that didn't update the count)

## Counting Rules Applied

- **Single posts (tweets, satellites, quote tweets, discord, polls):** Count all text between `## Content` and `## Editor Notes`, stripped of leading/trailing whitespace
- **Threads:** Count ONLY the `## Content` section (the opening summary/first tweet), NOT `## Thread Parts`
- **Blog/LinkedIn articles:** Count full body content between `## Content` and `## Editor Notes`
- **Data cards:** Skipped (no `## Content` section; uses `## Accompanying Post Text` instead; `character_count: 0` is intentional)

## Files with No Changes Needed (5)

| File | Count | Location |
|------|-------|----------|
| lt1-lending-teaser-1 | 183 | review |
| satellite-s11-aicrypto-bittensor | 255 | review |
| satellite-s9-defi-flows | 277 | review |
| datacard-dc1 (no content section) | 0 | review |
| .gitkeep (not a content file) | n/a | drafts |

## Files Corrected (45)

### Blog Articles (3 files) -- all were 0, now populated

| File | Old | New | Location |
|------|-----|-----|----------|
| blog-b1-what-is-voidai | 0 | 12640 | review |
| blog-b2-how-to-bridge-tao | 0 | 10659 | review |
| blog-b3-bittensor-cross-chain-defi | 0 | 11944 | review |

### LinkedIn Articles (6 files) -- all were 0, now populated

| File | Old | New | Location |
|------|-----|-----|----------|
| linkedin-l1-company-intro | 0 | 4672 | review |
| linkedin-l2-bridge-technical | 0 | 4657 | review |
| linkedin-l3-halving-analysis | 0 | 5007 | review |
| linkedin-l4-chainlink-ccip-choice | 0 | 4560 | review |
| linkedin-l5-developer-case | 0 | 4094 | review |
| linkedin-l6-sn106-subnet | 0 | 5722 | review |

### Threads (6 files) -- summary counts were 0 or wrong

| File | Old | New | Note | Location |
|------|-----|-----|------|----------|
| thread-t1-what-is-voidai | 0 | 223 | Was 0, now counts summary only | review |
| thread-t2-bridge-tao-howto | 0 | 173 | Was 0, now counts summary only | review |
| thread-t3-bittensor-post-halving | 0 | 195 | Was 0, now counts summary only | review |
| thread-t4-sn106-explained | 0 | 214 | Was 0, now counts summary only | review |
| thread-t5-crosschain-defi-possibilities | 0 | 226 | Was 0, now counts summary only | review |
| lt3-lending-teaser-3 | 1540 | 206 | Was counting full thread, now summary only | review |

### Discord Posts (2 files)

| File | Old | New | Diff | Location |
|------|-----|-----|------|----------|
| discord-d1-welcome | 1180 | 1137 | -43 | review |
| discord-d2-what-is-voidai | 1420 | 1415 | -5 | review |

### Lending Teasers (1 file)

| File | Old | New | Diff | Location |
|------|-----|-----|------|----------|
| lt2-lending-teaser-2 | 136 | 165 | +29 | review |

### Quote Tweets (4 files)

| File | Old | New | Diff | Location |
|------|-----|-----|------|----------|
| qt-x3-ainvest | 228 | 272 | +44 | review |
| qt-x4-systango | 248 | 251 | +3 | review |
| qt-x5-altcoinbuzz | 240 | 280 | +40 | review |
| qt-x6-subnetedge | 254 | 282 | +28 | review |

### Satellite Posts (12 files)

| File | Old | New | Diff | Location |
|------|-----|-----|------|----------|
| satellite-s1-fanpage-bridge | 210 | 209 | -1 | review |
| satellite-s2-fanpage-sn106 | 222 | 220 | -2 | review |
| satellite-s3-fanpage-culture | 195 | 184 | -11 | review |
| satellite-s4-ecosystem-rankings | 249 | 250 | +1 | review |
| satellite-s5-ecosystem-halving | 259 | 258 | -1 | review |
| satellite-s6-ecosystem-sn106 | 270 | 298 | +28 | review |
| satellite-s7-defi-liquidity | 248 | 312 | +64 | review |
| satellite-s8-defi-security | 270 | 359 | +89 | review |
| satellite-s10-aicrypto-compute | 254 | 253 | -1 | review |
| satellite-s12-aicrypto-agents | 279 | 278 | -1 | review |
| satellite-s13-meme-bridge | 193 | 192 | -1 | review |
| satellite-s14-meme-poll | 122 | 163 | +41 | review |

### Main Account Tweets (11 files)

| File | Old | New | Diff | Location |
|------|-----|-----|------|----------|
| tweet-x7-bridge-4chains | 224 | 227 | +3 | review |
| tweet-x8-ccip-security | 270 | 272 | +2 | approved |
| tweet-x9-sdk-infra | 230 | 237 | +7 | approved |
| tweet-x10-raydium-lp | 262 | 264 | +2 | review |
| tweet-x11-lending-teaser | 227 | 225 | -2 | review |
| tweet-x12-post-halving | 269 | 234 | -35 | review |
| tweet-x13-dtao-dynamics | 245 | 244 | -1 | review |
| tweet-x14-tao-ai-mindshare | 275 | 260 | -15 | review |
| tweet-x15-bridge-howto | 230 | 233 | +3 | review |
| tweet-x16-staking-explainer | 221 | 224 | +3 | review |
| tweet-x17-crosschain-alpha | 271 | 233 | -38 | review |
| tweet-x18-sn106-rank | 224 | 227 | +3 | review |

## Notable Flags

**Over 280 characters (X/Twitter limit concern):**
- satellite-s6-ecosystem-sn106: 298 chars
- satellite-s7-defi-liquidity: 312 chars
- satellite-s8-defi-security: 359 chars
- qt-x5-altcoinbuzz: 280 chars (at limit)
- qt-x6-subnetedge: 282 chars

These 5 posts exceed or are at the X/Twitter 280-character limit. Content should be trimmed before posting if these are single tweets. Note: some platforms allow longer posts (280 is X standard, but X Premium/Blue allows longer).

## Verification

Post-fix verification confirmed 50/50 files pass (0 remaining mismatches).
