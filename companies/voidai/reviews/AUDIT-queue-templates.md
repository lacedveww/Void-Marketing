# Queue & Templates Audit Report

**Auditor:** Code Reviewer (Claude)
**Date:** 2026-03-13
**Scope:** Queue manager skill, 13 templates, manifest schema, directory structure, compliance cross-reference

---

## CRITICAL BUGS

### 1. Template `status` field uses "draft" instead of "drafts"

All 13 templates set `status: "draft"` (singular), but the queue manager skill, the directory layout, and all `/queue move` transitions reference the status as `"drafts"` (plural). The `drafts/` directory is plural. The manifest counts key is `"drafts"`. The valid transition table lists `"drafts"` everywhere.

This means if `/queue add` instantiates from a template and preserves the template's `status: "draft"` value, then `/queue rebuild` will find a mismatch between the file's status field (`"draft"`) and its directory (`drafts/`). The rebuild logic will attempt to "fix" this inconsistency and potentially misroute the file or log a false error.

**Files affected:** All 13 templates.

**Fix:** Change `status: "draft"` to `status: "drafts"` in every template, OR explicitly document in the queue manager SKILL.md that `/queue add` must overwrite the template's status field with `"drafts"` upon instantiation (and ensure this happens reliably). The cleaner fix is to correct the templates:

```yaml
# Before (all templates)
status: "draft"

# After
status: "drafts"
```

### 2. X character count limit stated as 280 is incorrect for most accounts

The `x-single.md` template states "max 280 characters for X single post". As of 2025, X/Twitter allows up to 4,000 characters for verified accounts (X Premium). Since VoidAI will be operating brand accounts that may have Premium, the hard 280 limit is potentially wrong and will cause the compliance check to reject valid content.

More importantly, the disclaimer text alone ("Not financial advice. Digital assets are volatile and carry risk of loss. DYOR.") consumes 68 characters. That leaves only 212 characters for actual content in a 280-char limit, which is extremely restrictive and may explain why the test post was marked at 198 chars (fitting exactly within this constraint).

**Fix:** The queue manager should define platform character limits explicitly (not just in template placeholder text) and differentiate between verified/unverified accounts. Add a `character_limit` field to each template's frontmatter:

```yaml
character_limit: 280  # Override to 4000 if using X Premium
```

### 3. Manifest `pillar_distribution` excludes rejected items but SKILL.md says it should

The SKILL.md states pillar distribution is "Calculated from all items in drafts + review + approved + scheduled (excludes posted/rejected/failed/cancelled)." However, the manifest currently shows 0% across all pillars despite having 1 rejected item in `bridge-build`. This is correct per the spec. BUT the rejected item should be excluded from the distribution calculation per spec, so the current 0% is correct. No bug here after careful re-reading -- the spec and manifest agree. However, the manifest `items` array includes the rejected item, which means item indexing is not filtered by the same logic. This is inconsistent: the items array includes all items regardless of status, but pillar_distribution only counts active items. This should be explicitly documented.

**Downgraded to Warning -- see Warnings section.**

### 4. Missing `character_limit` enforcement field

The queue manager compliance check references `character_count` and the review card displays `{character_count} / {limit}`, but there is no `character_limit` field anywhere in the templates or the manifest schema. The review card template in SKILL.md line 125 shows `| **Chars** | {character_count} / {limit} |` but `{limit}` has no source field.

**Fix:** Add `character_limit` to each template's frontmatter with platform-appropriate defaults:

| Template | Limit |
|----------|-------|
| x-single | 280 (or 4000 for Premium) |
| x-thread | 280 per part (or 4000) |
| linkedin-post | 3000 |
| discord-announcement | 2000 |
| blog-post | N/A (no hard limit) |

And add `character_limit` to the manifest schema item properties.

---

## WARNINGS

### 1. `content-review-rules.md` prohibits "My play today:" format, but DeFi satellite persona uses it

CLAUDE.md DeFi Community Account 3 voice patterns include: `"My play today:" -- personal actionable format (builds trust through transparency)`. But `compliance/content-review-rules.md` Section 2 explicitly lists `"My play today:" or any personal-position format` under X/Twitter Prohibited content.

