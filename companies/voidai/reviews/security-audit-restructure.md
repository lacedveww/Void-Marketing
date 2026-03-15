# Security Audit: Universal Marketing Engine Restructure

**Auditor:** Security Auditor (Claude Opus 4.6)
**Date:** 2026-03-13
**Scope:** Post-restructure security audit of the universal marketing engine at `/Users/vew/Apps/Void-AI/`
**Classification:** CONFIDENTIAL -- Internal Use Only

---

## Executive Summary

The restructure from the 595-line monolithic `CLAUDE.md` to the universal engine architecture is **structurally sound from a security perspective**. Compliance rules were faithfully migrated with no substantive omissions. Prompt injection safeguards are present at both the universal (CLAUDE.md) and engine (base-rules.md) layers. Content drafts are clean -- no prohibited phrases in content bodies, no em dashes, no banned AI phrases, and no prompt injection vectors found.

This audit identifies **2 critical findings, 3 high findings, 4 medium findings, and 3 low findings**. The critical findings are inherited from the prior MCP integrations audit (Taostats API key exposure) and stale backup files containing the full pre-restructure system that should be removed. None of the findings block launch, but the critical items require near-term action.

**Overall assessment: PASS with conditions.** The restructure improved security posture by separating universal compliance from company-specific rules, establishing a clear priority hierarchy, and eliminating em dashes from all config files.

---

## Findings Summary

| ID | Severity | Category | Finding |
|----|----------|----------|---------|
| RSA-01 | CRITICAL | Data Leakage | Taostats API key exposed in `~/.claude.json` (inherited, unresolved) |
| RSA-02 | CRITICAL | Data Leakage | `CLAUDE.md.bak` and `CLAUDE.new.md` contain full system config and should be removed |
| RSA-03 | HIGH | Compliance Integrity | OFAC sanctioned regions detail gap between company compliance and engine module |
| RSA-04 | HIGH | Satellite OPSEC | Owned account disclosure in `accounts.md` exposes internal operational details |
| RSA-05 | HIGH | Supply Chain | NotebookLM MCP uses unpinned `@latest` npm package (inherited, unresolved) |
| RSA-06 | MEDIUM | Prompt Injection | Delimiter tag inconsistency between `CLAUDE.md.bak` and restructured files |
| RSA-07 | MEDIUM | Compliance Integrity | Manifest.json shows 0 items in active pipeline but 36 files exist in drafts/ |
| RSA-08 | MEDIUM | Data Leakage | Research files contain X account handles with engagement metrics (PII-adjacent) |
| RSA-09 | MEDIUM | Content Security | All 36 drafts have `compliance_passed: false` -- none have completed the 6-step pipeline |
| RSA-10 | LOW | File Hygiene | CLAUDE.md.bak contains 37 em dashes that were cleaned in the restructure |
| RSA-11 | LOW | Structure | Draft file naming does not follow the canonical pattern from SKILL.md |
| RSA-12 | LOW | Compliance | FCA required risk warning text missing from draft content |

---

## 1. Prompt Injection Safeguards

### Assessment: PASS

The prompt injection safeguards section in `CLAUDE.md` (lines 110-146) is **complete and well-structured**. It includes all three required layers:

**Input Sanitization (lines 116-127):**
- Strip instruction-like patterns: YES (7 patterns specified)
- Remove URLs: YES
- Wrap in XML delimiters: YES (`<user_content>`)
- Length limit: YES (500 chars)
- Character filtering: YES (non-printable, zero-width, unusual Unicode)

**Detection Layer (lines 129-136):**
- Instruction-like context detection: YES
- URL/link promotion detection: YES
- Unusual character pattern detection: YES
- Behavior change detection: YES

**Output Validation (lines 140-145):**
- URL whitelist enforcement: YES
- System prompt leakage prevention: YES
- Persona deviation detection: YES
- Approved entity list enforcement: YES

**Duplication check:** The same safeguards are also present in `engine/compliance/base-rules.md` (lines 99-121). This is intentional redundancy -- the engine file loads for all companies, ensuring safeguards are never bypassed even if CLAUDE.md is not read first. No conflicts between the two copies.

