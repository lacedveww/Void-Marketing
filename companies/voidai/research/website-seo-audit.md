# VoidAI Website & SEO Audit

## Technical Overview

| Field | Value |
|-------|-------|
| URL | voidai.com |
| Framework | Next.js 15 + Tailwind CSS |
| Font | Satoshi |
| Title | "VoidAI: Decentralizing Intelligence" |
| Meta Description | "VoidAI is democratizing access to the AI supply chain through Bittensor." |

## SEO Fundamentals

### What's Working

- **OG tags present** — Open Graph metadata is configured for social sharing
- **Twitter cards present** — Card metadata exists for X/Twitter previews
- **Organization schema** — Structured data with founding date (2024) is present
- **Sitemap exists** — 7 pages indexed: `/`, `/about`, `/roadmap`, `/careers`, `/blogs`, `/privacy-policy`, `/terms-and-conditions`
- **robots.txt** — Configured to allow all crawlers
- **About page** — Solid content covering mission, vision, products, and FAQs
- **Next.js 15** — Modern SSR framework with good SEO capabilities out of the box

### Critical Issues

| Priority | Issue | Impact |
|----------|-------|--------|
| **P0** | Roadmap page contains Lorem Ipsum placeholder text | Destroys credibility; Google may flag as thin/spam content |
| **P0** | Twitter card references @voidai instead of @v0idai | Social previews link to wrong/nonexistent account |
| **P1** | Only 1 blog post ("VoidAI 2.0", Dec 5 2025) | Blog is effectively dormant; no SEO content pipeline |
| **P1** | No dedicated product pages (bridge, SDK, staking, lending) | Missing high-intent search traffic for product-specific queries |
| **P1** | No developer documentation linked | Developers cannot find integration guides or API docs |
| **P2** | Meta keywords tag used (outdated approach) | Not harmful but signals outdated SEO practices |
| **P2** | No FAQ page (separate from About) | Missing featured snippet opportunities for common questions |

### Missing Pages

These pages should exist to capture product-specific search traffic and provide proper information architecture:

| Page | Search Intent | Priority |
|------|--------------|----------|
| `/bridge` | "VoidAI bridge", "Bittensor cross-chain bridge" | High |
| `/sdk` | "VoidAI SDK", "Bittensor SDK" | High |
| `/staking` | "TAO staking", "VoidAI staking" | High |
| `/lending` | "TAO lending", "Bittensor lending" | High |
| `/docs` or `/developers` | Developer integration, API reference | High |
| `/tutorials` | "How to bridge TAO", "How to stake TAO" | Medium |
| `/faq` | Common questions, featured snippet capture | Medium |
| `/ecosystem` | Partner/integration showcase | Medium |

## Content Strategy Gaps

### Blog (Currently 1 Post)

The blog should be VoidAI's primary SEO engine. Target keywords and topics:

- **"Bittensor cross-chain"** — explain VoidAI's bridge and why it matters
- **"TAO staking guide"** — tutorial content with high search intent
- **"Subnet 106 explained"** — educational content for Bittensor community
- **"Cross-chain interoperability DeFi"** — broader DeFi audience capture
- **"Chainlink CCIP integration"** — leverage Chainlink's brand for search traffic

### Recommended Publishing Cadence

- Minimum 2 blog posts/month to start
- Target 1 post/week by month 3
- Mix of product updates, tutorials, and thought leadership

## Recommendations

### Immediate Fixes (This Week)

1. **Remove Lorem Ipsum from roadmap page** — Replace with actual roadmap content or take the page down temporarily
2. **Fix Twitter card handle** — Change `@voidai` to `@v0idai` in meta tags
3. **Remove meta keywords tag** — It provides no SEO value and signals outdated practices

### Short-Term (Month 1)

4. **Create product landing pages** — At minimum: `/bridge`, `/staking`, `/lending` with proper H1s, meta descriptions, and structured data
5. **Publish 2–4 blog posts** — Focus on high-intent keywords: "how to bridge TAO", "Bittensor cross-chain explained"
6. **Add internal linking** — Connect product pages to blog posts and vice versa
7. **Set up Google Search Console** — Monitor indexing, click-through rates, and keyword rankings

### Medium-Term (Month 2–3)

8. **Build developer docs section** — Even a simple docs page with API references and integration guides
9. **Create tutorial content** — Step-by-step guides for each product (bridge, stake, lend)
10. **Implement FAQ schema** — Add FAQ structured data to product pages and the dedicated FAQ page
11. **Add blog RSS feed** — Enable content syndication and automated social posting
12. **Monitor Core Web Vitals** — Next.js 15 should perform well, but verify with PageSpeed Insights

### Tracking & Metrics

- **Google Search Console**: Impressions, clicks, average position for target keywords
- **Google Analytics**: Organic traffic, bounce rate, pages/session
- **Blog metrics**: Posts published, organic traffic per post, keyword rankings
- **Technical SEO**: Core Web Vitals scores, crawl errors, index coverage
