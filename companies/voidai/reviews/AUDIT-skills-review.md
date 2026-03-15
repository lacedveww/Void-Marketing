# Skills Audit Report -- VoidAI Marketing System (Step 2)

**Auditor:** Code Reviewer Agent
**Date:** 2026-03-13
**Scope:** All 37 skills in `.claude/skills/`, symlinks in `.agents/skills/`, product marketing context, cross-skill conflicts
**Files examined:** 37 SKILL.md files, 13 queue templates, manifest.json, CLAUDE.md, product-marketing-context.md, settings.json

---

## CRITICAL BUGS (Must Fix -- Will Break)

### C1. developer-growth-analysis depends on Rube MCP which is not installed

**File:** `/Users/vew/Apps/Void-AI/.claude/skills/developer-growth-analysis/SKILL.md`
**Lines:** 151-197

The skill references `Rube MCP` for HackerNews search (line 151: `RUBE_SEARCH_TOOLS`) and Slack delivery (line 193-197: `RUBE_MANAGE_CONNECTIONS`, `RUBE_MULTI_EXECUTE_TOOL`). No MCP servers are configured in the project -- `/Users/vew/Apps/Void-AI/.claude/settings.json` does not exist and `/Users/vew/.claude/settings.json` contains no `mcpServers` section.

**Impact:** Steps 5, 6, and 7 of the skill (HackerNews search, Slack delivery) will fail silently or error. The skill is essentially non-functional for its two differentiating features.

**Fix:** Either install Rube MCP, or rewrite those sections to use WebSearch/WebFetch for HackerNews and remove the Slack delivery (since Slack is not part of the VoidAI marketing stack per CLAUDE.md -- the tools listed are Claude Max, Google AI Pro, Canva, Figma, Loom, Screen Studio, DGX Spark).

---

### C2. developer-growth-analysis reads ~/.claude/history.jsonl which may not exist or have the described format

**File:** `/Users/vew/Apps/Void-AI/.claude/skills/developer-growth-analysis/SKILL.md`
**Line:** 65

The skill instructs: `Read the chat history from ~/.claude/history.jsonl`. Claude Code does not expose a `history.jsonl` file in this format. The fields described (`display`, `project`, `timestamp`, `pastedContents`) are not part of any documented Claude Code data structure.

**Impact:** Step 1 of the skill will fail -- no history data can be read, making the entire skill non-functional.

