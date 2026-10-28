---
name: game-design-spec
description: Design a casual, party or multiplayer game (including shared-screen games with phones as controllers) as one spec before code - pitch, phases with timings, who sees what, scoring that teaches good behaviour, ties, catch-up, finale, disconnects, narrator lines, content rules, prototype then playtest, and analytics from day one. Use for "design a game", "game mechanics", "write the game spec", "the game is boring", "the game is too long", "how to play screen", "zaprojektuj gre", "mechanika gry", "spec gry", "gra jest nudna".
---

# Game design spec

Write the spec before any code, fill every section with numbers, then build a playable demo before infrastructure. Judge by the screen and by a playtest, not by the document.

## Five rules

1. **Pace**: a phase ends when everyone eligible has acted (disconnected players never block); a session is 15-30 minutes; intro and rules can be skipped.
2. **Everyone gets a moment**: rotate who is in the spotlight, give catch-up help above a threshold, give fun titles to non-winners, make honesty pay.
3. **No repeats**: content and narrator lines are drawn with memory across sessions; frequent lines have many variants.
4. **Visible wow first**: a playable demo with one big moment beats a perfect backend.
5. **Secrets live on the server**, never in a client that does not need them.

## 1. Research (see `research-with-sources` in the marketing pack)

Player threads and reviews -> a table "observation -> design rule". Competitors: what works, what is missing. Name: search demand often sits in a cluster phrase, not your literal name.

## 2. The spec (one document, see `templates/spec-outline.md`)

Fill every section:

- **Pitch** in one sentence, min/max players, session length.
- **Phases with times**: intro, how to play, round (repeated N times; N as a function of players with a ceiling), interludes, finale, results. The server advances phases on timers and ends early when all eligible players acted.
- **Who sees what**: a table phase x (shared screen / player device / target player / server). On a phone controller: one tap per turn, 2-4 big choices, 3 s undo, a "look at the screen" waiting state.
- **Scoring**, and why it teaches the behaviour you want (for a bluffing game: truth earns, each fooled player earns, the target earns for "just right").
- **Ties** written out for every decision (vote, elimination, finale).
- **Catch-up**: a threshold behind the leader triggers a help, not a random card; announced only to the new chaser.
- **Finale** with changed rules (for example lives instead of points, a cap on sudden death).
- **Leaderboard**: rarely (after an act or only at the end), at least 3 s after its entrance animation finishes.
- **Ending**: winner plus 2 funny titles from stats for two different non-winners.
- **Disconnects and rejoin**: resend private screen, take over a seat, server restart without double points.
- **Hidden roles** (if any): identical layout and feedback on every device, fixed length of secret phases, role card shown only while a finger holds it.
- **No audio**: every moment has a minimum time; a phase lasts max(minimum, end of narrator line).

## 3. Narrator (see `voice-over` in the video pack)

Reads every question, introduces a rule when it is first used, never repeats what is already on screen. Beat table with hard limits; it never lengthens a round; max about 0.5 s wait after a line. Energy map with shouting only at peaks; tone "roast with affection". About 30 variants for lines heard 5-10 times a session; test "6 sessions in one room without repeats".

## 4. Content

- Readable from the couch: question at most about 15 words or 90 characters, an option at most 4 words.
- Quizzes: aim for 2/3 to 3/4 correct; the first question about 90%. Authors underestimate the difficulty of their own questions; measure per language.
- Questions about the players: always about people in the room, mild by default, spicy in a separate deck, strong but without slurs.
- Good question: concrete plus a small secret or hook. Bad: abstract, metaphor, assumes something happened, opinion about the group, worn idioms, hints at harm.
- Write natively in each language. Draw with exposure memory per device or account.

## 5. Prototype and playtest

1. HTML prototype of shared-screen and phone screens with the time of each phase, recorded on video (`html-prototype`).
2. Playable demo; "how to play" as an animated demo round synced with the narrator.
3. Tools: a debug panel with every scene and state (timed fixtures), a simulator of one screen plus N controllers, bots that play full sessions.
4. Playtest with real people (`user-test-plan`). Translate typical comments into numbers in the spec: "I did not know what to do" (missing introduction), "choppy" (transitions too fast), "sudden" (no announcement).

## 6. Analytics from day one

Events: start, end, finished (reached the results screen), abandoned with phase, use of each mechanic, a 1-question survey after EVERY session. Abandonment analysis split by mode and language; check that one room does not dominate the numbers.

## Technical traps that break design

- Reset scores at the START of a game (lobbies show the last ranking).
- Client animation times and server phase constants mirror each other: change both.
- Older clients do not know new screens: fallback "look at the screen", additive-only contract fields, rules text from the server.
- Empty lobby or vanished shared screen: timeout from the moment it emptied; one pause without auto-resume.

## Done when

Every spec section has numbers, ties and disconnects are written out, the narrator table has limits, an HTML prototype is recorded, and there is a list of playtest questions.
