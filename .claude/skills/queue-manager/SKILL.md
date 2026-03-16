# Queue Manager

Content staging queue for the universal marketing engine. Manages the full content lifecycle: `draft -> review -> approved -> scheduled -> posted` with compliance checks and cadence enforcement.

## Activation

Activated by any `/queue` command. This skill manages content items stored as markdown files with YAML frontmatter in `companies/{ACTIVE_COMPANY}/queue/`. Read `ACTIVE_COMPANY` from `CLAUDE.md` line 7.

## Before Any Operation

1. Read `CLAUDE.md`:universal rules, routing, active company
2. Read `companies/{ACTIVE_COMPANY}/voice.md`:brand voice rules
3. Read `companies/{ACTIVE_COMPANY}/compliance.md`:compliance rules (references engine modules)
4. Read `companies/{ACTIVE_COMPANY}/brand/voice-learnings.md`:latest performance data
5. Read `engine/compliance/base-rules.md`:universal compliance (FTC, banned phrases, quality gate)

## Directory Layout

```
companies/{ACTIVE_COMPANY}/queue/
  manifest.json           # Derived index, regenerated on every operation
  drafts/                 # AI-generated, not yet reviewed
  review/                 # Queued for human review
  approved/               # Approved, awaiting scheduling
  scheduled/              # Scheduled with specific post time
  posted/                 # Successfully posted (30-day retention)
  rejected/               # Rejected with feedback (can rework -> drafts/)
  failed/                 # Posting failed (API error, rate limit)
  cancelled/              # Manually cancelled

engine/templates/         # Pre-approved content templates (universal)
```

## Content Item Format

Each item is a `.md` file in the appropriate status subdirectory.

**Filename pattern:** `{YYYYMMDD}-{HHMMSS}-{platform}-{account}-{slug}.md`

Example: `20260315-143000-x-main-bridge-update.md`

The `id` field in frontmatter matches the filename without `.md`.

## Available Templates

| Template | File | Content Type | Tool | Best For |
|----------|------|:------------:|------|----------|
| X single post | `x-single.md` | single | N/A | Quick tweets, metrics drops, engagement |
| X thread | `x-thread.md` | thread | N/A | Deep-dives, tutorials, weekly recaps |
| X reply | `x-reply.md` | reply | N/A | Engagement replies, community interaction |
| X quote tweet | `x-quote-tweet.md` | quote_tweet | N/A | Commentary on other posts, amplification |
| LinkedIn post | `linkedin-post.md` | article | N/A | Professional updates, ecosystem positioning |
| Discord announcement | `discord-announcement.md` | announcement | N/A | Community announcements, launches |
| Blog post | `blog-post.md` | article | N/A | Pillar content, SEO, tutorials |
| Podcast brief | `podcast-notebooklm.md` | podcast | NotebookLM | Audio content from source documents |
| Video script | `video-script.md` | video | Higgsfield/Loom/Screen Studio/Canva | Scripted video content |
| Video (AI gen) | `video-google-veo.md` | video | Google Flow / Veo | AI-generated video clips |
| Social graphic | `image-social-graphic.md` | image | Nano Banana Pro | Post images, banners, memes, event graphics |
| Content hero image | `image-content-hero.md` | image | Nano Banana Pro (Pro model) | Blog headers, OG images, thumbnails |
| Infographic | `infographic.md` | infographic | Canva/Figma | Data viz, comparisons, process diagrams |
| Data card | `data-card.md` | data-card | Canva/Figma/n8n | Metrics snapshots, weekly recaps |
| Slide deck | `slide-deck.md` | slide-deck | Canva/Figma/Google Slides | Carousels, presentations, pitch decks |

**Template selection logic for `/queue add`:**
- Match by `--type` first, then by `--platform` if multiple templates exist for the same type
- Image types: use `image-social-graphic.md` for social posts, `image-content-hero.md` for blog/content assets
- Video types: use `video-google-veo.md` for AI-generated clips, `video-script.md` for scripted/recorded video

**Generated assets** (images, videos) are saved to `companies/{ACTIVE_COMPANY}/queue/assets/` and referenced from the content item.

## Commands

### `/queue add`

Create a new content item in `drafts/`.

**Usage:** `/queue add --platform <platform> --account <account> --pillar <pillar> [--type <content_type>] [--source <workflow>] [--priority <1-10>]`

