# OpenClaw Setup Guide for VoidAI Marketing Pipeline

**Replaces**: n8n Cloud (orchestration)
**Cost**: $0/mo (self-hosted, free APIs)
**Last updated**: 2026-03-25

---

## 1. Prerequisites

- OpenClaw installed and Gateway running on your always-on PC
- Discord bot token (from Discord Developer Portal, for OpenClaw two-way chat)
- Telegram bot token (already have: `8612...`)
- Gemini API key (free from aistudio.google.com): `AIzaSy...` (already set)
- Taostats API key (already set)
- GitHub PAT (already set)

## 2. Messaging Architecture

**Dual approach**: OpenClaw channels for two-way chat + existing webhooks for script notifications.

| Channel | OpenClaw (two-way) | Webhook (one-way) | When to use |
|---------|-------------------|-------------------|-------------|
| Discord | Bot in your server | Existing webhook URL | OpenClaw: cron delivery, interactive commands. Webhook: script notifications, quick alerts |
| Telegram | Bot in your channel | Bot API (sendMessage) | OpenClaw: cron delivery, interactive commands. Bot API: script notifications |

**Both are free.** Setting up OpenClaw channels gives you interactive access (type commands in Discord/Telegram to trigger pipelines) while keeping your existing webhooks as a reliable fallback for scripts.

### Why both?
- **OpenClaw channels**: Two-way. You can type "run daily metrics" in Discord and OpenClaw runs the pipeline. Cron jobs deliver results here automatically.
- **Existing webhooks**: One-way (send only). Scripts use these for simple notifications. Already tested and working. Zero setup needed.

## 3. OpenClaw Config

Add to your `~/.openclaw/openclaw.json`:

```json5
{
  // LLM provider: Gemini free tier for data tasks
  agents: {
    defaults: {
      model: { primary: "google/gemini-3-flash-preview" }
    }
  },

  // Discord channel (two-way bot)
  channels: {
    discord: {
      enabled: true,
      // Set token securely:
      // openclaw config set channels.discord.token '"YOUR_DISCORD_BOT_TOKEN"' --json
      groupPolicy: "allowlist",
      guilds: {
        "YOUR_SERVER_ID": {
          requireMention: false,
          users: ["YOUR_USER_ID"]
        }
      }
    },

    // Telegram channel (two-way bot)
    telegram: {
      enabled: true,
      // Uses env: TELEGRAM_BOT_TOKEN
      dmPolicy: "allowlist",
      allowFrom: ["YOUR_TELEGRAM_USER_ID"],
      groups: {
        "-1003443684339": {
          requireMention: false
        }
      }
    }
  },

  // Webhook hooks (for external triggers, Phase 3+)
  hooks: {
    enabled: true,
    token: "${OPENCLAW_HOOKS_TOKEN}",
    path: "/hooks"
  },

  // Cron scheduler
  cron: {
    enabled: true,
    maxConcurrentRuns: 1,
    sessionRetention: "48h",
    runLog: {
      maxBytes: "5mb",
      keepLines: 3000
    }
  }
}
```

**Note**: Your existing Discord webhook (`DISCORD_WEBHOOK_URL` in .env) and Telegram bot token continue to work independently. The scripts use the webhook for notifications. OpenClaw uses the bot token for interactive two-way communication. They don't conflict.

## 4. Cron Job Definitions

Run these commands to create each scheduled job. All times are America/New_York.

The pipeline uses 6 jobs organized around the Three-Pillar Generation Framework (see `engine/frameworks/three-pillar-generation.md`). Two jobs are silent data collectors; four produce messages for review.

### Job 1: Intelligence Sweep (SILENT)

Runs twice daily. Scans monitored X accounts (Tier 1 content accounts from `monitoring/content-accounts.md`, Tier 2 marketing accounts from `monitoring/marketing-accounts.md`) and collects ecosystem news, competitor signals, and engagement opportunities. Produces raw data files consumed by the Morning Summary.

