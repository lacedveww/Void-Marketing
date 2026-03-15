# MCP & External Integrations Audit

**Date:** 2026-03-13
**Auditor:** Code Reviewer (Claude Opus 4.6)
**Scope:** All MCP servers, plugins, and external integrations configured for the VoidAI Marketing System at `/Users/vew/Apps/Void-AI/`
**Config file:** `/Users/vew/.claude.json` -- project scope `/Users/vew/Apps/Void-AI`

---

## Inventory of Configured Integrations

| Integration | Type | Config Location | Status |
|-------------|------|-----------------|--------|
| Taostats | HTTP MCP | `.claude.json` projects["/Users/vew/Apps/Void-AI"].mcpServers.taostats | Configured |
| NotebookLM | stdio MCP | `.claude.json` projects["/Users/vew/Apps/Void-AI"].mcpServers.notebooklm | Configured |
| Nano Banana Pro | Plugin/Skill | `~/.claude/plugins/marketplaces/buildatscale-claude-code/plugins/nano-banana-pro/` | Installed |
| Apify (claude.ai) | claude.ai connector | `claudeAiMcpEverConnected` array in `.claude.json` | Connected (cloud) |
| seomachine | Local clone (not MCP) | `/Users/vew/Apps/Void-AI/seomachine/` | Installed, not configured |
| Composio | Referenced in CLAUDE.md | Not found anywhere in project | NOT installed |

---

## CRITICAL BUGS

### CRIT-01: Taostats API Key Hardcoded in Plaintext in `.claude.json`

**File:** `/Users/vew/.claude.json`, lines 565-567

```json
"taostats": {
  "type": "http",
  "url": "https://mcp.taostats.io?tools=data,docs,api",
  "headers": {
    "Authorization": "tao-****-****-****-****:****"
  }
}
```

The Taostats API key is stored in plaintext inside `~/.claude.json`. This file:
- Is not gitignored (it is a global Claude config, not project-scoped)
- Is readable by any process running as the user
- Contains a full bearer token that grants access to Taostats data/API tools
- Could be accidentally shared in screenshots, session exports, or support requests

**Fix:** Move the Taostats auth to an environment variable. Claude Code's MCP config supports `env` blocks. Alternatively, reference an environment variable in the header value. At minimum, ensure `~/.claude.json` is never committed to any repository and restrict its file permissions:

```bash
chmod 600 ~/.claude.json
```

**Severity:** CRITICAL -- live API credential exposed in a config file that is regularly read by tools and could be inadvertently logged.

---

### CRIT-02: NotebookLM MCP `active_notebook_id` Set to Wrong Project

**File:** `~/Library/Application Support/notebooklm-mcp/library.json`, line 62

```json
"active_notebook_id": "nodexo-ai"
```

The active notebook is set to `nodexo-ai` (the X-L2/Nodexo project), NOT `voidai`. The library contains three notebooks:
1. `nodexo-ai` -- Nodexo AI/X-L2 ecosystem docs (ACTIVE -- wrong)
2. `ai-marketing-general` -- AI Marketing General
3. `voidai` -- VoidAI

Any MCP tool calls to NotebookLM will operate against the Nodexo notebook by default, not VoidAI. This means podcast generation, source lookups, and any NotebookLM automation will pull from the wrong knowledge base.

**Fix:** Set `active_notebook_id` to `"voidai"` in `~/Library/Application Support/notebooklm-mcp/library.json`:

```json
"active_notebook_id": "voidai"
```

**Severity:** CRITICAL -- all NotebookLM-based content generation (podcast template, research queries) will use wrong source material.

---

## WARNINGS

### WARN-01: Apify MCP Not Configured as a Project-Scoped MCP Server

Apify appears in `claudeAiMcpEverConnected` as `"claude.ai Apify"` (line 680 of `.claude.json`), meaning it was connected through the claude.ai web interface. However, it is NOT listed in the project-scoped `mcpServers` for `/Users/vew/Apps/Void-AI`.

The project references `api-ninja/x-twitter-advanced-search` extensively (security audit, brand voice audit, x-voice-analysis, compliance docs). The memory notes explicitly state: "Apify scraper: use `api-ninja/x-twitter-advanced-search` (NOT apidojo/tweet-scraper)."

**Risk:** The cloud-based Apify connector may not be available in Claude Code CLI sessions. If Apify is only connected via the claude.ai web UI, local Claude Code sessions working on this project may not have access to Apify tools for monthly voice calibration scrapes.

