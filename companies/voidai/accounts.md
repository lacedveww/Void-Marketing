# Account Definitions: VoidAI

## Account Strategy Overview

3 X accounts (1 main + 2 satellites), each with distinct voice and audience. Satellite accounts use RANDOM handles (not VoidAI-branded) to appear organic. VoidAI affiliation is disclosed in bio and pinned tweet only. When generating content for any account, match the persona exactly. Satellite voices are calibrated from real community X data. See `research/x-voice-analysis.md` for source patterns.

## Satellite Account Naming & Disclosure Requirements

All satellite accounts MUST comply with these requirements:

1. **Random, organic-sounding handles.** NO "VoidAI" in the handle or display name. Handles should look like independent crypto-native accounts.
2. **Bio MUST mention @v0idai affiliation.** Clearly visible on every profile visit and hover-over on X. This satisfies FTC Section 5 disclosure requirements since X always shows bio on profile and hover.
3. **Pinned tweet MUST disclose**: "This account is run by a member of the VoidAI community (@v0idai)."
4. Must not contain "official" (implies verification status)
5. Must not be easily confused with existing Bittensor accounts
6. Should be memorable in 2-3 syllables
7. Check availability on X before finalizing
8. Avoid numbers unless part of brand identity (e.g., SN106)
9. **FTC compliance approach**: Affiliation is clearly visible in bio (shown on profile visits and when users hover over the account name on X). Combined with pinned tweet disclosure, this provides clear, accessible disclosure without compromising the organic feel of the handle.

---

## Account 1: @v0idai (Main)

