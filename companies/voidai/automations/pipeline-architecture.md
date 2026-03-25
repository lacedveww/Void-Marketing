# VoidAI Marketing Pipeline Architecture

**Status:** CURRENT
**Last Updated:** 2026-03-22
**Author:** Vew (with Claude Code assistance)
**Canonical for:** End-to-end automation pipeline, system connections, data flows, environment configuration, deployment procedures
**Dependencies:** `CLAUDE.md` (compliance/voice), `roadmap/staged-implementation-breakdown.md` (phased plan), `roadmap/voidai-marketing-roadmap.md` (strategy), `automations/x-lead-nurturing-architecture.md` (lead nurturing, Phase 4), `accounts.md` (account personas), `cadence.md` (timing rules)

---

## Table of Contents

1. [System Overview Diagram](#1-system-overview-diagram)
2. [Data Flow: Content Creation Pipeline](#2-data-flow-content-creation-pipeline)
3. [Data Flow: Automated Metrics Pipeline](#3-data-flow-automated-metrics-pipeline)
4. [Account Management Matrix](#4-account-management-matrix)
5. [Queue System Architecture](#5-queue-system-architecture)
6. [n8n Workflow Map](#6-n8n-workflow-map)
7. [Testing Architecture](#7-testing-architecture)
8. [Environment Variables and Secrets](#8-environment-variables-and-secrets)
9. [Deployment Phases](#9-deployment-phases)
    - [9.1 Crisis Kill Switch Procedure](#91-crisis-kill-switch-procedure)
    - [9.2 Credential Rotation Runbook](#92-credential-rotation-runbook)
10. [Failure Modes and Recovery](#10-failure-modes-and-recovery)
11. [Operational Checklists](#11-operational-checklists)
12. [Sub-Agent Content Generation Architecture](#12-sub-agent-content-generation-architecture)
13. [Content Experimentation Loop](#13-content-experimentation-loop-autoresearch-for-content)
14. [Research Pipeline Tools](#14-research-pipeline-tools)
15. [VoidAI as AI CMO Showcase](#15-voidai-as-ai-cmo-showcase)
16. [Analytics Feedback Loop Architecture](#16-analytics-feedback-loop-architecture)
17. [LarryBrain Skill Marketplace Evaluation](#17-larrybrain-skill-marketplace-evaluation)

---

## 1. System Overview Diagram

```
+===========================================================================+
|                           DATA SOURCES                                     |
|                                                                            |
|  [Taostats API]   [CoinGecko API]   [Bridge PostgreSQL DB]   [GitHub API] |
|  SN106 metrics    TAO price          Transaction history      Commit feed  |
|  Emissions data   Market data        Bridge volume             PR activity |
|  Delegation       Token rankings     Wallet counts                         |
|       |                |                    |                     |        |
+=======|================|====================|=====================|========+
        |                |                    |                     |
        v                v                    v                     v
+===========================================================================+
|                      DATA SERVICE LAYER                                    |
|                                                                            |
|  [Tracker / FastAPI]  (consolidation of TwiterBot + Tracker)               |
|  Endpoints:                                                                |
|    GET /api/bridge/recent         Recent bridge transactions               |
|    GET /api/taostats/price        TAO price + changes                      |
|    GET /api/taostats/subnet/106   SN106 metrics (emissions, TVL, rank)     |
|    GET /api/taostats/delegation   Delegation stats                         |
|    GET /api/metrics/summary       Aggregated daily/weekly metrics          |
|                                                                            |
|  Runs on: DGX Spark (production) / Mac local (dev/test)                   |
|       |                                                                    |
+=======|================================================================+===+
        |
        v
+===========================================================================+
|                    ORCHESTRATION LAYER (n8n)                                |
|                                                                            |
|  n8n Cloud Free Tier (5 workflow limit) -> Self-hosted on DGX Spark later  |
|                                                                            |
|  +---------------------+  +----------------------+  +------------------+   |
|  | WF1: Daily Metrics  |  | WF2: Bridge Alerts   |  | WF3: Weekly      |   |
|  | Cron 10AM ET daily  |  | Webhook: tx>threshold |  | Recap Thread     |   |
|  | -> Tracker API      |  | -> Filter             |  | Cron Fri 2PM ET  |   |
|  | -> Format           |  | -> Claude format      |  | -> 7-day metrics |   |
|  | -> Queue or Post    |  | -> Queue or Post      |  | -> Claude thread |   |
|  +---------------------+  +----------------------+  | -> Queue/review  |   |
|                                                      +------------------+   |
|  +---------------------+  +----------------------+                          |
|  | WF4: News Monitor   |  | WF5: Content          |                          |
|  | Cron every 4 hours  |  | Scheduler             |                          |
|  | -> X API search     |  | Cron 7AM ET daily     |                          |
|  | -> Claude relevance |  | -> Read approved/     |                          |
|  | -> IF score>=7:     |  | -> Enforce cadence    |                          |
|  |    draft to queue   |  | -> Schedule or Post   |                          |
|  +---------------------+  +----------------------+                          |
|                                                                            |
+=======|================================================================+===+
        |
        v
+===========================================================================+
|                   CONTENT GENERATION LAYER                                 |
|                                                                            |
|  [Claude Code CLI]            [Canva Pro]          [Claude API]            |
|  Skills:                      Image generation     Formatting for n8n      |
|    /generate-thread           Data card templates   workflows              |
|    /lending-teaser            Social graphics                              |
|    /queue add                 Blog headers                                 |
|    /weekly-report                                                          |
|    /seo-audit                                                              |
|                                                                            |
|  MCP Servers:                                                              |
|    Canva, Apify, GitHub, Taostats, Slack, AlphaXiv (arXiv search)         |
|                                                                            |
+=======|================================================================+===+
        |
        v
+===========================================================================+
|                    QUEUE SYSTEM (File-Based)                                |
|                                                                            |
|  companies/voidai/queue/                                                   |
|                                                                            |
|  drafts/ -> review/ -> approved/ -> scheduled/ -> posted/                  |
|                 |                                    |                      |
|              rejected/                           failed/                    |
|                                                  cancelled/                 |
|                                                                            |
|  manifest.json  (auto-regenerated, fast lookups)                           |
|  assets/        (images, data cards)                                       |
|                                                                            |
|  YAML frontmatter per file: id, platform, account, pillar,                 |
|  content_type, priority, compliance_passed, review_tier                    |
|                                                                            |
+=======|================================================================+===+
        |
        v
+===========================================================================+
|                 HUMAN REVIEW GATE                                          |
|                                                                            |
|  Vew reviews content in queue/review/ and queue/approved/                  |
|  Actions: approve (move to approved/scheduled), reject, edit               |
|  APPROVAL_GATE=true means ALL content requires manual approval             |
|  Phase 4: gradual gate removal per content type (see Section 9)            |
|                                                                            |
+=======|================================================================+===+
        |
        v
+===========================================================================+
|                  PUBLISHING LAYER                                          |
|                                                                            |
|  [OpenTweet]           [X API Basic]        [Direct API]                   |
|  $6/mo                 $200/mo              Free                           |
|  Phase 2-3 (test)      Phase 3+ (prod)                                    |
|       |                     |                    |                         |
|       v                     v                    v                         |
|  X / Twitter            X / Twitter         LinkedIn (native)              |
|  (@v0idai +             (@v0idai +          Discord (webhooks)             |
|   satellites)            satellites)         Telegram (bot API)             |
|                                                                            |
|  Note: Outstand ($6/mo) for multi-platform publishing once available.      |
|  Until then, direct API calls per platform.                                |
|                                                                            |
+=======|================================================================+===+
        |
        v
+===========================================================================+
|                  MONITORING AND ANALYTICS                                   |
|                                                                            |
|  [X Analytics]    [GA4]           [Taostats]     [Kaito Mindshare]         |
|  Impressions      Website traffic  On-chain       Protocol visibility      |
|  Engagement rate  UTM attribution  Bridge volume  X ecosystem ranking      |
|  Follower growth  Conversions      TVL, emissions                          |
|       |                |                |              |                   |
|       +-------+--------+-------+--------+              |                   |
|               |                |                        |                   |
|               v                v                        v                   |
|       [n8n WF3: Weekly Recap + Attribution Report]                         |
|       -> Claude API summarize                                              |
|       -> Queue for review                                                  |
|       -> voice-learnings.md update recommendations                         |
|                                                                            |
+=======|================================================================+===+
        |
        v
+===========================================================================+
|              FEEDBACK LOOP (Larry/OpenClaw Playbook)                       |
|                                                                            |
|  [collect-engagement.sh]   Daily 10PM ET cron                             |
|  -> Fetches engagement data (likes, RTs, replies, bookmarks, views)       |
|  -> Calculates per-post engagement rates                                  |
|  -> Identifies top performers by pillar, hook type, format                |
|  -> Outputs:                                                              |
|     engagement-YYYY-MM-DD.json  (raw data)                                |
|     performance-summary.json    (injected into generation prompts)         |
|     top-performers.json         (rolling best content reference)           |
|       |                                                                    |
|       v                                                                    |
|  [Content Generation Scripts]                                              |
|  generate-daily-tweet.sh, generate-weekly-thread.sh,                      |
|  generate-news-tweet.sh all load performance-summary.json                 |
|  and inject it into their Claude prompts as PERFORMANCE FEEDBACK           |
|       |                                                                    |
|       v                                                                    |
|  [Weekly Voice Calibration]   Friday 4PM ET cron                          |
|  -> Reads week's engagement data                                          |
|  -> Appends weekly summary to voice-learnings.md                          |
|  -> Checks calibration triggers (engine/frameworks/voice-calibration-loop) |
|  -> Proposes voice weight changes if thresholds met                       |
|       |                                                                    |
|       +-------> feeds back into CONTENT GENERATION (closed loop)          |
|                                                                            |
+===========================================================================+
```

### Component Inventory

| Component | Current Status | Location | Phase Available |
|-----------|---------------|----------|-----------------|
| Tracker/FastAPI | Code exists (TwiterBot + Tracker separate) | DGX Spark / Mac local | Phase 1a (consolidated) |
| n8n | Cloud free tier (5 workflows) | n8n Cloud | Phase 1a |
| Claude Code CLI | Active, with MCP servers | Mac local | Phase 1a |
| Canva Pro | Active | Cloud | Phase 1a |
| OpenTweet | 7-day trial active | Cloud | Phase 2 (test) |
| X API Basic | Not yet activated | Cloud | Phase 3 ($200/mo) |
| File-based queue | Live, 63 approved items | `companies/voidai/queue/` | Phase 1a (live) |
| Discord test server | Being created | Discord | Phase 2 |
| DGX Spark | Expected ~1 week | Local hardware | Phase 1b+ |
| 4070 PC | Available now | Local hardware | Phase 1a (n8n/Tracker fallback) |

---

## 2. Data Flow: Content Creation Pipeline

Every piece of content follows this path from idea to published post. No shortcuts. No exceptions.

### Flow Diagram

```
TRIGGER                    GENERATE                 QUEUE                   REVIEW
+-------------------+     +------------------+     +------------------+    +------------------+
| Manual:           |     | Claude Code CLI  |     | /queue add       |    | Vew reviews in   |
| /generate-thread  | --> | loads config:    | --> | YAML frontmatter | -> | queue/review/ or |
| /lending-teaser   |     | CLAUDE.md        |     | Auto-compliance  |    | queue/approved/  |
| /queue add        |     | company.md       |     | check runs       |    |                  |
| Direct drafting   |     | voice.md         |     | Category A/B/C   |    | Actions:         |
+-------------------+     | compliance.md    |     | Howey risk score |    | - approve        |
                          | pillars.md       |     | Review tier set  |    | - reject + note  |
+-------------------+     | voice-learnings  |     | Cadence check    |    | - edit + approve |
| Automated:        |     +------------------+     | Lands in drafts/ |    +--------+---------+
| n8n WF1 (metrics) |            |                 | or review/       |             |
| n8n WF2 (bridge)  |            v                 +------------------+             |
| n8n WF4 (news)    |     +------------------+                                      v
| n8n WF7 (blog     |     | Canva (if visual)|                              SCHEDULE
|   derivatives)    |     | Data card, header|                        +------------------+
+-------------------+     | Social graphic   |                        | Assign time slot |
                          +------------------+                        | Cadence rules:   |
                                                                      | - per-account    |
                                                                      |   daily limits   |
                                                                      | - inter-account  |
                                                                      |   2hr+ stagger   |
                                                                      | - weekend: max 1 |
                                                                      | - peak windows   |
                                                                      |   per account    |
                                                                      +--------+---------+
                                                                               |
                                                                               v
                                                                        PUBLISH
                                                                  +------------------+
                                                                  | IF DRY_RUN=true: |
                                                                  |   Log output     |
                                                                  |   Stay in queue  |
                                                                  |                  |
                                                                  | IF DRY_RUN=false |
                                                                  | + APPROVAL_GATE  |
                                                                  |   passed:        |
                                                                  |   -> API call    |
                                                                  |   -> Move to     |
                                                                  |      posted/     |
                                                                  |   -> Track UTMs  |
                                                                  +--------+---------+
                                                                           |
                                                                           v
                                                                     ANALYTICS
                                                                  +------------------+
                                                                  | Track: impressions|
                                                                  | engagement, UTM   |
                                                                  | conversions       |
                                                                  | Feed back into    |
                                                                  | voice-learnings   |
                                                                  +------------------+
```

### Step-by-Step Walkthrough

**Step 1: Trigger.** Content creation starts one of two ways:
- **Manual:** Vew runs a Claude Code skill (`/generate-thread`, `/lending-teaser`, or `/queue add`) or drafts content directly.
- **Automated:** An n8n workflow fires on its schedule (cron or webhook) and generates content via Claude API.

**Step 2: Config load.** Before generating any content, the system loads the full config chain per CLAUDE.md (12 files in order). If any file is missing, generation stops and notifies Vew.

**Step 3: Content generation.** Claude generates the content according to voice rules, compliance rules, content pillars, and the specific platform format (X single, X thread, LinkedIn, Discord). Banned phrases are checked. Em dashes are prohibited. Every post must answer "so what" with specific data or actionable insight.

**Step 4: Visual assets (if needed).** For data cards, social graphics, or blog headers, Canva Pro generates the visual via MCP server. Images land in `queue/assets/`.

**Step 5: Queue entry.** Content enters the queue via `/queue add`. On entry:
- YAML frontmatter is attached (id, platform, account, pillar, content_type, priority, review_tier)
- Auto-compliance scan runs (Category A/B/C, disclaimer verification, Howey risk scoring)
- Cadence check validates against per-account limits
- `manifest.json` is regenerated

**Step 6: Human review.** Vew reviews content in `queue/review/` or `queue/approved/`. Every piece is checked against CLAUDE.md voice and compliance rules. Actions: approve, reject with reason, or edit and approve.

**Step 7: Scheduling.** Approved content gets a time slot assigned based on:
- Account-specific peak windows (see cadence.md)
- Minimum gap between posts (2-3 hours depending on account)
- Inter-account stagger for same news (2-6 hours between satellites)
- Weekend reduction (max 1 post/day per account)
- No more than 6 posts/day from any single account

**Step 8: Publishing.** When the scheduled time arrives:
- If `DRY_RUN=true`: output is logged, content stays in queue. No external API call.
- If `DRY_RUN=false` and content has passed the approval gate: API call fires to the appropriate platform.
- On success: content moves to `queue/posted/`, timestamp recorded.
- On failure: content moves to `queue/failed/`, error logged, retry queued.

**Step 9: Analytics tracking.** Every published link includes UTM parameters. Engagement data (impressions, likes, replies, retweets) feeds back into the weekly recap and voice calibration loop.

---

## 3. Data Flow: Automated Metrics Pipeline

### 3.1 Daily Metrics Auto-Post (n8n Workflow 1)

```
[Cron: 10:00 AM ET daily]
        |
        v
[HTTP: Tracker /api/metrics/summary]
        |
        v
[HTTP: Taostats API]  -->  SN106 emissions, rank, mindshare, alpha price
        |
        v
[HTTP: CoinGecko API] -->  TAO price, 24h change, market cap
        |
        v
[Code: Merge + validate data]
        |
        v
[HTTP: Claude API]  -->  Format into metrics post template
        |                  "VoidAI Daily | March 15, 2026
        |                   TAO: $X (+Y%)
        |                   SN106 rank: #Z
        |                   Bridge volume (24h): $W
        |                   ..."
        v
[IF: DRY_RUN check]
   |              |
   v              v
[true]         [false]
Log to         [IF: APPROVAL_GATE]
queue/drafts      |           |
               [true]      [false]
               Queue to    Post via
               review/     OpenTweet/X API
```

### 3.2 Bridge Transaction Alerts (n8n Workflow 2)

```
[Webhook: Bridge DB triggers on new tx > threshold]
        |
        v
[Code: Filter]
   - tx amount > $X threshold (configurable, start at $1,000)
   - Deduplicate (check last 5 min for same tx)
   - Rate limit: max 4 alert tweets/day
        |
        v
[HTTP: Claude API]
   - Format: "A {amount} TAO bridge just completed via VoidAI.
              {source_chain} -> {dest_chain} in {time}.
              Bridge with Chainlink CCIP security: voidai.com/bridge"
        |
        v
[IF: DRY_RUN + APPROVAL_GATE checks]
        |
        v
[Post or queue]
```

### 3.3 Weekly Aggregation and Recap Thread (n8n Workflow 3)

```
[Cron: Friday 2:00 PM ET]
        |
        v
[HTTP: Tracker /api/metrics/summary?period=7d]
        |
        v
[HTTP: GitHub API]  -->  Commits this week, PRs merged, releases
        |
        v
[HTTP: Taostats]  -->  7-day SN106 trend (emissions, rank changes)
        |
        v
[HTTP: CoinGecko]  -->  7-day TAO price trend
        |
        v
[Code: Aggregate all data into structured JSON]
        |
        v
[HTTP: Claude API]
   - Generate 8-10 tweet thread
   - Hook tweet, data tweets, insight tweets, CTA tweet
   - Must follow /generate-thread format
        |
        v
[Queue to review/]  -->  [Vew reviews entire thread]  -->  [Schedule for posting]
```

### 3.4 Ecosystem News Monitor (n8n Workflow 4)

```
[Cron: Every 4 hours]
        |
        v
[HTTP: X API search]
   - Queries: "Bittensor", "$TAO", "SN106", "VoidAI", "cross-chain bridge"
   - Also: RSS feeds from CoinDesk, The Block, Blockworks
        |
        v
[HTTP: Claude API]
   - Score each item 1-10 for relevance to VoidAI ecosystem
   - Criteria: mentions Bittensor, DeFi, bridges, subnets, competitors
        |
        v
[IF: Score >= 7]
        |
        v
[HTTP: Claude API]
   - Draft commentary tweet from @v0idai perspective
   - Must add genuine value, not just "interesting!"
        |
        v
[Queue to drafts/]  -->  [Vew reviews, approves, or discards]
```

### 3.5 Blog Distribution Pipeline (n8n Workflow 7, Phase 3+)

```
[Webhook: New blog post published on voidai.com]
        |
        v
[HTTP: Fetch blog content]
        |
        v
[HTTP: Claude API]  -->  Generate derivatives:
   |    - X thread (10-12 tweets, adapted from blog)
   |    - LinkedIn post (professional tone adaptation)
   |    - Discord announcement (community tone)
   |    - Telegram message (brief summary + link)
   |
   v
[For each derivative:]
   [Queue to review/]  -->  [Vew reviews each]  -->  [Stagger scheduling across platforms]
```

---

## 4. Account Management Matrix

### Primary Accounts

| Account | Platform | Handle | Posting Method | Approval Required | Posts/Day | Peak Windows (UTC) | Thread Freq | Min Gap |
|---------|----------|--------|---------------|-------------------|-----------|-------------------|-------------|---------|
| Main | X | @v0idai | OpenTweet (test) / X API (prod) | Yes (all phases) for original; Phase 4 removes gate for templated | 1-2 | 14:00-16:00, 20:00-22:00 | 1/week | 3 hrs |
| Main | LinkedIn | VoidAI company page | Direct LinkedIn API / manual | Yes (all phases) | 0.3-0.5 (2-3/week) | 14:00-16:00 weekdays | Rare | N/A |
| Main | Discord | #announcements | Webhook | Yes for announcements; auto for bot responses | 0.5-1 | Any | N/A | N/A |
| Main | Telegram | VoidAI channel | Bot API (broadcast) | Yes (all phases) | 0.2-0.3 | Mirrors Discord | N/A | N/A |
| Main | Blog | voidai.com/blog | Direct publish | Yes (all phases, forever) | 0.1-0.3 (1-2/week) | N/A | N/A | N/A |

### Satellite Accounts (X only)

| Account | Handle (TBD) | Posting Method | Approval Required | Posts/Day | Peak Windows (UTC) | Phase Available |
|---------|-------------|---------------|-------------------|-----------|-------------------|-----------------|
| Fanpage | @void_maxi / @sn106_stan | OpenTweet / X API | Yes (Phase 2-3); auto for low-risk in Phase 4 | 1-2 | 13:00-15:00, 21:00-23:00 | Phase 1b (private/locked) |
| Bittensor Ecosystem | @tao_signal / @subnet_watch | OpenTweet / X API | Yes (Phase 2-3); auto for data posts Phase 4 | 1-2 | 14:00-17:00 | Phase 1b (private/locked) |
| DeFi / Cross-Chain | @defi_routes / @chain_flows | OpenTweet / X API | Yes until Phase 4 | 1-2 | 14:00-16:00, 20:00-22:00 | Phase 4 |
| AI x Crypto | @neural_markets / @ai_onchain | OpenTweet / X API | Yes until Phase 4 | 1 | 15:00-17:00 | Phase 4 |
| Meme / Culture | @tao_memes / @subnet_humor | OpenTweet / X API | Yes until Phase 4 | 1-2 | 13:00-15:00, 20:00-22:00 | Phase 4 |

### Owned Internal Accounts (not for public outreach)

| Account | Status | Notes |
|---------|--------|-------|
| @SubnetSummerT | Active, may be repurposed | Potential integration into satellite strategy |
| @gordonfrayne | Active, may be repurposed | May retire or repurpose |

### Inter-Account Coordination Rules

When the same news publishes across multiple accounts:

| Order | Account | Timing | Angle |
|-------|---------|--------|-------|
| 1 | @v0idai (Main) | First | Official announcement |
| 2 | Fanpage | +2 hours minimum | Hype/fan reaction |
| 3 | Bittensor Ecosystem | +3 hours minimum | Ecosystem impact analysis |
| 4 | DeFi / Cross-Chain | +4 hours minimum | Infrastructure/alpha angle |
| 5 | AI x Crypto | +5 hours minimum | AI narrative angle (if relevant) |
| 6 | Meme / Culture | +6 hours minimum (or next day) | Meme/joke angle |

Hard constraint: never more than 2 satellite accounts active in the same 30-minute window.

---

## 5. Queue System Architecture

### Directory Structure

```
companies/voidai/queue/
    manifest.json          Auto-regenerated index of all items
    assets/                Images, data cards, graphics
    drafts/                New content, not yet reviewed
    review/                Flagged for human review
    approved/              Reviewed and approved, awaiting scheduling
    scheduled/             Time slot assigned, awaiting publish time
    posted/                Successfully published
    rejected/              Rejected by reviewer (with reason)
    failed/                Publishing failed (with error)
    cancelled/             Cancelled before publishing
```

### Content File Format

Each content file uses YAML frontmatter:

```yaml
---
id: lt1-lending-teaser-1
status: approved
platform: x
account: v0idai
pillar: bridge-build
content_type: single
priority: 3
compliance_passed: true
review_tier: 1
created_at: "2026-03-13"
scheduled_at: null
posted_at: null
utm_campaign: lending-teaser-p1
---

What if you could borrow against your TAO without selling?

Something is coming to SN106.

voidai.com/lending?utm_source=twitter&utm_medium=post&utm_campaign=lending-teaser-p1
```

### Status Lifecycle

```
draft --> review --> approved --> scheduled --> posted
              |                                   |
              v                                   v
          rejected                             failed --> (retry or cancel)
                                                  |
                                                  v
                                              cancelled
```

### manifest.json

Auto-regenerated on every `/queue` operation. Provides fast lookups without scanning the filesystem. Current state: 63 approved items, 1 rejected, 0 posted (DRY_RUN=true).

### Queue Operations (Claude Code Skills)

| Command | What It Does |
|---------|-------------|
| `/queue add` | Only entry point for queue-ready content. Runs auto-compliance, assigns ID, writes file. |
| `/queue list` | Lists items by status, platform, account, or pillar. |
| `/queue approve <id>` | Moves item from review/ to approved/. |
| `/queue reject <id> <reason>` | Moves to rejected/ with reason. |
| `/queue schedule <id> <time>` | Assigns time slot, moves to scheduled/. Validates cadence rules. |
| `/queue calendar` | Shows upcoming scheduled content across all accounts. |
| `/queue export-batch` | Exports for Notion migration (future). |

---

## 6. n8n Workflow Map

### Free Tier Constraint

n8n Cloud free tier: **5 workflows maximum.** This means we must prioritize.

### Phase 1a-2 Workflows (within 5-workflow limit)

| # | Workflow | Trigger | Data Sources | Output | Priority |
|---|---------|---------|-------------|--------|----------|
| 1 | Daily Metrics Auto-Post | Cron 10AM ET | Tracker, Taostats, CoinGecko | Formatted tweet -> queue | MUST HAVE |
| 2 | Bridge Transaction Alerts | Webhook from Bridge DB | Bridge PostgreSQL | Alert tweet -> queue | MUST HAVE |
| 3 | Weekly Recap Thread | Cron Fri 2PM ET | Tracker, GitHub, Taostats, CoinGecko | 8-10 tweet thread -> queue | MUST HAVE |
| 4 | Ecosystem News Monitor | Cron every 4 hours | X API search, RSS feeds | Commentary drafts -> queue | HIGH |
| 5 | Scheduler/Publisher | Cron every 15 min | queue/scheduled/ | API calls to platforms | MUST HAVE |

**Strategy:** Workflows 1-3 and 5 (Scheduler) are non-negotiable. Workflow 4 (News Monitor) fills the 5th slot. When self-hosting on DGX Spark removes the 5-workflow limit, add Workflows 6-7.

### Phase 3+ Workflows (self-hosted n8n, no limit)

| # | Workflow | Trigger | Data Sources | Output |
|---|---------|---------|-------------|--------|
| 6 | Competitor Monitor | Cron daily 8AM | X API, Taostats | Private Discord DM to Vew |
| 7 | Blog Distribution | Webhook: new blog | Blog content | Derivatives -> queue |

### Phase 4 Workflows (Lead Nurturing, fully specified in x-lead-nurturing-architecture.md)

| # | Workflow | Trigger | Purpose |
|---|---------|---------|---------|
| 8 | Engagement Poller | Cron every 10 min | Detect new engagements with @v0idai |
| 9 | Assignment Engine | Cron every 15 min | Score leads, assign to satellites |
| 10 | Content Generator | Cron every 30 min | Generate contextual replies for leads |
| 11 | Engagement Poster | Cron every 15 min | Post approved interactions |
| 12 | Organic Content Poster | Cron per schedule | Post organic satellite content |
| 13 | Performance Tracker | Cron daily 11PM | Aggregate stats, update scores |
| 14 | Daily Reset | Cron midnight ET | Reset counters, cleanup |

### Workflow 5: Scheduler/Publisher (Detail)

This is the critical workflow that bridges the queue to actual publishing.

```
[Cron: every 15 minutes]
        |
        v
[Read: queue/scheduled/ directory]
   - Find items where scheduled_at <= NOW()
        |
        v
[For each ready item:]
   |
   v
[Switch: platform]
   |
   +-- x --> [IF: DRY_RUN] --> [true: log] / [false: OpenTweet API or X API POST]
   |
   +-- linkedin --> [IF: DRY_RUN] --> [true: log] / [false: LinkedIn API POST]
   |
   +-- discord --> [IF: DRY_RUN] --> [true: log] / [false: Discord webhook POST]
   |
   +-- telegram --> [IF: DRY_RUN] --> [true: log] / [false: Telegram Bot API POST]
        |
        v
[On success: move file to posted/, update manifest.json, log]
[On failure: move file to failed/, log error, queue retry if retries < 3]
```

---

## 7. Testing Architecture

### 7.1 DRY_RUN Flag Behavior

`DRY_RUN` is a global environment variable that prevents ANY external API calls to publishing platforms.

| Component | DRY_RUN=true Behavior | DRY_RUN=false Behavior |
|-----------|----------------------|----------------------|
| n8n Workflow 1-4 | Generates content, saves to queue/drafts/. No external post. | Generates content, saves to queue. Posts after approval. |
| n8n Workflow 5 (Scheduler) | Reads scheduled items, logs "WOULD POST: ..." to console. Does NOT call APIs. | Reads scheduled items, calls publishing APIs. |
| Claude Code `/queue add` | Adds to queue normally. Marks `dry_run_mode: true` in manifest. | Adds to queue normally. |
| Bridge alerts (WF2) | Logs alert content. Does not tweet. | Posts alert tweet (if approved or auto-approved). |
| Lead nurturing (Phase 4) | Entire system runs but posts to test accounts only. | Full production operation. |

**Rule:** DRY_RUN applies to the publishing step only. Content generation, queue management, compliance checks, and scheduling all run normally regardless of DRY_RUN state. This lets you validate the full pipeline without publishing.

### 7.2 Test Account Setup

| Test Environment | Purpose | Setup |
|-----------------|---------|-------|
| Private X alt account | Test tweet posting, thread creation, API integration | Create private/locked X account. Never make public. |
| Discord test server | Test webhooks, bot responses, channel structure | Create private Discord server mirroring production channels: #announcements, #general, #bridge-support, #lending-alpha, #dev-sdk |
| n8n test mode | Validate workflows without cron triggers | All workflows start in manual execution mode. Click "Execute" to test. Only switch to cron after sign-off. |
| Queue test items | Validate queue lifecycle | Create test items with `test-` prefix IDs. Run through full lifecycle. Delete after testing. |

### 7.3 Manual Testing Procedures

**For each n8n workflow (WF1-5):**

1. Set `DRY_RUN=true`
2. Run workflow in manual mode (click "Execute Workflow" in n8n)
3. Verify each node executes without error
4. Check output format matches expected template
5. Verify content lands in correct queue directory with correct frontmatter
6. Check compliance: no banned phrases, no em dashes, has "so what" insight
7. Verify error handling: disconnect a data source, confirm graceful failure
8. Run 3 times to check for consistency
9. Sign off in testing checklist

**For queue system:**

1. `/queue add` a test item. Verify file created in drafts/ with correct frontmatter.
2. Move to review/. Verify manifest updates.
3. `/queue approve` the item. Verify it moves to approved/.
4. `/queue schedule` with a time. Verify cadence rules enforced.
5. Trigger WF5 (Scheduler) in manual mode with DRY_RUN=true. Verify "WOULD POST" log.
6. Set DRY_RUN=false, point at test X account. Verify actual post appears.
7. Verify file moves to posted/.
8. Test rejection flow: `/queue reject` with reason. Verify file moves to rejected/.
9. Test failure handling: use invalid API credentials. Verify file moves to failed/.

**For publishing APIs:**

1. OpenTweet: POST a test tweet to private X alt. Verify content, timing, and rate limits.
2. Discord webhook: POST a test message to test server #announcements. Verify formatting.
3. LinkedIn: POST a test update (can delete immediately). Verify formatting.

### 7.4 Smoke Test Checklist

Run this checklist before each deployment phase transition.

| # | Test | Expected Result | Pass/Fail | Date |
|---|------|----------------|-----------|------|
| 1 | Tracker /api/metrics/summary returns data | 200 OK with valid JSON | [ ] | |
| 2 | Taostats API returns SN106 data | Valid subnet metrics | [ ] | |
| 3 | CoinGecko API returns TAO price | Valid price data | [ ] | |
| 4 | n8n WF1 manual run completes | Content in queue/drafts/ | [ ] | |
| 5 | n8n WF2 webhook triggers on test tx | Alert content generated | [ ] | |
| 6 | n8n WF3 manual run completes | Thread in queue/drafts/ | [ ] | |
| 7 | n8n WF4 manual run completes | News items scored, drafts created | [ ] | |
| 8 | n8n WF5 with DRY_RUN=true processes item | "WOULD POST" log entry | [ ] | |
| 9 | n8n WF5 with DRY_RUN=false posts to test account | Tweet appears on private alt | [ ] | |
| 10 | Queue /queue add creates valid file | File in drafts/ with correct YAML | [ ] | |
| 11 | Queue approve/reject/schedule all work | Correct file moves | [ ] | |
| 12 | manifest.json regenerates correctly | Counts match filesystem | [ ] | |
| 13 | Compliance auto-check catches banned phrase | Item flagged, not auto-approved | [ ] | |
| 14 | Cadence check rejects over-limit scheduling | Error message, item not scheduled | [ ] | |
| 15 | Discord webhook delivers message | Message in test server | [ ] | |
| 16 | Claude API returns on-brand content | Passes manual voice check | [ ] | |
| 17 | Error handling: API timeout | Graceful failure, logged, no crash | [ ] | |
| 18 | Error handling: invalid credentials | Clear error message, no data loss | [ ] | |

### 7.5 Rollback Procedures

| Severity | Trigger | Immediate Action | Recovery |
|----------|---------|-----------------|----------|
| **Low** | Single bad post (wrong data, tone-off) | Delete the post. Flag the template/workflow that produced it. Continue operations. | Review and fix the specific template or prompt. Re-test. |
| **Medium** | Workflow producing consistently bad output (3+ bad items) | Set `DRY_RUN=true` for that specific workflow. Review all output from last 24 hours. | Fix prompt, data source, or logic. Re-test with 5 manual runs. Sign off before re-enabling. |
| **High** | Compliance violation or 3+ incidents in 24 hours | Set `DRY_RUN=true` globally (ALL workflows). Pause all posting. Alert team. | Full audit of all systems. Review every queued item. Fix root cause. Get explicit sign-off before resuming. |
| **Critical** | Security incident, API key compromise, or unauthorized posting | Full shutdown: stop all n8n workflows, revoke all API keys, lock all accounts. | Security audit. Generate new API keys. Re-verify all systems from scratch. |

**Rollback command (emergency):**
Set `DRY_RUN=true` in n8n environment variables. This immediately stops all external publishing across all workflows. The queue keeps working internally.

---

## 8. Environment Variables and Secrets

### 8.1 Feature Flags

| Variable | Values | Default | Where Set | Purpose |
|----------|--------|---------|-----------|---------|
| `EMERGENCY_STOP` | `true` / `false` | `false` | n8n env vars | **Crisis kill switch.** Halts ALL workflows before any external API call. Takes priority over DRY_RUN and all other flags. See `crisis.md` for activation/recovery procedures. |
| `DRY_RUN` | `true` / `false` | `true` (fail-safe: defaults to dry-run if undefined or missing) | n8n env vars, `.env` | Prevents all external publishing API calls. If the variable is undefined, deleted, or set to any value other than the exact string `false`, the system treats it as dry-run mode. See n8n-workflow-specs.md "DRY_RUN Fail-Safe Logic" for implementation details. |
| `APPROVAL_GATE` | `true` / `false` | `true` | n8n env vars, `.env` | Requires human approval for every post |
| `APPROVAL_GATE_METRICS` | `true` / `false` | `true` | n8n env vars | Separate gate for daily metrics (remove first in Phase 4) |
| `APPROVAL_GATE_ALERTS` | `true` / `false` | `true` | n8n env vars | Separate gate for bridge alerts |
| `APPROVAL_GATE_NEWS` | `true` / `false` | `true` | n8n env vars | Separate gate for news commentary |
| `APPROVAL_GATE_DERIVATIVES` | `true` / `false` | `true` | n8n env vars | Separate gate for blog derivatives |
| `APPROVAL_GATE_ORIGINAL` | `true` / `false` | `true` | n8n env vars | Separate gate for original content (NEVER auto-remove) |

### 8.2 API Keys

| Variable | Service | Where Stored | Phase Needed | Monthly Cost |
|----------|---------|-------------|-------------|-------------|
| `OPENTWEET_API_KEY` | OpenTweet | n8n credentials store | Phase 2 (test) | $6/mo (trial: $0) |
| `X_API_KEY` | X/Twitter API Basic | n8n credentials store | Phase 3 | $200/mo |
| `X_API_SECRET` | X/Twitter API Basic | n8n credentials store | Phase 3 | (included) |
| `X_ACCESS_TOKEN` | X/Twitter per-account | n8n credentials store | Phase 3 | (included) |
| `X_ACCESS_SECRET` | X/Twitter per-account | n8n credentials store | Phase 3 | (included) |
| `TAOSTATS_API_KEY` | Taostats | n8n credentials store + `.env` | Phase 1a | $0 |
| `COINGECKO_API_KEY` | CoinGecko | n8n credentials store | Phase 1a | $0 |
| `CLAUDE_API_KEY` | Claude API (for n8n) | n8n credentials store | Phase 1a | Via Claude Max |
| `CANVA_API_TOKEN` | Canva Pro | MCP server config | Phase 1a | $0 (Pro plan) |
| `GITHUB_TOKEN` | GitHub API | MCP server config + n8n | Phase 1a | $0 |
| `DISCORD_WEBHOOK_URL` | Discord test server | n8n credentials store | Phase 2 | $0 |
| `DISCORD_WEBHOOK_PROD` | Discord production | n8n credentials store | Phase 3 | $0 |
| `SLACK_TOKEN` | Slack (internal alerts) | MCP server config | Phase 1a | $0 |
| `LINKEDIN_ACCESS_TOKEN` | LinkedIn API | n8n credentials store | Phase 3 | $0 |
| `TELEGRAM_BOT_TOKEN` | Telegram Bot API | n8n credentials store | Phase 3+ | $0 |
| `OUTSTAND_API_KEY` | Outstand | n8n credentials store | Phase 3 (when available) | ~$6/mo |

### 8.3 Configuration Variables

| Variable | Default | Purpose |
|----------|---------|---------|
| `BRIDGE_TX_THRESHOLD` | `100` | Minimum TAO bridge amount to trigger alert (WF2) |
| `BRIDGE_ALERTS_MAX_PER_DAY` | `4` | Maximum bridge alert tweets per day |
| `NEWS_RELEVANCE_THRESHOLD` | `7` | Minimum Claude relevance score to draft news commentary (WF4) |
| `WEEKLY_RECAP_DAY` | `friday` | Day of week for weekly recap thread (WF3) |
| `WEEKLY_RECAP_TIME` | `14:00` | Time (ET) for weekly recap |
| `DAILY_METRICS_TIME` | `10:00` | Time (ET) for daily metrics post (10 AM ET = 14:00 UTC in summer, 15:00 UTC in winter, both within peak window) |
| `SCHEDULER_INTERVAL_MIN` | `15` | How often WF5 checks for ready-to-post items |
| `MAX_RETRIES` | `3` | Number of publishing retries before moving to failed/ |
| `V0IDAI_X_USER_ID` | (set on setup) | Numeric X user ID for @v0idai |

### 8.4 Storage Locations

| Secret Type | Development | Testing | Production |
|-------------|------------|---------|------------|
| API keys | `.env` file (git-ignored) | n8n credentials store | n8n encrypted credentials + secrets manager (Phase 4) |
| Feature flags | `.env` file | n8n environment variables | n8n environment variables |
| Config values | `.env` file | n8n environment variables | n8n environment variables |
| Satellite X credentials | Not needed | n8n credentials store (per account) | Secrets manager (independently revocable) |

**Security rules:**
- `.env` is in `.gitignore`. Never committed.
- n8n credentials store is encrypted with `N8N_ENCRYPTION_KEY`.
- Each satellite account's X API credentials are independently revocable.
- Phase 4 (lead nurturing): PostgreSQL + Redis credentials in secrets manager, not in env vars.

---

## 9. Deployment Phases

### Phase 2: TEST (Days 8-14)

**Goal:** Everything runs with DRY_RUN=true on private/test accounts. Validate the pipeline end-to-end.

| Component | State | What to Validate |
|-----------|-------|-----------------|
| DRY_RUN | `true` | All workflows generate content but never publish externally |
| APPROVAL_GATE | `true` | All content requires manual review |
| n8n workflows 1-5 | Manual execution mode | Run each 3+ times, verify output quality |
| Queue system | Live | Full lifecycle test (add, review, approve, schedule, post to test account) |
| OpenTweet | 7-day trial | Post to private X alt account only |
| Discord | Test server | Webhooks deliver correctly |
| Tracker/FastAPI | Running | Returns valid data from all endpoints |
| Satellite accounts | Private/locked | Created but not posting publicly |
| Content | 63 approved items in queue | Review all against CLAUDE.md voice and compliance |

**Daily routine during TEST:**
1. Run each workflow manually once
2. Review all generated output for quality
3. Log issues in testing checklist
4. Fix bugs, tune prompts
5. Re-run fixed workflows

**Exit criteria for TEST:**
- [ ] All 5 workflows execute without error for 3 consecutive days
- [ ] All generated content passes manual brand voice review (>90% publish-ready)
- [ ] DRY_RUN flag correctly prevents all external publishing
- [ ] Queue lifecycle (draft to posted) works end-to-end
- [ ] Error handling gracefully catches API failures
- [ ] Compliance auto-check catches known bad content

### Phase 3: SOFT LAUNCH (Days 12-14+)

**Goal:** DRY_RUN=false, APPROVAL_GATE=true. Real publishing with manual approval on every piece.

| Component | State Change | Action |
|-----------|-------------|--------|
| DRY_RUN | `true` -> `false` | Set in n8n env vars |
| APPROVAL_GATE | `true` (stays) | No change |
| n8n workflows 1-4 | Manual -> Cron triggers | WF1: 10AM ET daily. WF3: Fri 2PM ET. WF4: every 4h. WF2: webhook (always on). |
| n8n workflow 5 (Scheduler) | Manual -> Cron every 15 min | Processes scheduled/ items |
| OpenTweet | Test -> Production @v0idai | Switch API credentials to production account |
| X API Basic | Not active -> Active ($200/mo) | Activate when OpenTweet trial ends |
| Discord | Test -> Production | Switch webhook URL to production server |
| LinkedIn | Not active -> Manual posting | Direct API or manual posting |
| 1st satellite account | Private -> Public | Bittensor Ecosystem satellite starts organic posting |

**Go-Live Day checklist (Day 12):**

Morning:
- [ ] Deploy Stage 0 website fixes (Lorem Ipsum, Twitter card, meta keywords)
- [ ] Verify website changes live

Afternoon:
- [ ] Set `DRY_RUN=false` in n8n environment
- [ ] Verify `APPROVAL_GATE=true` is set for all gate variables
- [ ] Switch n8n WF1 from manual to cron (10AM ET daily)
- [ ] Switch n8n WF3 from manual to cron (Fri 2PM ET)
- [ ] Switch n8n WF4 from manual to cron (every 4 hours)
- [ ] Switch n8n WF5 from manual to cron (every 15 minutes)
- [ ] Verify WF2 webhook is connected to Bridge DB
- [ ] Pin "What is VoidAI" thread on @v0idai
- [ ] Post first content from queue (manually approve, let scheduler publish)
- [ ] Monitor first 3 automated posts closely

**Soft Launch success criteria (must meet ALL before Phase 4):**

| Metric | Threshold | Current |
|--------|-----------|---------|
| Days of clean operation (no incidents) | 7+ consecutive | [ ] |
| Content approval rate | >90% of generated content approved as-is | [ ] |
| Workflow reliability | 100% uptime, zero failed runs | [ ] |
| Engagement trend | Upward over 7 days | [ ] |
| Compliance violations | 0 | [ ] |

### Phase 4: FULL DEPLOY (Day 21+)

**Goal:** Gradual gate removal per content type. Shift to autonomous operation.

**Gate removal schedule:**

| Week | Gate Removed | Variable Changed | Justification |
|------|-------------|-----------------|---------------|
| Week 3 | Daily metrics + bridge alerts | `APPROVAL_GATE_METRICS=false`, `APPROVAL_GATE_ALERTS=false` | Templated, data-driven, low risk. 2+ weeks of clean output. |
| Week 4 | News commentary (score >= 8 only) | `APPROVAL_GATE_NEWS=false` (with score threshold increase) | Proven accurate over 2+ weeks. |
| Week 5 | Blog derivative content | `APPROVAL_GATE_DERIVATIVES=false` | Pipeline proven reliable. |
| Week 6+ | Original content (A/B tested) | Gradual, per content type | After A/B testing validates quality. |

**NEVER remove approval gate for:**
- Pillar blog posts
- Media pitches
- Partnership communications
- Crisis response content
- Financial claims or yield data
- Lending platform content with specific numbers

**Phase 4 infrastructure additions:**

| Component | Purpose | Infrastructure |
|-----------|---------|---------------|
| Self-hosted n8n | Remove 5-workflow limit | DGX Spark |
| PostgreSQL (marketing) | Lead nurturing data | DGX Spark (SEPARATE from Bridge DB) |
| Redis | Rate limiting, cooldowns, caching | DGX Spark |
| Mautic | Email campaigns, lead scoring | DGX Spark (Docker) |
| Hermes Agent | Content orchestrator with self-improvement | DGX Spark |
| ElizaOS | Discord/Telegram community bot | DGX Spark |
| Lead nurturing workflows (8-14) | Automated satellite engagement | n8n self-hosted |

### 9.1 Crisis Kill Switch Procedure

When a crisis requires immediately halting all publishing (bridge exploit, security incident, regulatory action, or other emergency), follow this procedure. The goal is to stop all external output within 60 seconds.

**Immediate halt (choose the fastest available method):**

**Method A: EMERGENCY_STOP variable (preferred, fastest)**
1. Open n8n dashboard > Settings > Variables
2. Set `EMERGENCY_STOP` = `true`
3. This takes effect on the next workflow execution. All workflows check this variable before any external API call and will halt immediately with a Discord log message.
4. Note: any workflow execution already in progress will complete its current node before checking the variable. If a tweet is mid-publish, it may still go out.

**Method B: DRY_RUN toggle (backup)**
1. Open n8n dashboard > Settings > Variables
2. Set `DRY_RUN` = `true`
3. Same behavior as EMERGENCY_STOP for publishing, but without the explicit "crisis" logging.

**Method C: Deactivate all workflows (most thorough)**
1. Open n8n dashboard > Workflows
2. Click the toggle switch to deactivate each active workflow (WF1 through WF5)
3. This prevents any future executions from starting. Does not stop executions already in progress.
4. Use this if you need to guarantee no new executions will start at all.

**Method D: Full shutdown (nuclear option)**
1. If self-hosted: stop the n8n Docker container (`docker stop n8n`)
2. If n8n Cloud: deactivate all workflows (Method C is the equivalent)
3. Revoke API keys at provider dashboards if credential compromise is suspected

**Post-halt checklist:**
- [ ] Verify no new posts appeared after the halt was activated
- [ ] Check the last 30 minutes of posts across all accounts for problematic content
- [ ] Delete any published content that is part of the crisis
- [ ] Notify relevant stakeholders
- [ ] Document the incident using the template in Section 11.4
- [ ] Do NOT re-enable publishing until the root cause is identified and resolved

**Re-enabling after crisis resolution:**
1. Fix the root cause
2. Test the fix with `DRY_RUN=true` and `EMERGENCY_STOP=false`
3. Run each affected workflow manually and verify output
4. Set `DRY_RUN=false` only after explicit sign-off
5. Monitor the first 3 automated executions closely

### 9.2 Credential Rotation Runbook

All API keys should be rotated at least every 90 days, or immediately if a compromise is suspected. This section documents every credential, how to rotate it, and how to verify the rotation succeeded.

**Credential inventory:**

| # | Credential | Service | Used By | Rotation Method | Verification |
|---|-----------|---------|---------|-----------------|-------------|
| 1 | `TAOSTATS_API_KEY` | Taostats | WF1, WF3, WF6 | Generate new key at taostats.io dashboard. Update in n8n Settings > Variables. | Run WF1 manually; verify Taostats nodes return 200. |
| 2 | `COINGECKO_API_KEY` | CoinGecko | WF1, WF3 | Generate new demo key at coingecko.com developer portal. Update in n8n. | Run WF1 manually; verify CoinGecko nodes return 200. |
| 3 | `OPENTWEET_API_KEY` | OpenTweet | WF1, WF2, WF5 (posting) | Generate new key at opentweet.io dashboard. Update in n8n. | With DRY_RUN=false, post a test tweet to the private alt account. |
| 4 | `X_API_KEY` / `X_API_SECRET` | X Developer Portal | WF1 (posting), WF4, WF6 (search) | Regenerate at developer.x.com > Projects > Keys and Tokens. Update both values in n8n. | Run WF4 manually (search only); verify X API search returns results. |
| 5 | `X_ACCESS_TOKEN` / `X_ACCESS_SECRET` | X Developer Portal | WF1 (posting as @v0idai) | Regenerate at developer.x.com > Projects > Keys and Tokens > Access Token. Update both values in n8n. Also update the OAuth 1.0a credential in n8n Credentials store. | With DRY_RUN=false, post a test tweet to verify write access. |
| 6 | `X_API_BEARER_TOKEN` | X Developer Portal | WF4, WF6 (search) | Regenerate at developer.x.com > Projects > Keys and Tokens > Bearer Token. Update in n8n. | Run WF4 manually; verify search node returns results. |
| 7 | `CLAUDE_API_KEY` | Anthropic Console | WF3, WF4, WF6, WF7 | Generate new key at console.anthropic.com > API Keys. Revoke old key. Update in n8n AND in Claude Code MCP config. | Run WF3 manually; verify Claude API node returns generated content. |
| 8 | `DISCORD_WEBHOOK_URL` | Discord Server Settings | All workflows (notifications) | Create new webhook at Discord Server > Settings > Integrations > Webhooks. Delete old webhook. Update in n8n. | Run any workflow manually; verify Discord notification arrives. |
| 9 | `DISCORD_ANNOUNCE_WEBHOOK` | Discord Server Settings | WF7, publishing | Same as above but for #announcements channel. | Post test message to #announcements via the new webhook URL. |
| 10 | `GITHUB_TOKEN` | GitHub Settings | WF3 | Generate new PAT at github.com > Settings > Developer settings > Personal access tokens. Revoke old token. Update in n8n and MCP config. | Run WF3 manually; verify GitHub commits node returns data. |
| 11 | `LINKEDIN_ACCESS_TOKEN` | LinkedIn Developer Portal | Direct posting (Phase 3+) | Re-authorize OAuth flow. LinkedIn tokens expire every 60 days. Update in n8n. | Post test update (can delete immediately). |
| 12 | `TELEGRAM_BOT_TOKEN` | Telegram BotFather | Telegram channel (Phase 3+) | Revoke and regenerate via /revoke command to @BotFather. Update in n8n. | Send test message to test channel via Bot API. |
| 13 | `OUTSTAND_API_KEY` | Outstand dashboard | Multi-platform publishing (Phase 3+) | Generate new key at Outstand dashboard. Update in n8n. | Post test via Outstand API. |
| 14 | WF2/WF7 webhook Header Auth | n8n Credentials store | WF2, WF7 | Update the Header Auth credential in n8n Credentials. Update the corresponding header value in the sending service (Tracker/FastAPI for WF2, CMS for WF7). | Send test webhook request with new header; verify n8n accepts it. Send request with old header; verify n8n rejects with 401. |

**Rotation procedure (generic):**

1. Generate the new key/token at the provider's dashboard
2. Update the value in n8n (Settings > Variables or Credentials store, depending on the credential)
3. Run a manual test of each workflow that uses the credential (with DRY_RUN=true for posting workflows)
4. Verify the workflow completes without authentication errors
5. Revoke the old key at the provider's dashboard (only after confirming the new key works)
6. Log the rotation date in the credential tracking table below

**Rotation tracking:**

| Credential | Last Rotated | Next Due (90 days) | Rotated By |
|-----------|-------------|-------------------|-----------|
| TAOSTATS_API_KEY | (fill on setup) | | |
| COINGECKO_API_KEY | (fill on setup) | | |
| OPENTWEET_API_KEY | (fill on setup) | | |
| X_API_KEY / X_API_SECRET | (fill on setup) | | |
| X_ACCESS_TOKEN / X_ACCESS_SECRET | (fill on setup) | | |
| X_API_BEARER_TOKEN | (fill on setup) | | |
| CLAUDE_API_KEY | (fill on setup) | | |
| DISCORD_WEBHOOK_URL | (fill on setup) | | |
| GITHUB_TOKEN | (fill on setup) | | |
| WF2/WF7 Header Auth | (fill on setup) | | |

**Reminders:** Set a recurring calendar reminder every 90 days to review this table and rotate any credentials that are due. During the monthly review (Section 11.3), check this table as part of the "Audit all active API keys" task.

---

## 10. Failure Modes and Recovery

### 10.1 Data Source Failures

| Component | Failure Mode | Detection | Impact | Recovery |
|-----------|-------------|-----------|--------|----------|
| Taostats API | Down / timeout | n8n HTTP node returns error | WF1 (daily metrics) and WF3 (weekly recap) cannot get SN106 data | Use cached data from last successful call (cache TTL: 24h). Skip SN106 metrics in post. Add note: "SN106 data temporarily unavailable." Retry next cycle. |
| CoinGecko API | Down / timeout | n8n HTTP node returns error | Cannot get TAO price | Use cached price. Mark as "price as of [timestamp]." Retry next cycle. |
| Bridge DB | Down / disconnected | WF2 webhook stops firing | No bridge alerts | Alerts simply stop. Not critical. Manual check: query Tracker /api/bridge/recent. |
| GitHub API | Rate limited / down | n8n HTTP node returns error | WF3 weekly recap missing commit data | Omit development section from recap. Add: "Dev update coming separately." |
| Tracker/FastAPI | Service crash | n8n HTTP node returns connection error | WF1, WF2, WF3 all fail | Restart Tracker service. If persistent: fall back to direct API calls to Taostats/CoinGecko from n8n (bypass Tracker). |

### 10.2 Publishing Failures

| Component | Failure Mode | Detection | Impact | Recovery |
|-----------|-------------|-----------|--------|----------|
| OpenTweet API | Down / rate limited | HTTP 429 or 5xx from API | Cannot post to X | Exponential backoff: retry at 1 min, 5 min, 15 min. After 3 failures: move to failed/, alert Vew via Discord. Manual posting fallback. |
| X API Basic | Rate limited | HTTP 429 with rate limit headers | Cannot post to X | Respect rate limit headers. Queue posts for next available window. X API Basic allows 100 posts/24h per user (sufficient for all accounts). |
| X API Basic | Account suspended / restricted | HTTP 403 | All X posting stops for that account | Immediately stop posting from affected account. Check X account status. If suspended: do NOT attempt workarounds. Contact X support. Use other platforms. |
| Discord webhook | Invalid / deleted | HTTP 404 | Discord announcements fail | Generate new webhook URL. Update n8n credentials. |
| LinkedIn API | Token expired | HTTP 401 | LinkedIn posts fail | Refresh OAuth token. LinkedIn tokens expire every 60 days, set reminder. |

### 10.3 Content Quality Failures

| Failure Mode | Detection | Immediate Action | Root Cause Fix |
|-------------|-----------|-----------------|---------------|
| Bad content published (wrong data) | Manual observation or community report | Delete the post within 15 minutes. Post correction if needed. | Review data source. Was the API returning bad data? Was the prompt misformatting? Fix and re-test. |
| Off-brand content published | Manual observation during review | Delete if already posted. Flag the template/prompt. | Review voice-learnings.md. Update prompt with counter-example. Re-test. |
| Compliance violation published | Community report, legal review, or auto-detection | Delete immediately. Assess severity per rollback table (Section 7.5). | Full compliance audit. Review what bypassed the auto-check. Strengthen auto-check rules. |
| Duplicate content across accounts | Manual observation | Delete from satellite(s). Keep on main @v0idai. | Review inter-account coordination timing. Increase stagger window. |
| Bot-like posting pattern detected | X rate limit warning, community comment | Reduce posting frequency for 48 hours. Review timing patterns. | Add more randomization to scheduling jitter. Reduce daily volume. |

### 10.4 Infrastructure Failures

| Component | Failure Mode | Detection | Impact | Recovery |
|-----------|-------------|-----------|--------|----------|
| n8n Cloud | Platform outage | n8n status page, workflows stop firing | All automated workflows stop | Manual posting fallback. Queue still works (file-based). Publish manually from approved/ items. Check n8n status page. |
| n8n self-hosted | Process crash | Docker healthcheck fails, systemd alert | All automated workflows stop | Docker restart policy: `always`. If persistent: check logs, disk space, memory. Restart container. |
| DGX Spark | Hardware failure / power loss | Cannot reach any service | n8n, Tracker, PostgreSQL, Redis all down | Fallback to Mac local for Tracker. Fallback to n8n Cloud free tier. Queue (file-based) still works on Mac. Manual posting. |
| Mac local | Unavailable | Cannot run Claude Code | No manual content generation, no queue management | n8n workflows continue autonomously (if DRY_RUN=false). Approve content from phone via Discord bot (future). |
| File system (queue) | Corruption / data loss | manifest.json out of sync | Queue state inconsistent | Regenerate manifest.json from filesystem. Queue files are the source of truth, not the manifest. Git history provides backup. |

### 10.5 API Key Compromise

| Scenario | Immediate Action (within 15 minutes) | Follow-up |
|----------|--------------------------------------|-----------|
| X API key compromised | Revoke key in X Developer Portal. Pause all n8n workflows. | Generate new key. Update n8n credentials. Review recent posts for unauthorized content. |
| OpenTweet key compromised | Revoke in OpenTweet dashboard. Pause WF5. | Generate new key. Update n8n credentials. |
| Claude API key compromised | Revoke in Anthropic Console. | Generate new key. Update n8n credentials and MCP config. |
| Any satellite account compromised | Lock the specific account. Revoke its API credentials independently. Do NOT touch other accounts. | New credentials for that account only. Security audit on credential storage. |

---

## 11. Operational Checklists

### 11.1 Daily Soft Launch Routine (Phase 3)

| Time (ET) | Activity | Duration | Tools |
|-----------|----------|----------|-------|
| 8:30 AM | Check overnight: n8n workflow runs (any failures?), brand mentions, DMs | 15 min | n8n dashboard, X notifications |
| 10:00 AM | Review and approve daily metrics post (auto-generated by WF1) | 5 min | Queue, `/queue approve` |
| 9:30 AM | Review queued content batch (2-3 items). Approve, reject, or edit. | 15 min | Queue, `/queue list`, `/queue approve` |
| 10:00 AM | Reply engagement: 5-10 quality replies on X Tier 1-2 accounts | 30-45 min | X Pro lists, manual |
| 1:00 PM | Review news monitor outputs (WF4), approve if relevant | 10 min | Queue |
| 2:00 PM | Approve afternoon content batch | 10 min | Queue |
| 5:00 PM | End-of-day review: what posted, engagement metrics, any issues | 15 min | X Analytics, n8n logs |

**Total daily active time: ~1.5-2 hours**

### 11.2 Weekly Review Routine (Friday)

| Task | Duration | Output |
|------|----------|--------|
| Review weekly recap thread (auto-generated by WF3) | 15 min | Approve or edit thread |
| Review analytics: impressions, engagement, follower growth | 20 min | Note trends |
| Review content-to-product attribution (UTM data) | 15 min | Which content drove bridge usage? |
| Update voice-learnings.md with what worked/what did not | 15 min | Updated voice guidance |
| Plan next week's content calendar | 20 min | Editorial priorities |
| Check competitor monitor digest (WF6, Phase 3+) | 10 min | Any responses needed? |
| Verify all n8n workflows ran successfully this week | 10 min | Fix any recurring failures |

### 11.3 Monthly Review

| Task | Output |
|------|--------|
| Compare KPIs against targets (followers, engagement, bridge usage) | KPI report |
| Review and adjust posting cadence based on 30 days of data | Updated cadence.md if needed |
| Review and adjust peak posting windows based on engagement data | Updated cadence.md if needed |
| Audit all active API keys. Rotate any that are 90+ days old. | Security hygiene |
| Review queue rejection rate. If >20%, investigate content generation quality. | Prompt improvements |
| Cost review: actual spend vs budget | Budget adjustment |

### 11.4 Incident Response Template

When something goes wrong, fill in this template and save to `companies/voidai/incidents/YYYY-MM-DD-description.md`:

```
# Incident: [Brief Description]
**Date:** YYYY-MM-DD HH:MM ET
**Severity:** Low / Medium / High / Critical
**Status:** Investigating / Mitigated / Resolved

## What Happened
[One paragraph description]

## Impact
- What was affected?
- How many posts/accounts/users impacted?
- Duration of impact?

## Timeline
- HH:MM - First detection
- HH:MM - Initial response
- HH:MM - Mitigation applied
- HH:MM - Resolved

## Root Cause
[What actually went wrong]

## Resolution
[What was done to fix it]

## Prevention
[What changes will prevent this from recurring]
- [ ] Action item 1
- [ ] Action item 2
```

---

## 12. Sub-Agent Content Generation Architecture

Adapted from Anthropic's internal ad workflow (source: @itsolelehmann, 9.1K likes, 4.4M views), where a single non-technical marketer uses Claude Code with specialized sub-agents. Their flow: export ad performance CSV, Claude identifies underperformers, deploys specialized sub-agents (one for 30-char headlines, one for 90-char descriptions), Figma plugin auto-inserts copy, MCP server connects to Meta API for real-time performance, memory system learns from experiments. Result: ad creation 2hrs to 15min, 10x creative output.

### VoidAI Adaptation: Per-Account Sub-Agents

Each satellite account is treated as a specialized sub-agent with distinct optimization targets. See `accounts.md` "Sub-Agent Specialization Pattern" for the full specification.

**Batch generation workflow:**
1. Select topic or news trigger
2. For each relevant account, run the account-specific sub-agent with its constraints (voice, length, format, optimization target)
3. Generate 5-10 variations per account
4. Select best 1-2 per account via internal ranking (hook strength, data specificity, compliance pass, format match)
5. Route selected content to `/queue add` with correct account and pillar tags
6. Track which variations were selected vs. discarded to improve future generation

**Key principle:** Sub-agents specialize by constraint (character limit, optimization metric, format), not just by topic. The Fanpage sub-agent is optimized for engagement metrics (replies, QRTs) at under 200 chars. The DeFi sub-agent is optimized for actionable alpha with specific numbers. This mirrors Anthropic's headline agent (30-char) vs. description agent (90-char) specialization.

---

## 13. Content Experimentation Loop (Autoresearch for Content)

Inspired by the Karpathy autoresearch pattern (source: @gregisenberg, 4.1K likes, 425K views), which runs continuous experimentation: set objectives, plan, modify, test, evaluate, keep winners. Applied to content optimization.

### The Loop

```
SET OBJECTIVES          PLAN                  MODIFY               TEST
+------------------+   +------------------+   +------------------+  +------------------+
| Weekly goals:    |   | For each account:|   | Generate content |  | Publish A/B      |
| - Engagement %   |-->| - Pick 2 hooks   |-->| variations:      |->| pairs:           |
| - Reply rate     |   | - Pick 2 formats |   | - Hook A vs B    |  | - Same topic     |
| - Follower       |   | - Pick 2 posting |   | - Format A vs B  |  | - Different      |
|   growth         |   |   times          |   | - Time A vs B    |  |   variable       |
+------------------+   +------------------+   +------------------+  | - Track which    |
       ^                                                            |   wins           |
       |                                                            +--------+---------+
       |                                                                     |
       |    KEEP WINNERS                EVALUATE                             |
       |    +------------------+        +------------------+                 |
       +----| Update voice-    |<-------| After 48 hours:  |<---------------+
            | learnings.md     |        | - Which hook got  |
            | with winning     |        |   more engagement|
            | patterns         |        | - Which format   |
            | Flag losers to   |        |   drove more     |
            | avoid            |        |   replies        |
            +------------------+        | - Which time got |
                                        |   more impressions|
                                        +------------------+
```

### What to Experiment On

| Variable | Experiment Format | Tracking Method |
|----------|------------------|-----------------|
| Hook style | Same content, different first line (question vs. data vs. hot take) | Compare engagement rate within 48 hours |
| Post length | Short (under 150 chars) vs. full (250+ chars) for same topic | Compare impressions and engagement rate |
| Posting time | Same content type at different peak windows (e.g., 14:00 UTC vs. 20:00 UTC) | Compare impressions |
| Thread vs. single | Same topic as thread vs. condensed single tweet | Compare engagement, replies, bookmarks |
| Data specificity | Vague ("volume is up") vs. specific ("$2.1M bridged in 24h, +33% WoW") | Compare engagement and retweets |
| Cashtag placement | $TAO in hook vs. mid-tweet vs. no cashtag | Compare impressions (cashtags affect X algo) |
| CTA style | No CTA vs. soft CTA ("worth watching") vs. direct CTA ("bridge now: voidai.com") | Compare click-through |

### Rules for Experiments

1. Only run ONE experiment variable at a time per account (isolate the variable)
2. Each experiment needs minimum 4 data points (2 per variant) before declaring a winner
3. Results go into `brand/voice-learnings.md` with the date, account, variable tested, and winner
4. Never experiment with compliance-sensitive content (financial claims, yield data)
5. Experiments are tracked in the weekly report (`/weekly-report`)

---

## 14. Research Pipeline Tools

### AlphaXiv MCP Server (arXiv Paper Search)

**Tool:** AlphaXiv MCP (@askalphaxiv, 3K likes, 251K views)
**What it does:** Multi-turn retrieval, keyword search, and embedding search across millions of arXiv papers. Enables finding relevant academic research for content generation.

**Use cases for VoidAI:**
- Find papers on cross-chain bridge architectures, security models, and formal verification for Alpha & Education content
- Track new Bittensor/decentralized training research for Ecosystem Intelligence content
- Find DeFi protocol analysis papers for the DeFi / Cross-Chain account
- Monitor AI/ML research that connects to Bittensor's compute marketplace thesis for AI x Crypto account

**Integration point:** Add to MCP server config alongside Canva, Apify, GitHub, Taostats, Slack. Use in content generation when producing technical deep-dives, tutorial threads, or ecosystem analysis that benefits from academic sourcing.

**Search queries to configure:**
- "decentralized machine learning training" (Bittensor core thesis)
- "cross-chain bridge security" (VoidAI product relevance)
- "DeFi liquidity optimization" (DeFi account content)
- "federated learning incentive mechanisms" (subnet economics)
- "blockchain interoperability protocols" (bridge technology)

---

## 15. VoidAI as AI CMO Showcase

### The Opportunity

Okara AI (@askOkara, 27.6K likes, 13.7M views) launched as "World's first AI CMO," where you enter a website URL and it deploys agent teams for traffic and growth. This validates massive market interest in AI-powered marketing automation.

VoidAI's marketing pipeline is already more sophisticated than most AI marketing tools in several ways:
- Domain-specific intelligence (on-chain data, Bittensor metrics, bridge volume as content triggers)
- Multi-persona satellite account strategy with compliance-aware coordination
- File-based queue with human review gate and audit trail
- Sub-agent specialization per account
- Content experimentation loop with voice-learnings feedback

### Strategic Options

**Option A: Content showcase (low effort, high signal)**
Build-in-public content about how VoidAI uses Claude Code + sub-agents + MCP servers to run its marketing. This is Ecosystem Intelligence + Alpha & Education content that also demonstrates VoidAI's technical sophistication. "How SN106 runs its marketing with AI agents" is a compelling narrative.

**Option B: Open-source the framework (medium effort, ecosystem play)**
Extract the universal engine (`engine/`) into a standalone framework that other Bittensor projects (or crypto projects generally) could use for compliant, multi-account marketing. This positions VoidAI as infrastructure beyond just bridging.

**Option C: Product/service (high effort, revenue potential)**
Offer "AI CMO for crypto projects" as a service or product, leveraging the existing pipeline. Unlike Okara (generic), VoidAI's version would be crypto-native with built-in compliance (Howey risk scoring, FTC satellite disclosure, no financial advice automation).

**Recommended near-term action:** Option A. Write 2-3 build-in-public threads about the pipeline for the AI x Crypto account and main @v0idai account. Track engagement. If strong, consider Option B.

---

## Appendix A: Quick Reference Card

### Emergency Stops

| Action | How |
|--------|-----|
| **Crisis: halt ALL publishing instantly** | Set `EMERGENCY_STOP=true` in n8n Settings > Variables. See Section 9.1 for full procedure. |
| Stop ALL automated publishing | Set `DRY_RUN=true` in n8n environment variables |
| Stop a single workflow | Deactivate the workflow in n8n dashboard |
| Stop all n8n | Stop the n8n container/process |
| Lock an X account | Change password + revoke all app permissions in X settings |
| Revoke all API keys | Visit each provider dashboard (X Dev Portal, OpenTweet, Anthropic Console). See Section 9.2 for the full credential inventory. |

### Key URLs (fill in during setup)

| Service | URL | Notes |
|---------|-----|-------|
| n8n dashboard | `https://[your-instance].app.n8n.cloud` | Or `http://localhost:5678` if self-hosted |
| X Developer Portal | `https://developer.x.com` | API key management |
| OpenTweet dashboard | `https://opentweet.io` | Posting API |
| Anthropic Console | `https://console.anthropic.com` | Claude API key management |
| Canva | `https://canva.com` | Design assets |
| Taostats | `https://taostats.io` | SN106 metrics reference |
| VoidAI website | `https://voidai.com` | Production site |
| Queue directory | `companies/voidai/queue/` | File-based content queue |
| Voice learnings | `companies/voidai/brand/voice-learnings.md` | Performance-based voice updates |

### Configuration Files (Load Order)

1. `CLAUDE.md` (system-level rules, never bypassed)
2. `companies/voidai/company.md` (identity, products, URLs)
3. `companies/voidai/voice.md` (tone, registers, platform rules)
4. `companies/voidai/accounts.md` (account personas, coordination)
5. `companies/voidai/compliance.md` (prohibitions, disclaimers)
6. `engine/compliance/base-rules.md` (universal FTC/quality)
7. `engine/compliance/modules/` (per compliance.md)
8. `companies/voidai/pillars.md` (content pillars, weights)
9. `companies/voidai/cadence.md` (frequency, timing, spacing)
10. `companies/voidai/competitors.md` (competitive landscape)
11. `companies/voidai/metrics.md` (KPIs, anchor metrics)
12. `companies/voidai/crisis.md` (crisis triggers, recovery)
13. `companies/voidai/brand/voice-learnings.md` (before content generation)
14. `companies/voidai/design-system.md` (for visual content)

---

## 16. Analytics Feedback Loop Architecture

This section documents the feedback loop that closes the gap between content publishing and content improvement. Inspired by the Larry/OpenClaw marketing playbook (Oliver Henry, @oliverhenry): generate content, post it, track analytics, learn from data, generate better content.

### 16.1 Data Flow: Feedback Loop

```
PUBLISH                    COLLECT                   ANALYZE                  LEARN
+------------------+      +------------------+      +------------------+     +------------------+
| post-to-x.sh    |      | collect-          |      | performance-     |     | Content gen      |
| Posts tweet/     | ---> | engagement.sh    | ---> | summary.json     | --> | scripts load     |
| thread via       |      | Daily 10PM ET    |      | Per-post rates   |     | summary into     |
| OpenTweet API    |      | Fetches likes,   |      | By pillar, hook, |     | Claude prompts   |
|                  |      | RTs, replies,    |      | format, time     |     | as PERFORMANCE   |
| Moves content to |      | bookmarks, views |      |                  |     | FEEDBACK section |
| queue/posted/    |      | from OpenTweet/  |      | top-performers   |     |                  |
+------------------+      | X API            |      | .json (top 10)   |     | AI sees what     |
                          +------------------+      +------------------+     | worked before    |
                                                                             | and adjusts      |
                                                                             | hooks, format,   |
                                                                             | framing          |
                                                                             +--------+---------+
                                                                                      |
                                                                                      v
                                                                               CALIBRATE
                                                                        +------------------+
                                                                        | Weekly Voice     |
                                                                        | Calibration      |
                                                                        | Friday 4PM ET    |
                                                                        |                  |
                                                                        | Appends weekly   |
                                                                        | summary to       |
                                                                        | voice-learnings  |
                                                                        | .md              |
                                                                        |                  |
                                                                        | Checks triggers  |
                                                                        | for weight       |
                                                                        | changes          |
                                                                        +------------------+
```

### 16.2 Key Files

| File | Purpose | Updated By | Read By |
|------|---------|-----------|---------|
| `data/engagement-YYYY-MM-DD.json` | Raw daily engagement data | `collect-engagement.sh` (daily) | Weekly voice calibration job |
| `data/performance-summary.json` | Aggregated summary for prompt injection | `collect-engagement.sh` (daily) | All content generation scripts |
| `data/top-performers.json` | Rolling top 10 best-performing posts | `collect-engagement.sh` (daily) | Content generation scripts, weekly calibration |
| `brand/voice-learnings.md` | Human-readable performance log + calibration record | Weekly voice calibration job | All content generation (via CLAUDE.md config load) |

### 16.3 How the Feedback Loop Improves Content

1. **Prompt injection**: Every content generation script (`generate-daily-tweet.sh`, `generate-weekly-thread.sh`, `generate-news-tweet.sh`) loads `performance-summary.json` and injects a `PERFORMANCE FEEDBACK` section into the Claude prompt. This tells Claude what hook types, formats, and content pillars performed best recently, so it can lean into proven patterns.

2. **Voice calibration**: The weekly calibration job appends structured engagement data to `voice-learnings.md`. Since Claude reads this file before every content generation (per CLAUDE.md config load order item 13), it accumulates an ever-growing understanding of what works for the VoidAI audience.

3. **Trigger-based weight changes**: When engagement patterns hit quantitative thresholds (per `engine/frameworks/voice-calibration-loop.md`), the system flags voice weight adjustments for Vew's approval. This prevents slow drift and ensures the voice stays calibrated.

4. **A/B test integration**: The feedback data enables structured A/B testing of hooks, formats, and voice registers. Results accumulate in `voice-learnings.md` and automatically influence future content.

### 16.4 Comparison: Before vs After Feedback Loop

| Aspect | Before (blind posting) | After (feedback loop) |
|--------|----------------------|---------------------|
| Hook selection | Default voice rules only | Data-informed: uses top-performing hook types |
| Content type mix | Fixed pillar weights | Adaptive: pillars with higher engagement get more emphasis |
| Format choice | Arbitrary single vs thread | Performance data shows which format works per content type |
| Voice drift detection | Manual, reactive | Automated weekly checks with quantitative triggers |
| Content improvement | Requires manual analysis | Automatic: every prompt includes recent performance data |

---

## 17. LarryBrain Skill Marketplace Evaluation

### 17.1 What is LarryBrain?

LarryBrain (larrybrain.com) is a skill marketplace for OpenClaw agents, built by Oliver Henry. It offers 30+ professional marketing automation skills that install locally on your OpenClaw instance. Key characteristics:

- **Pricing**: Free tier available, Pro at $29.99/mo for full skill library
- **Security**: Skills install locally, credentials stay local, triple-layer security review
- **Scope**: Skills for X analytics, content scheduling, engagement automation, TikTok, conversion tracking

### 17.2 Skills Potentially Relevant to VoidAI Pipeline

| Skill Category | Potential Benefit | VoidAI Already Has? | Worth Exploring? |
|---------------|-------------------|--------------------|-----------------|
| X Analytics / Engagement Tracking | Automated engagement data collection from X | Partially (collect-engagement.sh via OpenTweet) | Yes, if it provides deeper X-native metrics |
| Content Scheduling | Multi-platform scheduling with optimization | Yes (WF5 scheduler + OpenTweet) | Low priority, existing solution works |
| A/B Testing | Automated variant testing and winner selection | No (manual A/B tests defined in voice-learnings.md) | Yes, could automate test management |
| Conversion Tracking | End-to-end attribution from post to action | No (UTM params defined but not tracked) | Yes, this is a major gap |
| TikTok Automation (LarryLoop) | Automated TikTok content + conversion tracking | No TikTok presence | Future consideration if TikTok becomes a channel |
| Competitor Monitoring | Automated competitor activity tracking | Partially (Job 7 does basic competitor intel) | Maybe, depends on depth vs existing setup |

### 17.3 ROI Evaluation Framework

Before subscribing to LarryBrain Pro ($29.99/mo), evaluate against these criteria:

**Evaluate each skill on:**
1. **Does it replace manual work?** Quantify hours saved per week.
2. **Does it close a gap?** Specifically: conversion tracking and A/B test automation are the biggest current gaps.
3. **Can we build it ourselves?** If the skill is simple (e.g., basic X scraping), building it is cheaper long-term.
4. **Data ownership**: Verify all data stays local. No skill should export credentials or analytics to third parties.
5. **Integration cost**: How much work to integrate with existing pipeline (queue system, cron jobs, voice-learnings.md)?

**Decision threshold:** Subscribe if 2+ skills would save >2 hours/week combined and close a gap that would take >8 hours to build internally.

### 17.4 Recommendation

**Current assessment: Do not subscribe yet.** Rationale:

1. The feedback loop gap (the biggest gap identified) is now closed by `collect-engagement.sh` + performance summary injection + weekly voice calibration. This was the primary Larry insight.
2. Conversion tracking remains a gap, but requires UTM infrastructure on voidai.com (GA4 setup) before any external tool can help.
3. A/B testing automation would be valuable but is Phase 4+ scope.
4. $29.99/mo is reasonable but the VoidAI pipeline is still in Phase 2-3 (testing/soft launch). Adding external dependencies before the core pipeline is stable adds risk.

**Revisit when:**
- Phase 3 soft launch is stable (7+ days clean operation)
- GA4 + UTM tracking is live on voidai.com
- Manual A/B testing in voice-learnings.md becomes burdensome (>3 concurrent tests)
- A specific LarryBrain skill would demonstrably save >2 hours/week

---

## Changelog

| Date | Change |
|------|--------|
| 2026-03-15 | Initial pipeline architecture document created. Covers full system: data sources, processing, content generation, queue, publishing, monitoring, testing, environment config, deployment phases, failure recovery. |
| 2026-03-15 | Post-audit updates: corrected all WF1 cron references from 9 AM to 10 AM ET; added Section 9.1 (Crisis Kill Switch Procedure) and Section 9.2 (Credential Rotation Runbook); updated DRY_RUN fail-safe default documentation in Section 8.1; updated DAILY_METRICS_TIME in Section 8.3; added EMERGENCY_STOP to Appendix A Emergency Stops table. |
| 2026-03-22 | Added Sections 16-17 (Analytics Feedback Loop Architecture, LarryBrain Skill Marketplace Evaluation). Feedback loop closes the biggest gap: generate -> post -> track -> learn -> generate better. |
| 2026-03-22 | Added Sections 12-15: Sub-Agent Content Generation Architecture (per-account sub-agents, batch generation), Content Experimentation Loop (autoresearch for content), Research Pipeline Tools (AlphaXiv MCP for arXiv search), VoidAI as AI CMO Showcase (Okara competitive response, strategic options). Added AlphaXiv to MCP servers in system diagram. Renumbered sections 12-17 for sequential file order. Updated TOC. |
