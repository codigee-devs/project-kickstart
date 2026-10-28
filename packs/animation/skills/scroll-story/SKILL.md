---
name: scroll-story
description: Build scroll-driven stories on the web (a pinned phone whose screen changes per step, a wall of screens that zooms into one, horizontal film strips, counters) with vanilla JS or GSAP ScrollTrigger - scroll position mapped to a story position by a pure function, named constants for every length, lazy video, mobile layout, and a static layout for reduced motion and no-JS. Includes a working template. Use for "scroll animation", "pinned section", "scrollytelling", "case study story on scroll", "sticky phone", "animacja na scrollu", "przypiety telefon", "efekt wow przy scrollu".
---

# Scroll stories

A scroll story is readable first and impressive second. If someone scrolls fast, uses a phone or has reduced motion on, they must still get every caption and every screen.

## 1. Design the story before code

- List the steps: `step | screen or media | caption (max ~12 words) | what changes on enter`.
- Pick ONE persistent actor (a phone, a card, a tile) that carries the story through every step. Unrelated reveals one after another feel like a slideshow.
- Decide the scroll budget: about 0.6-0.8 viewport heights per step reads well; a whole story longer than about 8-10 screens feels long. Write it down as constants.
- Plan the ending: the actor lands somewhere meaningful (a grid tile, a CTA), so the story hands over to the page.

## 2. Architecture (works with or without GSAP)

```
outer section: height = steps * STEP_VH + EXTRA_VH (in viewport heights)
  sticky stage: position: sticky; top: 0; height: 100vh   <- everything animated lives here
```

- Map scroll to a **story position** `s` (in steps) with one pure function: `s = clamp((scrollY - sectionTop) / (STEP_VH * innerHeight), 0, steps)`. Every visual state is a function of `s` only. Then seeking, resizing and fast scrolling always give the same picture.
- Smooth the drawn position toward `s` per frame (`drawn += (s - drawn) * SMOOTH`) only for cosmetic easing; never store state in the animation loop.
- Every number is a named constant at the top of the file (`STEP_VH`, `WIPE_LEAD`, `WIPE_SPAN`, `SMOOTH`, breakpoints). Tuning becomes a one-line change.
- Animate only `transform` and `opacity`. Read layout (`getBoundingClientRect`) on resize, not every frame.
- GSAP ScrollTrigger is fine for pinning and scrubbing; keep the same rule (state from progress), use `scrub` rather than time-based tweens, and call `ScrollTrigger.refresh()` after images and fonts load.

## 3. Media

- Videos: `muted playsinline loop preload="none"`, `data-src` set to `src` only when the step is near. Play the active step, pause the rest.
- Use posters so a frozen or blocked video still shows the right screen.
- Real screens and recordings, compressed (WebP or AVIF for images, H.264 or VP9 for video), sized to the largest rendered size.

## 4. Mobile

- Under the narrow breakpoint, keep the actor centered and put captions below it, not beside it. Shorter scroll per step.
- Check that captions never overlap the actor at 390 px width.
- Use `100svh` or `100dvh` where mobile browser bars change height.

## 5. Reduced motion and no-JS (required)

- Set a class early in `<head>`: `if (matchMedia("(prefers-reduced-motion: reduce)").matches) document.documentElement.classList.add("reduce")`.
- With `.reduce` or without JS, the section renders as a plain vertical list: each step's screen with its caption. The script exits early and does nothing.
- Counters show their final number. No autoplaying video under `.reduce`.

## 6. Verify

- Scroll through at 1440, 1920 and 390 widths; take screenshots at each step boundary.
- Record a fast scroll and a slow scroll and check frames (see `verify-motion-by-recording`): no blank frames, no text collisions mid-transition.
- Toggle reduced motion in DevTools (Rendering > Emulate CSS prefers-reduced-motion) and check the static layout.
- Profile one scroll pass in DevTools Performance: no long tasks, no layout thrashing.

Template: `templates/scroll-story.html` is a complete, dependency-free example of a pinned phone with a wipe between steps and a reduced-motion fallback. Copy it, replace the steps, tune the constants.

## Done when

Every step readable at all three widths, reduced-motion layout complete, fast scroll shows no blank or colliding frames (recorded, not assumed), and the owner confirmed the feel on a real phone.
