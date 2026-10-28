# Ideas and prototyping pack

How we go from an idea to a decision in hours instead of weeks: write a short brief, build a clickable HTML prototype, put several concepts side by side, let the owner pick, and test with real people before building the real thing.

| Skill | Use it when | You get |
|---|---|---|
| `html-prototype` | An idea, a page or a flow needs to be seen, not described | A BRIEF.md all variants follow, a folder per concept, checks at 3 widths, an overview page with pending decisions, a HANDOFF.md |
| `compare-concepts` | You want 2-5 different takes on the same thing | Parallel agent briefs, one comparison page with live scaled previews, wow effects and honest trade-offs (`templates/compare.html`) |
| `game-design-spec` | Designing a casual, party or multiplayer game, or fixing one that is boring or long | A spec with phases, timings, who-sees-what, scoring, ties, catch-up, narrator and analytics (`templates/spec-outline.md`) |
| `user-test-plan` | Before building on a guess: usability tests, playtests, rating many variants | A plan tied to a decision, a moderator script, an observation log, a rating page (`templates/rating-page.html`), a findings page |

## The loop

```
brief -> 3 concepts in parallel -> comparison page -> owner picks or combines
      -> refine the winner -> test with 5 people -> spec changes -> build
```

Every round ends with a recorded decision and a date, so the next session does not reopen a settled question.

## Why HTML

- Everyone can open it on their phone. No design tool account, no build step.
- Real content and real screens expose real problems (copy too long, proof missing, a section nobody needs).
- Agents can build several concepts in parallel and verify them with a headless browser before a human spends time on them.

## Related packs

- `animation` for scroll stories and verifying motion inside prototypes.
- `marketing` for the research and positioning a prototype brief needs.
- `video` for narrator lines and trailers once a game or product is real.