This is a direct contradiction between two authoritative documents. Per the file priority hierarchy, CLAUDE.md takes precedence, but the content-review-rules doc explicitly prohibits this format. The queue manager's compliance check reads both files (SKILL.md step: "Read compliance/content-review-rules.md"), so depending on which rule the AI agent follows, this format will either pass or fail compliance.

**Fix:** Resolve the contradiction. Either:
- Remove "My play today:" from the DeFi persona in CLAUDE.md, OR
- Add an exception in content-review-rules.md: "My play today: format is allowed ONLY for the DeFi satellite account and only for non-VoidAI-product commentary"

### 2. LinkedIn template hardcodes `account: "v0idai"` but queue manager allows all 4 accounts

The `linkedin-post.md`, `discord-announcement.md`, `blog-post.md`, `podcast-notebooklm.md`, `video-script.md`, `video-google-veo.md`, `infographic.md`, and `slide-deck.md` templates all hardcode `account: "v0idai"`. If content is generated for a satellite account on LinkedIn or as a blog post, the template will have the wrong default. The `/queue add` command accepts `--account` as a parameter, but if the template prefills the wrong value and the system does not override it, items will be misattributed.

**Fix:** Either set `account: ""` (empty, like x-single and x-thread do) on templates where multiple accounts might apply, or ensure `/queue add` always overwrites the template's `account` field with the `--account` parameter value.

### 3. Podcast template has no disclaimer in the audio output itself

CLAUDE.md requires disclaimers on all marketing content. The podcast template includes a compliance pre-check and disclaimer in the X promo post text, but NotebookLM-generated audio has no mechanism to inject a spoken disclaimer. Since "audio can't be edited after generation" (as the template itself warns), there is no way to add a disclaimer post-generation.

**Fix:** Add a mandatory talking point that instructs NotebookLM to include a verbal disclaimer. Under "Must Cover", add:
```
4. Verbal disclaimer: "This is for informational purposes only, not financial advice. Digital assets carry risk of loss."
```
This is not guaranteed to work (NotebookLM is not fully controllable), so also add a fallback requirement: the podcast description/show notes on whatever platform hosts it must include the full long-form disclaimer.

### 4. `thread_count` field is misleading on non-thread templates

Every template except `x-thread.md` sets `thread_count: 1`. This field only makes sense for X threads. For a blog post, podcast, infographic, slide deck, etc., this field is semantically meaningless. The slide deck template has its own `slide_count` field which is the actual useful count.

**Fix:** Remove `thread_count` from all non-X templates, or rename it to something generic like `part_count` with clear semantics per content type.

### 5. Manifest schema missing `scheduled_post_at` for rejected item

The manifest item for the rejected test post does not include `scheduled_post_at`, but the SKILL.md manifest regeneration process (line 501) says items should include `scheduled_post_at`. The field is missing from the manifest item rather than being present as null/empty.

**Fix:** Ensure manifest regeneration always includes all documented fields, even when empty. Example:
```json
"scheduled_post_at": null
```

### 6. No `telegram` template despite `telegram` being a valid platform in `/queue add`

The `/queue add` command lists `telegram` as a valid platform value, but there is no template for Telegram. CLAUDE.md also references "Discord/Telegram" under Tone by Platform. If someone runs `/queue add --platform telegram`, the system has no template to load.

**Fix:** Either create a Telegram template (could be minimal, similar to Discord), or remove `telegram` from the valid platform list until a template exists.

### 7. No `youtube` template despite `youtube` being a valid platform in `/queue add`

Same issue: `youtube` is listed as a valid platform, video templates reference YouTube Shorts in their export specs, but there is no YouTube-specific template. The video templates default to `platform: "x"`.

**Fix:** Either add a YouTube template or clarify that video templates serve YouTube by changing their platform comment to explicitly list YouTube as a valid value.

### 8. Manifest `items` array includes `rejection_reason` but not other review/execution fields