**Finding RSA-06 (MEDIUM):** The old `CLAUDE.md.bak` (line 553) uses the tag `<user_tweet>` while the restructured files use `<user_content>`. The tag was generalized during restructure (correct decision -- the system is now universal, not Twitter-specific). However, any existing code or n8n workflows referencing `<user_tweet>` should be updated. Verify no downstream consumers rely on the old tag name.

**Draft scan for injection vectors:** All 36 drafts in `companies/voidai/queue/drafts/` were scanned. One match found in `20260313-thread-t4-sn106-explained.md` line 75: "Miners act as LPs on @RaydiumProtocol CLMM pools" -- this is normal English usage of "act as," not an injection pattern. **No injection vectors found in any draft.**

---

## 2. Compliance Integrity

### Assessment: PASS -- No rules dropped in restructure

A line-by-line comparison of the compliance sections in `CLAUDE.md.bak` (lines 357-456) against the restructured files found **zero substantive omissions**:

| Compliance Element | CLAUDE.md.bak | Restructured Location | Status |
|---|---|---|---|
| Absolute Prohibitions (12 items) | Lines 361-374 | `companies/voidai/compliance.md` lines 14-27 | MATCH -- all 12 present |
| Language Substitutions (9 rows) | Lines 376-388 | `companies/voidai/compliance.md` lines 29-43 | MATCH -- identical table |
| Context-Dependent Rules | Lines 390-412 | `companies/voidai/compliance.md` lines 45-70 | MATCH -- same rules, same examples |
| Required Disclaimers (7 types) | Lines 414-435 | `companies/voidai/compliance.md` lines 72-100 | MATCH -- all 7 disclaimer types |
| Influencer/Partnership Rules | Lines 437-441 | `companies/voidai/compliance.md` lines 102-106 | MATCH |
| Jurisdictional Compliance | Lines 443-456 | `companies/voidai/compliance.md` lines 108-123 | MATCH -- UK, EU, Singapore, UAE |
| Human Review Gate | Lines 458-472 | `companies/voidai/compliance.md` lines 125-141 | MATCH -- 10-item checklist identical |
| OFAC Countries | Line 447 | `companies/voidai/compliance.md` line 112 | See RSA-03 |
| Banned AI Phrases (21 items) | Lines 50-74 | `CLAUDE.md` lines 48-73 + `engine/compliance/base-rules.md` lines 50-74 | MATCH -- all 21 phrases |
| Crisis Protocol | Lines 474-535 | `companies/voidai/crisis.md` | MATCH -- all sections migrated |
| Prompt Injection Safeguards | Lines 539-571 | `CLAUDE.md` lines 110-146 + `engine/compliance/base-rules.md` lines 99-121 | MATCH |

**Finding RSA-03 (HIGH):** The OFAC sanctions list has a detail gap. The engine module `crypto-ofac.md` (line 15) correctly specifies "Russia (Crimea, Donetsk, Luhansk regions specifically; broader Russia sanctions may apply)". The company-level `compliance.md` (line 112) only says "Russia/Crimea" without mentioning Donetsk and Luhansk. While the engine module is loaded additively and covers this, the company-level file should be updated to match to prevent confusion if someone reads only the company compliance file.

**Engine compliance modules verified:**
- `crypto-sec.md`: Howey Test avoidance (4 prongs with writing guide), 29 prohibited terms, 9 substitution rows, 6 disclaimer templates, 12 context-dependent review triggers, competitor mention rules. COMPREHENSIVE.
- `crypto-ofac.md`: 5 sanctioned countries/regions, marketing restrictions, engagement restrictions, advertising geo-exclusions, jurisdictional disclaimer template, lead filtering implementation. COMPREHENSIVE.
- `crypto-fca.md` and `crypto-mica.md`: Present in `/engine/compliance/modules/` (not read in detail for this audit as the focus was on restructure integrity, but file existence confirmed).

---

## 3. Data Leakage / Sensitive Information

