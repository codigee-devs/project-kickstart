# Video script template (for human approval)

Render as one HTML page so the owner can read it on a phone. Nothing is generated before this page is approved.

## 1. Idea
One sentence. Length, aspect ratio, where it runs, the one action at the end.

## 2. AI mistake -> rule in this script
| Typical mistake | Rule here |
|---|---|
| Group laughs on cue | Every reaction is different and small |
| Clones in the cast | Cast bible, distinct hair, build and clothes |
| Phone in landscape showing a portrait app | Phones upright, portrait |
| Readable garbage text | No text in generated frames; captions added in the edit |
| Several light sources | One window, late afternoon |

## 3. Room plan
Top-down sketch (SVG is fine) with furniture, people and one camera cone per shot. Per shot: who is left, who is right, who is cut off.

## 4. Cast bible
| Label | Age | Hair | Clothes | Position | Prop, hand | Role |
|---|---|---|---|---|---|---|

Cast block (pasted word for word into every prompt):
```
<label A>: <age>, <hair>, <clothes>, sits <position>, holds <prop> in the <left/right> hand.
...
No two people share hair colour, hairstyle, build or clothing colour.
```

## 5. Light and set
Time of day, one light source, set dressing with realistic clutter, content rules (for example no alcohol).

## 6. Shot table
| Time | Picture | Device screen | Caption | Voice | Sound | Source (real / generated / graphic) |
|---|---|---|---|---|---|---|

## 7. Logic check
Continuity of hands and props, furniture consistent across shots, every on-screen question answered, captions match picture, nothing physically impossible.

## 8. Reference stills
Key frames for each shot, edits of the same still for continuity. Then: approved by ____ on ____.

## Budget
| Shot | Probe cost | Take cost | Takes allowed |
|---|---|---|---|
Total approved: ____