```bash
openclaw cron add \
  --name "VoidAI Intelligence Sweep" \
  --cron "0 8,20 * * *" \
  --tz "America/New_York" \
  --session isolated \
  --message "Run the VoidAI Intelligence Sweep. SILENT data collection - do NOT send any messages to channels.

1. Read the monitoring account lists from:
   - companies/voidai/monitoring/content-accounts.md (Tier 1: Bittensor core, builders/analysts)
   - companies/voidai/monitoring/marketing-accounts.md (Tier 2: marketing/design, AI marketing tools)
2. For each monitored account, collect new posts, threads, and engagement signals since the last sweep.
3. Run: bash companies/voidai/automations/scripts/collect-news.sh
4. Run: bash companies/voidai/automations/scripts/collect-metrics.sh
5. Write consolidated output to companies/voidai/automations/data/sweep-\$(date +%Y-%m-%d)-\$(date +%H%M).json with structure:
   {
     \"collected_at\": \"ISO timestamp\",
     \"sweep_type\": \"morning|evening\",
     \"accounts_checked\": [...],
     \"new_posts\": [...],
     \"engagement_opportunities\": [...],
     \"competitor_mentions\": [...],
     \"trending_topics\": [...],
     \"ecosystem_news\": [...],
     \"metrics_snapshot\": {...}
   }
6. Do NOT announce results. This is silent collection only."
```

### Job 2: Morning Summary

Reads the latest sweep data and overnight news, generates a structured brief for Vew's review. This is the primary decision-making input for the day's content.

```bash
openclaw cron add \
  --name "VoidAI Morning Summary" \
  --cron "0 9 * * *" \
  --tz "America/New_York" \
  --session isolated \
  --message "Generate the VoidAI Morning Summary brief. Execute these steps:
1. Read the latest sweep JSON from companies/voidai/automations/data/ (most recent sweep-*.json)
2. Read the latest performance-summary.json (Pillar C feedback data)
3. Read the latest daily-metrics JSON for current market context
4. Generate a structured brief with these sections:
   A. MARKET SNAPSHOT: TAO price, SN106 emissions, bridge volume (1 line each)
   B. TOP STORIES (max 5): Priority-ranked news/posts from sweep, with suggested content angle and target account
   C. ENGAGEMENT OPPORTUNITIES (max 3): High-signal threads where a VoidAI reply/QT adds value, with draft hook
   D. COMPETITOR ACTIVITY: Any notable moves from gTAO/Tensorplex/TaoFi (or 'Nothing notable')
   E. CONTENT SUGGESTIONS: 3-5 draft post ideas across Pillars A+B with pillar tag, target account, and hook
   F. PERFORMANCE NOTE: Yesterday's engagement highlights from Pillar C (or 'Insufficient data' if pre-launch)
5. Deliver the brief to Discord and Telegram." \
  --announce \
  --channel discord \
  --to "channel:YOUR_CHANNEL_ID"
```

### Job 3: Draft Review + Content Scheduler

Generates content drafts from the morning summary, presents them for approval, and schedules approved posts. This is the daily content production job.

```bash
openclaw cron add \
  --name "VoidAI Draft Review + Scheduler" \
  --cron "30 10 * * *" \
  --tz "America/New_York" \
  --session isolated \
  --message "Run the VoidAI content generation and scheduling pipeline. Execute these steps:
1. Read the Morning Summary brief from today (if not available, generate from latest sweep data)
2. Read performance-summary.json for Pillar C feedback injection
3. Generate 3-5 draft posts across Pillars A and B:
   - Pillar A (X Intelligence): 2-3 posts from sweep data (news, QTs, narrative threads)
   - Pillar B (SEO/News): 1-2 posts from news feeds and research pipeline
   - Each draft includes: text, target account, pillar tag, suggested post time, hook type
4. Run: bash companies/voidai/automations/scripts/generate-daily-tweet.sh with today's metrics
5. Present all drafts for Vew's review with approve/edit/reject options
6. For approved drafts:
   - Move to queue/approved/
   - If DRY_RUN is not 'true', schedule via post-to-x.sh respecting cadence rules (MAX_POSTS_PER_DAY=6, MIN_POST_GAP_MINUTES=180)
7. Log rejected drafts with reason for voice calibration learning
8. Report: drafts generated, approved, rejected, scheduled." \
  --announce \
  --channel discord \
  --to "channel:YOUR_CHANNEL_ID"
```

