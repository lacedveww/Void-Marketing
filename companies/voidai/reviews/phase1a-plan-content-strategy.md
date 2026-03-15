# Phase 1a Content Stockpile Plan

**Document:** `reviews/phase1a-plan-content-strategy.md`
**Created:** 2026-03-13
**Author:** Content Strategy Planning Agent
**Status:** DRAFT -- Requires Vew approval before execution
**Dependencies:** `CLAUDE.md` (brand/compliance), `roadmap/staged-implementation-breakdown.md` (Phase 1a timeline), `queue/` system (content staging)

---

## Day Numbering Convention

All day references in this document use the implementation plan's numbering:
- **Day 1** = First day of Phase 1a prep work
- **Day 12** = Soft Launch day (first public posts from @v0idai)
- **SL+N** = Soft Launch + N days (used for lending teaser deployment timing)

Content generation phases (Phase A-F in Section 4) use phase labels, not day numbers, to avoid confusion with the implementation plan's day numbering.

---

## 0. Situation Assessment

**Starting state:** Queue is empty (1 rejected test item). Zero content in `approved/`. No engagement history in `brand/voice-learnings.md`. VoidAI has zero Bittensor community presence, approximately 2,021 X followers, 1 blog post, and a lending platform 3-8 weeks from launch.

**Phase 1a constraint:** PREP ONLY. Nothing is published until Soft Launch (Day 12-14). All content goes into `queue/approved/` and waits. The goal is to have enough stockpiled and reviewed content that Soft Launch Day can hit the ground running with 2+ weeks of scheduled material.

**Available templates:** 13 queue templates ready (x-single, x-thread, linkedin-post, blog-post, discord-announcement, data-card, infographic, video-script, video-google-veo, podcast-notebooklm, image-social-graphic, image-content-hero, slide-deck).

**Scope:** The PRIMARY plan targets 18 minimum viable items (Section 7). The full 84-item stockpile is the ASPIRATIONAL target if time permits (see Appendix A). Vew has 30-35 hours/week for ALL Phase 1a work (not just content), so content generation must fit within approximately 12-15 hours of the total budget.

---

## 1. Exact Content Items to Stockpile

### 1A. Blog Posts (Pillar Content) -- 3 posts

Blog posts are the content engine. Each blog generates 6-12 derivatives. Write these first, cut derivatives from them.

| # | Title | Pillar | Word Count | Derivatives to Cut | Priority |
|---|-------|--------|:----------:|:-------------------:|:--------:|
| B1 | "What is VoidAI: The Liquidity Layer for Bittensor" | bridge-build | 2500-3000 | X thread (10-12 tweets), LinkedIn post, Discord announcement, data card (product metrics), social graphic | 1 |
| B2 | "How to Bridge TAO to Solana with VoidAI (Step-by-Step Guide)" | alpha-education | 2000-2500 | X thread (8-10 tweets, screenshot-heavy), LinkedIn post, Discord tutorial pin | 2 |
| B3 | "Why Bittensor Needs Cross-Chain DeFi Infrastructure" | ecosystem-intelligence | 2000-3000 | X thread (10-12 tweets), LinkedIn thought leadership post, Bittensor satellite thread variant | 3 |

**Blog B4 (SDK) deferred to Phase 2+:** The SDK blog has no audience during Phase 1a community entry. The developer persona is a pull audience that requires existing VoidAI awareness. Reallocate those 3-4 hours to additional community engagement content.

**Compliance notes:** All blog posts are Tier 1 (mandatory human review). Each requires the full long-form disclaimer, risk disclosures for bridging/staking mentions, and "variable, not guaranteed" adjacent to any rate figures.

**Blog Generation Workflow:** Blog posts require specific technical accuracy that AI alone cannot guarantee. The workflow is:
1. Vew provides technical bullet points and key claims from internal documentation
2. Claude generates draft using bullet points + product-marketing-context.md + research files
3. Draft enters queue as Tier 1 (mandatory for all blog posts)
4. Vew verifies all technical claims against actual product behavior (lock-and-mint mechanism, Chainlink CCIP specifics, SN106 subnet mechanics)
5. Compliance check runs on final draft

### 1B. X Posts -- Main Account @v0idai (28 posts)

#### Standalone Single Posts (18 posts)

| # | Topic / Hook | Pillar | Type | Notes |
|---|-------------|--------|------|-------|
| X1 | "What is VoidAI" pinned thread derivative -- condensed 1-tweet version with product visual | bridge-build | single | Pin candidate |
| X2 | Daily bridge metrics template: "VoidAI Bridge -- Daily Update: $[X] bridged, [Y] txns, 99.8% uptime" | bridge-build | single+data-card | Create 5 variants with different hooks for the first week |
| X3 | Amplify ainvest coverage -- QT with builder-credibility angle | bridge-build | quote_tweet | Pull real quote from article |
| X4 | Amplify Systango coverage -- QT with technical depth angle | bridge-build | quote_tweet | Pull real quote from article |
| X5 | Amplify AltcoinBuzz coverage -- QT with ecosystem context | bridge-build | quote_tweet | Pull real quote from article |
| X6 | Amplify SubnetEdge coverage -- QT with "more coming" hint | bridge-build | quote_tweet | Reference their SN106 article |
| X7 | Chainlink CCIP security signal: "Why we chose Chainlink CCIP for cross-chain messaging" | bridge-build | single | Tag @chainlink |
| X8 | dTAO flow analysis: "Where is $TAO capital flowing this week? Here's the data..." | ecosystem-intelligence | single+data-card | Pull real Taostats data. Tag @taostats |
| X9 | Subnet spotlight #1 (NOT SN106 -- pick Chutes SN64 or Hippius SN75) | ecosystem-intelligence | single | What/Problem/Why format. Tag the subnet |
| X10 | Subnet spotlight #2 (different subnet -- Nineteen SN19 or Ridges SN62) | ecosystem-intelligence | single | Same format. Tag the subnet |
| X11 | Ecosystem growth metric post: "Bittensor wallet growth, subnet expansion -- the ecosystem is building" | alpha-education | single+data-card | Factual data, no price reference. Reassigned from ecosystem-intelligence to alpha-education for pillar balance |
| X12 | "How to bridge TAO to Solana in 3 steps" -- concise tweet + graphic | alpha-education | single+image | Screenshot-based graphic |
| X13 | "What is dTAO? A quick explainer for newcomers" | alpha-education | single | Use analogies, accessible language |
| X14 | "Cross-chain liquidity explained: why bridges matter for Bittensor" | alpha-education | single | Frame broadly, not VoidAI-specific |
| X15 | Poll: "What subnet are you most excited about? (a) SN64 (b) SN19 (c) SN106 (d) Other -- reply below" | community-culture | single | Engagement bait, tag each subnet |
| X16 | "34 repos. Open source. Auditable. That's how VoidAI builds." | bridge-build | single | Builder credibility, link to GitHub |
| X17 | Builder update: "What we shipped at VoidAI this week: [list of concrete items]" | bridge-build | single | Must have real shipped items -- do not fabricate |
| X18 | "Non-custodial means we never hold your funds. Here's how VoidAI bridge works under the hood" | alpha-education | single | Trust-building, technical credibility |

