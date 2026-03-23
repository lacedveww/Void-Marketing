# Compliance & Brand Framework Audit

**Auditor:** Code Reviewer (Claude Opus 4.6)
**Date:** 2026-03-13
**Scope:** CLAUDE.md, compliance/, brand/, research/, queue-manager SKILL.md
**Methodology:** Cross-referencing all compliance rules against enforcement mechanisms, checking for gaps, conflicts, and missing areas

---

## CRITICAL RISKS (Legal/Regulatory Exposure)

### CR-1: "Allocation" and "Airdrop" Are Not in the Prohibited Language Scanner

**Location:** CLAUDE.md Compliance Rules vs. queue-manager SKILL.md Step 1

The `content-review-rules.md` (Section 3, Category A) correctly adds "allocation" and "airdrop" as prohibited terms. However, `CLAUDE.md` itself does not list these in its Required Language Substitutions table or Absolute Prohibitions section. The queue-manager SKILL.md Step 1 (Category A Word Scan) derives its blocked terms list from CLAUDE.md, not from `content-review-rules.md`.

**Risk:** Content generated via `/queue add` scans against CLAUDE.md's prohibitions. If "allocation" and "airdrop" are not in CLAUDE.md's prohibition list, the automated scanner will miss them. The pre-launch checklist item 1.11 calls for adding these, but it is still unchecked.

**Fix:** Add "allocation" (in context of rewards/airdrops) and "airdrop" (as incentive for actions) to CLAUDE.md's Absolute Prohibitions list. Until then, these terms bypass the automated compliance check.

**Severity:** CRITICAL -- these terms have direct SEC enforcement precedent (SEC v. LBRY, SEC v. Ripple).

---

### CR-2: No Disclaimer Template for Video Content

**Location:** CLAUDE.md Required Disclaimers vs. queue-manager SKILL.md Step 4

CLAUDE.md defines disclaimer templates for social posts (short form), blog posts (long form), rates/APY discussions, lending/bridging discussions, and staking framing. It does NOT define a disclaimer template for video content or podcast content.

The queue-manager SKILL.md Step 4 (Disclaimer Verification) checks disclaimers by platform but only lists: X (single), X (thread), LinkedIn, Blog, and Discord. There is no disclaimer check for video, podcast, YouTube, or Telegram content types.

The `research/us-compliance-guide.md` (Section 10) provides video disclaimer templates (spoken + description), but these have NOT been adopted into CLAUDE.md.

**Risk:** Video scripts and podcast briefs generated via `/queue add --type video` or `--type podcast` will pass the disclaimer check vacuously (no requirement defined = no failure). Video content without spoken disclaimers is an FTC violation risk, especially for any content that could be construed as promotional.

**Fix:**
1. Add video and podcast disclaimer templates to CLAUDE.md Required Disclaimers section (adopt from `research/us-compliance-guide.md` Section 10).
2. Add video, podcast, YouTube, and Telegram rows to queue-manager SKILL.md Step 4 disclaimer verification table.

**Severity:** CRITICAL -- FTC Section 5 applies to video content; the SEC has prosecuted video-based crypto promotions (Kim Kardashian precedent).

---

### CR-3: No Email Disclaimer in CLAUDE.md

**Location:** CLAUDE.md Required Disclaimers, compliance/data-handling-policy.md

CLAUDE.md has no disclaimer template for email marketing content. The `research/us-compliance-guide.md` (Section 10) provides email header and footer disclaimers, and the `compliance/pre-launch-checklist.md` (Section 4) addresses CAN-SPAM requirements, but no email disclaimer template exists in the authoritative CLAUDE.md source.

**Risk:** When Mautic email campaigns begin, there is no CLAUDE.md-level standard for AI-generated email content. Email content generated through the queue system has no disclaimer template to check against. CAN-SPAM penalties are $43,792 per violation.

**Fix:** Add email marketing disclaimer template (header + footer) to CLAUDE.md Required Disclaimers section. Add "email" as a platform type in the queue-manager disclaimer verification step.

