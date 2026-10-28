---
name: html-prototype
description: Turn an idea into a clickable static HTML prototype in hours - one BRIEF.md every variant follows (audience, pillars, allowed proof, forbidden claims, brand, build and verification rules), real content and real screens, one folder per variant, served locally and checked on a phone, screenshots at three widths, an overview page with pending decisions and a HANDOFF.md so the next session continues. Use for "prototype this", "mock up the page", "clickable prototype", "try 3 versions of the homepage", "show me how it could look", "zrob prototyp", "zrob makiete", "pokaz jak to moze wygladac", "zrob 3 wersje".
---

# Idea to clickable HTML prototype

A prototype is the best brief. A static HTML page that the owner can open on their phone settles in an hour what a meeting about adjectives never settles. Prototypes are throwaway by design: they live outside the production app and never ship as they are.

## 1. Write BRIEF.md first (30 minutes)

Every prototype, and every agent building one, follows the same brief. Sections:

1. **Goal** of this round, and what the owner will decide after looking.
2. **Audience**: who it is for, who it is NOT for.
3. **Positioning and pillars** in order, with the proof each one uses.
4. **Copy rules**: slogans to keep word for word, tone, words that are banned.
5. **Allowed proof**: the only facts, numbers, logos and quotes that may appear. Anything else is a placeholder marked as such.
6. **Forbidden claims**.
7. **Brand and assets**: colors, fonts, where real screens and images live (a symlink to the real `public/` folder keeps paths working).
8. **Build rules**: static HTML/CSS/JS, no build step, libraries only from a pinned CDN version, readable at 390 px, reduced motion respected, draft prices tagged "draft".
9. **Verification**: the exact checks in section 4.

## 2. Structure

```
prototypes/
  BRIEF.md            the brief all variants follow
  HANDOFF.md          what a new session must know to continue
  overview.html       the page the owner opens first (in the owner's language)
  compare-<topic>-<date>.html   side-by-side comparisons (skill compare-concepts)
  public -> ../public symlink to real assets
  <concept>/          one folder per concept or variant: index.html + pages + assets
```

- One concept per folder. If several agents build variants in parallel, each owns one folder and never edits another.
- Name files by concept and page (`a-pricing.html`, `b-pricing.html`) so they sort together.
- Real content: real app screens, real case facts, real prices marked draft. Lorem ipsum hides the actual problem.

## 3. Build fast, in this order

1. The one screen that carries the idea (usually the hero or the key flow), at full quality.
2. The rest of the page at "good enough", using real copy.
3. Only then the "wow" (animation, 3D). Readability first; an effect never costs clarity (see the animation pack).

## 4. Verify before showing anything

```bash
cd prototypes && python3 -m http.server 4400 --bind 127.0.0.1
```

With Playwright (or any headless browser), for every page at 1440x900, 1920x1080 and 390x844:
- `document.documentElement.scrollWidth <= window.innerWidth` (no horizontal scroll);
- no console errors, no broken images (`naturalWidth === 0`);
- full-page screenshot saved next to the page, then actually LOOK at it and fix what looks off;
- for scroll effects, record a scroll pass (see `verify-motion-by-recording`).

Use your own port and browser instance; never touch ports or browsers someone else is using.

## 5. Hand it to the owner

- `overview.html`: what to look at first, one card per concept (screenshot, one-line idea, link), known issues, and a **pending decisions** table (question, options, default).
- The local URL plus a way to see it on a phone (same Wi-Fi: `http://<laptop-ip>:4400`, or a private preview deploy).
- Ask for a pick or a combination, not for "feedback". "A, but with the pricing from C" is the answer you want.

## 6. Keep the thread

- Update `HANDOFF.md` after each round: what exists, what the owner picked and why (with the date), known issues, where research lives. The next session (or the next person) starts there.
- Record the owner's decisions where your tools persist them (project notes or memory), so a later round does not undo a settled choice.

## Done when

Every page passes the checks at three widths, screenshots were looked at, the overview page lists concepts and pending decisions, HANDOFF.md is current, and the owner has the link. Tell them what you verified and that the feel on their phone is theirs to judge.