### Job 4: System Health Check

Midday operational check. Verifies APIs, cron jobs, and queue status. Closes the active content window for the day.

```bash
openclaw cron add \
  --name "VoidAI System Health Check" \
  --cron "0 12 * * 1-4,6-7" \
  --tz "America/New_York" \
  --session isolated \
  --message "Run the VoidAI System Health Check. Execute these steps:
1. Verify API connectivity:
   - Taostats API: curl companies/voidai/automations/scripts/collect-metrics.sh --dry-run
   - OpenTweet API: check key validity
   - Check .env for DRY_RUN status
2. Check cron job status: list all jobs, flag any that failed in last 24h
3. Queue audit:
   - Count items in queue/drafts/, queue/approved/, queue/scheduled/
   - Flag any approved items older than 48h (stale content)
4. Today's posting status:
   - Posts published today (count + accounts)
   - Posts remaining in schedule
   - Any cadence rule violations
5. Report summary with: API status (green/red), cron status, queue counts, posting status.
6. If any API is down or cron job failed, flag as URGENT." \
  --announce \
  --channel discord \
  --to "channel:YOUR_CHANNEL_ID"
```

### Job 5: Engagement Collector (SILENT)

Nightly collection of engagement data for all posts from the day. This is the Pillar C data collection job. Feeds into content generation the next morning.

```bash
openclaw cron add \
  --name "VoidAI Engagement Collector" \
  --cron "0 22 * * *" \
  --tz "America/New_York" \
  --session isolated \
  --message "Run the VoidAI engagement analytics collection. SILENT data collection - do NOT send any messages to channels.

1. Run: bash companies/voidai/automations/scripts/collect-engagement.sh --days 7
2. Update performance-summary.json and top-performers.json in companies/voidai/automations/data/
3. If any post achieved >3x average engagement rate, tag it as a breakout performer in top-performers.json
4. If average engagement dropped >30% vs previous collection, write a flag file (calibration-alert.txt) for the next Morning Summary to pick up
5. Do NOT announce results. This is silent collection only. The data will be automatically loaded by content generation scripts tomorrow."
```

### Job 6: Weekly Recap + Voice Calibration

Runs every Friday at noon. Generates the weekly recap thread, runs voice calibration analysis, and proposes adjustments. This closes the full feedback loop: post -> measure -> learn -> adjust -> post better.

```bash
openclaw cron add \
  --name "VoidAI Weekly Recap + Calibration" \
  --cron "0 12 * * 5" \
  --tz "America/New_York" \
  --session isolated \
  --message "Run the VoidAI Weekly Recap and Voice Calibration. Execute these steps:

PART 1 - WEEKLY RECAP THREAD:
1. Run: bash companies/voidai/automations/scripts/collect-metrics.sh
2. Run: bash companies/voidai/automations/scripts/generate-weekly-thread.sh with this week's metrics
3. Present the recap thread for Vew's review
4. If approved and DRY_RUN is not 'true', post via post-to-x.sh --thread

PART 2 - VOICE CALIBRATION:
5. Read the latest performance-summary.json and top-performers.json
6. Read the current voice-learnings.md from companies/voidai/brand/
7. Analyze the week's data and generate a Weekly Summary entry:
   - Per-account engagement averages vs baselines
   - Best and worst performers with reasons
   - Pattern observations (content type, time of day, hook style)
   - Voice drift check
   - Specific adjustments for next week
8. Append the summary to voice-learnings.md
9. Check voice calibration triggers (from engine/frameworks/voice-calibration-loop.md):
   - Any register outperforming >50% for 4+ weeks?
   - Any register underperforming >50% for 4+ weeks?
   - Engagement dropped >30% over 2 weeks?
   - Community language shifted >20%?
10. If any trigger is met, propose specific weight changes and flag for Vew's approval.
11. Report the recap thread status and calibration results." \
  --announce \
  --channel discord \
  --to "channel:YOUR_CHANNEL_ID"
```

