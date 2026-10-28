# Research HTML outline

One self-contained HTML file (inline CSS, no external requests), readable on a phone. Sections in this order:

1. **Verdict in 60 seconds**: one sentence, then 4-6 stat tiles (number + one-line label). Every number links to its source row.
2. **Decisions**: the frame's decisions, each with recommendation, criterion and result.
3. **Now vs proposed**: table with columns `area | today | proposed | why (source)`.
4. **Findings**: grouped by thread. Each finding: claim, number or quote, source, confidence badge.
5. **Observation -> rule**: table that turns findings into rules for this project.
6. **Verified / Hypothesis**: two lists, side by side.
7. **To decide**: numbered questions, default answer in brackets, for example "1. Launch in DE first? (yes, largest volume, weakest competitors)".
8. **Method**: sources, dates read, search budget used, what was not checked.
9. **Sources**: URL, date read, rank (1-5).

Rules:
- Escape all dynamic text. Never paste keys or internal URLs; replace them with `<REDACTED>`.
- Dates are absolute (2026-10-29), never "last week".
- Support light and dark mode with CSS variables.