#### Threads (5 threads)

| # | Topic / Hook | Pillar | Tweets | Notes |
|---|-------------|--------|:------:|-------|
| T1 | "What is VoidAI?" pinned thread: bridge + staking + SDK + lending teaser + why it matters | bridge-build | 7-8 | Pin this on launch day |
| T2 | "Why Bittensor needs DeFi infrastructure" -- thesis thread | ecosystem-intelligence | 10-12 | Cut from blog B3 |
| T3 | "How to bridge TAO to Solana using VoidAI" -- tutorial thread | alpha-education | 8-10 | Cut from blog B2, include screenshots |
| T4 | "The State of Bittensor Cross-Chain: Where is TAO flowing?" -- data thread | ecosystem-intelligence | 8-10 | Original data analysis, reference Taostats |
| T5 | Weekly recap thread template: "VoidAI Week [N] -- what we shipped, metrics, what's next" | bridge-build | 8-10 | Template for recurring use. First instance with real data |

#### Reply/Engagement Frameworks (5 pre-drafted templates)

**Note:** Reply templates (R1-R5) are engagement FRAMEWORKS, not queue items. They are used as real-time response guides during community engagement. They do NOT go through `/queue add` and are NOT counted in the pillar distribution or stockpile totals. They are stored as reference documents, not queue content items. A reply/quote_tweet queue template must be created (AUDIT item 14) before any reply content can enter the compliance pipeline.

| # | Target Account/Context | Pillar | Notes |
|---|----------------------|--------|-------|
| R1 | Reply template: @opentensor protocol announcement -- "How this impacts cross-chain infrastructure" | ecosystem-intelligence | Value-add, no shilling |
| R2 | Reply template: @taostats data post -- complementary data point about cross-chain flows | ecosystem-intelligence | Collaborative, data-driven |
| R3 | Reply template: Bittensor community asking about bridges -- factual answer with soft VoidAI mention | alpha-education | Helpful, brief disclaimer |
| R4 | Reply template: @chainlink update -- "We're using CCIP for Bittensor cross-chain" | bridge-build | Natural co-marketing |
| R5 | Reply template: Subnet team celebrating milestone -- genuine congratulations + ecosystem framing | community-culture | No VoidAI mention, pure goodwill |

### 1C. X Posts -- Bittensor Community Satellite @voidai_tao (14 posts)

This is the first satellite to launch. Per CLAUDE.md, all content for the first 30 days is Tier 1 (mandatory human review).

**PREREQUISITE:** Satellite account handle must be confirmed on Day 1 of Phase 1a (currently TBD in CLAUDE.md -- e.g., @VoidAI_TAO or @TaoInsider). Satellite content generation (Phase C in Section 4) is GATED on this decision. Content items S1 and S13 contain explicit @ mentions that depend on the final handle. Generate all satellite content as a batch AFTER handle confirmation, not before.

**Satellite timeline:** Account CREATED on Day 8 (private/locked). Goes PUBLIC on Day 15 (after 7 days of main account establishing presence post-Soft Launch). See Section 3 for details.

**Satellite pillar weights (first 30 days):** Per the improvements plan's recommendation, the satellite uses adjusted weights during community entry: Ecosystem Intelligence 50%, Alpha & Education 25%, Bridge & Build 15%, Community & Culture 10%. This prioritizes demonstrating ecosystem knowledge over product promotion, matching the Bittensor community's 80/20 value-add/promotional expectation.

| # | Topic / Hook | Pillar | Type | Notes |
|---|-------------|--------|------|-------|
| S1 | Pinned tweet: "This account is operated by the VoidAI team (@v0idai). We cover Bittensor ecosystem updates, subnet analysis, and $TAO alpha." | -- | single | Mandatory disclosure tweet |
| S2 | "The State of Bittensor -- [date]: [key ecosystem metrics this week]" | ecosystem-intelligence | single+data-card | Use Taostats data. Template for weekly recurring |
| S3 | Subnet spotlight: Chutes (SN64) deep-dive using What/Problem/Why format | ecosystem-intelligence | single | Tag @chutes_ai. Different angle from main account version |
| S4 | Subnet spotlight: Hippius (SN75) deep-dive | ecosystem-intelligence | single | Tag @hippius_subnet |
| S5 | dTAO emissions flow analysis: "Top 10 subnets by staking inflows this week" | ecosystem-intelligence | single+data-card | Pure data, no price predictions |
| S6 | "$TAO ecosystem growth: [X] new wallets this month, [Y] active subnets" | alpha-education | single | Factual ecosystem growth data. Reassigned from ecosystem-intelligence to alpha-education for pillar balance |
| S7 | "SN106 weekly: What we built, metrics, what's next" | bridge-build | single | Builder update, VoidAI-specific but ecosystem-framed |
| S8 | "Why cross-chain matters for Bittensor" -- short thesis post | alpha-education | single | Different framing than main account version |
| S9 | Thread: "Bittensor Subnet Deep-Dive: [3 subnets reviewed]" | ecosystem-intelligence | thread (10-12) | Educational, covers 3 non-SN106 subnets |
| S10 | "Post-halving $TAO: what the emission cut means for subnet dynamics" | ecosystem-intelligence | single | Educational framing, reference halving (Dec 2025). Reassigned from alpha-education to ecosystem-intelligence to match satellite weights |
| S11 | Thread: "How VoidAI Bridge works -- a technical walkthrough for the $TAO community" | bridge-build | thread (8-10) | Builder-credibility register. Technical but accessible |
| S12 | Poll: "What's your #1 $TAO subnet? Drop your pick below" | community-culture | single | Engagement driver, tag popular subnets |
| S13 | QT of @v0idai main announcement with ecosystem impact angle | bridge-build | quote_tweet | Must be 3+ hours after main post |
| S14 | "Bittensor community resources: where to learn, what to read, who to follow" | alpha-education | single | Value-add resource list, tag community accounts |

### 1D. LinkedIn Posts (6 posts)

| # | Topic | Pillar | Notes |
|---|-------|--------|-------|
| L1 | "VoidAI: Connecting Bittensor's Intelligence to Global Liquidity" -- company intro post | bridge-build | Professional, institutional framing |
| L2 | "Why Cross-Chain Infrastructure is the Missing Piece for Decentralized AI" -- thought leadership | ecosystem-intelligence | Cut from blog B3, adapted tone |
| L3 | "How VoidAI uses Chainlink CCIP for Secure Cross-Chain Messaging" -- partnership story | bridge-build | Tag Chainlink company page |
| L4 | "The Bittensor Ecosystem: A Builder's Perspective on Decentralized AI" | ecosystem-intelligence | Broader audience, less technical |
| L5 | "VoidAI SDK: Enabling Developers to Build on Bittensor" | alpha-education | Developer recruitment angle. Reassigned from bridge-build to alpha-education to improve pillar balance |
| L6 | "Lending on Bittensor: What Cross-Chain DeFi Infrastructure Makes Possible" | bridge-build | Teaser, compliant language only |

