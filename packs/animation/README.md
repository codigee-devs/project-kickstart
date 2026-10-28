# Animation pack

Motion for websites, apps and short product films: how to design it, how to build scroll stories that stay readable, and how to prove an animation works on screen instead of assuming it.

| Skill | Use it when | You get |
|---|---|---|
| `motion-principles` | Designing or reviewing any animation | Six rules, composition rules, UI timing table, engineering rules (deterministic, transform/opacity, reduced motion), a review checklist |
| `scroll-story` | A section that tells a story on scroll (pinned phone, wall to one screen, film strip) | Architecture with a pure scroll-to-story function, media and mobile rules, a reduced-motion layout, and `templates/scroll-story.html` |
| `verify-motion-by-recording` | Checking that an animation or UI change really shows up | Surface choice, restart and fixtures, recording commands, frame measurement in Python, a verified vs to-confirm report |

## Rules that run through all three

- Readability first. An effect never costs clarity; reduced motion and no-JS users get every piece of information.
- Every number has a name. Scroll lengths, durations and easings are constants or tokens, so tuning is one edit.
- "Done" is what a person sees on a real screen. Short effects are recorded and measured; the owner confirms the feel on a real device.

## Try the template

```bash
cd packs/animation/skills/scroll-story/templates
python3 -m http.server 4400
# open http://localhost:4400/scroll-story.html, then toggle reduced motion in DevTools
```
