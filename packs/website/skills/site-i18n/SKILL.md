---
name: site-i18n
description: Add a second language to a Next.js site with next-intl without breaking the first - URL model (default locale unprefixed, others prefixed), an allowlist so untranslated URLs answer 404, message files with identical keys enforced by a test, locale-aware links and language switcher, canonical and hreflang per real pair. Use when adding a language, translating a page, or moving UI text into messages. Triggers - "add polish version", "translate the site", "i18n", "language switcher", "move text to messages", "dodaj wersje polska", "przetlumacz strone", "przelacznik jezyka".
---

# site-i18n

Goal: the existing language keeps every URL, every byte of copy and its SEO. The new language appears page by page, only when each page is really translated.

## 1. URL model

- Default locale without a prefix (`/pricing`), other locales prefixed (`/pl/cennik` or `/pl/pricing`). next-intl: `localePrefix: "as-needed"`.
- The locale comes only from the URL. No Accept-Language redirect, no cookie: crawlers and shared links must see the same page.
- `/en/...` (the default locale with a prefix) answers one permanent redirect to the unprefixed URL.
- A prefixed URL is public only when an allowlist says so. Everything else under `/pl` answers 404 in that language. This lets you ship the Polish chrome before every page is translated, without duplicate English content under `/pl`.

```ts
export const PL_ROUTE_ALLOWLIST = ["/pl", "/pl/cennik", "/pl/blog/*"] as const;
```

Check the allowlist on the normalized, decoded path (lowercase, encoded characters and dot segments resolved). A check on the raw path lets `/%70l/...` slip through.

## 2. Messages

- `src/messages/<locale>/<namespace>.json`, one namespace per area (`common` for header, footer, forms, 404).
- English (or your default) defines the keys; other locales mirror them exactly.
- A unit test fails on: a missing file, a key present in one locale only, an empty string, invalid ICU, different placeholders or rich-text tags between locales, typographic characters you ban.

```ts
for (const ns of NAMESPACES) {
  const en = flatten(load("en", ns));
  const pl = flatten(load("pl", ns));
  expect(Object.keys(pl).sort()).toEqual(Object.keys(en).sort());
  for (const [key, value] of Object.entries(pl)) expect(value, `${ns}.${key}`).not.toBe("");
}
```

- Moving existing text into messages must not change it: the rendered default-language page stays byte for byte the same, typos included. Fix copy in a separate change.
- Plurals use ICU. Polish needs `one`, `few`, `many`, `other`.
- Keep long copy in server components; `NextIntlClientProvider` sends its messages to the browser.

## 3. Translating a page

1. The page renders the new language when the locale says so, and calls `notFound()` for items that have no translation.
2. Localized slug? Add it to next-intl `pathnames` (then every route linked through next-intl needs an entry, even identity ones).
3. Add the external path to the allowlist.
4. Metadata in that language: title, description, canonical for the prefixed URL.
5. If it has a twin in the other language, register the pair, so the switcher, hreflang and sitemap know about it. A pair counts only once both sides are public.
6. Smoke test: 200, `<html lang="pl">`, visible h1.

Translation quality: write natural copy in the target language and its usual register, not a word-for-word copy. Brand slogans may stay in the original language on purpose; decide once and write the list down.

## 4. Links and switcher

- Links to pages that exist in both languages: the locale-aware `Link` from your i18n navigation module.
- Links to pages that exist only in the default language: a plain link with the default path. Label it (for example "(EN)") so the reader knows.
- The switcher goes to the twin page if a public pair exists, otherwise to the other language's home page. Never link to the prefixed default locale.

## 5. Gotchas

- Route handlers outside the locale segment (API, files, special routes) must be excluded from the i18n middleware, or they get rewritten into the locale tree and 404.
- Slugs must not contain dots; dotted paths skip the middleware in common matcher setups.
- A `loading.tsx` at the locale root can turn a later `notFound()` into a 200 after streaming. Avoid it there.
- Cache revalidation needs the internal path (`/en/blog`) or the typed pattern, not the public URL.

## 6. Gates

`<pm> run test` (message parity, allowlist, alternates), `<pm> run build`, e2e smoke for both languages. Then open both versions of each changed page in the browser and report what you checked.
