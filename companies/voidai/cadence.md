# Posting Cadence: VoidAI

## Per-Account Schedule

| Account | Posts/Day | Peak Windows (UTC) | Thread Frequency | Min Gap Between Posts |
|---------|-----------|--------------------|--------------------|----------------------|
| Main (@v0idai) | 1-2 | 14:00-16:00, 20:00-22:00 | 1/week | 3 hours |
| Daily/Informational | 3-5 | 13:00-17:00, 20:00-23:00 | Rare | 2 hours |
| Bittensor Ecosystem | ~3 | 14:00-17:00 | 2/week | 2 hours |

## Daily Pipeline Rhythm

The automated pipeline follows this daily schedule (all times Eastern). The morning window uses a reply-gated sequential chain where each step waits for Vew's response before proceeding.

```
8:00 AM  -- Intelligence Sweep (SILENT, automatic)
8:30 AM  -- Morning Summary delivered (automatic, 5-6 messages)
           PAUSED -- waits for Vew's response
[on response] -- Draft Review -> Scheduling -> Content Schedule -> Health Check
10:00 AM -- Health Check (automatic fallback if chain not complete)
10:30 AM -- FRIDAYS: Weekly Recap + Voice Calibration
-------- ACTIVE WINDOW ENDS --------
8:00 PM  -- Intelligence Sweep (SILENT)
10:00 PM -- Engagement Collector (SILENT)
```

**Daily content target:** 7-10 posts total across 3 accounts (@v0idai 1-2/day + Daily/Info 3-5/day + Bittensor ~3/day). See `engine/frameworks/three-pillar-generation.md`.

## Cadence Rules

- **@v0idai minimum floor**: The main account MUST post at least 1 original post every single day, 7 days a week. Consistency is the #1 driver of algorithmic reach. Going silent for even 1-2 days kills momentum. If nothing major to announce, post a builder update, ecosystem observation, or metric highlight. Replies and quote-tweets do NOT count toward this minimum.
- Never post more than 6 times/day from any single account (spam signal to X algorithm)
- Space posts minimum gap as listed above per account
- Peak windows are initial estimates. Update based on `brand/voice-learnings.md` engagement data after 2 weeks
- Minimum viable cadence: at least 4 posts/week per satellite account to maintain algorithmic momentum
- Content calendar rhythm: Morning Summary at 8:30AM ET sets the day's agenda; reply-gated chain handles draft review, scheduling, and health check on Vew's responses; Health Check fallback at 10AM ET. Plan weekly on Monday, review Friday (aligns with Weekly Recap + Calibration at 10:30AM)

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
| 2026-03-25 | Compacted to 5-job reply-gated schedule: Morning Summary at 8:30AM starts sequential chain, Health Check at 10AM as fallback, Weekly Recap at Fri 10:30AM. Updated pipeline rhythm and calendar rhythm references. | Claude Code |
| 2026-03-25 | Lending pivot: updated to 3 accounts. Removed Fanpage/AI-Crypto/Meme entries. Added Daily/Info at 3-5/day, updated Bittensor to ~3/day. | Vew |
