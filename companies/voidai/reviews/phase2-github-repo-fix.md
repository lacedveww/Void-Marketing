# Phase 2: GitHub Repository Count Fix

**Date:** 2026-03-15
**Issue:** Content across 11 queue files and company.md claimed "34 public repositories" or "open source across 34 repos" at github.com/v0idai. This was inaccurate. VoidAI has 34 total repositories, but only 2 are public (SN106 and SubnetsBot). The remaining 32 are private. Publishing the original claims would have been verifiably false.

**Fix applied:** Removed all "34 repos" counts from published content. Replaced with accurate framing that references open source code without implying all repos are public. Kept github.com/v0idai link in all cases.

---

## Files Modified

### 1. company.md (config)
- **Path:** `companies/voidai/company.md`
- **Change:** `Repo count: 34` changed to `Repo count: 34 total (2 public: SN106, SubnetsBot; 32 private)`
- **Reason:** Source of truth for all content. Must reflect accurate breakdown.

### 2. b1-what-is-voidai (blog)
- **Path:** `queue/approved/20260313-blog-b1-what-is-voidai.md`
- **Changes (3 locations):**
  - "open source and auditable across 34 public repositories on github.com/v0idai" -> "Core protocol code is open source and auditable at github.com/v0idai"
  - "All contracts are open source across 34 repositories. Audit them yourself" -> "All contracts are open source. Audit them yourself"
  - "development is active across 34 open source repositories:" -> "development is active. Core protocol code is open source:"
- **character_count:** 12640 -> 12592
- **Editor note:** DATA REFRESH NEEDED replaced with FIXED note

### 3. b2-how-to-bridge-tao (blog)
- **Path:** `queue/approved/20260313-blog-b2-how-to-bridge-tao.md`
- **Change:** "All contracts are open source across 34 repositories at github.com/v0idai" -> "Core protocol code is open source at github.com/v0idai"
- **character_count:** 10659 -> 10640
- **Editor note:** DATA REFRESH NEEDED replaced with FIXED note

### 4. b3-bittensor-cross-chain-defi (blog)
- **Path:** `queue/approved/20260313-blog-b3-bittensor-cross-chain-defi.md`
- **Change:** "github.com/v0idai (34 public repos)" -> "github.com/v0idai"
- **character_count:** 11944 -> 11926
- **Editor note:** DATA REFRESH NEEDED replaced with FIXED note

### 5. t1-what-is-voidai (X thread)
- **Path:** `queue/approved/20260313-thread-t1-what-is-voidai.md`
- **Change (Part 3):** "Open source across 34 repos: github.com/v0idai" -> "Open source: github.com/v0idai"
- **character_count:** Unchanged (223 is for Part 1, not Part 3)
- **Editor note:** DATA REFRESH NEEDED replaced with FIXED note

### 6. t2-bridge-tao-howto (X thread)
- **Path:** `queue/approved/20260313-thread-t2-bridge-tao-howto.md`
- **Change (Part 6):** "34 open-source repos: github.com/v0idai" -> "Open source: github.com/v0idai"
- **updated_at:** 2026-03-13 -> 2026-03-15
- **character_count:** Unchanged (173 is for Part 1, not Part 6)
- **Editor note:** DATA REFRESH NEEDED replaced with FIXED note

### 7. t4-sn106-explained (X thread)
- **Path:** `queue/approved/20260313-thread-t4-sn106-explained.md`
- **Change (Part 8):** "34 open-source repos. Non-custodial." -> "Open source: github.com/v0idai. Non-custodial."
- **character_count:** Unchanged (214 is for Part 1, not Part 8)
- **Editor note:** DATA REFRESH NEEDED replaced with FIXED note

### 8. d2-what-is-voidai (Discord)
- **Path:** `queue/approved/20260313-discord-d2-what-is-voidai.md`
- **Changes (3 locations):**
  - Content: "There are 34 repos in the VoidAI GitHub org." -> "Core protocol code is open source at github.com/v0idai."
  - Strategy comment: "34 repos in GitHub org" -> "Core protocol code open source at github.com/v0idai (2 public repos: SN106, SubnetsBot)"
  - Verification comment: "GitHub repo count (currently 34: confirm via github.com/v0idai)" -> "GitHub public repos (2 public: SN106, SubnetsBot at github.com/v0idai)"
- **character_count:** 1415 -> 1427
- **Editor note:** DATA REFRESH NEEDED replaced with FIXED note

### 9. l1-company-intro (LinkedIn)
- **Path:** `queue/approved/20260313-linkedin-l1-company-intro.md`
- **Change:** "Open source across 34 repositories at github.com/v0idai." -> "Open source: github.com/v0idai."
- **character_count:** 2314 -> 2289
- **Editor note:** DATA REFRESH NEEDED replaced with FIXED note

### 10. x4-systango (X quote tweet)
- **Path:** `queue/approved/20260313-qt-x4-systango.md`
- **Change:** "34 repos. All open source. Read the code, not just the article." -> "Open source. Read the code, not just the article: github.com/v0idai"
- **character_count:** 251 -> 255
- **updated_at:** 2026-03-13 -> 2026-03-15
- **Editor note:** DATA REFRESH NEEDED replaced with FIXED note

### 11. x9-sdk-infra (X tweet)
- **Path:** `queue/approved/20260313-tweet-x9-sdk-infra.md`
- **Change:** "34 repos on GitHub. Open-source, non-custodial, permissionless." -> "Open source, non-custodial, permissionless."
- **character_count:** 237 -> 218
- **updated_at:** 2026-03-13 -> 2026-03-15
- **Editor note:** DATA REFRESH NEEDED replaced with FIXED note

### 12. s20-fanpage-ecosystem-credibility (X satellite)
- **Path:** `queue/approved/20260315-satellite-s20-fanpage-ecosystem-credibility.md`
- **Change:** "34 repos on github. SDK in python and typescript." -> "SDK in python and typescript. audited contracts. chainlink CCIP integration. code is public on github."
- **character_count:** 210 -> 216
- **Editor note:** DATA REFRESH NEEDED replaced with FIXED note. Strategy comment updated to remove "34 repos" reference.

---

## Files NOT modified (review/reference files with "34 repos" mentions)

The following review and planning files reference "34 repos" in analytical context (audits, strategy plans, verification reports). These are internal reference documents, not publishable content, so they were left as-is. Their references serve as historical record of the original error and correction process:

- `reviews/phase2-data-verification.md` (documents the finding)
- `reviews/phase2-data-fixes-changelog.md` (documents earlier partial fix)
- `reviews/phase1a-plan-content-strategy.md` (strategy reference)
- `reviews/phase1a-plan-improvements.md` (strategy reference)
- `reviews/phase1a-plan-website-seo.md` (SEO planning)
- `reviews/website-seo-recommendations.md` (SEO planning)
- `reviews/step2-seomachine-install.md` (tool config reference)
- `reviews/phase2-voice-quality-CHALLENGER.md` (audit reference)
- `reviews/phase2-strategy-sequencing-audit.md` (audit reference)
- `reviews/security-compliance-audit.md` (audit reference, refers to marketingskills fork, not VoidAI repos)
- `roadmap/voidai-marketing-roadmap.md` (roadmap reference)
- `roadmap/staged-implementation-breakdown.md` (refers to marketingskills fork, not VoidAI repos)

## Verification

After all edits, a grep for `34 repo|34 public|across 34|34 open` in `queue/approved/` returns only HTML comment editor notes marked as FIXED. Zero instances remain in publishable content.
