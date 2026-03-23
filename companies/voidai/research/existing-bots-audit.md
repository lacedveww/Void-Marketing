# Existing Bots Audit

## Overview

VoidAI has two existing Twitter bot codebases that can be repurposed for the broader marketing automation strategy. Both are functional and share a common pattern: monitor blockchain data, format a tweet, post via Twitter API.

---

## TwiterBot (v0idai/TwiterBot)

### Technical Stack

| Component | Technology |
|-----------|-----------|
| Language | TypeScript |
| Web Framework | Express |
| Twitter SDK | twitter-api-v2 (v1.16.2) |
| Scheduler | node-cron |
| Database | PostgreSQL (bridge DB) |
| Port | 3002 |

### What It Does

Runs a cron job every minute that:
1. Queries the bridge PostgreSQL database for completed transactions in the last minute
2. Formats a tweet with transaction details
3. Posts via Twitter API v2

### Tweet Format

```
Bridge Tracker
New Transfer Detected: {amount} {network} transferred ({direction})
Time: {utc}
{txLink}
#Bittensor #TAO #DeFi #Blockchain #SN106
```

### Current Features

- `test_mode` toggle for development without posting
- `min_amount` filter to avoid spamming small transactions
- Configurable polling interval
- Express server with health check endpoint
- Direct PostgreSQL connection to bridge database

### Status

Production-ready code. Requires Twitter API keys and bridge DB credentials to be configured.

### Repurposing Potential: HIGH

**Strengths to leverage:**
- Solid cron + DB + Twitter API v2 architecture
- Already connected to bridge transaction data
- Express server can be extended with more endpoints
- TypeScript codebase is maintainable and extensible

**Improvements needed:**
- Add more tweet templates with variety/rotation to avoid repetitive content
- Add engagement metrics tracking (likes, retweets, replies on posted tweets)
- Add reply and quote-tweet capability
- Add support for posting images/video alongside text
- Integrate with n8n for workflow orchestration instead of standalone cron

---

## Tracker (v0idai/Tracker)

### Technical Stack

| Component | Technology |
|-----------|-----------|
| Backend Language | Python |
| Backend Framework | FastAPI |
| Twitter SDK | tweepy (v1.1 API + v2 Client) |
| Frontend | Next.js |
| External API | Taostats API (has API key) |

### What It Does

1. Connects to Taostats API to monitor specific wallet addresses
2. Classifies transfers as inbound/outbound
3. Filters treasury transactions
4. Auto-tweets when new transactions exceed configurable thresholds
5. Frontend dashboard displays transaction data

### Taostats Integration

- Fetches TAO transfers and Alpha transfers
- Classifies transactions by direction (in/out)
- Filters known treasury addresses to reduce noise
- 5-minute cache to avoid API rate limits

### Twitter Integration

- **v1.1 API** (tweepy.API) — for media uploads and legacy endpoints
- **v2 API** (tweepy.Client) — for tweet creation
- Dual-API approach provides maximum flexibility

### Current Features

- Background monitoring tasks (async)
- Tweet history tracking
- Test mode for development
- Transaction classification and filtering
- Next.js dashboard frontend

### Status

More feature-rich than TwiterBot. Includes Taostats API integration, which is a significant asset.

### Repurposing Potential: HIGH

**Strengths to leverage:**
- Taostats API integration is invaluable for pulling real-time blockchain data for marketing content
- FastAPI backend could serve as a data source for n8n workflows
- Dual Twitter API support (v1.1 + v2) enables full range of tweet operations
- Background async tasks pattern is production-ready
- Next.js dashboard provides a UI foundation

**Improvements needed:**
- Expose Taostats data via REST endpoints for n8n consumption
- Add webhook support for real-time event triggers
- Expand tweet templates beyond transaction notifications
- Add multi-platform posting capability (or delegate to Outstand/n8n)

---

## Consolidation Strategy

### Recommended Approach

Rather than maintaining two separate bots, consolidate into a unified architecture:

1. **Keep Tracker's FastAPI backend** as the primary data service
   - It has Taostats API integration (the harder-to-replace piece)
   - FastAPI is better suited for serving data to n8n via REST endpoints
   - Python ecosystem has better ML/NLP libraries for content generation

2. **Absorb TwiterBot's bridge DB monitoring** into the Tracker backend
   - Add a PostgreSQL bridge query module to Tracker
   - Unify all blockchain data sources in one service

3. **Delegate tweet posting to n8n or Outstand**
   - Remove direct Twitter posting from both bots
   - Let n8n handle scheduling, template selection, multi-platform posting
   - Use Outstand API for cross-platform distribution

4. **Resulting architecture:**
   ```
   [Bridge DB] ──> [Tracker/FastAPI] ──> [n8n Workflows] ──> [Outstand/Twitter API]
   [Taostats API] ─┘                         │
                                              ├──> Scheduled content posts
                                              ├──> Transaction alerts
                                              ├──> Engagement monitoring
                                              └──> Multi-platform distribution
   ```

### Data Endpoints to Expose from Tracker

| Endpoint | Data | Consumer |
|----------|------|----------|
| `GET /api/bridge/recent` | Recent bridge transactions | n8n transaction alert workflow |
| `GET /api/taostats/price` | Current TAO price and changes | n8n market update workflow |
| `GET /api/taostats/subnet/106` | SN106 metrics | n8n subnet metrics workflow |
| `GET /api/taostats/delegation` | Delegation stats | n8n staking content workflow |
| `GET /api/metrics/summary` | Aggregated daily/weekly metrics | n8n weekly recap workflow |
