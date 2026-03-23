# Step 2: SEO Machine Installation & Configuration

**Date**: 2026-03-13
**Status**: COMPLETE

## What Was Done

### 1. Repository Cloned
- Source: `https://github.com/TheCraigHewitt/seomachine.git`
- Location: `/Users/vew/Apps/Void-AI/seomachine/`

### 2. Context Files Configured for VoidAI

All 7 context files in `/Users/vew/Apps/Void-AI/seomachine/context/` were replaced with VoidAI-specific content (original templates were generic Castos-focused placeholders):

| File | Description | Key Content |
|------|-------------|-------------|
| `brand-voice.md` | Voice registers, compliance rules, audience | 4 voice pillars (Builder-Credibility 40%, Alpha-Leak 25%, Community-Educator 25%, Culture 10%), full compliance rules with required language substitutions, mandatory disclaimers for YMYL content |
| `features.md` | Products, differentiators, use cases | Cross-chain bridge, SN106/VOID, SDK, lending (upcoming), non-custodial architecture, Chainlink CCIP, 34 open-source repos |
| `seo-guidelines.md` | SEO rules, YMYL considerations, schema | YMYL/E-E-A-T requirements, content length targets, keyword density, schema markup priorities (FAQPage, HowTo, Article, Organization), compliance disclaimers |
| `competitor-analysis.md` | Competitive landscape, content gaps | Project Rubicon (direct), Wormhole/LayerZero/Axelar (indirect), Bittensor ecosystem tools (adjacent). Key finding: Bittensor DeFi content is nearly nonexistent -- massive first-mover opportunity |
| `target-keywords.md` | 5 topic clusters, priority pipeline | Cluster 1: Bittensor Bridge (CORE), Cluster 2: Bittensor Ecosystem, Cluster 3: Cross-chain DeFi, Cluster 4: Tutorials, Cluster 5: VoidAI Branded. Priority pipeline with immediate, next-quarter, and long-term targets |
| `internal-links-map.md` | Internal linking targets, best practices | Homepage, bridge app, staking page, SDK docs, blog index, GitHub. Placeholder URLs flagged for confirmation. Topic-based quick reference linking guide |
| `style-guide.md` | Grammar, formatting, terminology | Bittensor-native terminology guide, required language substitutions, heading hierarchy, code example standards (Python/TypeScript), mandatory disclaimer placement rules |

### 3. Environment Configuration

- `.env.example` created at `/Users/vew/Apps/Void-AI/seomachine/data_sources/config/.env.example`
- API keys needed:
  - **DataForSEO**: Login + password (SERP analysis, keyword research)
  - **GA4**: Property ID + service account credentials JSON
  - **GSC**: Site URL (shares GA4 service account)
  - **WordPress**: URL + username + app password (blog publishing)

### 4. Pre-Existing Files Preserved

The following context files that came with the repo were NOT modified (they are not VoidAI-specific templates):
- `cro-best-practices.md` -- conversion rate optimization guidelines (generic, still useful)
- `writing-examples.md` -- example content patterns (generic, still useful)

## Action Items for Vew

- [ ] Confirm bridge app URL (placeholder in internal-links-map.md)
- [ ] Confirm staking/SN106 page URL (placeholder in internal-links-map.md)
- [ ] Confirm SDK documentation URL (placeholder in internal-links-map.md)
- [ ] Set up DataForSEO account and add credentials to `.env`
- [ ] Set up GA4 and GSC API access, add credentials
- [ ] Set up WordPress application password for publishing
- [ ] Install `seo-machine-yoast-rest.php` WordPress MU-plugin (see `wordpress/` directory)
- [ ] Run `pip install -r data_sources/requirements.txt` to install Python dependencies
- [ ] Test API connectivity with `python3 test_dataforseo.py`

## Next Steps

With seomachine configured, the next priorities are:
1. Set up API credentials and test connectivity
2. Run `/research bittensor bridge` to generate first keyword research brief
3. Create pillar content for Cluster 1 (Bittensor Bridge) -- highest priority, near-zero competition
4. Create "How to Bridge TAO to Solana" tutorial -- VoidAI's key differentiator keyword

## Architecture Notes

- **Commands**: Slash commands in `.claude/commands/` (e.g., `/research`, `/write`, `/optimize`)
- **Agents**: Specialized roles in `.claude/agents/` (SEO Optimizer, Meta Creator, Internal Linker, etc.)
- **Pipeline**: `topics/` -> `research/` -> `drafts/` -> `review-required/` -> `published/`
- **Python scripts**: Research and analysis tools (run from repo root)
- **Context files**: Brand guidelines that inform all content generation
