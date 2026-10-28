# The creative packs

Four packs cover the work around the code: deciding what to build, showing it, and telling people about it. They follow the same rules as the engineering packs: plan before spending, verify what a person actually sees, and let a human approve anything that leaves the building.

| Pack | Skills | Start here when |
|---|---|---|
| [ideas-prototyping](../packs/ideas-prototyping/README.md) | `html-prototype`, `compare-concepts`, `game-design-spec`, `user-test-plan` | You have an idea and need a decision |
| [animation](../packs/animation/README.md) | `motion-principles`, `scroll-story`, `verify-motion-by-recording` | Something should move, and still be readable |
| [video](../packs/video/README.md) | `ai-video-production`, `voice-over`, `video-editing-qa` | You need a trailer, an ad, a demo or narrator lines |
| [marketing](../packs/marketing/README.md) | `research-with-sources`, `positioning-and-copy`, `ad-creatives`, `aso-store-listing`, `launch-checklist` | You need facts, words, creatives or a launch plan |

## A typical flow

1. **Research** the decision (`research-with-sources`): frame the question, rank sources, end with a "To decide" list.
2. **Position** it (`positioning-and-copy`): one page of who it is for, the proof, and what we never claim.
3. **Prototype** 3 concepts from one brief (`html-prototype`, `compare-concepts`) and let the owner pick on their phone.
4. **Move** only where motion explains something (`motion-principles`, `scroll-story`), and prove it with a recording (`verify-motion-by-recording`).
5. **Test** with 5 real people (`user-test-plan`) and turn comments into numbers.
6. **Tell** people: store listing (`aso-store-listing`), ads (`ad-creatives`) with footage and voice from the video pack, then `launch-checklist`.

## Principles behind every creative skill

- **A decision first.** Research, prototypes and tests exist to change a decision. Write the decision down before starting.
- **Real over generated.** Real screens, real recordings and real numbers. Generated media fills scenes, never fakes proof.
- **Cheap-looking is expensive.** Audiences read cheap-looking marketing as a cheap product. Every creative gets an anti-slop pass and a human sign-off.
- **Readability before effect.** Every animation keeps working with reduced motion and at phone width.
- **Measured, then judged.** Frames, loudness, transcripts and screenshots are checked by tools; feel, rhythm and taste are judged by a person. Reports always separate the two.
- **Budget out loud.** State the cost of any paid generation before running it and keep a running total.
- **No AI tells in text.** No long dashes, smart quotes or hype words; `packs/marketing/skills/positioning-and-copy/scripts/find-ai-tells.sh` checks files.

## Tools these skills expect

- A browser automation tool (Playwright or similar) for screenshots and recordings.
- `ffmpeg` and `ffprobe` for video and audio checks; Python with Pillow for frame measurement.
- Accounts for any generative video or TTS provider you choose, with keys in `.env` only.

None of the skills depend on a specific vendor. Where a vendor is named, it is an example from our own use, with dates, because limits and prices change.
