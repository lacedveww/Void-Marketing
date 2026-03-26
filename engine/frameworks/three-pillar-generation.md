# Three-Pillar Content Generation Framework

**Status:** CURRENT
**Last Updated:** 2026-03-25
**Canonical for:** Content generation strategy, pillar priorities, daily targets, generation process
**Dependencies:** `companies/{ACTIVE_COMPANY}/automations/openclaw-setup.md` (cron jobs), `companies/{ACTIVE_COMPANY}/pillars.md` (content pillars), `companies/{ACTIVE_COMPANY}/cadence.md` (posting schedule)

---

## Overview

All VoidAI content generation flows through three pillars, each with a distinct data source, priority level, and daily output target. The pillars work together to produce 3-5 posts per day.

---

## Pillar A: X/Twitter Intelligence (Highest Priority)

**Source:** Intelligence Sweep (8AM + 8PM ET, silent collection)
**Output:** 2-3 tweets/day
**Data:** Bittensor community activity, ecosystem news, competitor signals, engagement opportunities

### What It Covers
- Breaking Bittensor ecosystem news (protocol updates, subnet launches, network milestones)
- Community discourse and trending narratives from monitored accounts
- Engagement opportunities (quote-tweets, replies to high-signal threads)
- Competitor activity requiring a response (new features, partnerships, incidents)
- Content angles surfaced by monitored builders/analysts
- Lending ecosystem developments (Sturdy SN10, BitQuant SN15, Aave, Compound, Morpho)

### Account Routing (3 accounts)
- Protocol news, builder updates, lending development, ecosystem commentary: @v0idai (main)
- Daily stats, routine updates, metrics recaps: Daily/Informational account
- Technical deep-dives on subnets, decentralized training, DeFi/lending ecosystem: Bittensor Ecosystem account
- DeFi/cross-chain angles, lending market analysis: @v0idai (main) for major pieces, Daily/Informational for routine updates

### Priority Rules
1. Breaking news gets same-day coverage (within 4 hours of sweep detection)
2. Engagement opportunities (QTs, replies) within 2 hours of detection
3. Narrative threads can be batched for next-day morning slot
4. Competitor response follows frameworks in `competitors.md`

---

## Pillar B: SEO & Google News (Second Priority)

**Source:** Google News API, RSS feeds, manual research pipeline
**Output:** 1-2 tweets/day
**Data:** Industry trends, AI/crypto news, research papers, product launches

### What It Covers
- AI industry news relevant to Bittensor/decentralized compute narrative
- Crypto/DeFi trends that intersect with VoidAI's product (bridging, lending, cross-chain)
- Lending market news (Aave governance, Compound updates, Morpho innovations, new lending protocols)
- Research papers and technical breakthroughs (via AlphaXiv MCP, arXiv)
- Product launches and partnership announcements from adjacent ecosystems
- SEO-aligned content that builds topical authority

### Account Routing (3 accounts)
- DeFi/bridging/lending industry context: @v0idai (main)
- General AI/tech trends reframed for audience: @v0idai (main)
- Technical research explainers: Bittensor Ecosystem account
- Factual news recaps: Daily/Informational account

### Priority Rules
1. News with direct VoidAI relevance (Bittensor, Solana, Chainlink) gets same-day treatment
2. Broader AI/crypto trends can be scheduled 24-48 hours out
3. Research deep-dives are best as morning posts (higher engagement for long-form)
4. Evergreen SEO content can be queued and spaced across the week

---

## Pillar C: Analytics Feedback (Optimizer)

**Source:** Engagement Collector (10PM ET, silent collection) + Weekly Voice Calibration (Fri 10:30 AM ET)
**Output:** Does NOT generate content directly
**Role:** Optimizes Pillars A and B by feeding performance data back into generation prompts

### What It Does
- Collects engagement metrics (likes, RTs, replies, views, bookmarks) for all posted content
- Builds `performance-summary.json` with per-pillar stats, hook analysis, and pattern detection
- Identifies top-performing content patterns (content type, time of day, hook style, account)
- Detects underperforming patterns and flags for voice calibration review
- Weekly calibration updates `brand/voice-learnings.md` with structured performance summaries

### How It Feeds Back
1. `performance-summary.json` is loaded by all content generation scripts (`generate-daily-tweet.sh`, `generate-weekly-thread.sh`, `generate-news-tweet.sh`)
2. Injected as a "PERFORMANCE FEEDBACK" section in Claude prompts
3. Generation scripts use this data to prefer high-performing patterns and avoid low-performing ones
4. Weekly voice calibration checks for drift and proposes weight adjustments

### Pre-Launch Note
Pillar C requires live posting data to function. During DRY_RUN and early soft-launch phases:
- `performance-summary.json` will contain zero values (no data to analyze)
- Content generation scripts handle this gracefully (skip feedback section if no data)
- Voice calibration runs but produces "insufficient data" reports
- **Full Pillar C activation occurs after 7+ days of live posting with engagement data**

---

## Daily Content Targets

| Pillar | Source | Daily Target | Content Type | Silent? |
|--------|--------|-------------|--------------|---------|
| A: X/Twitter Intelligence | Intelligence Sweep (8AM + 8PM ET) | 2-3 posts | Reactive: news, QTs, replies, narrative threads | Data collection is silent |
| B: SEO & Google News | News feeds, research pipeline | 1-2 posts | Proactive: industry context, research explainers, SEO content | N/A |
| C: Analytics Feedback | Engagement Collector (10PM ET) | 0 posts (optimizer only) | Feedback data injected into A+B generation | Data collection is silent |
| **Total** | | **3-5 posts/day** | Mix of reactive + proactive | |

### Weekly Breakdown

