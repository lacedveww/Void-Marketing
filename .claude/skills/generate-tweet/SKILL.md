# /generate-tweet

Generate a single tweet for VoidAI, formatted for the content queue.

## Trigger
When the user says: "generate tweet", "write tweet", "create tweet", "/generate-tweet"

## Instructions

1. **Load config** (stop if any missing):
   - Read all config files per CLAUDE.md Config Load Order (items 1-8 minimum)
   - Read `companies/{ACTIVE_COMPANY}/brand/voice-learnings.md` (mandatory for content generation)
   - Read `engine/templates/x-single.md` for template format

2. **Gather inputs** (ask if not provided):
   - Topic or angle (required)
   - Account: v0idai (default), or satellite name (fanpage, bittensor-ecosystem, defi-crosschain, ai-crypto, meme-culture)
   - Pillar: bridge-build, ecosystem-intelligence, alpha-education, community-culture
   - Include media: yes/no

3. **Generate the tweet:**
   - Under 280 characters (hard limit)
   - Match voice register for the target account
   - Main account (@v0idai): builder-credible, data-driven, direct
   - Satellites: match their persona from accounts.md
   - Must answer "so what" for the reader
   - Include specific data or actionable insight where possible

4. **Compliance check:**
   - Zero banned AI phrases
   - Zero em dashes or double hyphens
   - Under 280 characters (count and confirm)
   - Disclaimer if financial content

5. **Output:**
   - Write to `companies/voidai/queue/drafts/{YYYYMMDD}-tweet-{short-id}.md`
   - Exact YAML frontmatter format from existing approved tweets
   - Set status: "draft", dry_run: true
   - Remind user to run `/queue check <id>` for compliance validation