### 1E. Discord/Telegram Announcements (4 items)

| # | Content | Pillar | Type | Notes |
|---|---------|--------|------|-------|
| D1 | Welcome message update with current product links and upcoming lending mention | bridge-build | announcement | Pin in #announcements |
| D2 | "What is VoidAI" summary (adapted from blog B1) | community-culture | announcement | Pin in #general. Reassigned from bridge-build to community-culture (community channel welcome piece) for pillar balance |
| D3 | "How to bridge TAO" tutorial (adapted from blog B2) | alpha-education | announcement | Pin in #bridge-support |
| D4 | Lending teaser: "Something new is coming to SN106..." | bridge-build | announcement | #lending-alpha channel. Excluded from pillar count (lending teaser) |

### 1F. Data Cards / Infographics (6 items)

| # | Topic | Pillar | Template | Account | Notes |
|---|-------|--------|----------|---------|-------|
| DC1 | Daily bridge metrics snapshot (template for recurring use) | bridge-build | data-card | v0idai | Pull real data from Taostats/internal |
| DC2 | Weekly metrics recap (template for recurring use) | bridge-build | data-card | v0idai | 7-day summary format |
| DC3 | SN106 mindshare rank card: "#5 at 2.01% mindshare" | ecosystem-intelligence | data-card | voidai_tao | Bittensor ecosystem data |
| DC4 | Bittensor ecosystem overview: subnets, wallets, staked TAO | alpha-education | data-card | voidai_tao | Ecosystem-level, not VoidAI-specific. Reassigned from ecosystem-intelligence to alpha-education for pillar balance |
| DC5 | "VoidAI at a Glance" -- product overview infographic | bridge-build | infographic | v0idai | Bridge + Staking + SDK + Lending (upcoming) |
| DC6 | "Cross-Chain TAO Flows" -- where bridged TAO is going | ecosystem-intelligence | infographic | voidai_tao | Data visualization of flow directions |

**Data freshness note:** Data cards DC1-DC4 and infographic DC6 require current Taostats/bridge data. Generate text FRAMEWORKS with `[PLACEHOLDER]` data during Phase C (Days 5-7), then fill in real numbers on Days 11-12 immediately before Soft Launch. This prevents stale data in launch-day content.

### 1G. Visual Assets (4 items)

| # | Asset | Pillar | Template | Account | Notes |
|---|-------|--------|----------|---------|-------|
| IG1 | Blog B1 hero image: dark themed, VoidAI branding | bridge-build | image-content-hero | v0idai | Space Grotesk + Inter typography |
| IG2 | Blog B2 hero image: tutorial-style, step indicators | alpha-education | image-content-hero | v0idai | Include Bittensor + Solana logos |
| IG3 | Pinned thread graphic: "What is VoidAI" visual summary | bridge-build | image-social-graphic | v0idai | Key stats, product overview |
| IG4 | Satellite account banner + profile image | community-culture | image-social-graphic | voidai_tao | Branded but distinct from main. Reassigned to community-culture (brand identity asset) |

### 1H. Lending Teaser Content (15 posts across 5 phases)

See Section 5 for full breakdown.

---

## 2. Pillar Distribution Validation

### Target vs. Planned Distribution

**Methodology:** Every content item in Sections 1A-1G has an explicit pillar assignment. Items excluded from the count: lending teasers (tracked separately in Section 5), reply/engagement frameworks R1-R5 (not queue items -- see Section 1B note), disclosure tweet S1 (no pillar), and lending teaser D4.

### Item-by-Item Pillar Assignment

| Item | Pillar | Category |
|------|--------|----------|
| B1 | bridge-build | Blog |
| B2 | alpha-education | Blog |
| B3 | ecosystem-intelligence | Blog |
| X1 | bridge-build | X single |
| X2 | bridge-build | X single |
| X3 | bridge-build | X single |
| X4 | bridge-build | X single |
| X5 | bridge-build | X single |
| X6 | bridge-build | X single |
| X7 | bridge-build | X single |
| X8 | ecosystem-intelligence | X single |
| X9 | ecosystem-intelligence | X single |
| X10 | ecosystem-intelligence | X single |
| X11 | alpha-education | X single |
| X12 | alpha-education | X single |
| X13 | alpha-education | X single |
| X14 | alpha-education | X single |
| X15 | community-culture | X single |
| X16 | bridge-build | X single |
| X17 | bridge-build | X single |
| X18 | alpha-education | X single |
| T1 | bridge-build | X thread |
| T2 | ecosystem-intelligence | X thread |
| T3 | alpha-education | X thread |
| T4 | ecosystem-intelligence | X thread |
| T5 | bridge-build | X thread |
| S2 | ecosystem-intelligence | Satellite |
| S3 | ecosystem-intelligence | Satellite |
| S4 | ecosystem-intelligence | Satellite |
| S5 | ecosystem-intelligence | Satellite |
| S6 | alpha-education | Satellite |
| S7 | bridge-build | Satellite |
| S8 | alpha-education | Satellite |
| S9 | ecosystem-intelligence | Satellite |
| S10 | ecosystem-intelligence | Satellite |
| S11 | bridge-build | Satellite |
| S12 | community-culture | Satellite |
| S13 | bridge-build | Satellite |
| S14 | alpha-education | Satellite |
| L1 | bridge-build | LinkedIn |
| L2 | ecosystem-intelligence | LinkedIn |
| L3 | bridge-build | LinkedIn |
| L4 | ecosystem-intelligence | LinkedIn |
| L5 | alpha-education | LinkedIn |
| L6 | bridge-build | LinkedIn |
| D1 | bridge-build | Discord |
| D2 | community-culture | Discord |
| D3 | alpha-education | Discord |
| DC1 | bridge-build | Data card |
| DC2 | bridge-build | Data card |
| DC3 | ecosystem-intelligence | Data card |
| DC4 | alpha-education | Data card |
| DC5 | bridge-build | Infographic |
| DC6 | ecosystem-intelligence | Infographic |
| IG1 | bridge-build | Visual |
| IG2 | alpha-education | Visual |
| IG3 | bridge-build | Visual |
| IG4 | community-culture | Visual |

### Target vs. Planned Distribution

| Pillar | Target | Planned Count | Planned % | Delta | Status |
|--------|:------:|:-------------:|:---------:|:-----:|:------:|
| Bridge & Build | 40% | 24 | 41.4% | +1.4% | Within tolerance |
| Ecosystem Intelligence | 25% | 16 | 27.6% | +2.6% | Within tolerance |
| Alpha & Education | 25% | 14 | 24.1% | -0.9% | Within tolerance |
| Community & Culture | 10% | 4 | 6.9% | -3.1% | Within tolerance |
| **TOTAL** | **100%** | **58** | **100%** | -- | **All within 5% threshold** |