### Assessment: CONDITIONAL PASS

**Finding RSA-01 (CRITICAL -- Inherited):** The Taostats API key is stored in plaintext in `~/.claude.json` as documented in the prior MCP integrations audit (`AUDIT-mcp-integrations.md`, CRIT-01 / SEC-01). The key `tao-104ff5b2-c47e-42f0-9115-2bdddbb7cda3:fb7c4f1a` is visible in the audit report itself (lines 36-37 of `AUDIT-mcp-integrations.md`). This finding remains OPEN and UNRESOLVED. The key should be rotated immediately and moved to an environment variable.

**OWASP Reference:** A2:2017 -- Broken Authentication, CWE-798 (Use of Hard-coded Credentials)

**Recommended fix:**
1. Rotate the Taostats API key immediately (the old key is now documented in a file within this repo)
2. Store the new key in an environment variable (e.g., `TAOSTATS_API_KEY`)
3. Update `~/.claude.json` to reference the env var
4. Restrict permissions: `chmod 600 ~/.claude.json`
5. Redact the key from `AUDIT-mcp-integrations.md` lines 36-37

**Finding RSA-02 (CRITICAL):** Two files remain at the repository root after restructure:
- `/Users/vew/Apps/Void-AI/CLAUDE.md.bak` (39,759 bytes, 595 lines) -- the complete pre-restructure monolithic config
- `/Users/vew/Apps/Void-AI/CLAUDE.new.md` (9,427 bytes) -- identical to current CLAUDE.md

`CLAUDE.md.bak` contains the full VoidAI marketing system including all compliance rules, satellite account strategy, crisis protocol, voice patterns, and operational details. While it does not contain API keys or secrets, it is a complete operational playbook that should not remain as an untracked file. If this repository is ever made public or shared, the backup exposes the entire system architecture including satellite account OPSEC details.

**Recommended fix:**
1. Verify the restructure is complete and validated
2. Delete `CLAUDE.md.bak` and `CLAUDE.new.md`
3. If retention is desired, move to a `.archive/` directory with a `.gitignore` entry

**Scan results for secrets across `companies/voidai/`:**

| Pattern Searched | Files Matched | Assessment |
|---|---|---|
| API keys (sk-, tao-, Bearer) | 16 files | All matches are documentation references (audit reports, architecture docs) describing where keys should go -- no actual key values found in company files |
| Wallet addresses (0x...) | 0 files | CLEAN |
| Seed phrases / mnemonics | 0 files | CLEAN |
| Passwords | 0 files | CLEAN |
| Internal/staging URLs | 1 file (`x-lead-nurturing-architecture.md` line 1768) | `localhost:{port}` is a placeholder in architecture documentation, not an exposed endpoint. Acceptable. |

**`.mcp/` directory check:** The `companies/voidai/.mcp/taostats-mcp/` directory contains only a `.gitignore`, `LICENSE`, and empty `README.md`. No credentials, no configuration, no code. CLEAN.

---

## 4. Content Draft Security

### Assessment: PASS -- All 5 spot-checked drafts are clean

**Drafts spot-checked:**

| Draft | Em Dashes | Banned AI Phrases | Prohibited Terms | Disclaimer | Notes |
|---|---|---|---|---|---|
| `tweet-x7-bridge-4chains.md` | None | None | None in content | N/A (no financial claims) | Missing standard disclaimer -- see RSA-12 |
| `tweet-x11-lending-teaser.md` | None | None | None in content | N/A (teaser, no claims) | Compliance-safe: no rates, no promises |
| `blog-b1-what-is-voidai.md` | None | None | None in content | Full long-form disclaimer present | Excellent compliance notes in editor section |
| `thread-t3-bittensor-post-halving.md` | None | None | None in content | Short + long disclaimer on parts 1 and 9 | Well-structured 9-part thread |
| `lt1-lending-teaser-1.md` | None | None | None in content | Short disclaimer present | Cryptic hook, no product naming -- good OPSEC |

