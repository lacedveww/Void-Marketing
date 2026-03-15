# VoidAI Autonomous Marketing Roadmap

**Status:** CURRENT (sections 3, 9, 11-13, 15 replaced with cross-references per 2026-03-13 audit)
**Last Updated:** 2026-03-13
**Canonical for:** Marketing strategy, positioning, channel strategy, KPIs, lending launch sequence
**Dependencies:** `CLAUDE.md` (brand/compliance), `roadmap/staged-implementation-breakdown.md` (implementation), `automations/x-lead-nurturing-architecture.md` (lead nurturing)

**Prepared for:** Vew (Marketing Lead, VoidAI)
**Date:** March 12, 2026 (revised March 13, 2026)
**Framework:** The Autonomous Marketing Architecture (customized for VoidAI / Bittensor SN106)
**Research base:** 10 research files, 34-repo org audit, reference PDF (91 citations)

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Current State Assessment](#2-current-state-assessment)
3. [Brand Foundation & Voice](#3-brand-foundation--voice)
4. [Tool Stack & Cost Analysis](#4-tool-stack--cost-analysis)
5. [The VoidAI Agent Architecture](#5-the-voidai-agent-architecture)
6. [Content Pipeline (1:6:12:1 Rule)](#6-content-pipeline-16121-rule)
7. [Channel-by-Channel Strategy](#7-channel-by-channel-strategy)
8. [X Monitoring & Engagement System](#8-x-monitoring--engagement-system)
9. [Themed X Accounts Strategy](#9-themed-x-accounts-strategy)
10. [Lending Platform Launch Sequence](#10-lending-platform-launch-sequence)
11. [Automation Workflows (n8n Pipelines)](#11-automation-workflows-n8n-pipelines)
12. [Weekly Operating Rhythm](#12-weekly-operating-rhythm)
13. [Implementation Plan](#13-implementation-plan)
14. [KPIs & Analytics Framework](#14-kpis--analytics-framework)
15. [Compliance Guardrails](#15-compliance-guardrails)
16. [Bittensor Community Entry Playbook](#16-bittensor-community-entry-playbook)
17. [Competitive Response Plan](#17-competitive-response-plan)
18. [Content-to-Product Attribution](#18-content-to-product-attribution)
19. [Next Steps & Deliverables](#19-next-steps--deliverables)

---

## 1. Executive Summary

VoidAI has a **strong product and a weak megaphone**. The bridge works, Chainlink CCIP is integrated, the SDK exists, and a lending platform launches in 3-8 weeks. But the marketing presence is nearly dormant: ~2,021 X followers, zero LinkedIn activity, 1 blog post, Lorem Ipsum on the roadmap page, and a posting cadence of a few times per month.

This roadmap builds a **one-person, AI-automated marketing operation** that produces the output of a 15-person team at ~$55-310/month in tooling costs. You (Vew) shift from content creator to **AI Systems Architect** -- defining guardrails, reviewing outputs, and allocating budget to top-performing loops.

### Core Architecture (Three Layers)

| Layer | Tools | Function |
|-------|-------|----------|
| **Cognitive Engine** | Claude Max, Claude Code CLI, MCP servers, custom skills | Strategy, writing, automation, compliance enforcement |
| **Intelligence Infrastructure** | Google AI Pro (Workspace Studio, Flow, Opal, NotebookLM, Antigravity) | Research, video, mini-apps, workflow automation |
| **Execution Layer** | n8n (self-hosted on DGX Spark), Outstand API, Higgsfield, ElizaOS, existing bots | Distribution, community bots, video production, on-chain data pipelines |

### Key Result

- **Cost:** $55-310/month in tooling (vs. $25K-50K+/month in headcount)
- **Output:** 10-14 posts/week across X, LinkedIn, Discord, Telegram, blog
- **Your time:** 15-20 hours/week active work; automated systems handle 30-40 additional hours equivalent
- **Target:** 3,000 X followers in 30 days, 8,000+ in 90 days
- **Critical deadline:** Lending platform launch in 3-8 weeks -- teaser campaign starts immediately

---

## 2. Current State Assessment

### What's Working

| Asset | Status | Value |
|-------|--------|-------|
| Bridge (TAO-Solana, TAO-EVM) | Live, functional | Core product, generates organic coverage |
| Chainlink CCIP integration | Live | Massive credibility signal; co-marketing opportunity |
| wTAO on Solana | Live | 50K impressions on announcement post |
| SN106 subnet | Active, 2.01% mindshare (#5) | Top-5 mindshare despite minimal marketing |
| Organic advocates | @SubnetSummerT, @markjeffrey, ainvest.com | Unprompted coverage -- rare luxury |
| SDK (@voidaisdk/bridge-sdk) | Published | Developer distribution channel |
| TwiterBot (TypeScript) | Code exists | Bridge transaction auto-tweeter, repurposable |
| Tracker (Python/FastAPI) | Code exists | Taostats API integration, repurposable |
| VoidAI 2.0 launch coverage | Multiple outlets | Unlevered media coverage sitting on the table |

### What's Broken

| Issue | Severity | Impact |
|-------|----------|--------|
| X posting cadence: ~2-4x/month | Critical | Crypto Twitter has a 24-hour memory |
| LinkedIn: completely dormant | High | Missing institutional/VC audience |
| Website: Lorem Ipsum on roadmap page | Critical | Destroys credibility on visit |
| Twitter card: @voidai instead of @v0idai | High | Social previews link to wrong account |
| Blog: 1 post total | High | No SEO content pipeline |
| No product landing pages (bridge, SDK, staking, lending) | High | Missing high-intent search traffic |
| No thread game on X | High | Threads are the primary vehicle for crypto narrative |
| No lending platform teaser campaign running | Critical | 3-8 weeks to launch with no buildup |
| Token price: -87% from ATH ($0.91 vs $7.91) | Context | Twitter not rebuilding confidence |
| No founder/team visibility | High | Most successful crypto projects have identifiable humans |
| Earned media not amplified | Medium | ainvest, Systango, AltcoinBuzz, SubnetEdge coverage sitting unused |
| Zero Bittensor community presence | Critical | VoidAI is invisible in the primary target community |

---

## 3. Brand Foundation & Voice

> **Canonical source:** See `CLAUDE.md` for brand voice registers, voice rules (DO/DO NOT), content pillars, design system, anchor metrics, and satellite account personas. See `research/x-voice-analysis.md` for the community voice baseline data from 300 scraped tweets.

### Positioning Statement

> **VoidAI is the economic infrastructure layer that connects Bittensor's intelligence to the world's liquidity.**

This framing:
- Aligns with Bittensor's builder-first culture (highest credibility tier)
- Elevates VoidAI beyond "just a bridge" to infrastructure narrative
- Addresses a real, underserved need (cross-chain liquidity for TAO)
- Creates competitive differentiation vs. Project Rubicon (Solana DeFi access vs. Base/Coinbase pathway)

---

## 4. Tool Stack & Cost Analysis

> **Note:** The staged breakdown (`roadmap/staged-implementation-breakdown.md`) contains the updated tool stack with additions from repo research (Hermes Agent, ElizaOS, Mautic, Composio, marketingskills, Autoresearch, Superpowers). Refer to that document for the current canonical tool list.

### Essential (Month 1)

| Tool | Monthly Cost | Role | Replaces |
|------|-------------|------|----------|
| **Claude Max** | $20 | Cognitive engine: writing, strategy, code, compliance enforcement, agent skills, MCP hub | Content writer, strategist, data analyst |
| **Google AI Pro** | $20 | Workspace Studio (automation), Flow (video), Opal (mini-apps), NotebookLM (research), Antigravity (IDE) | Video editor, researcher, workflow admin |
| **X/Twitter API Basic** | $200 | Primary posting/engagement channel, automation | Social media manager |
| **Outstand API** | ~$6 | Multi-platform publishing (X, LinkedIn, Discord, Telegram) via single API | Buffer/Hootsuite ($99+) |

**Essential subtotal: ~$246/month**

### Budget Alternatives

| If budget tight... | Replace | With | Save |
|---|---|---|---|
| X API Basic ($200) | Official API | OpenTweet ($6/mo) or TwitterAPI.io (pay-as-you-go) | ~$194/mo |
| Higgsfield ($9-30) | Paid video | Google Flow only (included in AI Pro) | $9-30/mo |

**Minimum viable cost: ~$52/month** (Claude Max + Google AI Pro + OpenTweet + Outstand)
**Recommended cost: ~$256/month** (full stack with official X API)

### DGX Spark Fallback Plan

DGX Spark is expected in ~1 week. If delivery is delayed, use these fallbacks to avoid blocking Phase 1:
- **n8n:** Use n8n Cloud free tier (up to 5 workflows) or self-host on a $10-20/mo VPS (Hetzner, DigitalOcean)
- **Mautic:** Use Mautic Cloud free tier or defer to Phase 4
- **Hermes/ElizaOS:** Run locally on Mac during Build/Test phases; move to DGX Spark when available
- **PostgreSQL/Redis:** Use managed free tiers (Supabase, Upstash) or run locally

---

## 5. The VoidAI Agent Architecture

Mapped from the 45-agent framework to VoidAI's specific needs. Your role: define guardrails, review outputs, allocate budget to top-performing loops.

### Division 1: Research, Strategy & SEO (The Analytical Core)

| Agent | Implementation | What It Does for VoidAI |
|-------|---------------|------------------------|
| **Intent Intelligence** | Dune Analytics MCP + Taostats API | Monitors bridge volume, wallet behaviors, SN106 metrics. Flags trends for content. |
| **Trend Aggregator** | NotebookLM + Google Search | Monitors Bittensor ecosystem, DeFi lending news, Chainlink updates, competitor moves (Project Rubicon, TAO Pad). Daily digest. |
| **SEO Content Brief** | Gemini 3.1 Pro via Workspace Studio | Keyword gap analysis for "Bittensor bridge," "TAO staking," "cross-chain DeFi." Generates content briefs with internal linking. |

### Division 2: Content & Creative Production (The Execution Engine)

| Agent | Implementation | What It Does for VoidAI |
|-------|---------------|------------------------|
| **Brand Voice Engine** | Claude.ai with CLAUDE.md brand file | Drafts all long-form content. 4-8 blog posts/month, repurposed into threads, LinkedIn posts, video scripts. |
| **Ad Creative Variant Gen** | Claude Code + Figma API + Canva | Generates visual ad permutations via Figma plugin. Adjusts claims, hooks, CTAs for different audiences. |
| **Video Production** | Higgsfield Click-to-Ad + Google Flow | Converts pages into social-ready video ads. Cinema Studio for polished explainers. |
| **Thread Writer** | Claude Code custom skill: /generate-thread | Takes a topic + data, outputs formatted X thread (hook, body, CTA). 10-15 hook variants per topic. |

### Division 3: Distribution & Community (The Frontline)

| Agent | Implementation | What It Does for VoidAI |
|-------|---------------|------------------------|
| **Omnichannel Scheduler** | Outstand API via n8n | Single API call publishes to X, LinkedIn, Discord, Telegram simultaneously. Timezone-aware scheduling. |
| **Social Listening** | Huginn (self-hosted) -> upgrade to Brand24 | Monitors @v0idai mentions, "VoidAI," "SN106," competitor mentions. Feeds engagement opportunities. |
| **Discord/Telegram Bot** | ElizaOS (TypeScript, Web3-native) | 24/7 community manager. Answers bridge questions, shares stats, onboards new users. |
| **X Engagement Agent** | Claude Code + X API | Monitors target accounts, drafts contextual replies. 5-10 quality replies/day on relevant conversations. |

### Division 4: Analytics & Revenue Ops (The Feedback Loop)

| Agent | Implementation | What It Does for VoidAI |
|-------|---------------|------------------------|
| **Metrics Dashboard** | Tracker bot (FastAPI) + Taostats API + n8n | Auto-generates daily SN106 dashboard: TVL, bridge volume, alpha token price, emissions rank. |
| **Campaign Intelligence** | Google Analytics (GA4) + n8n | Weekly "what changed and why" narrative. Tracks which content drives bridge usage via UTM attribution. |
| **Compliance Checker** | CLAUDE.md rules | Auto-validates all content against regulatory guardrails before publishing. Human review as final gate. |

---

## 6. Content Pipeline (1:6:12:1 Rule)

Every piece of content follows the pillar-to-derivatives model:

**1 pillar** generates **6 cutdown formats** (thread, carousel, short video, audio clip, newsletter, LinkedIn post), producing **12 derivative variations** (A/B hooks, CTAs, platform edits), all driving to **1 landing page**.

### Pipeline Stages

| Stage | Action | Primary Tool | Output |
|-------|--------|-------------|--------|
| 1. Research | Deep dive, competitor analysis, on-chain trends | NotebookLM + Claude Deep Research | Research brief |
| 2. Strategy | Define angle, audience, format, plan | Claude.ai (brand memory) | Content brief |
| 3. Pillar Creation | Write main long-form piece | Claude.ai or Claude Code | 1 blog post (2000-5000 words) |
| 4. Visual Production | Images, diagrams, video clips | Google Flow + Figma + Canva | 5-15 visual assets |
| 5. Derivative Cutting | Break pillar into platform formats | Claude Code + Opal mini-app | 10-30 derivatives |
| 6. Review & QA | Human review, brand consistency, compliance check | You (Vew) | Approved queue |
| 7. Distribution | Deploy across all platforms | Outstand API + n8n | Scheduled 1-2 weeks |
| 8. Analytics | Track performance, feed back | GA4 + Taostats + Claude Code | Optimization insights |

### Weekly Output Target

| Content Type | Quantity | Pipeline Stage |
|-------------|----------|---------------|
| Blog posts (pillar) | 1-2/week | Stage 3 |
| X threads (8-15 tweets) | 2-3/week | Stage 5 |
| X standalone tweets | 7-10/week | Stage 5 |
| LinkedIn posts | 2-3/week | Stage 5 (adapted tone) |
| Discord announcements | 3-5/week | Stage 7 |
| Short-form video (Reels/Shorts) | 2-3/week | Stage 4 |
| Data drops (charts/infographics) | 2-3/week | Stage 4 |

---

## 7. Channel-by-Channel Strategy

### X / Twitter (@v0idai) -- PRIMARY CHANNEL

**Current:** ~2,021 followers, sporadic posting, no threads, no Spaces
**Target:** 3,000 (30 days), 8,000+ (90 days)

| Element | Strategy |
|---------|----------|
| **Posting cadence** | 2-3 posts/day (mix of original + replies + retweets) |
| **Thread game** | 2-3 educational threads/week (8-15 tweets each) |
| **Reply strategy** | 5-10 quality replies/day on Tier 1-2 accounts during Phase 1-3; scale to 15-20 in Phase 4 |
| **Timing** | Tue-Thu, 9-11 AM ET for major content; reply within 15 min of target posts |
| **Hashtags** | 2-3 per post: #Bittensor, $TAO, #DeFi, #CrossChain, #SN106, #VoidAI |
| **Pinned tweet** | Compelling thread: what VoidAI is, why it matters, lending platform coming |
| **Spaces** | Bi-weekly, with Bittensor community members and other subnet founders |

**Immediate actions:**
1. Pin a "What is VoidAI" thread explaining bridge + lending + SDK
2. Start posting daily (even simple metrics: "$X bridged today")
3. Amplify ALL existing media coverage (ainvest, Systango, AltcoinBuzz, SubnetEdge)
4. Begin reply engagement on @opentensor, @chainlink, Solana DeFi accounts, other subnet teams
5. Start lending platform teaser campaign

### LinkedIn (linkedin.com/company/voidai/) -- INSTITUTIONAL CHANNEL

**Current:** Completely dormant, 2 employees listed
**Target:** Active presence, 2-3 posts/week

| Element | Strategy |
|---------|----------|
| **Tone** | Professional, thought leadership, institutional credibility |
| **Content** | Repurposed from X, adapted for LinkedIn's professional audience |
| **Frequency** | 2-3 posts/week |
| **Key content** | Milestone updates, partnership announcements, Chainlink integration story |
| **Automation** | Outstand API cross-posts from X with tone adaptation via Claude |

### Discord -- CORE COMMUNITY HUB

**Current:** Exists within Bittensor Discord ecosystem
**Target:** Active VoidAI community with 24/7 bot support

| Element | Strategy |
|---------|----------|
| **Bot** | ElizaOS with LangChain + vector DB containing protocol docs, FAQs, technical docs |
| **Channels** | Separate hype/announcements from support/troubleshooting |
| **Key channels** | #announcements, #general, #bridge-support, #lending-alpha, #dev-sdk, #governance |
| **Cadence** | Weekly AMAs, bi-weekly community calls, exclusive alpha drops before X |
| **Trigger** | n8n monitors GitHub commits and auto-posts to #dev-updates |

### Telegram -- QUICK UPDATES

| Element | Strategy |
|---------|----------|
| **Structure** | Announcement channel (broadcast-only) + community group |
| **Bot** | ElizaOS handles moderation, FAQs, real-time stats |
| **Content** | Cross-posted major announcements from Discord |
| **Frequency** | Announcements only (avoid noise) |

### Website / Blog (voidai.com) -- SEO ENGINE

**Current:** 7 pages, 1 blog post, Lorem Ipsum on roadmap, missing product pages
**Target:** Active SEO content hub, 2+ blog posts/week

**Immediate fixes:** Remove Lorem Ipsum, fix Twitter card handle, remove meta keywords tag.

**Month 1:** Create product landing pages (/bridge, /staking, /lending, /sdk). Publish 4-8 blog posts. Set up Google Search Console. Add internal linking.

**Target keywords:** "Bittensor cross-chain bridge," "TAO staking guide," "Subnet 106 explained," "Chainlink CCIP integration Bittensor," "Cross-chain interoperability DeFi," "VoidAI lending"

### YouTube -- LEARNING CHANNEL (Phase 4, Month 2+)

Deprioritized from Phase 1. Focus video effort on short-form clips for X (15-60 seconds) during Phase 1-3. Full YouTube strategy activates in Phase 4 with tutorials, explainers, and dev walkthroughs using Google Flow and NotebookLM Audio Overviews.

### Reddit (r/bittensor) -- AUTHENTIC ENGAGEMENT

Target 2-3 genuine comments per week on r/bittensor. Focus on answering technical questions about bridging, cross-chain mechanics, and Bittensor DeFi. Never shill. Build a post history of genuine helpfulness before ever mentioning VoidAI by name.

---

## 8. X Monitoring & Engagement System

### Target Account List (Monitor Daily)

**Tier 1 -- Engage with every major post:**
- @opentensor (Bittensor core)
- @bittensor (brand account)
- @chainlink (co-marketing opportunity)
- @taostats (data partner)
- @TheBittensorHub (community media)

**Tier 2 -- Engage 3-5x/week:**
- @markjeffrey (already engaged organically)
- @SubnetSummerT (already wrote about VoidAI)
- @bittingthembits (Andy -- prolific Bittensor analyst)
- @AngryDavee (ecosystem commentator)
- @CryptoZPunisher (subnet spotlights)
- @RaydiumProtocol (Solana DeFi partner)
- @JupiterExchange (Solana DeFi)

**Tier 3 -- Monitor for opportunities:**
- @ridges_ai, @Bitcast_network, @BitAds_AI (subnet ecosystem)
- @gtaoventures (Project Rubicon -- competitor)
- @DLNewsInfo, @TheBlock__, @CoinDesk (crypto media)
- Barry Silbert, Raoul Pal (institutional narrative)

### Monitoring Bot Architecture

Consolidate TwiterBot + Tracker into a unified data service:

```
[Bridge PostgreSQL DB] --> [Tracker/FastAPI] --> [n8n Workflows] --> [Outstand/X API]
[Taostats API] ────────┘                            │
[CoinGecko API] ───────┘                            ├──> Transaction alert tweets
                                                     ├──> Daily metrics posts
                                                     ├──> Weekly recap threads
                                                     └──> Multi-platform distribution
```

**Data endpoints from consolidated Tracker:**

| Endpoint | Data | Content Use |
|----------|------|-------------|
| `GET /api/bridge/recent` | Recent bridge transactions | Transaction alert tweets |
| `GET /api/taostats/price` | TAO price + changes | Market update posts |
| `GET /api/taostats/subnet/106` | SN106 metrics | Daily dashboard posts |
| `GET /api/taostats/delegation` | Delegation stats | Staking content |
| `GET /api/metrics/summary` | Aggregated daily/weekly metrics | Weekly recap threads |

### Reply Strategy (The Reply Guy Playbook)

X algorithm values replies at **27x the weight of likes**. This is the fastest organic growth method.

**Rules:**
- Reply within 15 minutes of target posts (early replies get 300% more impressions)
- Add genuine value: data, perspective, smart questions
- Never spam or self-promote in replies
- Be the expert voice in cross-chain DeFi conversations

**Daily target:** 5-10 quality replies during Phase 1-3 (Tier 1-2 accounts only). Scale to 15-20 in Phase 4.

---

## 9. Themed X Accounts Strategy

> **Updated 2026-03-13:** Satellite account strategy has been redesigned from branded niche accounts to community-page accounts. See `CLAUDE.md` Satellite Account Personas section for current persona definitions, voice patterns, and content format ratios.

**Implementation approach:** Start with 1 satellite account only (the Bittensor Community Page, e.g., @TaoInsider or @SubnetAlpha). Add the DeFi Community Page in Phase 4 once the first account proves viable. Defer the VoidAI Fanpage/meme account to Month 3+ as it requires the most voice skill to execute authentically.

**Key compliance rules (apply to all satellite accounts):**
- Each account clearly states its community focus in the bio
- No deception about who operates the account
- Each account has a distinct, genuine purpose (not just amplifying the main account)
- Accounts do not engage in coordinated behavior to artificially amplify content

### Amplification Alternatives (Zero Risk)

1. **KOL cultivation** (5-10 targets): @markjeffrey (already engaged), @SubnetSummerT (already wrote about VoidAI), Bittensor podcast hosts (TaoApe, Bittensor Guru), DeFi-focused Bittensor analysts

2. **Bitcast (SN93) partnership**: Use Bitcast's X marketing platform to run VoidAI campaigns. Pay in alpha tokens for verified creator content.

3. **Ambassador program** (Month 3+): 3-tier structure (Contributor > Advocate > Core). Application-based, quality over quantity. Content kits with pre-written threads, branded graphics, data points.

---

## 10. Lending Platform Launch Sequence

With the lending platform 3-8 weeks out, the buildup campaign starts **immediately**.

### Phase 1: Teaser (Weeks 8-6 Before Launch) -- START NOW

**Goal:** Create awareness and anticipation. Estimate: ~3 hours to create all Phase 1 teasers.

| Day | Content | Platform |
|-----|---------|----------|
| Day 1 | Cryptic tweet: "What if you could borrow against your TAO without selling?" | X |
| Day 2 | Behind-the-scenes screenshot (blurred dashboard UI) | X, Discord |
| Day 3 | Educational thread: "Why DeFi lending is coming to Bittensor" | X |
| Day 5 | "Something is coming to SN106..." with VoidAI visual branding | X, LinkedIn |
| Day 7 | Quote-tweet ecosystem commentary with subtle hint | X |
| Day 10 | Announce security audit partner (if applicable) | X, Discord, Blog |
| Day 14 | Thread: "5 things that change when TAO gets lending markets" | X |

**Minimum viable teaser** (if product launches in < 3 weeks): 3 posts over 1 week -- cryptic hint, blurred screenshot, "DeFi lending is coming to Bittensor" thread. Compress to fast timeline.

### Phase 2: Announcement (Weeks 6-4)

**Goal:** Full product reveal and education. Estimate: ~8 hours.
- Full product reveal thread (10-15 tweets) with architecture diagrams
- Blog post with technical deep-dive on lending mechanics
- 60-90 second explainer video (Google Flow)
- Press outreach: CoinDesk, The Defiant, Blockworks, CoinTelegraph
- Podcast appearances: TaoApe (already covered SN106), Bittensor Guru
- SubnetEdge follow-up article pitch

### Phase 3: Documentation & Education (Weeks 4-2)

**Goal:** Enable users to understand and prepare. Estimate: ~6 hours.
- Full docs site live for lending
- Tutorial content: "How to lend on VoidAI in 5 minutes"
- SDK documentation for lending integrations
- Minimal Zealy quest campaign (3-5 educational quests)

### Phase 4: Testnet to Mainnet (Weeks 2-0)

**Goal:** Community participation and stress-test. Estimate: ~4 hours.
- Public testnet with leaderboard and bug bounty
- Daily countdown content on X
- Discord launch event with team AMA
- Galxe on-chain quests (defer until testnet date confirmed)

### Phase 5: Post-Launch (Weeks 1-4 After)

**Goal:** Momentum and metrics storytelling. Estimate: ~3 hours/week ongoing.
- Daily metrics sharing: TVL milestones, transactions, unique users
- User testimonials and case studies
- Yield comparison content vs. alternatives
- Governance proposal for community input on future parameters

### Compliance Guardrails for Lending Launch

Per `CLAUDE.md` compliance rules: Frame lending as "protocol participation," never as "investment." All rates described as variable. Disclose risks: smart contract vulnerabilities, liquidation risk, market volatility, impermanent loss. Never compare lending rates to bank savings or traditional returns.

---

## 11. Automation Workflows (n8n Pipelines)

> **Canonical source:** 13 n8n workflows are fully specified in `roadmap/staged-implementation-breakdown.md` (Workstream C: Workflows 1-7, plus Lead Nurturing Workflows 8-13). The lead nurturing system architecture is in `automations/x-lead-nurturing-architecture.md`.

**Launch Critical workflows (Phase 1, Week 1):** Workflows 1-4 (Daily Metrics, Bridge Alerts, Weekly Recap, Ecosystem News Monitor).

**Post-Launch workflows (Phase 3+):** Workflows 5-7 (Blog Distribution, Competitor Monitor, Email Campaign).

**Deferred to Phase 4:** Workflows 8-13 (Lead Nurturing: Engagement Poller, Assignment Engine, Content Generator, Engagement Poster, Organic Content Poster, Performance Tracker).

---

## 12. Weekly Operating Rhythm

> **Detailed daily breakdown:** See `roadmap/staged-implementation-breakdown.md` Phase 4 section for the condensed day-by-day operating rhythm at full deployment speed.

**Total active work: 15-20 hours/week (Phase 4).** Automated systems handle 30-40 additional hours equivalent. Your role is AI Systems Architect -- defining guardrails, monitoring integrations, allocating budget to top-performing loops.

| Day | Focus | Hours |
|-----|-------|-------|
| **Monday** | Strategy, research, editorial planning | 3-4 |
| **Tuesday** | Pillar content creation, visual production | 4-5 |
| **Wednesday** | Derivatives, distribution, scheduling, engagement | 3-4 |
| **Thursday** | Community, live events, KOL relationships | 3-4 |
| **Friday** | Analytics, optimization, weekend prep | 2-3 |
| **Weekend** | Automated operations, 30-min check-in | 0.5 |

---

## 13. Implementation Plan

> **Canonical source:** The full 4-phase staged implementation plan with 6 parallel workstreams, day-by-day tasks, testing checklists, and rollback procedures is in `roadmap/staged-implementation-breakdown.md`.

### Revised Phase Structure (Post-Audit)

| Phase | Duration | Focus | Your Hours/Week |
|-------|----------|-------|-----------------|
| **Launch Critical** | Days 1-7 | Website fixes, daily posting, reply engagement, first content, 4 core n8n workflows | 30-35 |
| **Post-Launch Build** | Days 8-21 | Skills/tools, agent deployment, content backlog, 1 satellite account | 25-30 |
| **TEST** | Days 8-14 (overlaps) | DRY_RUN validation on private accounts | 20-25 |
| **SOFT LAUNCH** | Days 12-14+ | Go live with approval gate, lending teasers begin | 20-25 |
| **FULL DEPLOY** | Day 21+ | Remove approval gate gradually, fully autonomous | 16-21 |

### Critical Path (Days 1-7)

```
Day 1:  Website fixes + begin daily posting (manual OK)          [~3 hrs]
Day 2:  Pinned thread + amplify coverage + reply engagement      [~3 hrs]
Day 3:  First lending teaser + content staging queue setup        [~3 hrs]
Day 4:  n8n install + Workflow 1 (Daily Metrics) build           [~4 hrs]
Day 5:  Workflow 2 (Bridge Alerts) build                         [~4 hrs]
Day 6:  First pillar blog post drafted                           [~4 hrs]
Day 7:  Blog published + Workflow 3 (Weekly Recap) build         [~4 hrs]
```

### Deferred Items (Phase 4 / Month 2+)

- Full lead nurturing system (all 7 nurturing workflows, PostgreSQL schema, Redis, satellite automation)
- Hermes Agent deployment (Claude Max handles content gen in Phase 1-3)
- ElizaOS deployment (late Phase 3 earliest)
- Autoresearch pattern adaptation
- Ambassador program
- YouTube full strategy
- Quest campaigns (Galxe on-chain)
- BigQuery / Dataflow, Google Opal mini-apps, Antigravity
- 2nd and 3rd satellite accounts

---

## 14. KPIs & Analytics Framework

### Primary KPIs

| Metric | Current Baseline | 30-Day Target | 30-Day Minimum | 90-Day Target |
|--------|-----------------|---------------|----------------|---------------|
| X Followers | ~2,021 | 3,000 | 2,500 | 8,000+ |
| Posts/week (X) | ~1-2 | 10-14 | 7 | 14-21 |
| Avg impressions/post | Est. 2-5K | 10K | 5K | 25K |
| Engagement rate (X) | Unknown | 3%+ | 2% | 5%+ |
| X Spaces hosted | 0 | 2 | 1 | 6+ |
| KOL relationships | 2-3 organic | 8-10 | 5 | 15+ |
| Blog posts published | 1 total | 6-8 | 4 | 20+ |
| LinkedIn posts/week | 0 | 2-3 | 1 | 3-5 |
| Discord active members | -- | 100+ | 50 | 500+ |
| Website organic traffic | Unknown | 2x baseline | 1.5x | 5x baseline |
| Kaito Mindshare | 2.01% | 2.5% | 2.2% | 4%+ |
| Media coverage amplified | 0 | All existing | Top 3 | Proactive pitching |

Use the gap between minimum and target as a signal for whether to invest in paid amplification.

### Lending Platform Launch KPIs

| Metric | Launch Day | Week 1 | Month 1 |
|--------|-----------|--------|---------|
| Launch announcement impressions | 50K+ | -- | -- |
| Unique wallets (lending) | -- | 100+ | 500+ |
| TVL (lending) | -- | Track | Growing week-over-week |
| Discord spike | -- | 2x pre-launch | Retained 70%+ |
| Press coverage | 3+ outlets | 5+ | Ongoing |

### Tracking Tools

| Tool | Metrics Tracked |
|------|----------------|
| X Analytics (native) | Impressions, engagement rate, follower growth, top posts |
| Google Analytics (GA4) | Website traffic, organic search, referral sources, conversions |
| Google Search Console | Keyword rankings, click-through rates, index coverage |
| Taostats API | SN106 metrics (emissions, TVL, bridge volume, alpha price) |
| Kaito Mindshare | Protocol visibility on crypto X |
| n8n auto-reports | Weekly digest aggregating all metrics into single report |

---

## 15. Compliance Guardrails

> **Canonical source:** See `CLAUDE.md` Compliance Rules section. These are mandatory and override all other instructions. CLAUDE.md is the canonical compliance reference and is auto-loaded for every content generation session. It contains: absolute prohibitions, required language substitutions, required disclaimers by content type, influencer/partnership rules, jurisdictional compliance, and the full 10-point human review gate checklist.

---

## 16. Bittensor Community Entry Playbook

VoidAI has **zero presence** in the Bittensor X community. The voice analysis confirms it: "No VoidAI mentions found in the Bittensor community dataset itself." This playbook provides specific daily actions for the first 30 days to break in.

### Principles

1. **Lead with ecosystem value, not product promotion.** Give before taking. Spotlight other subnets. Share genuine alpha about ecosystem trends.
2. **Be a real human voice.** Brand accounts struggle in builder-first communities. Whether Vew posts personally or as @v0idai, the voice must sound like a builder talking to builders, not a marketing account.
3. **Earn credibility through knowledge.** The Bittensor community values technical depth, honest takes, and people who ship. Reference real metrics, acknowledge risks, show you understand the ecosystem.

### Key Accounts to Build Relationships With (Priority Order)

| Account | Why | Approach |
|---------|-----|----------|
| @markjeffrey | Already engaged with VoidAI organically | Deepen the relationship. Quote-tweet his takes. DM to discuss collaboration. |
| @SubnetSummerT | Already wrote about VoidAI | Engage with their content regularly. Offer exclusive alpha for future posts. |
| @bittingthembits (Andy) | Prolific Bittensor analyst | Provide data for his analyses. Reply to his threads with complementary insights. |
| @KeithSingery | Major Bittensor voice | Engage genuinely with his content. A single QT from him carries more than 100 standalone posts. |
| @jollygreenmoney | Major Bittensor voice | Same approach as KeithSingery. |
| @opentensor | Core team account | Reply to announcements with how VoidAI infrastructure supports the ecosystem. |
| @sobczak_mariusz | Active community member | Engage regularly. Potential early informal advocate. |

### Subnet-Specific Content Angles

These content topics demonstrate genuine Bittensor knowledge and provide value to the ecosystem:

1. **Cross-chain liquidity analysis:** "How much TAO is locked in bridges? Where is it going? What does this mean for dTAO dynamics?" -- pure data, no shilling
2. **Subnet spotlight series:** Highlight OTHER subnets (not SN106). "What @hippius_subnet does and why it matters." This builds goodwill and positions VoidAI as ecosystem-oriented.
3. **dTAO flow analysis:** Where are alpha token emissions going? Which subnets are gaining/losing mindshare? Data-driven content using Taostats.
4. **Cross-chain DeFi thesis:** "Why Bittensor needs DeFi infrastructure" -- position the argument broadly, not just for VoidAI.
5. **Builder updates:** Genuine "building in public" posts about what VoidAI shipped this week. Show code, show metrics, show progress.

### Community Events & Spaces to Join

- **X Spaces:** Attend (not host) Bittensor community Spaces for the first 2 weeks. Listen, contribute value in the chat, ask smart questions. Then offer to co-host starting Week 3.
- **Discord:** Active participation in the main Bittensor Discord. Answer bridging/cross-chain questions when they come up naturally.
- **Podcasts:** Pitch TaoApe and Bittensor Guru for appearances -- these are genuine community voices.
- **SubnetEdge / TAO.media:** Contribute guest content or provide data for their articles.

### 30-Day Timeline

**Week 1: Listen and Engage (focus: main account @v0idai)**
| Day | Action | Time |
|-----|--------|------|
| 1 | Set up X Pro lists for all Tier 1-2 accounts. Begin monitoring. Start posting daily. | 1 hr |
| 2 | Reply to 5 Bittensor ecosystem posts with genuine value (data, insights, smart questions). Zero product mentions. | 45 min |
| 3-4 | Continue 5 replies/day. Quote-tweet 1 ecosystem post with VoidAI perspective. Post first subnet spotlight (not SN106). | 45 min/day |
| 5-7 | DM @markjeffrey and @SubnetSummerT -- thank them, offer exclusive lending alpha. Continue daily engagement. | 1 hr total |

**Week 2: Contribute Value**
| Day | Action | Time |
|-----|--------|------|
| 8-9 | Post first data thread: "Cross-chain TAO flows this week" using Taostats data. Tag relevant accounts. | 2 hrs |
| 10-11 | Reply to @bittingthembits and @KeithSingery posts. Share complementary data. Attend a Bittensor X Space (listen + ask 1 question). | 45 min/day |
| 12-14 | Post builder update: "What we shipped at VoidAI this week." Genuine, technical, builder-credible. | 1.5 hrs |

**Week 3: Establish Presence**
| Day | Action | Time |
|-----|--------|------|
| 15-17 | Post second subnet spotlight. Continue daily engagement (now should have some reciprocal engagement). Create Bittensor Community satellite account (organic posting, private for first 3 days). | 1.5 hrs/day |
| 18-21 | Offer to co-host a Bittensor community X Space. Post dTAO analysis thread. First lending teaser that references Bittensor ecosystem context. | 2 hrs/day |

**Week 4: Build Momentum**
| Day | Action | Time |
|-----|--------|------|
| 22-25 | Co-host or participate in X Space. Satellite account begins public organic posting. Post cross-chain DeFi thesis thread. | 1.5 hrs/day |
| 26-30 | Pitch TaoApe/Bittensor Guru podcast. Post 3rd subnet spotlight. By now, should have 3-5 reciprocal relationships with Bittensor community voices. | 1.5 hrs/day |

### Success Metrics (30-Day Community Entry)

| Metric | Target |
|--------|--------|
| Reciprocal relationships (people who engage back regularly) | 5+ |
| Mentions by other Bittensor accounts | 3+ |
| X Space participation (attend or co-host) | 2+ |
| Subnet spotlights published | 3 |
| Reply engagement rate | 2%+ average on replies |

---

## 17. Competitive Response Plan

### Primary Competitor: Project Rubicon (@gtaoventures)

**Our differentiation:** Solana DeFi access vs. Base/Coinbase pathway. Multi-chain bridge vs. single-chain. Lending platform (upcoming). Non-custodial architecture.

### Pre-Drafted Response Frameworks

**Scenario 1: Competitor launches competing bridge with lower fees**
- **Response time:** Within 4 hours
- **Action:** Post thread comparing total cost of bridging (not just fees -- speed, reliability, supported assets, security model). Lead with VoidAI's Chainlink CCIP security advantage. "Lower fees mean nothing if the bridge isn't secure. Here's why we chose Chainlink CCIP."
- **DO NOT:** Attack the competitor directly. Let the comparison speak.

**Scenario 2: Competitor announces major partnership**
- **Response time:** Within 24 hours
- **Action:** Congratulate genuinely. Then pivot to VoidAI's own partnerships and roadmap. "Great to see cross-chain infrastructure getting attention. Here's what we're building with Chainlink + [upcoming partner]."
- **DO NOT:** Minimize their achievement. Community sees through it.

**Scenario 3: Competitor copies VoidAI's lending platform concept**
- **Response time:** Within 48 hours
- **Action:** "Imitation is the sincerest form of flattery. We've been building lending for [X] months. Here's what makes our approach different: [technical differentiators]." Share builder-credibility content showing development history.
- **DO NOT:** Claim ownership of the idea. DeFi lending is not novel. Focus on execution.

**Scenario 4: Negative campaign against VoidAI**
- **Response time:** Within 2 hours
- **Action:** Respond once with facts. Do not engage in back-and-forth. Let advocates defend VoidAI (this is why building community relationships is critical). If factually wrong, correct with evidence. If opinion-based, ignore after one response.
- **DO NOT:** Get into a public argument. It amplifies the negative narrative.

**Scenario 5: Smart contract exploit or bridge vulnerability (CRISIS)**
- **Response time:** Within 30 minutes
- **Holding statement:** "We are aware of [issue] and are investigating. User fund safety is our top priority. We will provide updates as we have confirmed information."
- **Action:** Pause all marketing content. Coordinate with team. Post transparent update within 4 hours with root cause (if known), impact assessment, and remediation plan.
- **DO NOT:** Downplay the issue. The Bittensor community will find out. Transparency builds trust.

### Competitor Monitoring (Ongoing)

Workflow 6 (Competitor Monitor) runs daily. Flag any of the above scenarios for immediate attention. Weekly competitor digest includes: new features, partnerships, community sentiment, mindshare changes.

---

## 18. Content-to-Product Attribution

Marketing metrics (followers, impressions, engagement) are important but do not tell you which content actually drives product usage. This section defines how to connect content to bridge transactions, staking, and lending deposits.

### UTM Tracking (All Links)

Every link shared from any platform must include UTM parameters:

```
https://voidai.com/bridge?utm_source=twitter&utm_medium=thread&utm_campaign=bridge-guide&utm_content=hook-v1
```

| Parameter | Values |
|-----------|--------|
| `utm_source` | twitter, linkedin, discord, telegram, reddit, blog, email, podcast |
| `utm_medium` | thread, post, reply, space, dm, newsletter, article |
| `utm_campaign` | descriptive campaign name (e.g., lending-teaser-p1, bridge-guide, weekly-recap) |
| `utm_content` | variant identifier for A/B testing (e.g., hook-v1, hook-v2) |

### Bridge Landing Page Conversion Tracking

1. Set up GA4 conversion events on key actions:
   - `bridge_page_visit` -- landed on /bridge
   - `bridge_connect_wallet` -- clicked "Connect Wallet"
   - `bridge_initiate_tx` -- started a bridge transaction
   - `bridge_complete_tx` -- completed a bridge transaction
2. Tag each conversion event with the UTM source/campaign that brought the user
3. Weekly report: "Which content drove the most bridge transactions?"

### Content-to-Transaction Attribution Model

| Level | Method | Accuracy | Implementation |
|-------|--------|----------|----------------|
| **Basic** | UTM tracking + GA4 conversions | Medium | Phase 1 -- set up immediately |
| **Intermediate** | Referral path analysis (which pages did users visit before bridging?) | Medium-High | Phase 3 -- requires GA4 data accumulation |
| **Advanced** | Wallet-to-content mapping (track which wallets bridged after engaging with specific content) | High | Phase 4 -- requires on-chain analytics + Dune queries |

### Weekly Attribution Report (Automated via n8n)

Include in the weekly recap:
- Top 3 content pieces by bridge transaction referrals
- Content type breakdown: which format (thread, blog, video, reply) drives the most conversions
- Channel breakdown: which platform drives the most product usage
- Cost per bridge transaction by content campaign (if paid promotion is active)

---

## 19. Next Steps & Deliverables

### Immediate (Today/Tomorrow)

1. **Fix the website** -- remove Lorem Ipsum, fix Twitter card handle (~30 min)
2. **Start daily posting from @v0idai** -- even simple metrics create cadence (~30 min/day)
3. **Begin Bittensor community engagement** -- 5 quality replies/day on Tier 1-2 accounts (~45 min/day)
4. **Amplify existing coverage** -- quote-tweet ainvest, Systango, AltcoinBuzz, SubnetEdge (~30 min)
5. **Post first lending teaser** -- "What if you could borrow against your TAO?" (~15 min)

### This Week

6. **Set up content staging queue** (simple: Discord channel or Notion) (~1 hr)
7. **Pin "What is VoidAI" thread on X** (~1 hr to write)
8. **Install n8n + build Workflow 1 (Daily Metrics)** (~4 hrs)
9. **Write first pillar blog post** (~3-4 hrs)
10. **Update LinkedIn page** (~30 min)

### Deferred Deliverables (Phase 4 / Month 2+)

| Deliverable | Original Timeline | New Timeline |
|-------------|-------------------|--------------|
| Full lead nurturing system | Days 9-10 | Day 21+ (Phase 4) |
| Hermes Agent deployment | Days 5-6 | Phase 4 |
| ElizaOS deployment | Days 7-8 | Late Phase 3 |
| Ambassador program | Days 9-10 | Month 3+ |
| YouTube strategy | Phase 1 | Phase 4 |
| BigQuery/Dataflow pipeline | Month 2 | Month 3+ |

---

*This roadmap synthesizes research from: X/Twitter audit, competitor DeFi marketing analysis, Bittensor ecosystem marketing landscape, marketing tools research, US compliance guide, website SEO audit, LinkedIn audit, existing bots audit, V21 Studio analysis, and The Autonomous Marketing Architecture framework. All data as of March 12, 2026. Revised March 13, 2026 based on strategy and architecture audits.*
