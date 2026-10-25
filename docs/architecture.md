# Architecture

## One self-contained page
`app/learning-system.html` holds everything, in this order:

1. The `<title>`, meta tags and Google Fonts links (Andika, Baloo Bhaijaan 2, IBM Plex Sans Arabic).
2. `<style id="css">`: all styles. Colours are CSS variables on `:root`, with a dark theme.
3. The markup skeleton: cover, week, `#view`, `#overlay` (full-screen players), `#modal`, `#toast`.
4. `<script type="application/json" id="snap">`: the **snapshot** (see [data/README.md](../data/README.md#the-snapshot)).
5. `<script id="appjs">`: the app, one IIFE in plain JavaScript, with no build step and no libraries.

There is no build step. The file is edited directly and published as it is.

## Runtime capabilities
Inside a Claude artifact, the page asks the host for capabilities through `window.claude.use(name)`:

| Capability | Used for |
|---|---|
| `db` | All data (`settings`, `weeks`, `lessons`, `items`, `results`), with live `onSnapshot` updates |
| `user` | Whether the viewer may write data (`can('data.write')`) and edit the page (`canEdit()`) |
| `assets` | Lesson photos and school files (`blobUrl` for viewing) |
| `sample` | Claude: `sample.json(prompt, {images})` reads photos and returns JSON; `limits()` gives the image limit |
| `downloads` | Printable copies of sheets and lesson maps |
| `artifact` | `publish(html)`: the page republishes itself to refresh the student copy |

## Modes
The page starts the same way every time. `loadSnap()` renders the embedded snapshot at once, then the page asks for the capabilities.

- **No `window.claude`** (a static host, or a file opened from disk): `S.noDb`, `S.student`. The page stays on the snapshot, with no editing.
- **Claude, signed out** (the child): `use('db')` gives nothing, so the result is the same student copy. Progress goes to `localStorage`.
- **Claude, signed in** (the parent): the database replaces the snapshot. Editing, uploads and Make buttons appear according to `user.can` and `sample`.

## Refreshing the student copy
`buildSnap()` collects the weeks, the lessons, every item that is not a photo or file (without its `files`), the tables and the profile. `pageSource(snap)` rebuilds the full HTML from the constants `HEAD_HTML` and `BODY_HTML`, plus the live text of `#css` and `#appjs`. `artifact.publish()` then publishes it.

**Keep `HEAD_HTML` and `BODY_HTML` in step with the file's real head and markup** whenever either one changes.

`snapStale()` compares the published snapshot with the current data. When they differ, the cover button shows a dot.

## Making activities with Claude
- `makeForLesson(lessonId, kinds, photos)` and `runMake(...)` send the lesson photos with one prompt per kind:
  - `PROMPTS[kind](subject, context, n)`. All of these start from `lessonContext()`, which carries the student, the lesson title, the pages and the parent's note.
  - `helpRules()` adds the tutor fields to game and sheet prompts.
  - `visualPrompt()` lists the allowed diagram types for the subject.
- Each reply goes through `NORMS[kind]`, which checks the shape and clamps every field:
  - `normRound()` and `normHelp()` for questions;
  - `normCard()` for diagrams;
  - `normalizeReading()`, `normalizeOutline()` and others.

  Anything malformed is dropped rather than shown.
- `kindsFor(lesson)` decides which kinds a lesson gets (see [features.md](features.md)).
- `extractWeek()` reads a weekly plan: photos are sent as they are, and each PDF page is first drawn to a JPEG with pdf.js (`planImages()`, `pdfToImages()`). pdf.js is loaded from cdnjs only when a PDF needs reading.

## Interface language
- `UI` is `'ar'` or `'en'` and is saved in `localStorage["nay-ui"]`. Every interface string goes through `tx(ar, en)`.
- Activity content uses its own language: the `T[lang]` strings and the `dir` on its container.
- Inside Arabic text, equations are wrapped in the bidi isolates LRI/PDI (`E()`), so they stay left to right.

## Speech
- `speak(list, opt)` reads one sentence at a time through `speechSynthesis`. It has a watchdog for phones whose speech engine stalls.
- `voicesFor(lang)` ranks the device's voices (`voiceScore`); `pickVoice` uses the saved choice in `localStorage["nay-voice"]`, or the best-ranked voice.

## Student profile
`kid()` reads `settings.student`. `bookTitle()`, `copyName()`, `praise()`, `forKidAr()`, `kidEn()` and `kidAbout()` put the name into the title, the cover, the praise and the prompts. The Arabic interface strings are written to a girl.

## Tests
The tests in `tests/` run the real page in headless Edge with a fake Claude runtime and a fake speech engine (`tests/_harness.js`). They also run in a mode with no runtime at all. `scripts/run-tests.ps1` runs them all; [tests/README.md](../tests/README.md) explains how.