**Bulk scan of all 36 drafts:**
- Em dashes (Unicode U+2014): **0 found** across all 36 files. All dashes use `--` (double hyphen) as required.
- Banned AI phrases (21 patterns): **0 found** across all 36 files.
- Prohibited compliance terms in content body: **0 found**. 7 files matched grep but all matches were in `<!-- Editor Notes -->` compliance verification sections, not in publishable content.
- Prompt injection patterns: **0 found**. 1 match ("act as") was normal English in context.

**Finding RSA-09 (MEDIUM):** All 36 drafts have `compliance_passed: false` and `prohibited_language: "unchecked"` in their frontmatter. None have completed the formal 6-step compliance pipeline defined in the queue manager SKILL.md. While the content itself appears clean from manual inspection, the system's own compliance gate has not been run. Before any content moves to `review/` or `approved/`, each item should have a formal `/queue check` run that sets the compliance fields properly.

**Finding RSA-12 (LOW):** The `tweet-x7-bridge-4chains.md` draft does not include the standard short disclaimer ("Not financial advice. Digital assets are volatile and carry risk of loss. DYOR."). The frontmatter claims `disclaimer_included: true` but no disclaimer text appears in the content body. The tweet references a bridge URL and mentions wTAO:TAO peg, which could be interpreted as promotional financial content. A short disclaimer should be appended, or the frontmatter should be corrected to `disclaimer_included: false` so the compliance pipeline catches it.

---

## 5. File Permissions and Structure

### Assessment: PASS

**File permissions:**

| File/Directory | Permissions | Assessment |
|---|---|---|
| `CLAUDE.md` | `-rw-r--r--` (644) | Standard, not world-writable. OK. |
| `CLAUDE.md.bak` | `-rw-r--r--` (644) | Standard. File should be deleted (RSA-02). |
| `CLAUDE.new.md` | `-rw-r--r--` (644) | Standard. File should be deleted (RSA-02). |
| `queue/drafts/` directory | `drwxr-xr-x` (755) | Standard. OK. |
| Draft files | `-rw-r--r--` (644) | Standard. OK. |

No world-writable files found. All files have owner-write, group-read, world-read permissions which is the macOS default. This is acceptable for a local development environment.

**Manifest.json structure check:**

**Finding RSA-07 (MEDIUM):** The `manifest.json` shows `"drafts": 0` but there are 36 files in the `queue/drafts/` directory. The manifest lists only 1 item (a rejected test post). This means the manifest is stale and does not reflect the actual queue state. The queue manager SKILL.md (line 485) specifies that "manifest.json is rebuilt from files on every queue operation. It is never the source of truth -- files are." This is by design, but the current manifest could mislead any n8n workflow or external tool that reads it. Running `/queue rebuild` would resolve this.

**Finding RSA-11 (LOW):** Most draft filenames follow the pattern `20260313-{type}-{slug}.md` but the canonical pattern from SKILL.md (line 38) is `{YYYYMMDD}-{HHMMSS}-{platform}-{account}-{slug}.md`. The existing drafts omit the `HHMMSS` timestamp and some omit the platform/account segments. Example: `20260313-tweet-x7-bridge-4chains.md` should be `20260313-HHMMSS-x-v0idai-bridge-4chains.md`. This is a minor structural inconsistency that would cause issues if the queue system tries to parse filenames programmatically.

---

## 6. Satellite Account OPSEC

### Assessment: CONDITIONAL PASS

The satellite account strategy in `companies/voidai/accounts.md` is well-designed with strong OPSEC foundations:

**Strengths:**
- Random organic handles (no VoidAI branding in handles)
- FTC-compliant bio disclosure (@v0idai mentioned in every satellite bio)
- Pinned tweet disclosure requirement
- Inter-account coordination rules prevent astroturfing detection (no cross-RT, 2-hour stagger minimum, no identical phrasing)
- Explicit "never more than 2 satellites active in same 30-minute window" rule
- Cross-promotion hard limits (main account max 1 RT/week per satellite, satellites max 2 @v0idai mentions/week)