**Fix:** Remove this skill from the active set or rewrite it to work with available data (e.g., Claude Code's conversation context or project files). This skill appears designed for a different environment.

---

### C3. competitive-ads-extractor claims to scrape ad libraries but has no mechanism to do so

**File:** `/Users/vew/Apps/Void-AI/.claude/skills/competitive-ads-extractor/SKILL.md`
**Lines:** 22, 62-82

The skill claims it "Scrapes ads from Facebook Ad Library, LinkedIn, etc." and shows output as if it accesses Facebook's Ad Library API, captures screenshots, and saves files. Claude Code has no browser, screenshot capability, or Facebook Ad Library API integration. The `Bash` tool cannot run browser automation, and there is no Puppeteer/Playwright or Apify integration configured for this purpose.

**Impact:** The skill presents a false capability. It cannot extract ads, capture screenshots, or access ad libraries. Users invoking it will get hallucinated output.

**Fix:** Either integrate with Apify (the project already uses `api-ninja/x-twitter-advanced-search` per memory), configure a browser-automation MCP, or clearly reframe this skill as an "analysis framework" that operates on manually provided ad screenshots/data rather than pretending to scrape live data.

---

### C4. product-marketing-context.md location mismatch -- 32 skills look in the wrong place

**File:** All 32 symlinked marketingskills SKILL.md files
**Pattern (line varies by skill):** `If .agents/product-marketing-context.md exists (or .claude/product-marketing-context.md in older setups)`

The actual product marketing context lives at `/Users/vew/Apps/Void-AI/.agents/product-marketing-context.md`. The 32 marketingskills correctly check `.agents/product-marketing-context.md` as primary. However, the `product-marketing-context` skill (which generates this file) is symlinked into `.claude/skills/` from the marketingskills package and will try to create/write to `.agents/product-marketing-context.md` -- this works. But there is also a symlink at `.claude/skills/product-marketing-context` pointing to the marketingskills package, which is a skill directory, NOT the context document. When Claude encounters the skill, it may try to load the SKILL.md instead of the context document.

**Additionally:** No file exists at `.claude/product-marketing-context.md` (confirmed missing), so the "older setups" fallback path silently fails. This is not critical since `.agents/product-marketing-context.md` does exist, but it means the fallback is dead code.

**Impact:** Low-to-medium. The primary path works, but the directory naming overlap between the `product-marketing-context` skill and the `product-marketing-context.md` document could cause confusion.

**Fix:** No immediate action needed -- the primary path resolves. Consider renaming the skill to `product-marketing-context-generator` to avoid namespace confusion.

---

## WARNINGS (Should Fix)

### W1. 15+ SaaS-focused skills are irrelevant to VoidAI's protocol/infrastructure model

**Files:** Multiple symlinked skills from the marketingskills package

VoidAI is a DeFi protocol/infrastructure project, not a SaaS product. The following skills are designed for SaaS businesses and contain SaaS-specific advice that does not apply or could produce misleading output:

| Skill | Why Irrelevant |
|-------|----------------|
| `churn-prevention` | SaaS subscription churn -- VoidAI has no subscriptions |
| `pricing-strategy` | SaaS pricing tiers/freemium -- VoidAI charges protocol fees |
| `paywall-upgrade-cro` | In-app paywalls -- VoidAI has no paywall |
| `signup-flow-cro` | SaaS signup flows -- VoidAI uses wallet connect |
| `onboarding-cro` | SaaS onboarding -- VoidAI onboarding is connect wallet + bridge |
| `form-cro` | Lead capture forms -- VoidAI has no lead forms |
| `popup-cro` | Website popups -- VoidAI has a dApp, not a SaaS site |
| `cold-email` | B2B cold outreach -- VoidAI targets crypto communities, not email prospects |
| `email-sequence` | Lifecycle email drips -- no email marketing system (Mautic is planned but not deployed) |
| `revops` | Marketing-to-sales handoff -- VoidAI has no sales team |
| `sales-enablement` | Sales decks, pitch decks -- no sales team |
| `free-tool-strategy` | Free tools for lead gen -- different growth model |
| `referral-program` | SaaS referral programs -- could apply to crypto but not in current form |
| `ab-test-setup` | A/B testing -- could apply later but no test infrastructure exists |
| `analytics-tracking` | GA4/Mixpanel -- different analytics needs for DeFi protocols |

**Impact:** These skills will waste context tokens when loaded and may generate advice that conflicts with VoidAI's actual business model. For example, `pricing-strategy` advising "freemium tiers" or `cold-email` suggesting B2B outreach.

**Fix:** Create a `.claude/skills/DISABLED.md` or remove the symlinks for inapplicable skills. Keep only skills relevant to the current phase: `social-content`, `content-strategy`, `copywriting`, `copy-editing`, `seo-audit`, `ai-seo`, `schema-markup`, `programmatic-seo`, `site-architecture`, `launch-strategy`, `marketing-ideas`, `marketing-psychology`, `content-research-writer`, `twitter-algorithm-optimizer`, `competitive-ads-extractor` (after fix), `competitor-alternatives`, `ad-creative`, `paid-ads`, `queue-manager`.

---

### W2. queue-manager references n8n integration but no n8n workflows exist

**File:** `/Users/vew/Apps/Void-AI/.claude/skills/queue-manager/SKILL.md`
**Lines:** 517-534

The skill describes n8n writing to `queue/drafts/` and a posting workflow polling `queue/scheduled/`. Per the memory context, 13 n8n workflows are planned but none are deployed yet. The Hermes Agent and ElizaOS mentioned in CLAUDE.md are also not deployed.

**Impact:** The n8n integration section describes behavior that will not happen. This is acceptable since `dry_run_mode: true` is set in manifest.json, but any user reading the skill may expect automated posting to work.

**Fix:** Add a note at the top of the n8n integration section: `STATUS: Not yet deployed. All posting is manual while dry_run_mode is true.`

---

### W3. queue-manager template references tools that are not installed/configured

**File:** `/Users/vew/Apps/Void-AI/.claude/skills/queue-manager/SKILL.md`
**Lines:** 51-57 (template table)

The template table references tools that have varying levels of availability:

| Template | Referenced Tool | Status |
|----------|----------------|--------|
| `podcast-notebooklm.md` | NotebookLM MCP | Installed but needs first-time Chrome auth (per memory) |
| `video-google-veo.md` | Google Flow / Veo | Deferred to Phase 3 (per `project_deferred_mcps.md`) |
| `image-social-graphic.md` | Nano Banana Pro | Installed as a plugin in settings.json |
| `image-content-hero.md` | Nano Banana Pro (Pro model) | Same plugin, but "Pro model" distinction unclear |
| `infographic.md` | Canva/Figma | External tools, no API integration |
| `data-card.md` | Canva/Figma/n8n | n8n not deployed |
| `slide-deck.md` | Canva/Figma/Google Slides | External tools, no API integration |
| `video-script.md` | Higgsfield/Loom/Screen Studio/Canva | External tools only |

**Impact:** Users attempting to generate video, podcast, infographic, or slide content through the queue will hit dead ends for automated generation. Only image generation via Nano Banana Pro is currently functional.

**Fix:** Add a `Status` column to the template table indicating which are operational vs. manual-only vs. deferred.

---

### W4. twitter-algorithm-optimizer does not reference VoidAI compliance rules

**File:** `/Users/vew/Apps/Void-AI/.claude/skills/twitter-algorithm-optimizer/SKILL.md`

This 327-line skill provides general Twitter optimization advice but has zero awareness of VoidAI's compliance framework. It suggests tactics like:

- Line 101: "Create controversy (safely): Debate attracts engagement" -- conflicts with CLAUDE.md crisis protocol and the prohibition on content that could be reported/blocked
- Line 107: "Hot take: Current climate policy ignores nuclear energy. Thoughts?" -- the "hot take" pattern is acknowledged in CLAUDE.md for satellite accounts but the optimizer does not scope its advice to VoidAI's brand voice registers
- Lines 232-234: Uses emojis in optimized examples -- CLAUDE.md fanpage persona says "sparingly but strategically" for emojis

The skill never reads `CLAUDE.md`, `brand/voice-learnings.md`, or applies compliance checks before suggesting optimizations.

**Impact:** Content optimized by this skill without compliance awareness could violate CLAUDE.md rules, especially the absolute prohibitions around financial language. A user could ask "optimize this tweet about SN106 staking" and receive suggestions that violate compliance.

**Fix:** Add a preamble to the skill: "Before optimizing any tweet for VoidAI, read CLAUDE.md compliance rules and brand voice. All optimized content must pass the queue-manager compliance check sequence. Never suggest engagement bait patterns that use prohibited financial language."

---

### W5. social-content skill overlaps significantly with queue-manager and twitter-algorithm-optimizer

**Files:**
- `/Users/vew/Apps/Void-AI/.agents/marketingskills/skills/social-content/SKILL.md`
- `/Users/vew/Apps/Void-AI/.claude/skills/queue-manager/SKILL.md`
- `/Users/vew/Apps/Void-AI/.claude/skills/twitter-algorithm-optimizer/SKILL.md`

The `social-content` skill generates social media content. The `queue-manager` generates content via `/queue add`. The `twitter-algorithm-optimizer` optimizes tweets. There is no clear routing: when a user says "write a tweet about bridge volume," which skill activates?

**Impact:** Inconsistent content generation. `social-content` will not run compliance checks. `queue-manager` will run compliance but uses a different generation flow. `twitter-algorithm-optimizer` will optimize for engagement but ignore compliance.

**Fix:** Establish a clear hierarchy: `queue-manager` is the primary entry point for all VoidAI content generation. `social-content` and `twitter-algorithm-optimizer` are advisory skills consulted during generation, not independent generators. Document this routing in each skill's description.

---

### W6. content-research-writer skill references ~/writing/ working directory unrelated to VoidAI queue

**File:** `/Users/vew/Apps/Void-AI/.claude/skills/content-research-writer/SKILL.md`
**Lines:** 36-46, 493-507

The skill instructs users to create files in `~/writing/my-article-title/` with its own file organization structure. This bypasses the queue system entirely. Blog content should flow through `queue/drafts/` using the `blog-post.md` template.

**Impact:** Content created via this skill will not enter the queue, will not get compliance checks, and will not appear in the manifest.

**Fix:** Update the skill's instructions to save output to `queue/drafts/` and use the blog-post template's frontmatter format.

---

### W7. Missing `.agents/skills/` symlinks for 32 marketingskills

**Directory:** `/Users/vew/Apps/Void-AI/.agents/skills/`

The `.agents/skills/` directory only has 5 symlinks (competitive-ads-extractor, content-research-writer, developer-growth-analysis, queue-manager, twitter-algorithm-optimizer) -- all pointing to `.claude/skills/` custom skills. None of the 32 symlinked marketingskills have entries in `.agents/skills/`.

Per the Agent Skills specification, `.agents/skills/` is the cross-agent standard directory. Any non-Claude agent (Hermes Agent, ElizaOS) looking for skills would only find 5 of the 37 installed skills.

**Impact:** If other agents are integrated later, they will not find the marketing skills.

**Fix:** Either create symlinks in `.agents/skills/` for all 32 marketingskills, or decide that `.claude/skills/` is the canonical location for Claude-only skills and document this.

---

### W8. YAML frontmatter in queue templates uses comments that may not parse correctly

**Files:** All 13 templates in `/Users/vew/Apps/Void-AI/queue/templates/`
**Example:** `/Users/vew/Apps/Void-AI/queue/templates/x-single.md`, line 12: `account: ""  # v0idai|voidai_memes|voidai_tao|voidai_defi`

YAML comments (`#`) on the same line as key-value pairs are valid YAML, but several lines also use `# Section headers` as organizational markers within the frontmatter (lines 7, 10, 15, 21, 27, 31, 41, 48, 54). Some YAML parsers treat lines starting with `#` inside the frontmatter block as comments, but others may error. This is technically valid YAML but fragile.

**Impact:** If n8n or another tool uses a strict YAML parser that does not tolerate comment-only lines within frontmatter, parsing will fail.

**Fix:** Move section comments outside the `---` delimiters, or ensure all consuming tools use a YAML parser that handles comments correctly. Test with the actual n8n YAML/markdown parsing module before deployment.

---

## GAPS (Missing Capabilities)

### G1. No community engagement / reply management skill

VoidAI's marketing roadmap emphasizes community building and the X satellite accounts strategy requires active engagement (replies, QTs, mentions). No skill manages:
- Monitoring and responding to mentions
- Community reply templates by persona
- Engagement tracking
- Reply queue management

**Recommendation:** Create a `community-engagement` skill that handles reply generation per satellite persona, with compliance checks on replies (replies can still violate financial language rules).

---

### G2. No metrics/data ingestion skill

CLAUDE.md requires "anchor metrics" (total value bridged, SN106 mindshare rank, unique wallets, bridge uptime, chains supported) in content. No skill provides a workflow for pulling this data from Taostats MCP or other sources into a format the queue-manager can reference.

**Recommendation:** Create a `metrics-dashboard` skill that pulls from Taostats MCP (which is installed per memory), caches current metrics to a file like `data/current-metrics.json`, and makes them available to content generation skills.

---

### G3. No competitor monitoring skill

CLAUDE.md references competitor monitoring (Project Rubicon, Wormhole, LayerZero, Axelar) and the queue-manager has a `competitor-monitor` source workflow. No skill defines how competitor monitoring actually works.

**Recommendation:** Create a `competitor-monitor` skill or integrate with the Apify X scraper to track competitor activity.

---

### G4. No weekly voice calibration skill

CLAUDE.md defines a "Weekly Voice Calibration" process (Friday workflow: scrape, analyze, extract patterns, update `brand/voice-learnings.md`). No skill automates or guides this process.

**Recommendation:** Create a `voice-calibration` skill with the Friday workflow steps, or document it as an n8n workflow to be built.

---

### G5. No crisis communication skill

CLAUDE.md has a detailed crisis communication protocol. No skill activates this protocol or guides the user through crisis response. If a bridge exploit occurs, the user must manually remember to read CLAUDE.md and follow the protocol.

**Recommendation:** Create a `crisis-response` skill activated by `/crisis` that implements the CLAUDE.md crisis protocol (pause all content, draft factual acknowledgment, per-account behavior).

---

### G6. No Telegram content template

The queue-manager's `--platform` parameter accepts `telegram` but no template exists for Telegram. The `discord-announcement.md` template is the closest but Discord and Telegram have different formatting capabilities.

**Recommendation:** Create a `telegram-announcement.md` template.

---

## IMPROVEMENTS (Nice-to-Haves)

### I1. Queue-manager could auto-count characters in generated content

The `character_count` field in templates defaults to 0 and must be manually set. The queue-manager should automatically count characters in the content body and set this field, then validate against platform limits (280 for X single, 25000 for LinkedIn, etc.).

---

### I2. Queue templates could include the disclaimer text as a constant rather than inline

Every template includes the disclaimer text inline. If the disclaimer wording changes (as it might for different jurisdictions per CLAUDE.md), all 13 templates must be updated. Consider moving disclaimers to a `queue/templates/_disclaimers.md` partial that templates reference.

---

### I3. developer-growth-analysis and competitive-ads-extractor could be moved to a "disabled" folder

Since both are non-functional (C1-C3), they should be moved out of the active skills directory to avoid confusion. Create `/Users/vew/Apps/Void-AI/.claude/skills-disabled/` and move them there.

---

### I4. The marketingskills package CLAUDE.md auto-update check could cause unwanted network calls

**File:** `/Users/vew/Apps/Void-AI/.agents/marketingskills/CLAUDE.md`
**Section:** "Checking for Updates"

The marketingskills package CLAUDE.md instructs: "Once per session, on first skill use, check for updates: Fetch VERSIONS.md from GitHub." This will make network calls to `raw.githubusercontent.com/coreyhaines31/marketingskills/` on every session. This is not harmful but could be unexpected.

---

### I5. product-marketing-context.md could reference actual live URLs

**File:** `/Users/vew/Apps/Void-AI/.agents/product-marketing-context.md`

The document references product URLs from memory (`app.voidai.com/bridge-chains`, `app.voidai.com/stake`, `docs.voidai.com`) in the "Proof Points" section generally but does not include clickable URLs in the main document body. Adding specific product URLs would make generated content more accurate.

---

### I6. Queue-manager SKILL.md is 555 lines -- exceeds the 500-line guideline

**File:** `/Users/vew/Apps/Void-AI/.claude/skills/queue-manager/SKILL.md`

Per the marketingskills Agent Skills specification, SKILL.md files should be under 500 lines. The queue-manager is 555 lines. Consider moving the compliance check sequence (lines 340-453) or the cadence rules (lines 456-490) to a `references/` subdirectory.

---

## CONFLICTS (Cross-Skill Issues)

### X1. social-content vs. queue-manager content generation conflict

As noted in W5, both skills generate social media content. The `social-content` skill has its own voice/tone framework ("ask if not provided" approach) that is completely independent of CLAUDE.md's voice registers and compliance rules. When `social-content` generates content, it will:
- Not run compliance checks
- Not apply CLAUDE.md brand voice weights (40% builder-credibility, 25% alpha-leak, etc.)
- Not save to the queue
- Not present a review card

Meanwhile `queue-manager`'s `/queue add` does all of these things.

**Resolution:** The `social-content` skill should be marked as "advisory only" for VoidAI. All actual content creation must go through `/queue add`.

---

### X2. content-strategy pillar system vs. CLAUDE.md pillar system

The `content-strategy` skill (from marketingskills package) asks users to define their own content pillars from scratch. CLAUDE.md already defines fixed pillars with specific weights:
- Bridge & Build: 40%
- Ecosystem Intelligence: 25%
- Alpha & Education: 25%
- Community & Culture: 10%

If a user invokes `content-strategy`, it may suggest different pillars or weights that conflict with the established system.

**Resolution:** The `content-strategy` skill should check for `.agents/product-marketing-context.md` (which it does) and defer to the existing pillar structure. This mostly works, but the skill's description should note that VoidAI already has defined pillars.

---

### X3. copywriting skill suggests website copy changes -- contradicts project constraint

The `copywriting` skill is designed for "homepage, landing pages, pricing pages, feature pages, about pages, or product pages." Per the project constraint in memory: "NOT building/editing website. Blog posts only on existing voidai.com."

**Resolution:** This is a soft conflict. The skill could still be useful for copy on blog posts or marketing assets, but its primary use case (website copy) is out of scope for this project. Document this limitation or adjust the skill description for VoidAI's context.

---

### X4. Duplicate content creation paths (4 skills can generate tweets)

Four different skills can generate tweet content:
1. `queue-manager` via `/queue add --platform x`
2. `social-content` when asked for Twitter content
3. `twitter-algorithm-optimizer` when rewriting tweets
4. `content-research-writer` for article-promotion tweets

Only path 1 runs compliance checks and enters the queue.

**Resolution:** Document the canonical path in CLAUDE.md or a routing document. All tweet generation for VoidAI should use `/queue add`. Other skills serve as advisors to the generation process.

---

### X5. ad-creative and competitive-ads-extractor reference paid advertising -- compliance risk

Both skills involve creating and analyzing ads. CLAUDE.md compliance rules have strict requirements for paid content:
- "ALL sponsored or paid content MUST be labeled: #ad, #sponsored"
- Jurisdictional compliance for UK (FCA), EU (MiCA), Singapore (MAS), UAE (VARA)

Neither the `ad-creative` nor `competitive-ads-extractor` skill references these compliance requirements. If VoidAI ever runs paid ads, content generated by `ad-creative` could violate jurisdictional rules.

**Resolution:** Add compliance awareness to `ad-creative`. Note that crypto advertising is banned or heavily restricted on most major ad platforms (Google, Meta, LinkedIn all have crypto ad policies). The `paid-ads` skill should also include a crypto-specific section on platform policies.

---

## Summary

| Category | Count | Severity |
|----------|:-----:|----------|
| Critical Bugs | 4 | 2 fully broken skills, 1 skill with false capabilities, 1 path mismatch |
| Warnings | 8 | Irrelevant skills, missing integrations, compliance gaps, overlaps |
| Gaps | 6 | Missing community, metrics, competitor, calibration, crisis, Telegram skills |
| Improvements | 6 | Character counting, disclaimer management, cleanup, update checks |
| Conflicts | 5 | Duplicate content paths, pillar conflicts, compliance gaps in ad skills |

### Priority Actions

1. **Immediately:** Disable or rewrite `developer-growth-analysis` and `competitive-ads-extractor` (C1-C3) -- they are non-functional
2. **Before soft launch:** Add compliance preamble to `twitter-algorithm-optimizer` (W4) and establish content generation routing (W5, X1, X4)
3. **Before soft launch:** Create `community-engagement` skill (G1) and `metrics-dashboard` skill (G2) -- these are core to the marketing workflow
4. **Before first Friday:** Create `voice-calibration` skill (G4) or document the manual process
5. **This week:** Remove or disable the 15 SaaS-irrelevant skills (W1) to reduce noise
6. **Before n8n deployment:** Add status notes to queue-manager n8n section (W2) and test YAML parsing (W8)
