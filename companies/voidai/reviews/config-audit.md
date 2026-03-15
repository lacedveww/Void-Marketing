# Config Audit: VoidAI Company Configuration
**Date**: 2026-03-13
**Auditor**: code-reviewer agent
**Source of truth**: `/Users/vew/Apps/Void-AI/CLAUDE.md` (595 lines)

## Scope

Verified that all critical information from CLAUDE.md was properly extracted into the company config files at `companies/voidai/`. Checked completeness, accuracy, and structural integrity of each config file.

## Files Audited

| File | Status | Notes |
|------|--------|-------|
| company.md | PASS (fixed) | All products, architecture, context present. Added missing `docs.voidai.com` URL. |
| voice.md | PASS | All voice registers, banned phrases (21/21), em dash ban, platform tones, priority hierarchy, self-improving loop extracted correctly. |
| accounts.md | PASS | All 6 accounts (1 main + 5 satellites) fully defined. Inter-account coordination, timing, cross-promotion limits, owned accounts (SubnetSummerT, gordonfrayne) all present. |
| compliance.md | PASS | All absolute prohibitions, language substitutions, context-dependent rules, per-account guidance, 6 disclaimer templates (social, blog, rates, lending, video, podcast), influencer rules, jurisdictional table (UK/EU/SG/UAE), human review gate extracted correctly. Compliance modules (crypto-sec, crypto-fca, crypto-mica, crypto-ofac) listed. |
| pillars.md | PASS | All 4 pillars with weights match CLAUDE.md. Pillar-to-account mapping table is a useful addition not in CLAUDE.md. Anchor metrics reference included. |
| cadence.md | PASS | All 6 account schedules, cadence rules, weekend rules match CLAUDE.md. Reply cadence section is an addition. |
| design-system.md | PASS | Visual identity, partner badges, image guidelines, social media format dimensions all present. |
| metrics.md | PASS | Comprehensive. Anchor metrics, market context (TAO price, halving data, network growth), product-specific metrics (bridge, SN106), token metrics (VOID/SN106), data sources with URLs, freshness caveats, update cadence all present. |
| competitors.md | PASS | Primary competitor (Project Rubicon), category competitors (Tensorplex, TaoFi, Wormhole, LayerZero, Axelar), competitive response frameworks (5 scenarios), monitoring setup, SN106 positioning among peers all present. |
| crisis.md | CREATED | Was missing entirely. Crisis communication protocol (CLAUDE.md lines 476-536) extracted into new file. |

## Gaps Found and Remediated

### Critical (must fix)

None.

### Warnings (should fix) -- FIXED

1. **Missing `docs.voidai.com` in company.md product table.** The documentation site URL was referenced in user memory as a key product URL but was absent from the products table. Fixed: added Documentation row to products table.

2. **Crisis communication protocol not in company config.** The full crisis protocol (activation triggers, immediate response steps, response templates, per-account behavior, post-crisis procedures) was only in CLAUDE.md. For the system to operate from company configs alone, this needed its own file. Fixed: created `crisis.md`.

### Suggestions (consider improving)

1. **Prompt injection safeguards** (CLAUDE.md lines 539-572) are not in the company config. This is correct -- they are engine-level security concerns, not company-specific. No action needed, but documenting the decision here.

2. **Content generation routing** (`/queue add` as canonical entry point, CLAUDE.md lines 15-17) is not in the company config. This is correct -- it is an engine workflow instruction. No action needed.

3. **Voice file priority hierarchy** was adapted in voice.md to reference the new modular structure (engine compliance > company compliance > company voice > learnings > research) rather than the CLAUDE.md-centric hierarchy. This is a good structural change for the modular system.

4. **Design system could be richer.** The primary accent color is listed as "VoidAI primary accent" without a specific hex value. Consider adding the actual hex code when available, along with any secondary/tertiary palette colors.

5. **Metrics freshness.** Several anchor metrics (total value bridged, unique wallets, bridge uptime) are listed as "Not publicly indexed." Consider prioritizing the on-chain analytics dashboard or Dune query setup referenced in the metrics file.

## Verification Checklist

| Check | Result |
|-------|--------|
| 6 X accounts properly defined (1 main + 5 satellites) | PASS |
| Voice guidelines match CLAUDE.md (banned phrases, em dash ban, emoji encouragement) | PASS |
| All 4 content pillars captured with correct weights | PASS |
| Posting cadence defined for all accounts | PASS |
| Compliance modules referenced (crypto-sec, crypto-ofac, crypto-fca, crypto-mica) | PASS |
| Product info (Bridge, SN106, SDK, Lending) captured | PASS |
| Key URLs (app.voidai.com/bridge-chains, app.voidai.com/stake, docs.voidai.com) present | PASS (after fix) |
| Metrics/KPIs baseline included | PASS |
| Competitors documented | PASS |
| Crisis protocol documented | PASS (after fix) |
| Inter-account coordination rules present | PASS |
| Satellite naming and FTC disclosure requirements present | PASS |
| Owned accounts (SubnetSummerT, gordonfrayne) documented | PASS |

## Conclusion

The extraction from CLAUDE.md to modular company config files was thorough. Two gaps were found and fixed during this audit: the missing `docs.voidai.com` URL and the missing crisis communication protocol file. All other content was verified as complete and accurate against the 595-line CLAUDE.md source.
