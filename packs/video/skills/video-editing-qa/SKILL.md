---
name: video-editing-qa
description: Edit and quality-check short videos (ads, trailers, demos) in any editor, including editors driven by an MCP server - templates and versioned copies instead of editing approved timelines, aspect-ratio rules, audio levels without overlapping speech, frame-by-frame QA at full resolution, loudness targets, export checks with ffprobe and blackdetect, and a creative registry. Use for "edit this video", "build an ad from the template", "export the timelines", "check the video before publishing", "loudness", "zmontuj", "wyeksportuj filmiki", "sprawdz filmik przed publikacja".
---

# Video editing and QA

## 0. Before editing

1. There is an approved script (see `ai-video-production`). If not, write it first; spend nothing.
2. The editor is connected and the RIGHT project is open. Editors driven by MCP often bind to the front-most project; one agent session per project.
3. Read the project state (media folders, templates, timelines, canvas size, fps) from the editor's tools, and tool parameters from its schema, not from memory.

## 1. Timeline rules

- **Never edit an approved timeline.** Copy it (`<LANG> - <Name> - <length> - v2`) and edit the copy. After a copy, all clip ids are new: re-read the timeline.
- Pass the timeline id explicitly in every call when the tool supports it; a human may be clicking in parallel.
- Batch multi-step edits when the editor supports atomic batches (one undo step).
- Import media only from a permanent project folder, never from temp folders.
- Mute the linked audio of generated b-roll clips explicitly.
- An asset in a foreign aspect ratio (16:9 inside 9:16) always gets an explicit treatment: full bleed, fitted inside a device frame, or pillarbox over a blurred copy. Never a strip on a flat background.
- Language versions from one master: identical file names per language folder, swap media and text by tag; read the list of unmatched items.
- Save the project after a big series of edits and before quitting the editor.

## 2. Audio

- Voice at full level, music about 14 dB under the voice with a fade-out, b-roll audio muted.
- No overlapping speech: read the transcript with word timings; the last word of one line ends at least 5 frames before the next line starts. Too short a window: move the cut or trim the scene tail.
- A person speaking on screen keeps their own voice; do not cover their mouth with an off-screen narrator.
- Raise loudness at the source (normalize + limiter on the file), not with clip gain in the editor.
- Check the voice-over language by transcription, not by file name.

## 3. QA before export (mandatory)

- Timeline check from the editor (zero errors, warnings reviewed), if it has one.
- Loudness target: -14 LUFS for punchy social pieces, about -16 LUFS for calm pieces, true peak at or below -1.5 dBTP.
- Capture the first frame of every beat at full resolution (preview thumbnails are too small to judge text).

Frame checklist:
- Frame 0 is a finished, readable composition (it is the thumbnail).
- No seams or exposed background, no half-entered words.
- Safe zones in 9:16: critical text not in the bottom ~12% of the height and not along the right edge (platform UI covers them).
- Screen language matches the version; cursors and fingers only on real taps.
- No readable text inside generated scenes; the same person stays the same person across shots.

## 4. Export and verify the file

```bash
ffprobe -v error -show_entries format=duration:stream=codec_name,width,height,r_frame_rate -of compact out.mp4
ffmpeg -i out.mp4 -vf blackdetect=d=0.3:pix_th=0.10 -an -f null - 2>&1 | grep black_start
ffmpeg -i out.mp4 -af ebur128=peak=true -f null - 2>&1 | tail -12
ffmpeg -ss 3.5 -i out.mp4 -frames:v 1 check-3.5s.png
```

- Duration matches the timeline (within 1 s), no unexpected black, loudness in target, control frames of every changed scene.
- Never overwrite an export: new versions get a `-v2` suffix. Exports go to a series folder; a human moves finals to production.

## 5. Project order

- One project per brand. Timeline folders numbered by role: `00 Templates`, `01 Production`, series folders, `97 Previews`, `98 Archive`, `99 To delete`, language subfolders.
- File folders: `01-production/<market>/vN/`, `02-exports/<series>/`, `03-sources/`, `04-work/<production>/`. Production scripts live in the repo, not in temp folders.
- A **creative registry** (one markdown file): what is final, where it lives, which template, the recipe. Every new creative is added.
- A master template plus an end-card block with alpha; markers in the template say what to replace and what not to touch.

## Done when

No editor errors, loudness in target, first frame of every beat viewed at full resolution, ffprobe and blackdetect clean, registry updated, project saved. The report separates what was checked (frames, LUFS, transcript) from what a human must judge by eye and ear (rhythm, intonation), with timestamps.
