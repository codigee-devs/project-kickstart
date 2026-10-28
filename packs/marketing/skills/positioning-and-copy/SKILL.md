---
name: positioning-and-copy
description: Positioning and copy for websites, landing pages, store listings and ads that reads like a senior human wrote it - one-line positioning, message pillars per persona, proof that is true, headline patterns, and a hard pass that removes AI tells (long dashes, smart quotes, hype words, empty triads). Use for "write the copy", "rewrite this headline", "positioning", "value proposition", "make it sound less AI", "landing page copy", "napisz copy", "popraw naglowek", "zeby nie brzmialo jak AI", "pozycjonowanie".
---

# Positioning and copy without AI tells

Copy is read in two seconds and judged on trust. Generic copy reads as "they did not care", which readers translate into "the product is cheap too".

## 1. Positioning first (one page, before any headline)

Fill this in `docs/positioning.md`:

```
For <who, specific: role, situation, budget>
who <the trigger moment: what just happened that made them look>,
<product> is <category they already understand>
that <the one outcome they pay for>.
Unlike <the real alternative they consider, including "do nothing">,
we <the one difference you can prove>.
Proof: <facts a stranger can verify: shipped products, numbers from a public source, named awards>.
Never say: <claims we cannot prove, words that attract the wrong buyer>.
```

- Name the buyer you do NOT want. Copy that tries to please everyone sounds like a template.
- One persona = one page or section. Pillars differ per persona; facts and prices stay identical everywhere.

## 2. Message pillars (3-4, ordered)

For each pillar: the claim (max 8 words), the proof (a fact, screen, number or story), the objection it answers. If a pillar has no proof, it is not a pillar yet. Show, do not tell: a real screen beats an adjective.

## 3. Headlines

- Short, concrete, in the brand's voice. Keep existing brand slogans when they exist; do not "improve" a founder's voice into marketing English.
- Pattern that works: outcome or tension in the headline, mechanism in the line below, proof right after.
- Read it out loud. If a competitor could put it on their site unchanged, rewrite it.
- Numbers only from a source you can link. No "10x", no invented percentages, no fake testimonials.

## 4. The AI-tell pass (mandatory before shipping any text)

Characters (replace every occurrence):

| Remove | Use instead |
|---|---|
| em dash, en dash, horizontal bar | comma, colon, parentheses, full stop or plain `-` |
| curly quotes and apostrophes | plain `"` and `'` |
| single-character ellipsis | three dots `...` |
| non-breaking, narrow, zero-width spaces, soft hyphen, BOM | regular space or nothing |

Check with `scripts/find-ai-tells.sh <files>` from this skill folder (non-zero exit when something is found).

Words and patterns to cut or rewrite:
- Hype and filler: "unlock", "elevate", "seamless", "cutting-edge", "game-changer", "revolutionize", "supercharge", "in today's fast-paced world", "whether you're X or Y".
- Empty triads ("fast, simple and powerful") without proof for each word.
- "Not just X, but Y" constructions, rhetorical questions as openers, every paragraph ending on a punchline.
- Exclamation marks outside a real peak. Emoji in professional copy unless the brand uses them.
- Claims about AI as the selling point. If you use AI, say what it does for the customer (speed, review, verification), and that a person is responsible.

## 5. Per-locale copy

Write each language natively from the same positioning, do not translate line by line. Prices, guarantees and legal facts stay identical; currency per locale. Check diacritics on the rendered page, not only in the source.

## Done when

Positioning page exists and was approved by a human, every claim has a proof or was cut, the AI-tell script exits 0, and the copy was read on the real page at phone width. Report what you checked versus what the owner must read and approve.
