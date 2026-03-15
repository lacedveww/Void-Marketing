# Phase 2: Manifest Regeneration & Double-Hyphen Cleanup

**Date**: 2026-03-15
**Agent**: Claude Opus 4.6 (1M context)

---

## Task 1: Manifest Regeneration

### Summary

Regenerated `/companies/voidai/queue/manifest.json` from version 2 to version 3. Added 13 new items created by the Phase 2 Strategy Challenger agent.

### Changes

- **Version**: 2 -> 3
- **Approved count**: 50 -> 63
- **Rejected count**: 1 (unchanged, bridge test item)
- **last_updated**: 2026-03-15T20:03:50Z
- **dry_run_mode**: true (unchanged)

### New Items Added (13)

| ID | Platform | Account | Pillar | Content Type | Priority |
|----|----------|---------|--------|-------------|----------|
| e1-defi-barrier-poll | x | v0idai | ecosystem-intelligence | poll | 5 |
| e2-hot-take-liquidity | x | v0idai | ecosystem-intelligence | single | 5 |
| e3-next-chain-question | x | v0idai | bridge-build | single | 5 |
| e4-dtao-open-question | x | v0idai | ecosystem-intelligence | single | 5 |
| satellite-s15-fanpage-lending-hype | x | fanpage-satellite | bridge-build | single | 5 |
| satellite-s16-ecosystem-dtao-flows | x | bittensor-ecosystem-satellite | ecosystem-intelligence | single | 5 |
| satellite-s17-defi-bridge-volume | x | defi-crosschain-satellite | ecosystem-intelligence | single | 5 |
| satellite-s18-aicrypto-subnet-economics | x | ai-crypto-satellite | alpha-education | single | 5 |
| satellite-s19-meme-subnet-personality | x | meme-culture-satellite | community-culture | single | 5 |
| satellite-s20-fanpage-ecosystem-credibility | x | fanpage-satellite | alpha-education | single | 5 |
| ss1-subnet-spotlight-chutes-sn64 | x | v0idai | ecosystem-intelligence | thread | 3 |
| ss2-subnet-spotlight-targon-sn4 | x | v0idai | ecosystem-intelligence | thread | 3 |
| ss3-subnet-spotlight-openkaito-sn5 | x | v0idai | ecosystem-intelligence | single | 5 |

### Updated Pillar Distribution

| Pillar | Old Count | New Count | Old % | New % | Target % |
|--------|-----------|-----------|-------|-------|----------|
| bridge-build | 22 | 24 | 44.0% | 38.1% | 40% |
| ecosystem-intelligence | 11 | 19 | 22.0% | 30.16% | 25% |
| alpha-education | 12 | 14 | 24.0% | 22.22% | 25% |
| community-culture | 5 | 6 | 10.0% | 9.52% | 10% |

**Note**: The Challenger heavily weighted ecosystem-intelligence (8 of 13 new items), bringing it above target at 30.16% vs 25% target. Bridge-build dropped from 44% to 38.1%, now closer to the 40% target. Alpha-education and community-culture are both slightly below their targets.

### Rejected Items

1 rejected item retained: `20260313-180000-x-v0idai-bridge-test` (rejection reason: "Too general, no information or value.")

---

## Task 2: Double-Hyphen Cleanup

### Rule

No ` -- ` (space-hyphen-hyphen-space) anywhere in published content, editor notes, or frontmatter comments. Exceptions: YAML structural separators (---), markdown table column separators (|---|), and table cells showing "no data" or "not applicable."

### Replacements Made

Total replacements: **168 occurrences across 33 files**

#### Queue Approved Files (19 files, 38 replacements)