**Severity:** CRITICAL -- CAN-SPAM and CASL carry per-email penalties.

---

### CR-4: UK FCA Required Warning Text Not in Any Disclaimer Template

**Location:** CLAUDE.md Jurisdictional Compliance

CLAUDE.md correctly identifies the UK FCA requirement: "Don't invest unless you're prepared to lose all the money you invest." However, this mandatory text is NOT included in any disclaimer template in CLAUDE.md, content-review-rules.md, or any compliance document. The pre-launch checklist item 7.6 flags this for legal review but is unchecked.

The queue-manager SKILL.md has no jurisdictional disclaimer logic -- it checks for a single platform-based disclaimer, not jurisdiction-specific variants.

**Risk:** Any VoidAI content visible to UK audiences (which includes all public X posts) technically requires the FCA risk warning since October 2023. The FCA has taken enforcement action against crypto promoters who fail to include this. Since VoidAI cannot control who sees its public posts, the most conservative approach is to include FCA-compliant language in the standard disclaimer.

**Fix:** Either (a) incorporate FCA-mandated language into the standard short-form disclaimer, or (b) add a jurisdictional disclaimer layer to the queue-manager compliance check that appends jurisdiction-specific warnings when content is public-facing. Option (a) is simpler and more conservative.

**Severity:** CRITICAL -- FCA has actively fined crypto companies for non-compliant social media promotions since 2023.

---

### CR-5: Lending Platform Marketing Has No Compliance Templates

**Location:** CLAUDE.md, compliance/content-review-rules.md

Multiple pre-launch checklist items (1.2, 1.5, 1.6, 1.9) relate to lending platform marketing. The lending platform is described as "upcoming" in CLAUDE.md. However, there are no lending-specific content templates, no lending-specific disclaimer variations, and no lending-specific Howey Test guidance in the queue templates directory.

The `research/us-compliance-guide.md` (Section 6) provides guidance on marketing lending safely, and `compliance/content-review-rules.md` (Section 5) has one lending example, but these have not been operationalized into queue templates.

**Risk:** When the lending platform launches, content will be generated without lending-specific compliance guardrails. Lending content triggers multiple Howey prongs simultaneously (investment of money + expectation of profit + efforts of others). The pre-launch checklist items are all unchecked, meaning this entire area is unaddressed.

**Fix:** Before lending launch, create lending-specific content templates in `queue/templates/` that embed the required disclaimers (smart contract risk, liquidation risk, variable rates, no guarantee). Add lending-specific Category A terms to the scanner: "deposit" (use "supply"), "interest" (use "variable rate rewards"), "collateral ratio" (context-dependent), "guaranteed rate."

**Severity:** CRITICAL -- lending products face the highest regulatory scrutiny. The MSB/FinCEN question (checklist 1.9, 1.10) is unresolved.

---

## ENFORCEMENT GAPS (Rules Exist But Aren't Automated)

### EG-1: Inter-Account Coordination Rules Are Not Machine-Enforceable

**Location:** CLAUDE.md Inter-Account Coordination Rules vs. queue-manager SKILL.md

CLAUDE.md defines detailed inter-account coordination rules:
- Satellite accounts must never retweet each other directly
- Never use identical phrasing across accounts for the same event
- If one account goes viral, other accounts must not pile on

The queue-manager SKILL.md implements the `/queue stagger` command and timing-based stagger rules (2/3/4 hour delays). However, there is no automated check for:
- Identical or substantially similar phrasing across accounts (the stagger command assigns timing but does not compare content text)
- Whether a satellite account has been set to retweet another satellite (this would happen at the X API level, outside the queue system)
- Viral pile-on detection (no engagement monitoring in the queue system)

**Gap:** The timing rules are enforceable; the content differentiation and behavioral rules are not. These depend entirely on human judgment during review.

