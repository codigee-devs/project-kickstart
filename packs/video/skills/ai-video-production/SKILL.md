---
name: ai-video-production
description: Produce video with generative models (image-to-video and text-to-video, for example Seedance, Kling or Flux video) without it looking like AI - brief and budget first, script and cast bible approved before spending, timeline prompts with time beats, cheap probe generations, green-screen device screens for language versions, seamless background loops, full-resolution frame QA, an independent critic and a "less AI" post pass. Use for "generate a video", "make a scene with AI", "ad with people", "trailer", "write a video prompt", "make it look less AI", "background loop from an image", "wygeneruj filmik", "napisz prompt do wideo", "zeby nie wygladalo jak AI".
---

# AI video production

Models change every few months; the process does not. Spend nothing until a human approved the script. Generated footage is for scenes; product screens are always real recordings.

## 1. Brief and budget (no spending)

- What must a viewer understand **with the sound off** (max 3 things), and the one action at the end.
- What is real (product screens, real sessions), what is generated, what is a graphic or HTML scene.
- Budget in money, agreed up front. State the estimated cost before every generation and keep a running total. Check current per-second pricing of the model and resolution you use; higher resolutions often cost 2-3 times more.
- Consider cheaper, more reliable forms first: real phone footage from a shot list, a photo dump from stills, an HTML scene rendered with a headless browser. Current models handle groups of more than about 4 people reacting at once badly.

## 2. Script for approval (an HTML page, see `references/script-template.md`)

1. The idea in one sentence.
2. Table "typical AI mistake -> rule in this script" (from research and the anti-slop list).
3. A top-down plan of the room with camera cones; for each shot, what is left and right in THAT frame. Check geometrically who fits in frame.
4. **Cast bible**: age, hair, clothes, position, prop (which phone, which hand), role. One English cast block pasted word for word into every generation, ending with "No two people share hair colour, hairstyle, build or clothing colour."
5. One light source, time of day, a set with realistic clutter.
6. Second-by-second shot table: picture, device screen, caption, voice, sound, source of the shot.
7. Logic check per scene: furniture, continuity of hands and props, natural behaviour, every question on screen gets an answer, captions match the picture.
8. Reference stills (and edits of the same still for continuity), then **STOP for human approval**.

## 3. Prompt structure (timeline prompting)

See `references/prompt-template.md`. Rules that held across models:

- Fixed labels for each character ("the woman on the right" everywhere, never "she" in one beat and "the woman" in the next).
- One action per time beat; number of beats matches clip length (`[0s] [2s] [4s]` for 5 s).
- Direction of movement stated explicitly ("walks to the LEFT of frame").
- Continuous micro-movement ("nobody freezes"); reactions low-key and different per person, never a group laughing on cue.
- Camera described plainly ("gentle handheld drift", "static wide"). No buzzwords like "cinematic", "8K", "masterpiece".
- Phones with a portrait UI: "held UPRIGHT in PORTRAIT orientation".
- In image-to-video, describe only what changes (motion and sound), not what the image already shows.
- Content negatives at the end (for example "no alcohol, no readable text anywhere in frame").

## 4. Generate: probe, then once properly

- **Probe** each new shot type at the lowest resolution, shortest length, no audio. It costs a fraction of the real take.
- Checklist before the real take: device orientation, screen language, reference image size, active project or account, remaining balance.
- One shot = one clip of 4-5 s (one action, one camera move). In the edit you use 2-3 s of it.
- Hosted providers moderate inputs. Observed in 2026: faces in reference images (even drawn characters) and large references were rejected, often with the error only visible when you fetch the result body, not in the job status. Fixes: keep references at or below about 1280 px, describe faces in words, use text-to-video for groups, upload references to the provider's storage instead of inline base64. Always read the full response body.
- Motion the prompt cannot force: give the model your own rough clip as a video reference.
- **Language versions**: generate ONCE with solid green device screens ("solid bright green chroma key screen, no content") and composite real recordings per language in post. A reference with visible UI makes the model redraw text in the wrong language.
- Results in provider queues expire after hours; cancelling a started job usually does not stop billing. Download immediately to a permanent folder and log model, prompt, seed, job id and cost in a generation ledger.

## 5. QA every clip at full resolution

```bash
ffmpeg -ss 2.0 -i clip.mp4 -frames:v 1 -vf format=yuv420p frame-2s.png   # full-size frames, not thumbnails
```

Reject when: a face, hairstyle or outfit changes between shots, hands or eyes are wrong, readable text appears, there are several light sources, motion floats or smears, a phone is in the wrong orientation, a screen shows the wrong language, the cast has clones, or anything breaks your content rules. Some models output 10-bit HEVC: put `format=yuv420p` first in ffmpeg filter chains.

Then send the render and the brief (nothing else) to a **fresh critic agent**. Fix by its list; the next round goes to a new critic that verifies the previous list item by item.

## 6. "Less AI" post pass

- Picture: slightly darker mid-tones, warmer, light vignette, grain, a little hand shake or slow push-in, one shared grade for the whole piece, mild sharpen on 720p clips.
- Composited screens: match brightness and sharpness to the room, lift blacks, add reflection or glow, remove green spill.
- Character voices: calmer and "through a phone" (see `voice-over`, mix section).
- Sound design: room tone, action sounds; music under the voice.

## Background loop from one image

Image-to-video with the same image as first and last frame, about 6 s, no audio, calm prompt ("LIGHTING IS CONSTANT, no flashes, no strobing", "the logo is never redrawn"). Seam: find an end frame that matches frame 0 (hard cut) or crossfade about 12 frames. QA: frame-to-frame difference on the loop played twice; the seam must sit inside the normal step range. Frame interpolation does not fix jumping figures; a new take does.

## Done when

Script approved, spend within budget and reported, every clip viewed at full resolution, the critic round passed, post pass done, edit QA done (`video-editing-qa`). The report separates what was checked (frames, costs) from what a human must judge (motion, naturalness).
