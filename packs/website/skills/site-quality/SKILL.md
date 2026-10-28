---
name: site-quality
description: Check and fix performance and accessibility of a marketing site before launch or after a redesign - Core Web Vitals (LCP, CLS, INP) with Lighthouse, images, fonts, third-party scripts, heavy animation, plus WCAG 2.1 AA basics (contrast, headings, keyboard, focus, alt text, reduced motion). Use before shipping a page, after adding animation or media, or when the site feels slow on a phone. Triggers - "the site is slow", "lighthouse", "core web vitals", "accessibility check", "wcag", "check performance", "strona wolno dziala", "sprawdz wydajnosc", "dostepnosc", "zrob lighthouse".
---

# site-quality

Measure first, change second, measure again. Report numbers, not impressions.

## 1. Measure

Run against a production build (`<pm> run build && <pm> run start`) or the PR preview, never against the dev server.

```bash
npx lighthouse https://<preview>/<path> --preset=perf --form-factor=mobile --screenEmulation.mobile \
  --output=json --output-path=./lighthouse-mobile.json --quiet --chrome-flags="--headless"
npx lighthouse https://<preview>/<path> --only-categories=accessibility,seo,best-practices \
  --output=html --output-path=./lighthouse-a11y.html --quiet --chrome-flags="--headless"
```

Note LCP, CLS, TBT (proxy for INP), the LCP element, and the top opportunities. Mobile numbers are the ones that matter.

## 2. Performance fixes, in order of payoff

**LCP**
- The LCP element (usually the hero image or heading) is in the initial HTML, not rendered after JavaScript.
- Hero image: `next/image` with `priority`, right `sizes`, AVIF or WebP, no lazy loading. Nothing else gets `priority`.
- Hero video: a poster image as the LCP candidate, video loaded after.
- Fonts: `next/font` (self-hosted, `display: swap`), at most two families, subset to the scripts you need.

**CLS**
- Every image, video, iframe and embed has dimensions or an aspect-ratio box.
- No content injected above existing content after load (banners, cookie bars push from the bottom or overlay).
- Font fallback metrics adjusted (`next/font` does this) so the swap does not shift text.

**INP / TBT**
- Third-party scripts (analytics, chat, tag managers) with `next/script` `strategy="lazyOnload"` or `afterInteractive`, and only the ones you use.
- Heavy client components (sliders, 3D, canvas) loaded with `dynamic(() => import(...), { ssr: false })` when below the fold.
- Animations on `transform` and `opacity` only. No layout-triggering properties in scroll handlers; use `IntersectionObserver` or CSS scroll-driven animations. Long lists of animated elements are paused when off screen.

## 3. Accessibility basics (WCAG 2.1 AA)

- Contrast: body text 4.5:1, large text and UI components 3:1. Check text on images and on brand accent colors in particular.
- Structure: one h1, headings in order, landmarks (`header`, `nav`, `main`, `footer`), lists as lists.
- Keyboard: every interactive element reachable with Tab, in a sensible order, with a visible focus style. Menus and dialogs trap and return focus, close with Escape.
- Names: buttons and links say what they do (no bare "Read more" without context, or add `aria-label`). Icon buttons have labels. Form fields have real labels and error messages tied to them.
- Images: meaningful `alt`, empty `alt=""` for decoration.
- Motion: everything that moves respects `prefers-reduced-motion`, and anything that plays longer than 5 seconds can be stopped or is not essential.
- Language: `<html lang>` matches the page language.

Quick keyboard test: unplug the mouse mentally, Tab through the page, open and close the menu, submit the form.

## 4. Re-measure and report

| Metric | Before | After |
|---|---|---|
| LCP (mobile) | 4.1 s | 2.2 s |
| CLS | 0.21 | 0.02 |
| TBT | 640 ms | 180 ms |
| Accessibility score | 82 | 98 |

Plus the list of what you changed and what you could not check automatically (screen reader pass, real device on a slow network). Lab numbers are a proxy; field data (Search Console, RUM) is the final word.