**Parameters:**
- `--platform` (required): `x` | `linkedin` | `discord` | `telegram` | `blog` | `podcast` | `youtube`
- `--account` (required): Read valid accounts from `companies/{ACTIVE_COMPANY}/accounts.md`
- `--pillar` (required): Read valid pillars from `companies/{ACTIVE_COMPANY}/pillars.md`
- `--type` (optional, default `single`): `single` | `thread` | `reply` | `quote_tweet` | `meme` | `article` | `announcement` | `podcast` | `video` | `infographic` | `data-card` | `slide-deck` | `image`
- `--source` (optional, default `manual`): `daily-metrics` | `bridge-alerts` | `weekly-recap` | `news-monitor` | `blog-distribution` | `competitor-monitor` | `manual`
- `--priority` (optional, default `5`): 1=highest, 10=lowest

**Behavior:**
1. Load the appropriate template from `engine/templates/` based on platform and content_type
2. Generate the content following brand voice rules from `companies/{ACTIVE_COMPANY}/voice.md` and `companies/{ACTIVE_COMPANY}/brand/voice-learnings.md`
3. Prompt the user to provide or confirm the content body
4. Generate the filename using current UTC timestamp + platform + account + slug derived from content
5. Auto-run the compliance check sequence (see Compliance Checks below)
6. Save the file to `companies/{ACTIVE_COMPANY}/queue/drafts/`
7. **Auto-advance to review**: Immediately move the file to `companies/{ACTIVE_COMPANY}/queue/review/`, update status frontmatter
8. Regenerate `manifest.json`
9. **Auto-present review card**: Display the full in-chat review card (see `/queue review` format) and prompt the reviewer to approve or reject inline. Do NOT leave items sitting in `drafts/`:every generated draft flows straight into the review card for immediate decision.

**CRITICAL:Auto-Review Rule:** Any time content is generated or drafted (whether via `/queue add`, batch generation, or any other content creation workflow), the draft MUST be immediately presented as an in-chat review card for the reviewer's approval. Never silently save drafts without presenting them for review. This applies to ALL content generation, not just `/queue add`.

### `/queue list`

List content items with optional filters.

**Usage:** `/queue list [--status <status>] [--account <account>] [--platform <platform>] [--pillar <pillar>] [--priority <max>]`

**Behavior:**
1. Read `manifest.json` for fast lookup
2. Apply filters
3. Display table: ID | Status | Platform | Account | Pillar | Priority | Compliance | Created

### `/queue review`

Present items pending review as rich in-chat cards for inline approval.

**Usage:** `/queue review [--account <account>]`

**Behavior:**
1. List all items in `companies/{ACTIVE_COMPANY}/queue/review/`
2. For each item, read the full file and render an **in-chat review card** using this format:

```
### Queue Review: `{id}`

| Field | Value |
|-------|-------|
| **Platform** | {platform} ({content_type}) |
| **Account** | @{account} |
| **Pillar** | {pillar_display_name} ({target}% target) |
| **Chars** | {character_count} / {limit} |
| **Compliance** | {pass/fail summary} |
| **Review Tier** | Tier {review_tier} |
| **Red Flags** | {red_flags or "None"} |
| **Dry Run** | {Yes/No} |

**Content:**
{full content body in a code block, formatted for readability}

**Approve or reject?**
```

3. After displaying the card, wait for the user's response:
   - "approve" / "approved" / "yes" / "lgtm" / "ship it" → run `/queue approve` flow
   - "reject" / "no" / "nah" + reason → run `/queue reject` flow with the stated reason
   - "skip" / "next" → show next item
   - "edit: [feedback]" → note the feedback, send back to drafts for rework
4. If multiple items are pending, show them one at a time in sequence
5. After all items reviewed, show summary: X approved, Y rejected, Z skipped

### `/queue approve`

Approve a content item.

**Usage:** `/queue approve <id> [--notes "..."]`

**Behavior:**
1. Find the file by ID (search across all status directories)
2. Verify item is in `review/` status
3. Update frontmatter: `status: "approved"`, `previous_status: "review"`, `reviewed_by: "{reviewer}"`, `reviewed_at: <now>`, `review_notes: <notes>`
4. Move file from `companies/{ACTIVE_COMPANY}/queue/review/` to `companies/{ACTIVE_COMPANY}/queue/approved/`
5. Regenerate `manifest.json`

