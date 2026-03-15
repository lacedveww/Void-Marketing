---
id: ""
created_at: ""
updated_at: ""

# Status
status: "drafts"
previous_status: ""

# Target
platform: "blog"                   # blog|x|linkedin (OG images serve all platforms)
account: ""
content_type: "image"

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

# Image specs
image_variant: ""                  # blog-header|og-image|thread-header|slide-background|thumbnail|newsletter-header
image_dimensions: ""               # 1200x630 (OG/blog) | 1920x1080 (presentation bg) | 1280x720 (thumbnail) | 600x315 (email)
image_count: 1

# Source
source_workflow: ""                # blog-distribution|manual
generated_by: "claude"             # claude|human|n8n

# Compliance
review_tier: 2                     # Tier 2, content images rarely contain financial language
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
- [ ] **Blog header**: Hero image for blog post (1200x630 or wider)
- [ ] **OG image**: Open Graph / Twitter Card preview image (1200x630)
- [ ] **Thread header**: First-tweet image for X threads (1200x675)
- [ ] **Slide background**: Presentation/deck background (1920x1080)
- [ ] **Thumbnail**: Video or content thumbnail (1280x720)
- [ ] **Newsletter header**: Email header image (600x315)

## Associated Content

<!-- What content does this image support? -->
- Content title: [Title of the blog post, thread, etc.]
- Content topic: [Brief description]
- Key visual concept: [What should the image communicate at a glance]

## Generation Prompt

### Full Prompt

```
[Complete prompt for image generation tool]
```

## Alt Text

[Descriptive alt text for SEO and accessibility. Required for blog headers and OG images]

## Editor Notes

<!-- Human review notes. NOT posted. -->
<!-- Content image checklist:
- [ ] Image matches the content topic and communicates the right concept?
- [ ] Brand colors correct?
- [ ] No text baked into the image (text should be in HTML for SEO)?
- [ ] Alt text written for accessibility?
- [ ] Resolution sufficient for target use?
-->
