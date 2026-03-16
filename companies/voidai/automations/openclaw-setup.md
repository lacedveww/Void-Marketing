# OpenClaw Setup Guide for VoidAI Marketing Pipeline

**Replaces**: n8n Cloud (orchestration)
**Cost**: $0/mo (self-hosted, free APIs)
**Last updated**: 2026-03-16

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

### Job 1: Daily Metrics + Tweet (replaces WF1)

```bash
openclaw cron add \
  --name "VoidAI Daily Metrics" \
  --cron "0 10 * * *" \
  --tz "America/New_York" \
  --session isolated \
  --message "Run the VoidAI daily metrics pipeline. Execute these steps in order:
1. Run: bash /Users/vew/Apps/Void-AI/companies/voidai/automations/scripts/collect-metrics.sh
2. Run: bash /Users/vew/Apps/Void-AI/companies/voidai/automations/scripts/generate-daily-tweet.sh /Users/vew/Apps/Void-AI/companies/voidai/automations/data/daily-metrics-\$(date +%Y-%m-%d).json
3. Show me the generated tweet for review.
4. If DRY_RUN is not 'true' in /Users/vew/Apps/Void-AI/.env, run: bash /Users/vew/Apps/Void-AI/companies/voidai/automations/scripts/post-to-x.sh with the tweet text.
5. Report the result." \
  --announce \
  --channel discord \
  --to "channel:YOUR_CHANNEL_ID"
```

### Job 2: Weekly Recap Thread (replaces WF3)

```bash
openclaw cron add \
  --name "VoidAI Weekly Recap" \
  --cron "0 14 * * 5" \
  --tz "America/New_York" \
  --session isolated \
  --message "Run the VoidAI weekly recap pipeline. Execute these steps:
1. Run: bash /Users/vew/Apps/Void-AI/companies/voidai/automations/scripts/collect-metrics.sh
2. Run: bash /Users/vew/Apps/Void-AI/companies/voidai/automations/scripts/generate-weekly-thread.sh /Users/vew/Apps/Void-AI/companies/voidai/automations/data/daily-metrics-\$(date +%Y-%m-%d).json
3. Show me the generated thread for review.
4. If DRY_RUN is not 'true', run: bash /Users/vew/Apps/Void-AI/companies/voidai/automations/scripts/post-to-x.sh --thread with the thread JSON.
5. Report the result." \
  --announce \
  --channel discord \
  --to "channel:YOUR_CHANNEL_ID"
```

### Job 3: Ecosystem News Monitor (replaces WF4)

```bash
openclaw cron add \
  --name "VoidAI News Monitor" \
  --cron "0 */4 * * *" \
  --tz "America/New_York" \
  --session isolated \
  --message "Run the VoidAI ecosystem news pipeline. Execute these steps:
1. Run: bash /Users/vew/Apps/Void-AI/companies/voidai/automations/scripts/collect-news.sh
2. Check the output. If new relevant items were found, for each top item (max 2):
   Run: bash /Users/vew/Apps/Void-AI/companies/voidai/automations/scripts/generate-news-tweet.sh with the item data piped to stdin.
3. Show me any generated tweets.
4. Report how many items found and tweets generated." \
  --announce \
  --channel discord \
  --to "channel:YOUR_CHANNEL_ID"
```

### Job 4: Content Scheduler (replaces WF5)

```bash
openclaw cron add \
  --name "VoidAI Content Scheduler" \
  --cron "0 7 * * *" \
  --tz "America/New_York" \
  --session isolated \
  --message "Check the VoidAI content queue at /Users/vew/Apps/Void-AI/companies/voidai/queue/approved/ for items ready to post today. Read the manifest.json to find approved items. If DRY_RUN is not 'true', post up to 2 items using post-to-x.sh. Respect the MAX_POSTS_PER_DAY=6 limit and MIN_POST_GAP_MINUTES=180. Report what was posted or queued." \
  --announce \
  --channel discord \
  --to "channel:YOUR_CHANNEL_ID"
```

### Job 5: Competitor Monitor (replaces WF6, Phase 3+)

```bash
openclaw cron add \
  --name "VoidAI Competitor Intel" \
  --cron "0 8 * * *" \
  --tz "America/New_York" \
  --session isolated \
  --message "Collect competitor intelligence for VoidAI. Search for recent activity from Bittensor competitors (gTAO Ventures, Project Rubicon, TaoFi, Tensorplex) and mentions of VoidAI/SN106. Summarize findings with: competitor activity count, VoidAI mention count, key themes, and any threats or opportunities. This is internal intel only, never post publicly." \
  --announce \
  --channel discord \
  --to "channel:YOUR_CHANNEL_ID" \
  --model "google/gemini-3-flash-preview"
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
- [ ] All 5 cron jobs created (Phase 2)
- [ ] DRY_RUN test: collect-metrics.sh (verify API data flows)
- [ ] DRY_RUN test: generate-daily-tweet.sh (verify claude -p works)
- [ ] DRY_RUN test: post-to-x.sh (verify OpenTweet posting)
- [ ] DRY_RUN test: each cron job via `openclaw cron run`
- [ ] Verify Discord notifications arrive (both OpenClaw announce and webhook)
- [ ] Set DRY_RUN=false in .env
- [ ] First live tweet posted successfully
- [ ] Renew OpenTweet before 2026-03-22

## 9. Quick Reference

| Schedule | Job | What it does |
|----------|-----|-------------|
| Daily 10AM ET | Daily Metrics | Collect data, generate tweet, post via OpenTweet |
| Fri 2PM ET | Weekly Recap | Collect 7d data, generate thread, post via OpenTweet |
| Every 4h | News Monitor | Scan RSS, generate tweets for relevant items |
| Daily 7AM ET | Content Scheduler | Post approved queue items via OpenTweet |
| Daily 8AM ET | Competitor Intel | Collect competitor data, report to Discord |