**Recommendation:** Add a phrasing similarity check to `/queue stagger` -- when items share a `stagger_group`, compare content bodies for >30% text overlap (simple Jaccard similarity or cosine similarity on word tokens). Flag items that are too similar. For RT prevention and viral pile-on rules, document these as human-review-only items in the review card.

---

### EG-2: L33tspeak and Misspelling Variants Not Defined

**Location:** queue-manager SKILL.md Step 1, compliance/content-review-rules.md Section 4.1

Both documents state that the Category A word scan should check for "common misspellings and l33tspeak" variants. However, neither document defines what these variants are. There is no list of l33tspeak mappings (e.g., "gu4r4nteed", "r1sk-free", "pa$$ive inc0me") or common misspellings.

**Gap:** The instruction to check for l33tspeak is aspirational, not operational. Without a defined list or pattern-matching algorithm, this check depends entirely on the AI model's judgment, which may miss novel obfuscations.

**Recommendation:** Either (a) define a canonical l33tspeak character mapping table (a->4, e->3, i->1, o->0, s->5, t->7) and apply it to all Category A terms to generate variants, or (b) use fuzzy string matching with a defined similarity threshold (e.g., Levenshtein distance <= 2) for Category A terms. Document the approach in the SKILL.md.

---

### EG-3: Prompt Injection Safeguards Are Documented But Not Implemented

**Location:** CLAUDE.md Prompt Injection Safeguards vs. queue-manager SKILL.md

CLAUDE.md defines a detailed prompt injection defense: input sanitization (strip instruction patterns, remove URLs, XML delimiters, length limits, character filtering), a detection layer (flag for human review), and output validation (no new URLs, no system prompt leakage).

The queue-manager SKILL.md Section 4.3 of content-review-rules.md references prompt injection detection, but the queue-manager compliance check sequence (Steps 1-6) does NOT include a prompt injection check step. There is no Step 7 for input sanitization or output validation.

**Gap:** If n8n workflows write content to `queue/drafts/` based on scraped user tweets (e.g., news-monitor, competitor-monitor workflows), the user-generated content passes through without the sanitization described in CLAUDE.md. The queue compliance check only runs word scans, disclaimer checks, and Howey scoring -- it does not sanitize input or validate output against prompt injection patterns.

**Recommendation:** Add a Step 0 (pre-scan) to the queue-manager compliance check: if `source_workflow` is not "manual", apply CLAUDE.md's prompt injection sanitization rules before running Steps 1-6. Add a Step 7 (post-scan) for output validation. Alternatively, require n8n workflows to sanitize input before writing to the queue (but this distributes responsibility and is harder to audit).

---

### EG-4: OFAC Jurisdictional Filtering Is Not in the Queue System

**Location:** CLAUDE.md Jurisdictional Compliance, compliance/pre-launch-checklist.md Section 7

CLAUDE.md states: "NEVER engage with users from OFAC-sanctioned countries." The pre-launch checklist has detailed jurisdictional filtering items (7.1-7.8). The `content-review-rules.md` Section 4.4 describes a jurisdictional check.

However, the queue-manager SKILL.md compliance check sequence has no jurisdictional check step. Items in the queue are not tagged with target geography, and there is no mechanism to prevent scheduling content that targets restricted jurisdictions.

