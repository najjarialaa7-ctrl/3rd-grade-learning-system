# Tests

Each `*.test.html` file checks one feature of the real page. To run them all:

```
./scripts/run-tests.ps1
```

The runner puts four things together into one page: `_harness.js`, the sample snapshot (`window.__SAMPLE`), the test file, and `app/learning-system.html`. It opens that page in headless Edge (or Chrome) with virtual time, so timers such as the one-minute race finish at once, and reads the `data-result` attribute the test leaves on `<html>`: `PASS`, or `FAIL:` followed by the reasons. Any JavaScript error counts as a failure.

`_harness.js` provides:
- `fakeClaude(snapshot, {settings, publish})`: an in-memory database and a signed-in parent. Writes are recorded in `window.__writes`. If no fake runtime is set up, the page runs as the student copy;
- a fake speech engine: the voices come from `window.__voices`, and what was said is in `window.__said`;
- `T_.ok(condition, message)`, `$q`, `$qa`, `$txt`, `wait(ms)` and `runTest(async () => { … })`.

| Test | Checks |
|---|---|
| `picture-guide` | Every diagram type draws, for math and English, and the library shows the cards |
| `tutor` | The nudge, then the explanation with its picture, the fix-it round, the sheet's two checks, and the Arabic reasons |
| `times-tables` | All five trainer modes, editing the tables, and saving progress |
| `voice` (`#ios`, `#win`, `#edge`) | How voices are ranked, that novelty voices are hidden, the preview, and the saved choice and speed |
| `profile` (`#named`, plain) | The name on the cover and in the praise, editing it, and the page with no name |
| `student-copy` | The page with no runtime: the snapshot data, no editing controls, and progress kept in the browser |
| `student-copy-publish` | The page rebuilds itself with a full snapshot |
| `weekly-plan-pdf` | A PDF plan is drawn to page images and read; the notes and lesson rows are saved (needs the internet for pdf.js) |
| `older-lessons` | Past lessons sit in one table per subject, newest first; English is split into reading, grammar, and phonics with dictation |
| `sentence-check` | Her own sentence is checked with no Claude: any form of the word counts, each kind of slip gets its hint, small fixes; orange and yellow words |
| `stars` (plain, `#student`) | The parent stars and unstars lessons and tables; the cards at the top open each activity; the student's ticks; the back button; reminders one line per subject |
| `extra-sheet` | Two sheets in one lesson get numbered buttons (row and star card); the word box shows and reads words; wrong-answer reasons and fixing to full marks |

To run one test: `./scripts/run-tests.ps1 -Only sentence`.
