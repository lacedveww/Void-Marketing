# Skills Cleanup Report — VoidAI Marketing System

**Date**: 2026-03-13
**Assessed by**: Claude (automated audit)
**Scope**: All 36 skills in `/Users/vew/Apps/Void-AI/.claude/skills/`

---

## Summary

| Category | Count | Action |
|----------|:-----:|--------|
| KEEP — Relevant and functional | 7 | No action needed |
| KEEP WITH CAUTION — Usable but generic | 8 | Use selectively, watch for SaaS assumptions |
| RECOMMEND DISABLE — Irrelevant to VoidAI | 21 | Disable or remove |

---

## KEEP — Core Skills (7)

These skills are functional, relevant to VoidAI's crypto/DeFi marketing, and actively used.

| Skill | Why Keep |
|-------|---------|
| `queue-manager` | Core content lifecycle manager. Custom-built for VoidAI. Essential. |
| `twitter-algorithm-optimizer` | Directly supports X strategy (primary channel). Compliance preamble added this session. |
| `social-content` | General social media content creation. Supports X, LinkedIn, Discord content workflows. |
| `content-strategy` | Helps plan content pillars, topics, editorial calendar. Adaptable to crypto. |
| `product-marketing-context` | Foundational context document. All other skills reference it. |
| `copy-editing` | Editing/polishing existing marketing copy. Platform-agnostic, useful for all content. |
| `copywriting` | Writing marketing copy. Adaptable to crypto landing pages, blog posts, descriptions. |

---

## KEEP WITH CAUTION — Generic but Usable (8)

These skills are functional but designed for SaaS/general marketing. They can be useful for VoidAI if outputs are filtered through CLAUDE.md compliance rules. Watch for SaaS-specific assumptions (trials, subscriptions, pricing pages) that don't apply.

| Skill | Notes |
|-------|-------|
| `ai-seo` | AI search optimization. Relevant for VoidAI docs/blog visibility in ChatGPT, Perplexity, etc. |
| `seo-audit` | Technical SEO auditing. Useful for voidai.com, but VoidAI is not building/editing website (SEO fixes only). |
| `schema-markup` | Structured data. Useful for voidai.com search appearance. |
| `site-architecture` | Website IA/navigation. Limited use (VoidAI not rebuilding site), but helpful for SEO fix recommendations. |
| `content-research-writer` | Research + writing assistant. Useful for blog posts and long-form. No crypto-specific context. |
| `launch-strategy` | Product launch planning. Useful for bridge launches, new chain integrations. Ignore Product Hunt / SaaS-specific advice. |
| `marketing-psychology` | Behavioral science for marketing. Platform-agnostic principles. Useful for community engagement tactics. |
| `analytics-tracking` | GA4, event tracking, UTMs. Useful for tracking bridge traffic, blog, campaign attribution. |

---

## RECOMMEND DISABLE — Irrelevant to VoidAI (21)

These skills are designed for SaaS, e-commerce, or B2B contexts. They reference concepts like subscription churn, signup flows, pricing tiers, cold email outreach, paid ad campaigns, and demo request forms — none of which apply to VoidAI's crypto protocol marketing. They add noise to the skill directory and risk generating off-brand content.

### SaaS Conversion Optimization (7)
| Skill | Why Disable |
|-------|-------------|
| `form-cro` | Lead capture / contact form optimization. VoidAI is a DeFi protocol, not a SaaS product with lead forms. |
| `signup-flow-cro` | Signup/registration flow optimization. VoidAI uses wallet connections, not signup flows. |
| `onboarding-cro` | Post-signup user activation. Not applicable to DeFi protocol onboarding. |
| `page-cro` | Landing page conversion optimization. VoidAI is not doing CRO on marketing pages. |
| `popup-cro` | Popup/modal conversion elements. Not applicable to DeFi protocol marketing. |
| `paywall-upgrade-cro` | In-app paywall/upgrade screens. VoidAI has no paywall or freemium model. |
| `ab-test-setup` | A/B testing for web pages. Not applicable to current VoidAI marketing approach. |

### B2B Sales & Outreach (4)
| Skill | Why Disable |
|-------|-------------|
| `cold-email` | B2B cold outreach emails. VoidAI is not running cold email campaigns. |
| `sales-enablement` | Sales collateral, pitch decks, objection handling. VoidAI has no sales team. |
| `revops` | Revenue operations, lead scoring, CRM automation. Not applicable to protocol marketing. |
| `email-sequence` | Lifecycle email drip campaigns. VoidAI uses Mautic but this skill assumes SaaS email patterns. |

### Paid Advertising (3)
| Skill | Why Disable |
|-------|-------------|
| `paid-ads` | Paid ad campaign strategy (Google, Meta, LinkedIn). Crypto advertising is heavily restricted on these platforms. |
| `ad-creative` | Bulk ad copy generation for paid platforms. Same restriction as paid-ads. |
| `competitive-ads-extractor` | Scrapes competitor ads from Facebook/LinkedIn ad libraries. Not relevant to crypto competitor analysis. |

### SaaS Business Strategy (4)
| Skill | Why Disable |
|-------|-------------|
| `pricing-strategy` | SaaS pricing tiers, freemium models. VoidAI pricing is protocol-level (bridge fees, staking), not SaaS. |
| `churn-prevention` | Subscription churn, cancel flows, save offers. Not applicable to DeFi protocol. |
| `referral-program` | SaaS referral/affiliate programs. VoidAI ambassador program has different mechanics (crypto-native). |
| `free-tool-strategy` | Building free tools for lead gen. Not aligned with VoidAI's current marketing approach. |

### Generic / Wrong Domain (3)
| Skill | Why Disable |
|-------|-------------|
| `marketing-ideas` | Generic SaaS marketing brainstorming. Descriptions explicitly reference "SaaS or software product." |
| `competitor-alternatives` | SaaS "vs" and "alternative" comparison pages. Not how crypto protocols compete. |
| `developer-growth-analysis` | Analyzes developer chat history for coding improvement. Not a marketing skill at all — designed for individual developer self-improvement. References "Rube MCP" for HackerNews search and Slack delivery, which may not be configured. |

### SEO — Marginal (1)
| Skill | Why Disable |
|-------|-------------|
| `programmatic-seo` | Template pages at scale (city pages, directory pages). Not applicable to VoidAI's content strategy. |

---

## Recommendations

1. **Do not delete** any skills yet — just disable by renaming SKILL.md to SKILL.md.disabled or moving to a `disabled/` subdirectory
2. **Priority**: Disable the 21 skills marked above to reduce cognitive load and prevent accidental use
3. **After disabling**: Update the queue-manager Available Templates table if any templates reference disabled skills
4. **Review quarterly**: Some skills (like referral-program, email-sequence) could become relevant if VoidAI launches ambassador or lifecycle email programs

---

## User Skills Directory

Skills in `/Users/vew/.claude/skills/` are user-level and not part of the VoidAI project. No action recommended:
- audit-prs, brainstorming, canvas-design, file-organizer, find-skills, frontend-design, git-commit-helper, project-explorer, remotion-best-practices, senior-prompt-engineer, ui-ux-pro-max, vercel-react-best-practices
