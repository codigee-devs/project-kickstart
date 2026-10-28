---
name: compare-concepts
description: Build N different concepts of the same thing (a page, a case study layout, a hero, a game screen) from one brief and put them side by side on one comparison page with live scaled previews, a short description, the "wow" effect and honest trade-offs, so the owner can pick or combine in minutes. Includes the comparison page template and how to brief parallel agents. Use for "show me 3 options", "compare concepts", "side by side", "which version is better", "propose alternatives", "porownanie", "pokaz 3 propozycje", "porownaj wersje", "zrob kilka wariantow".
---

# Compare concepts side by side

Picking is faster than describing. Build 3 (sometimes 2-5) genuinely different concepts from one brief, then let the owner compare them on one page.

## 1. Make the concepts different on purpose

- Same content, same brief, same order of material. Only the idea changes, so the comparison is about layout and effect, not about copy.
- Each concept gets a **name that describes the idea** ("Pinned phone", "Film strip", "Wall to phone"), not "Option 1".
- Spread the concepts along a real axis: safest and simplest to ship, most cinematic, boldest entrance. Three variations of the same idea waste the round.

## 2. Build in parallel (one agent per concept)

Brief each agent with:
- the shared BRIEF.md and the shared content (paths);
- its concept name and the one idea it must express;
- its own files (`<page>-a.html`, `<page>-b.html` ...) and the rule to never touch another concept's files;
- the verification steps (3 widths, no horizontal scroll, no console errors, screenshots looked at, recording for scroll effects);
- the return format: 3 lines of "wow effect", 2 lines of honest notes (length, risk, what it needs), screenshot paths.

Put the comparison page up as soon as the first concept exists; fill cards as agents report. A card can say "still being checked" until its report arrives.

## 3. The comparison page

Use `templates/compare.html`. One card per concept:

- **Live preview**: an iframe rendered at desktop size (1440x900) and scaled down to the card width with a CSS transform, so the owner sees the real page, not a screenshot. `loading="lazy"`.
- **Tag** ("Concept A"), **name**, one paragraph of what it is.
- **Wow effect**: 2-3 bullets of what happens on scroll or interaction.
- **Notes**: honest trade-offs (scroll length, effort to roll out to all pages, assets it needs, known issues).
- **Open** button to the full page in a new tab (the full effect needs a real scroll).

Header: what is being compared, what stays the same across concepts, and the ask: "pick one or say what to combine". Write it in the owner's language.

## 4. After the pick

- Record the decision with the date and the reason (HANDOFF.md, project notes), plus what to borrow from the losing concepts.
- Keep the losing concepts' files for one round as a parts bin, then move them to an archive folder. Do not delete without asking.
- Roll the winner out to the other pages only after the owner confirmed it on a real phone.

## Done when

Each concept is verified at three widths, every card has a live preview, a wow list and honest notes, the page works on a phone, and the owner's pick (or combination) is recorded with a date.
