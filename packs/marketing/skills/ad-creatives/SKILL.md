---
name: ad-creatives
description: Brief, produce and check ad creatives (short video, UGC-style clips, statics) that do not look cheap or AI-made - concept per market and persona, hook in the first 2 seconds, beat list, asset plan, hook variants, honest proof, disclosure, anti-slop checklist and human sign-off. Use for "make an ad", "creative brief", "new hook variants", "UGC concept", "static ad", "refresh creatives", "zrob kreacje", "zrob reklame", "nowe hooki", "brief kreacji".
---

# Ad creatives that earn trust

Audiences read a cheap-looking ad as a cheap product. Research on large forum threads about AI-made ads (thousands of weighted comments) ranked the reasons people reject them: "they save money, so the product is cheap too" first, then visible artifacts, uncanny voices, generic "AI cartoon" style, and the same ad running for months. Design against that list.

## 1. Brief (no spending yet)

Write one brief per concept in this order:

1. **Concept**: market, persona, format (A, B or C below), the single action (CTA) and the landing page it goes to.
2. **Hook (first 2 s)**: what is on screen at frame 0 and the first line. Frame 0 must be a finished, readable composition.
3. **Beats**: `time | picture | on-screen text | spoken line | sound`. Spoken lines are casual speech with contractions, not ad copy.
4. **Assets**: what is real (product screens are always real recordings), what is generated, what is a template graphic. Tool per asset.
5. **Metadata**: name by convention (`<market>_<concept>_<hook>_<format>_v<n>`), UTM, placement and aspect ratio.
6. **Guardrail checklist** (section 4), ticked.

Start the brief with one real audience quote from your research, as a reminder of who will watch it.

## 2. Three formats

- **A. Faceless B-roll**: reactions, product in use, hype cuts. Cheap to vary.
- **B. Talking head**: one person to camera. Fictional, generic personas only; never the likeness of a real or famous person.
- **C. Clip factory**: record a real session of the product being used, cut 10-15 vertical clips around the strongest moments, burn in captions. Real reactions are the moat; AI makes hooks and variants, it does not fake energy.

## 3. Variants

- A winning concept gets 3-5 **different hooks**, not 5 copies with a new font. Change the first 2 seconds, keep the body.
- One UTM per variant. Rotate creatives on a schedule instead of running one for months.
- Statics with text in non-English scripts: render text through an HTML/SVG template layer, never through image diffusion (it breaks diacritics).

## 4. Guardrails (hard)

- **Proof is real**: one number from a source of truth, real reviews only, no placeholder case studies, no invented scarcity or urgency.
- **Message match**: the ad promises what the landing page shows (an ad saying "no install" sending people to "download the app" kills quality score and trust).
- **Disclosure**: label synthetic voices and AI-generated imagery where law or platform policy requires it. Voice clones of real people only with signed consent.
- **No artifacts**: no warped hands or faces, no readable garbage text, no identity drift between shots, no wrong-language screens.
- **No generic "AI style"**: pick an explicit stylisation instead of pretending to be real footage, or use real footage.
- **Voice**: synthetic voice listened to by a human for natural rhythm; overexcited "ad voice" is rejected faster than any visual flaw.
- **Minors**: nothing targeted at children.
- **Human sign-off** before anything is published. Paid accounts are changed by a human or after explicit approval.

## 5. Check before handoff

- Watch at phone size with sound off: can a stranger say what it is and what to do next?
- Captions: rendered diacritics correct, inside safe zones (critical text not in the bottom ~12% or along the right edge in 9:16).
- Lengths, loudness and frames checked (see the `video-editing-qa` skill in the video pack).

## Output

The brief file, the asset list with costs, and a handoff note that separates "verified (render, captions, lengths, loudness)" from "the owner must watch and approve before publishing".
