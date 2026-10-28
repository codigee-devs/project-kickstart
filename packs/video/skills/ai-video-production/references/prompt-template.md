# Timeline prompt template

Works for current timeline-aware video models. Fill the angle brackets, delete what does not apply.

```
A short <style, e.g. "ordinary smartphone video"> <format, e.g. "vertical 9:16 clip"> in the exact style of @Image1.
<Scene: place, time of day, one light source, a little realistic clutter.>
<N> characters only: <full description of A> (@Image2 shows A from the front); <full description of B>.
No two people share hair colour, hairstyle, build or clothing colour.

[0s] <camera, e.g. "Static wide shot with exactly the composition of @Image1">. <one small concrete gesture per character>. <sound>.
[2s] <next action, one per beat>.
[4s] <ending, e.g. "Cut to: closer handheld shot on the man in the middle pressing his lips together">.

Sound: <room ambience>, <single sounds>. No music, no dialogue, no speech.
Style: <style>, <tone>. Characters keep exactly the same design, clothing, colours and proportions as in the references.
Nobody freezes. Reactions stay low-key and mundane, like a real casual conversation; no exaggerated group laughter.
No readable text anywhere in frame. <content negatives>.
Ordinary smartphone footage, no gimbal smoothness, no cinematic polish.
```

## Variants

- **Multi-shot in one generation**: use "Cut to:" between beats; models that support it keep identity across cuts. Describe the relation ("back to the wide shot").
- **Dialogue with lip-sync**: put the line in quotes: `She says: "You came back."`
- **Image-to-video**: drop the scene and cast description, keep only motion and sound per beat.
- **Moving camera hook**: "Vertical smartphone video FILMED HANDHELD BY A PERSON WALKING, natural walking sway, slight focus hunt and exposure shift."

## Generation ledger (one line per job)

```
date | shot id | model | resolution | seconds | prompt file | seed | job id | cost | accepted window (s) | verdict
```
