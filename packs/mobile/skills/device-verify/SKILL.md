---
name: device-verify
description: Verify a mobile UI or behavior change the way the user will see it - full restart instead of hot reload, simulator screenshots and screen recordings, frame extraction for animations, batched debug logs for bugs you cannot run yourself, and a report that separates what was verified from what a human must confirm. Use before saying a UI fix is done, and when the user says it still does not work. Triggers - "check it on the device", "verify the screen", "record the animation", "it still does not work", "the change is not showing", "sprawdz na urzadzeniu", "nadal nie dziala", "nie widze zmiany", "nagraj to".
---

# device-verify

Green analyzer and tests prove the code compiles. They do not prove the screen is right. Done means what the user sees.

## 1. "The change is not showing" is usually not a failed edit

Check in this order before editing again:

1. Hot reload missed it. Do a full restart (`R` in `flutter run`, or stop and run again). Changes to `initState`, constructors, DI, routes, native files and generated code always need a restart or rebuild.
2. Stale generated code. Run `dart run build_runner build --delete-conflicting-outputs`.
3. A remote override hides it: server-driven translations, remote config, feature flags or a cached API response can mask a new string or a new default. Check the overlay layer.
4. Wrong flavor or env: the build you are looking at is not the one you changed.
5. Only then: the edit itself is wrong.

## 2. Capture what the user sees

iOS simulator:

```bash
xcrun simctl list devices booted
xcrun simctl io booted screenshot /tmp/screen.png
xcrun simctl io booted recordVideo --codec h264 /tmp/screen.mov &
REC_PID=$!
# ...reproduce the flow...
kill -INT "$REC_PID"      # SIGINT, or the file is unreadable
```

Android emulator or device:

```bash
adb exec-out screencap -p > /tmp/screen.png
adb shell screenrecord /sdcard/screen.mp4   # Ctrl+C to stop
adb pull /sdcard/screen.mp4 /tmp/
```

Then open the image and look at it yourself before reporting.

## 3. Animations and short effects: record, then measure

A screenshot of a 300 ms transition proves nothing either way. Record it, split it into frames and measure:

```bash
ffmpeg -i /tmp/screen.mov -vf "fps=10,scale=480:-1" /tmp/frames/f-%03d.png
```

```python
from PIL import Image, ImageStat
region = Image.open("/tmp/frames/f-012.png").crop((x0, y0, x1, y1))
print(ImageStat.Stat(region).mean)   # average RGB of the area that should change
```

Compare the numbers across frames (a fade changes the mean gradually; a cut changes it in one frame). For before/after questions, record both and compare the same region.

## 4. Bugs that only reproduce on the user's device

You cannot run it, so do not debug one log at a time.

1. Write down the hypotheses (two to five) and what each predicts.
2. Add logs for all of them in one change, at every branch that matters, each with a unique tag: `[FEATURE] step=... value=...`. Use the app logger, not `print`.
3. For each hypothesis, name the exact log line that confirms or rules it out.
4. Ask the user for one run and the full log.
5. When the log comes back, say which hypotheses it ruled out before proposing a fix. Do not call the diagnosis closed before the data arrives.
6. Remove or downgrade the temporary logs in the fix commit.

"Still broken" after a fix is the same bug. Keep the list of what was already ruled out; do not restart the diagnosis.

## 5. Report

Two short lists, always:

- **Verified:** what you ran and saw (analyzer, tests, screenshot of screen X on simulator Y, frame numbers).
- **Please confirm:** what only the user can check (physical device, real account, push, payment, store build, sound).

Attach or link the screenshots and recordings.
