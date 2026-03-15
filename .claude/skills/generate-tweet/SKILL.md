# /generate-tweet

Generate a single tweet for VoidAI, formatted for the content queue.

## Trigger
When the user says: "generate tweet", "write tweet", "create tweet", "/generate-tweet"

## Instructions

1. **Load config:**
   - Read `CLAUDE.md` for banned phrases, formatting rules
   - Read `companies/voidai/voice.md` for voice registers
   - Read `companies/voidai/accounts.md` for account personas
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
