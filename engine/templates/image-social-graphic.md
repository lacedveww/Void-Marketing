---
id: ""
created_at: ""
updated_at: ""

# Status
status: "drafts"
previous_status: ""

# Target
platform: "x"                     # x|linkedin|discord|telegram
account: ""
content_type: "image"

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

# Image specs
image_variant: ""                  # post-image|profile-pic|banner|meme-base|event-graphic|partner-announcement|quote-card
image_dimensions: ""               # 1080x1080 (square feed) | 1200x675 (x card) | 1500x500 (x banner) | 1200x628 (linkedin)
image_count: 1                     # Number of images to generate (variants for A/B testing)

# Source
source_workflow: "manual"
generated_by: "claude"             # claude|human|n8n

# Compliance
review_tier: 2                     # Tier 2 if no text on image, Tier 1 if text contains financial terms
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
tool: ""
---

## Image Variant

<!-- Pick one -->
- [ ] **Post image**: Visual accompanying a tweet or LinkedIn post
- [ ] **Profile picture**: Account avatar (square, recognizable at small size)
- [ ] **Banner image**: X header (1500x500) or LinkedIn cover
- [ ] **Meme base**: Template image for culture accounts (text overlaid separately)
- [ ] **Event graphic**: AMA, Space, launch announcement visual
- [ ] **Partner announcement**: Co-branded visual with partner logo/identity
- [ ] **Quote card**: Text-on-image format for impactful statements

## Generation Prompt

### Subject
[What the image depicts. Be specific]

### Style
[Artistic style: minimalist, abstract, futuristic, cyberpunk, clean-tech, data-visualization]

### Colors
[Brand palette and overrides]

### Mood
[Atmosphere: professional, futuristic, energetic, intelligent, trustworthy]

### Context
[How it will be used: X post image, LinkedIn banner, Discord embed, thread header]

### Technical
- Aspect ratio: [square | landscape | portrait]
- Need text space: [yes/no, leave clear area for text overlay]
- Logo placement: [where logo should be, or "add in post-production"]

### Full Prompt

```
[Complete prompt for image generation tool]
```

## Accompanying Post Text

[Text that accompanies this image when posted.]

Not financial advice. Digital assets are volatile and carry risk of loss. DYOR.

## Editor Notes

<!-- Human review notes. NOT posted. -->
<!-- Image review checklist:
- [ ] No prohibited language in any text ON the image?
- [ ] Brand colors match design system?
- [ ] No competitor logos or branding without approval?
- [ ] If text on image: disclaimer included or in post text?
- [ ] Image resolution appropriate for target platform?
-->
