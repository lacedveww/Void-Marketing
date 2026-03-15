# Brand Voice: {COMPANY_NAME}

## Voice Registers (Weight Distribution)

<!-- Define 3-5 voice registers with percentage weights totaling 100%. -->
<!-- Weights determine how much of your content output falls into each register. -->

| Register | Weight | When to Use |
|----------|--------|-------------|
| {REGISTER_1} | {WEIGHT}% | {DESCRIPTION} |
| {REGISTER_2} | {WEIGHT}% | {DESCRIPTION} |
| {REGISTER_3} | {WEIGHT}% | {DESCRIPTION} |
| {REGISTER_4} | {WEIGHT}% | {DESCRIPTION} |

<!-- Example registers: Builder-Credibility (40%), Alpha-Leak (25%), Community-Educator (25%), Culture/Memes (10%) -->

## Voice Rules: DO

<!-- What your brand voice should consistently do. Be specific. -->

- {DO_RULE_1}
  <!-- e.g., "Lead with results and data, not promises" -->
- {DO_RULE_2}
  <!-- e.g., "Use industry-native terminology correctly" -->
- {DO_RULE_3}
- {DO_RULE_4}
- {DO_RULE_5}
- {DO_RULE_6}
- {DO_RULE_7}

## Voice Rules: DO NOT

<!-- What your brand voice must never do. Be specific. -->

- {DONT_RULE_1}
  <!-- e.g., "Use empty hype or unsubstantiated superlatives" -->
- {DONT_RULE_2}
- {DONT_RULE_3}
- {DONT_RULE_4}
- {DONT_RULE_5}
- {DONT_RULE_6}

## Banned AI Phrases (Auto-Fail)

<!-- Phrases that indicate AI-generated content. Any content containing these fails review. -->
<!-- Add phrases common to your industry that sound generic or robotic. -->

- "{BANNED_PHRASE_1}"
- "{BANNED_PHRASE_2}"
- "{BANNED_PHRASE_3}"

<!-- Common defaults to consider banning:
- "It's worth noting"
- "In the ever-evolving landscape of"
- "At its core"
- "This is a game-changer"
- "Without further ado"
- "Revolutionizing the way"
- "Paradigm shift"
- "Synergy" / "synergies"
- "Holistic approach"
- "Cutting-edge"
- "Seamless integration"
- "Robust ecosystem"
- "Additionally," at start of sentence
- "Furthermore," at start of sentence
- "Moreover," at start of sentence
- "In conclusion"
-->

## Tone by Platform

<!-- How voice registers shift per platform. Each platform has different norms. -->

| Platform | Tone Adjustment |
|----------|----------------|
| X (Twitter) | {TONE_ADJUSTMENT} |
| LinkedIn | {TONE_ADJUSTMENT} |
| Blog | {TONE_ADJUSTMENT} |
| Discord/Telegram | {TONE_ADJUSTMENT} |
| Video scripts | {TONE_ADJUSTMENT} |

<!-- Example: X = "Sharp, concise, data-forward. Threads for depth." -->
<!-- Example: LinkedIn = "Professional but not corporate. Lead with business impact." -->

## Voice File Priority Hierarchy

<!-- When files contradict each other, this hierarchy determines which source wins. -->
<!-- Highest authority listed first. -->

1. **Engine compliance rules** -- NEVER overridden by any other file
2. **Company compliance.md** -- company-specific compliance, non-negotiable
3. **Company voice.md** (this file) -- default brand rules
4. **brand/voice-learnings.md** -- latest performance data may override default voice/format preferences (but never compliance rules)
5. **research/ files** -- community baseline reference data, lowest priority

If you encounter a conflict between files, follow the higher-priority file and flag the conflict in `brand/voice-learnings.md` for resolution.

## Self-Improving Voice Loop

<!-- The brand voice is NOT static. It evolves based on what performs. -->

### How It Works

1. **Before generating content**: Read `brand/voice-learnings.md` for latest patterns
2. **After posting cycle**: Scrape engagement data on recent posts (all accounts)
3. **Analyze**: Compare engagement rates across content types, hooks, formats, tone variations
4. **Update**: Append findings to `brand/voice-learnings.md`
5. **Calibrate**: If patterns shift significantly, update voice weights in this file

### Voice Calibration Triggers

Update voice weights ONLY when ANY of these quantitative conditions are met:

- A register consistently **outperforms its target weight by >50%** in engagement rate over 4+ weeks
- A register consistently **underperforms its target weight by >50%** for 4+ weeks
- **Engagement drops >30% across the board** over a 2-week period
- Community language baseline shifts measurably (**>20% new terms** in monthly scrape)
- A content format achieves **3x average engagement rate** for 3+ consecutive uses
- Competitor accounts make a noticeable voice shift detected in weekly monitoring

### Process for Weight Updates

1. Document the trigger condition and supporting data in `brand/voice-learnings.md`
2. Propose specific weight changes with rationale
3. Human approves before this file is edited
4. Log the change in the Changelog section
5. NEVER auto-update compliance rules

---

## Changelog

| Date | Change | Approved by |
|------|--------|-------------|
| {DATE} | Initial voice config created | {APPROVER} |