| Day | Pillar A | Pillar B | Special |
|-----|----------|----------|---------|
| Mon | 2-3 posts | 1 post | Weekly planning review |
| Tue | 2-3 posts | 1-2 posts | |
| Wed | 2-3 posts | 1-2 posts | |
| Thu | 2-3 posts | 1-2 posts | |
| Fri | 2-3 posts | 1 post | Weekly Recap thread + Voice Calibration |
| Sat | 1 post | 0-1 posts | Reduced weekend cadence |
| Sun | 1 post | 0-1 posts | Reduced weekend cadence |

---

## Content Generation Process (7 Steps)

### Step 1: Intelligence Sweep (8AM + 8PM ET, SILENT)
- Automated scan of monitored X accounts (see `monitoring/content-accounts.md` Tier 1, `monitoring/marketing-accounts.md` Tier 2)
- Collects: new posts, threads, engagement signals, trending topics, competitor activity
- Output: `data/sweep-YYYY-MM-DD-{morning|evening}.json`
- **No messages sent** -- pure data collection

### Step 2: Morning Summary (8:30 AM ET)
- Reads latest sweep data + overnight news
- Generates a structured brief: top stories, engagement opportunities, suggested content angles
- Delivered to Telegram for Vew's review (5-6 messages)
- Includes: priority flags, suggested account routing, draft hooks
- **PAUSES** -- waits for Vew's response before continuing to Step 3

### Step 3: Content Generation with Two-Stage Curation (reply-gated, on Vew's response)
- Claude generates **8 variants per tweet/thread slot** (4 for articles) with enforced hook diversity
- Each variant uses a different hook type (data-lead, builder, curiosity-gap, alpha-leak) with tone variation (analytical vs conversational)
- Variants output as JSON with metadata: `hook_type`, `tone`, `format`, `content_type`, `account`, `pillar`, `topic`, `word_count`
- Drafts are generated **per-account in sequence**, not as one batch
- Each account's persona is loaded from `accounts.md` before generating its content
- Account order: @v0idai (1-2 slots) -> Daily/Info (3-5 slots) -> Bittensor Ecosystem (2-3 slots)
- Different voice, hook, angle per account even on the same topic (Sub-Agent Specialization Pattern)
- See `engine/frameworks/preference-learning.md` for the full curation pipeline

### Step 3b: Gemini Scoring Layer (internal, per content slot)
- OpenClaw (Gemini) scores **all 8 variants** on 6 dimensions (1-10 each): voice match, relevance, hook quality, compliance, uniqueness, data density
- Composite score = average of all 6 dimensions; compliance failure = 0 overall
- Selects **top 4** by composite score, enforcing at least 3 different hook types in the selection
- Randomizes presentation order (A/B/C/D does not correspond to score rank)
- Logs **ALL 8 variants** with full scores to `data/preference-log/preference-log-YYYY-MM-DD.json`
- See `engine/frameworks/gemini-scoring-criteria.md` for the full scoring rubric

### Step 4: Human Selection (reply-gated, curated options)
- Top 4 variants presented to Vew via Telegram as A/B/C/D with hook type labels
- Scores are NOT shown to Vew
- Options: letter (A/B/C/D), letter with edit, regenerate (fresh 8 variants), skip, preview
- On regenerate: 8 new variants generated, scored, filtered, fresh top 4 presented; originals logged with `regenerated: true`
- Selection logged with: variant ID, score rank, whether top-scored was picked, score gap
- Three learning signals captured: Gemini quality scores, Vew's preference, audience engagement (later)
- @v0idai drafts scheduled via OpenTweet; satellite accounts saved to `queue/posted/{account}/` as manually_posted

### Step 5: Scheduled Posting
- Approved content posted at optimal times based on cadence rules
- Respects per-account min gap, daily max, and peak window constraints
- Uses OpenTweet API for posting
- Post IDs recorded for engagement tracking

### Step 6: Engagement Collection (10PM ET, SILENT)
- Collects engagement data for all posts from the day
- Updates `performance-summary.json` and `top-performers.json`
- Flags breakout performers (>3x average engagement)
- Flags significant drops (>30% below average)
- **No messages sent** -- pure data collection

### Step 7: Weekly Calibration (Friday 10:30 AM ET)
- Analyzes full week of engagement data
- Generates Weekly Recap thread (posted to @v0idai)
- Runs voice calibration checks against `engine/frameworks/voice-calibration-loop.md` triggers
- Proposes adjustments to content weights, hook preferences, posting times
- Updates `brand/voice-learnings.md` with structured summary
- Flags any calibration triggers for Vew's approval

---

## Changelog

| Date | Change |
|------|--------|
| 2026-03-25 | Initial framework document created. Three-pillar generation system with daily targets, 7-step process, and pre-launch notes for Pillar C. |
| 2026-03-25 | Updated to reply-gated workflow: Step 2 at 8:30AM (was 9AM), Steps 3-4 are reply-gated (were timed at 10:30AM), Step 7 at Fri 10:30AM (was Fri 12PM). Pillar C weekly calibration reference updated. |
| 2026-03-25 | Lending pivot: added lending keywords to Pillar A+B coverage and routing. Updated account routing from 6 to 4 accounts. Removed Meme/Culture and AI x Crypto routing. Added Daily/Informational routing. |
| 2026-03-25 | Updated Step 3 (Content Drafting) to per-account sequential generation with account-specific persona loading. Replaces single-batch drafting with 4-account mini-review cycles. |
| 2026-03-25 | Two-stage curation: Step 3 generates 8 variants with hook diversity, Step 3b adds Gemini 6-dimension scoring layer, Step 4 presents curated top 4 to Vew. Preference logging for all variants. |