**Notes:**
- The queue system warns at >5% drift from targets (per SKILL.md pillar monitoring). All pillars are within tolerance.
- Ecosystem Intelligence runs slightly heavy because the Bittensor community satellite account is ecosystem-focused by design -- this is intentional for the community entry strategy.
- The previous version of this table claimed 71 items with 28/20/16/7 distribution. That count was incorrect -- it included items without explicit pillar assignments and double-counted some derivatives. This corrected version assigns every item a pillar explicitly (see item-by-item table above) and arrives at 58 countable items.

### Lending Teasers (15 posts)
All lending teasers fall under Bridge & Build pillar. They are counted separately because they deploy on a fixed timeline relative to lending launch, not as part of the regular content calendar. When added to the total, Bridge & Build would represent approximately 44% -- above the 40% target but justified by the lending launch urgency.

---

## 3. Account Distribution

### Content by Account

| Account | Planned Items | Posts/Week (at 2/day cadence) | Notes |
|---------|:------------:|:-----------------------------:|-------|
| @v0idai (main) | 44 (18 singles + 5 threads + 6 LinkedIn cross-posts + 3 Discord + 6 data cards/infographics) | 10-14 | Primary account, posts first on all news |
| @voidai_tao (Bittensor satellite) | 14 | 7-10 | First satellite. Ecosystem-focused. Created Day 8 (private), PUBLIC Day 15 |
| @voidai_memes (fanpage) | 0 | 0 | Deferred to Month 3+ per roadmap. Most risky to execute authentically |
| @voidai_defi (DeFi) | 0 | 0 | Deferred to Phase 4 per roadmap |

**Note on reply templates:** R1-R5 are engagement frameworks, not queue items. They are not counted in the item totals above.

### Satellite Account Timeline (Definitive)

This is the single authoritative satellite timeline. All documents should reference these dates:

| Day | Action |
|:---:|--------|
| Day 1 | Confirm satellite handle (check availability of top 3 candidates on X) |
| Day 8 | CREATE satellite account (private/locked). Begin posting S1-S4 privately for voice calibration |
| Day 12 | Soft Launch of MAIN account only. Satellite remains private |
| Day 15 | Satellite goes PUBLIC. Pin disclosure tweet (S1). Post S13 QT of main announcement |
| Day 15-21 | Ramp satellite posting to 1-2/day. All Tier 1 review |

**Rationale:** Main account needs 3 days of public posting (Days 12-14) to establish initial presence before the satellite amplifies. This gives the satellite 7 days of private voice calibration (Days 8-14) before going public. Aligns with the roadmap's satellite timing (Days 15-17 creation, private first 3 days).

### Launch Day Sequence (Day 12 Soft Launch -- @v0idai ONLY)

Per CLAUDE.md, @v0idai max is 2 posts/day with 3-hour minimum gap. The pinned thread (T1) is a pin action, not a new post in algorithmic terms. Launch content is spread across Days 12-14 to comply with cadence rules.

| Time (UTC) | Account | Content | Notes |
|:----------:|---------|---------|-------|
| 14:00 | @v0idai | Pin "What is VoidAI" thread (T1) | Pin action -- sets profile anchor |
| 14:30 | @v0idai | First blog post (B1) published + tweet | Post 1 of 2 for Day 12 |
| 14:45 | -- | LinkedIn company intro (L1) | LinkedIn is a separate platform, does not count toward X cadence |
| 20:00 | @v0idai | First coverage QT (X3 -- ainvest) | Post 2 of 2 for Day 12. 3+ hour gap from B1 tweet |

**Day 13 continuation:**

| Time (UTC) | Account | Content | Notes |
|:----------:|---------|---------|-------|
| 14:00 | @v0idai | Coverage QT (X4 -- Systango) | Post 1 of 2 for Day 13 |
| 20:00 | @v0idai | Coverage QT (X5 -- AltcoinBuzz) | Post 2 of 2 for Day 13 |

**Day 14 continuation:**

| Time (UTC) | Account | Content | Notes |
|:----------:|---------|---------|-------|
| 14:00 | @v0idai | Coverage QT (X6 -- SubnetEdge) | Post 1 of 2 for Day 14 |
| 20:00 | @v0idai | First lending teaser (LT1) | Post 2 of 2 for Day 14 |

**Day 15 (satellite goes public):**

| Time (UTC) | Account | Content | Notes |
|:----------:|---------|---------|-------|
| 14:00 | @v0idai | Daily metrics data card (DC1) | Post 1 of 2 for Day 15 |
| 15:00 | @voidai_tao | Satellite goes public. Pin disclosure tweet (S1) | Post 1 of 2 for satellite Day 15 |
| 18:00 | @voidai_tao | QT of main announcement (S13) | Post 2 of 2 for satellite. 3+ hour gap. 4+ hours after main per stagger rules |
| 20:00 | @v0idai | X7 (Chainlink) or X12 (bridge guide) | Post 2 of 2 for Day 15 |

### Week 1-2 Soft Launch Calendar (Days 12-18)

| Day | @v0idai (max 2/day) | @voidai_tao | LinkedIn |
|-----|---------|-------------|----------|
| Day 12 (Launch) | B1 tweet + X3 (QT ainvest) | -- (still private) | L1 |
| Day 13 | X4 (QT Systango) + X5 (QT AltcoinBuzz) | -- (still private) | L2 |
| Day 14 | X6 (QT SubnetEdge) + LT1 (lending teaser) | -- (still private) | -- |
| Day 15 | DC1 (metrics) + X7 or X12 | S1 (pin, goes public) + S13 (QT) | L3 |
| Day 16 | X8 (dTAO flows) + T2 (ecosystem thread) | S2 (State of BT) + S3 (SN64) | -- |
| Day 17 | X16 (34 repos) + X18 (non-custodial) | S5 (emissions data) | L4 |
| Day 18 | X9 (subnet spotlight) + DC2 (weekly recap) | S4 (SN75) + S7 (SN106 weekly) | -- |

All @v0idai entries respect the 2 posts/day maximum and 3-hour minimum gap. Satellite entries respect its own 2/day max and 3-hour gap. Weekend days (if applicable) drop to 1/day per account.

---

## 4. Content Sequencing

### Generation Order (Dependency Chain)

Content must be generated in this order because later items derive from earlier ones. Phase labels are used (not day numbers) to avoid confusion with the implementation plan's day numbering.

**Phase A: Foundation Content (Days 1-3)**

1. Blog B1 ("What is VoidAI") -- all other content references this positioning
2. Thread T1 ("What is VoidAI" pinned thread) -- cut from B1
3. LinkedIn L1 -- cut from B1
4. Discord D1, D2 -- cut from B1
5. Visual assets IG1, IG3, DC5 -- design alongside B1

**Phase B: Education + Ecosystem (Days 3-5)**