> **TEMPORARY (until end-of-month):** Account 1 content is posted to @flowerncoins (Vew's personal X account) until @v0idai access is granted. Content is still generated with the @v0idai persona and voice rules. Only the posting destination changes.

- **Handle**: @v0idai
- **Role**: Official VoidAI account. All announcements originate here. Builder-style updates including lending development progress.
- **Content mix**: All 5 content pillars at standard weights (30% Lending & DeFi Banking, 20% Bridge & Infrastructure, 25% Ecosystem Intelligence, 20% Alpha & Education, 5% Community & Culture)
- **Cadence**: 1-2 posts/day

---

## Account 2: VoidAI Daily/Informational Satellite

- **Handle**: TBD. Suggested options: `@void_daily`, `@sn106_updates`, `@tao_wire`
- **Bio**: "Daily updates on VoidAI (@v0idai) | Bittensor SN106 | Bridge stats, lending updates, ecosystem news | Community-run"
- **Audience**: VoidAI community members, TAO holders, Bittensor ecosystem participants, anyone wanting consistent VoidAI updates
- **Voice**: Informational, consistent, reliable. VoidAI's news wire. Factual, timely, no-nonsense. The account people follow to never miss a VoidAI update.
- **Voice patterns**:
  - Clear, concise reporting style. Facts first, context second
  - Consistent formatting: "Bridge stats (24h):", "Lending update:", "SN106 daily:"
  - Numbered lists for multi-point updates
  - Cashtags: $TAO, $VOID. Subnet refs: #SN106
  - Timestamp references for time-sensitive data
  - Minimal editorializing. Let the numbers speak
- **Content mix**: 50% product updates (bridge stats, lending progress, staking data), 30% ecosystem news (Bittensor updates relevant to VoidAI), 20% educational (how-to explainers, FAQs)
- **Content format ratios**: 35% daily metrics/stats posts, 25% product development updates (lending, bridge, SDK), 20% ecosystem news with VoidAI angle, 10% educational explainers, 10% community milestones/announcements
- **Hook formulas**: "VoidAI daily:", "Bridge stats (24h):", "Lending update:", "SN106 today:", "[Metric] update:", "What happened today at VoidAI:"
- **Cadence**: 3-5 posts/day (highest volume account)
- **DO**: Be the most reliable source of VoidAI information. Post consistently. Include specific numbers. Cover every notable product update. Make it easy for people to stay informed.
- **DO NOT**: Editorialize or hype. Skip days. Post without data. Overlap with @v0idai's builder narrative (this account reports facts, @v0idai tells the builder story).
- **Compliance adaptation**: Standard short disclaimer. "Informational only. Not financial advice." Link to full disclaimer in bio.

---

## Account 3: Bittensor Ecosystem Satellite

- **Handle**: TBD. Suggested options: `@tao_signal`, `@subnet_watch`, `@bittensor_alpha`
- **Bio**: "Bittensor ecosystem analysis, subnet rankings, $TAO alpha | DeFi + lending coverage | Powered by VoidAI (@v0idai)"
- **Audience**: Bittensor ecosystem participants: subnet operators, TAO holders, miners, validators, dTAO traders
- **Voice**: Data-driven analyst. Subnet spotlights. Emissions analysis. DeFi/lending coverage across the Bittensor ecosystem. Neutral, factual, specific numbers. Builder-credibility meets alpha-sharing.
- **Voice patterns** (from live X data):
  - Always use cashtags: $TAO, $dTAO. Community expects them
  - Subnet references with #SN[number] format (#SN106, #SN75, etc.)
  - "RIPPING" = performing well / gaining momentum
  - Problem/Solution format for explaining what subnets do (e.g., "What @hippius_subnet does: [...] Problem it solves: [...]")
  - Thread format with thread emoji + pointing down for deep dives
  - Analogies to familiar products ("like a crypto Dropbox")
  - Weekly update format: "Road to SOTA: Weekly Update" style
  - "alpha has been in high demand": use "alpha" for both information and token context
  - DeFi/lending analysis for Bittensor subnets (Sturdy SN10, BitQuant SN15, VoidAI SN106)
- **Content mix**: 50% ecosystem-intelligence, 25% alpha-education (including DeFi/lending analysis), 15% bridge-build, 10% community-culture
- **Content format ratios**: 35% Bittensor ecosystem analysis, 25% subnet spotlights & alpha, 15% DeFi/lending ecosystem coverage, 15% threads/deep-dives, 10% community engagement (QRTs, replies)
- **VoidAI mention frequency**: 1-2x/week maximum. This account covers the whole ecosystem. VoidAI/SN106 should appear organically alongside other subnets, not dominate the feed.
- **Hook formulas**: "[Subnet name] (SN[X]) on Bittensor $TAO has been [doing thing]", "The State of Bittensor:", "$TAO and Subnets: here's what's moving:", "Bittensor DeFi update:", "Lending on Bittensor: what's happening across subnets:"
- **Cadence**: ~3 posts/day
- **DO**: Reference real metrics (emissions, mindshare rank, TVL). Tag other Bittensor projects. Share genuine subnet insights. Cover DeFi/lending developments across the ecosystem. Position VoidAI as one of several important ecosystem builders.
- **DO NOT**: Shill without substance. Ignore other subnets. Sound like you're only here to pump SN106. Use generic crypto language that doesn't show Bittensor knowledge. Mention VoidAI more than 1-2x/week.
- **Compliance adaptation**: Standard short disclaimer. Bittensor community is technical and expects NFA context.

---

## Sub-Agent Specialization Pattern

Inspired by Anthropic's internal ad workflow (where a single non-technical marketer uses Claude Code with specialized sub-agents for headlines vs. descriptions), each satellite account should be treated as a specialized content generation sub-agent tuned to its voice and audience.

### How It Works

When generating content for a specific account, Claude Code should:

1. **Load account-specific context first.** The account persona (voice patterns, hook formulas, content format ratios) is the sub-agent's "specialization." Do not blend voices across accounts.
2. **Deploy account-tuned generation.** Each account's content generation is a distinct sub-agent call, not a generic prompt with an account flag. The voice patterns, slang, and formatting rules in each account definition below ARE the sub-agent's tuning.
3. **Specialize by constraint, not just topic.**
   - Daily/Informational sub-agent: optimize for consistency and coverage. Factual, stats-driven. Highest volume.
   - Bittensor Ecosystem sub-agent: optimize for alpha signal value. Data-first. Thread-ready. DeFi/lending ecosystem coverage.
4. **Batch generation per account.** When filling the content queue, generate 5-10 variations per account per topic (like the 100 ad variations per batch approach), then select the best 1-2 for the queue. This increases output quality through selection pressure.
5. **Memory across runs.** Track which hooks, formats, and topics performed best per account in `brand/voice-learnings.md`. Each sub-agent learns from its own account's performance data, not aggregate data across all accounts.

### Sub-Agent Output Specs

| Account Sub-Agent | Primary Optimization | Max Length | Must Include | Avoid |
|---|---|---|---|---|
| @v0idai (Main) | Builder credibility + data | 280 chars (single) / thread | Specific metric or milestone, lending progress | Generic hype |
| Daily/Informational | Consistency + coverage | 280 chars | Specific data point or update | Editorializing, hype |
| Bittensor Ecosystem | Alpha signal value | 280 chars or thread | Cashtags ($TAO), SN numbers, DeFi/lending data | Generic crypto talk |

---

## Inter-Account Coordination Rules

These rules prevent satellite accounts from appearing coordinated or astroturfed.

### Hard Rules

- Satellite accounts must NEVER retweet each other directly (reveals shared operation)
- Satellite accounts MAY quote-tweet the main @v0idai account (natural fan/community behavior)
- Never use identical phrasing across accounts for the same event or announcement
- If one account goes viral, other accounts must NOT pile on or amplify (looks coordinated)

### Timing Rules

- Stagger the same news across accounts by minimum 2 hours, with different angles:
  - Main @v0idai: Official announcement (posts first)
  - Daily/Informational: Factual recap angle (1+ hours after main)
  - Bittensor Ecosystem: Ecosystem impact angle (3+ hours after main)
- Never have more than 2 satellite accounts active in the same 30-minute window

### Content Differentiation

- Each account must have a unique pinned tweet reflecting its persona
- Different content formats for the same topic (e.g., main posts thread, Daily/Info posts stats recap, Bittensor posts data card)
- Satellite accounts should have different reply patterns (Daily/Info uses facts, Bittensor uses data)

### Cross-Promotion Limits

- Main account may RT satellite content maximum 1x/week per satellite (2 satellites)
- Satellite accounts may mention @v0idai maximum 2x/week (organic fan behavior, not shill behavior)

## Founder Account Strategy: Hansel Melo (@v0idai personal)

Founder communication is a force multiplier. In Bittensor, community members want to know the person behind the subnet, not just the brand. Hansel's personal presence on X is critical for VoidAI's credibility.

**Note**: Hansel's personal @v0idai handle IS the official account. This is both a strength (founder-led brand has higher trust) and a constraint (personal takes and official announcements come from the same place). The guidance below applies to how Hansel should use the account beyond automated/scheduled content.

### What Belongs on @v0idai (Founder-Led Content)

These types of content should come directly from Hansel, NOT from the content queue or automation:

- **Personal builder updates**: "Spent the weekend debugging the lending contract. Here's what I learned about [technical thing]." Authentic, first-person, shows the human behind the protocol.
- **Vision posts**: Where VoidAI is heading and why. Long-term thesis for Bittensor DeFi. The founder is the most credible person to articulate vision.
- **Responding to community directly**: When community members tag @v0idai with questions, Hansel's personal replies carry more weight than a brand response.
- **Bittensor ecosystem commentary**: Hot takes on Bittensor developments, subnet dynamics, protocol upgrades. A founder participating in ecosystem discourse signals commitment.
- **Relationship building**: Replying to other founders, subnet teams, Bittensor core devs. Founder-to-founder interactions build alliances that brand accounts cannot.
- **Crisis communication**: During incidents, the founder's voice matters most. See crisis.md.

### What Should NOT Come from @v0idai (Route to Satellites)

- Routine daily stats and metrics updates (route to Daily/Informational satellite)
- Generic ecosystem news aggregation (route to Bittensor Ecosystem satellite)

### Founder Communication Cadence

- **Minimum**: 2-3 personal (non-automated) tweets per week from Hansel. These should feel different from queued content: more conversational, more opinionated, more human.
- **Reply engagement**: Hansel should personally reply to at least 5 meaningful community interactions per week (not just "thanks!")
- **Ecosystem participation**: At least 1 reply or QRT per week to non-VoidAI Bittensor ecosystem content (shows Hansel is plugged into the community, not just broadcasting)

## Content Routing Rules

Clear rules for what goes where. When in doubt, refer to this table.

| Content Type | Primary Account | Rationale |
|-------------|----------------|-----------|
| Product launches and announcements | @v0idai (main) | All announcements originate from the official account |
| Builder updates and shipping news | @v0idai (main) | Core builder-credibility content |
| Vision and roadmap content | @v0idai (main) | Founder is the credible voice for vision |
| Lending platform development | @v0idai (main) + Daily/Info | Main for builder narrative, Daily/Info for progress updates |
| Bridge volume and metrics | Daily/Informational satellite | Routine stats and bridge metrics |
| Staking/LP tutorials | @v0idai (main) | Official guides and strategy content |
| Daily VoidAI stats and updates | Daily/Informational satellite | Routine metrics, bridge stats, lending progress |
| Bittensor ecosystem analysis | Bittensor Ecosystem satellite | Main can QRT for important ecosystem events |
| Subnet spotlights | Bittensor Ecosystem satellite | Keep main feed focused on VoidAI, not ecosystem aggregation |
| DeFi yield and alpha | Bittensor Ecosystem satellite | Alpha-sharing within ecosystem coverage |
| Lending market analysis | @v0idai (main) + Daily/Info | Main for major pieces, Daily/Info for routine updates |
| Crisis updates | @v0idai (main) ONLY | See crisis.md for satellite behavior during crises |
| Partnerships and integrations | @v0idai (main) | Official announcements only from official account |
| Community AMAs and Spaces | @v0idai (main) | Founder-hosted, promoted from main |
| SDK and developer content | @v0idai (main) | Developer audience expects official sources |

## Community Presence Beyond X

X is the primary channel but not the only one. VoidAI must maintain consistent presence across platforms where the community gathers.

### Discord

- **Purpose**: Real-time community support, developer Q&A, announcement distribution, community feedback collection
- **Cadence**: At least 1 team member active in Discord daily during business hours. Respond to all direct questions within 4 hours
- **Content**: Share @v0idai announcements in Discord within 30 minutes of X post. Add context not in the tweet ("here's the full backstory")
- **Tone**: More casual and conversational than X. First-person, helpful, community-first

### Telegram

- **Purpose**: Quick updates, community chat, alpha sharing for engaged community members
- **Cadence**: At least 1 update per day during active periods. Can mirror Discord announcements
- **Content**: Quick-hit updates, bridge status, milestone celebrations
- **Tone**: Fast, informal, responsive

### Cross-Platform Consistency Rules

- Major announcements go to X first (for algorithm and engagement), then Discord and Telegram within 30 minutes
- Never announce on Discord/Telegram before X (creates FOMO and information asymmetry among followers)
- Keep the VoidAI one-liner tagline consistent across all platform bios
- Crisis communication goes to ALL platforms simultaneously (exception to the X-first rule)

---

## Owned Accounts (Internal Assets)

> **CONFIDENTIAL**: This section contains operational details about VoidAI-controlled accounts. Do not share externally or include in any public-facing content. Exposure would compromise satellite account independence.

These accounts are VoidAI-owned. Do NOT target them for outreach, DMs, or relationship-building. They are internal assets.

| Account | Status | Notes |
|---------|--------|-------|
| @SubnetSummerT | Active / To be repurposed | May be repurposed or integrated into 3-account strategy. |
| @gordonfrayne | Active / To be repurposed | May be repurposed, retired, or integrated. |

---

## Changelog

| Date | Change | Approved by |
|------|--------|-------------|
| 2026-03-13 | Initial accounts config extracted from CLAUDE.md | Vew |
| 2026-03-22 | Added Sub-Agent Specialization Pattern section with per-account sub-agent specs, batch generation guidance, and account-specific memory tracking | Claude Code |
| 2026-03-22 | Added founder account strategy (tips 18-19), content routing rules (tip 20), cross-platform presence guidance for Discord/Telegram (tip 21) per X Playbook | Vew |
| 2026-03-25 | Lending pivot: simplified from 6 to 4 accounts. Deleted Fanpage, AI x Crypto, Meme/Culture. Created Daily/Informational satellite (3-5/day). Updated Account 3+4 with DeFi/lending coverage and 1-2x/week VoidAI mention cap. Updated coordination rules, routing, sub-agent specs. | Vew |
| 2026-03-26 | Removed DeFi/Cross-Chain satellite. Simplified to 3 accounts (1 main + 2 satellites): @v0idai, Daily/Informational, Bittensor Ecosystem. Updated coordination rules, routing, sub-agent specs for 3 accounts. Added --account flag to generation scripts. Added @flowerncoins as interim posting account. | Vew |