## 5. Emergency Stop

To halt all cron jobs immediately:

```bash
# Disable all jobs
openclaw cron list | grep -o '"jobId":"[^"]*"' | while read -r line; do
  id=$(echo "$line" | cut -d'"' -f4)
  openclaw cron edit "$id" --disable
done

# Or disable cron entirely
openclaw config set cron.enabled false --json
openclaw gateway restart
```

To resume:

```bash
openclaw config set cron.enabled true --json
openclaw gateway restart
# Re-enable individual jobs as needed
```

## 6. Testing Each Job

Test any job manually without waiting for the schedule:

```bash
# List all jobs
openclaw cron list

# Run a specific job immediately
openclaw cron run <jobId>

# Check run history
openclaw cron runs --id <jobId> --limit 5
```

Test with DRY_RUN first (already set to true in .env).

## 7. Environment Variables

These are already set in `/Users/vew/Apps/Void-AI/.env`. Also export them in your shell profile so OpenClaw cron jobs can access them:

```bash
export GEMINI_API_KEY="<from .env>"
export TAOSTATS_API_KEY="<from .env>"
export GITHUB_TOKEN="<from .env>"
export OPENTWEET_API_KEY="<from .env>"
export TELEGRAM_BOT_TOKEN="<from .env>"
export DISCORD_WEBHOOK_URL="<from .env>"
```

**Note**: All values are in `/Users/vew/Apps/Void-AI/.env`. Copy them from there.

## 8. Migration Checklist

- [ ] OpenClaw Gateway running on always-on PC
- [ ] Discord bot created and paired in OpenClaw
- [ ] Telegram bot paired in OpenClaw
- [ ] Gemini API key set in env
- [ ] Taostats API key set in env
- [ ] GitHub PAT set in env
- [ ] OpenTweet API key set in env
- [ ] All 6 cron jobs created (Intelligence Sweep, Morning Summary, Draft Review, Health Check, Engagement Collector, Weekly Recap)
- [ ] Monitoring files in place: `monitoring/content-accounts.md` (Tier 1) and `monitoring/marketing-accounts.md` (Tier 2)
- [ ] DRY_RUN test: collect-metrics.sh (verify API data flows)
- [ ] DRY_RUN test: collect-engagement.sh (verify engagement collection)
- [ ] DRY_RUN test: generate-daily-tweet.sh (verify claude -p works + feedback injection)
- [ ] DRY_RUN test: post-to-x.sh (verify OpenTweet posting)
- [ ] DRY_RUN test: Intelligence Sweep via `openclaw cron run` (verify sweep JSON output)
- [ ] DRY_RUN test: Morning Summary via `openclaw cron run` (verify brief delivery)
- [ ] DRY_RUN test: Draft Review + Scheduler via `openclaw cron run` (verify approval flow)
- [ ] Verify Discord notifications arrive (both OpenClaw announce and webhook)
- [ ] Set DRY_RUN=false in .env
- [ ] First live tweet posted successfully
- [ ] OpenTweet subscription active (renewed 2026-03-22, next renewal April 22, 2026)

## 9. Quick Reference

| Schedule | Job | What it does | Messages? |
|----------|-----|-------------|-----------|
| 8AM + 8PM ET | Intelligence Sweep | SILENT data collection from monitored X accounts, news, metrics | No |
| 9AM ET (~9:30AM) | Morning Summary | Full summary brief: market snapshot, top stories, engagement ops, content suggestions | Yes |
| 10:30AM ET | Draft Review + Scheduler | Content generation, approval workflow, scheduling approved posts | Yes |
| 12PM ET (not Fri) | System Health Check | API connectivity, cron status, queue audit, posting status | Yes |
| 10PM ET | Engagement Collector | SILENT performance data collection, updates performance-summary.json | No |
| Fri 12PM ET | Weekly Recap + Calibration | Recap thread + voice calibration analysis + weight adjustment proposals | Yes |