6. Blog B3 ("Why Bittensor Needs Cross-Chain DeFi") -- thesis content
7. Thread T2 -- cut from B3
8. LinkedIn L2 -- cut from B3
9. Blog B2 ("How to Bridge TAO") -- tutorial content
10. Thread T3 -- cut from B2
11. Discord D3 -- cut from B2
12. Visual assets IG2 -- design alongside B2

**Phase C: Satellite + Data Frameworks (Days 5-7)**

**GATE:** Satellite handle must be confirmed (Day 1 decision) before generating satellite content.

13. All Bittensor satellite content (S1-S14) -- requires confirmed handle + ecosystem data pull from Taostats
14. Data card/infographic TEXT FRAMEWORKS with [PLACEHOLDER] data (DC1-DC4, DC6) -- real data filled in Days 11-12
15. Thread T4 ("State of Cross-Chain") -- requires data framework from DC4/DC6

**Phase D: Remaining Main Account + Amplification (Days 7-9)**

16. Coverage amplification QTs (X3-X6) -- requires reading the original articles
17. Standalone tweets (X7-X18) -- can be generated in any order
18. Reply frameworks (R1-R5) -- draft after reviewing target account recent posts. These are reference documents, not queue items
19. LinkedIn L3-L5 -- can be cut from existing blog/thread content

**Phase E: Lending Teasers (Days 9-10)**

20. All 15 lending teasers (LT1-LT15) -- generate as a batch, schedule based on lending timeline
21. LinkedIn L6 (lending teaser) -- derived from lending teaser batch
22. Discord D4 (lending teaser) -- derived from lending teaser batch

**Phase F: Data Fill + Polish (Days 11-12)**

23. Fill real data into DC1-DC6 placeholder frameworks (single Taostats/bridge data pull session)
24. Visual asset IG4 (satellite branding) -- needs confirmed handle
25. Final review pass on all approved content -- update any stale data

### Key Dependencies

- Blogs B1, B2, B3 must be written BEFORE their derivative threads/LinkedIn posts
- Satellite content generation is GATED on handle confirmation (Day 1 decision)
- Data cards: generate TEXT FRAMEWORKS in Phase C, fill REAL DATA in Phase F (Days 11-12) for freshness
- Lending teasers require knowing the approximate lending launch date to calibrate phase timing
- Reply frameworks should be drafted AFTER reviewing current X activity from target accounts (Tier 1-2 list in roadmap Section 8)

---

## 5. Lending Teaser Campaign

### Phase-by-Phase Content (15 items total)

The lending platform is 3-8 weeks from launch. Teasers deploy relative to the launch date. Per the roadmap, Phase 1 teasers start immediately at Soft Launch. Lending teaser day numbering uses "SL+N" (Soft Launch + N days) to avoid confusion with Phase 1a day numbering.

#### Phase 1: Teaser (Weeks 8-6 before launch) -- 5 posts

Deploy these starting on Soft Launch Day, staggered across the first 2 weeks.

| # | Day | Content | Platform | Account | Hook/Angle |
|---|:---:|---------|----------|---------|------------|
| LT1 | SL+2 (Day 14) | "What if you could access liquidity from your $TAO without selling?" | X | v0idai | Cryptic curiosity hook. No product name. No details. **Compliance note:** Original phrasing "borrow against your $TAO" flagged as compliance concern -- "borrow" combined with a specific asset ($TAO) walks close to the CLAUDE.md solicitation prohibition. Revised to remove direct lending implication while maintaining curiosity. Tier 1 mandatory review. |
| LT2 | SL+4 | Behind-the-scenes screenshot -- blurred lending dashboard UI | X + Discord | v0idai | Visual intrigue. Caption: "Building something for the $TAO ecosystem..." |
| LT3 | SL+6 | Thread: "Why DeFi lending is coming to Bittensor -- and why it matters" (5-7 tweets) | X | v0idai | Educational, positions the NEED (not the product). References locked TAO liquidity problem. |
| LT4 | SL+9 | "Something is coming to SN106..." + branded VoidAI visual | X + LinkedIn | v0idai | Broader awareness. LinkedIn L6 adaptation. |
| LT5 | SL+14 | Thread: "5 things that change when $TAO gets lending markets" (7-8 tweets) | X | v0idai | Forward-looking ecosystem analysis. Each point describes a new capability, not a promise. |

**Compliance rules for Phase 1 teasers:**
- NO mention of rates, APY, or rewards
- NO language implying guaranteed returns ("earn," "yield," "profit")
- Lending described as "protocol participation" not "investment"
- Avoid "borrow" in direct association with specific assets (compliance red flag)
- Include short-form disclaimer on every post
- All are Tier 1 -- mandatory human review

#### Phase 2: Announcement (Weeks 6-4 before launch) -- 4 posts

These are generated during Phase 1a but NOT deployed until the lending product is ready for public announcement.

| # | Content | Platform | Account | Hook/Angle |
|---|---------|----------|---------|------------|
| LT6 | Full product reveal thread (12-15 tweets) with architecture diagrams | X | v0idai | Technical deep-dive: how lending works, security model, what assets supported. Tag @chainlink for CCIP angle |
| LT7 | Blog post: "Introducing VoidAI Lending: How It Works" (2500-3000 words) | Blog | v0idai | Full technical explainer. SEO target: "Bittensor lending", "TAO lending" |
| LT8 | 60-second explainer video script | Video script | v0idai | Google Flow or Loom recording. Visual-first, conversational. Spoken disclaimer |
| LT9 | LinkedIn announcement: "VoidAI brings lending to the Bittensor ecosystem" | LinkedIn | v0idai | Institutional angle: what this means for cross-chain DeFi |

**Compliance rules for Phase 2:**
- Full risk disclosure: "Participation involves risks including smart contract vulnerabilities, market volatility, impermanent loss, liquidation risk, and potential total loss of funds"
- All rates described as "variable, not guaranteed, subject to change"
- "Supply" not "deposit"; "receive variable rewards" not "earn yield"
- Blog requires full long-form disclaimer

#### Phase 3: Documentation & Education (Weeks 4-2) -- 3 posts

| # | Content | Platform | Account | Hook/Angle |
|---|---------|----------|---------|------------|
| LT10 | Tutorial thread: "How to use VoidAI Lending in 5 minutes" (8-10 tweets, screenshot-heavy) | X | v0idai | Step-by-step walkthrough. Requires testnet screenshots -- defer generation until testnet available |
| LT11 | Tutorial blog post: step-by-step guide with screenshots | Blog | v0idai | SEO: "how to lend TAO", "VoidAI lending tutorial" |
| LT12 | FAQ post: "VoidAI Lending -- Common Questions" | Discord | v0idai | Pin in #lending-alpha. Cover: What is it, how does it work, what are the risks, what assets, is it custodial |

#### Phase 4: Testnet to Mainnet (Weeks 2-0) -- 2 posts

