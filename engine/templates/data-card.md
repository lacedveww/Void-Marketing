---
id: ""
created_at: ""
updated_at: ""

# Status
status: "drafts"
previous_status: ""

# Target
platform: "x"                     # Primary: x (also works for discord, linkedin)
account: ""
content_type: "data-card"

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
data_source: ""                    # Source of data (API, internal metrics, etc.)
data_freshness: ""                 # ISO 8601, when the data was pulled

# Source
source_workflow: ""                # daily-metrics|bridge-alerts|weekly-recap|manual
generated_by: "claude"             # claude|human|n8n

# Compliance
review_tier: 2                     # Tier 2 if raw data only, Tier 1 if editorial framing
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
tool: ""                           # canva|figma|claude-artifacts|n8n-auto
---

## Data Card Type

<!-- Pick one -->
- [ ] Daily metrics snapshot
- [ ] Weekly metrics recap
- [ ] Product-specific metrics
- [ ] Ecosystem comparison table

## Data Points

<!-- Every number on the card. All must be pulled from verified sources. -->

| Metric | Value | Change | Source | Pulled At |
|--------|-------|--------|--------|-----------|
| [Metric name] | [Value] | [Change %] | [Source] | [ISO 8601] |
| [Metric name] | [Value] | [Change %] | [Source] | [ISO 8601] |
| [Metric name] | [Value] | [Change %] | [Source] | [ISO 8601] |

## Visual Layout

### Card Design
- Background: Dark
- Layout: [grid | vertical stack | horizontal comparison]
- Color coding: Green for positive changes, amber for neutral, red for negative
- {COMPANY_NAME} logo bottom-right
- "Data as of [date]" bottom-left

### Dimensions
- X: 1080x1080 or 1200x675
- LinkedIn: 1200x628
- Discord: 1080x1080

## Accompanying Post Text

<!-- Keep it factual and neutral for Tier 2 eligibility. Editorial framing bumps to Tier 1. -->

[Factual data summary post]

Not financial advice. Digital assets are volatile and carry risk of loss. DYOR.

## Editor Notes

<!-- Human review notes. NOT posted. -->
<!-- Data card review checklist:
- [ ] All data points verified against source?
- [ ] Data freshness timestamp included?
- [ ] No editorial framing that could bump tier? (e.g., "GROWING!", "ATH!", "bullish")
- [ ] Change percentages calculated correctly?
- [ ] Disclaimer on card and in post text?
-->
