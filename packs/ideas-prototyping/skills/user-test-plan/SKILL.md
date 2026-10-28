---
name: user-test-plan
description: Plan and run a small user test or playtest of a prototype, app or game - the decision it informs, 3-5 tasks, who to recruit, a moderator script that does not lead, what to observe and log, a rating page with 4 buttons and "Copy ratings" for content or variants, turning comments into numbers and spec changes, and a short findings page. Use for "user test", "playtest", "usability test", "test this with people", "rate these variants", "what do users think", "test z uzytkownikami", "playtest", "ocena wariantow", "sprawdzmy na ludziach".
---

# User test plan

Five people find most of the big problems. The test exists to change a decision, so write that decision down first.

## 1. Plan (one page, `tests/<date>-<topic>/PLAN.md`)

- **Decision** this test informs, and what result would change it.
- **What is tested**: prototype URL or build number, device, language.
- **Participants**: 5 per segment, matching the real audience (not the team, not friends who know the product). Screener questions in one list.
- **Tasks** (3-5): realistic goals, not instructions. "You want to book a guided tour for Saturday" instead of "tap Book".
- **Success criteria per task**: completed without help / with a hint / failed; time to complete.
- **Questions after**: one rating (1-5 "how easy"), "what was confusing", "what would you tell a friend this is".

## 2. Moderator script

- Explain that you test the product, not the person; ask them to think aloud.
- Never explain the UI during a task. If asked, answer "what would you expect?".
- Hint only after a fixed time (for example 60 s stuck), and log the hint.
- Same script, same order for everyone. Record screen and voice with consent.

## 3. Observe and log

One row per observation, during or right after the session:

```
participant | task | moment (mm:ss) | what happened | quote | severity (blocker / major / minor)
```

For games and shared-screen products, also log: when people looked at the wrong screen, when nobody knew whose turn it was, where the room went quiet.

## 4. Rating pages for content and variants

When people (or the owner) must judge many items (questions, voice lines, screen variants, creatives), use `templates/rating-page.html`: each item gets 4 buttons (bad / weak / good / great) and a comment; ratings are kept in the browser and "Copy ratings" puts them on the clipboard as text to paste back. Rewrite or regenerate by the pattern of the ratings, not by the loudest comment.

## 5. From comments to changes

- Group observations by problem, count participants per problem, sort by severity then count.
- Translate feelings into numbers in the spec: "I did not know what to do" -> add an introduction step; "too fast" -> transition from 4 s to 8 s; "sudden" -> add an announcement 2 s before.
- Every change has the observation it came from. Re-test the changed parts with new people.

## 6. Findings page

A single HTML page: the decision and the answer, task success table, top problems with quotes and counts, proposed changes, and **To decide** with default answers. Keep recordings private; quote participants without names.

## Done when

The plan states the decision, 5 participants per segment completed the tasks, every observation is logged with severity, problems are counted, changes are traced to observations, and the owner has the findings page.