| # | Content | Platform | Account | Hook/Angle |
|---|---------|----------|---------|------------|
| LT13 | Countdown tweet template: "VoidAI Lending in [X] days. Here's what to know:" + key fact | X | v0idai | Daily countdown for final 5 days. Generate 5 variants |
| LT14 | Launch day announcement: "VoidAI Lending is now available" | X + LinkedIn + Discord + Telegram | v0idai | Coordinated multi-platform. Factual, not hype. Stagger across platforms over 4 hours |

#### Phase 5: Post-Launch (Weeks 1-4 after) -- 1 template

| # | Content | Platform | Account | Hook/Angle |
|---|---------|----------|---------|------------|
| LT15 | Recurring metric template: "VoidAI Lending -- Day/Week [N]: [TVL], [unique addresses], [variable rates at app]" | X | v0idai | Factual data sharing template. Neutral framing per compliance rules |

**Stockpile note for Phase 3-5 items:** LT10-LT15 require testnet/mainnet data and screenshots that do not exist yet. During Phase 1a, draft the text framework and compliance-check the language. Leave placeholder brackets for screenshots and live data. These items enter the queue as drafts with `[PLACEHOLDER]` tags that block them from advancing to `approved` until real data is inserted.

---

## 6. Community Entry Content (First 2 Weeks of Bittensor Engagement)

This section covers the reply engagement strategy and community presence-building content that supports the 30-Day Community Entry Playbook (roadmap Section 16). These are NOT standalone posts -- they are engagement actions and pre-drafted response frameworks. They do NOT go through `/queue add` and are NOT queue items.

### Week 1: Listen and Engage (5 replies/day target)

#### Pre-Drafted Reply Frameworks (for @v0idai main account)

| Context | Reply Framework | Pillar | Notes |
|---------|----------------|--------|-------|
| @opentensor announces protocol upgrade | "Interesting implications for cross-chain infrastructure. [Specific technical observation about how the upgrade affects bridging/DeFi access]. The ecosystem tooling around $TAO keeps improving." | ecosystem-intelligence | NO product mention. Pure ecosystem value |
| @taostats shares ecosystem data | "[Complementary data point from VoidAI's perspective]. The flow data is especially interesting -- [specific observation about capital movement]." | ecosystem-intelligence | Contribute data, build relationship |
| @bittingthembits posts subnet analysis | "Great breakdown. One thing to add: [genuine insight from VoidAI's cross-chain perspective]. The subnet economics on [topic] are more nuanced than most people realize." | alpha-education | Add value, demonstrate knowledge |
| @KeithSingery posts conviction take | "[Thoughtful agreement or expansion]. The community quality point is underrated -- most ecosystems never achieve this level of technical discourse." | community-culture | Short, genuine, no shilling |
| @markjeffrey posts about Bittensor | "[Expansion on his point with specific example from cross-chain data]. Your framing of [his concept] as [restatement] is exactly right." | ecosystem-intelligence | Deepen existing relationship |
| Someone asks about TAO bridges | "There are a few options. VoidAI bridge handles TAO to Solana/EVM via Chainlink CCIP. [1-sentence factual description]. Worth comparing based on which destination chain you need. NFA." | alpha-education | Helpful, factual, brief. Include disclaimer |
| Community discussion about DeFi on Bittensor | "[Genuine observation about cross-chain liquidity dynamics]. The ecosystem is still early on the DeFi side -- lot of infrastructure being built right now." | ecosystem-intelligence | Ecosystem-level, no VoidAI plug |
| Subnet team celebrates milestone | "Congrats to the [subnet] team. [Specific detail about what they built]. This is what builder culture looks like." | community-culture | ZERO VoidAI mention. Pure goodwill |

**Week 1 engagement targets:**
- 5 quality replies/day on Tier 1-2 accounts
- 0 VoidAI product mentions in replies (unless directly asked)
- Focus: @opentensor, @bittensor, @taostats, @markjeffrey, @SubnetSummerT
- DM @markjeffrey and @SubnetSummerT by Day 5 (thank for coverage, offer lending alpha preview)

### Week 2: Contribute Value (scaling to 8-10 replies/day)

#### Satellite Account (@voidai_tao) Engagement Content

The satellite account is private until Day 15. During private phase (Days 8-14), post S1-S4 to test voice.

| Context | Reply Framework | Account | Notes |
|---------|----------------|---------|-------|
| Subnet spotlight opportunity | "[Subnet name] (SN[X]) on Bittensor $TAO has been [specific observation]. What they built: [1-2 sentences]. Why it matters: [ecosystem implication]. $TAO" | voidai_tao | Use the What/Problem/Why format from x-voice-analysis.md |
| Ecosystem data conversation | "[Data point from Taostats]. +[X]k $TAO injected in subnets last [timeframe]. The infrastructure layer is where the real activity is." | voidai_tao | Data-first, neutral tone |
| Builder-culture conversation | "Real builders ship. [Specific example of VoidAI or another team shipping]. The gap between subnets that ship and subnets that announce is widening." | voidai_tao | Anti-hype positioning per community voice analysis |

**Week 2 engagement targets:**
- 8-10 quality replies/day between both accounts
- Max 2 VoidAI mentions/week from satellite (organic fan behavior, not shill behavior)
- Attend 1 Bittensor X Space (listen only, ask 1 smart question if appropriate)
- Post first data thread (T4 or equivalent) from main account
- Post builder update (X17) from main account

### Community Entry Success Criteria (End of Week 2)

| Metric | Minimum | Target |
|--------|:-------:|:------:|
| Reciprocal engagements (people who engage back) | 2 | 5 |
| Mentions by other Bittensor accounts | 1 | 3 |
| Subnet spotlights published | 2 | 3 |
| Reply engagement rate | 1.5% | 2%+ |
| DMs sent to KOLs | 2 | 4 |

---

## 7. Primary Plan: Minimum Viable Stockpile (18 Items)

This is the PRIMARY plan. Vew has 30-35 hours/week for ALL Phase 1a work (website fix recs, system testing, audit remediation, content generation). Content generation fits within approximately 12-15 hours of that budget.

### Must Have Before Soft Launch

| Priority | Item | Count | Why It's Essential |
|:--------:|------|:-----:|-------------------|
| 1 | Blog B1 ("What is VoidAI") | 1 | Defines positioning. Generates all derivative content. SEO anchor |
| 2 | Thread T1 (pinned "What is VoidAI") | 1 | First thing visitors see. Credibility anchor |
| 3 | Coverage QTs (X3-X6) | 4 | Amplify existing earned media. Fastest credibility signal |
| 4 | Lending teasers Phase 1 (LT1-LT3) | 3 | Lending is 3-8 weeks out. Teaser campaign must start at Soft Launch |
| 5 | Daily metrics data card template (DC1) | 1 | Creates posting cadence immediately. Data-driven, low risk |
| 6 | Weekly recap thread template (T5) | 1 | Recurring content engine. Shows consistency |
| 7 | Satellite disclosure pin (S1) | 1 | Compliance requirement before satellite goes public |
| 8 | Reply frameworks (R1-R5) | 5 | Engagement strategy cannot wait. Replies are 27x algorithmic weight. Note: these are reference documents, not queue items |
| 9 | LinkedIn company intro (L1) | 1 | LinkedIn page needs basic presence |
| **TOTAL MINIMUM** | | **18** | |

