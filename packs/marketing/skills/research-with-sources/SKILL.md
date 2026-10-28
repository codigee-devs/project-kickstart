---
name: research-with-sources
description: Research method with source verification for market, competitors, user opinions, platforms and SEO topics. Starts from the decision the research must enable, ranks sources by reliability, fans out parallel threads, triangulates, confronts findings with your own data and ends with an HTML report that has a "To decide" section. Use for "do a research", "deep research", "what do people say about", "research competitors", "is this true", "verify the sources", "zrob research", "co ludzie mowia o", "sprawdz w necie", "czy to prawda".
---

# Research with source verification

Research exists to make a decision. If you cannot name the decision, you are not ready to search.

## 1. Frame it (5 minutes, before any search)

Write a working file `research/<topic>/FRAME.md`:

- **Decisions** the research must enable (A vs B) and the **criterion** that settles each one (a number or a threshold).
- **What we already know** from our own data (analytics, database, store consoles, ad accounts) and what must be checked live. Notes and journals go stale; live state wins.
- **Scope**: markets and languages, time window, time budget, search budget. Agents in one session share the search budget, so split it explicitly.

## 2. Rank sources by reliability

| Rank | Source | Use it for |
|---|---|---|
| 1 | Own data and measurement | If an experiment can measure it, measure it |
| 2 | Primary APIs | Keyword planners (volume per market, sequential calls, back off on 429), official community APIs (authenticated, not anonymous scraping), store consoles, public ad libraries |
| 3 | Official documentation | Platform guidelines, store rules, vendor docs |
| 4 | Communities | Forums, reviews, threads. Weight by upvotes on comments, not by mention count |
| 5 | Blogs and aggregators | Hypotheses and methods only. Confirm facts in ranks 1-3 |

## 3. Fan out

- One agent per independent thread (for example: "what users complain about", "how pros do it", "what competitors charge").
- Brief each agent with: the question, what NOT to search (other threads), a search limit, and concrete URLs to fetch instead of broad searching.
- Required return format per finding: `claim -> number or quote -> source URL + date read -> confidence (high/medium/low)`.
- After synthesis, run a second "confirm or correct" pass only on findings that change a decision. Write corrections explicitly: "corrected: X, because source Y".

## 4. Analyse

- **Weighting**: rank themes by summed upvotes, quote top comments with their scores, name low-signal sources as such.
- **Triangulation**: any finding that changes a decision needs at least 2 independent sources.
- **Confront with own data**: define metrics from the final event ("finished = reached the result screen", not "opened the page"), split by segment, check that one customer or one room does not inflate the result.
- **A zero in a new counter** means "the mechanism never fired" until you see a real event.
- **SERP and competitors**: look for what nobody on page one covers. That gap is your angle.

## 5. Output

1. A single HTML report in the repo (see `templates/html-outline.md`): synthesis with numbers, a "now vs proposed" table, two lists "verified" and "hypothesis", sources.
2. A table "observation -> rule for our project". Research ends in executable rules (a checklist, script rules, design rules), not in an essay.
3. A **To decide** section: numbered questions, each with a default answer in brackets, so "go" from a human is enough.
4. Raw data saved next to the report (`research/<topic>/data/*.jsonl`) so nobody has to scrape again.
5. No external changes (stores, campaigns, publishing) before a human decides. Report differences between live state and notes; do not silently fix them.

## Pitfalls

- Agents search the same thing and burn the budget: split topics and hand out URLs.
- One forum thread reported as truth: that is an anecdote until weighted and triangulated.
- A dashboard metric that counts something else (abandonment, landing views): define the metric from the final event.
- Translating keywords instead of measuring each market: measure volume per market and language.
- Hours of research without state: after each thread, write 1-2 sentences of "what we know now".
- Facts about other companies' products published without checking at the source.

## Done when

Every decision from the frame has a recommendation with numbers and sources, decision-changing findings are triangulated, "verified" and "hypothesis" are separated, the report is opened by a human, and "To decide" has default answers.
