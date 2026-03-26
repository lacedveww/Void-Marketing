# Preference Learning System

**Status:** ACTIVE
**Last Updated:** 2026-03-25
**Canonical for:** Content curation pipeline, variant scoring, preference logging, Telegram presentation
**Dependencies:** `engine/frameworks/gemini-scoring-criteria.md` (scoring rubric), `companies/{ACTIVE_COMPANY}/automations/data/preference-log/` (log storage)

---

## Overview

Two-stage content curation with three simultaneous learning loops that improve content quality over time.

---

## Architecture: Three-Layer Curation Pipeline

```
LAYER 1 — Claude Code CLI generates variants per content slot (8 tweets, 6 threads, 4 articles)
  | all variants output as JSON with metadata
LAYER 2 — OpenClaw (Gemini) scores all variants on multiple dimensions (1-10 each)
  | selects top options by composite score, ensures angle diversity
  | logs ALL variants with full scores
LAYER 3 — Vew picks 1 from the top options via Telegram
  | selection + all scores logged to preference system
  | three feedback signals: Gemini quality scores, Vew's preference, audience engagement
```

---

## Three Learning Loops

1. **Gemini scoring** — learns what passes quality/brand checks (improves filtering over time)
2. **Vew's selections** — learns curator preferences (improves which 4 are presented)
3. **Audience engagement** — learns what performs in the market (improves topic/hook selection)

---

## Variant Counts

| Content Type | Claude Generates | Gemini Scores | Vew Sees | Vew Picks |
|---|---|---|---|---|
| Tweet | 8 | all 8 | top 4 (A/B/C/D) | 1 |
| Thread | 6 | all 6 | top 3 (A/B/C) + Telegraph links | 1 |
| Article/Blog | 4 | all 4 | top 2 (A/B) | 1 |

---

## Content Generation Strategy

Variants are generated based on (in priority order):
1. **Monitoring data** — today's sweep (X accounts, RSS news, Taostats metrics)
2. **Trending topics / SEO** — what's hot in Bittensor/DeFi right now
3. **Post analytics** — engagement data from previous posts (performance-summary.json)
4. **Preference learning** — patterns from past curator selections vs declines (preference-log/)

Each variant should take a different angle on the data. Diversity emerges organically from the data, not from predefined categories. No hook type labels or structure type assignments.

---

## Scoring Reference

See `engine/frameworks/gemini-scoring-criteria.md` for the full 6-dimension scoring rubric.

---

## Preference Log Format

Log file: `automations/data/preference-log/preference-log-YYYY-MM-DD.json`

Each content slot generates one log entry containing ALL data:

```json
{
  "entries": [
    {
      "timestamp": "ISO timestamp",
      "date": "YYYY-MM-DD",
      "account": "v0idai",
      "content_type": "tweet",
      "slot_number": 1,
      "topic": "topic description",
      "pillar": "A",
      "generation": {
        "total_generated": 8,
        "model": "claude-code-cli",
        "prompt_included": ["sweep_data", "metrics", "voice_rules", "performance_feedback", "preference_learning"]
      },
      "gemini_scoring": {
        "model": "gemini-2.5-flash",
        "all_variants": [
          {
            "id": "v1",
            "content_preview": "First 100 chars...",
            "topic": "specific angle/topic",
            "scores": {
              "voice_match": 8,
              "relevance": 9,
              "hook_quality": 7,
              "compliance": 10,
              "uniqueness": 8,
              "data_density": 9
            },
            "composite_score": 8.5,
            "presented_to_user": true,
            "presented_as": "A"
          }
        ]
      },
      "user_selection": {
        "selected_option": "B",
        "selected_variant_id": "v5",
        "selected_topic": "lending TVL update",
        "selected_composite_score": 8.2,
        "was_top_scored": false,
        "top_scored_variant_id": "v1",
        "top_scored_composite": 8.5,
        "score_rank_of_selection": 2,
        "edited": false,
        "regenerated": false,
        "skipped": false
      },
      "learning_signals": {
        "gemini_top_pick_matched_user": false,
        "user_preferred_lower_score": true,
        "score_gap": 0.3,
        "pattern_note": "User picked variant with different angle over higher-scored option"
      }
    }
  ]
}
```

---

## Telegram Presentation Format

No scores, no category labels. Order is RANDOMIZED (not by score).
ALL content types are published to Telegraph for clean review via `publish-telegraph.sh`.

**Tweets (4 options):**
```
[@v0idai] Tweet 1 — Pick one:

A: telegra.ph/link-a
B: telegra.ph/link-b
C: telegra.ph/link-c
D: telegra.ph/link-d

Reply with a letter (A/B/C/D), "regenerate", or "skip".
```

**Threads (3 options):**
```
[@v0idai] Thread — Pick one:

A: telegra.ph/link-a
B: telegra.ph/link-b
C: telegra.ph/link-c

Reply with a letter (A/B/C), "regenerate", or "skip".
```

**Articles (2 options):**
```
[@v0idai] Article — Pick one:

A: telegra.ph/link-a
B: telegra.ph/link-b

Reply with a letter (A/B), "regenerate", or "skip".
```

On "regenerate": Claude generates NEW variants (8 tweets, 6 threads, 4 articles), Gemini scores and filters again, presents fresh options. Originals logged with `regenerated: true`.

---

## Phase 2: Preference Analysis (March 30)

After 5+ days of data collection, implement:
- `analyze-preferences.sh` script reads logs, produces preference-summary.json
- Gemini scoring weight calibration based on score-vs-selection alignment
- Preference feedback injection into generation prompts
- Weekly calibration report with scoring dimension recommendations

---

## Phases

| Phase | Status | Implements |
|-------|--------|-----------|
| Phase 1 | ACTIVE | Generation, scoring, selection, logging |
| Phase 2 | PLANNED (March 30) | Analysis, calibration, feedback injection |

---

## Changelog

| Date | Change |
|------|--------|
| 2026-03-25 | Initial creation. Three-layer curation pipeline, preference log format, Telegram presentation format, Phase 2 plan. |