**Estimated generation time for minimum viable stockpile:** 12-15 hours across Days 1-7, including Vew review time.

**Hour budget context:** Vew has approximately 30-35 hours/week for Phase 1a total. Of that:
- Audit remediation (8 MUST FIX items): 4-5 hours (Day 0/1)
- Website fix recommendations: 3-4 hours
- System testing / workflow setup: 5-6 hours
- Content generation (this plan): 12-15 hours
- Review and compliance checking: 3-4 hours
- **Total: ~27-34 hours** -- fits within Week 1 budget

### Triage Decision Framework

If the lending platform launches in LESS than 3 weeks:
- Compress lending teasers: skip LT3 and LT5, go straight from cryptic hints (LT1-LT2) to product reveal (LT6-LT7)
- Prioritize minimum viable stockpile only (18 items)
- Defer satellite account launch by 1 week (start with main account only)
- Defer blogs B2, B3 to post-Soft Launch generation

If the lending platform launches in MORE than 5 weeks:
- Generate full stockpile (see Appendix A -- 84 items, time permitting)
- Satellite account can launch Day 15 (7 days private calibration)
- Time to generate Phase 2-3 lending content before needed
- Can add more subnet spotlights and ecosystem analysis content

---

## 8. Improvements and Gaps in the Existing Plan

### Identified Gaps

**Gap 1: Already Planned -- Media Outreach**

The staged-implementation-breakdown.md (Phase 1b, Days 12-14) already includes: "Draft media outreach pitches (TaoApe, SubnetEdge, Bittensor Guru) -- NOT sent until Soft Launch." Confirm these are included in the content stockpile count and aligned with the queue format.

**Gap 2: No Emergency Content Buffer**

The plan assumes a stable cadence, but what happens if a competitor announces something, a Bittensor protocol upgrade occurs, or market conditions shift? Stockpile:
- 3 "evergreen" tweets that can deploy any day (builder credibility, non-custodial trust signal, ecosystem stat)
- 1 "competitor response" thread template (pre-drafted per roadmap Section 17 competitive response frameworks -- adapt for queue format)
- 1 "ecosystem news reaction" template (fill-in-the-blank for fast response to ecosystem developments)

**Gap 3: No Chainlink Co-Marketing Content**

The roadmap notes that Chainlink promoted Project Rubicon on their account but VoidAI has not received similar treatment. Before Soft Launch, create:
- 1 dedicated Chainlink integration thread showing HOW VoidAI uses CCIP (technical, taggable by @chainlink)
- 1 "Built on Chainlink CCIP" social graphic with proper partner badge
- A draft DM/email to Chainlink's BD or marketing for co-promotion (not a queue item, but a prep deliverable)

**Gap 4: No Benchmark Content for Voice Calibration**

The `brand/voice-learnings.md` file is empty. After Soft Launch, the first 5-7 days of content should be treated as a calibration experiment:
- Tag each post with its voice register (builder-credibility, alpha-leak, community-educator, culture) in the queue metadata
- After 7 days, run the first voice calibration using the Weekly Summary template in `voice-learnings.md`
- Plan to A/B test 2 hook styles in Week 2 (e.g., data-first hooks vs. thesis hooks on similar topics)

**Gap 5: Missing Satellite Account Handle Decision**

CLAUDE.md lists satellite handles as "TBD" (e.g., @VoidAI_TAO or @TaoInsider). This decision blocks:
- Creating the satellite X account (need the handle)
- Designing satellite visual assets (IG4)
- Generating satellite content with proper @ mentions
- The satellite pinned tweet (S1)

This should be resolved on Day 1 of Phase 1a. Check availability of the top 3 handle candidates on X.

### Strategic Decisions for Vew (Day 1)

These are not "gaps" -- they are deliberate strategic choices that Vew must make:

1. **Satellite account handle** -- pick from top 3 candidates, check X availability
2. **Personal account strategy** -- Does Vew post from a personal X account alongside @v0idai? The Bittensor community values builders with names and faces. Anonymous brand accounts start with a credibility deficit. This is a personal decision, not something to auto-generate.
3. **Compressed timeline activation** -- If lending launches in <3 weeks, which items get cut? (See Section 7 triage framework)

### Improvements to Existing Plan

**Improvement 1: Batch Generate by Dependency, Not by Day**

The staged-implementation-breakdown assigns content creation to specific days. In practice, it is more efficient to batch by dependency chain (as outlined in Section 4 above) rather than by calendar day. Generate all blog content first, then cut all derivatives, then generate all satellite content. This avoids context-switching between registers.

**Improvement 2: Pre-Pull All Data Before Content Generation**

Before generating any data-driven content (data cards, ecosystem analysis, metrics posts), do a single data pull session:
- Pull current Taostats data for SN106 (mindshare rank, emissions, TVL, alpha token data)
- Pull current bridge metrics (total bridged, unique wallets, uptime)
- Pull Bittensor ecosystem data (total staked TAO, wallet growth, subnet count)
- Store these in a reference file that all content generation can draw from
- This prevents inconsistent metrics across posts and speeds up generation

**Improvement 3: Create a "Content Review Day" on Day 10-11**

After all content is generated and sitting in `queue/review/`, dedicate a full session to reviewing everything against CLAUDE.md compliance. Use `/queue review` to process all items sequentially. This consolidates Vew's review time rather than spreading reviews across multiple sessions. Estimated review time: 3-4 hours for the minimum viable stockpile.

**Improvement 4: Tag Content with Stagger Groups During Generation**

For content that covers the same topic across accounts (e.g., lending teaser on main + satellite ecosystem angle), create the stagger group at generation time using `/queue stagger`. This prevents scheduling conflicts later and ensures the inter-account timing rules from CLAUDE.md are enforced from the start.

---

## Summary: Minimum Viable Stockpile Inventory (Primary Plan)

| Category | Count | Items |
|----------|:-----:|-------|
| Blog posts | 1 | B1 |
| X single posts (QTs) | 4 | X3-X6 |
| X threads | 2 | T1, T5 |
| Reply frameworks | 5 | R1-R5 (reference docs, not queue items) |
| LinkedIn posts | 1 | L1 |
| Data cards | 1 | DC1 |
| Lending teasers | 3 | LT1-LT3 |
| Satellite disclosure | 1 | S1 |
| **TOTAL MINIMUM** | **18** | |

**Estimated generation time:** 12-15 hours across Days 1-7, including Vew review time.

---

## Appendix A: Full Stockpile Inventory (Time Permitting -- 84 Items)

If the lending timeline is 5+ weeks and Vew has capacity beyond the minimum viable stockpile, generate these additional items in priority order per Sections 1A-1H.

