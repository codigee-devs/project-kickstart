---
name: voice-over
description: Synthetic voice-over and character voices with a TTS service such as ElevenLabs - beat table with hard length limits, style samples before batch generation, emotion tags and an energy map, a pronunciation layer for brand and foreign words, length calibration, STT and loudness verification of every file, cutting a read to picture, and a "less studio" mix. Use for "record a voice-over", "generate a voice", "the narrator mispronounces", "lines are too long", "make the voice less studio", "TTS", "nagraj lektora", "wygeneruj glos", "lektor zle czyta", "zle wymawia".
---

# Voice-over with TTS

An unnatural voice is rejected faster than any visual flaw. Plan, sample, then batch, and verify every file by measurement and transcription.

## 1. Plan before generating

- **Beat table**: where the voice speaks, a hard limit in seconds per beat, how many variants (lines heard 5-10 times per session need about 30 variants), energy level per beat. Shouting only at peaks.
- **Three style samples** (A/B/C) of one line. A human picks; write down the allowed and banned tags.
- Voice, model and stability per language in ONE config file. No silent fallback to another language's voice.
- Keys only in `.env` (for example `TTS_API_KEY`), never in files, logs or answers.

## 2. Writing for expressive TTS models

- Tags in square brackets, max 2 per sentence (for example `[warm, playful]`). Newer expressive models often ignore SSML breaks; use punctuation.
- Energy: excited tags only at peaks; max one "!" per line outside peaks.
- Laughter: use a laugh tag plus a friendly modifier (warm, playful, teasing). Avoid "mocking", "smug", "sinister" and spelled-out laughter: they sound like a villain. Crowd laughter is a sound effect, not TTS.
- Punctuation shapes delivery: "Look! Richard!" (to the audience) vs "Look, Richard" (to a character). Commas mark beats for animation; an ellipsis drags a word.
- **Pronunciation layer**: brand and foreign words are respelled phonetically ONLY in the TTS input, never on screen. Do it in one function (`toSpeech(text)`) with a rule list, not by hand in the content. Version the rule list and include the version in the file hash so a rule change triggers regeneration.
- A voice reading a language it was not made for: set the language code AND respell; the code alone is not enough.
- Narrator character through theatrical tags (for example `[wry aside]`, `[with gravitas]`), not whispering.
- **Length**: calibrate characters per second for your voice and language with 10 sample lines, add start latency. Other languages run longer: write to 75-80% of the limit.

## 3. Generate

```bash
curl -s -X POST "https://api.elevenlabs.io/v1/text-to-speech/$VOICE_ID?output_format=mp3_44100_128" \
  -H "xi-api-key: $TTS_API_KEY" -H "Content-Type: application/json" \
  -d '{"text":"[warm] Your line here.","model_id":"<model>","voice_settings":{"stability":0.5,"similarity_boost":0.8}}' \
  -D headers.txt -o line-001.mp3
grep -i character-cost headers.txt
```

- Stability around 0.5 for expressive lines; around 0.8 for a continuous narrator (lower values make every line sound like a different person).
- Respect the account's concurrency limit (a few parallel requests per process; 429 means back off).
- The generator skips unchanged files (hash of text + voice + settings + pronunciation rule version) and writes a manifest with `durationMs`.
- Archive every file outside temp folders. The API may not keep history; a lost file is a new paid generation.
- Use only the official API. Do not script a vendor's internal web endpoints.

## 4. Verify every file

```bash
ffprobe -v error -show_entries format=duration -of csv=p=0 line-001.mp3          # vs the beat limit
ffmpeg -i line-001.mp3 -af loudnorm=I=-16:TP=-1.5:print_format=json -f null -     # measure
```

- Speech-to-text (vendor STT or local Whisper): text matches, language is right, brand word in an accepted spelling. Whitelist names that STT always gets wrong.
- Normalize to about -16 LUFS, true peak -1.5 dBTP with two-pass loudnorm.
- Completeness gate: every line x language has a file within its limit.
- Listening page for a human: 4 buttons per file (bad / weak / good / great), a comment field and "Copy ratings".

## 5. Cut a read to finished picture

- Generate one natural read of the whole passage, then cut at pauses and place fragments on the picture's timings.
- Find cut points from the loudness envelope (for example below -42 dBFS for 40 ms), not from STT timestamps, which end stretched words early.
- Anchor cuts on two-word pairs; a single word can occur twice.
- Lip-sync to generated mouths: speed tags and at most about 1.25x tempo.

## 6. "Less studio" mix for voices inside scenes

1. Calm lines, no exclamation marks, higher stability.
2. Distance: `highpass=f=180,lowpass=f=6500`.
3. Reverb by convolution with a REAL impulse response of a small damped room (`afir`), dry about 0.55, wet about 0.9. Synthetic IRs blur words.
4. Quiet room noise, slow strong compression, mono.
5. Dialogue as loud as the narrator, raised at the source plus a limiter.

## 7. In an app or game

- A phase waits for the line to end (length from the manifest); max about 0.5 s of waiting after it. Everything works without audio.
- Guard: never play a recording whose text differs from the caption on screen.
- New recordings ship disabled and are switched on after a backup; old ones are deleted only on explicit request.

## Done when

Every file is within its length limit, matches its text by STT, is normalized, listed in the manifest and archived. The report says "checked by transcription and measurement" vs "listen to the intonation of line X at second N".