**Finding RSA-04 (HIGH):** The "Owned Accounts (Internal Assets)" section at the bottom of `accounts.md` (lines 182-190) explicitly names `@SubnetSummerT` and `@gordonfrayne` as VoidAI-owned accounts with operational notes about their previous management ("Previously run by Alchemist (former marketing lead)"). This section:

1. Creates an operational linkage between these accounts and VoidAI that could be discovered if this file is ever exposed
2. Names a former employee by role ("Alchemist (former marketing lead)") which is internal organizational information
3. States these accounts "May be repurposed or integrated into 6-account strategy" which reveals the strategic intent

**Recommended fix:** This information is necessary for internal tracking but should be marked with a clear "INTERNAL ONLY -- DO NOT PUBLISH" header. Consider whether the former employee's role/name is necessary in this file or whether a reference to a separate, more restricted internal document would be safer. If this repo is ever shared with contractors, partners, or made semi-public, this section would compromise OPSEC.

**Bio disclosure consistency check:** All 5 satellite account bios in `accounts.md` include @v0idai mention:
- Account 2 (Fanpage): "Fan account for VoidAI (@v0idai)" -- YES
- Account 3 (Bittensor): "Powered by VoidAI (@v0idai)" -- YES
- Account 4 (DeFi): "Built by the VoidAI team (@v0idai)" -- YES
- Account 5 (AI x Crypto): "VoidAI community (@v0idai)" -- YES
- Account 6 (Meme/Culture): "Community page by VoidAI fans (@v0idai)" -- YES

**Note on Account 4 bio:** The phrasing "Built by the VoidAI team" is more explicit than the other satellites which use "fan," "community," or "powered by." This phrasing directly admits VoidAI team operation rather than community/fan framing. Consider aligning to "VoidAI community (@v0idai)" or "Tracking cross-chain DeFi for VoidAI (@v0idai)" to maintain consistent disclosure level without being more explicit than necessary.

---

## Cross-Check: CLAUDE.md.bak vs. Restructured System

### Items Present in Backup but Not in Restructured Files

| Section | CLAUDE.md.bak | Restructured Location | Status |
|---|---|---|---|
| Design System Reference | Lines 348-356 | `companies/voidai/design-system.md` (expected) | Not verified in this audit -- check file exists |
| SEO tools (Composio) | Line 592 | `companies/voidai/company.md` line 54 | Present but Composio is not installed (documented in AUDIT-mcp-integrations.md WARN-03) |
| n8n (13 workflows) | Line 594 | `companies/voidai/company.md` line 56 | Present |
| AI Agents (Hermes, ElizaOS) | Line 595 | `companies/voidai/company.md` lines 57 | Present |
| Voice calibration triggers (quantitative thresholds) | Lines 305-318 | `engine/frameworks/voice-calibration-loop.md` (referenced from CLAUDE.md line 99) | Not verified in this audit -- reference exists |

**Finding RSA-10 (LOW):** `CLAUDE.md.bak` contains 37 em dashes (Unicode U+2014) throughout its content. The restructured files have zero. This confirms the restructure properly cleaned all em dashes. This is a formatting hygiene finding only, but it is another reason to delete the backup file -- it represents the pre-remediation state and could cause confusion if accidentally referenced.

---

## Recommended Actions (Priority Order)

### Critical (Action Within 24 Hours)

1. **RSA-01: Rotate Taostats API key** and move to environment variable. Redact from `AUDIT-mcp-integrations.md`.
2. **RSA-02: Delete `CLAUDE.md.bak` and `CLAUDE.new.md`** from repository root after confirming restructure completeness.

### High (Action Within 1 Week)

3. **RSA-03: Update `companies/voidai/compliance.md` line 112** to include Donetsk and Luhansk regions alongside Crimea, matching the engine module's OFAC detail level.
4. **RSA-04: Add "INTERNAL ONLY" marker** to the Owned Accounts section in `accounts.md`. Consider moving former employee details to a separate restricted document.
5. **RSA-05: Pin NotebookLM MCP version** in `~/.claude.json` instead of using `@latest`.

### Medium (Action Within 2 Weeks)

