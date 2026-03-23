# Website SEO Fix Recommendations

**For:** VoidAI Dev Team
**From:** Marketing (Vew)
**Date:** 2026-03-13
**Scope:** Actionable fixes for voidai.com, organized by priority. Each fix includes what, why, exact implementation, expected impact, and effort estimate.

---

## P0 — Before Any Content Goes Live

These are blockers. If we drive any traffic to the site before these are fixed, visitors hit credibility-destroying issues. Nothing else matters until these are done.

---

### P0-1: Remove Lorem Ipsum from voidai.com/roadmap

**What:** The /roadmap page contains Lorem Ipsum placeholder text.

**Why:** Any user, journalist, or partner who navigates to /roadmap immediately questions whether VoidAI is legitimate. Google quality raters flag placeholder content as low-quality/abandoned. For a YMYL (Your Money Your Life) domain handling financial assets, this tanks our E-E-A-T score. This is the single most damaging issue on the site.

**Exact Fix (pick one):**

**Option A — Replace with real content (preferred):**
1. Remove all Lorem Ipsum text.
2. Replace with a structured roadmap using these milestones:
   - **Completed:** Cross-chain bridge (Bittensor to Solana/EVM), Chainlink CCIP integration, SN106 subnet activation, wTAO on Solana, SDK release
   - **In Progress:** Lending platform development
   - **Upcoming:** New chain integrations, SDK v2, governance features
3. Use timeline/milestone layout consistent with existing design system (dark background, Space Grotesk headings, Inter body).
4. Each milestone: title + 1-2 sentence description + status indicator (Completed / In Progress / Upcoming).

**Option B — Take the page down temporarily:**
1. Remove /roadmap from the navigation menu.
2. Add `<meta name="robots" content="noindex">` to the page.
3. Set up a 302 (temporary) redirect from /roadmap to /about.
4. Remove /roadmap from sitemap.xml.
5. Reinstate when real content is ready.

**Expected Impact:** Eliminates the most severe credibility risk. Unblocks all content marketing.

**Effort:** Option B: 15-30 min. Option A: 1-2 hours (depending on content readiness).

---

### P0-2: Fix Twitter Card Meta Tag Handle

**What:** Twitter card meta tags reference `@voidai` instead of `@v0idai` (with a zero).

**Why:** Every time a voidai.com URL is shared on X, the preview card attributes content to the wrong account. Link clicks don't route engagement to our actual account, social previews look broken, and brand mentions via shared links go to the wrong entity.

**Exact Fix:**

Locate the Twitter card meta tags in your Next.js metadata configuration. Likely in one of:
- `app/layout.tsx` (metadata export)
- A shared `metadata.ts` config file
- A `<Head>` component in the root layout

```html
<!-- WRONG -->
<meta name="twitter:site" content="@voidai" />
<meta name="twitter:creator" content="@voidai" />

<!-- CORRECT -->
<meta name="twitter:site" content="@v0idai" />
<meta name="twitter:creator" content="@v0idai" />
```

If using the Next.js metadata API:

```typescript
export const metadata: Metadata = {
  twitter: {
    site: '@v0idai',    // was @voidai
    creator: '@v0idai', // was @voidai
    card: 'summary_large_image',
  },
};
```

