# /generate-thread

Generate a complete X thread from a topic and data points, formatted for the VoidAI content queue.

## Trigger
When the user says: "generate thread", "create thread", "write thread", "/generate-thread"

## Instructions

1. **Load config** (stop if any missing):
   - Read all config files per CLAUDE.md Config Load Order (items 1-8 minimum)
   - Read `companies/{ACTIVE_COMPANY}/brand/voice-learnings.md` (mandatory for content generation)
   - Read `engine/templates/x-thread.md` for the template format

2. **Gather inputs** (ask user if not provided):
   - Topic (required)
   - Key data points or talking points (required)
   - Target pillar: bridge-build, ecosystem-intelligence, alpha-education, or community-culture
   - Account: v0idai (default) or satellite account name
   - Hook variant count: 1-5 (default 3)

3. **Generate the thread:**
   - Write 8-15 tweet parts
   - Part 1: Hook (compelling, under 280 chars, answers "so what")
   - Parts 2-N: Body (data-driven, specific, each under 280 chars)
   - Final part: CTA with relevant links
   - Generate the requested number of hook variants

4. **Compliance check before output:**
   - Zero banned AI phrases (check against CLAUDE.md list)
   - Zero em dashes or double hyphens in content
   - Each part under 280 characters
   - Disclaimer included if discussing financial products ("Not financial advice. DYOR.")
   - No price predictions or guaranteed returns
   - Voice matches the assigned account persona

5. **Output to queue:**
   - Write file to `companies/voidai/queue/drafts/` with filename: `{YYYYMMDD}-thread-{short-id}.md`
   - Use the exact YAML frontmatter format from existing approved threads (read one as reference)
   - Set status: "draft", dry_run: true, compliance_passed: false (will be checked separately)
   - Include all hook variants in an ## Alternate Hooks section
   - Include ## Editor Notes with compliance check results

6. **Notify user:** Show the thread content and confirm it's in drafts. Remind user to run `/queue check <id>` for compliance validation.
