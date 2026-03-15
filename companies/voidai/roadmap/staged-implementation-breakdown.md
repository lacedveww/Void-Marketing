# VoidAI Marketing: Staged Implementation Breakdown

**Status:** CURRENT
**Last Updated:** 2026-03-13
**Canonical for:** Implementation plan, day-by-day tasks, tool stack, workflow specs, testing procedures
**Dependencies:** `CLAUDE.md` (brand/compliance), `roadmap/voidai-marketing-roadmap.md` (strategy), `automations/x-lead-nurturing-architecture.md` (lead nurturing)

**Build Everything -> Test in Sandbox -> Soft Launch with Approval Gate -> Full Autonomous Deploy**

---

## Overview: The Four Phases (Revised)

| Phase | Name | Duration | Monthly Cost | Key Output | Your Hours/Week |
|-------|------|----------|-------------|------------|-----------------|
| **1a** | LAUNCH CRITICAL | Days 1-7 | ~$46 | Website fixed, daily posting live, 4 core workflows built, first content published | 30-35 |
| **1b** | POST-LAUNCH BUILD | Days 8-21 | ~$46 | Skills/tools installed, agents deployed, content backlog, 1 satellite account created | 25-30 |
| **2** | TEST | Days 8-14 (overlaps 1b) | ~$46 | DRY_RUN validation on private accounts | 20-25 |
| **3** | SOFT LAUNCH | Days 12-14+ | ~$261-276 | Go live with approval gate, lending teasers begin | 20-25 |
| **4** | FULL DEPLOY | Day 21+ | ~$276-390 | Remove approval gate, fully autonomous | 16-21 |

**Timeline constraint:** Lending platform launches in 3-8 weeks (as of 2026-03-12). Soft Launch must be 1-2 weeks before that. Target: Soft Launch by Day 12-14.

**Cardinal rule:** Nothing gets posted publicly until Soft Launch. All building happens first. Testing happens on private/test accounts only.

---

## Updated Tool Stack

> This supersedes the tool stack in `roadmap/voidai-marketing-roadmap.md` Section 4. The roadmap retains cost analysis and budget alternatives.

### Claude Code Skills Layer