### `/queue reject`

Reject a content item with feedback.

**Usage:** `/queue reject <id> --reason "..."`

**Behavior:**
1. Find the file by ID
2. Update frontmatter: `status: "rejected"`, `previous_status: "review"`, `rejection_reason: <reason>`, `reviewed_by: "{reviewer}"`, `reviewed_at: <now>`
3. Move file from `companies/{ACTIVE_COMPANY}/queue/review/` to `companies/{ACTIVE_COMPANY}/queue/rejected/`
4. Regenerate `manifest.json`
5. Display: "Item rejected. To rework, use `/queue move <id> drafts` to send back to drafts."

### `/queue schedule`

Schedule an approved item for posting.

**Usage:** `/queue schedule <id> --at "ISO8601" [--earliest "ISO8601"] [--latest "ISO8601"]`

**Behavior:**
1. Find the file by ID
2. Verify item is in `approved/` status
3. Run cadence validation (see Cadence Rules below)
4. If cadence check fails, display conflicts and ask user to confirm or pick a different time
5. Update frontmatter: `status: "scheduled"`, `previous_status: "approved"`, `scheduled_post_at: <time>`, `earliest_post_at`, `latest_post_at`
6. Move file to `companies/{ACTIVE_COMPANY}/queue/scheduled/`
7. Regenerate `manifest.json`

### `/queue schedule-day`

Auto-schedule all approved items for a given date, respecting cadence rules.

**Usage:** `/queue schedule-day <YYYY-MM-DD> [--account <account>]`

**Behavior:**
1. List all items in `companies/{ACTIVE_COMPANY}/queue/approved/` (optionally filtered by account)
2. Sort by priority (1=first)
3. For each item, find the next available time slot on the given date that respects:
   - Account-specific peak windows (from `companies/{ACTIVE_COMPANY}/cadence.md`)
   - Minimum gap between posts for the same account
   - Inter-account stagger rules
   - Weekend limits (max 1/day per account on weekends)
   - Max 6 posts/day per account
4. Display proposed schedule and ask for confirmation
5. On confirm, schedule each item via the same logic as `/queue schedule`

### `/queue calendar`

Show the posting schedule across all accounts.

**Usage:** `/queue calendar [--days <N>]` (default: 7 days)

**Behavior:**
1. Read all items in `companies/{ACTIVE_COMPANY}/queue/scheduled/`
2. Display a day-by-day, hour-by-hour grid showing:
   - Scheduled items per account per day
   - Gap analysis (flags gaps violating minimum spacing)
   - Daily post counts per account
   - Pillar distribution for the period
3. Highlight any cadence violations in the schedule
4. Show empty slots where content could be added

### `/queue check`

Run compliance pre-checks on a specific item.

**Usage:** `/queue check <id>`

**Behavior:**
1. Find the file by ID
2. Run the full compliance check sequence (see below)
3. Update the compliance fields in frontmatter
4. Display detailed results

### `/queue batch-approve`

Approve all items from a specific source workflow.

**Usage:** `/queue batch-approve --workflow <workflow> [--max <N>]`

**Behavior:**
1. Find all items in `companies/{ACTIVE_COMPANY}/queue/review/` with matching `source_workflow`
2. **EXCLUDE all Tier 1 items**:Tier 1 content (mandatory human review) must ALWAYS be individually reviewed via `/queue review`. Batch approval is for Tier 2/3 only. If Tier 1 items are found, display a warning listing them and skip.
3. Verify all remaining have `compliance_passed: true`
4. Display list and ask for confirmation
5. On confirm, approve each item (same as `/queue approve`)
6. Items with `compliance_passed: false` are skipped with a warning

### `/queue move`

Manually change an item's status.

**Usage:** `/queue move <id> <target_status>`

**Valid transitions:**
- `drafts` -> `review`
- `review` -> `approved` | `rejected` | `drafts`
- `approved` -> `scheduled` | `drafts`
- `scheduled` -> `approved` | `cancelled`
- `rejected` -> `drafts`
- `failed` -> `drafts` | `scheduled`
- Any -> `cancelled`

