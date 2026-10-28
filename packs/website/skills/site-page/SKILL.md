---
name: site-page
description: Add a page or a section to a Next.js marketing site the way it stays maintainable - reuse existing components first, thin page.tsx, a View made of parts, content read through services, metadata and canonical on every page, and a check in the browser at phone and desktop width. Use for a new landing page, subpage, dynamic [slug] route or a new section on an existing page. Triggers - "add a page", "new landing page", "new section on the homepage", "add a route for", "dodaj strone", "nowa podstrona", "nowa sekcja na stronie", "landing pod".
---

# site-page

## 0. Reuse first

Before writing any UI:

```bash
ls src/components src/components/* | head -100
grep -rln "export default function\|export function" src/components src/views/*/parts | head -50
```

Look for an existing heading, paragraph, button, container, card, section, animation wrapper and form. If one almost fits, add a prop or variant to it. Do not create a new shared component without asking; a marketing site with five button implementations is a site nobody can restyle.

## 1. Layers

```
src/app/<route>/page.tsx            thin: get data, render View, export metadata
src/views/<Name>View/<Name>View.tsx server component that composes parts
src/views/<Name>View/parts/*.tsx    sections, barrel parts/index.ts
src/components/...                  shared UI, reused
src/services/<feature>.ts           content access and logic
```

No fetching or business logic in parts or components. `"use client"` only on leaves that need state or events (slider, modal, form); the server parent passes data down as props.

## 2. page.tsx

Static:

```tsx
import type { Metadata } from "next";
import { getCanonicalLink } from "@/services/seo";
import PricingView from "@/views/PricingView/PricingView";

export const metadata: Metadata = {
  title: "Pricing | <Brand>",
  description: "One sentence that says what the visitor gets and for whom, under ~155 characters.",
  ...getCanonicalLink("/pricing"),
};

export default function Page() {
  return <PricingView />;
}
```

Dynamic route:

```tsx
export async function generateStaticParams() {
  return (await CaseStudies.all()).map(({ slug }) => ({ slug }));
}

export async function generateMetadata({ params }: { params: Promise<{ slug: string }> }): Promise<Metadata> {
  const { slug } = await params;
  const item = await CaseStudies.bySlug(slug);
  if (!item) return {};
  return { title: `${item.title} | <Brand>`, description: item.summary, ...getCanonicalLink(`/work/${slug}`) };
}

export default async function Page({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params;
  const item = await CaseStudies.bySlug(slug);
  if (!item) notFound();
  return <CaseStudyView item={item} />;
}
```

In recent Next.js versions `params` is a Promise. Check the version in `package.json` and the bundled docs before using an API from memory.

## 3. Content

- Read content only through a service (CMS client, JSON files, MDX loader). Components never import content files directly.
- Keep the content shape typed. When you add a field, update the type and every place that reads it.
- Slugs and anchor ids that other pages link to are contracts. Grep for links before renaming one.

## 4. Copy

- One h1 per page, saying what the page is about in plain words. The reader should know what the page offers within one screen.
- Short paragraphs, concrete numbers only when they are true and sourced, a clear next step (one primary call to action per section).
- Plain ASCII punctuation: no long dashes, curly quotes or one-character ellipsis.

## 5. Wire it in

- Navigation, footer or internal links from related pages.
- Sitemap entry if the sitemap is not generated from routes.
- OG image (route `opengraph-image` or metadata `openGraph.images`).

## 6. Check it like a visitor

```bash
<pm> run lint && <pm> run build
```

Then open the page (dev server or the PR preview) at 375 px and 1440 px. Check: no horizontal scroll, headings wrap well, images load with the right size, links go somewhere, the page works with JavaScript disabled for its main content. Report what you looked at, and ask the user to confirm the visual result.
