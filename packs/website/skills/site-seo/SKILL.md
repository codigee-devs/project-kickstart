---
name: site-seo
description: Implement technical SEO on a Next.js site - metadata and canonical per page, hreflang for language pairs, sitemap and robots (including AI crawlers), JSON-LD for organization, articles, FAQ and breadcrumbs, image and heading hygiene, and noindex outside production. Use when adding pages, launching a site, migrating URLs or fixing indexing. Triggers - "SEO for this page", "add schema markup", "sitemap", "robots.txt", "canonical", "hreflang", "redirects after migration", "zrob SEO", "dodaj schema", "mapa strony", "przekierowania".
---

# site-seo

For an audit of an existing site use `seo-audit` (audits pack). This skill implements.

## 1. Every page

- `title` 50-60 characters, primary topic first, brand last.
- `description` 120-155 characters, what the visitor gets.
- Canonical URL, absolute, self-referencing, without query strings. One helper (`getCanonicalLink(path)`) used by every page, returning nothing outside production.
- Exactly one `h1`. Headings in order, no skipped levels for styling.
- OG title, description and a 1200x630 image.

```ts
export function getCanonicalLink(path: string): Pick<Metadata, "alternates"> {
  if (process.env.NEXT_PUBLIC_ENV !== "production") return {};
  return { alternates: { canonical: new URL(path, SITE_URL).toString() } };
}
```

## 2. Language versions

- Only pages that really exist in both languages get hreflang: `en`, `pl` (or yours) and `x-default`, the same set on both sides.
- Put hreflang in page metadata and the sitemap. Avoid adding it as HTTP `Link` headers on every response.
- A translated page is a real translation with its own title and description, not a machine copy.

## 3. Sitemap and robots

- `app/sitemap.ts` lists every indexable URL once, with `lastModified` from real content dates, and alternates for language pairs. Production only.
- `app/robots.ts`: allow the site, disallow API and preview paths, point to the sitemap.
- AI crawlers: decide on purpose. If you want to be cited by AI assistants, allow them explicitly. Named crawler groups in robots replace the `*` group for those bots, so repeat any `Disallow` there.

```ts
export default function robots(): MetadataRoute.Robots {
  const disallow = ["/api/", "/preview/"];
  return {
    rules: [
      { userAgent: "*", allow: "/", disallow },
      { userAgent: ["GPTBot", "ClaudeBot", "PerplexityBot", "Google-Extended"], allow: "/", disallow },
    ],
    sitemap: `${SITE_URL}/sitemap.xml`,
  };
}
```

- Every non-production deploy answers `x-robots-tag: noindex, nofollow` (middleware or headers config), so previews never get indexed.

## 4. Structured data (JSON-LD)

One small helper per type, rendered in a `<script type="application/ld+json">` from server components:

| Page | Types |
|---|---|
| Home | `Organization` (name, url, logo, sameAs), `WebSite` |
| Article | `Article` / `BlogPosting` (headline, datePublished, dateModified, author, image) |
| Case study / service | `Service` or `CreativeWork`, plus `BreadcrumbList` |
| FAQ section | `FAQPage`, only with questions visible on the page |

Validate with the Rich Results Test or the Schema.org validator. Never mark up content that is not on the page.

## 5. URLs and redirects

- Lowercase, hyphenated, no dots, no trailing variants. Pick trailing slash or not and redirect the other.
- Moving or deleting a page: 301 (or 308) from the old URL to the closest new one, in `next.config` redirects. Keep a redirect map file in the repo for migrations and test it (request each old URL, expect one hop to a 200).
- Never redirect everything to the home page.

## 6. Images and performance

- `next/image` with width and height (or `fill` with a sized parent), descriptive `alt` (empty `alt=""` for decoration), modern formats.
- The hero image gets `priority`; nothing else does.
- See `site-quality` for Core Web Vitals.

## 7. Verify

```bash
curl -s https://<preview-or-prod>/<path> | grep -iE '<title>|rel="canonical"|hreflang|application/ld\+json|name="robots"'
curl -sI https://<preview>/<path> | grep -i x-robots-tag
curl -s https://<site>/sitemap.xml | head -40
```

Report what the HTML actually contains, per page checked.
