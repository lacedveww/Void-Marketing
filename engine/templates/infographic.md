---
id: ""
created_at: ""
updated_at: ""

# Status
status: "drafts"
previous_status: ""

# Target
platform: "x"                     # Primary distribution: x|linkedin|blog|discord
account: ""
content_type: "infographic"

# Scheduling
priority: 5
scheduled_post_at: ""
earliest_post_at: ""
latest_post_at: ""

# Content metadata
pillar: ""                         # Configure per tenant
character_count: 0
has_media: true
thread_count: 1
image_dimensions: ""                # 1080x1080 (feed) | 1080x1350 (portrait) | 1200x628 (linkedin) | 1600x900 (blog)
image_count: 1

# Source
source_workflow: ""                # daily-metrics|weekly-recap|manual
generated_by: "claude"             # claude|human|n8n

# Compliance
review_tier: 1                     # Infographics with data are Tier 1
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
tool: ""                           # canva|figma|claude-artifacts
---

## Infographic Concept

[One-line: what this visual communicates and the key takeaway]

## Type

<!-- Pick one -->
- [ ] Data visualization (charts, metrics, comparisons)
- [ ] Process/flow diagram (how something works)
- [ ] Comparison table (feature matrix)
- [ ] Educational explainer (concept breakdown)
- [ ] Ecosystem map (landscape, connections)
- [ ] Timeline (roadmap, milestones)

## Data / Content

### Headline
[Bold, clear headline on the graphic, max 8 words]

### Key Data Points
<!-- List all data that appears on the infographic. Every number must be verifiable. -->

1. [Metric]: [Value]. Source: [source]
2. [Metric]: [Value]. Source: [source]
3. [Metric]: [Value]. Source: [source]

### Supporting Text
[Any explanatory text on the graphic. Keep minimal, let the visual do the work]

### Footer
[{COMPANY_NAME} logo | {COMPANY_URL} | {MAIN_ACCOUNT}]

Not financial advice. DYOR.

## Design Brief

### Layout
[Describe the visual layout: top-to-bottom flow, left-right comparison, radial, grid, etc.]

## Accompanying Post Text

[The text that goes with this infographic when posted.]

Not financial advice. Digital assets are volatile and carry risk of loss. DYOR.

## Editor Notes

<!-- Human review notes. NOT posted. -->
<!-- Infographic review checklist:
- [ ] All data points verified with cited sources?
- [ ] No prohibited language in any text on the graphic?
- [ ] Disclaimer visible on the graphic?
- [ ] Brand colors and fonts match design system?
-->