The manifest item for the rejected post includes `rejection_reason` (not documented in the SKILL.md manifest schema). The SKILL.md says the items array should include: `id, status, platform, account, pillar, priority, compliance_passed, review_tier, created_at, scheduled_post_at`. The current manifest adds `content_type` and `rejection_reason` which are not in the documented schema.

**Fix:** Update the SKILL.md manifest schema to include all fields that are actually output, or strip the extra fields from the manifest regeneration.

---

## GAPS

### 1. No template for `reply` or `quote_tweet` content types

The `/queue add` command lists `reply` and `quote_tweet` as valid content types, but there are no templates for either. These are distinct content types with unique requirements:
- `reply` needs a `reply_to_id` or `reply_to_url` field to reference the parent tweet
- `quote_tweet` needs a `quote_tweet_url` field

**Fix:** Create `x-reply.md` and `x-quote-tweet.md` templates, or extend `x-single.md` with optional fields for reply/QT context.

### 2. No template for `meme` content type

`meme` is listed as a valid content type in `/queue add`, and the fanpage persona is heavily meme-focused. Currently, memes would fall through to either `image-social-graphic.md` (for image memes) or `x-single.md` (for text memes), but there is no explicit meme template that encodes the fanpage voice rules, the lighter compliance disclaimer format ("nfa // dyor"), or the meme-specific review considerations.

**Fix:** Create a `x-meme.md` template that:
- Defaults to `account: "voidai_memes"`
- Uses the lighter disclaimer format per CLAUDE.md fanpage compliance adaptation
- Includes a field for meme format/reference (e.g., `meme_format: "POV" | "nobody:" | "hot take"`)
- Defaults `review_tier: 3` for memes with no financial claims (per SKILL.md Tier 3 rules)

### 3. No `asset_path` field linking generated media to content items

The SKILL.md states "Generated assets (images, videos) are saved to `queue/assets/` and referenced from the content item." But none of the templates have an `asset_path` or `media_url` field in their frontmatter to store this reference. The image and video templates have `has_media: true` but no field to store the actual file path.

**Fix:** Add to all media templates:
```yaml
asset_path: ""    # Path to generated asset in queue/assets/
asset_paths: []   # For multi-image posts (e.g., carousel, A/B variants)
```

### 4. No crisis mode field or mechanism in the queue system

CLAUDE.md has a detailed Crisis Communication Protocol that requires: "PAUSE all scheduled content across ALL accounts immediately." But the queue manager has no `/queue pause` or `/queue crisis` command, and there is no `crisis_mode` flag in the manifest. During a crisis, Vew would need to manually move every scheduled item back to approved or cancelled.

**Fix:** Add:
- `crisis_mode: false` to manifest.json
- `/queue pause` command that sets `crisis_mode: true`, blocks all scheduling and auto-posting, and logs the reason
- `/queue resume` command that lifts the pause

### 5. Fanpage disclaimer format not encoded in templates

CLAUDE.md specifies the fanpage should use lighter disclaimers: `"nfa // dyor"` or `"not financial advice obv"` with a link to full disclaimer in bio. But the x-single and x-thread templates only include the formal disclaimer text. There is no mechanism to select the appropriate disclaimer based on the account.

**Fix:** Add a `disclaimer_format` field:
```yaml
disclaimer_format: "standard"  # standard | short | long | none-in-bio
```
And define the mapping:
- `standard`: "Not financial advice. Digital assets are volatile and carry risk of loss. DYOR."
- `short`: "nfa // dyor" (fanpage)
- `long`: Full blog disclaimer
- `none-in-bio`: No in-post disclaimer, link to disclaimer in bio (only for Tier 3 memes)

### 6. No rework tracking for rejected items sent back to drafts

When an item is rejected and sent back to drafts via `/queue move <id> drafts`, there is no field to track rework history. How many times has this item been rejected? What were the previous rejection reasons? This matters for identifying content that keeps failing review.

**Fix:** Add:
```yaml
rework_count: 0
rejection_history: []  # [{reason: "...", rejected_at: "...", rejected_by: "..."}]
```

### 7. No batch generation tracking