**Compliance field reset:** When any item moves BACK to `drafts` (from `review`, `approved`, `rejected`, or `failed`), ALL compliance fields must be cleared/reset so the 6-step compliance pipeline re-runs on the revised content. Reset these fields: `compliance_passed`, `compliance_checked_at`, `disclaimer_present`, `prohibited_terms_check`, `cadence_check`, `pillar_check`, `review_tier`, `red_flags`. This ensures reworked content gets fresh compliance validation.

**Behavior:**
1. Find the file by ID
2. Validate the transition is allowed
3. Update frontmatter: `status`, `previous_status`, `updated_at`
4. Move file to the target subdirectory
5. Regenerate `manifest.json`

### `/queue stats`

Show queue statistics.

**Usage:** `/queue stats [--account <account>]`

**Behavior:**
1. Read `manifest.json`
2. Display:
   - Counts by status
   - Pillar distribution vs. targets (flag if >5% drift)
   - Posts per account (today, this week, all-time)
   - Average time in each status
   - Compliance pass/fail rates
   - Items by source workflow

### `/queue rebuild`

Regenerate manifest from files.

**Usage:** `/queue rebuild`

**Behavior:**
1. Scan all subdirectories for `.md` files (skip `.gitkeep`)
2. Parse YAML frontmatter from each file
3. Rebuild `manifest.json` with fresh counts, pillar distribution, and item index
4. Report any inconsistencies found (file in wrong directory vs. its status field, etc.)

### `/queue stagger`

Create a coordinated multi-account posting group.

**Usage:** `/queue stagger <group-name> --items <id1,id2,...>`

**Behavior:**
1. Find all specified items
2. Verify they cover different accounts
3. Set `stagger_group: <group-name>` on each item
4. Auto-assign `stagger_order` based on `companies/{ACTIVE_COMPANY}/accounts.md` inter-account coordination rules (main account first, satellites follow with increasing delays per their defined stagger timing)
5. If any items are already scheduled, validate timing meets stagger requirements
6. Regenerate `manifest.json`

### `/queue cleanup`

Remove posted items older than 30 days.

**Usage:** `/queue cleanup [--dry-run]`

**Behavior:**
1. Scan `companies/{ACTIVE_COMPANY}/queue/posted/` for items where `posted_at` is >30 days ago
2. Display list of items to remove
3. If `--dry-run`, just show the list
4. Otherwise, ask for confirmation, then delete the files
5. Regenerate `manifest.json`

### `/queue export-batch`

Export items as JSON for Notion import.

**Usage:** `/queue export-batch --status <status> [--output <filepath>]`

**Behavior:**
1. Find all items with the specified status
2. Convert each item's YAML frontmatter to a flat JSON object (all keys map 1:1 to Notion database properties)
3. Content body maps to a `content` text field
4. Write JSON array to output file (default: `companies/{ACTIVE_COMPANY}/queue/export-{status}-{timestamp}.json`)
5. Display count and output path

## Compliance Check Sequence

Runs automatically on `/queue add` and `/queue check`. Reads rules from `companies/{ACTIVE_COMPANY}/compliance.md`, `engine/compliance/base-rules.md`, and loaded engine compliance modules.

### Step 1: Category A Word Scan

Scan content body for absolute prohibitions (case-insensitive, including common misspellings and l33tspeak):

**Blocked terms** (content MUST be rewritten if found):
- "guaranteed returns", "risk-free", "no risk", "safe investment", "secure investment"
- "get rich", "financial freedom", "passive income", "to the moon", "100x"
- "SEC-approved", "SEC-registered", "CFTC-approved", "government-backed", "FDIC-insured"
- "investment" (when describing token purchase/staking/protocol participation)
- "earn" (when describing staking/lending:substitute: "receive" or "be allocated")
- "yield" (without "variable" qualifier:substitute: "variable rate rewards")
- "profit" (describing protocol participation:substitute: "network-generated rewards")
- "high APY" (without specific rate and disclaimer)
- "allocation" (in context of token rewards or airdrops:implies securities distribution)
- "airdrop" (as incentive for user actions:SEC enforcement precedent)

**Result:** If ANY Category A term found → `prohibited_language: "fail"`, `compliance_passed: false`. Content is blocked and must be rewritten.

### Step 2: Category B Word Scan

Scan for context-dependent review triggers:

- "APY" / "APR":OK if reporting current rate with disclaimer, NOT OK if celebratory
- "TVL":OK if factual reporting, NOT OK if celebratory
- "alpha":OK for ecosystem analysis, NOT OK if implying insider info
- "yield farming": OK if educational, NOT OK if promotional for company products
- "stake" / "staking":OK if educational, NOT OK if promotional
- "rewards":OK if "variable rewards" with context, NOT OK if "huge rewards"
- "opportunity":OK if generic, NOT OK if financial
- "bullish" / "bearish":OK for market commentary, NOT OK for price predictions
- "undervalued", "gem", "hidden gem":NEVER OK for VOID token

**Result:** Each found term recorded in `red_flags_found[]` with the matched term and surrounding context. Human review needed for context judgment.

### Step 3: Category C:Competitor Name Scan

Scan for competitor names listed in `companies/{ACTIVE_COMPANY}/competitors.md`. Flag any named competitor, bridge, lending protocol, or similar project.

**Result:** If ANY competitor name found → automatically `review_tier: 1`.

### Step 4: Disclaimer Verification

Check that the appropriate disclaimer is present based on platform AND account. Read disclaimer templates from `companies/{ACTIVE_COMPANY}/compliance.md` (Required Disclaimers section). Each account may have different acceptable disclaimer formats defined in compliance.md.

**Matching rules:**
- Match is case-insensitive
- Match checks if any acceptable variant is a substring of the content body (not exact string match)
- For satellite accounts, accept BOTH the account-specific short form AND the main account's standard disclaimer
- For video/podcast, check that disclaimer text appears in the script body or description field
- For threads, disclaimer must appear in the final tweet

**Result:** `disclaimer_included: true/false`

### Step 5: Howey Test Risk Scoring

Score content against the 4 Howey prongs:

1. **Investment of money**:Does the content use "invest", "deposit", "put in"? (+1 risk)
2. **Common enterprise**:Does it emphasize pooled funds, shared outcomes, or community investment? (+1 risk)
3. **Expectation of profit**:Does it mention returns, yields, APY, earning, profit? (+1 risk)
4. **Efforts of others**:Does it reference team efforts driving returns, "our team", "we work for you"? (+1 risk)

**Scoring:**
- 0 prongs triggered → `howey_risk: "none"`
- 1 prong triggered → `howey_risk: "low"`
- 2 prongs triggered → `howey_risk: "medium"`, auto-escalate to Tier 1
- 3-4 prongs triggered → `howey_risk: "high"`, `compliance_passed: false`, must rewrite

### Step 6: Review Tier Assignment

Assign review tier per `engine/frameworks/review-tier-system.md` and `companies/{ACTIVE_COMPANY}/compliance.md`:

**Tier 1 triggers** (mandatory human review):
- Content mentions: returns, yields, rates, APY, rewards, staking rewards, lending rates
- Content mentions: lending platform, borrow, collateral, liquidation
- Content mentions: token value/price, VOID price, TAO price, market cap, trading volume
- Content mentions: TVL, bridge volume milestones, growth metrics
- Content involves: influencer partnerships, paid collaborations, sponsored posts
- Content involves: ambassador program, community rewards, testnet incentives
- Content involves: smart contract audit status, security claims
- Content mentions: competitor projects by name
- Content involves: legal/regulatory statements
- All blog posts and long-form content
- All content for first 30 days of any new satellite account
- Any red flags from Category B or C

**Tier 2** (auto-queue, 20% spot-check):
- Educational content about company products (no financial claims)
- Technical deep-dives on Bittensor/bridging architecture
- Ecosystem news commentary (factual, no price implications)
- Retweets/QTs with factual commentary only

**Tier 3** (auto-post allowed):
- Memes with NO financial claims, NO token mentions
- Community engagement: polls, "gm", community milestones
- Automated bridge status posts (raw data only)

**Result:** Set `review_tier`, `risk_level`, and `requires_approval` accordingly.

### Compliance Check Output

After all steps, update the item's frontmatter with:
- `compliance_passed`: true only if no Category A violations AND howey_risk != "high"
- `prohibited_language`: "pass" | "fail"
- `disclaimer_included`: true | false
- `review_tier`: 1 | 2 | 3
- `risk_level`: "low" | "medium" | "high"
- `howey_risk`: "none" | "low" | "medium" | "high"
- `red_flags_found`: array of flagged terms with context
- `compliance_checked_at`: ISO 8601 timestamp

Display a summary table showing each check step and its result.