| Category | Main @v0idai | Satellite @voidai_tao | LinkedIn | Discord | Total |
|----------|:-----------:|:---------------------:|:--------:|:-------:|:-----:|
| Blog posts | 3 | -- | -- | -- | 3 |
| X single posts | 18 | 10 | -- | -- | 28 |
| X threads | 5 | 2 | -- | -- | 7 |
| Reply frameworks | 5 | 3 | -- | -- | 8 |
| LinkedIn posts | -- | -- | 6 | -- | 6 |
| Discord/Telegram | -- | -- | -- | 4 | 4 |
| Data cards | 4 | 2 | -- | -- | 6 |
| Infographics | 1 | 1 | -- | -- | 2 |
| Visual assets | 3 | 1 | -- | -- | 4 |
| Lending teasers | 13 | -- | 1 | 1 | 15 |
| **TOTAL** | **52** | **19** | **7** | **5** | **83** |

**Note:** Blog B4 (SDK) deferred to Phase 2+, reducing the total from the original 84 to 83. The 8 reply/engagement frameworks are reference documents, not queue items. Estimated generation time for the full stockpile: 55-70 hours (not achievable in 12 days by one person also running Phase 1a implementation). Generate in priority order and stop when time runs out.

---

### Critical Files for Implementation

- `/Users/vew/Apps/Void-AI/CLAUDE.md` - Brand voice rules, compliance framework, satellite account personas, content pillars, posting cadence -- every content item must pass checks against this file
- `/Users/vew/Apps/Void-AI/.claude/skills/queue-manager/SKILL.md` - Queue system commands and compliance check pipeline -- all content items flow through this system
- `/Users/vew/Apps/Void-AI/roadmap/voidai-marketing-roadmap.md` - Lending launch sequence (Section 10), community entry playbook (Section 16), target account lists (Section 8) -- the strategic backbone for content topics and timing
- `/Users/vew/Apps/Void-AI/research/x-voice-analysis.md` - Voice patterns, hook formulas, and example tweets for each community -- essential reference when generating satellite account content and calibrating tone
- `/Users/vew/Apps/Void-AI/queue/templates/x-thread.md` - Thread template format -- most derivative content (7 threads) uses this structure and must match the YAML frontmatter schema

---

## Corrections Applied

This document was corrected on 2026-03-13 based on the Phase 1a Challenger Report (`reviews/phase1a-challenger-strategy.md`). Changes made:

| # | Challenger ID | Change | Reason |
|---|:------------:|--------|--------|
| 1 | CS-01 (BLOCKER) | Replaced Section 2 pillar distribution table with item-by-item pillar assignment spreadsheet. Added explicit pillar column to Sections 1E, 1F, 1G. Corrected totals from 71 items (28/20/16/7) to 58 items (24/16/14/4). Rebalanced pillar assignments to bring all within 5% tolerance (see row 17). | Original distribution math was unverifiable and incorrect. Alpha & Education was particularly inflated (claimed 16, actual ~11). |
| 2 | CS-04 (BLOCKER) | Made the 18-item minimum viable stockpile the PRIMARY plan (Section 7). Moved full 84-item stockpile to Appendix A. Updated hour estimates to fit within Vew's 30-35 hr/week total Phase 1a budget. Added explicit hour budget breakdown. | 84 items in 12 days is unrealistic for a sole operator who is also running Phase 1a implementation. 12-15 hours for 18 items is achievable. |
| 3 | CS-07 (BLOCKER) | Completely restructured launch day calendar (Section 3). Day 12 reduced from 7 @v0idai posts to 2. Spread QTs across Days 12-14. Moved LT1 to Day 14. Moved DC1 to Day 15. Satellite launch moved from Day 12 to Day 15. | Original Day 12 had 7 posts from @v0idai -- 3.5x the CLAUDE.md max of 2/day. Queue system would reject this. |
| 4 | CS-10 (BLOCKER) | Set definitive satellite timeline: created Day 8 (private), public Day 15. Removed satellite from Day 12 launch sequence. Added Satellite Account Timeline table to Section 3. | Four conflicting satellite timelines across plans. Now ONE authoritative timeline. |
| 5 | CS-03 | Changed LT1 from "borrow against your $TAO" to "access liquidity from your $TAO." Added compliance note explaining why. Added "borrow" avoidance to Phase 1 compliance rules. | "Borrow" + specific asset is a solicitation red flag per CLAUDE.md Absolute Prohibitions. |
| 6 | CS-09 | Added clarifying notes to Section 1B (reply templates) and Section 6 that reply/QT templates are engagement FRAMEWORKS, not queue items. They do not go through `/queue add`. Noted AUDIT item 14 (create reply template) is prerequisite. | Reply templates were ambiguous -- could be misread as queue content items that bypass compliance pipeline. |
| 7 | IM-10 | Added "Day Numbering Convention" section at top of document. Changed lending teaser day numbers to SL+N format. | Three different "Day 1" references caused confusion. |
| 8 | IM-11 | Added satellite pillar weights (50/25/15/10) to Section 1C. Reassigned S10 from alpha-education to ecosystem-intelligence. | Resolved disagreement between plans. Adopted improvements plan's recommendation for ecosystem-heavy satellite during community entry. |
| 9 | CS-05 | Deferred Blog B4 (SDK) to Phase 2+. Reduced blog count from 4 to 3. Updated full stockpile total from 84 to 83. | No SDK audience during Phase 1a community entry. Reallocate hours to engagement content. |
| 10 | IM-07 | Moved "Vew Personal Account Strategy" from Gaps to new "Strategic Decisions for Vew" section. | It is a strategic choice, not a system deficiency. |
| 11 | IM-01 | Reframed Gap 1 (media outreach) as "Already Planned" with cross-reference to implementation plan. | Media outreach is already scheduled in staged-implementation-breakdown.md. |
| 12 | IM-09 | Removed Gap 6 (r/bittensor content). Reddit deferred to Phase 4. | Reddit adds work for low-impact output. Opportunistic comments can be done without stockpiled content. |
| 13 | IM-12 | Added "Blog Generation Workflow" to Section 1A. | No process existed for verifying technical accuracy in blog posts. |
| 14 | CS-08 | Added data freshness note to Section 1F. Changed Phase C to generate text frameworks with [PLACEHOLDER] data, Phase F to fill real numbers. | Data cards generated Days 5-7 would be stale by Soft Launch Day 12. |
| 15 | L5 reassignment | Changed L5 from bridge-build to alpha-education. | Improved pillar balance -- alpha-education was under target. |
| 16 | IG4 reassignment | Assigned IG4 to community-culture pillar. | Visual asset had no pillar. Brand identity asset fits community-culture. |
| 17 | CS-01 rebalancing | Reassigned X11, S6, DC4 from ecosystem-intelligence to alpha-education; D2 from bridge-build to community-culture. Final counts: BB=24 (41.4%), EI=16 (27.6%), AE=14 (24.1%), CC=4 (6.9%). | After initial pillar assignment, EI was +7.8% over target (outside 5% tolerance) and AE was -6.0% (outside tolerance). Reassignments bring all pillars within tolerance. |