The `/queue batch-approve` command works on items from a specific `source_workflow`, but there is no batch ID to group items generated in the same run. If n8n Workflow 1 generates 5 items from daily metrics, there is no way to see them as a batch or approve/reject the entire batch at once.

**Fix:** Add:
```yaml
batch_id: ""   # Groups items from the same generation run
```

### 8. Blog template missing `canonical_url` field

Blog posts on voidai.com need a canonical URL for SEO. The template has `seo_slug` but no `canonical_url` to store the full URL after publishing. This matters for the blog distribution workflow (Workflow 5) that creates derivative content linking back to the original.

**Fix:** Add:
```yaml
canonical_url: ""  # e.g., https://voidai.com/blog/{seo_slug}
```

### 9. No Notion property mapping for template-specific fields

The SKILL.md documents a Notion migration path mapping YAML keys to Notion property types. But template-specific fields like `word_count`, `seo_title`, `seo_description`, `seo_slug`, `seo_keywords`, `estimated_duration`, `video_duration`, `video_format`, `aspect_ratio`, `image_variant`, `image_dimensions`, `image_count`, `slide_count`, `deck_purpose`, `data_source`, `data_freshness`, `dimensions`, `tool`, `derivative_formats`, `derivatives_needed`, and all the Nano Banana Pro fields are not included in the Notion mapping.

**Fix:** Extend the Notion property mapping section in SKILL.md to cover all template-specific fields.

---

## IMPROVEMENTS

### 1. Add a template validation command

There is no way to validate that a template conforms to the expected schema. A `/queue validate-templates` command would catch issues like the `status: "draft"` vs `"drafts"` bug automatically.

### 2. Add `--template` override to `/queue add`

Currently, template selection is automatic based on `--type` and `--platform`. Allow `--template <filename>` to explicitly choose a template, which is useful when the auto-selection logic picks the wrong one.

### 3. Consider adding a `tags` field

For cross-cutting content organization beyond pillars (e.g., "chainlink-ccip", "solana", "bittensor", "sdk-launch"), a tags field would improve discoverability and filtering in `/queue list` and the eventual Notion migration.

### 4. Manifest could track daily posting counts

The cadence rules enforce max posts/day per account, but the manifest only tracks total counts by status. Adding a `daily_counts` section would speed up cadence validation:
```json
"daily_counts": {
  "2026-03-13": { "v0idai": 0, "voidai_memes": 0, "voidai_tao": 0, "voidai_defi": 0 }
}
```

### 5. The `assets/` directory has no `.gitkeep`

All other queue subdirectories have a `.gitkeep` file to preserve the directory in git. The `assets/` directory does not.

### 6. Add `updated_at` auto-update documentation

Templates have `updated_at: ""` but the SKILL.md does not specify when this field should be updated. It should be updated on every status transition, content edit, or compliance recheck.

### 7. Infographic template uses `dimensions` instead of `image_dimensions`

The infographic template uses a field called `dimensions` while the image templates use `image_dimensions`. This inconsistency will cause confusion and potential bugs in any code that tries to read image dimensions generically across content types.

**Fix:** Standardize on `image_dimensions` across all visual templates.

### 8. Video-script template lists Higgsfield but SKILL.md says Higgsfield/Loom/Screen Studio/Canva

The template includes tool-specific instruction sections for Higgsfield, Loom/Screen Studio, and Canva. But the SKILL.md Available Templates table lists the tool as "Higgsfield/Loom/Screen Studio/Canva". These are consistent, but Higgsfield is not mentioned anywhere else in the project. Verify this is a real tool the team has access to.

### 9. Consider separating "template" files from "schema" definition

Currently, the templates serve dual duty: they define the YAML schema AND provide placeholder content. A separate schema file (JSON Schema or similar) would enable automated validation, Notion property auto-generation, and n8n workflow configuration.

---

## TEMPLATE-SPECIFIC ISSUES

### x-single.md
- **BUG:** `status: "draft"` should be `"drafts"` (see Critical Bug 1)
- **GAP:** No `character_limit` field (see Critical Bug 4)
- **GAP:** No `asset_path` field for media attachments when `has_media: true`
- Content placeholder says "max 280 characters" -- potentially incorrect (see Critical Bug 2)