**Gap:** The queue system is designed for content creation and scheduling, not for engagement routing (that is the lead nurturing system's job). However, if content is specifically geo-targeted (e.g., a blog post about UK DeFi regulations), there is no queue-level check for jurisdictional appropriateness.

**Recommendation:** Add an optional `target_jurisdiction` field to content item frontmatter. If set, the compliance check should verify that the jurisdiction is not OFAC-sanctioned and that jurisdiction-specific disclaimers are present. For general public content, this field can be null (no check needed, but standard disclaimers apply).

---

### EG-5: Satellite Account 30-Day Full Review Period Is Not Auto-Enforced

**Location:** CLAUDE.md (implied), content-review-rules.md Section 1

Content-review-rules.md states: "All content for the first 30 days of any new satellite account" triggers Tier 1 mandatory review. The queue-manager SKILL.md Step 6 repeats this rule.

However, there is no mechanism to track when a satellite account was created, nor to auto-calculate whether the 30-day window has elapsed. The review tier assignment depends on the AI correctly remembering this rule and knowing the account creation date.

**Gap:** If the account creation date is not stored anywhere machine-readable, this rule cannot be reliably enforced. After 30 days, there is no trigger to transition satellite accounts from Tier 1 to their standard tier.

**Recommendation:** Add an `account_created_at` field to the queue manifest or a dedicated `queue/config.json` file. The compliance check should compare the current date against `account_created_at` for each satellite account and auto-force Tier 1 if within 30 days.

---

### EG-6: Voice Calibration Triggers Are Not Measurable Without Data

**Location:** CLAUDE.md Voice Calibration Triggers

CLAUDE.md defines quantitative triggers for updating voice weights:
- Register outperforms/underperforms by >50% for 4+ weeks
- Engagement drops >30% over 2 weeks
- >20% new slang terms in monthly scrape
- Format achieves 3x average engagement for 3+ uses

These triggers are well-defined numerically, but `brand/voice-learnings.md` currently has zero data entries -- only templates. Until real engagement data is logged, none of these triggers can fire. More importantly, there is no automated mechanism to check these thresholds; they depend on a human or AI reading the file and performing the calculation.

**Gap:** The triggers are theoretically sound but operationally inert. There is no scheduled check, no alert mechanism, and no data to evaluate against.

**Recommendation:** This is expected pre-launch (no data exists yet). However, add to the Friday weekly calibration workflow (n8n Workflow) an explicit step that calculates each trigger condition and reports "TRIGGERED / NOT TRIGGERED" with the supporting numbers. This ensures triggers are evaluated weekly rather than ad hoc.

---

### EG-7: Tier 2 "20% Spot-Check" Is Not Operationally Defined

**Location:** content-review-rules.md Section 1, queue-manager SKILL.md

Tier 2 content is described as "auto-queue, 20% spot-check weekly." The queue-manager SKILL.md does not implement this spot-check. There is no mechanism to:
- Randomly select 20% of Tier 2 items for review
- Track which Tier 2 items have been spot-checked
- Alert Vew when the spot-check queue has items

**Gap:** Without implementation, Tier 2 content effectively receives zero review, which is indistinguishable from Tier 3 (auto-post).

**Recommendation:** Add a `/queue spot-check` command that randomly selects 20% of Tier 2 items posted in the past week and presents them as review cards. Add a weekly reminder to the Friday calibration workflow.

---

### EG-8: Batch-Approve Bypasses Human Review Gate

**Location:** queue-manager SKILL.md `/queue batch-approve`

The `/queue batch-approve` command approves all items from a specific source workflow if `compliance_passed: true`. While it requires confirmation, it allows bulk approval without reviewing individual content. CLAUDE.md states: "ALL content must be reviewed by Vew before publishing. AI generates, human approves. No exceptions."

**Gap:** Batch-approve contradicts the "no exceptions" human review gate for Tier 1 content. If a Tier 1 item has `compliance_passed: true` (all automated checks pass), batch-approve could approve it without Vew reading the actual content.

**Recommendation:** Modify `/queue batch-approve` to exclude Tier 1 items. Only Tier 2 and Tier 3 items should be eligible for batch approval. Tier 1 items must always go through the individual review card flow.

---

## MISSING COMPLIANCE AREAS

### MC-1: No Accessibility Compliance (ADA/WCAG)

**Location:** All documents

There is zero mention of accessibility requirements anywhere in the compliance framework. Blog content on voidai.com must comply with WCAG 2.1 AA standards (images need alt text, videos need captions/transcripts, color contrast must meet minimums, interactive elements need keyboard navigation).

VoidAI creates images (social graphics, data cards, infographics), videos (Veo, scripts), and blog posts. None of the queue templates or compliance checks verify accessibility requirements.

**Risk:** ADA Title III lawsuits against websites have increased significantly. While enforcement against crypto sites is currently low, blog content and product pages are standard web content subject to accessibility norms. More practically, inaccessible content excludes potential users.

**Recommendation:** Add accessibility requirements to blog and video content templates: (a) all images must have alt text in the queue item frontmatter, (b) all videos must have transcript or caption reference, (c) infographics must have a text-equivalent description. Add an accessibility check to the compliance sequence for blog and video content types.

---

### MC-2: No CCPA/California Privacy Compliance

**Location:** compliance/data-handling-policy.md

The data-handling-policy.md mentions CCPA once, in the breach notification section (8.3). There is no CCPA-specific section covering:
- Right to know what personal information is collected
- Right to delete personal information
- Right to opt out of sale of personal information
- Right to non-discrimination for exercising rights

The GDPR sections (Sections 2, 5) partially overlap with CCPA requirements, but CCPA has distinct requirements (e.g., "Do Not Sell My Personal Information" link, 12-month lookback period, different categories of personal information).

**Risk:** If VoidAI collects data from California residents (statistically certain given Bittensor's US user base), CCPA requirements apply to businesses that meet the thresholds (25,000 consumers/households, $25M revenue, or 50%+ revenue from selling personal information). Even below thresholds, implementing CCPA safeguards is best practice.

**Recommendation:** Add a CCPA section to data-handling-policy.md. At minimum, document: (a) categories of personal information collected (mapping to CCPA's categories), (b) whether VoidAI "sells" personal information (it does not, per Section 6.2), (c) CCPA-specific rights and how to exercise them. If voidai.com has a privacy policy page, include CCPA-specific disclosures.

---

### MC-3: No Record-Keeping for Compliance Decisions

**Location:** All documents

There is no audit trail requirement for compliance decisions. When Vew approves content through the queue system, the frontmatter records `reviewed_by`, `reviewed_at`, and `review_notes`. However:
- There is no requirement to document WHY a Category B flagged term was deemed acceptable
- There is no log of compliance exceptions or overrides
- There is no record of which version of CLAUDE.md was in effect when content was approved
- Deleted/rejected content retains rejection reasons but no structured compliance rationale

**Risk:** If a regulator or platform investigates VoidAI's content practices, the ability to show a documented, consistent compliance decision-making process is critical. "We had a checklist" is weaker than "Here is the decision log showing how each flagged item was evaluated."

**Recommendation:** Add a `compliance_notes` field to the queue item frontmatter. When Tier 1 items with Category B red flags are approved, require the reviewer to document the compliance rationale (e.g., "yield" used in educational context per CLAUDE.md context-dependent rules, not describing VoidAI product). Consider maintaining a separate `compliance/decision-log.md` for significant compliance decisions.

---

### MC-4: No EU Digital Services Act (DSA) Bot Disclosure

**Location:** compliance/platform-policies.md

The platform-policies.md (Section 1.3) notes that X does not require bot labeling but the EU DSA may. However, there is no concrete DSA compliance plan. The DSA requires that automated accounts be clearly identified as such to EU users.

**Risk:** VoidAI's satellite accounts use automation (n8n-driven content posting). If any EU user interacts with these accounts, DSA bot disclosure requirements may apply. The DSA has been in effect since February 2024, and enforcement is escalating.

**Recommendation:** Add DSA compliance to the satellite account setup checklist: each satellite account bio should include "Automated posts" or similar bot disclosure language. This is already partially recommended in platform-policies.md (Section 1.3) but is not in the CLAUDE.md satellite account requirements.

---

### MC-5: No Anti-Money Laundering (AML) Marketing Considerations

**Location:** All documents

CLAUDE.md states VoidAI is "non-custodial -- we never hold user funds." However, the bridge and lending products facilitate value transfer, and marketing these products could create AML implications:
- Marketing that emphasizes privacy or anonymity features could attract regulatory attention
- Marketing that targets high-value transfers without risk disclosures could be problematic
- The pre-launch checklist (1.9, 1.10) flags MSB/FinCEN questions but these are unresolved

There are no marketing-specific AML guidelines (e.g., "never market the bridge as a way to move funds without oversight" or "never emphasize privacy as a feature of the bridge").

**Risk:** If VoidAI's bridge or lending platform is determined to be an MSB, all prior marketing materials could be scrutinized for AML compliance. Marketing that emphasized ease of cross-border transfers without mentioning regulatory requirements could be used as evidence of negligence.

**Recommendation:** Add a brief AML marketing guidance section to CLAUDE.md: (a) never market the bridge as a privacy tool, (b) never emphasize the ability to move funds "without intermediaries" in a way that implies regulatory avoidance, (c) always include "check local regulations" language when discussing cross-border transfers.

---

## BRAND CONSISTENCY ISSUES

### BC-1: Research Documents Contain Non-Compliant Example Language

**Location:** research/bittensor-ecosystem-marketing.md, research/competitor-defi-marketing.md, research/x-voice-analysis.md

Multiple research documents contain language that violates CLAUDE.md compliance rules:

- `research/bittensor-ecosystem-marketing.md` Section 10.5: "Earn 80%+ APY staking TAO" -- uses "Earn" and "APY" without disclaimer
- `research/bittensor-ecosystem-marketing.md` Section 11: "Top testers get allocation" -- uses "allocation"
- `research/competitor-defi-marketing.md` Section 3: "top testers get allocation" -- same issue
- `research/competitor-defi-marketing.md` Section 3 Launch Week: "Influencer posts go live within 2-hour window" -- violates the staggered influencer launch rule already noted in pre-launch checklist 1.8
- `research/x-voice-analysis.md` Section 5 example tweets contain "yield," "farming," "DeFi access" language applied to VoidAI products

The pre-launch checklist items 6.2 and 6.3 call for adding compliance annotations to the research documents. Both are unchecked.

**Risk:** If an AI agent reads these research files without first reading CLAUDE.md (violating the Voice File Dependencies order), it could generate content using the non-compliant language found in the research. The voice-analysis.md file even has a cross-reference note at the top, but the bittensor-ecosystem and competitor-defi files do not.

**Fix:** Add compliance header notes to `research/bittensor-ecosystem-marketing.md` and `research/competitor-defi-marketing.md` similar to the one already present in `research/x-voice-analysis.md`. Complete pre-launch checklist items 6.2 and 6.3. Add inline annotations to non-compliant example language: "[COMPLIANCE NOTE: 'earn' must be replaced with 'receive' per CLAUDE.md when used for VoidAI content]".

---

### BC-2: Satellite Account Disclaimer Inconsistency

**Location:** CLAUDE.md Required Disclaimers vs. CLAUDE.md Satellite Account Personas vs. pre-launch-checklist.md 2.1.9

CLAUDE.md's Required Disclaimers section defines one short-form disclaimer for social posts:
> "Not financial advice. Digital assets are volatile and carry risk of loss. DYOR."

However, CLAUDE.md's Satellite Account Personas section defines shorter variants:
- Fanpage: "nfa // dyor" or "not financial advice obv"
- Bittensor Community: "Standard short disclaimer"
- DeFi Community: "Informational only -- not financial advice. DYOR."

The pre-launch checklist (2.1.9) attempts to reconcile this by saying satellite accounts may use "Not financial advice. DYOR." (shorter) with a link to full disclaimer in bio.

**Gap:** There are now three different "short-form" disclaimer versions across the documents, and the queue-manager Step 4 only checks for one exact string. Content generated for satellite accounts may use the persona-specific shorter version, which would fail the queue-manager's disclaimer check.

**Recommendation:** Standardize: Define an "acceptable disclaimers" list in the queue-manager Step 4 that includes all approved variations (the full short-form AND the approved abbreviated forms). Document which accounts may use which variants. The current single-string check is too rigid for the multi-account system.

---

### BC-3: "My Play Today" Format Prohibited But Appears in DeFi Account Voice Patterns

**Location:** CLAUDE.md Account 3 Voice Patterns vs. content-review-rules.md Section 2

CLAUDE.md Account 3 (DeFi Community) voice patterns include: "'My play today:' -- personal actionable format (builds trust through transparency)."

However, `compliance/content-review-rules.md` Section 2 (X/Twitter @v0idai main account Prohibited) explicitly prohibits: "'My play today:' or any personal-position format."

The content-review-rules.md prohibition applies to the main account, and the DeFi satellite section is in CLAUDE.md (higher authority). But the "My play today" format inherently implies a financial position, which conflicts with the Absolute Prohibition against "content that could be interpreted as a solicitation to buy, sell, or hold any specific digital asset."

**Risk:** If the DeFi satellite account posts "My play today: bridging TAO to Solana and supplying to VoidAI lending," this simultaneously follows the persona voice pattern AND violates the Absolute Prohibition. The persona instruction and the compliance instruction conflict.

**Recommendation:** Remove "My play today:" from the DeFi account voice patterns in CLAUDE.md. Replace with a compliant alternative like "What I'm watching today:" or "Protocol activity update:" which provides the same transparency format without implying a personal financial position.

---

### BC-4: Content Pillar Weights Are Defined Twice with Identical Values But Different Monitoring

**Location:** CLAUDE.md Content Pillars vs. queue-manager SKILL.md Pillar Distribution Monitoring

CLAUDE.md defines pillar weights: Bridge & Build 40%, Ecosystem Intelligence 25%, Alpha & Education 25%, Community & Culture 10%.

The queue-manager monitors these with a 5% drift threshold. However, the monitoring calculates distribution from "all items in drafts + review + approved + scheduled" -- this means the distribution is based on content created, not content posted.

**Gap:** If many bridge-build items are created but rejected (e.g., compliance issues with lending content), the pillar distribution will show bridge-build at 40% even though the actual posted content might be 20% bridge-build and 60% ecosystem. The monitoring measures input, not output.

**Recommendation:** Track pillar distribution at two points: (a) creation-time (current behavior) and (b) post-time (distribution of items in `posted/`). Alert if the posted distribution drifts from targets by >10%.

---

## IMPROVEMENTS

### IMP-1: Add a Compliance Version Identifier

Every piece of content generated should reference the version of CLAUDE.md in effect when it was created. The CLAUDE.md changelog provides dates, but content items do not reference which compliance version they were checked against. Add a `compliance_version` field to the frontmatter (e.g., "2026-03-13-v2") that corresponds to the CLAUDE.md changelog. This creates an audit trail for regulatory purposes.

---

### IMP-2: Create a "Compliance Quick Reference" Card

CLAUDE.md is 492 lines long. The content-review-rules.md is 441 lines. For the Friday weekly review and day-to-day content generation, create a 1-page quick reference card that lists: (a) the 10 most commonly triggered Category A terms, (b) the 3 disclaimer templates, (c) the Howey prong checklist, (d) the review tier summary. This does not replace the full documents but accelerates compliance checking.

---

### IMP-3: Formalize the Crisis Communication Queue Behavior

CLAUDE.md's Crisis Communication Protocol says to "PAUSE all scheduled content" immediately. The queue-manager SKILL.md has no crisis mode. There is no `/queue crisis` or `/queue pause-all` command.

**Recommendation:** Add a `/queue pause-all` command that: (a) moves all items in `scheduled/` back to `approved/` with a `paused_reason: "crisis"` tag, (b) sets a `crisis_mode: true` flag in `manifest.json`, (c) blocks `/queue schedule` and `/queue schedule-day` until crisis mode is cleared. Add a `/queue resume` command to clear crisis mode.

---

### IMP-4: Add Forward-Looking Statement Disclaimer

The pre-launch checklist (1.4, 1.5, 1.6) references "forward-looking statement disclaimers" multiple times. This is standard for publicly traded companies and increasingly expected for crypto projects. However, no forward-looking statement template exists in CLAUDE.md.

**Recommendation:** Add a forward-looking statement template to CLAUDE.md Required Disclaimers:
> "Statements about future events, products, or performance are forward-looking statements that involve risks and uncertainties. Actual results may differ materially. VoidAI undertakes no obligation to update forward-looking statements."

Use this template whenever content discusses: upcoming product launches, roadmap items, planned features, or projected metrics.

---

### IMP-5: Establish a Compliance Training Checkpoint

The current system assumes that any AI agent reading CLAUDE.md will correctly implement all compliance rules. There is no verification mechanism to confirm the agent understood the rules before generating content.

**Recommendation:** Add a "compliance acknowledgment" step to `/queue add`: before generating content, the system should output a brief summary of which compliance rules apply to the specific content type being created (e.g., "This is X content for DeFi satellite: applying context-dependent language rules, DeFi account persona voice, short-form disclaimer required, Category A + B + C scan will run"). This forces the system to explicitly reason about applicable rules before content generation.

---

### IMP-6: Define "Substantially Similar" for Cross-Account Content

CLAUDE.md prohibits "identical phrasing across accounts for the same event." The word "identical" is too narrow -- content can be substantially similar without being identical. Define a threshold: content across accounts in the same stagger group must differ by at least 60% of words (excluding common stop words and the event name itself).

---

### IMP-7: Add Competitor List Maintenance Schedule

The Category C competitor scan checks for specific names: "Project Rubicon, Wormhole, LayerZero, Axelar, Aave, Compound." The DeFi and bridge landscapes change rapidly. New competitors may emerge that should trigger Tier 1 review.

**Recommendation:** Add a quarterly competitor list review to the compliance maintenance schedule. Document the review in the CLAUDE.md changelog.

---

### IMP-8: Reconcile US Compliance Guide Disclaimer Templates with CLAUDE.md

The `research/us-compliance-guide.md` Section 10 contains 6 detailed disclaimer templates (blog, social, video spoken, video description, landing page above-fold, landing page footer, email header, email footer). CLAUDE.md only contains 4 disclaimer types (social short, blog long, rates/APY, lending/bridging).

The research document's templates are more comprehensive and include elements missing from CLAUDE.md:
- "Nothing in this content should be interpreted as a recommendation to buy, sell, or hold any digital asset"
- "[Company Name] does not custody, control, or manage user funds"
- "This content is not directed at residents of any jurisdiction where distribution is restricted"

**Recommendation:** Adopt the comprehensive templates from the US compliance guide into CLAUDE.md, replacing the current shorter versions. The more detailed disclaimers provide stronger legal protection.

---

## Summary of Findings

| Category | Count | Highest Severity |
|----------|:-----:|-----------------|
| Critical Risks | 5 | Legal/regulatory exposure requiring immediate action |
| Enforcement Gaps | 8 | Rules that cannot be reliably automated |
| Missing Compliance Areas | 5 | Absent regulatory coverage |
| Brand Consistency Issues | 4 | Contradictions between documents |
| Improvements | 8 | Operational enhancements |

**Priority Actions (Before Soft Launch):**
1. Add "allocation" and "airdrop" to CLAUDE.md prohibitions (CR-1)
2. Add video/podcast/email disclaimer templates to CLAUDE.md (CR-2, CR-3)
3. Incorporate FCA warning language into standard disclaimers or add jurisdictional layer (CR-4)
4. Resolve "My play today" conflict between DeFi persona and compliance rules (BC-3)
5. Add crisis mode commands to queue-manager (IMP-3)
6. Implement prompt injection check in queue compliance sequence (EG-3)
7. Fix disclaimer check to accept approved variants per account (BC-2)
8. Add compliance annotations to research documents (BC-1)

---

*This audit was conducted by reviewing all compliance, brand, and research documentation as of 2026-03-13. It does not constitute legal advice. Engage qualified legal counsel to validate regulatory conclusions.*
