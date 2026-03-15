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
content_type: "thread"

# Scheduling
priority: 5
scheduled_post_at: ""
earliest_post_at: ""
latest_post_at: ""

# Content metadata
pillar: ""                         # Configure per tenant
character_count: 0
has_media: false
thread_count: 0                    # Update with actual number of thread parts

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

[Thread hook tweet, max 280 characters. This is what people see first.]

## Thread Parts

### Part 1
[Hook tweet, same as Content above]

### Part 2
[Continuation, max 280 characters per part]

### Part 3
[Continuation]

### Part 4
[CTA or closing thought]

### Part N (final)
Not financial advice. Digital assets are volatile and carry risk of loss. DYOR.

[Link or CTA if applicable]

## Editor Notes

<!-- Human review notes. NOT posted. -->