### x-thread.md
- **BUG:** `status: "draft"` should be `"drafts"`
- **GAP:** No `character_limit` field (per-part limit)
- **GAP:** No mechanism to track per-part character counts; `character_count` is a single number but threads have N parts
- Thread Part 1 duplicates the Content section (both say "Hook tweet"). Confusing for the author -- which one is canonical?
- `thread_count: 0` default will cause issues if not updated; should be validated as > 0 on submission

### linkedin-post.md
- **BUG:** `status: "draft"` should be `"drafts"`
- **WARNING:** `account` hardcoded to `"v0idai"` (see Warning 2)
- LinkedIn character limit is stated as 3,000 in the placeholder but the actual LinkedIn limit is 3,000 characters for regular posts and up to 100,000+ for articles. This should be clarified based on post type.

### discord-announcement.md
- **BUG:** `status: "draft"` should be `"drafts"`
- **WARNING:** `account` hardcoded to `"v0idai"`
- **GAP:** No `channel` field to specify which Discord channel (e.g., #announcements, #updates, #general). The editor notes mention "Channel: #announcements" in a comment, but this should be a frontmatter field for n8n automation.

### blog-post.md
- **BUG:** `status: "draft"` should be `"drafts"`
- **WARNING:** `account` hardcoded to `"v0idai"`
- **GOOD:** Has blog-specific fields (`word_count`, SEO fields, `derivatives_needed`, `derivative_formats`). Well-designed.
- **GOOD:** Review tier correctly hardcoded to 1 per CLAUDE.md rules.
- **GAP:** Missing `canonical_url` field (see Gap 8)
- **GAP:** Missing `author` field for multi-author blog support
- **NOTE:** Risk disclosures section uses HTML comments to conditionally include disclaimers. This is good UX but an n8n workflow parsing this file will need to handle these comments correctly.

### podcast-notebooklm.md
- **BUG:** `status: "draft"` should be `"drafts"`
- **WARNING:** `account` hardcoded to `"v0idai"`
- **WARNING:** No audio disclaimer mechanism (see Warning 3)
- **GAP:** No `audio_file_path` field to store the generated podcast file location
- **GAP:** No `show_notes` field for the podcast description (needed for hosting platform)
- **GOOD:** Compliance pre-check checklist is well-thought-out for the unique challenges of audio content.

### video-script.md
- **BUG:** `status: "draft"` should be `"drafts"`
- **GAP:** `tool: ""` is empty by default with no selection logic documented. If `/queue add` does not auto-populate this, the item will have no tool assignment.
- **GOOD:** Comprehensive scene-by-scene structure with Visual + Narration split.

### video-google-veo.md
- **BUG:** `status: "draft"` should be `"drafts"`
- **GOOD:** Excellent prompt recipes with specific, actionable examples for each use case.
- **GOOD:** Platform export specs table is very practical.
- **NOTE:** This is the most comprehensive template. At 174 lines, it may be overwhelming for quick content creation. Consider whether a "quick mode" vs "full mode" distinction would help.

### image-social-graphic.md
- **BUG:** `status: "draft"` should be `"drafts"`
- **GAP:** No `asset_path` field (see Gap 3)
- **NOTE:** References `${SKILL_DIR}/scripts/image.py` in the Nano Banana Pro command. This path assumes the skill has a `scripts/` subdirectory. Verify this file exists.
- **GOOD:** Prompt recipes by variant are practical and account-for-common-use-cases.

### image-content-hero.md
- **BUG:** `status: "draft"` should be `"drafts"`
- **GAP:** No `asset_path` field
- **GOOD:** Alt text field is included (good for SEO and accessibility).
- **GOOD:** Multi-variant generation example (blog header + square variant) is practical.

### infographic.md
- **BUG:** `status: "draft"` should be `"drafts"`
- **WARNING:** Uses `dimensions` instead of `image_dimensions` (inconsistent with image templates -- see Improvement 7)
- **GAP:** No `asset_path` field
- **GOOD:** Data point sourcing table enforces verifiability.

### data-card.md
- **BUG:** `status: "draft"` should be `"drafts"`
- **GOOD:** `data_source` and `data_freshness` fields are unique and appropriate for this content type.
- **GOOD:** The data points table with Source and Pulled At columns enforces accountability.
- **GOOD:** Clear Tier escalation rules: Tier 2 for raw data, Tier 1 for editorial framing.
- **NOTE:** Account comment says "not fanpage -- data cards aren't memes" which is a good guardrail.

### slide-deck.md
- **BUG:** `status: "draft"` should be `"drafts"`
- **WARNING:** `account` hardcoded to `"v0idai"`
- **GOOD:** `slide_count` and `deck_purpose` fields are well-designed.
- **GAP:** No mechanism to validate that each slide has been compliance-checked individually. The editor notes checklist says "Every slide checked for prohibited language?" but this is manual-only.

---

## COMPLIANCE CROSS-REFERENCE SUMMARY

### Prohibited terms coverage

The SKILL.md compliance check Step 1 (Category A) covers these terms from CLAUDE.md:
- "guaranteed returns" -- covered
- "risk-free" -- covered
- "no risk" -- covered
- "safe investment" -- covered
- "secure investment" -- covered
- "get rich" -- covered
- "financial freedom" -- covered
- "passive income" -- covered
- "to the moon" -- covered
- "100x" -- covered
- "SEC-approved/registered" -- covered
- "CFTC-approved" -- covered
- "government-backed" -- covered
- "FDIC-insured" -- covered

**MISSING from Category A scan:**
- "insured" (standalone, per CLAUDE.md: "insured")
- "regulated" (CLAUDE.md says never claim regulated "unless verifiably true")
- Comparison to bank rates / savings accounts / traditional investments (CLAUDE.md prohibits this but the compliance scan does not check for it)
- "payment stablecoin" (CLAUDE.md says never use unless GENIUS Act applies)
- "solicitation to buy, sell, or hold" patterns (CLAUDE.md prohibits this)
- "legal tender" (CLAUDE.md prohibits claiming stablecoins are equivalent)

### Disclaimer verification gaps

The SKILL.md Step 4 disclaimer table covers X, LinkedIn, Blog, and Discord. Missing:
- **Telegram** -- no disclaimer requirement defined (no template either)
- **YouTube** -- no disclaimer requirement defined
- **Podcast** -- no disclaimer requirement defined (audio medium is a special case)
- **Slides/Decks** -- not in the table (should require disclaimer on final slide)

### Pillar distribution alignment

CLAUDE.md and SKILL.md both specify the same targets:
- bridge-build: 40% -- matches
- ecosystem-intelligence: 25% -- matches
- alpha-education: 25% -- matches
- community-culture: 10% -- matches

The manifest also matches. No issues here.

### Cadence rules alignment

SKILL.md cadence table matches CLAUDE.md exactly for all accounts (max posts/day, min gap, peak windows, weekend max). No discrepancies.

### Stagger rules alignment

SKILL.md stagger rules match CLAUDE.md inter-account coordination rules exactly. No discrepancies.

---

## SUMMARY

| Category | Count |
|----------|:-----:|
| Critical Bugs | 4 |
| Warnings | 8 |
| Gaps | 9 |
| Improvements | 9 |
| Template-specific issues | 40+ (across 13 templates) |

**Highest priority fixes:**
1. Fix `status: "draft"` -> `"drafts"` across all 13 templates (5 minutes, prevents rebuild errors)
2. Add `character_limit` field to templates and resolve the review card `{limit}` reference (prevents runtime display errors)
3. Resolve "My play today:" contradiction between CLAUDE.md and content-review-rules.md (prevents inconsistent compliance rulings)
4. Create missing templates for `reply`, `quote_tweet`, `meme`, and `telegram` content types (prevents `/queue add` failures)
5. Add `asset_path` field to media templates (needed before any image/video generation workflow can work)
6. Add missing prohibited terms to Category A scan (compliance gap)
