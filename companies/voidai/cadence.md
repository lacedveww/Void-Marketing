# Posting Cadence: VoidAI

## Per-Account Schedule

| Account | Posts/Day | Peak Windows (UTC) | Thread Frequency | Min Gap Between Posts |
|---------|-----------|--------------------|--------------------|----------------------|
| Main (@v0idai) | 1-2 | 14:00-16:00, 20:00-22:00 | 1/week | 3 hours |
| Fanpage Satellite | 1-2 | 13:00-15:00, 21:00-23:00 | Rare | 2 hours |
| Bittensor Ecosystem | 1-2 | 14:00-17:00 | 2/week | 3 hours |
| DeFi / Cross-Chain | 1-2 | 14:00-16:00, 20:00-22:00 | 2/week | 3 hours |
| AI x Crypto | 1 | 15:00-17:00 | 1/week | N/A |
| Meme / Culture | 1-2 | 13:00-15:00, 20:00-22:00 | Rare | 2 hours |

## Daily Pipeline Rhythm

The automated pipeline follows this daily schedule (all times Eastern):

| Time (ET) | Event | Details |
|-----------|-------|---------|
| 8:00 AM | Intelligence Sweep (SILENT) | Data collection from monitored X accounts, news, metrics |
| 9:00 AM (~9:30 delivery) | Morning Summary | Full brief delivered to Discord/Telegram for review |
| 10:30 AM | Draft Review + Content Scheduler | Content generation, approval workflow, scheduling |
| 12:00 PM (not Fri) | System Health Check | API/cron/queue status check, closes active content window |
| 8:00 PM | Intelligence Sweep (SILENT) | Evening data collection |
| 10:00 PM | Engagement Collector (SILENT) | Performance data collection for next-day feedback |
| Fri 12:00 PM | Weekly Recap + Calibration | Replaces health check on Fridays |

**Daily content target:** 3-5 posts across Pillars A (X Intelligence, 2-3 posts) and B (SEO/News, 1-2 posts). See `engine/frameworks/three-pillar-generation.md`.

## Cadence Rules

- **@v0idai minimum floor**: The main account MUST post at least 1 original post every single day, 7 days a week. Consistency is the #1 driver of algorithmic reach. Going silent for even 1-2 days kills momentum. If nothing major to announce, post a builder update, ecosystem observation, or metric highlight. Replies and quote-tweets do NOT count toward this minimum.
- Never post more than 6 times/day from any single account (spam signal to X algorithm)
- Space posts minimum gap as listed above per account
- Peak windows are initial estimates. Update based on `brand/voice-learnings.md` engagement data after 2 weeks
- Minimum viable cadence: at least 4 posts/week per satellite account to maintain algorithmic momentum
- Content calendar rhythm: Morning Summary at 9:30AM ET sets the day's agenda; content approval at 10:30AM ET; System Health Check at 12PM ET closes active window. Plan weekly on Monday, review Friday (aligns with Weekly Recap + Calibration)

## Consistency Accountability

If @v0idai misses its daily post minimum for 2 consecutive days, trigger an immediate content sprint: draft 5 posts for the next 3 days to rebuild momentum. Log the gap in `brand/voice-learnings.md` and note any engagement impact.

## Weekend Rules

- Reduce to 1 post/day max per account (lower engagement, save content for weekdays)

## Reply Cadence (Separate from Posts)

- Replies from @v0idai count toward engagement but are tracked separately from original posts
- Daily reply target: 5-10 quality replies on Tier 1-2 accounts during Phase 1-3, scale to 15-20 in Phase 4
- Reply within 15 minutes of target posts (early replies get 300% more impressions)

## Cross-Platform Cadence (Discord, Telegram)

X is the primary channel, but community presence extends beyond X. See accounts.md "Community Presence Beyond X" for full guidelines.

| Platform | Minimum Activity | Content Type |
|----------|-----------------|-------------|
| Discord | Daily presence during business hours; respond to questions within 4 hours | Announcements (within 30 min of X post), community support, developer Q&A |
| Telegram | 1 update/day during active periods | Quick updates, bridge status, milestone celebrations |

Cross-platform rule: X always gets announcements first. Discord and Telegram follow within 30 minutes. Exception: crisis communication goes to all platforms simultaneously.

---

## Changelog

| Date | Change | Approved by |
|------|--------|-------------|
| 2026-03-13 | Initial cadence config extracted from CLAUDE.md | Vew |
| 2026-03-22 | Added @v0idai daily minimum floor (1 post/day, no exceptions), consistency accountability trigger, and cross-platform presence guidance per X Playbook tips 1, 21 | Vew |
| 2026-03-25 | Added Daily Pipeline Rhythm table (6-job schedule), updated content calendar rhythm to reference Morning Summary/Draft Review/Health Check times, added 3-5 daily target reference to three-pillar framework | Claude Code |
