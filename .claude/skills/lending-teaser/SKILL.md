# /lending-teaser

Generate lending platform teaser content for VoidAI's upcoming launch, calibrated by phase.

## Trigger
When the user says: "lending teaser", "generate lending content", "/lending-teaser"

## Instructions

1. **Load config** (stop if any missing):
   - Read all config files per CLAUDE.md Config Load Order (items 1-8 minimum)
   - Read `companies/{ACTIVE_COMPANY}/brand/voice-learnings.md` (mandatory for content generation)
   - Read `companies/voidai/roadmap/voidai-marketing-roadmap.md` Section 10 (Lending Platform Launch Sequence)

2. **Gather inputs:**
   - Phase number (1-5, required):
     - Phase 1: Cryptic hints, curiosity-building ("What if you could access liquidity without selling your TAO?")
     - Phase 2: Full product reveal, architecture details, explainer thread
     - Phase 3: Documentation, tutorials, "How to use" content
     - Phase 4: Testnet countdown, community participation, bug bounty
     - Phase 5: Post-launch metrics, TVL milestones, user testimonials
   - Platform: x (default), linkedin, discord, blog
   - Metrics data (optional, for Phases 4-5)

3. **Generate content:**
   - Match the escalation tone for the phase
   - Phase 1: Mysterious, short, no details
   - Phase 2: Technical, comprehensive, transparent
   - Phase 3: Educational, step-by-step, helpful
   - Phase 4: Exciting, community-driven, countdown energy
   - Phase 5: Data-driven, milestone celebrations, growth narrative

4. **Lending-specific compliance:**
   - Use "access liquidity" not "borrow" or "loan"
   - "Variable rate" not "fixed rate" or "guaranteed"
   - Include risk disclosure: smart contract risk, market volatility, liquidation risk
   - "Protocol participation" not "investment"
   - No comparison to bank savings or traditional returns
   - No yield promises or APY numbers unless confirmed by team

5. **Output:**
   - Write to `companies/voidai/queue/drafts/{YYYYMMDD}-lending-{phase}-{short-id}.md`
   - Tag with pillar: bridge-build
   - Include compliance notes in ## Editor Notes
   - Remind user to run `/queue check <id>` for compliance validation
