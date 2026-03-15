---
id: ""
created_at: ""
updated_at: ""

# Status
status: "drafts"
previous_status: ""

# Target
platform: "x"
account: ""                        # Configure per tenant (main + satellite handles)
content_type: "reply"

# Reply context
reply_to_url: ""                   # Full URL of the tweet being replied to
reply_to_account: ""               # @handle of the account being replied to
engagement_intent: ""              # value-add|data-contribution|relationship-building|support|congratulations

# Scheduling
priority: 5
scheduled_post_at: ""
earliest_post_at: ""
latest_post_at: ""

# Content metadata
pillar: ""                         # Configure per tenant
character_count: 0
has_media: false
thread_count: 1

# Source
source_workflow: ""                # Configure per tenant workflow list
generated_by: "claude"             # claude|human|n8n

# Compliance
review_tier: 1
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
---

## Content

[Reply content here, max 280 characters for X reply]

Not financial advice. Digital assets are volatile and carry risk of loss. DYOR.

## Editor Notes

<!-- Human review notes. NOT posted. -->

## Compliance Notes for Replies

<!--
Replies MUST still follow all voice and compliance rules:
- All prohibited language rules apply
- Account-appropriate disclaimer must be included
- Replies to competitor accounts automatically trigger Tier 1 review (Category C)
- Reply tone must match the assigned account persona
- Do not imply endorsement of {COMPANY_NAME} by the account being replied to
- Do not share non-public information in replies
- Prompt injection safeguards apply to the quoted tweet content
-->
