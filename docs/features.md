# Features

## Cover and student profile
- The cover shows the notebook's title, the name label (name, grade, school year) and the school platform link. Below it, the week box shows the week's title, reminders and earlier plan files, and each subject appears as a tile with only its icon and name; what the subject covers this week is inside its page. It also has the language switch and the **reading voice** button.
- The parent presses **Edit** on the label to set the child's name in Arabic and English, whether Claude should address a girl or a boy, and the school year. Without a name, the title reads «نظام التعلّم للصف الثالث» / *3rd Grade Learning System*.

## Weekly plan and lesson tables
- Each subject page shows only: this week's note, this week's lesson table, and the older-lessons table (plus the times-tables banner in math and the library tiles in English). Every map, game, sheet and reading opens from its lesson row; a separate shelf appears only for an activity or photo that is not linked to any lesson.
- The school's weekly plan, as photos or a PDF, is read by Claude (a PDF's pages are first drawn to images in the browser with pdf.js) into a short note per subject, the week's reminders, and a lesson table per subject: period, lesson, pages, homework, assessment.
- Each lesson row has columns for its photos, its explanation (English: reading, rule card or phonics card), its map or picture guide, its practice sheet and its game. When a part is missing, the row offers a «اصنع» (Make) button.
- **Older lessons:** every lesson that is not in this week's plan (past weeks, and lessons added without a plan with `week: ""`) sits in one table per subject, newest week first, with only what helps revision: the explanation or picture guide, the map, the sheet and the game. English is split into three sections: reading, grammar, and phonics with dictation (any lesson with a dictation goes there). Rows can be edited and deleted.
- When new photos are added to a lesson that already has activities, everything is rebuilt from all of the photos. A row whose photos are newer than its activities shows «تحديث من كل الصور» (update from all photos).

## What Claude makes from lesson photos
The parts depend on the subject and, for English, on the lesson type:

| Lesson | Made from the photos |
|---|---|
| Math | Picture guide, practice sheet, game |
| English reading | Read-aloud text with the yellow vocabulary, lesson map, sheet, game |
| English grammar | Rule card, picture guide, sheet, game |
| English phonics | Phonics card (spelling patterns, words with meanings), picture guide, sheet, game |
| Other subjects | Lesson map, sheet, game |

Every prompt tells Claude to use **only what the pages show**, to write short sentences for an 8-year-old in the lesson's language, and, in Islamic studies and Arabic, to quote a verse or hadith only exactly as it appears in the photos. The read-aloud text is a simple retelling in Claude's own words, not a copy of the book.

## Tutor explanations (games and sheets)
- Every question carries a `hint`, a `why`, a reason for each likely wrong answer (`wrong`), and, where it helps, a picture.
- **Games:**
  - The first slip shows «اقتربتِ! فكّري مرة أخرى» with the reason, and the wrong choice is disabled.
  - The second slip shows the answer, the explanation and the picture.
  - After the last round, the missed rounds come back once in a **fix-it round**.
  - The score counts first tries only.
- **Sheets:**
  - A 💡 hint button sits next to each question.
  - The first check nudges, and the question stays open to fix.
  - The second check shows the answer and why.
  - Blank answers don't use up a try. The printable copy's answer key includes the explanations.

## Picture guides
Claude chooses the diagram types and fills in their data; the page draws them and computes the equations itself.

- **Math:** `array` (dots in rows), `groups` (equal groups of apples, stars…), `numberline` (jumps), `split` (distributive property), `factfamily`, `bar` (bar model), `fraction`, `placevalue` (blocks)
- **Grammar:** `sentence` (coloured parts of speech), `change` (word changes), `formula` (the rule as blocks), `compare` (right and wrong), `sort`
- **Phonics:** `tiles` (silent letters drawn as ghost tiles), `family` (a spelling pattern and its words), `sort`, `change`, `compare`
- **Any subject:** `steps`

## English library
Three tiles under the English table open every reading lesson (texts and vocabulary), every grammar rule with its practice, and every phonics card with its words and dictation lists. The lessons come from this week, older lessons and past weeks.

## Reading aloud and vocabulary
- English reading lessons can be heard sentence by sentence, at normal or slow speed. The sentence being read is highlighted.
- Words highlighted in yellow in the book appear in yellow. Tapping one opens its card: meaning, Arabic meaning, the sentence from the lesson and two examples. The child can also write her own sentence and get feedback from Claude, but only when signed in.
- A vocabulary game is built from the words: match, fill the blank, and listen and write.

## Dictation trainer
- It is built automatically for any lesson whose assessment is a dictation.
- **English steps:**
  1. Meet the words, with silent letters shown as ghosts.
  2. Ghost hunt.
  3. Look, cover, write.
  4. Letter tiles.
  5. The test, on paper or typed.
- **Arabic steps:**
  1. The sentence, with each word's spelling rule (sun and moon letters, tanween, shadda, taa marbuta, alif maqsura, hamza).
  2. Pick the right spelling.
  3. Word tiles.
  4. Look, cover, write.
  5. The test.
- Each word grows into a flower after it is spelled right three times.

## Times tables trainer
- A banner at the top of the Math page opens the trainer. It covers only the tables taught so far, which the parent lists with **Edit the tables**.
- **Learn a table:**
  - every fact from ×0 to ×10, with a dot picture and how to find it (for example: «ضِعف 6 هو 12، وضِعف 12 هو 24»);
  - hear the whole table read aloud;
  - hide the answers to test yourself.
- **Skip-count jumps:** the number line grows one jump at a time.
- **Smart practice:**
  - 12 questions on a big keypad, weakest facts first, some with a missing factor;
  - a slip gets the table's rule; a second slip shows the answer, how to find it and its picture, and the fact comes back three questions later.
- **Memory match:** six pairs, each a fact and its answer.
- **One-minute race:** the best score is kept.
- A fact counts as mastered after three right answers. Each table shows how many of its 11 facts are mastered.

## Student copy
- The child opens the same link without a Claude account and sees the lessons, readings, maps, sheets, games and trainers from the last time the parent pressed **Update the student's version**.
- School files and lesson photos are not included.
- Progress (game scores, the word garden, the times-tables boxes) is saved in the child's browser.

## Language and voice
- One switch flips the whole interface between Arabic (right to left) and English. Lesson content keeps its own language.
- **Reading voice:** the page ranks the device's voices. Premium, Enhanced and Natural voices come first, then gentle female voices; Apple's novelty voices are never used. The picker plays a short sample of each voice and saves the choice and the speed on that device. When the device has only robotic voices, it suggests how to get better ones: download Ava or Zoe (Premium) on an iPad, or open the link in Microsoft Edge on Windows.
