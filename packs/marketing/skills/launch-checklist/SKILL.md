---
name: launch-checklist
description: Pre-launch and launch-week checklist for an app, website or new feature - measurement working end to end, store and SEO readiness, legal and disclosure, support and rollback, launch assets, a day-by-day launch plan and a post-launch read on fixed dates. Use for "launch checklist", "are we ready to launch", "go live plan", "release marketing", "launch week", "czy jestesmy gotowi", "plan premiery", "checklista przed startem".
---

# Launch checklist

A launch is ready when a stranger can find it, use it, pay or sign up, and you can see all of that in your numbers. Go through every block; mark each item verified (how) or not applicable (why).

## 1. Measurement (check first, it cannot be added later)

- [ ] Analytics events defined from the final event backwards: visit -> key action -> sign-up or purchase. Names written down.
- [ ] Each event fired once from a real device and seen in the analytics tool (not just in code).
- [ ] UTM convention fixed; every link in launch posts and ads has one.
- [ ] Conversion tracking for ad platforms verified with a test conversion.
- [ ] Crash and error reporting receives a test error from production.
- [ ] A one-page dashboard: the 5 numbers you will read after launch.

## 2. Product surface

- [ ] Real device test of the main flow on the slowest supported phone and on a bad network.
- [ ] Empty states, error states and first-run onboarding reviewed on screen.
- [ ] Store listing ready (see `aso-store-listing`), review submitted with buffer for rejection.
- [ ] Website: titles, meta descriptions, Open Graph images, sitemap, robots, structured data, canonical URLs, 404 page.
- [ ] Page speed and accessibility checked on the landing page (contrast, alt text, keyboard focus, tap targets).

## 3. Trust and legal

- [ ] Privacy policy and terms match what the product actually collects. Cookie consent if required.
- [ ] Every public claim has a source. Prices and guarantees identical across site, store and ads.
- [ ] AI-generated media and synthetic voices disclosed where required.
- [ ] Account deletion path works (store requirement for apps with accounts).

## 4. Support and rollback

- [ ] A support address or form that a person reads during launch week.
- [ ] Rollback plan: previous build or feature flag, who decides, how long it takes.
- [ ] Backups taken before any data migration; restore tested once.
- [ ] Rate limits and costs: what happens if traffic is 10 times the estimate (alerts on spend).

## 5. Launch assets

- [ ] Launch post (problem, what is new, proof, one CTA), 3 short clips or screenshots, one demo video under 60 s.
- [ ] Copy passed the AI-tell check (`positioning-and-copy`).
- [ ] List of channels with owner and time: own audience, communities where self-promotion is allowed, partners, press, directories.

## 6. Launch week plan

| Day | What | Owner | Number to read |
|---|---|---|---|
| D-7 | Freeze scope, final device test, store review submitted | | |
| D-2 | Assets final, posts scheduled, dashboard checked | | |
| D0 | Release, posts live, team watching errors and support | | errors, sign-ups |
| D+1 | Fix top issue, reply to every comment | | activation |
| D+7 | First read: what worked, what to stop | | retention D1, cost per sign-up |
| D+30 | Second read, decide next bets | | retention D7/D30 |

## Done when

Every box is verified or explicitly marked not applicable, the dashboard shows real launch-day data, and the D+7 read is on the calendar. Report what you verified on real devices versus what the owner must check.
