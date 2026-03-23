---
id: ""
created_at: ""
updated_at: ""

# Status
status: "drafts"
previous_status: ""

# Target
platform: "blog"
account: ""
content_type: "article"

# Scheduling
priority: 3                        # Blog posts are high-priority pillar content
scheduled_post_at: ""
earliest_post_at: ""
latest_post_at: ""

# Content metadata
pillar: ""                         # Configure per tenant
character_count: 0
has_media: false
thread_count: 1
word_count: 0                      # Target: 2000-3000 words for pillar posts
seo_title: ""                      # Max 60 chars
seo_description: ""                # Max 155 chars
seo_slug: ""                       # URL path
seo_keywords: []                   # Primary + secondary keywords

# Source
source_workflow: ""                # blog-distribution|manual
generated_by: "claude"             # claude|human|n8n

# Compliance
review_tier: 1                     # Blog posts are ALWAYS Tier 1
compliance_passed: false
prohibited_language: "unchecked"   # pass|fail|unchecked
disclaimer_included: false
risk_level: "low"                  # low|medium|high
howey_risk: "none"                 # none|low|medium|high
red_flags_found: []
compliance_checked_at: ""

# Approval
requires_approval: true            # Always true for blog
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

# Derivatives
derivatives_needed: true           # Triggers blog distribution pipeline
derivative_formats: ["x-thread", "linkedin-post", "discord-announcement"]
---

## Title

[Blog post title, clear, SEO-optimized, answers "so what"]

## Subtitle

[Optional subtitle for additional context]

## Header Image

<!-- Describe the header image needed. -->
<!-- Alt text: [descriptive alt text for SEO and accessibility] -->

## Content

### Introduction

[Hook: open with a problem, insight, or data point. Answer "why should I read this?" in the first 2 sentences.]

### Section 1: [Heading]

[Body content. Lead with data.]

### Section 2: [Heading]

[Body content.]

### Section 3: [Heading]

[Body content.]

### Conclusion / CTA

[Summarize key takeaway. Clear call to action.]

---

**Risk Disclosures**

<!-- Include the applicable risk disclosures based on content topic and loaded compliance modules. -->

**Disclaimer**

<!-- Insert company-specific long-form disclaimer from loaded compliance modules. -->

## Editor Notes

<!-- Human review notes. NOT posted. -->
<!-- Blog review checklist (all must be YES before publishing):
- [ ] Full long-form disclaimer at bottom?
- [ ] Risk disclosure present where applicable?
- [ ] All claims verifiable with cited sources?
- [ ] SEO title, description, slug, keywords filled in?
- [ ] Header image created?
- [ ] Derivative formats identified?
-->
