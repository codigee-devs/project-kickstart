---
name: verify-motion-by-recording
description: Verify UI, animations and transitions the way a person sees them - pick the right surface (iOS/tvOS simulator, separate Chromium, a logged-in browser over CDP), full restart instead of hot reload, fixtures for the state, screen recording instead of screenshots for effects under 2 seconds, frames extracted with ffmpeg and measured with Python (mean brightness, A/B), side-by-side comparison pages and a verified vs to-confirm list. Use for "check if the animation works", "record it", "is the effect visible", "the effect does not work", "compare with the design", "sprawdz czy animacja dziala", "nagraj to", "efekt nie dziala", "porownaj z figma".
---

# Verify motion by recording

"It works" means what is on screen, measured. A screenshot where "nothing is visible" does not prove the effect is missing; a screenshot where "something flashed" does not prove it works. Green tests are not proof of anything visual.

## 1. Pick the surface

| What | Tool |
|---|---|
| iOS or tvOS simulator | `xcrun simctl io booted screenshot` / `recordVideo` |
| Android emulator or device | `adb shell screenrecord`, `adb exec-out screencap -p` |
| Web, local | A separate Chromium from Playwright (flags below) |
| Pages behind the user's login | The user's own browser over CDP or a browser extension, with permission |
| Old TV browser engines | The matching old Chromium build in headless screenshot mode |

## 2. Prepare (always)

1. Full restart instead of hot reload; free the port first (`lsof -nP -iTCP:<port> -sTCP:LISTEN -t | xargs kill -9`). Confirm the new build or commit in the log. Hot reload and cached bundles routinely hide edits.
2. Headless with real GPU for WebGL: `--enable-gpu --ignore-gpu-blocklist` (on macOS add `--use-angle=metal`). Check the renderer string is not a software rasterizer.
3. Set the state with a fixture or deep link. Scenes that animate only NEW items need a fixture with timed steps (`steps: [{atMs, state}]`), or you only ever see the end state.
4. Flutter web: enable semantics (click `flt-semantics-placeholder`) to find elements by label; avoid device scale factor 2 with CanvasKit (blank frames).
5. Never reload a screen a person is looking at; never run simulations on a shared environment.

## 3. Capture

- Static screen: screenshot of the element, not the whole page.
- Effect shorter than 2 s or any transition: **record**, starting before the effect is triggered.

```bash
xcrun simctl io booted recordVideo --codec h264 out.mov & REC=$!
# trigger the scene
kill -INT $REC                                   # a plain kill corrupts the file
ffmpeg -i out.mov -vf "fps=8,scale=640:-1" f-%03d.png
```

- Web: Playwright `recordVideo` on the context, or `getDisplayMedia` + `MediaRecorder` in a Chromium launched with `--auto-accept-this-tab-capture`. Re-encode WebM with an explicit rate (`ffmpeg -r 30 -i in.webm ...`), since some recorders declare a wrong frame rate.
- 10-bit HEVC sources: start filters with `format=yuv420p`.

## 4. Measure instead of eyeballing

```python
from PIL import Image, ImageStat
crop = Image.open("f-012.png").crop((x0, y0, x1, y1))
print(ImageStat.Stat(crop).mean)   # mean R, G, B of the region
```

- Fades: measure MEAN brightness of the region over frames (linear in opacity). A binary threshold makes a 500 ms fade look like a one-frame cut.
- A/B: the same shot with and without the effect, compare numbers.
- Smoothness and fps: count from recorded frames, not from a JS counter.
- Loops: `ffmpeg -stream_loop 1 -i loop.mp4 -vf "tblend=all_mode=difference,signalstats" -f null -` and check the seam sits within normal frame-to-frame steps.
- Web vs design or native: sample the pixel color at the same point on both, read sizes from computed style or `getBoundingClientRect`, after confirming both show the same state.

## 5. Report

- An HTML page with pairs side by side (app | reference), each with a status: matches / deliberate difference / out of scope.
- For human judgement, a rating page: 4 buttons per item (bad / weak / good / great), a comment field and "Copy ratings" (see `user-test-plan` in the ideas-prototyping pack).
- End with two lists: **verified** (how, with numbers) and **to confirm on a device / by ear**.

## Done when

The state is measured (numbers from frames or side-by-side pairs), every effect under 2 s has a recording, and the report separates verified from to-confirm. Never "works" based on a single screenshot or green tests.
