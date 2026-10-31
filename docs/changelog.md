# Changelog

The version number shows in the page footer («نسخة الدفتر N»).

## 23 (2026-10-31)
- **More than one sheet or game per lesson.** The lesson row and the star card show a numbered button for each («ورقة 1», «ورقة 2»), oldest first. Before, only the newest one could be opened.
- **Word box on sheets.** A sheet can carry `bank`, the list of words to choose from, shown at the top like the box on a workbook page (and on the printable copy). Tapping a word reads it aloud. Sheets made from photos copy the page's word box when there is one.

## 22 (2026-10-27)
- **Today's stars.** The parent stars a lesson (from its row) or a times table (from the trainer). It shows at the top of the first page with a button for each of its activities, so the student starts there; the lesson stays in its table with a star on its row. The student can tick a star as finished on her device, and the parent removes the star when it is done. Stars are saved in `settings.stars` and go into the student's copy.
- **A clear way back.** «All subjects» is now its own button outside the coloured header, and it stays on screen while scrolling.
- **Reminders, one line per subject.** Each line starts with the subject's name and colour, in the subjects' order. A reminder that mixes subjects is split. Weekly plans are now asked for one reminder per subject.
- `embed-snapshot.ps1` no longer rejects a snapshot whose keys differ only in case (Windows PowerShell's `ConvertFrom-Json` did).

## 21 (2026-10-26)
- **The student's own sentence is checked on the device.** Before, the «Check my sentence» button needed Claude, so the student's copy (signed out) never checked anything. Now the page checks it by itself, in any tense or form of the word ("voyages", "tossed", "lit the lamp", "cheered her up"). It points out a missing word, a misspelling, a sentence that is too short, a copied example or a missing verb. It also fixes small things (capital letter, "I", a/an, the full stop), says whether the sentence shows the meaning, and repeats the meaning in English and Arabic. When Claude is in the page, Claude also checks the meaning and is told that any form of the word is fine. Enter checks the sentence too.
- **Orange words.** A vocabulary word can be marked orange (`hl: "orange"`). It is highlighted in orange in the reading and the examples, and the word list shows yellow words and orange words in two groups. Readings made from photos also list words highlighted in orange in the book.
- Vocabulary words can carry extra `forms` (irregular or related forms) and `cues` (everyday words that show the meaning). Reading prompts ask Claude for both.
- The word game takes a fresh set of 8 words each time, so long word lists still get every kind of round.
- `run-tests.ps1 -Only <name>` runs one test.

## 20 (2026-10-25)
- **A calmer first page.** The week box no longer lists what every subject covers, and the subject tiles show only the icon and the name. Each subject's week note shows inside its page. The week's reminders stay on the first page.

## 19 (2026-10-25)
- **No card shelves on subject pages.** Maps, games, practice sheets and readings now open only from the lesson tables (this week and older lessons), which keeps the page calm for the student. A shelf appears only for something not linked to any lesson, so nothing becomes unreachable; school files show only when there are some.

## 18 (2026-10-25)
- **Older lessons in one table.** Past weeks and lessons added without a plan now sit in one table per subject, newest first, with the explanation, map, sheet and game, instead of a separate table plus a folding group per week. English is split into reading, grammar, and phonics with dictation.

## 17 (2026-10-25)
- **PDF weekly plans are read automatically.** The pages are drawn to images in the browser (pdf.js, loaded only when needed) and read by Claude like photos. Before this, a PDF plan was stored but not read.
- The cover's reading-voice button icon is sized correctly on phones.

## 16 (2026-10-23)
- **Student profile.** The child's name, the address form (girl or boy) and the school year are now a setting (`settings.student`), edited from the cover label. They used to be written into the code. The page title, the cover, the praise and Claude's prompts all use the profile.
- The project is packaged as **3rd Grade Learning System**, with sample data, documentation and browser tests.
- A demo label on the cover when the page runs on sample data, and a GitHub Pages workflow for the public demo.

## 15 (2026-10-23)
- **Reading voice.** Voices are ranked so that natural ones come first, and novelty voices are never used. A picker on the cover and in the reading screen previews each voice and saves the choice and speed per device.

## 14 (2026-10-22)
- **Times tables trainer** at the top of the Math page, for the tables taught so far: learn, skip-count jumps, smart practice, memory match and a one-minute race.

## 13 (2026-10-22)
- **Tutor explanations** in games and sheets: a hint, the reason a wrong answer is wrong, the explanation with a picture, and a fix-it round.
- Typed answers that contain commas are checked with their commas.

## 12 (2026-10-19)
- **Picture guides** for math, grammar and phonics: 16 diagram types drawn by the page.

## 11 (2026-10-18)
- **English library** (reading, grammar, phonics), and lesson types for English lessons.

## 1–10 (2026-10-17 to 2026-10-18)
- The notebook by subject, with the school platform link.
- The weekly plan is read into per-subject lesson tables.
- Games, practice sheets and lesson maps are made from lesson photos.
- English reading aloud with the yellow vocabulary; no reading for grammar lessons.
- The dictation trainer (English and Arabic) with the word garden.
- The Arabic / English interface switch.
- Older lessons without a plan.
- Activities are rebuilt from all of a lesson's photos.
- The student copy for a tablet with no account.
