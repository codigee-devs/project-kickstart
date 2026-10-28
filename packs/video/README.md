# Video pack

Short videos for products: ads, trailers, demos and in-app scenes, made with generative models, synthetic voices and a normal editor. The point is not to generate more; it is to ship footage that does not look cheap.

| Skill | Use it when | You get |
|---|---|---|
| `ai-video-production` | Any generated footage: scenes with people, product b-roll, background loops | Brief and budget, a script page with a cast bible to approve, timeline prompts, probe-then-take workflow, frame QA, a critic loop, a "less AI" post pass |
| `voice-over` | A narrator, character voices or ad voice-over with TTS | Beat table with limits, a pronunciation layer, STT and loudness checks, cutting a read to picture, a "less studio" mix |
| `video-editing-qa` | Editing and exporting, in any editor or one driven by MCP | Timeline rules, audio rules, a frame checklist, ffmpeg export checks, a project structure and creative registry |

## Order of work

1. `ai-video-production` sections 1-2: brief, budget, script. A human approves.
2. Probe generations, then real takes. `voice-over` in parallel.
3. `video-editing-qa`: edit, QA, export, verify the file.
4. Handoff note: what was measured vs what a human must watch and listen to.

## What you need

- `ffmpeg` and `ffprobe` on the PATH.
- Accounts for the model and TTS providers you use; keys in `.env`, never in files.
- Optional: Whisper or a vendor STT for transcript checks.

Prices, limits and moderation rules of hosted models change often. Treat the numbers in these skills as observations with a date, and check current docs.