## Cadence Rules

Enforced on `/queue schedule` and `/queue schedule-day`. Read account-specific cadence from `companies/{ACTIVE_COMPANY}/cadence.md`.

### Per-Account Limits

Read from `companies/{ACTIVE_COMPANY}/cadence.md`. Each account defines: max posts/day, minimum gap, peak windows (UTC), and weekend limits.

### Inter-Account Stagger Rules

When multiple accounts cover the same news (same `stagger_group`), read stagger timing from `companies/{ACTIVE_COMPANY}/accounts.md` (Inter-Account Coordination section). General rules:

- Main account posts first, satellites follow with increasing delays
- Never have all satellite accounts active in the same 30-minute window
- Never use identical phrasing across accounts for the same event
- Satellite accounts NEVER retweet each other directly

### Cadence Validation

When scheduling, check:
1. Same account doesn't exceed max posts/day
2. Minimum gap from nearest existing post on same account is met
3. If stagger_group is set, inter-account timing is enforced
4. Weekend limits are respected (Saturday/Sunday)
5. Post falls within a peak window (warn if outside, don't block)

## Manifest Regeneration

`manifest.json` is rebuilt from files on every queue operation. It is never the source of truth:files are.

**Regeneration process:**
1. Scan all status subdirectories for `.md` files
2. Parse YAML frontmatter from each file
3. Build counts per status
4. Calculate pillar distribution from all non-posted/cancelled items
5. Build items array with: id, status, platform, account, pillar, priority, compliance_passed, review_tier, created_at, scheduled_post_at
6. Write `manifest.json` with version, last_updated, dry_run_mode, counts, pillar_distribution, items

## Pillar Distribution Monitoring

Read target distribution from `companies/{ACTIVE_COMPANY}/pillars.md`. Each pillar defines a target weight percentage.

Calculated from all items in drafts + review + approved + scheduled (excludes posted/rejected/failed/cancelled).

**Warning threshold:** If any pillar drifts >5 percentage points from its target, display a warning on `/queue add`, `/queue stats`, and `/queue calendar`.

## n8n Integration

### n8n Writes to Queue

n8n workflows (1-6) write `.md` files directly to `companies/{ACTIVE_COMPANY}/queue/drafts/` with:
- `source_workflow` set to the workflow name
- `generated_by: "n8n"`
- Frontmatter following the exact schema above
- Compliance fields left as unchecked (Claude runs checks when item enters review)

### n8n Reads from Queue

A posting workflow polls `companies/{ACTIVE_COMPANY}/queue/scheduled/` on cron:
- Reads items where `scheduled_post_at <= NOW()`
- Posts content via platform API
- On success: moves file to `companies/{ACTIVE_COMPANY}/queue/posted/`, sets `posted_at`, `post_id`
- On failure: moves file to `companies/{ACTIVE_COMPANY}/queue/failed/`, sets `failure_reason`
- When `dry_run: true`: logs output, moves to `posted/` with `post_id: "DRY_RUN"`

## Notion Migration Path

All YAML frontmatter keys map 1:1 to Notion database properties:
- `status`, `platform`, `account`, `content_type`, `pillar`, `source_workflow`, `generated_by` → Select
- `created_at`, `updated_at`, `scheduled_post_at`, `posted_at`, `reviewed_at`, `compliance_checked_at` → Date
- `compliance_passed`, `disclaimer_included`, `has_media`, `requires_approval`, `dry_run` → Checkbox
- `priority`, `character_count`, `thread_count`, `stagger_order` → Number
- `review_tier` → Number
- `risk_level`, `howey_risk`, `prohibited_language` → Select
- `id`, `reviewed_by`, `review_notes`, `rejection_reason`, `post_id`, `failure_reason`, `stagger_group` → Text
- `red_flags_found` → Multi-select
- Content body → Rich Text (page body)

Use `/queue export-batch` to generate JSON for Notion API import. After migration, n8n switches to Notion API and local company queue directory gets deleted.

## Error Handling

- If a file is found in the wrong directory vs. its `status` field, `/queue rebuild` fixes the inconsistency (moves file to correct directory and logs the correction)
- If `manifest.json` is missing or corrupted, any command auto-triggers `/queue rebuild`
- If a compliance check fails to parse content, set all compliance fields to their most restrictive values and flag for manual review