**Fix:** Either:
1. Confirm that `claude.ai Apify` is accessible from Claude Code CLI for this project, or
2. Add Apify as a proper MCP server in the project config if a local MCP server is available, or
3. Document that Apify scraping must be done through the claude.ai web interface and cannot be automated locally

### WARN-02: seomachine Has No API Credentials Configured

**File:** `/Users/vew/Apps/Void-AI/reviews/step2-seomachine-install.md` (action items)

The seomachine install review lists 6 uncompleted action items for API credentials:
- [ ] DataForSEO account and credentials in `.env`
- [ ] GA4 and GSC API access + credentials
- [ ] WordPress application password for publishing
- [ ] Install WordPress MU-plugin (`seo-machine-yoast-rest.php`)
- [ ] Run `pip install -r data_sources/requirements.txt`
- [ ] Test API connectivity

The `.env` file itself could not be read (permission denied, likely because it is in `data_sources/config/` which may be gitignored or restricted). The `.env.example` also could not be read from `/Users/vew/Apps/Void-AI/seomachine/data_sources/config/`.

**Impact:** All seomachine commands (`/research`, `/write`, `/optimize`, `/performance-review`, `/publish-draft`) will fail until credentials are configured. The blog content pipeline (Cluster 1: Bittensor Bridge -- described as "highest priority, near-zero competition") is blocked.

**Fix:** Complete all 6 action items listed in the step2 review. These are pre-requisites for Phase 1a content generation.

### WARN-03: Composio Referenced in CLAUDE.md But Not Installed

**File:** `/Users/vew/Apps/Void-AI/CLAUDE.md` under Project Context:

```
- **SEO**: seomachine (off-page/strategic), Composio (on-page/technical)
```

Composio is referenced across 9 files in the project (roadmap, pre-launch checklist, security audit, strategy docs) as the on-page/technical SEO tool. However, there is NO Composio configuration, installation, or MCP server anywhere in the project or in `.claude.json`.

**Impact:** The SEO workflow is designed as a two-tool approach (seomachine for off-page, Composio for on-page). With Composio missing, the on-page SEO capability has no tooling.

**Fix:** Either:
1. Install and configure Composio (requires determining if it has an MCP server or is a standalone tool)
2. Determine if seomachine can cover on-page SEO tasks and remove Composio references
3. Document Composio as a Phase 2+ deferred item

### WARN-04: Nano Banana Pro Requires `GEMINI_API_KEY` Environment Variable

**File:** `/Users/vew/.claude/plugins/marketplaces/buildatscale-claude-code/plugins/nano-banana-pro/skills/generate/scripts/image.py`, line 52-54

```python
api_key = os.environ.get("GEMINI_API_KEY")
if not api_key:
    print("Error: GEMINI_API_KEY environment variable not set", file=sys.stderr)
```

The image generation plugin requires `GEMINI_API_KEY` to be set. This is not mentioned anywhere in the VoidAI project setup docs (step2 review, pre-launch checklist, or CLAUDE.md). If the env var is not set in the user's shell profile, all image generation via queue templates (`image-social-graphic.md`, `image-content-hero.md`) will fail silently.

**Fix:**
1. Verify `GEMINI_API_KEY` is set in the shell environment: `echo $GEMINI_API_KEY`
2. If not set, add it to `~/.zshrc` or `~/.zprofile`
3. Add this prerequisite to the pre-launch checklist

### WARN-05: `developer-growth-analysis` Skill References Non-Existent "Rube MCP"

**File:** `/Users/vew/Apps/Void-AI/.claude/skills/developer-growth-analysis/SKILL.md`

This skill references `RUBE_SEARCH_TOOLS`, `RUBE_MANAGE_CONNECTIONS`, and `RUBE_MULTI_EXECUTE_TOOL` for HackerNews search and Slack integration. "Rube MCP" is not configured in `.claude.json` for any project, including `/Users/vew/Apps/Void-AI`.

**Impact:** Low for VoidAI specifically (this skill appears to be a general-purpose developer tool, not marketing-specific). However, any attempt to use this skill will fail at the Rube MCP integration steps.

**Fix:** Either remove this skill from the VoidAI project (it was likely bundled with the marketingskills package), or configure Rube MCP if the HackerNews research and Slack delivery features are desired.

### WARN-06: Queue Template Path References Use `${SKILL_DIR}` Variable

**File:** `/Users/vew/Apps/Void-AI/queue/templates/image-social-graphic.md`, lines 161-166

