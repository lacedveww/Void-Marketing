# /weekly-report

Generate a weekly metrics recap thread for VoidAI.

## Trigger
When the user says: "weekly report", "weekly recap", "generate weekly thread", "/weekly-report"

## Instructions

1. **Load config** (stop if any missing):
   - Read all config files per CLAUDE.md Config Load Order (items 1-8 minimum)
   - Read `companies/{ACTIVE_COMPANY}/brand/voice-learnings.md` (mandatory for content generation)
   - Read `engine/templates/x-thread.md` for thread format

2. **Gather metrics** (ask user for data, or fetch if MCP tools available):
   - Bridge volume (7-day)
   - TAO price (current + weekly change)
   - SN106 metrics (emissions rank, alpha price, TVL)
   - X followers (current + weekly change)
   - Top-performing content this week
   - GitHub commits (if available)
   - Any notable events or milestones

3. **Generate 8-10 tweet thread:**
   - Part 1: Hook with headline metric ("$X bridged this week via VoidAI. Here's the full recap.")
   - Parts 2-4: Key metrics with week-over-week comparisons
   - Parts 5-7: Highlights (top content, community milestones, ecosystem news)
   - Part 8-9: What's coming next week
   - Part 10: CTA (follow, join Discord, try the bridge)

4. **Data freshness requirement:**
   - Every number must be current (fetched this session or provided by user)
   - Add "as of [date]" to any metric that might change
   - Never use placeholder or estimated data without flagging it

5. **Compliance checks (all must pass):**
   - Zero banned AI phrases (full list in CLAUDE.md)
   - Zero em dashes or double hyphens ( -- )
   - Each part under 280 characters
   - Appropriate disclaimer included per compliance.md
   - No price predictions or guaranteed returns
   - Voice matches assigned account register per voice.md

6. **Output:**
   - Write to `companies/voidai/queue/drafts/{YYYYMMDD}-weekly-recap.md`
   - Tag with pillar: ecosystem-intelligence
   - Set review_tier: 1 (always requires human review)
   - Remind user to run `/queue check <id>` for compliance validation
