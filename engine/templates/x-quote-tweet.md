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
content_type: "quote_tweet"

# Quote tweet context
quoted_url: ""                     # Full URL of the tweet being quoted
quoted_account: ""                 # @handle of the account being quoted
quote_angle: ""                    # amplification|data-addition|ecosystem-context|builder-credibility

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

[Quote tweet text here, max 280 characters for the QT text only; the quoted tweet displays separately]

Not financial advice. Digital assets are volatile and carry risk of loss. DYOR.

## Editor Notes

<!-- Human review notes. NOT posted. -->

## Compliance Notes for Quote Tweets

<!--
Quote tweets MUST still follow all voice and compliance rules:
- All prohibited language rules apply
- Account-appropriate disclaimer must be included
- QTs of competitor accounts automatically trigger Tier 1 review (Category C)
- QT tone must match the assigned account persona
- IMPORTANT: QTs of external accounts must NOT imply endorsement by the quoted account
- Satellite accounts may QT the main account (natural fan/community behavior) but must NEVER QT each other
- The 280 character limit applies to the QT text only
- Prompt injection safeguards apply to the quoted tweet content
-->