```bash
uv run "${SKILL_DIR}/scripts/image.py" \
  --prompt "[FULL PROMPT FROM ABOVE]" \
  --output "/Users/vew/Apps/Void-AI/queue/assets/[FILENAME].png" \
  --model [flash|pro] \
  --aspect [square|landscape|portrait]
```

The template uses `${SKILL_DIR}` which resolves to the Nano Banana Pro plugin's skill directory. This path depends on Claude Code's internal skill resolution. If invoked outside the skill context (e.g., manually by a user or by n8n), `${SKILL_DIR}` will be undefined and the command will fail.

**Fix:** Either:
1. Document that image generation must always be triggered through Claude Code's skill system (not manually)
2. Add a fallback absolute path in the template comments:
   `~/.claude/plugins/marketplaces/buildatscale-claude-code/plugins/nano-banana-pro/skills/generate/scripts/image.py`

---

## MISSING INTEGRATIONS

### MISS-01: No X API (Official) MCP or Configuration

CLAUDE.md references the official X API as the primary data source (per security audit remediation). The compliance pre-launch checklist item 5.6 states: "use official X API as primary source." However, no X API configuration exists anywhere -- no MCP server, no API keys, no integration code.

The project currently relies entirely on:
- Apify `api-ninja/x-twitter-advanced-search` for scraping (monthly research)
- Manual posting (no posting API configured)

For the planned n8n workflows (posting automation, engagement tracking), an official X API integration is required.

**Recommended:** Set up X API developer account and configure for both data reading and posting. This is a prerequisite for automated posting in Phase 3+.

### MISS-02: No Google Analytics MCP (Deferred but Referenced)

Per `project_deferred_mcps.md` in memory, Google Analytics MCP is deferred to Phase 3/4. However, seomachine's Python analytics pipeline (`google_analytics.py`, `google_search_console.py`) requires GA4/GSC credentials independently.

These are two separate integration points:
1. GA4/GSC credentials for seomachine Python scripts (needed now for `/performance-review`)
2. Google Analytics MCP for Claude Code (deferred to Phase 3/4)

Ensure these are tracked as separate line items.

### MISS-03: No n8n Integration Configured

CLAUDE.md references "n8n (13 workflows planned)" and the queue manager skill describes n8n reading/writing to `queue/drafts/` and `queue/scheduled/`. However, no n8n instance URL, API key, webhook URLs, or configuration exists in the project.

This is expected for the current phase (Build > Test) but should be tracked for Phase 3 readiness.

### MISS-04: Genmedia MCP (Veo/Lyria) Not Configured (Expected -- Deferred)

Per memory notes, Genmedia MCP (for Google Veo video generation and Lyria audio) is deferred to Phase 3/4. The `video-google-veo.md` template references this tool. Currently non-functional for video generation.

This is documented and expected.

### MISS-05: Hermes Agent / ElizaOS Not Configured

CLAUDE.md references:
- "Hermes Agent (content orchestrator)"
- "ElizaOS (Web3 community bot)"

Neither has any configuration, MCP server, installation, or integration code in the project. These appear to be planned but not yet set up.

---

## SECURITY CONCERNS

### SEC-01: Taostats API Key in `.claude.json` (See CRIT-01)

The full API key `[REDACTED -- rotate immediately]` was stored in plaintext. This key was also visible in the system reminder context that gets injected into Claude sessions, meaning it may be logged in conversation histories, cached by the model, or visible in tool output.

**Immediate action:** Rotate this key on Taostats and store the new one in an environment variable.

### SEC-02: Multiple CLI Tools Have API Key Patterns But Proper Dry-Run Guards

Files found in `.agents/marketingskills/tools/clis/`:
- `coupler.js` -- masks Authorization header in dry run (`'***'`)
- `resend.js` -- masks Authorization header in dry run (`'***'`)
- `buffer.js` -- masks Authorization header in dry run (`'***'`)

These tools read API keys from environment variables and properly mask them in dry-run mode output. This is good practice. However, verify that none of these env vars (`BUFFER_API_KEY`, `RESEND_API_KEY`, `COUPLER_API_KEY`) are set to real values yet -- they should remain unset until those integrations are needed.

### SEC-03: NotebookLM MCP Has No Authentication Configuration

**File:** `.claude.json`, lines 569-576

```json
"notebooklm": {
  "type": "stdio",
  "command": "npx",
  "args": ["notebooklm-mcp@latest"],
  "env": {}
}
```

