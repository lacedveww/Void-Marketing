---
id: "dc1-daily-metrics"
created_at: "2026-03-13"
updated_at: "2026-03-13"

# Status
status: "approved"
previous_status: "review"

# Target
platform: "x"
account: "v0idai"
content_type: "data-card"

# Scheduling
priority: 3
scheduled_post_at: ""
earliest_post_at: ""
latest_post_at: ""

# Content metadata
pillar: "bridge-build"
character_count: 0
has_media: true
thread_count: 1
data_source: "taostats|internal-metrics"
data_freshness: ""

# Source
source_workflow: "daily-metrics"
generated_by: "claude"

# Compliance
review_tier: 2
compliance_passed: true
prohibited_language: "pass"
disclaimer_included: true
risk_level: "low"
howey_risk: "none"
red_flags_found: []
compliance_checked_at: "2026-03-14T02:57:46Z"

# Approval
requires_approval: true
reviewed_by: "vew"
reviewed_at: "2026-03-13"
review_notes: "Batch approved after 4-pass review pipeline (review agents + verification agents + challenger agents + voice audit)"
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
tool: "canva"
---

## Data Card Type

- [x] Daily metrics snapshot (bridge volume, uptime, wallets)

## Data Points

| Metric | Value | Change | Source | Pulled At |
|--------|-------|--------|--------|-----------|
| Total Value Bridged (Cumulative) | [PLACEHOLDER] | [PLACEHOLDER] 7d | internal | [PLACEHOLDER] |
| Transactions Today | [PLACEHOLDER] | [PLACEHOLDER] vs yesterday | internal | [PLACEHOLDER] |
| Bridge Uptime | [PLACEHOLDER]% | n/a | internal | [PLACEHOLDER] |
| Chains Supported | 4 (Bittensor, Solana, Ethereum, Base) | n/a | internal | [PLACEHOLDER] |
| SN106 Mindshare Rank | [PLACEHOLDER] (#[PLACEHOLDER]) | [PLACEHOLDER] 7d | taostats | [PLACEHOLDER] |
| Unique Wallets (Cumulative) | [PLACEHOLDER] | [PLACEHOLDER] 7d | internal | [PLACEHOLDER] |
| SN106 Variable Rate (Current) | [PLACEHOLDER]% | [PLACEHOLDER] vs last week | taostats | [PLACEHOLDER] |

## Visual Layout

### Card Design
- Background: Dark (#0A0A0F)
- Layout: vertical stack with two-column grid for main metrics, single row for secondary metrics
- Typography: Space Grotesk (metric labels), Inter (values and change indicators)
- Color coding: Green for positive changes, amber for neutral/flat, red for negative
- Top section: VoidAI logo + "Daily Bridge Metrics" heading + date
- Main grid (2x2):
  - Top left: Total Value Bridged (large number, green accent)
  - Top right: Transactions Today (large number)
  - Bottom left: Bridge Uptime (percentage with green dot indicator)
  - Bottom right: Chains Supported (number with chain logos)
- Secondary row (3 across):
  - SN106 Mindshare Rank
  - Unique Wallets
  - SN106 Current Rate (with "variable, not guaranteed" subtext)
- Bottom bar: "Built on Chainlink CCIP" badge left, "Data as of [date]" right
- VoidAI logo watermark bottom-right

### Dimensions
- X: 1200x675 (landscape for better timeline visibility)
- LinkedIn: 1200x628
- Discord: 1080x1080

### Design Notes
- Rate field MUST include "variable, not guaranteed" in small text directly adjacent to the rate number
- No editorial framing in the visual. No "ATH!", "GROWING!", "bullish". Raw data only
- Change indicators use arrows (up/down) with percentage, no exclamation marks
- Clean, minimal design. Let the numbers speak

## Accompanying Post Text

VoidAI Bridge: Daily Metrics

Total bridged: [PLACEHOLDER]
Transactions today: [PLACEHOLDER]
Uptime: [PLACEHOLDER]%
Chains: 4 (Bittensor, Solana, Ethereum, Base)
SN106 mindshare: [PLACEHOLDER]
Wallets served: [PLACEHOLDER]

Rates are variable, not guaranteed, and subject to change.

Data via Taostats + internal metrics.

Not financial advice. Digital assets are volatile and carry risk of loss. DYOR.

## Automation Notes

<!-- TEMPLATE FOR DAILY USE -->
<!-- This data card is designed to be generated daily by the n8n daily-metrics workflow (Workflow 1). -->
<!-- Data sources:
  - Taostats API: SN106 mindshare rank, emissions data, alpha token price
  - Internal metrics: bridge volume, transaction count, uptime, unique wallets
  - Bridge contract queries: total value locked, daily transaction count
-->
<!-- Workflow steps:
  1. Pull data from Taostats API (getTaoPrice, subnet analytics endpoints)
  2. Pull internal bridge metrics from monitoring dashboard
  3. Fill [PLACEHOLDER] values with real data
  4. Generate card visual via Canva API or n8n image generation
  5. Post to X with accompanying text
  6. Cross-post card to Discord #metrics channel
-->
<!-- IMPORTANT: Before first use, replace ALL [PLACEHOLDER] values with real data -->
<!-- IMPORTANT: Rate field must ALWAYS show "variable, not guaranteed" (compliance requirement) -->

## Editor Notes

<!-- Human review notes. NOT posted. -->
<!-- Data card review checklist:
- [ ] All data points verified against source?
- [ ] Data freshness timestamp included?
- [x] No editorial framing that could bump tier? (raw data only, no "GROWING!", "ATH!", "bullish")
- [ ] Change percentages calculated correctly?
- [x] Disclaimer on card and in post text?
- [x] If showing rates/APY: "variable, not guaranteed" disclaimer adjacent?
-->
