# Step 2: Marketingskills Installation Summary

*Completed: 2026-03-13*

## What Was Done

### 1. Cloned marketingskills repo
- **Source:** `https://github.com/coreyhaines31/marketingskills`
- **Location:** `/Users/vew/Apps/Void-AI/.agents/marketingskills/`
- **Method:** `git clone` (not submodule — Void-AI is not a git repo)
- **Status:** COMPLETE

### 2. Created product-marketing-context.md
- **Location:** `/Users/vew/Apps/Void-AI/.agents/product-marketing-context.md`
- **Source data:** CLAUDE.md (brand voice, compliance, products, personas, satellite accounts)
- **Sections completed:** All 12 sections from the SKILL.md template plus VoidAI-specific additions (Content Pillars, Satellite Accounts, Key References)
- **Status:** COMPLETE

### 3. Symlinked skills to .claude/skills/
- **Status:** PENDING — requires manual command (Bash permission was denied during session)

**Run this command to complete the symlinks:**
```bash
ln -sf /Users/vew/Apps/Void-AI/.agents/marketingskills/skills/* /Users/vew/Apps/Void-AI/.claude/skills/
```

## Skills Installed (32 total)

| # | Skill | Category |
|---|-------|----------|
| 1 | ab-test-setup | Experimentation |
| 2 | ad-creative | Paid Media |
| 3 | ai-seo | SEO |
| 4 | analytics-tracking | Analytics |
| 5 | churn-prevention | Retention |
| 6 | cold-email | Outreach |
| 7 | competitor-alternatives | Competitive |
| 8 | content-strategy | Content |
| 9 | copy-editing | Copy |
| 10 | copywriting | Copy |
| 11 | email-sequence | Email |
| 12 | form-cro | CRO |
| 13 | free-tool-strategy | Growth |
| 14 | launch-strategy | Go-to-Market |
| 15 | marketing-ideas | Ideation |
| 16 | marketing-psychology | Psychology |
| 17 | onboarding-cro | CRO |
| 18 | page-cro | CRO |
| 19 | paid-ads | Paid Media |
| 20 | paywall-upgrade-cro | CRO |
| 21 | popup-cro | CRO |
| 22 | pricing-strategy | Pricing |
| 23 | product-marketing-context | Foundation |
| 24 | programmatic-seo | SEO |
| 25 | referral-program | Growth |
| 26 | revops | Revenue Ops |
| 27 | sales-enablement | Sales |
| 28 | schema-markup | SEO |
| 29 | seo-audit | SEO |
| 30 | signup-flow-cro | CRO |
| 31 | site-architecture | SEO |
| 32 | social-content | Social |

## Pre-existing Skills in .claude/skills/ (4)

These were already installed before this session:
1. twitter-algorithm-optimizer
2. competitive-ads-extractor
3. content-research-writer
4. developer-growth-analysis

## Verification Checklist

- [x] marketingskills repo cloned to `.agents/marketingskills/`
- [x] All 32 skills present in source directory
- [x] product-marketing-context.md created at `.agents/product-marketing-context.md`
- [x] product-marketing-context.md contains all required sections
- [x] product-marketing-context.md aligned with CLAUDE.md brand/compliance rules
- [ ] **PENDING:** Skills symlinked to `.claude/skills/` — run command above

## Product Marketing Context Sections

The context file covers:
1. **Product Overview** — one-liner, products, category, business model
2. **Target Audience** — primary/secondary/tertiary, jobs to be done, use cases
3. **Personas** — TAO Holder, Subnet Operator, DeFi Power User, dTAO Trader, Developer
4. **Problems & Pain Points** — core problem, alternative shortcomings, costs, emotional tension
5. **Competitive Landscape** — Rubicon (direct), general bridges (secondary), CEXs (indirect)
6. **Differentiation** — 6 key differentiators with reasoning
7. **Objections** — 4 objections with responses + anti-personas
8. **Switching Dynamics** — JTBD four forces (push/pull/habit/anxiety)
9. **Customer Language** — verbatim phrases, words to use/avoid, full glossary (14 terms)
10. **Brand Voice** — tone, style, personality, voice registers with weights, platform adjustments
11. **Proof Points** — anchor metrics, notable signals, 6 value themes with proof
12. **Goals** — business goal, 5 conversion actions prioritized, current metrics status
13. **Content Pillars** — 4 pillars with weights and content types
14. **Satellite Accounts** — 3 satellite personas summary (full details in CLAUDE.md)
15. **Key References** — links to all supporting documents

## Next Steps

1. **Run the symlink command** to make skills discoverable by Claude Code
2. Skills are now usable via slash commands (e.g., `/social-content`, `/launch-strategy`, `/copywriting`)
3. All skills will automatically reference `product-marketing-context.md` for VoidAI context
4. Update `product-marketing-context.md` anytime with `/product-marketing-context`