| Source | What You Get | Action |
|--------|-------------|--------|
| **`coreyhaines31/marketingskills`** (fork) | 34 production-ready marketing skills | Fork repo, audit and adapt 5-8 most relevant for VoidAI crypto context (not all 34) |
| **`ComposioHQ/awesome-claude-skills`** (install) | Twitter/X, LinkedIn, Discord, Social Media Generator, SEO (22+ commands), Competitive Intelligence, YouTube, Canva, Connect (1000+ services) | Install directly; audit overlap with marketingskills before building custom |
| **Custom VoidAI skills** (build only what Composio doesn't cover) | `/generate-thread`, `/lending-teaser`, `/weekly-report`, `/seo-audit` | Build as SKILL.md files |

### Autonomous Agent Layer (Phase 4 -- deferred from Phase 1)

| Agent | Role | Deployment | Phase |
|-------|------|-----------|-------|
| **Hermes Agent** | Marketing orchestrator. Persistent memory, self-improving skills, multi-channel, cron scheduler, MCP integration. | DGX Spark | Phase 4 (Claude Max handles content gen in Phase 1-3) |
| **ElizaOS** | Web3-specific community bot. Wallet queries, on-chain verification, bridge support, FAQ. | DGX Spark | Late Phase 3 |

### Email & Lead Management Layer (Phase 3+)

| Tool | Cost | Purpose | Phase |
|------|------|---------|-------|
| **Mautic** (self-hosted) | $0 | Email campaigns, lead scoring, behavioral tracking, contact segmentation, form builders. | Phase 3: basic setup. Phase 4: full integration |

Mautic custom crypto extensions (wallet validation, on-chain scoring, token holder segmentation) are stretch goals for Phase 4+.

### Existing Tools (Keep)

| Tool | Cost | Purpose |
|------|------|---------|
| Claude Max | $20/mo | Cognitive engine |
| Google AI Pro | $20/mo | NotebookLM, Google Flow, Opal |
| n8n (self-hosted) | $0 | Workflow orchestration |
| Figma/Canva | $0 | Design system, quick graphics |
| Outstand API | ~$6/mo | Multi-platform publishing |
| X/Twitter API Basic | $200/mo | Programmatic posting (activated Phase 3) |
| Dune/CoinGecko/Taostats APIs | $0 | On-chain data |

### Testing Environment

Every system must have:

| Requirement | Implementation |
|-------------|---------------|
| `DRY_RUN=true` flag | Environment variable preventing public posting; logs output |
| Private X alt account | Private/locked alt for testing tweet workflows |
| Discord test server | Private server mirroring production channel structure |
| n8n manual/test mode | All workflows start in manual execution, not cron-triggered |
| Content staging queue | Approval gate: `draft` -> `queued` -> `approved` -> `scheduled` -> `posted` |

---

## Phase 1a: LAUNCH CRITICAL (Days 1-7)

**Goal:** Get visible immediately. Fix credibility issues, start posting, begin community engagement, build 4 core workflows. This is the absolute minimum for a solo operator to establish presence before the lending platform launches.

> **DEPENDENCY CHAIN:** Day 1 (website fixes + posting) -> Day 2 (pinned thread + amplification) -> Day 3 (staging queue + teaser) -> Days 4-7 (workflows + blog). Each day depends on prior day completing.

### Day 1: Website Fixes + Start Posting (~3 hours)

**Critical Path: These fixes must happen before any content drives traffic.**

| # | Fix | Time | Why |
|---|-----|------|-----|
| 1 | Remove Lorem Ipsum from voidai.com/roadmap | 15 min | Destroys credibility on visit |
| 2 | Fix Twitter card meta tag: @voidai -> @v0idai | 5 min | Social previews link to wrong account |
| 3 | Remove `<meta keywords>` tag | 2 min | Signals outdated SEO practices |

**Then start posting:**
- Post 1 tweet from @v0idai (even a simple metrics post: "$X bridged today via VoidAI")
- Set up X Pro lists for Tier 1-2 accounts (see roadmap Section 8)
- Begin reply engagement: 5 quality replies on Bittensor ecosystem posts (zero product mentions)

### Day 2: Pinned Thread + Amplification (~3 hours)

- Write and pin "What is VoidAI" thread on @v0idai (5-7 tweets: bridge + lending + SDK + why it matters)
- Amplify existing media coverage: quote-tweet ainvest, Systango, AltcoinBuzz, SubnetEdge articles
- Update LinkedIn page: logo, banner, about section, website link
- Continue 5 replies/day engagement
- Set up content staging queue (use Discord channel with approval reactions, or Notion database)

### Day 3: First Lending Teaser + Staging Queue (~3 hours)

- Post first lending teaser: "What if you could borrow against your TAO without selling?"
- **Content staging queue is live** at `queue/` -- file-based with YAML frontmatter, managed via `/queue` skill commands
  - Statuses: `draft -> review -> approved -> scheduled -> posted` with `rejected`, `failed`, `cancelled` branches
  - Auto-compliance checks on add (Category A/B/C scan, disclaimer verification, Howey risk scoring, review tier assignment)
  - Cadence enforcement on schedule (per-account limits, inter-account stagger, weekend rules)
  - `manifest.json` auto-regenerated on every operation for fast lookups
  - Templates in `engine/templates/` for X single, X thread, LinkedIn, Discord
  - Structured for 1:1 Notion migration later via `/queue export-batch`
- Verify staging queue: `/queue add`, `/queue list`, `/queue approve`, `/queue schedule`, `/queue calendar`
- Post 2-3 tweets (ecosystem commentary, data drop)
- Continue reply engagement (5 replies)

### Day 4-5: n8n + Workflows 1-2 (~8 hours total)

- Install n8n self-hosted on DGX Spark (or fallback: n8n Cloud free tier / local Mac)
- Consolidate TwiterBot + Tracker into unified FastAPI data service with endpoints: `/api/bridge/recent`, `/api/taostats/price`, `/api/taostats/subnet/106`, `/api/metrics/summary`
- **Build Workflow 1 -- Daily Metrics Auto-Post** (manual execution mode):
  - Trigger -> Tracker /api/metrics/summary -> Taostats -> CoinGecko -> Claude API format -> IF DRY_RUN: log to staging queue, ELSE: Outstand API post
- **Build Workflow 2 -- Bridge Transaction Alerts:**
  - Webhook (new tx > threshold) -> Filter -> Claude API generate tweet -> IF DRY_RUN: log, ELSE: post
- Test both end-to-end: data in -> formatted post -> staging queue
- Continue daily posting + 5 replies

### Day 6: First Pillar Blog Post (~4 hours)

- Draft pillar blog post: "What is VoidAI: The Liquidity Layer for Bittensor" (2000-3000 words)
- Generate blog header image (Google Flow or Canva)
- Continue daily posting + 5 replies + 1 lending teaser

### Day 7: Blog Publish + Workflow 3 (~4 hours)

- Publish blog post to voidai.com/blog
- Cut derivatives manually: X thread (10-12 tweets), LinkedIn post, Discord announcement
- **Build Workflow 3 -- Weekly Recap Thread:** manual trigger -> 7-day metrics -> GitHub commits -> Claude API 8-10 tweet thread -> staging queue for review
- Continue daily posting + 5 replies

---

## Phase 1b: POST-LAUNCH BUILD (Days 8-21)

**Goal:** Build out remaining skills, tools, workflows, agents, content backlog, and 1 satellite account. Overlaps with TEST phase.

> **DEPENDENCY:** Phase 1a must be complete (website fixed, posting cadence established, 3 core workflows built).

### Days 8-10: Skills & Tools (~12 hours)

- Fork `coreyhaines31/marketingskills` repo. Audit all 34 skills. Adapt 5-8 most relevant for VoidAI crypto context.
- Install from Composio: Twitter/X Automation, LinkedIn Automation, Discord Automation, Social Media Generator, SEO Automation. Configure with DRY_RUN=true.
- Audit overlap: check which Composio skills cover `/generate-thread`, `/seo-audit`, `/weekly-report` before building custom.
- Build remaining custom skills (only what Composio doesn't cover):
  - `/generate-thread`: topic + data -> formatted 10-15 tweet thread with hook variants
  - `/lending-teaser`: phase (1-5) + metrics -> platform-specific teaser content
- Configure MCP server connections: Dune Analytics, CoinGecko, Taostats, GitHub, X API, Google Analytics

### Days 10-12: Workflows 4-6 + Mautic Basic Setup (~10 hours)

- **Workflow 4 -- Ecosystem News Monitor:** cron (manual) -> X API search + RSS -> Claude score relevance -> IF >= 7: draft commentary -> staging queue
- **Workflow 5 -- Blog Distribution Pipeline:** webhook -> read content -> Claude generate derivatives (thread, LinkedIn, Discord, Telegram) -> staging queue
- **Workflow 6 -- Competitor Monitor:** daily -> X API search competitors -> Taostats -> Claude summarize -> private Discord DM
- Basic Mautic deployment: Docker on DGX Spark, SMTP config, contact segments (bridge users, stakers, lending waitlist), welcome email sequence (3 emails)

### Days 12-14: Content Backlog + 1 Satellite Account (~10 hours)

- Write pillar blog post 2: "How to Bridge TAO to Solana with VoidAI" (tutorial)
- Pre-build lending teaser content for all 5 phases (3-4 variants each)
- Build 1 week of daily content backlog (daily metrics templates, tweets, LinkedIn posts)
- Create 1 satellite X account (Bittensor Community Page, e.g., @TaoInsider) -- private/locked initially
- Begin organic posting from satellite (private mode, 1-2 posts/day for voice calibration)
- Draft media outreach pitches (TaoApe, SubnetEdge, Bittensor Guru) -- NOT sent until Soft Launch

### Days 15-17: Agent Deployment (~10 hours)

- **ElizaOS** (late Phase 3): Deploy to DGX Spark. Configure VoidAI character file. Load protocol docs into vector DB. Connect to Discord/Telegram test servers. Test FAQ scenarios.
- NotebookLM notebooks: VoidAI technical docs, competitor research, Bittensor ecosystem news
- Set up Google Search Console for voidai.com
- Run Claude Code `/seo-audit` on voidai.com

### Days 18-21: Community Infrastructure (~8 hours)

- Discord server restructure: #announcements, #general, #bridge-support, #lending-alpha, #dev-sdk, #memes
- Telegram channel setup with welcome messages
- Minimal Zealy quest campaign design (3-5 educational quests, NOT launched yet)
- Begin Bittensor community X Space attendance (listen, contribute value in chat)

---

## Phase 2: TEST (Days 8-14, Overlapping with Phase 1b)

**Goal:** Validate every system end-to-end with DRY_RUN=true on private accounts. Find bugs, tune prompts, adjust workflows.

### Testing Protocol

For each system: Deploy with DRY_RUN=true -> Run on private accounts -> Validate output quality (brand voice, compliance, accuracy) -> Test error handling -> Fix bugs, tune prompts -> Sign off.

### Day 8-10: Workflow Testing

- Run each workflow (1-6) in manual mode end-to-end
- Validate data ingestion from all API sources
- Verify Claude API formatting produces on-brand output
- Check DRY_RUN flag correctly prevents external posting
- Verify content lands in staging queue with correct metadata
- Test error handling: API down, rate limited, unexpected data

### Day 10-12: Content Review & Quality Audit

- Review ALL queued content against CLAUDE.md (brand voice, compliance, accuracy)
- Score each piece: Publish as-is / Needs edits / Needs rewrite / Cut
- Walk through lending teaser sequence -- verify escalation makes narrative sense
- Time-stamp each teaser phase for Soft Launch deployment schedule

### Day 12-13: End-to-End Pipeline Validation

- Full pipeline test: simulated blog publish -> Workflow 5 triggers -> derivatives -> staging queue -> approve -> DRY_RUN catches
- Full day simulation: morning metrics post, bridge alerts, news scan, content generation -- review all outputs
- Log issues, fix bugs, re-run failed tests

### Testing Checklist

| System | Tested | Issues Found | Issues Fixed | Sign-Off |
|--------|--------|-------------|-------------|----------|
| Workflow 1: Daily Metrics | [ ] | | | [ ] |
| Workflow 2: Bridge Alerts | [ ] | | | [ ] |
| Workflow 3: Weekly Recap | [ ] | | | [ ] |
| Workflow 4: News Monitor | [ ] | | | [ ] |
| Workflow 5: Blog Distribution | [ ] | | | [ ] |
| Workflow 6: Competitor Monitor | [ ] | | | [ ] |
| Content staging queue (`/queue` skill) | [ ] | | | [ ] |
| DRY_RUN flag (all systems) | [ ] | | | [ ] |
| Claude Code skills (all) | [ ] | | | [ ] |
| Staging queue -> approval flow | [ ] | | | [ ] |
| Content quality (full audit) | [ ] | | | [ ] |

---

## Phase 3: SOFT LAUNCH (Days 12-14, Then Ongoing)

**Goal:** Flip DRY_RUN=false with approval gate ON. Deploy Stage 0 fixes. Start publishing with manual approval on every piece. Begin engagement strategy. Launch lending teasers.

**Cardinal rule:** The approval gate stays ON. Every piece of content requires manual approval before posting.

### Day 12: Go-Live

**Morning:** Deploy Stage 0 emergency fixes (website, Twitter card, LinkedIn -- all prepped in Phase 1a).

**Afternoon:**
- Set DRY_RUN=false on all systems
- Verify approval gate is ON and functional
- Switch n8n workflows from manual to cron triggers (Workflow 1: 9 AM ET daily, Workflow 3: Friday 2 PM ET, Workflow 4: every 4 hours, Workflow 6: daily)
- Pin "What is VoidAI" thread (already written)

### Day 12-13: First Public Content (Staggered)

- Hour 0: Pin thread + LinkedIn update
- Hour 1-2: Post first pillar blog + trigger Workflow 5 derivative cascade
- Hour 3-4: Amplify existing coverage (quote-tweets) + first lending teaser
- Hour 6+: First automated daily metrics post fires
- Begin reply engagement on X Pro lists: 5-10 quality replies/day

### Day 13-14: Ramp Up

- 2-3 tweets/day from staging queue (approved individually)
- 1 LinkedIn post/day, 1-2 Discord posts
- Lending teasers: 1 per day, following Phase 1-2 escalation
- Publish second pillar blog post + derivative pipeline
- Send media outreach pitches (TaoApe, SubnetEdge, Bittensor Guru)

### Day 14+: Establish Operating Rhythm

**Daily Soft Launch routine:**

| Time | Activity | Time Est |
|------|----------|----------|
| 8:30 AM | Review overnight: workflow outputs, brand mentions | 15 min |
| 9:00 AM | Approve daily metrics post (auto-generated) | 5 min |
| 9:30 AM | Review and approve queued content (2-3 posts) | 15 min |
| 10:00 AM | Reply engagement: 5-10 quality replies on X | 30-45 min |
| 1:00 PM | Review news monitor outputs, approve if relevant | 10 min |
| 2:00 PM | Approve afternoon content batch | 10 min |
| 5:00 PM | End-of-day review: what posted, engagement metrics | 15 min |

### Soft Launch Success Criteria (Before Moving to Phase 4)

| Metric | Threshold |
|--------|-----------|
| Days of clean operation | 7+ |
| Content approval rate | >90% |
| Workflow reliability | 100% |
| Engagement trend | Upward |
| Compliance violations | 0 |

**Do NOT move to Phase 4 until all criteria are met.**

### Rollback Plan

| Severity | Trigger | Action |
|----------|---------|--------|
| **Low** | Single bad post | Delete post, flag template for review, continue |
| **Medium** | Bot gives incorrect info | Pull bot offline, review knowledge base, redeploy to test |
| **High** | Compliance violation or 3+ incidents in 24h | Revert ALL to DRY_RUN=true. Pause posting. Review everything. |
| **Critical** | Security incident or API abuse | Full shutdown. Revoke API keys. Audit all systems. |

**Rollback is always to DRY_RUN=true** -- the content queue keeps working, nothing goes public.

---

## Phase 4: FULL DEPLOY (Day 21+)

**Goal:** Remove approval gate on proven content types. Shift to fully autonomous operation. Vew operates as AI Systems Architect.

### Transition: Gradual Gate Removal

| Week | Gate Removed | Justification |
|------|-------------|---------------|
| Week 3 | Daily metrics + bridge alerts | Templated, data-driven, low risk |
| Week 4 | Ecosystem news (scored >= 8) + ElizaOS FAQ | Proven accurate over 2+ weeks |
| Week 5 | Blog derivative content | Pipeline proven reliable |
| Week 6+ | Original content generation | After A/B testing validates quality |

**Always keeps approval gate:** Pillar blog posts, media pitches, partnership communications, crisis response, financial claims/yield data.

### Phase 4 Activities

**Deferred items now activated:**
- Hermes Agent deployment (content orchestrator with GEPA self-improvement)
- Full lead nurturing system (Workflows 8-13, PostgreSQL, Redis) -- see `automations/x-lead-nurturing-architecture.md`
- 2nd satellite account (DeFi Community Page)
- Autoresearch iterate/evaluate/keep-discard loop for content variant generation
- Ambassador program launch (3-tier, application-based)
- Zealy quest campaign activation
- YouTube first tutorial video
- A/B testing infrastructure

**Lending platform launch coordination:** When mainnet goes live, coordinated launch across VoidAI-owned channels simultaneously. Influencer posts staggered across 24-48 hours with different angles (briefing packet sent after VoidAI's public announcement -- see pre-launch checklist item 1.8). Discord launch event with team AMA. Real-time TVL milestone tweets. Activate on-chain Galxe quests. Press release to all media contacts.

### Weekly Operating Rhythm at Full Speed

| Day | Hours | Active Work | Background (Automated) |
|-----|-------|-------------|----------------------|
| **Mon** | 3-4 | Review auto-generated analytics + competitor digest. Set weekly priorities. NotebookLM research. Update editorial calendar. | Metrics post, bridge alerts, Hermes content, ElizaOS community |
| **Tue** | 4-5 | Write 1-2 pillar posts. Generate visuals. Review + publish. Approve derivative cascade. | Same + Autoresearch overnight variants |
| **Wed** | 3-4 | Run derivative scripts. Generate videos. Queue full week via Outstand. 15-20 X replies. | Same |
| **Thu** | 3-4 | Discord/Telegram engagement. Host AMA/Space. KOL outreach. Ambassador onboarding. | Same |
| **Fri** | 2-3 | Review analytics + A/B results. Update CLAUDE.md voice learnings. Optimize workflows. Prep weekend queue. | Same |
| **Weekend** | 0.5 | 30-min check-in for urgent items only. | Full automated operation |

Detailed daily breakdowns will be created as an operational runbook during Phase 3.

---

## Cost Summary by Phase

| Phase | Monthly Cost | Key Additions |
|-------|-------------|---------------|
| **Phase 1-2** (Build & Test) | ~$46/mo | Claude Max $20 + Google AI Pro $20 + Outstand $6 |
| **Phase 3** (Soft Launch) | ~$261-276/mo | + X API Basic $200 + Higgsfield $15-30 |
| **Phase 4** (Full Deploy) | ~$276-390/mo | + Brand24 $0-99 (optional) + paid ads (variable) |
| **Equivalent headcount** | -- | $25,000-50,000+/month |

---

## Hour Estimates Summary

| Phase | Duration | Total Hours | Hours/Week |
|-------|----------|-------------|------------|
| **1a: Launch Critical** | Days 1-7 | ~25-30 hrs | 30-35 |
| **1b: Post-Launch Build** | Days 8-21 | ~50-60 hrs | 25-30 |
| **2: TEST** | Days 8-14 (overlap) | ~15-20 hrs | (included in 1b) |
| **3: SOFT LAUNCH** | Days 12-14+ | ~20-25 hrs first week | 20-25 |
| **4: FULL DEPLOY** | Day 21+ ongoing | ~16-21 hrs/week | 16-21 |

**Total to Soft Launch (Day 14): ~60-70 hours over 2 weeks.**
**Total to Full Deploy (Day 21): ~90-110 hours over 3 weeks.**

---

*This staged breakdown maps to the full VoidAI Marketing Roadmap (`roadmap/voidai-marketing-roadmap.md`). Brand voice and compliance rules are in `CLAUDE.md` (canonical, auto-loaded). The Build->Test->Soft Launch->Full Deploy methodology ensures nothing goes public until validated. Every system is built with a DRY_RUN flag and approval gate.*
