# n8n Workflow Specifications: VoidAI Marketing Automation

**Status:** CURRENT
**Last Updated:** 2026-03-15
**Canonical for:** n8n workflow design, node specifications, environment variables, testing procedures
**Dependencies:** `CLAUDE.md` (brand/compliance), `roadmap/staged-implementation-breakdown.md` (phasing), `metrics.md` (data sources), `cadence.md` (timing), `accounts.md` (account personas)
**Constraint:** n8n FREE tier = max 5 active workflows. Workflows 1-5 are the active five. Workflows 6-7 are Phase 3+ designs, ready to swap in.

---

## Table of Contents

1. [Environment Variables (Shared)](#environment-variables-shared)
2. [Workflow 1: Daily Metrics Post](#workflow-1-daily-metrics-post)
3. [Workflow 2: Bridge Transaction Alerts](#workflow-2-bridge-transaction-alerts)
4. [Workflow 3: Weekly Recap Thread](#workflow-3-weekly-recap-thread)
5. [Workflow 4: Ecosystem News Monitor](#workflow-4-ecosystem-news-monitor)
6. [Workflow 5: Content Calendar Scheduler](#workflow-5-content-calendar-scheduler)
7. [Workflow 6: Competitor Monitor (Phase 3+)](#workflow-6-competitor-monitor-phase-3)
8. [Workflow 7: Blog Distribution Pipeline (Phase 3+)](#workflow-7-blog-distribution-pipeline-phase-3)
9. [API Reference Notes](#api-reference-notes)
10. [Testing Playbook](#testing-playbook)

---

## Environment Variables (Shared)

All workflows share a single set of environment variables configured in n8n Settings > Variables (or `.env` for self-hosted).

| Variable | Example Value | Description |
|----------|--------------|-------------|
| `DRY_RUN` | `true` | Master kill switch. When `true`, no external posts are made. All output goes to log file / webhook. |
| `TAOSTATS_API_BASE` | `https://api.taostats.io/api` | Taostats API base URL |
| `TAOSTATS_API_KEY` | `ts_xxxx` | Taostats API key (free tier) |
| `COINGECKO_API_BASE` | `https://api.coingecko.com/api/v3` | CoinGecko API base URL |
| `COINGECKO_API_KEY` | `(empty for free tier)` | CoinGecko API key (optional, free tier has no key) |
| `X_API_BEARER_TOKEN` | `AAAA...` | X/Twitter API v2 Bearer Token (Basic plan, $200/mo) |
| `X_API_KEY` | `xxxx` | X API consumer key |
| `X_API_SECRET` | `xxxx` | X API consumer secret |
| `X_ACCESS_TOKEN` | `xxxx` | X OAuth 1.0a access token for @v0idai |
| `X_ACCESS_SECRET` | `xxxx` | X OAuth 1.0a access token secret |
| `OPENTWEET_API_KEY` | `ot_xxxx` | OpenTweet API key (7-day trial, then X API) |
| `OUTSTAND_API_KEY` | `os_xxxx` | Outstand API key for multi-platform publishing |
| `OUTSTAND_API_BASE` | `https://api.outstand.com/v1` | Outstand API base URL |
| `CLAUDE_API_KEY` | `sk-ant-xxxx` | Anthropic Claude API key for content generation |
| `DISCORD_WEBHOOK_URL` | `https://discord.com/api/webhooks/...` | Discord webhook for notifications to Vew |
| `DISCORD_ANNOUNCE_WEBHOOK` | `https://discord.com/api/webhooks/...` | Discord webhook for #announcements channel |
| `GITHUB_TOKEN` | `ghp_xxxx` | GitHub PAT for commit count (weekly recap) |
| `GITHUB_ORG` | `voidai` | GitHub org name |
| `BRIDGE_MONITOR_URL` | `http://localhost:8000/api/bridge/recent` | Consolidated Tracker/FastAPI bridge endpoint |
| `BRIDGE_TX_THRESHOLD` | `100` | Minimum TAO amount to trigger bridge alert |
| `LOG_FILE_PATH` | `/data/n8n/dry-run-logs/` | Directory for DRY_RUN output logs |
| `QUEUE_DRAFTS_PATH` | `/data/voidai/queue/drafts/` | Path for content queue drafts |
| `QUEUE_APPROVED_PATH` | `/data/voidai/queue/approved/` | Path for approved content |
| `QUEUE_SCHEDULED_PATH` | `/data/voidai/queue/scheduled/` | Path for scheduled content |
| `POSTING_API` | `opentweet` | Which posting API to use: `opentweet`, `x_api`, or `outstand` |
| `MAX_POSTS_PER_DAY` | `6` | Per cadence.md: never more than 6 posts/day from any account |
| `MIN_POST_GAP_MINUTES` | `180` | Per cadence.md: 3-hour minimum gap for @v0idai |

### Variable Groups by Phase

| Phase | Variables to Activate |
|-------|-----------------------|
| Phase 1-2 (Build/Test) | `DRY_RUN=true`, `POSTING_API=opentweet` |
| Phase 3 (Soft Launch) | `DRY_RUN=false`, `POSTING_API=opentweet` (7-day trial) |
| Phase 3+ (Production) | `DRY_RUN=false`, `POSTING_API=x_api` or `outstand` |

---

## Workflow 1: Daily Metrics Post

**Priority:** CRITICAL (Slot 1 of 5)
**File:** `workflows/workflow-1-daily-metrics.json`

### Description

Fetches SN106 subnet metrics from Taostats and TAO market data from CoinGecko every morning, merges them, formats a daily metrics tweet, and posts it from @v0idai. This is the foundational "always-on" content that establishes posting cadence and data credibility.

### Trigger

- **Type:** Cron
- **Schedule:** `0 9 * * *` (9:00 AM ET daily, adjust for server timezone)
- **Note:** 9:00 AM ET falls within the 14:00-16:00 UTC peak window per cadence.md (9 AM ET = 14:00 UTC in summer / 14:00 UTC in winter)

### Node-by-Node Specification

```
[Cron Trigger] -> [Taostats API] -> [CoinGecko API] -> [Merge Data] -> [Format Tweet] -> [DRY_RUN Check] -> [Post or Log]
```

#### Node 1: Cron Trigger
- **Type:** Schedule Trigger
- **Config:**
  - Rule: `0 9 * * *` (daily at 9:00 AM ET)
  - Timezone: `America/New_York`

#### Node 2: Taostats API -- Subnet 106 Data
- **Type:** HTTP Request
- **Config:**
  - Method: `GET`
  - URL: `{{ $env.TAOSTATS_API_BASE }}/subnet/latest?netuid=106`
  - Headers: `Authorization: {{ $env.TAOSTATS_API_KEY }}`
  - Authentication: Header Auth
  - Response Format: JSON
  - Timeout: 30 seconds
  - Continue On Fail: `true` (workflow must not die if API is down)
- **Expected Response Fields:**
  - `emission` (daily emissions)
  - `registration_cost` (registration cost in TAO)
  - `tempo` (block tempo)
  - Additional fields: check Taostats `/subnet/latest` endpoint

#### Node 3: Taostats API -- Subnet 106 Pool/Price
- **Type:** HTTP Request
- **Config:**
  - Method: `GET`
  - URL: `{{ $env.TAOSTATS_API_BASE }}/dtao/pool/latest?netuid=106`
  - Headers: `Authorization: {{ $env.TAOSTATS_API_KEY }}`
  - Response Format: JSON
  - Timeout: 30 seconds
  - Continue On Fail: `true`
- **Expected Response Fields:**
  - `tao_reserve` (TAO in pool)
  - `alpha_reserve` (alpha tokens in pool)
  - `price` (alpha price in TAO)
  - `market_cap`

#### Node 4: CoinGecko API -- TAO Price
- **Type:** HTTP Request
- **Config:**
  - Method: `GET`
  - URL: `{{ $env.COINGECKO_API_BASE }}/simple/price?ids=bittensor&vs_currencies=usd&include_24hr_change=true&include_market_cap=true&include_24hr_vol=true`
  - Headers: (none required for free tier, or `x-cg-demo-api-key: {{ $env.COINGECKO_API_KEY }}` if using demo key)
  - Response Format: JSON
  - Timeout: 30 seconds
  - Continue On Fail: `true`
- **Expected Response:**
  ```json
  {
    "bittensor": {
      "usd": 221.74,
      "usd_24h_change": -2.5,
      "usd_market_cap": 2390000000,
      "usd_24h_vol": 231300000
    }
  }
  ```

#### Node 5: CoinGecko API -- SN106 Alpha Token Price
- **Type:** HTTP Request
- **Config:**
  - Method: `GET`
  - URL: `{{ $env.COINGECKO_API_BASE }}/simple/price?ids=liquidity-provisioning&vs_currencies=usd&include_24hr_change=true&include_market_cap=true`
  - Response Format: JSON
  - Timeout: 30 seconds
  - Continue On Fail: `true`
- **Expected Response:**
  ```json
  {
    "liquidity-provisioning": {
      "usd": 1.01,
      "usd_24h_change": -4.6,
      "usd_market_cap": 3020240
    }
  }
  ```

#### Node 6: Merge Data
- **Type:** Code (JavaScript)
- **Config:**
  ```javascript
  // Merge all API responses into a single data object
  const taostatsSubnet = $input.first().json;
  const taostatsPool = $('Taostats Pool').first().json;
  const taoPrice = $('CoinGecko TAO').first().json;
  const alphaPrice = $('CoinGecko SN106').first().json;

  // Handle API failures gracefully
  const data = {
    tao_price: taoPrice?.bittensor?.usd ?? 'N/A',
    tao_24h_change: taoPrice?.bittensor?.usd_24h_change ?? 'N/A',
    tao_market_cap: taoPrice?.bittensor?.usd_market_cap ?? 'N/A',
    tao_volume_24h: taoPrice?.bittensor?.usd_24h_vol ?? 'N/A',
    alpha_price_usd: alphaPrice?.['liquidity-provisioning']?.usd ?? 'N/A',
    alpha_24h_change: alphaPrice?.['liquidity-provisioning']?.usd_24h_change ?? 'N/A',
    alpha_market_cap: alphaPrice?.['liquidity-provisioning']?.usd_market_cap ?? 'N/A',
    sn106_emission: taostatsSubnet?.emission ?? 'N/A',
    sn106_tao_reserve: taostatsPool?.tao_reserve ?? 'N/A',
    sn106_alpha_reserve: taostatsPool?.alpha_reserve ?? 'N/A',
    sn106_alpha_price_tao: taostatsPool?.price ?? 'N/A',
    timestamp: new Date().toISOString(),
    date_display: new Date().toLocaleDateString('en-US', {
      weekday: 'long',
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      timeZone: 'America/New_York'
    }),
    api_failures: []
  };

  // Track which APIs failed
  if (data.tao_price === 'N/A') data.api_failures.push('CoinGecko TAO');
  if (data.alpha_price_usd === 'N/A') data.api_failures.push('CoinGecko SN106');
  if (data.sn106_emission === 'N/A') data.api_failures.push('Taostats Subnet');
  if (data.sn106_tao_reserve === 'N/A') data.api_failures.push('Taostats Pool');

  return [{ json: data }];
  ```

#### Node 7: Check API Failures
- **Type:** IF
- **Config:**
  - Condition: `{{ $json.api_failures.length }}` > 2
  - True path: Send error notification (too many APIs down, skip post)
  - False path: Continue to format tweet

#### Node 8: Error Notification (True path from Node 7)
- **Type:** HTTP Request (Discord Webhook)
- **Config:**
  - Method: `POST`
  - URL: `{{ $env.DISCORD_WEBHOOK_URL }}`
  - Body (JSON):
    ```json
    {
      "content": "**Daily Metrics Workflow Failed**\nAPIs down: {{ $json.api_failures.join(', ') }}\nTimestamp: {{ $json.timestamp }}\nManual post required today."
    }
    ```

#### Node 9: Format Tweet
- **Type:** Code (JavaScript)
- **Config:**
  ```javascript
  const d = $input.first().json;

  // Format numbers
  const fmtPrice = (n) => typeof n === 'number' ? `$${n.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}` : 'N/A';
  const fmtPct = (n) => typeof n === 'number' ? `${n >= 0 ? '+' : ''}${n.toFixed(1)}%` : 'N/A';
  const fmtMcap = (n) => {
    if (typeof n !== 'number') return 'N/A';
    if (n >= 1e9) return `$${(n / 1e9).toFixed(2)}B`;
    if (n >= 1e6) return `$${(n / 1e6).toFixed(1)}M`;
    return `$${n.toLocaleString()}`;
  };
  const fmtVol = fmtMcap;

  // Build tweet text
  // Design hint: numbers should be rendered in Space Grotesk for manual image creation
  const tweet = [
    `SN106 Daily | ${d.date_display}`,
    ``,
    `$TAO: ${fmtPrice(d.tao_price)} (${fmtPct(d.tao_24h_change)})`,
    `Market Cap: ${fmtMcap(d.tao_market_cap)}`,
    `24h Volume: ${fmtVol(d.tao_volume_24h)}`,
    ``,
    `SN106 Alpha: ${fmtPrice(d.alpha_price_usd)} (${fmtPct(d.alpha_24h_change)})`,
    `Alpha MCap: ${fmtMcap(d.alpha_market_cap)}`,
  ];

  // Add pool data if available
  if (d.sn106_tao_reserve !== 'N/A') {
    tweet.push(`Pool: ${Number(d.sn106_tao_reserve).toLocaleString()} TAO / ${Number(d.sn106_alpha_reserve).toLocaleString()} Alpha`);
  }

  tweet.push('');
  tweet.push('Data: Taostats + CoinGecko');
  tweet.push('#Bittensor $TAO #SN106 #VoidAI');

  const tweetText = tweet.join('\n');

  // Validate tweet length (280 char limit)
  if (tweetText.length > 280) {
    // Fallback: shorter version
    const short = [
      `SN106 Daily`,
      `$TAO: ${fmtPrice(d.tao_price)} (${fmtPct(d.tao_24h_change)})`,
      `SN106: ${fmtPrice(d.alpha_price_usd)} (${fmtPct(d.alpha_24h_change)})`,
      `MCap: ${fmtMcap(d.tao_market_cap)}`,
      ``,
      `#Bittensor $TAO #SN106`
    ].join('\n');
    return [{ json: { tweet: short, full_data: d, truncated: true } }];
  }

  return [{ json: { tweet: tweetText, full_data: d, truncated: false } }];
  ```

#### Node 10: DRY_RUN Check
- **Type:** IF
- **Config:**
  - Condition: `{{ $env.DRY_RUN }}` equals `true`
  - True path: Log to file
  - False path: Post via API

#### Node 11: DRY_RUN Log (True path)
- **Type:** Code (JavaScript)
- **Config:**
  ```javascript
  // Write to dry-run log
  const fs = require('fs');
  const logDir = $env.LOG_FILE_PATH || '/data/n8n/dry-run-logs/';
  const date = new Date().toISOString().split('T')[0];
  const logFile = `${logDir}workflow-1-daily-metrics-${date}.json`;

  const logEntry = {
    workflow: 'daily-metrics',
    timestamp: new Date().toISOString(),
    dry_run: true,
    tweet_text: $input.first().json.tweet,
    tweet_length: $input.first().json.tweet.length,
    full_data: $input.first().json.full_data,
    truncated: $input.first().json.truncated,
    would_post_to: '@v0idai'
  };

  fs.mkdirSync(logDir, { recursive: true });
  fs.writeFileSync(logFile, JSON.stringify(logEntry, null, 2));

  return [{ json: { status: 'logged', file: logFile, ...logEntry } }];
  ```

#### Node 12: Post via API (False path)
- **Type:** Switch
- **Config:** Route based on `{{ $env.POSTING_API }}`
  - Case `opentweet`: OpenTweet HTTP Request
  - Case `x_api`: X API v2 HTTP Request
  - Case `outstand`: Outstand API HTTP Request

#### Node 12a: Post via OpenTweet
- **Type:** HTTP Request
- **Config:**
  - Method: `POST`
  - URL: `https://api.opentweet.com/v1/tweets`
  - Headers: `Authorization: Bearer {{ $env.OPENTWEET_API_KEY }}`
  - Body (JSON):
    ```json
    {
      "text": "{{ $json.tweet }}"
    }
    ```
  - Continue On Fail: `true`

#### Node 12b: Post via X API v2
- **Type:** HTTP Request
- **Config:**
  - Method: `POST`
  - URL: `https://api.twitter.com/2/tweets`
  - Authentication: OAuth 1.0 (using X_API_KEY, X_API_SECRET, X_ACCESS_TOKEN, X_ACCESS_SECRET)
  - Body (JSON):
    ```json
    {
      "text": "{{ $json.tweet }}"
    }
    ```
  - Continue On Fail: `true`

#### Node 12c: Post via Outstand
- **Type:** HTTP Request
- **Config:**
  - Method: `POST`
  - URL: `{{ $env.OUTSTAND_API_BASE }}/publish`
  - Headers: `Authorization: Bearer {{ $env.OUTSTAND_API_KEY }}`
  - Body (JSON):
    ```json
    {
      "platforms": ["twitter"],
      "account": "@v0idai",
      "content": {
        "text": "{{ $json.tweet }}"
      }
    }
    ```
  - Note: Outstand API not yet available. This is a placeholder based on expected API shape. Update when API docs are published.

#### Node 13: Post Success/Failure Check
- **Type:** IF
- **Config:**
  - Condition: HTTP status code equals 200 or 201
  - True: Log success
  - False: Send failure notification to Discord

#### Node 14: Success Notification
- **Type:** HTTP Request (Discord Webhook)
- **Config:**
  - Method: `POST`
  - URL: `{{ $env.DISCORD_WEBHOOK_URL }}`
  - Body:
    ```json
    {
      "content": "Daily metrics posted successfully.\nTweet length: {{ $json.tweet.length }} chars\nTAO: {{ $json.full_data.tao_price }}"
    }
    ```

#### Node 15: Failure Notification
- **Type:** HTTP Request (Discord Webhook)
- **Config:**
  - Method: `POST`
  - URL: `{{ $env.DISCORD_WEBHOOK_URL }}`
  - Body:
    ```json
    {
      "content": "**ALERT: Daily Metrics Post FAILED**\nAPI: {{ $env.POSTING_API }}\nError: {{ $json.error || 'Unknown' }}\nManual post required.\n\nDraft tweet:\n```{{ $json.tweet }}```"
    }
    ```

### Error Handling

| Failure Point | Behavior |
|---------------|----------|
| Taostats API down | Fields show "N/A". If >2 APIs fail, skip post entirely, notify via Discord. |
| CoinGecko API down | Same as above. |
| Both price APIs down | Skip post, notify Discord. Manual post required. |
| Posting API down | Notify Discord with draft tweet text for manual posting. |
| Tweet exceeds 280 chars | Auto-truncate to shorter format. |
| n8n execution error | n8n built-in error workflow sends Discord notification. |

### DRY_RUN Behavior

When `DRY_RUN=true`:
1. All API calls to Taostats and CoinGecko still execute (read-only, no side effects).
2. The formatted tweet is written to `LOG_FILE_PATH/workflow-1-daily-metrics-YYYY-MM-DD.json`.
3. No post is made to any platform.
4. Log file contains: full tweet text, character count, all raw API data, timestamp.
5. Review the log file to validate data accuracy and tweet formatting before going live.

### Testing Instructions

1. Set `DRY_RUN=true` in n8n variables.
2. Open Workflow 1 in n8n editor.
3. Click "Execute Workflow" (manual trigger).
4. Inspect each node's output:
   - Node 2-5: Verify API responses contain expected fields.
   - Node 6: Verify merge produces complete data object.
   - Node 9: Verify tweet text is within 280 chars and reads well.
   - Node 11: Verify log file was written.
5. Check the log file at `LOG_FILE_PATH/workflow-1-daily-metrics-YYYY-MM-DD.json`.
6. Run 3 consecutive days and review output for consistency.
7. When satisfied, set `DRY_RUN=false` and execute once manually to verify posting works.

---

## Workflow 2: Bridge Transaction Alerts

**Priority:** CRITICAL (Slot 2 of 5)
**File:** `workflows/workflow-2-bridge-alerts.json`

### Description

Monitors for new bridge transactions and posts alerts for significant transfers (above a TAO threshold). Creates real-time social proof of bridge usage and highlights VoidAI's non-custodial, Chainlink CCIP-secured infrastructure.

### Trigger Options

**Option A (Preferred): Webhook from bridge monitoring service**
- The consolidated Tracker/FastAPI service pushes transaction events to n8n when a bridge tx exceeds the threshold.
- Requires: Tracker service configured to POST to n8n webhook URL.

**Option B (Fallback): Cron poll every 15 minutes**
- n8n polls the Tracker API for recent transactions.
- Less real-time but works without Tracker push capability.

This spec implements both options as separate trigger nodes. Enable one, disable the other.

### Node-by-Node Specification

```
[Webhook OR Cron] -> [Fetch Recent Txs (if cron)] -> [Filter Threshold] -> [Deduplicate] -> [Format Tweet] -> [DRY_RUN Check] -> [Post or Log]
```

#### Node 1a: Webhook Trigger (Option A)
- **Type:** Webhook
- **Config:**
  - HTTP Method: `POST`
  - Path: `/bridge-tx-alert`
  - Authentication: Header Auth (shared secret)
  - Response Mode: Immediately
- **Expected Payload:**
  ```json
  {
    "tx_hash": "0xabc...",
    "amount_tao": 250.5,
    "source_chain": "Bittensor",
    "dest_chain": "Solana",
    "timestamp": "2026-03-15T14:30:00Z",
    "explorer_url": "https://explorer.example.com/tx/0xabc..."
  }
  ```

#### Node 1b: Cron Trigger (Option B)
- **Type:** Schedule Trigger
- **Config:**
  - Rule: `*/15 * * * *` (every 15 minutes)
  - Timezone: `UTC`

#### Node 2: Fetch Recent Transactions (only for Cron path)
- **Type:** HTTP Request
- **Config:**
  - Method: `GET`
  - URL: `{{ $env.BRIDGE_MONITOR_URL }}?since=15m`
  - Headers: (internal service, auth as needed)
  - Response Format: JSON
  - Timeout: 15 seconds
  - Continue On Fail: `true`
- **Expected Response:**
  ```json
  {
    "transactions": [
      {
        "tx_hash": "0xabc...",
        "amount_tao": 250.5,
        "source_chain": "Bittensor",
        "dest_chain": "Solana",
        "timestamp": "2026-03-15T14:30:00Z",
        "explorer_url": "https://explorer.example.com/tx/0xabc..."
      }
    ]
  }
  ```
- **Note:** If using webhook trigger, this node is bypassed.

#### Node 3: Split Items (Cron path only)
- **Type:** Split In Batches / Item Lists
- **Config:** Split `transactions` array into individual items for processing.

#### Node 4: Filter by Threshold
- **Type:** IF
- **Config:**
  - Condition: `{{ $json.amount_tao }}` >= `{{ $env.BRIDGE_TX_THRESHOLD }}`
  - True path: Continue
  - False path: Stop (sub-threshold, do not alert)

#### Node 5: Deduplicate
- **Type:** Code (JavaScript)
- **Config:**
  ```javascript
  // Prevent duplicate alerts for the same transaction
  const fs = require('fs');
  const stateFile = ($env.LOG_FILE_PATH || '/data/n8n/dry-run-logs/') + 'bridge-alert-state.json';

  let state = {};
  try {
    state = JSON.parse(fs.readFileSync(stateFile, 'utf8'));
  } catch (e) {
    state = { posted_hashes: [] };
  }

  const txHash = $input.first().json.tx_hash;

  if (state.posted_hashes.includes(txHash)) {
    // Already posted, skip
    return [];
  }

  // Add to state (keep last 500 hashes)
  state.posted_hashes.push(txHash);
  if (state.posted_hashes.length > 500) {
    state.posted_hashes = state.posted_hashes.slice(-500);
  }
  fs.writeFileSync(stateFile, JSON.stringify(state, null, 2));

  return $input.all();
  ```

#### Node 6: Format Tweet
- **Type:** Code (JavaScript)
- **Config:**
  ```javascript
  const tx = $input.first().json;

  const amount = Number(tx.amount_tao).toLocaleString('en-US', {
    minimumFractionDigits: 0,
    maximumFractionDigits: 1
  });

  // Map chain names to display format
  const chainDisplay = {
    'Bittensor': 'Bittensor',
    'Solana': 'Solana',
    'Ethereum': 'Ethereum',
    'Base': 'Base'
  };

  const source = chainDisplay[tx.source_chain] || tx.source_chain;
  const dest = chainDisplay[tx.dest_chain] || tx.dest_chain;

  // Build tweet
  const tweet = `${amount} $TAO bridged from ${source} to ${dest}.

Non-custodial. Secured by @chainlink CCIP.

#Bittensor #VoidAI #CrossChain`;

  // Add explorer link if available and fits
  let tweetWithLink = tweet;
  if (tx.explorer_url && (tweet.length + tx.explorer_url.length + 2) <= 280) {
    tweetWithLink = `${amount} $TAO bridged from ${source} to ${dest}.

Non-custodial. Secured by @chainlink CCIP.

${tx.explorer_url}

#Bittensor #VoidAI #CrossChain`;
  }

  const finalTweet = tweetWithLink.length <= 280 ? tweetWithLink : tweet;

  return [{
    json: {
      tweet: finalTweet,
      tx_hash: tx.tx_hash,
      amount_tao: tx.amount_tao,
      source_chain: tx.source_chain,
      dest_chain: tx.dest_chain,
      timestamp: tx.timestamp
    }
  }];
  ```

#### Node 7: DRY_RUN Check
- **Type:** IF
- **Config:** Same pattern as Workflow 1, Node 10.

#### Node 8: DRY_RUN Log
- **Type:** Code (JavaScript)
- **Config:**
  ```javascript
  const fs = require('fs');
  const logDir = $env.LOG_FILE_PATH || '/data/n8n/dry-run-logs/';
  const date = new Date().toISOString().replace(/[:.]/g, '-');
  const logFile = `${logDir}workflow-2-bridge-alert-${date}.json`;

  const logEntry = {
    workflow: 'bridge-alert',
    timestamp: new Date().toISOString(),
    dry_run: true,
    tweet_text: $input.first().json.tweet,
    tx_hash: $input.first().json.tx_hash,
    amount_tao: $input.first().json.amount_tao,
    source_chain: $input.first().json.source_chain,
    dest_chain: $input.first().json.dest_chain,
    would_post_to: '@v0idai'
  };

  fs.mkdirSync(logDir, { recursive: true });
  fs.writeFileSync(logFile, JSON.stringify(logEntry, null, 2));

  return [{ json: { status: 'logged', file: logFile } }];
  ```

#### Node 9: Post via API
- **Type:** Same Switch pattern as Workflow 1, Node 12 (OpenTweet / X API / Outstand).

#### Node 10: Post Result Notification
- **Type:** HTTP Request (Discord Webhook)
- **Config:** Notify Discord on success or failure, same pattern as Workflow 1.

### Error Handling

| Failure Point | Behavior |
|---------------|----------|
| Tracker API down (cron mode) | Log error, skip this cycle. Next cycle will retry. No notification unless 3+ consecutive failures. |
| Webhook payload malformed | Validate required fields. If missing, log error and notify Discord. |
| Duplicate transaction | Deduplicate node filters it. No alert sent. |
| Posting API down | Notify Discord with draft tweet for manual posting. |

### DRY_RUN Behavior

When `DRY_RUN=true`:
1. Webhook/cron triggers still fire.
2. Bridge data is fetched and processed.
3. Tweet is formatted and validated.
4. Output written to `LOG_FILE_PATH/workflow-2-bridge-alert-{timestamp}.json`.
5. No post is made to any platform.
6. Deduplicate state is still updated (so switching to live won't re-post old txs).

### Testing Instructions

1. Set `DRY_RUN=true`.
2. **Webhook test:** Use n8n's "Test Webhook" button, then send a POST request with sample payload using curl:
   ```bash
   curl -X POST http://localhost:5678/webhook/bridge-tx-alert \
     -H "Content-Type: application/json" \
     -d '{"tx_hash":"0xtest123","amount_tao":250.5,"source_chain":"Bittensor","dest_chain":"Solana","timestamp":"2026-03-15T14:30:00Z","explorer_url":"https://example.com/tx/0xtest123"}'
   ```
3. **Cron test:** Execute workflow manually. Verify it fetches from Tracker API.
4. **Threshold test:** Send a tx with `amount_tao: 50` (below threshold). Verify no tweet is generated.
5. **Dedup test:** Send the same `tx_hash` twice. Verify second execution produces no output.
6. Verify log files are written correctly.

---

## Workflow 3: Weekly Recap Thread

**Priority:** HIGH (Slot 3 of 5)
**File:** `workflows/workflow-3-weekly-recap.json`

### Description

Every Friday at 2:00 PM ET, aggregates 7 days of data (SN106 metrics, TAO price movement, bridge volume, GitHub commits), sends it to Claude API to generate an 8-10 tweet thread, writes the thread to the drafts queue for human review, and notifies Vew via Discord. This workflow ALWAYS requires human approval -- it never auto-posts.

### Trigger

- **Type:** Cron
- **Schedule:** `0 14 * * 5` (Friday 2:00 PM ET)
- **Timezone:** `America/New_York`

### Node-by-Node Specification

```
[Cron] -> [Parallel: Taostats 7d, CoinGecko 7d, Bridge Volume, GitHub Commits] -> [Merge All] -> [Claude API Generate Thread] -> [Write to Drafts Queue] -> [Discord Notification]
```

#### Node 1: Cron Trigger
- **Type:** Schedule Trigger
- **Config:** `0 14 * * 5`, timezone `America/New_York`

#### Node 2a: Taostats -- 7-Day Subnet History
- **Type:** HTTP Request
- **Config:**
  - Method: `GET`
  - URL: `{{ $env.TAOSTATS_API_BASE }}/dtao/pool/history?netuid=106&period=7d`
  - Headers: `Authorization: {{ $env.TAOSTATS_API_KEY }}`
  - Continue On Fail: `true`

#### Node 2b: CoinGecko -- 7-Day TAO Price History
- **Type:** HTTP Request
- **Config:**
  - Method: `GET`
  - URL: `{{ $env.COINGECKO_API_BASE }}/coins/bittensor/market_chart?vs_currency=usd&days=7`
  - Continue On Fail: `true`
- **Expected Response:** Array of `[timestamp, price]` pairs.

#### Node 2c: CoinGecko -- 7-Day SN106 Alpha Price History
- **Type:** HTTP Request
- **Config:**
  - Method: `GET`
  - URL: `{{ $env.COINGECKO_API_BASE }}/coins/liquidity-provisioning/market_chart?vs_currency=usd&days=7`
  - Continue On Fail: `true`

#### Node 2d: Bridge Volume (Internal)
- **Type:** HTTP Request
- **Config:**
  - Method: `GET`
  - URL: `{{ $env.BRIDGE_MONITOR_URL }}?period=7d&aggregate=true`
  - Continue On Fail: `true`
- **Expected Response:**
  ```json
  {
    "total_tao_bridged": 5000,
    "transaction_count": 47,
    "unique_wallets": 23,
    "chains": {
      "Solana": { "tao_bridged": 3200, "tx_count": 30 },
      "Ethereum": { "tao_bridged": 1500, "tx_count": 12 },
      "Base": { "tao_bridged": 300, "tx_count": 5 }
    }
  }
  ```
- **Note:** This endpoint depends on the consolidated Tracker service. If not available yet, this node can be disabled and the thread generated without bridge data.

#### Node 2e: GitHub Commits (Optional)
- **Type:** HTTP Request
- **Config:**
  - Method: `GET`
  - URL: `https://api.github.com/orgs/{{ $env.GITHUB_ORG }}/repos?per_page=100&sort=pushed`
  - Headers: `Authorization: Bearer {{ $env.GITHUB_TOKEN }}`
  - Continue On Fail: `true`
- **Post-processing (Code node):**
  ```javascript
  // Count commits across all repos in the last 7 days
  const repos = $input.first().json;
  const oneWeekAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString();
  let totalCommits = 0;
  let activeRepos = 0;

  // Note: this is approximate. For exact counts, you'd need to
  // hit /repos/{owner}/{repo}/commits?since={date} for each repo.
  // This simplified version counts repos pushed in the last 7 days.
  if (Array.isArray(repos)) {
    for (const repo of repos) {
      if (repo.pushed_at > oneWeekAgo && !repo.fork) {
        activeRepos++;
      }
    }
  }

  return [{ json: { active_repos: activeRepos, note: 'repos with pushes in last 7d' } }];
  ```

#### Node 3: Merge All Data
- **Type:** Code (JavaScript)
- **Config:**
  ```javascript
  const taostats = $('Taostats 7d').first().json;
  const taoPrices = $('CoinGecko TAO 7d').first().json;
  const alphaPrices = $('CoinGecko SN106 7d').first().json;
  const bridge = $('Bridge Volume').first().json;
  const github = $('GitHub Commits').first().json;

  // Calculate TAO weekly change from price history
  let taoWeeklyChange = 'N/A';
  if (taoPrices?.prices?.length >= 2) {
    const start = taoPrices.prices[0][1];
    const end = taoPrices.prices[taoPrices.prices.length - 1][1];
    taoWeeklyChange = ((end - start) / start * 100).toFixed(1);
  }

  // Calculate Alpha weekly change
  let alphaWeeklyChange = 'N/A';
  if (alphaPrices?.prices?.length >= 2) {
    const start = alphaPrices.prices[0][1];
    const end = alphaPrices.prices[alphaPrices.prices.length - 1][1];
    alphaWeeklyChange = ((end - start) / start * 100).toFixed(1);
  }

  const weekData = {
    tao_current_price: taoPrices?.prices?.length
      ? taoPrices.prices[taoPrices.prices.length - 1][1]
      : 'N/A',
    tao_weekly_change_pct: taoWeeklyChange,
    alpha_current_price: alphaPrices?.prices?.length
      ? alphaPrices.prices[alphaPrices.prices.length - 1][1]
      : 'N/A',
    alpha_weekly_change_pct: alphaWeeklyChange,
    bridge_total_tao: bridge?.total_tao_bridged ?? 'N/A',
    bridge_tx_count: bridge?.transaction_count ?? 'N/A',
    bridge_unique_wallets: bridge?.unique_wallets ?? 'N/A',
    bridge_chains: bridge?.chains ?? {},
    github_active_repos: github?.active_repos ?? 'N/A',
    sn106_pool_data: taostats ?? {},
    week_ending: new Date().toLocaleDateString('en-US', {
      year: 'numeric', month: 'long', day: 'numeric',
      timeZone: 'America/New_York'
    })
  };

  return [{ json: weekData }];
  ```

#### Node 4: Claude API -- Generate Thread
- **Type:** HTTP Request
- **Config:**
  - Method: `POST`
  - URL: `https://api.anthropic.com/v1/messages`
  - Headers:
    - `x-api-key: {{ $env.CLAUDE_API_KEY }}`
    - `anthropic-version: 2023-06-01`
    - `Content-Type: application/json`
  - Body (JSON):
    ```json
    {
      "model": "claude-sonnet-4-20250514",
      "max_tokens": 2000,
      "messages": [
        {
          "role": "user",
          "content": "You are writing a weekly recap X thread for @v0idai (VoidAI, Bittensor SN106 subnet). Write 8-10 tweets as a thread.\n\nRules:\n- First tweet is the hook. Must stop the scroll.\n- Each tweet must be under 280 characters.\n- Use specific numbers. No fluff.\n- Tone: builder-credible, data-first, direct. Not hype.\n- Include $TAO and #Bittensor hashtags naturally.\n- Last tweet: forward-looking CTA (follow, bridge, join Discord).\n- NEVER use: guaranteed returns, risk-free, passive income, to the moon, or any price predictions.\n- NEVER use em dashes. Use commas, periods, or colons instead.\n- Include a short disclaimer in the last tweet: 'Not financial advice. DYOR.'\n- Do NOT use any of these phrases: 'It's worth noting', 'In the ever-evolving landscape', 'game-changer', 'paradigm shift', 'seamless integration', 'robust ecosystem', 'cutting-edge'.\n\nWeek ending: {{ $json.week_ending }}\n\nData:\n- TAO price: ${{ $json.tao_current_price }} ({{ $json.tao_weekly_change_pct }}% weekly)\n- SN106 Alpha price: ${{ $json.alpha_current_price }} ({{ $json.alpha_weekly_change_pct }}% weekly)\n- Bridge volume: {{ $json.bridge_total_tao }} TAO bridged this week\n- Bridge transactions: {{ $json.bridge_tx_count }}\n- Unique bridge wallets: {{ $json.bridge_unique_wallets }}\n- GitHub repos active: {{ $json.github_active_repos }}\n\nFormat your response as a JSON array of strings, one per tweet. Example:\n[\"1/ Hook tweet here\", \"2/ Second tweet\", ..., \"8/ Final tweet with CTA\"]"
        }
      ]
    }
    ```
  - Continue On Fail: `true`

#### Node 5: Parse Thread
- **Type:** Code (JavaScript)
- **Config:**
  ```javascript
  const response = $input.first().json;
  let threadTweets = [];

  try {
    // Claude returns content in response.content[0].text
    const text = response.content[0].text;
    // Parse JSON array from response
    threadTweets = JSON.parse(text);
  } catch (e) {
    // If JSON parsing fails, try to extract tweets manually
    const text = response.content?.[0]?.text || '';
    threadTweets = text.split('\n').filter(line => line.match(/^\d+\//));
  }

  // Validate each tweet is under 280 chars
  const validated = threadTweets.map((tweet, i) => ({
    index: i + 1,
    text: tweet,
    length: tweet.length,
    over_limit: tweet.length > 280
  }));

  const hasErrors = validated.some(t => t.over_limit);

  return [{
    json: {
      thread: validated,
      tweet_count: validated.length,
      has_length_errors: hasErrors,
      raw_response: response
    }
  }];
  ```

#### Node 6: Write to Drafts Queue
- **Type:** Code (JavaScript)
- **Config:**
  ```javascript
  const fs = require('fs');
  const draftsDir = $env.QUEUE_DRAFTS_PATH || '/data/voidai/queue/drafts/';
  const date = new Date().toISOString().split('T')[0];
  const filename = `weekly-recap-${date}.md`;
  const filepath = `${draftsDir}${filename}`;

  const thread = $input.first().json.thread;

  // Build YAML frontmatter + content (matches /queue skill format)
  let content = `---
type: x-thread
account: "@v0idai"
status: review
created: ${new Date().toISOString()}
source: workflow-3-weekly-recap
requires_human_review: true
tweet_count: ${thread.length}
has_length_errors: ${$input.first().json.has_length_errors}
---

# Weekly Recap Thread | ${date}

`;

  for (const tweet of thread) {
    content += `## Tweet ${tweet.index} (${tweet.length} chars${tweet.over_limit ? ' -- OVER LIMIT' : ''})

${tweet.text}

`;
  }

  fs.mkdirSync(draftsDir, { recursive: true });
  fs.writeFileSync(filepath, content);

  return [{ json: { status: 'drafted', file: filepath, tweet_count: thread.length } }];
  ```

#### Node 7: Discord Notification
- **Type:** HTTP Request
- **Config:**
  - Method: `POST`
  - URL: `{{ $env.DISCORD_WEBHOOK_URL }}`
  - Body (JSON):
    ```json
    {
      "content": "**Weekly Recap Thread Ready for Review**\n\nFile: `{{ $json.file }}`\nTweets: {{ $json.tweet_count }}\n\nReview and approve before posting. Use `/queue approve {{ $json.file }}` when ready.\n\n_This thread will NOT be posted automatically. Human review required._"
    }
    ```

### Error Handling

| Failure Point | Behavior |
|---------------|----------|
| Any data API down | Thread generated with available data. Missing data noted as "N/A" in prompt. |
| Claude API down | Notify Discord that weekly recap generation failed. Provide raw data for manual thread writing. |
| Thread tweets over 280 chars | Flagged in draft file. Human reviewer must edit before approving. |
| Write to drafts fails | Notify Discord with full thread text in message body as fallback. |

### DRY_RUN Behavior

This workflow ALWAYS writes to the drafts queue (never auto-posts), so DRY_RUN behavior is identical to production: data is fetched, thread is generated, draft is written, Discord is notified. The human review gate is the safety mechanism, not DRY_RUN.

In DRY_RUN mode, the only difference: the Discord notification includes a "[DRY_RUN]" prefix so Vew knows the data sources may be in test mode.

### Testing Instructions

1. Execute workflow manually (don't wait for Friday).
2. Check all 5 data fetch nodes produce valid responses.
3. Verify Claude API generates a properly formatted JSON array of tweets.
4. Check the draft file in `QUEUE_DRAFTS_PATH` has correct YAML frontmatter.
5. Verify Discord notification was received.
6. Read the thread. Check for: compliance violations, banned phrases, em dashes, tweet length.
7. Test with mock data (some APIs returning errors) to verify graceful degradation.

---

## Workflow 4: Ecosystem News Monitor

**Priority:** HIGH (Slot 4 of 5)
**File:** `workflows/workflow-4-ecosystem-news.json`

### Description

Every 4 hours, scans for Bittensor ecosystem news via RSS feeds (and X API search when available), scores each item for relevance using Claude, and writes high-scoring items with draft commentary to the content queue. Ensures VoidAI stays responsive to ecosystem developments.

### Trigger

- **Type:** Cron
- **Schedule:** `0 */4 * * *` (every 4 hours: 00:00, 04:00, 08:00, 12:00, 16:00, 20:00 UTC)

### Node-by-Node Specification

```
[Cron] -> [Parallel: RSS Feeds, X API Search (when available)] -> [Merge + Deduplicate] -> [Claude API Score + Draft] -> [Filter >= 7] -> [Write to Drafts] -> [Discord Notification]
```

#### Node 1: Cron Trigger
- **Type:** Schedule Trigger
- **Config:** `0 */4 * * *`, timezone `UTC`

#### Node 2a: RSS Feed -- CoinDesk
- **Type:** RSS Feed Trigger / HTTP Request
- **Config:**
  - URL: `https://www.coindesk.com/arc/outboundfeeds/rss/`
  - Note: Filter for "Bittensor" or "TAO" in title/description post-fetch.
  - Continue On Fail: `true`

#### Node 2b: RSS Feed -- The Block
- **Type:** HTTP Request
- **Config:**
  - URL: `https://www.theblock.co/rss.xml`
  - Continue On Fail: `true`

#### Node 2c: RSS Feed -- CoinTelegraph
- **Type:** HTTP Request
- **Config:**
  - URL: `https://cointelegraph.com/rss`
  - Continue On Fail: `true`

#### Node 2d: RSS Feed -- DL News
- **Type:** HTTP Request
- **Config:**
  - URL: `https://www.dlnews.com/rss/`
  - Continue On Fail: `true`

#### Node 2e: X API Search (Phase 3+ when X API available)
- **Type:** HTTP Request
- **Config:**
  - Method: `GET`
  - URL: `https://api.twitter.com/2/tweets/search/recent?query=(Bittensor OR $TAO OR SN106 OR VoidAI) -is:retweet&max_results=50&tweet.fields=created_at,public_metrics,author_id`
  - Headers: `Authorization: Bearer {{ $env.X_API_BEARER_TOKEN }}`
  - Continue On Fail: `true`
  - **Note:** Disabled until X API Basic is activated. Enable in Phase 3.

#### Node 3: Filter RSS for Relevance
- **Type:** Code (JavaScript)
- **Config:**
  ```javascript
  // Combine all RSS feeds and filter for Bittensor-related content
  const keywords = [
    'bittensor', 'tao', 'sn106', 'voidai', 'void ai',
    'subnet', 'decentralized ai', 'chainlink ccip',
    'cross-chain bridge', 'dtao', 'opentensor'
  ];

  const allItems = [];
  const sources = ['CoinDesk RSS', 'The Block RSS', 'CoinTelegraph RSS', 'DL News RSS'];

  for (const sourceName of sources) {
    try {
      const feed = $(sourceName).first().json;
      const items = feed?.rss?.channel?.item || feed?.items || [];
      const itemList = Array.isArray(items) ? items : [items];

      for (const item of itemList) {
        const title = (item.title || '').toLowerCase();
        const desc = (item.description || item.summary || '').toLowerCase();
        const combined = title + ' ' + desc;

        const isRelevant = keywords.some(kw => combined.includes(kw));
        if (isRelevant) {
          allItems.push({
            title: item.title,
            description: item.description || item.summary || '',
            url: item.link || item.url || '',
            published: item.pubDate || item.published || '',
            source: sourceName.replace(' RSS', ''),
            type: 'news'
          });
        }
      }
    } catch (e) {
      // Feed unavailable, skip
    }
  }

  // Deduplicate by URL
  const seen = new Set();
  const unique = allItems.filter(item => {
    if (seen.has(item.url)) return false;
    seen.add(item.url);
    return true;
  });

  // Check against already-processed items
  const fs = require('fs');
  const stateFile = ($env.LOG_FILE_PATH || '/data/n8n/dry-run-logs/') + 'news-monitor-state.json';
  let state = {};
  try {
    state = JSON.parse(fs.readFileSync(stateFile, 'utf8'));
  } catch (e) {
    state = { processed_urls: [] };
  }

  const newItems = unique.filter(item => !state.processed_urls.includes(item.url));

  // Update state
  state.processed_urls = [...state.processed_urls, ...newItems.map(i => i.url)].slice(-1000);
  fs.writeFileSync(stateFile, JSON.stringify(state, null, 2));

  if (newItems.length === 0) {
    return [{ json: { no_new_items: true } }];
  }

  return newItems.map(item => ({ json: item }));
  ```

#### Node 4: Check for New Items
- **Type:** IF
- **Config:**
  - Condition: `{{ $json.no_new_items }}` equals `true`
  - True: Stop (nothing new)
  - False: Continue to scoring

#### Node 5: Claude API -- Score and Draft Commentary
- **Type:** HTTP Request (loop over items)
- **Config:**
  - Method: `POST`
  - URL: `https://api.anthropic.com/v1/messages`
  - Headers:
    - `x-api-key: {{ $env.CLAUDE_API_KEY }}`
    - `anthropic-version: 2023-06-01`
  - Body:
    ```json
    {
      "model": "claude-sonnet-4-20250514",
      "max_tokens": 500,
      "messages": [
        {
          "role": "user",
          "content": "Score this news item for relevance to VoidAI (Bittensor SN106, cross-chain bridge, DeFi infrastructure) and draft a short commentary tweet from @v0idai perspective.\n\nRules for commentary:\n- Be data-first, builder-credible, direct.\n- Show genuine ecosystem knowledge.\n- NEVER use em dashes. Use commas, periods, or colons.\n- NEVER use: 'game-changer', 'paradigm shift', 'seamless', 'robust ecosystem', 'cutting-edge'.\n- Max 280 characters for the commentary tweet.\n- If the news mentions VoidAI directly, score higher.\n- If the news is about Bittensor ecosystem, Chainlink, cross-chain DeFi, or TAO, score higher.\n\nNews item:\nTitle: {{ $json.title }}\nDescription: {{ $json.description }}\nSource: {{ $json.source }}\nURL: {{ $json.url }}\n\nRespond in JSON format:\n{\"score\": <1-10>, \"reasoning\": \"<why this score>\", \"commentary\": \"<draft tweet text>\", \"suggested_hashtags\": [\"#tag1\", \"#tag2\"]}"
        }
      ]
    }
    ```
  - Continue On Fail: `true`
  - **Rate Limiting Note:** Process items sequentially with a 1-second delay between calls to avoid Claude API rate limits. Use n8n's "Batch Size" setting = 1 with "Wait Between Batches" = 1000ms.

#### Node 6: Parse Score
- **Type:** Code (JavaScript)
- **Config:**
  ```javascript
  const items = $input.all();
  const results = [];

  for (const item of items) {
    try {
      const claudeResponse = item.json.content?.[0]?.text || '{}';
      const parsed = JSON.parse(claudeResponse);

      results.push({
        json: {
          ...item.json.originalItem,
          score: parsed.score || 0,
          reasoning: parsed.reasoning || '',
          commentary: parsed.commentary || '',
          hashtags: parsed.suggested_hashtags || [],
          scored_at: new Date().toISOString()
        }
      });
    } catch (e) {
      // Skip items that failed scoring
    }
  }

  return results;
  ```

#### Node 7: Filter Score >= 7
- **Type:** IF
- **Config:**
  - Condition: `{{ $json.score }}` >= 7

#### Node 8: Write to Drafts Queue
- **Type:** Code (JavaScript)
- **Config:**
  ```javascript
  const fs = require('fs');
  const draftsDir = $env.QUEUE_DRAFTS_PATH || '/data/voidai/queue/drafts/';
  const item = $input.first().json;
  const slug = item.title.toLowerCase().replace(/[^a-z0-9]+/g, '-').slice(0, 50);
  const date = new Date().toISOString().split('T')[0];
  const filename = `news-${date}-${slug}.md`;
  const filepath = `${draftsDir}${filename}`;

  const content = `---
type: x-single
account: "@v0idai"
status: review
created: ${new Date().toISOString()}
source: workflow-4-ecosystem-news
requires_human_review: true
relevance_score: ${item.score}
news_source: ${item.source}
news_url: ${item.url}
---

# News Commentary | ${item.title}

## Original Article
- **Title:** ${item.title}
- **Source:** ${item.source}
- **URL:** ${item.url}
- **Relevance Score:** ${item.score}/10
- **Reasoning:** ${item.reasoning}

## Draft Tweet (${item.commentary.length} chars)

${item.commentary}

## Suggested Hashtags
${item.hashtags.join(' ')}
`;

  fs.mkdirSync(draftsDir, { recursive: true });
  fs.writeFileSync(filepath, content);

  return [{ json: { status: 'drafted', file: filepath, score: item.score, title: item.title } }];
  ```

#### Node 9: Discord Notification (batch summary)
- **Type:** Code + HTTP Request
- **Config:**
  ```javascript
  // Collect all drafted items into one notification
  const items = $input.all();

  if (items.length === 0) return [];

  const summary = items.map(i =>
    `- [${i.json.score}/10] ${i.json.title}`
  ).join('\n');

  const message = `**Ecosystem News Monitor: ${items.length} item(s) scored >= 7**\n\n${summary}\n\nReview drafts in \`queue/drafts/\` and approve for posting.`;

  return [{ json: { discord_message: message } }];
  ```
  Then HTTP Request to Discord webhook with the message.

### Error Handling

| Failure Point | Behavior |
|---------------|----------|
| RSS feed down | Skip that feed. Other feeds still processed. |
| All RSS feeds down | No items to score. Workflow ends silently. If X API search is enabled, it may still find items. |
| Claude API down | Notify Discord. Items are logged but unscored. Manual review needed. |
| Claude returns invalid JSON | Item skipped. Error logged. |
| X API not yet available | Node 2e disabled. Workflow runs with RSS only. |

### DRY_RUN Behavior

This workflow ALWAYS writes to the drafts queue (never auto-posts), so behavior is identical in DRY_RUN and production. The human review gate is the safety mechanism. DRY_RUN prefix is added to Discord notification for awareness.

### Testing Instructions

1. Execute workflow manually.
2. Check RSS feed nodes return valid XML/JSON.
3. Verify keyword filtering produces relevant items only.
4. Verify deduplication prevents re-processing of already-seen URLs.
5. Check Claude API scoring returns valid JSON with score 1-10.
6. Verify only items scoring >= 7 reach the drafts queue.
7. Read draft files. Check for: compliance violations, banned phrases, em dashes, tweet length.
8. Verify Discord notification was received with correct summary.

---

## Workflow 5: Content Calendar Scheduler

**Priority:** HIGH (Slot 5 of 5)
**File:** `workflows/workflow-5-content-scheduler.json`

### Description

Runs daily at 7:00 AM ET. Reads the `queue/approved/` directory for content items tagged for today's date, enforces cadence rules (max posts per account, minimum spacing, weekend rules), assigns optimal posting times, and either schedules them via the posting API or logs the schedule in DRY_RUN mode. Moves posted items to `queue/scheduled/`.

### Trigger

- **Type:** Cron
- **Schedule:** `0 7 * * *` (7:00 AM ET daily)
- **Timezone:** `America/New_York`

### Node-by-Node Specification

```
[Cron] -> [Read Approved Queue] -> [Filter Today's Items] -> [Enforce Cadence] -> [Assign Times] -> [DRY_RUN Check] -> [Schedule or Log] -> [Move to Scheduled] -> [Discord Summary]
```

#### Node 1: Cron Trigger
- **Type:** Schedule Trigger
- **Config:** `0 7 * * *`, timezone `America/New_York`

#### Node 2: Read Approved Queue
- **Type:** Code (JavaScript)
- **Config:**
  ```javascript
  const fs = require('fs');
  const path = require('path');
  const approvedDir = $env.QUEUE_APPROVED_PATH || '/data/voidai/queue/approved/';

  let files = [];
  try {
    files = fs.readdirSync(approvedDir)
      .filter(f => f.endsWith('.md'))
      .map(f => {
        const content = fs.readFileSync(path.join(approvedDir, f), 'utf8');

        // Parse YAML frontmatter
        const fmMatch = content.match(/^---\n([\s\S]*?)\n---/);
        const frontmatter = {};
        if (fmMatch) {
          fmMatch[1].split('\n').forEach(line => {
            const [key, ...val] = line.split(':');
            if (key && val.length) {
              frontmatter[key.trim()] = val.join(':').trim().replace(/^["']|["']$/g, '');
            }
          });
        }

        // Extract tweet text (content after frontmatter)
        const bodyMatch = content.match(/---\n[\s\S]*?\n---\n([\s\S]*)/);
        const body = bodyMatch ? bodyMatch[1].trim() : '';

        return {
          filename: f,
          filepath: path.join(approvedDir, f),
          frontmatter,
          body,
          account: frontmatter.account || '@v0idai',
          type: frontmatter.type || 'x-single',
          scheduled_date: frontmatter.scheduled_date || null,
          priority: parseInt(frontmatter.priority || '5', 10)
        };
      });
  } catch (e) {
    return [{ json: { error: 'Could not read approved queue', details: e.message, items: [] } }];
  }

  return [{ json: { items: files, count: files.length } }];
  ```

#### Node 3: Filter Today's Items
- **Type:** Code (JavaScript)
- **Config:**
  ```javascript
  const items = $input.first().json.items;
  const today = new Date().toISOString().split('T')[0];

  // Items for today: either scheduled_date matches today, or no date set (post ASAP)
  const todaysItems = items.filter(item =>
    item.scheduled_date === today || !item.scheduled_date
  );

  // Sort by priority (lower number = higher priority)
  todaysItems.sort((a, b) => a.priority - b.priority);

  if (todaysItems.length === 0) {
    return [{ json: { no_items: true, today } }];
  }

  return [{ json: { items: todaysItems, count: todaysItems.length, today } }];
  ```

#### Node 4: Check for Items
- **Type:** IF
- **Config:**
  - Condition: `{{ $json.no_items }}` equals `true`
  - True: Stop (nothing to schedule today)
  - False: Continue

#### Node 5: Enforce Cadence Rules
- **Type:** Code (JavaScript)
- **Config:**
  ```javascript
  // Cadence rules from cadence.md:
  // - @v0idai: max 6 posts/day, min 3-hour gap, 1-2 posts/day target
  // - Weekend: max 1 post/day per account
  // - Never more than 6 posts/day from any account

  const items = $input.first().json.items;
  const today = new Date();
  const isWeekend = today.getDay() === 0 || today.getDay() === 6;
  const maxPerDay = parseInt($env.MAX_POSTS_PER_DAY || '6', 10);
  const minGapMinutes = parseInt($env.MIN_POST_GAP_MINUTES || '180', 10);

  // Group by account
  const byAccount = {};
  for (const item of items) {
    const acct = item.account;
    if (!byAccount[acct]) byAccount[acct] = [];
    byAccount[acct].push(item);
  }

  const scheduled = [];
  const deferred = [];

  for (const [account, accountItems] of Object.entries(byAccount)) {
    const dailyLimit = isWeekend ? 1 : Math.min(maxPerDay, 2); // Target 1-2 per cadence.md

    // Take up to daily limit
    const toPost = accountItems.slice(0, dailyLimit);
    const toDefer = accountItems.slice(dailyLimit);

    scheduled.push(...toPost.map((item, i) => ({ ...item, slot_index: i })));
    deferred.push(...toDefer.map(item => ({ ...item, deferred_reason: 'cadence_limit' })));
  }

  return [{
    json: {
      scheduled,
      deferred,
      is_weekend: isWeekend,
      scheduled_count: scheduled.length,
      deferred_count: deferred.length
    }
  }];
  ```

#### Node 6: Assign Posting Times
- **Type:** Code (JavaScript)
- **Config:**
  ```javascript
  // Optimal posting windows from cadence.md:
  // @v0idai peak: 14:00-16:00 UTC, 20:00-22:00 UTC
  // (9-11 AM ET = 14:00-16:00 UTC in summer)
  const items = $input.first().json.scheduled;
  const minGap = parseInt($env.MIN_POST_GAP_MINUTES || '180', 10);

  // Define time slots (UTC hours)
  const timeSlots = [
    { hour: 14, minute: 0 },  // 9:00 AM ET (primary)
    { hour: 15, minute: 30 }, // 10:30 AM ET
    { hour: 17, minute: 0 },  // 12:00 PM ET
    { hour: 20, minute: 0 },  // 3:00 PM ET (secondary peak)
    { hour: 21, minute: 30 }, // 4:30 PM ET
  ];

  const today = new Date().toISOString().split('T')[0];

  const withTimes = items.map((item, i) => {
    const slot = timeSlots[i % timeSlots.length];
    const scheduledTime = `${today}T${String(slot.hour).padStart(2, '0')}:${String(slot.minute).padStart(2, '0')}:00Z`;

    return {
      ...item,
      scheduled_post_at: scheduledTime,
      time_slot: `${slot.hour}:${String(slot.minute).padStart(2, '0')} UTC`
    };
  });

  return [{
    json: {
      items: withTimes,
      deferred: $input.first().json.deferred
    }
  }];
  ```

#### Node 7: DRY_RUN Check
- **Type:** IF
- **Config:** Same pattern as Workflow 1.

#### Node 8a: DRY_RUN Log
- **Type:** Code (JavaScript)
- **Config:**
  ```javascript
  const fs = require('fs');
  const logDir = $env.LOG_FILE_PATH || '/data/n8n/dry-run-logs/';
  const date = new Date().toISOString().split('T')[0];
  const logFile = `${logDir}workflow-5-schedule-${date}.json`;

  const logEntry = {
    workflow: 'content-calendar-scheduler',
    timestamp: new Date().toISOString(),
    dry_run: true,
    scheduled_items: $input.first().json.items.map(item => ({
      filename: item.filename,
      account: item.account,
      type: item.type,
      scheduled_post_at: item.scheduled_post_at,
      preview: item.body?.slice(0, 100) + '...'
    })),
    deferred_items: $input.first().json.deferred.map(item => ({
      filename: item.filename,
      reason: item.deferred_reason
    }))
  };

  fs.mkdirSync(logDir, { recursive: true });
  fs.writeFileSync(logFile, JSON.stringify(logEntry, null, 2));

  return [{ json: { status: 'schedule_logged', file: logFile } }];
  ```

#### Node 8b: Schedule Posts (Production)
- **Type:** Code + HTTP Request loop
- **Config:**
  ```javascript
  // For each item, schedule via the posting API
  const items = $input.first().json.items;
  const results = [];

  for (const item of items) {
    // Based on POSTING_API env var, construct the appropriate API call
    // This would be implemented as sub-nodes in n8n, but the logic is:

    const postData = {
      text: item.body,
      scheduled_time: item.scheduled_post_at,
      account: item.account
    };

    results.push({
      filename: item.filename,
      account: item.account,
      scheduled_post_at: item.scheduled_post_at,
      status: 'scheduled'
    });
  }

  return [{ json: { results } }];
  ```
  **Implementation Note:** In practice, this node would be a loop that calls the posting API for each item. The exact API call depends on `POSTING_API`:
  - **OpenTweet:** `POST /v1/tweets/schedule` with `{ text, scheduled_time }`
  - **X API:** X API v2 does not support scheduled tweets natively. Alternative: use n8n's built-in "Wait" node to delay execution until the scheduled time, then post.
  - **Outstand:** `POST /v1/schedule` with `{ platforms, content, scheduled_time }`

#### Node 9: Move to Scheduled Directory
- **Type:** Code (JavaScript)
- **Config:**
  ```javascript
  const fs = require('fs');
  const path = require('path');
  const approvedDir = $env.QUEUE_APPROVED_PATH || '/data/voidai/queue/approved/';
  const scheduledDir = $env.QUEUE_SCHEDULED_PATH || '/data/voidai/queue/scheduled/';
  const items = $input.first().json.items || $input.first().json.results || [];

  fs.mkdirSync(scheduledDir, { recursive: true });

  for (const item of items) {
    const src = path.join(approvedDir, item.filename);
    const dest = path.join(scheduledDir, item.filename);

    try {
      // Read, update frontmatter, write to scheduled/
      let content = fs.readFileSync(src, 'utf8');
      content = content.replace(
        /status: approved/,
        `status: scheduled\nscheduled_post_at: ${item.scheduled_post_at}`
      );
      fs.writeFileSync(dest, content);
      fs.unlinkSync(src); // Remove from approved/
    } catch (e) {
      // Log error but continue with other items
    }
  }

  return [{ json: { moved: items.length } }];
  ```

#### Node 10: Discord Summary
- **Type:** HTTP Request
- **Config:**
  - Method: `POST`
  - URL: `{{ $env.DISCORD_WEBHOOK_URL }}`
  - Body:
    ```json
    {
      "content": "**Content Calendar: Today's Schedule**\n\nScheduled: {{ scheduled_count }} posts\nDeferred: {{ deferred_count }} posts (cadence limits)\n\n{{ items.map(i => `- ${i.time_slot}: ${i.account} | ${i.type} | ${i.filename}`).join('\\n') }}\n\n{{ deferred.length ? 'Deferred items will be rescheduled tomorrow.' : '' }}"
    }
    ```

### Error Handling

| Failure Point | Behavior |
|---------------|----------|
| Approved queue directory empty | Workflow ends. No notification (this is normal if no content is approved). |
| File read error | Log error, skip that file, continue with others. |
| Scheduling API fails | Notify Discord. File stays in approved/ for retry. |
| Cadence limit exceeded | Items deferred to next day. Deferred items noted in Discord summary. |

### DRY_RUN Behavior

When `DRY_RUN=true`:
1. Approved queue is read and cadence rules are enforced.
2. Posting times are assigned.
3. Full schedule is written to log file.
4. No API calls to posting services.
5. Files are NOT moved from approved/ to scheduled/ (they stay for the next test run).
6. Discord summary notes "[DRY_RUN]" prefix.

### Testing Instructions

1. Create 3-4 test `.md` files in `queue/approved/` with proper YAML frontmatter.
2. Set `DRY_RUN=true`.
3. Execute workflow manually.
4. Verify: files are read, cadence rules applied, times assigned, log written.
5. Check log file for correct schedule.
6. Test weekend mode: change system date or modify the weekend check to test weekend cadence (max 1 post/day).
7. Test over-limit: add 8 items for the same account. Verify only 2 are scheduled, 6 deferred.

---

## Workflow 6: Competitor Monitor (Phase 3+)

**Priority:** DEFERRED (Beyond Free Tier)
**File:** `workflows/workflow-6-competitor-monitor.json`
**Activation:** When upgrading from n8n free tier (5 workflow limit), OR by swapping out a lower-priority workflow.

### Description

Daily scan of competitor activity (Project Rubicon / @gtaoventures, TaoFi, Tensorplex) across X, news, and on-chain data. Generates a private competitor digest sent to Vew via Discord DM. Never posts publicly. This is an intelligence workflow, not a content workflow.

### Trigger

- **Type:** Cron
- **Schedule:** `0 8 * * *` (8:00 AM ET daily)

### Node-by-Node Specification

```
[Cron] -> [Parallel: X API Search, Taostats Competitor Subnets, RSS Search] -> [Claude API Summarize] -> [Discord DM to Vew]
```

#### Node 1: Cron Trigger
- **Config:** `0 8 * * *`, timezone `America/New_York`

#### Node 2a: X API Search -- Competitors
- **Type:** HTTP Request
- **Config:**
  - URL: `https://api.twitter.com/2/tweets/search/recent?query=(from:gtaoventures OR "Project Rubicon" OR "TaoFi" OR "Tensorplex") -is:retweet&max_results=50&tweet.fields=created_at,public_metrics`
  - Headers: `Authorization: Bearer {{ $env.X_API_BEARER_TOKEN }}`
  - Continue On Fail: `true`
  - **Note:** Requires X API Basic ($200/mo). Disabled until Phase 3.

#### Node 2b: Taostats -- Competitor Subnet Data
- **Type:** HTTP Request (multiple)
- **Config:** Fetch subnet data for known competitor subnets.
  - URL: `{{ $env.TAOSTATS_API_BASE }}/subnet/latest?netuid={competitor_netuid}`
  - Repeat for each competitor subnet.
  - Continue On Fail: `true`

#### Node 2c: RSS Search -- Competitors
- **Type:** Same RSS feeds as Workflow 4, filtered for competitor keywords.

#### Node 3: Claude API -- Summarize Competitor Activity
- **Type:** HTTP Request
- **Config:**
  - URL: `https://api.anthropic.com/v1/messages`
  - Body prompt: "Summarize competitor activity for VoidAI. Focus on: new features, partnerships, community sentiment, mindshare changes, threats, opportunities. Format as a brief daily intelligence digest."
  - Continue On Fail: `true`

#### Node 4: Discord DM to Vew
- **Type:** HTTP Request (Discord Webhook)
- **Config:**
  - URL: `{{ $env.DISCORD_WEBHOOK_URL }}` (private channel or DM webhook)
  - Body: The competitor digest.

### Environment Variables (Additional)

| Variable | Value | Description |
|----------|-------|-------------|
| `COMPETITOR_KEYWORDS` | `gtaoventures,Project Rubicon,TaoFi,Tensorplex` | Comma-separated competitor identifiers |
| `COMPETITOR_SUBNETS` | `(TBD)` | Comma-separated competitor subnet netuids |

### Error Handling

All nodes set to `Continue On Fail: true`. If all data sources fail, the digest is sent with a note that data collection failed.

### DRY_RUN Behavior

This workflow never posts publicly, so DRY_RUN only affects whether the Discord DM is sent. In DRY_RUN mode, the digest is written to a log file instead.

---

## Workflow 7: Blog Distribution Pipeline (Phase 3+)

**Priority:** DEFERRED (Beyond Free Tier)
**File:** `workflows/workflow-7-blog-distribution.json`
**Activation:** Same as Workflow 6.

### Description

Triggered when a new blog post is published. Reads the blog content, uses Claude to generate platform-specific derivatives (X thread, LinkedIn post, Discord announcement, Telegram message), and writes them all to the drafts queue for human review. Automates the 1:6:12:1 content pipeline.

### Trigger

- **Type:** Webhook
- **Path:** `/blog-published`
- **Payload:**
  ```json
  {
    "title": "How to Bridge TAO to Solana with VoidAI",
    "url": "https://voidai.com/blog/bridge-tao-solana",
    "content": "Full blog post text...",
    "category": "tutorial",
    "author": "Vew"
  }
  ```

### Node-by-Node Specification

```
[Webhook] -> [Claude API: Generate X Thread] -> [Claude API: Generate LinkedIn Post] -> [Claude API: Generate Discord Announcement] -> [Write All to Drafts] -> [Discord Notification]
```

#### Node 1: Webhook Trigger
- **Config:** `POST /blog-published`

#### Node 2: Claude API -- X Thread (10-12 tweets)
- **Type:** HTTP Request
- **Config:** Similar to Workflow 3 Node 4, but prompt is:
  "Convert this blog post into a 10-12 tweet X thread for @v0idai. First tweet is the hook. Each tweet under 280 chars. Include link to blog in tweet 2 or 3. End with CTA. Follow all VoidAI voice and compliance rules."

#### Node 3: Claude API -- LinkedIn Post
- **Type:** HTTP Request
- **Config:** Prompt:
  "Convert this blog post into a LinkedIn post for VoidAI company page. Professional, thought-leadership tone. 200-400 words. Include blog link. Add relevant hashtags (#Bittensor #DeFi #CrossChain #Web3)."

#### Node 4: Claude API -- Discord Announcement
- **Type:** HTTP Request
- **Config:** Prompt:
  "Convert this blog post into a Discord announcement for #announcements channel. Casual but informative. Include blog link. Use Discord markdown formatting. Keep under 2000 characters."

#### Node 5: Write All to Drafts Queue
- **Type:** Code (JavaScript)
- **Config:** Writes three files to `queue/drafts/`:
  - `blog-deriv-x-thread-{slug}.md`
  - `blog-deriv-linkedin-{slug}.md`
  - `blog-deriv-discord-{slug}.md`

#### Node 6: Discord Notification
- **Config:** Notify Vew that 3 derivative drafts are ready for review.

### Error Handling

If Claude API fails for one derivative, the others still proceed. Failed derivatives noted in Discord notification.

### DRY_RUN Behavior

Same as Workflows 3-4: always writes to drafts queue. Human review gate is the safety mechanism.

---

## API Reference Notes

### Taostats API

- **Base URL:** `https://api.taostats.io/api`
- **Auth:** API key in header (`Authorization: {key}`)
- **Free tier:** Available, rate limits apply
- **Key endpoints used:**
  - `GET /subnet/latest?netuid=106` -- SN106 subnet data
  - `GET /dtao/pool/latest?netuid=106` -- SN106 dTAO pool data (alpha price, reserves)
  - `GET /dtao/pool/history?netuid=106&period=7d` -- 7-day pool history
  - `GET /validator/yield` -- Validator yield data
  - `GET /account/latest?address={ss58}` -- Account data
- **Note:** Verify exact endpoint paths against Taostats API documentation. The paths above are based on common patterns. Use the `getTaostatsApiRoutes` MCP tool to get the canonical route list.

### CoinGecko API

- **Base URL:** `https://api.coingecko.com/api/v3`
- **Auth:** Optional demo key via `x-cg-demo-api-key` header
- **Free tier:** 10-30 calls/minute (sufficient for our use)
- **Key endpoints used:**
  - `GET /simple/price?ids=bittensor&vs_currencies=usd&include_24hr_change=true&include_market_cap=true&include_24hr_vol=true`
  - `GET /simple/price?ids=liquidity-provisioning&vs_currencies=usd&include_24hr_change=true&include_market_cap=true`
  - `GET /coins/bittensor/market_chart?vs_currency=usd&days=7`
  - `GET /coins/liquidity-provisioning/market_chart?vs_currency=usd&days=7`
- **CoinGecko coin IDs:**
  - TAO: `bittensor`
  - SN106 Alpha: `liquidity-provisioning`

### X API v2 (Phase 3+)

- **Plan:** Basic ($200/mo)
- **Key endpoints:**
  - `POST /2/tweets` -- Post tweet
  - `GET /2/tweets/search/recent` -- Search recent tweets
- **Auth:** OAuth 1.0a for posting, Bearer token for search

### OpenTweet (Phase 1-2 trial)

- **Cost:** $6/mo (or 7-day free trial)
- **Docs:** Check opentweet.com for current API documentation
- **Note:** Verify endpoint paths before building. The spec assumes standard tweet posting API.

### Outstand API (Placeholder)

- **Status:** Not yet available
- **Expected:** Multi-platform publishing (X, LinkedIn, Discord, Telegram) via single API
- **Cost:** ~$6/mo
- **Alternative:** Post directly to each platform's API until Outstand is available

### Claude API (Anthropic)

- **Base URL:** `https://api.anthropic.com/v1/messages`
- **Model:** `claude-sonnet-4-20250514` (recommended for content generation in workflows; cost-effective)
- **Auth:** `x-api-key` header + `anthropic-version: 2023-06-01`
- **Rate limits:** Varies by plan. Workflows use sequential processing with delays to stay within limits.

---

## Testing Playbook

### Phase 1: Individual Workflow Testing (Days 4-7)

For each workflow:

1. **Set `DRY_RUN=true` in n8n variables.**
2. **Open workflow in n8n editor.**
3. **Execute manually** (click "Execute Workflow").
4. **Inspect each node:** Click on each node to see its output. Verify:
   - API calls returned valid data
   - Data transformations produced expected output
   - Tweets are within 280 characters
   - No banned phrases or em dashes in generated content
   - DRY_RUN correctly prevented external posting
   - Log files were written with complete data
5. **Test error paths:** Temporarily break an API URL to verify error handling works.
6. **Review generated content** against `compliance.md` and `voice.md`.

### Phase 2: Integration Testing (Days 8-10)

1. **Run all 5 workflows in sequence** (manual triggers).
2. **Verify no conflicts:** Check that workflows don't interfere with each other's state files.
3. **Full day simulation:**
   - 7:00 AM: Workflow 5 (Content Calendar) runs -- verify it reads queue correctly.
   - 9:00 AM: Workflow 1 (Daily Metrics) runs -- verify tweet is generated.
   - Every 4 hours: Workflow 4 (News Monitor) runs -- verify items are scored.
   - On demand: Workflow 2 (Bridge Alerts) fires on webhook -- verify alert is generated.
4. **Check resource usage:** Monitor n8n's execution logs for excessive API calls or long-running nodes.

### Phase 3: Go-Live Checklist

Before setting `DRY_RUN=false`:

- [ ] All 5 workflows pass individual testing
- [ ] Integration test (full day simulation) passes
- [ ] Generated content reviewed for compliance by Vew
- [ ] API keys are production keys (not test/sandbox)
- [ ] Discord webhook points to correct channel
- [ ] `POSTING_API` is set correctly (`opentweet` for trial, `x_api` for production)
- [ ] Cron schedules are set to correct timezone
- [ ] Error notifications are being received in Discord
- [ ] Log file directory exists and is writable
- [ ] Queue directories exist: `drafts/`, `approved/`, `scheduled/`
- [ ] Deduplicate state files are initialized (empty JSON objects)

### Rollback Procedure

If anything goes wrong after go-live:

1. Set `DRY_RUN=true` immediately (one variable change).
2. All workflows continue running but nothing posts externally.
3. Review logs to identify the issue.
4. Fix the issue.
5. Test the fix with `DRY_RUN=true`.
6. Set `DRY_RUN=false` to resume.

---

## Free Tier Slot Allocation Summary

| Slot | Workflow | Trigger | Critical? |
|------|----------|---------|-----------|
| 1 | Daily Metrics Post | Cron 9 AM ET daily | Yes |
| 2 | Bridge Transaction Alerts | Webhook / Cron 15min | Yes |
| 3 | Weekly Recap Thread | Cron Fri 2 PM ET | Yes |
| 4 | Ecosystem News Monitor | Cron every 4 hours | Yes |
| 5 | Content Calendar Scheduler | Cron 7 AM ET daily | Yes |
| -- | Competitor Monitor | Cron 8 AM ET daily | Phase 3+ (swap slot) |
| -- | Blog Distribution | Webhook | Phase 3+ (swap slot) |

**Swap strategy:** When upgrading beyond free tier, activate Workflows 6 and 7 first. If staying on free tier and needing Workflow 6 or 7, the most swappable slot is Workflow 4 (News Monitor), which can be run manually instead.

---

## Changelog

| Date | Change |
|------|--------|
| 2026-03-15 | Initial creation. 7 workflows specified (5 active + 2 Phase 3+). |