**Verify after deploy:** Paste any voidai.com URL into the [X Card Validator](https://cards-dev.twitter.com/validator) or share in a draft tweet to check the preview.

**Expected Impact:** All social shares correctly attribute to @v0idai. Increases click-through from X previews.

**Effort:** 5 minutes code change + deploy.

---

### P0-3: Remove the Meta Keywords Tag

**What:** The site includes a `<meta name="keywords">` tag.

**Why:** Google confirmed in 2009 they don't use meta keywords as a ranking signal. Its presence signals outdated SEO to anyone inspecting source code (journalists, partners, investors). It also exposes target keywords to competitors.

**Exact Fix:**

```html
<!-- REMOVE THIS LINE -->
<meta name="keywords" content="..." />
```

In Next.js metadata API, remove the `keywords` property:

```typescript
export const metadata: Metadata = {
  // Remove the 'keywords' property entirely
  title: "VoidAI: Decentralizing Intelligence",
  description: "...",
};
```

**Expected Impact:** Minor credibility improvement. Prevents competitor keyword leakage.

**Effort:** 2 minutes.

---

## P1 — First Week

Complete these within the first 7 days. They fix missing information architecture and broken discovery pathways.

---

### P1-1: Create Product Landing Pages

**What:** VoidAI has zero dedicated product pages on the main domain. The bridge, staking, SDK, and lending exist only as app subdomains or docs with no SEO-optimized marketing pages.

**Why:** Users searching "VoidAI bridge" or "Bittensor cross-chain bridge" find no dedicated page. App pages (app.voidai.com/bridge-chains) behind wallet-connect interfaces have minimal crawlable text and don't index well.

**Pages to create (priority order):**

| Priority | URL | Primary Keyword | Content Needed |
|----------|-----|----------------|----------------|
| 1 | /bridge | bittensor bridge | What the bridge does, supported chains (Bittensor, Solana, Ethereum), Chainlink CCIP security, non-custodial architecture, CTA to app.voidai.com/bridge-chains |
| 2 | /staking | bittensor staking, SN106 | SN106 overview, how network participation works, current metrics, variable rate rewards disclosure, CTA to app.voidai.com/stake |
| 3 | /lending | TAO lending | Coming soon page with email capture, what the lending platform will offer, risk disclosures, waitlist CTA |
| 4 | /sdk or /developers | VoidAI SDK | SDK overview, supported languages (Python, TypeScript), link to docs.voidai.com, GitHub link, code examples |

**Requirements for each page:**
- Unique H1 with primary keyword
- Meta title (50-60 chars) and description (150-160 chars) with primary keyword
- At least 500-800 words of crawlable text
- Internal links to blog posts and other product pages
- Structured data: Product schema or WebPage schema
- Compliance disclaimer at bottom (see below)
- CTA button linking to app page or docs
- **FCA/MiCA compliance:** Product pages with CTAs are promotional content visible to UK/EU audiences. Must include: "Don't invest unless you're prepared to lose all the money you invest."
- **Staking/lending pages specifically:** Must include variable rate/risk disclaimers

**Expected Impact:** Captures product-specific search traffic with no current landing destination. Near-zero competition for Bittensor DeFi product keywords — estimated 50-200 monthly organic visits per page within 3 months.

**Effort:** 6-8 hours per page (design + compliance-compliant copy + structured data). Total: 24-32 hours for all four.

---

### P1-2: Establish Blog Infrastructure

**What:** The blog at voidai.com/blogs has 1 post ("VoidAI 2.0", December 2025). Effectively dormant.

**Why:** A blog with a single 3+ month old post signals to Google and visitors that the project is inactive. For a YMYL domain, content freshness is a critical ranking factor.

**Structural fixes needed:**

1. **Categories/tags system.** Categories: Bridge & Build, Ecosystem Intelligence, Alpha & Education, Tutorials. Tags: Bittensor, TAO, DeFi, Cross-Chain, SN106, Chainlink CCIP, Staking, Bridge, SDK, Lending.
2. **Author attribution.** Each post needs a visible author name + link to /about. Critical for E-E-A-T in YMYL content.
3. **"Last Updated" date.** Display both published and last-updated dates. Crypto moves fast — signals content maintenance.
4. **Reading time estimate.** Reduces bounce rate on technical content.
5. **Related posts section.** 2-3 related posts at bottom of each post. Increases pages-per-session.
6. **Table of contents.** Auto-generated from H2/H3 for posts over 1,500 words. Can generate sitelinks in search results.
7. **URL structure.** Confirm clean, keyword-rich slugs (e.g., `/blogs/bittensor-bridge-guide`). If changing `/blogs` to `/blog` is possible without breaking existing URLs, do so with a 301 redirect.
8. **RSS feed.** Required for content syndication and automated social posting. Next.js can generate via API route.

**Expected Impact:** Transforms the blog from a dead asset into an SEO engine.

**Effort:** 10-15 hours total.

---

### P1-3: Add Developer Documentation Links

**What:** No visible link from voidai.com to docs.voidai.com or github.com/v0idai.

**Why:** Developers searching "VoidAI SDK" or "VoidAI documentation" land on voidai.com with no path to docs or code. Linking also passes authority to the docs subdomain.

**Exact Fix:**
1. Add "Developers" or "Docs" link to main nav → docs.voidai.com
2. Add "GitHub" link to footer → github.com/v0idai
3. Ensure the link does NOT use `rel="nofollow"` — subdomains benefit from followed links

**Expected Impact:** Captures developer intent traffic. Passes link authority to docs subdomain.

**Effort:** 30 minutes.

---

### P1-4: Internal Linking Foundation

**What:** With only 7 pages and 1 blog post, minimal internal linking exists. Need architecture in place before new content is added.

**Exact Fix:**

1. **Navigation update:**
   - Products dropdown: Bridge, Staking, SDK, Lending (coming soon)
   - Resources dropdown: Blog, Docs, GitHub

2. **Footer link block:**
   - Products: Bridge, Staking, Lending, SDK
   - Resources: Blog, Documentation, GitHub
   - Company: About, Roadmap, Careers
   - Legal: Privacy Policy, Terms

3. **Blog post template additions:**
   - Related posts (topic-based)
   - Links to relevant product pages
   - CTA box linking to primary product for that topic

4. **Breadcrumbs:** Implement on all pages (e.g., Home > Blog > Post Title). Add BreadcrumbList schema markup.

**Expected Impact:** Creates coherent topic cluster architecture. Distributes page authority to product pages. Reduces bounce rate.

**Effort:** 2-3 hours for nav/footer. Blog linking is ongoing.

---

## P2 — Before Soft Launch

Enhances search visibility through rich results, social sharing, and content discoverability.

---

### P2-1: Create Dedicated FAQ Page

**What:** FAQ content exists embedded in /about but no standalone /faq page.

**Why:** FAQPage schema markup captures "People Also Ask" positions in Google results — these appear above standard organic results. Near-zero competition for Bittensor/DeFi questions means VoidAI can own these featured positions immediately.

**Exact Fix:**
1. Create standalone /faq page
2. Sections: General, Bridge, Staking/SN106, SDK/Developers, Lending (when applicable), Security
3. Each Q as H2/H3 with concise answer (40-60 words) — optimal for featured snippet capture
4. Implement FAQPage JSON-LD schema:

```json
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "How do I bridge TAO to Solana?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Connect your Bittensor and Solana wallets to the VoidAI bridge at app.voidai.com/bridge-chains. Select TAO as the source asset and Solana as the destination chain. Enter the amount, confirm the transaction, and the bridge processes your transfer using Chainlink CCIP."
      }
    }
  ]
}
```

5. Include mandatory compliance disclaimers (full long-form at bottom + risk disclaimers in answers about rewards/bridge operations)

**Expected Impact:** Estimated 100-300 monthly organic visits within 3 months.

**Effort:** 2-3 hours.

---

### P2-2: Implement Comprehensive Schema Markup

**What:** Site has basic Organization schema only. No Article, FAQPage, HowTo, Product, or BreadcrumbList schema.

**Why:** Schema enables rich results — FAQ accordions, how-to steps, breadcrumbs — which increase CTR by 20-40% vs plain blue links.

**Schemas to add:**

| Schema | Where | Priority |
|--------|-------|----------|
| Article | Every blog post | High |
| FAQPage | /faq + FAQ sections in posts | High |
| HowTo | Tutorial blog posts | High |
| BreadcrumbList | All pages | High |
| Organization | Site-wide (enhance existing) | Medium |
| Product | /bridge, /staking, /sdk | Medium |
| WebSite | Homepage | Medium |

**Implementation:** Use JSON-LD via Next.js metadata API. Create a reusable schema component:

```typescript
// components/StructuredData.tsx
export function ArticleSchema({ title, description, datePublished, dateModified, author, image }: ArticleSchemaProps) {
  const schema = {
    "@context": "https://schema.org",
    "@type": "Article",
    headline: title,
    description,
    datePublished,
    dateModified,
    author: { "@type": "Person", name: author, url: "https://voidai.com/about" },
    publisher: {
      "@type": "Organization",
      name: "VoidAI",
      url: "https://voidai.com",
      logo: { "@type": "ImageObject", url: "https://voidai.com/logo.png" }
    },
    image,
  };
  return <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(schema) }} />;
}
```

**Expected Impact:** 20-40% CTR increase on pages with rich results.

**Effort:** 4-6 hours initial. Blog schemas auto-generate from frontmatter after that.

---

### P2-3: Create and Optimize Open Graph Images

**What:** OG tags exist but likely use a generic site-wide image. No per-page OG images.

**Why:** Custom OG images increase CTR from social shares by 30-50%. Our content strategy relies heavily on X threads linking back to blog posts — a generic preview image is a significant traffic leak.

**Exact Fix:**

1. **Create branded OG template:**
   - Dimensions: 1200x630px (OG standard) + 1200x675px (X summary_large_image)
   - Dark background (#0A0A0F), VoidAI logo, Space Grotesk headline, accent color highlights

2. **Dynamic OG generation for blog posts** (recommended):

```typescript
// app/blog/[slug]/opengraph-image.tsx
import { ImageResponse } from 'next/og';

export default async function Image({ params }: { params: { slug: string } }) {
  const post = await getPost(params.slug);
  return new ImageResponse(
    <div style={{ /* VoidAI brand styling */ }}>
      <h1>{post.title}</h1>
      <p>VoidAI Blog</p>
    </div>,
    { width: 1200, height: 630 }
  );
}
```

3. **Validate after deploy:** X Card Validator, Facebook Sharing Debugger, LinkedIn Post Inspector.

**Expected Impact:** 30-50% increase in click-through from social shares.

**Effort:** 2-3 hours for template + dynamic generation. Static per-page images: 15-30 min each.

---

### P2-4: Sitemap Optimization

**What:** Current sitemap indexes 7 pages with no priority signals or last-modified dates.

**Why:** As product pages and blog posts are added, the sitemap must ensure Google crawls them within 24-48 hours instead of waiting for natural crawl cycles.

**Exact Fix:**

1. **Switch to dynamic sitemap generation:**

```typescript
// app/sitemap.ts
export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const posts = await getAllBlogPosts();
  const blogEntries = posts.map(post => ({
    url: `https://voidai.com/blogs/${post.slug}`,
    lastModified: post.updatedAt,
    changeFrequency: 'monthly' as const,
    priority: 0.7,
  }));

  return [
    { url: 'https://voidai.com', lastModified: new Date(), changeFrequency: 'weekly', priority: 1.0 },
    { url: 'https://voidai.com/bridge', priority: 0.9 },
    { url: 'https://voidai.com/staking', priority: 0.8 },
    { url: 'https://voidai.com/sdk', priority: 0.7 },
    { url: 'https://voidai.com/about', priority: 0.6 },
    { url: 'https://voidai.com/faq', priority: 0.7 },
    { url: 'https://voidai.com/blogs', priority: 0.8 },
    ...blogEntries,
  ];
}
```

2. Remove /roadmap from sitemap if Option B (takedown) is chosen for P0-1.
3. Ensure robots.txt references the sitemap:

```
User-agent: *
Allow: /
Sitemap: https://voidai.com/sitemap.xml
```

4. Submit updated sitemap to Google Search Console after deploy.

**Expected Impact:** New pages indexed within 24-48 hours.

**Effort:** 1-2 hours. Automatic for new content after setup.

---

### P2-5: Meta Description Optimization

**What:** The current site-wide meta description is generic: "VoidAI is democratizing access to the AI supply chain through Bittensor."

**Why:** Meta descriptions are the sales copy that appears in search results. A compelling, keyword-rich description increases CTR. Each page should have a unique description targeting its primary keyword.

**Exact Fix — per-page descriptions:**

| Page | Meta Description (150-160 chars) |
|------|----------------------------------|
| Homepage | "VoidAI connects Bittensor to Solana and EVM chains via Chainlink CCIP. Bridge TAO, participate in SN106, and access cross-chain DeFi. Non-custodial." |
| /bridge | "Bridge TAO between Bittensor, Solana, and Ethereum with VoidAI. Secured by Chainlink CCIP. Non-custodial cross-chain transfers." |
| /staking | "Participate in Bittensor Subnet 106 with VoidAI. SN106 network participation with variable rate rewards. Non-custodial." |
| /lending | "VoidAI Lending brings DeFi to Bittensor. Access liquidity from your TAO position. Coming soon. Non-custodial." |
| /sdk | "Build on Bittensor with the VoidAI SDK. Python and TypeScript support. Cross-chain bridge integration for developers." |
| /about | "VoidAI is the economic infrastructure layer connecting Bittensor's intelligence to global liquidity. 34 repos, SN106, Chainlink CCIP." |
| /faq | "Common questions about VoidAI: how to bridge TAO, what is SN106, supported chains, fees, security, and the non-custodial architecture." |

**Expected Impact:** Improved CTR from search results with targeted, keyword-rich descriptions.

**Effort:** 30 minutes.

---

## Priority Summary

| Fix | Priority | Effort | Impact |
|-----|----------|--------|--------|
| P0-1: Remove Lorem Ipsum | BLOCKER | 15 min - 2 hr | Eliminates worst credibility risk |
| P0-2: Fix Twitter handle | BLOCKER | 5 min | Fixes all social share attribution |
| P0-3: Remove meta keywords | BLOCKER | 2 min | Minor credibility fix |
| P1-1: Product landing pages | Week 1 | 24-32 hr | Captures product search traffic |
| P1-2: Blog infrastructure | Week 1 | 10-15 hr | Enables content pipeline |
| P1-3: Dev docs links | Week 1 | 30 min | Developer traffic + link authority |
| P1-4: Internal linking | Week 1 | 2-3 hr | Site architecture + authority flow |
| P2-1: FAQ page | Pre-launch | 2-3 hr | Featured snippet positions |
| P2-2: Schema markup | Pre-launch | 4-6 hr | 20-40% CTR increase |
| P2-3: OG images | Pre-launch | 2-3 hr | 30-50% social CTR increase |
| P2-4: Sitemap optimization | Pre-launch | 1-2 hr | Faster indexing |
| P2-5: Meta descriptions | Pre-launch | 30 min | Better search CTR |

**Total P0 effort:** ~15 minutes to 2 hours
**Total P1 effort:** ~37-51 hours
**Total P2 effort:** ~10-15 hours

P0 fixes can be shipped today. Start there.
