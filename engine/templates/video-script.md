---
id: ""
created_at: ""
updated_at: ""

# Status
status: "drafts"
previous_status: ""

# Target
platform: "x"                     # Primary distribution: x|linkedin|youtube
account: ""
content_type: "video"

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
video_duration: ""                 # Target duration, e.g., "30s", "60s", "3min"
video_format: ""                   # short-form (< 60s) | long-form (> 60s)
aspect_ratio: ""                   # 9:16 (reels/shorts) | 16:9 (youtube/linkedin) | 1:1 (feed)

# Source
source_workflow: "manual"
generated_by: "claude"             # claude|human|n8n

# Compliance
review_tier: 1                     # Videos are always Tier 1, can't edit after rendering
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
tool: ""                           # Recording/editing tool
---

## Video Concept

[One-line concept: what this video shows and why someone would watch it]

## Script

### Hook (0:00 - 0:03)

[Open with THE hook. You have 3 seconds to stop the scroll. Question, bold claim, or visual surprise.]

### Body (0:03 - 0:XX)

<!-- For short-form: keep to 2-3 key points. For long-form: expand with sections. -->

**Scene 1:**
- Visual: [What's on screen: screencast, animation, talking head, data viz]
- Narration/Text: [What's said or shown as text overlay]

**Scene 2:**
- Visual: [Description]
- Narration/Text: [Content]

**Scene 3:**
- Visual: [Description]
- Narration/Text: [Content]

### CTA (final 3-5s)

- Visual: [Logo, URL, or action prompt]
- Narration/Text: [Clear CTA]

### Disclaimer Frame (final frame or pinned comment)

Not financial advice. Digital assets are volatile and carry risk of loss. DYOR.

## Accompanying Post Text

[The text that accompanies the video when posted. Must include disclaimer.]

Not financial advice. Digital assets are volatile and carry risk of loss. DYOR.

## Editor Notes

<!-- Human review notes. NOT posted. -->
<!-- Video review checklist:
- [ ] Hook grabs attention in first 3 seconds?
- [ ] No prohibited language in script or on-screen text?
- [ ] Disclaimer visible (final frame, pinned comment, or post text)?
- [ ] Brand colors/fonts match design system?
- [ ] CTA is clear and actionable?
-->