| File | Count | Replacement Pattern |
|------|-------|-------------------|
| 20260313-discord-d2-what-is-voidai.md | 5 | colons, commas for inline annotations |
| 20260313-tweet-x14-tao-ai-mindshare.md | 1 | colon for register description |
| 20260313-blog-b1-what-is-voidai.md | 2 | comma for priority comment, period for data refresh note |
| 20260313-datacard-dc1-daily-metrics.md | 3 | periods for design notes, parentheses for compliance note |
| 20260313-tweet-x17-crosschain-alpha.md | 1 | colon for register description |
| 20260313-blog-b2-how-to-bridge-tao.md | 1 | comma for priority comment |
| 20260313-blog-b3-bittensor-cross-chain-defi.md | 4 | comma/period for compliance and positioning notes |
| 20260313-lt2-lending-teaser-2.md | 2 | colon for title, period for design note |
| 20260313-tweet-x9-sdk-infra.md | 1 | colon for register description |
| 20260313-qt-x6-subnetedge.md | 2 | parentheses and period for attribution notes |
| 20260313-lt3-lending-teaser-3.md | 5 | periods and commas for strategy/compliance notes |
| 20260313-tweet-x10-raydium-lp.md | 1 | colon for mechanism description |
| 20260313-linkedin-l1-company-intro.md | 2 | commas for audience/compliance notes |
| 20260313-tweet-x12-post-halving.md | 1 | colon for register description |
| 20260313-linkedin-l3-halving-analysis.md | 2 | colon and comma for compliance notes |
| 20260313-discord-d1-welcome.md | 1 | colon for action note |
| 20260313-thread-t1-what-is-voidai.md | 2 | comma for priority, period for data note |
| 20260313-lt1-lending-teaser-1.md | 2 | colon for title, period for strategy note |
| 20260313-linkedin-l4-chainlink-ccip-choice.md | 2 | comma for compliance note, period for data note |
| 20260313-thread-t3-bittensor-post-halving.md | 2 | commas for compliance notes |
| 20260313-qt-x5-altcoinbuzz.md | 2 | period for source/differentiation notes |
| 20260313-linkedin-l2-bridge-technical.md | 2 | period for data notes |
| 20260315-satellite-s20-fanpage-ecosystem-credibility.md | 1 | period for data note |

#### Brand Files (3 files, 83 replacements)

| File | Count | Notes |
|------|-------|-------|
| voice-learnings.md | 69 | Templates, voice analysis, calibration notes, terminology lists. Replaced with colons, periods, commas, equals signs, and parentheses as contextually appropriate |
| engagement-frameworks.md | 12 | Reply templates, DM templates, rules. Replaced with periods, commas |
| README.md | 2 | File path descriptions. Replaced with colons |

#### Engine Files (17 files, 47 replacements)

| File | Count | Notes |
|------|-------|-------|
| frameworks/voice-calibration-loop.md | 7 | File hierarchy, process notes |
| templates/x-thread.md | 3 | Content placeholders |
| compliance/modules/saas-gdpr.md | 1 | Consent behavior note |
| automations/lead-nurturing-template.md | 4 | Touch descriptions |
| frameworks/satellite-account-pattern.md | 3 | Account requirements, cadence |
| compliance/modules/crypto-ofac.md | 1 | Legal note |
| templates/slide-deck.md | 4 | Tier comment, placeholders |
| templates/x-reply.md | 1 | Content placeholder |
| frameworks/engagement-framework-template.md | 4 | Philosophy, rules |
| templates/infographic.md | 5 | Placeholders and design briefs |
| templates/podcast-notebooklm.md | 6 | Tier comment, topic, promotion placeholders |
| templates/video-script.md | 3 | Tier comment, concept, visual |
| compliance/modules/crypto-sec.md | 8 | Prohibited language table, disclaimer |
| templates/image-social-graphic.md | 6 | Variant list, prompt fields |
| templates/image-content-hero.md | 3 | Tier comment, variant list, alt text |
| frameworks/crisis-protocol-template.md | 2 | Approval note, satellite rule |
| templates/video-google-veo.md | 8 | Duration/format comments, variants, prompt, checklist |
| templates/discord-announcement.md | 2 | Body and CTA placeholders |
| templates/linkedin-post.md | 2 | Content and CTA placeholders |
| templates/x-single.md | 1 | Content placeholder |
| templates/x-quote-tweet.md | 1 | Content placeholder |
| templates/data-card.md | 1 | Freshness comment |
| templates/blog-post.md | 2 | Title and hook placeholders |
| compliance/base-rules.md | 1 | Updated rule to ban double hyphens alongside em dashes |
| compliance/platform-policies.md | 1 | Schema markup note |
| compliance/data-handling-base.md | 2 | Cache and AI API notes |

### Exceptions Preserved (not replaced)

| File | Line | Reason |
|------|------|--------|
| 20260313-datacard-dc1-daily-metrics.md | 74-75 | Table cells: "no data" indicator for Bridge Uptime and Chains Supported change columns |
| video-google-veo.md | 103-104, 113 | Table cells: "not applicable" for max size and transition columns |
| voice-learnings.md | 546 | Rule definition text referencing the banned pattern itself |
| base-rules.md | 78 | Compliance rule definition referencing the banned pattern itself |

### Additional Fix: base-rules.md Contradiction

The original `engine/compliance/base-rules.md` line 78 said: "Use commas, periods, colons, or double hyphens (--) instead." This contradicted the em-dash ban by recommending double hyphens as a replacement. Updated to: "Never use em dashes or double hyphens ( -- ) anywhere in content. Use commas, periods, colons, or line breaks instead."

---

## Verification

Final grep for ` -- ` across all three directory trees returned only the documented exceptions listed above. All content, editor notes, and frontmatter comments are clean.
