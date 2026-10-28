---
name: motion-principles
description: Motion design rules for web and app UI and for short product films - one persistent actor, the foreground becomes the transition, change speed instead of drifting, density from hierarchy, cause and effect, frame 0 finished, pacing numbers, durations and easing for UI, deterministic animation, performance budget and reduced motion. Use before designing or reviewing any animation, for example "add animation", "make it feel premium", "transition between screens", "the animation feels cheap", "hero animation", "dodaj animacje", "animacja jest tania", "przejscie miedzy ekranami".
---

# Motion principles

Motion explains what changed and where it went. Effects that do not explain anything are cut, and no effect is worth losing readability.

## 1. Six rules (from studying professional launch films frame by frame)

1. **One persistent actor.** A card, phone, cursor or shape keeps its identity across steps. Unrelated reveals in a row feel like a slideshow.
2. **The foreground becomes the transition.** A headline or shape scales past the camera while the next scene is already in place underneath. No empty gap between scenes.
3. **Change speed, do not drift.** Readable landing, fast exit, slowing arrival. Constant-speed motion reads as screensaver.
4. **Density from hierarchy.** One primary move, supporting staggers, fine tertiary detail, overlapping in time. Do not start and stop the whole frame on every beat.
5. **Hard cuts are fine** when subject, scale, direction and material match and motion continues after the cut.
6. **Cause and effect.** Every animated action produces a visible result: a tap produces a state, a scan produces findings.

## 2. Composition

- The lead subject fills most of the frame in feature moments (roughly 60-85%). A small card in a big empty field reads as cheap.
- 1-2 reading targets at a time.
- Frame 0 (and the first paint of a page) is a finished composition, never a half-entered word.
- Keep one wipe direction and one title position across a sequence of similar steps.

## 3. UI timing (starting points, tune on device)

| Motion | Duration | Easing |
|---|---|---|
| Hover, press, toggle | 100-150 ms | ease-out |
| Small element enter (tooltip, chip) | 150-200 ms | ease-out |
| Panel, sheet, modal enter | 250-350 ms | ease-out (decelerate) |
| Exit | about 70% of enter | ease-in (accelerate) |
| Page or screen transition | 300-450 ms | ease-in-out |
| Stagger between list items | 30-60 ms, cap the total | |

Put durations and easings in named tokens (`--motion-fast`, `--ease-out`), never as raw numbers in components.

## 4. Engineering rules

- **Deterministic**: state is a function of time or scroll progress. No `Date.now()` in render, no unseeded randomness, no physics history for anything that must be seekable or recorded.
- **Cheap properties**: animate `transform` and `opacity`. Avoid animating layout (width, height, top, left) and large blurs or shadows every frame.
- **Budget**: 60 fps on a mid-range phone. Check with DevTools Performance or the platform profiler, not by eye on a fast laptop.
- **Pause what is not visible**: IntersectionObserver for off-screen loops, pause videos and canvases out of view.
- **Reduced motion**: honor `prefers-reduced-motion` (web) and the platform setting (iOS Reduce Motion, Android remove animations). Replace movement with instant state changes or short fades; keep every piece of information.
- **No motion that blocks reading**: text never moves while it should be read; autoplaying motion longer than 5 s needs a way to stop it, unless the brand has decided that it is ambient decoration that carries no information.

## 5. Review checklist

- What does each animation explain? If nothing, remove it.
- Is there one actor carrying the story?
- Any held frame without motion longer than about 0.6 s in a film (except the CTA)?
- Any text collisions mid-transition? Check recorded frames, not just the start and end.
- Does it work at 390 px wide and with reduced motion?
- Was it measured on a real mid-range device?

## Done when

Each animation has a stated purpose, timings live in tokens, the reduced-motion version keeps all information, frames were checked from a recording, and performance was measured on a real device.