The `env` block is empty. NotebookLM MCP authentication relies on Chrome browser-based OAuth (first-time auth). This means:
- Auth state is stored locally in the browser/system keychain
- If Chrome auth expires or the session is invalidated, the MCP will fail silently
- There is no env-var-based fallback or token refresh mechanism
- Running in a headless/CI environment will not work

**Risk:** Low for current manual use, but a reliability concern for automated workflows. Document the re-authentication procedure.

### SEC-04: `npx notebooklm-mcp@latest` Pulls Latest Unpinned Version

The NotebookLM MCP server command uses `@latest`, meaning every invocation pulls the latest published version from npm. This creates a supply chain risk -- a compromised version could:
- Exfiltrate notebook contents
- Inject content into notebooks
- Access Google account data

**Fix:** Pin to a specific version: `npx notebooklm-mcp@1.x.x` (replace with current working version).

---

## IMPROVEMENTS

### IMP-01: Add MCP Health Check to Pre-Launch Checklist

The pre-launch checklist (`/Users/vew/Apps/Void-AI/compliance/pre-launch-checklist.md`) covers legal, disclosure, and security items but does not include a "verify all MCP servers are functional" item. Add a section:

- [ ] Verify Taostats MCP responds (test data tool)
- [ ] Verify NotebookLM MCP responds (test notebook list)
- [ ] Verify Nano Banana Pro image generation works (test with simple prompt)
- [ ] Verify `GEMINI_API_KEY` env var is set
- [ ] Verify seomachine API credentials (DataForSEO, GA4, GSC, WordPress)
- [ ] Verify Apify access for X scraping

### IMP-02: Consolidate MCP Documentation

MCP server information is scattered across:
- `.claude.json` (actual config)
- `reviews/step2-seomachine-install.md` (seomachine setup)
- `project_deferred_mcps.md` (deferred items in memory)
- CLAUDE.md (tool references)
- Queue templates (tool field references)

Consider creating a single `integrations/README.md` that maps all tools, their config locations, required credentials, and current status.

### IMP-03: Add Taostats URL `?tools=` Parameter Validation

The Taostats MCP URL includes `?tools=data,docs,api` which filters available tools. Verify these are the correct/desired tool categories. If Taostats offers additional tool categories that would benefit the marketing workflow (e.g., price data, subnet metrics, validator stats), they may be missing.

### IMP-04: NotebookLM Library Needs VoidAI-Specific Metadata

The `voidai` notebook entry in the library has generic placeholder metadata:

```json
{
  "id": "voidai",
  "use_cases": [
    "Learning about VoidAI",
    "Implementing features with VoidAI"
  ]
}
```

These use cases are auto-generated placeholders. Update them to reflect actual marketing use cases:
- "Generating podcast episodes about VoidAI bridge and ecosystem updates"
- "Research source for content generation"
- "Source material for blog post drafts"

### IMP-05: Consider Adding Fetch MCP to Project Scope

The `fetch` MCP is disabled at the `/Users/vew` project scope (line 367) and the X-L2 project scope (line 466). For the marketing project, web fetching would be useful for:
- Pulling live data from Taostats web UI
- Fetching competitor pages for analysis
- Checking VoidAI product URLs (`app.voidai.com/bridge-chains`, etc.)
- Verifying blog posts after publishing

Consider enabling `fetch` specifically for the VoidAI project scope.

---

## Summary

| Category | Count | Items |
|----------|-------|-------|
| Critical Bugs | 2 | CRIT-01 (Taostats key exposed), CRIT-02 (NotebookLM wrong active notebook) |
| Warnings | 6 | WARN-01 through WARN-06 |
| Missing Integrations | 5 | MISS-01 through MISS-05 |
| Security Concerns | 4 | SEC-01 through SEC-04 |
| Improvements | 5 | IMP-01 through IMP-05 |

### Priority Actions (Ordered)

1. **Rotate Taostats API key** and move to env var (CRIT-01 / SEC-01)
2. **Set NotebookLM active_notebook_id to "voidai"** (CRIT-02)
3. **Pin NotebookLM MCP version** instead of `@latest` (SEC-04)
4. **Verify `GEMINI_API_KEY` is set** for image generation (WARN-04)
5. **Complete seomachine credential setup** for blog content pipeline (WARN-02)
6. **Clarify Composio status** -- install or remove references (WARN-03)
7. **Set up X API** for posting automation prerequisites (MISS-01)
