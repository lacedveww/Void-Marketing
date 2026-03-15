# Marketing Tools Research

## Data Sources

### Taostats API

| Field | Details |
|-------|---------|
| Purpose | Comprehensive Bittensor network data |
| SDK | `@taostats/sdk` (npm) |
| API Key | Required — via dash.taostats.io |
| VoidAI Status | **Already has an API key** |

**Available Endpoints:**
- Price data (TAO, subnets)
- Coldkey/hotkey lookups
- Delegation statistics
- Validation and mining data
- Network-wide metrics
- Metagraph data
- Subnet-specific data
- Live chain data feed

**Value for Marketing:**
- Real-time data for automated "market update" tweets
- Subnet 106 metrics for weekly performance posts
- Delegation/staking data for community transparency reports
- Price data for contextual content triggers (e.g., "TAO hits new ATH" posts)

---

## Publishing & Distribution

### X/Twitter API (2026 Pricing)

| Tier | Cost | Post Limit | Read Access | Notes |
|------|------|-----------|-------------|-------|
| Free | $0 | 1,500/mo | No | Write-only, sufficient for basic automation |
| Basic | $200/mo | 15,000/mo | Yes | Can read tweets, monitor mentions |
| Pro | $5,000/mo | 1,000,000/mo | Yes | Enterprise-grade |

**Key Constraints:**
- Free tier **cannot read tweets** — no monitoring, no engagement tracking
- Automation is allowed within rate limits
- Basic tier is the minimum for a proper engagement strategy (need read access for mention monitoring)

**Recommendation:** Start with Free tier for posting automation. Upgrade to Basic ($200/mo) when engagement monitoring and reply automation is needed.

### Outstand API

| Field | Details |
|-------|---------|
| Purpose | Unified multi-platform social publishing |
| Cost | ~$10–30/mo (usage-based) |
| SLA | 99.9% uptime |
| Latency | Sub-200ms |

**Supported Platforms (10+):**
- X/Twitter
- LinkedIn
- Instagram
- TikTok
- YouTube
- Facebook
- Threads
- Bluesky
- Pinterest

**Key Value Proposition:**
- One API call publishes to all channels simultaneously
- Eliminates the need to maintain separate API integrations per platform
- Usage-based pricing keeps costs low at VoidAI's current scale

**Recommendation:** Use Outstand as the distribution layer. All content flows through n8n, which calls Outstand to publish across platforms. This avoids managing 5+ separate API integrations.

### Buffer

| Field | Details |
|-------|---------|
| Cost | $15–30/mo |
| Features | Visual calendar, manual scheduling, analytics |
| API | Available for programmatic control |

**Use Case:** Good for manual scheduling and visual calendar planning, but redundant if using n8n + Outstand for automated workflows.

**Recommendation:** Use Buffer only if the team wants a visual drag-and-drop calendar for manual content planning. Otherwise, n8n handles scheduling programmatically.

---

## Workflow Orchestration

### n8n

| Field | Details |
|-------|---------|
| Cost | Free (self-hosted) |
| Hosting Plan | DGX Spark arriving in ~1 week |
| AI Capabilities | 70+ AI nodes, LangChain integration, conditional logic |

**Key Capabilities:**
- Scheduled content pipelines (cron-based)
- Multi-API data processing and transformation
- Conditional logic (if TAO price > X, post celebration tweet)
- LLM integration for content generation
- Webhook triggers for real-time events
- Database connections (PostgreSQL, Redis)

**Recommended Workflows:**
1. **Daily content pipeline**: Pull data from Taostats, generate tweet, post via Outstand
2. **Bridge transaction alerts**: Webhook from Tracker, format tweet, post to X
3. **Weekly metrics recap**: Aggregate weekly data, generate summary thread, schedule for Monday
4. **Engagement monitoring**: Poll Twitter API for mentions, trigger reply workflows
5. **Multi-platform distribution**: Receive content from any source, adapt format per platform, distribute via Outstand

**Recommendation:** n8n is the central orchestration hub. All automated content flows through n8n workflows. Self-host on the DGX Spark for zero ongoing cost.

---

## AI Agent Frameworks

### Eliza Framework (ai16z)

| Field | Details |
|-------|---------|
| Cost | Free / open-source |
| Language | TypeScript |
| Platforms | Discord, Telegram |
| Special Features | Shared memory, blockchain transaction plugins, Web3-native |

**Capabilities:**
- AI agent framework purpose-built for crypto communities
- Discord and Telegram bot capabilities
- Shared memory across conversations (context retention)
- Blockchain transaction execution via plugins
- Community engagement automation

**Use Case for VoidAI:** Deploy an AI-powered community bot in Discord and/or Telegram that can answer questions about VoidAI products, share real-time metrics, and maintain conversational context.

**Recommendation:** Evaluate for Discord/Telegram community management. Lower priority than X/LinkedIn automation but valuable for community engagement at scale.

---

## Content Creation

### Higgsfield AI

| Field | Details |
|-------|---------|
| Cost | $15–30/mo |
| Focus | Social-first short-form video |

**Features:**
- **Click-to-Ad**: URL to video ad in seconds
- **Cinema Studio**: Full video creation suite
- **Lipsync**: AI-powered lip synchronization
- **Sora 2 Trends Presets**: Trending video format templates

**Use Case for VoidAI:** Generate short-form video content for X, TikTok, and Instagram. Product demos, feature announcements, and trend-riding content.

**Recommendation:** Use for social video content production. Particularly valuable for creating quick announcement videos and product demo clips. The "Click-to-Ad" feature is ideal for turning blog posts or product pages into video content with minimal effort.

### Google Flow

| Field | Details |
|-------|---------|
| Cost | Included with Google AI Pro subscription |
| Video Engine | Veo 3.1 |
| Image Engine | Imagen 4 |
| Direction | Gemini-powered creative direction |

**Use Case for VoidAI:** Higher-quality, more polished video content for product demos, b-roll footage, and presentation materials. Better suited for longer-form content than Higgsfield.

**Recommendation:** Use Google Flow for polished product demos and marketing videos. Use Higgsfield for quick social-first clips. The two tools complement each other — Higgsfield for speed, Google Flow for quality.

---

## Recommended Tool Stack Summary

| Layer | Tool | Cost | Purpose |
|-------|------|------|---------|
| Data | Taostats API | Free (has key) | Blockchain data for content |
| Data | Tracker (existing) | Free (self-hosted) | Bridge + wallet monitoring |
| Orchestration | n8n | Free (self-hosted) | Workflow automation hub |
| Distribution | Outstand API | ~$10–30/mo | Multi-platform publishing |
| Posting | X/Twitter API Free | $0 | Direct tweet posting |
| Video (fast) | Higgsfield AI | $15–30/mo | Social-first short video |
| Video (quality) | Google Flow | Included w/ AI Pro | Polished demos, b-roll |
| Community | Eliza Framework | Free | Discord/Telegram bots |
| **Total** | | **~$25–60/mo** | |

**Note:** If/when engagement monitoring is needed (reading tweets, tracking mentions), the Twitter API Basic tier adds $200/mo. This should be deferred until the posting cadence is established and there is meaningful engagement to monitor.