6. **RSA-06: Document the `<user_tweet>` to `<user_content>` delimiter change** so any existing code referencing the old tag is updated.
7. **RSA-07: Run `/queue rebuild`** to regenerate manifest.json from the 36 actual draft files.
8. **RSA-08:** Review research files containing X account handles. If any of these accounts were scraped without consent and the data is personally identifiable, consider anonymizing handles in files that might be shared externally.
9. **RSA-09: Run `/queue check` on all 36 drafts** to complete the formal compliance pipeline before any content moves to review status.

### Low (Address When Convenient)

10. **RSA-10:** Covered by RSA-02 (delete backup files).
11. **RSA-11:** Standardize draft filenames to match the canonical `{YYYYMMDD}-{HHMMSS}-{platform}-{account}-{slug}.md` pattern, or document the simplified pattern as an accepted variant.
12. **RSA-12:** Add short disclaimer to `tweet-x7-bridge-4chains.md` or correct its `disclaimer_included` frontmatter field.

---

## Security Checklist Summary

| Check | Result |
|---|---|
| Prompt injection safeguards in CLAUDE.md | PASS -- all 3 layers present and complete |
| Prompt injection safeguards in engine base-rules | PASS -- redundant copy, no conflicts |
| Prompt injection patterns in drafts | PASS -- 0 vectors found in 36 files |
| Compliance rules fully migrated from monolith | PASS -- 0 substantive omissions |
| Absolute prohibitions (12 items) | PASS -- all present in company compliance |
| Language substitutions (9 rows) | PASS -- identical tables |
| Disclaimers (7 types) | PASS -- all migrated |
| Howey Test avoidance guidance | PASS -- comprehensive in crypto-sec.md |
| OFAC sanctioned countries | CONDITIONAL -- Donetsk/Luhansk detail gap (RSA-03) |
| Banned AI phrases in drafts | PASS -- 0 found |
| Em dashes in drafts | PASS -- 0 found |
| Prohibited terms in draft content bodies | PASS -- 0 found (7 matches were in editor notes only) |
| API keys / secrets in company files | PASS -- 0 actual credentials found |
| Wallet addresses in company files | PASS -- 0 found |
| Internal URLs exposed | PASS -- 1 localhost placeholder in architecture doc, acceptable |
| Satellite bio disclosure | PASS -- all 5 satellites include @v0idai |
| Satellite OPSEC coordination rules | PASS -- comprehensive anti-detection rules |
| File permissions | PASS -- no world-writable files |
| Backup files contain secrets | PASS -- no credentials in .bak or .new files |
| Manifest.json structural integrity | FAIL -- stale, needs /queue rebuild (RSA-07) |
| Human review gate | PASS -- present in CLAUDE.md, company compliance, and base-rules |
| Priority hierarchy | PASS -- 5-level hierarchy clearly defined, compliance always wins |

---

## OWASP and Regulatory References

| Finding | OWASP / Regulatory Reference |
|---|---|
| RSA-01 (API key exposure) | OWASP A2:2017 Broken Authentication, CWE-798 Hard-coded Credentials |
| RSA-02 (Stale backup files) | OWASP A3:2017 Sensitive Data Exposure, CWE-538 Insertion of Sensitive Information |
| RSA-03 (OFAC detail gap) | OFAC SDN List, 31 CFR Part 501 |
| RSA-04 (Internal ops disclosure) | CWE-200 Exposure of Sensitive Information |
| RSA-05 (Unpinned npm package) | OWASP A9:2017 Using Components with Known Vulnerabilities, CWE-829 |
| RSA-06 (Delimiter inconsistency) | CWE-74 Improper Neutralization (Injection) |
| RSA-09 (Unchecked compliance) | FTC Section 5, SEC Howey Test |
| RSA-12 (Missing disclaimer) | FTC 16 CFR Part 255, UK FCA crypto promotion rules |

---

## Changelog

| Date | Change | Author |
|---|---|---|
| 2026-03-13 | Initial post-restructure security audit | Security Auditor (Claude Opus 4.6) |
