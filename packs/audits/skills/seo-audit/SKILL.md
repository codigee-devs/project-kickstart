---
name: seo-audit
description: Audit a live website for SEO - crawlability and indexation, metadata and headings, canonical and hreflang, sitemap and robots (including AI crawlers), structured data, Core Web Vitals, internal linking, content quality and AI-answer visibility - and produce a prioritized fix list. Use before or after a launch, a migration or a redesign, or when traffic drops. Triggers - "SEO audit", "audit the website", "why is traffic down", "check indexing", "audyt SEO", "przeanalizuj SEO strony", "sprawdz indeksowanie".
---

# seo-audit

Read-only. Measure the live site (or a production preview), not the source code alone. To implement fixes on a Next.js site use `site-seo`.

## 1. Inputs

- The domain and the five to ten most important pages (home, main offers, top articles, contact).
- Access to Search Console and analytics if the user has them. If not, say which findings are therefore estimates.

## 2. Crawl and index

```bash
curl -s https://<site>/robots.txt
curl -s https://<site>/sitemap.xml | grep -c '<loc>'
curl -sIL https://<site>/<page> | grep -iE '^HTTP|^location|x-robots-tag'
```

- robots: no accidental `Disallow: /`; sitemap referenced; AI crawler rules deliberate.
- Sitemap: only canonical, indexable, 200 URLs; no redirects or 404s inside.
- Redirect chains: one hop max. http -> https and www rules consistent.
- Each important page: 200, indexable (no `noindex`), self-canonical.
- `site:<domain>` search and Search Console coverage: indexed count vs sitemap count.

## 3. Per page

| Check | Pass when |
|---|---|
| Title | unique, 50-60 chars, topic first |
| Meta description | unique, 120-155 chars, says what the visitor gets |
| h1 | exactly one, matches the page intent |
| Headings | logical order, descriptive |
| Canonical | absolute, self, matches the final URL |
| hreflang | only for real translations, reciprocal, with x-default |
| Images | alt text, modern formats, sized |
| Links | internal links to and from related pages, no broken links |
| Structured data | valid, matches visible content |

Collect it with a script over the page list:

```bash
for u in $(cat pages.txt); do
  html="$(curl -s "$u")"
  printf '%s\n  title: %s\n  h1: %s\n  canonical: %s\n' "$u" \
    "$(printf '%s' "$html" | grep -o '<title>[^<]*' | head -1 | cut -c8-)" \
    "$(printf '%s' "$html" | grep -o '<h1[^>]*>[^<]*' | head -1 | sed 's/<h1[^>]*>//')" \
    "$(printf '%s' "$html" | grep -o 'rel="canonical" href="[^"]*' | cut -d'"' -f4)"
done
```

## 4. Performance

Lighthouse mobile on the key pages (see `site-quality`): LCP, CLS, TBT, and the top opportunities. Field data from Search Console's Core Web Vitals report beats lab numbers.

## 5. Content and intent

- Does each key page answer one clear search intent, in the words people search for? One topic per page; two pages competing for the same query is a finding (cannibalization).
- Thin pages (little unique text), outdated facts, missing author or date on articles.
- Proof on the page: concrete results, examples, case studies, named people where allowed.

## 6. AI-answer visibility

- Can AI crawlers fetch the pages (robots, no blocking WAF rules)?
- Is the important content in the HTML (not only rendered by client JavaScript)?
- Clear, quotable statements: what the company does, for whom, where, prices or ranges if public, FAQ sections that answer real questions.
- `Organization` structured data with `sameAs` links to the real profiles.

## 7. Report

Score each area (crawl, on-page, technical, content, performance, AI visibility). Then:

- **Critical** (blocks indexing or ranking now)
- **Warnings**
- **Good** (keep doing it)
- **Fix list** in order of impact vs effort, each with the exact page and change.

For a document to share, render it with `app-audit-report`.
