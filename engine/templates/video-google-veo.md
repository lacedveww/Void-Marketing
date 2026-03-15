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
video_duration: ""                 # AI video tools generate short clips, typically 4-8 seconds per generation
video_format: "short-form"         # short-form (AI clips), stitch multiple for longer
aspect_ratio: ""                   # 16:9 (landscape) | 9:16 (vertical/reels) | 1:1 (square)

# Source
source_workflow: "manual"
generated_by: "claude"             # claude|human|n8n

# Compliance
review_tier: 1                     # Videos always Tier 1, can't edit after rendering
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
tool: ""                           # AI video generation tool
---

## Video Concept

[One-line: what this video shows and the intended visual impact]

## Use Case

<!-- Pick one -->
- [ ] **Product teaser**: Short visual clip showcasing product in action
- [ ] **Announcement visual**: Animated graphic for launches, milestones, events
- [ ] **Background loop**: Ambient loop for presentations, streams, or social profile video
- [ ] **Explainer clip**: Visual metaphor for a technical concept
- [ ] **Social hook**: Scroll-stopping opening clip for a video post or thread
- [ ] **Culture clip**: Animated visual for community/meme content

## AI Video Generation Prompt

### Full Prompt

```
[Complete prompt for AI video generation. Emphasize motion, camera, and mood.]
```

## Post-Production Plan

### Editing Steps
1. [ ] Trim to optimal length for platform
2. [ ] Add logo watermark (if not in generation)
3. [ ] Add text overlay if needed
4. [ ] Add disclaimer frame at end
5. [ ] Add audio/music track (optional, copyright-free)
6. [ ] Export in correct format for target platform

### Platform Export Specs

| Platform | Format | Max Duration | Max Size |
|----------|--------|:------------:|:--------:|
| X | MP4 | 2:20 | 512MB |
| LinkedIn | MP4 | 10:00 | 5GB |
| YouTube Shorts | MP4 | 0:60 | -- |
| Instagram Reels | MP4 | 1:30 | -- |
| Discord | MP4 | 0:30 recommended | 25MB |

## Stitch Plan (for longer videos)

<!-- If combining multiple AI clips into one video -->

| Clip # | Prompt Summary | Duration | Transition |
|:------:|---------------|:--------:|:----------:|
| 1 | [Hook/opening shot] | 4s | -- |
| 2 | [Main visual] | 6s | Cross-dissolve |
| 3 | [Supporting visual] | 4s | Cut |
| 4 | [CTA/closing] | 4s | Fade to black |

## Accompanying Post Text

[Text that accompanies this video when posted.]

Not financial advice. Digital assets are volatile and carry risk of loss. DYOR.

## Editor Notes

<!-- Human review notes. NOT posted. -->
<!-- AI video checklist:
- [ ] No prohibited language in any text overlays?
- [ ] Disclaimer frame at end or in post text?
- [ ] Brand colors consistent?
- [ ] Video quality acceptable? (AI generation can be inconsistent, may need regeneration)
- [ ] Audio track copyright-free if used?
- [ ] Exported in correct format/size for target platform?
-->
