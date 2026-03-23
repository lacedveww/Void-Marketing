---
id: ""
created_at: ""
updated_at: ""

# Status
status: "drafts"
previous_status: ""

# Target
platform: "podcast"               # Published via NotebookLM or similar, promoted across platforms
account: ""
content_type: "podcast"

# Scheduling
priority: 4
scheduled_post_at: ""
earliest_post_at: ""
latest_post_at: ""

# Content metadata
pillar: ""                         # Configure per tenant
character_count: 0
has_media: true
thread_count: 1
estimated_duration: ""             # e.g., "8-12 minutes"

# Source
source_workflow: "manual"
generated_by: "claude"             # claude|human|n8n

# Compliance
review_tier: 1                     # Podcasts are always Tier 1, audio can't be edited post-publish
compliance_passed: false
prohibited_language: "unchecked"   # pass|fail|unchecked
disclaimer_included: false
risk_level: "low"                  # low|medium|high
howey_risk: "none"                 # none|low|medium|high
red_flags_found: []
compliance_checked_at: ""

# Approval
requires_approval: true
reviewed_by: ""
reviewed_at: ""
review_notes: ""
rejection_reason: ""

# Execution
posted_at: ""
post_id: ""
failure_reason: ""
dry_run: true

# Coordination
stagger_group: ""
stagger_order: 0

# Tool
tool: "notebooklm"
derivative_formats: ["x-single", "x-thread", "linkedin-post", "discord-announcement"]
---

## Podcast Topic

[One-line topic: what this episode covers and why it matters]

## Source Documents

<!-- List the documents to feed into the podcast generation tool as sources. -->

1. [Document/URL 1]
2. [Document/URL 2]
3. [Document/URL 3]
4. [Optional: additional sources]

## Talking Points and Guidance

### Must Cover
1. [Key point 1: the core insight or news]
2. [Key point 2: why it matters for the audience]
3. [Key point 3: actionable takeaway or CTA]

### Must Avoid
1. Prohibited language per loaded compliance modules
2. Price predictions or implied appreciation
3. Competitor disparagement (factual comparisons OK)

### Tone Direction
[e.g., "Technical but accessible. Two builders breaking down what just shipped and why it matters."]

## Compliance Pre-Check

<!-- Review these BEFORE generating audio. Audio can't be edited after generation. -->

- [ ] Source documents contain no Category A prohibited language?
- [ ] Talking points use compliant language substitutions?
- [ ] No price predictions in source material that could bleed into podcast?

## Promotion Plan

### X Promo Post
[Short teaser: "New episode: [topic]. [Hook]. Listen: [link]"]

Not financial advice. Digital assets are volatile and carry risk of loss. DYOR.

### LinkedIn Promo Post
[Professional angle: why this matters for the industry]

### Discord Announcement
[Community-first: "New podcast dropped. This one covers [topic]."]

## Editor Notes

<!-- Human review notes. NOT posted. -->
<!-- CRITICAL: Listen to the full generated podcast before approving. Audio cannot be edited. If compliance issues exist, regenerate from scratch. -->
