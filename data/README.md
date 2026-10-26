# Data model

The app stores everything in the Claude artifact database: collections of JSON documents. The same shapes are used in the **snapshot**, the read-only copy embedded in the page (see the end of this file).

## `settings/main`

| Field | Meaning |
|---|---|
| `nexUrl` | Link to the school platform, shown on the cover |
| `tables` | Times tables taught so far, e.g. `[0,1,2,3,4,5,10]`. The trainer shows only these |
| `student` | `{ ar, en, gender: "f"\|"m", year }`: the name in Arabic and English, how Claude should address the child, and the school year |

## `weeks/*`: weekly plans

`{ weekOf: "YYYY-MM-DD", title, notes: { math, science, english, arabic, islamic, computer }, reminders: [], files: [{id,type,name}], createdAt }`

## `lessons/*`: one row in a subject's table

| Field | Meaning |
|---|---|
| `week` | The `weeks` id, or `""` for an older lesson added without a plan |
| `weekOf`, `subject`, `order`, `period` | Where the row sits, e.g. `period: "الحصتان 1–2"` |
| `title`, `pages` | Lesson title and book pages |
| `homework` | Homework text |
| `assess`, `assessType` | An assessment: `إملاء` (dictation), `تقييم` (assessment) or `مشروع` (project). For dictation, `assess` holds comma-separated English words, or the Arabic sentence |
| `etype` | English lessons only: `reading`, `grammar`, `phonics`, `writing` or `other`. If missing, it is guessed from the title |
| `reading` | `false` turns off the reading for an English lesson |

## `items/*`: everything attached to a subject or lesson

Common fields: `kind`, `subject`, `lesson` (the lessons id), `title`, `lang` (`ar`/`en`), `createdAt`, `source` (the photo item it was made from), and `example: true` for sample content.

| `kind` | Extra fields |
|---|---|
| `photo` | `files: [{id, type, name}]`: lesson photos in the artifact's file storage (never in the snapshot) |
| `file`, `link` | School files (`files`) or a link (`url`) |
| `reading` | `paragraphs[]` (a simple retelling, not the book's text), `highlighted`, `vocab[{w, base, pos, meaning, ar, from, examples[2], hl?, forms?, cues?}]`. `hl: "orange"` shows the word in orange (default yellow); `forms` are extra accepted forms (irregular or related words); `cues` are everyday words that show the meaning in her own sentence |
| `outline` | Lesson map: `summary`, `branches[{title, points[]}]`, `words[{w,m}]`, `remember[]` |
| `grammar` | Rule card: `rule`, `points[]`, `examples[{s, ok, note}]`, `tips[]`, `words[{w,m}]` |
| `phonics` | `rules[{pattern, rule, words[]}]`, `words[{w, m, ar}]`, `tips[]` |
| `visual` | Picture guide: `intro`, `cards[{type, label, …}]`; the card types are listed in [docs/features.md](../docs/features.md#picture-guides) |
| `game` | `rounds[]` (see the question types below) |
| `sheet` | `intro`, `sections[{title, items[]}]` |

### Questions (game rounds and sheet items)

| `type` | Fields |
|---|---|
| `choice` | `q`, `choices[]`, `answer` (copied exactly from `choices`) |
| `tf` | `q`, `answer: true\|false` |
| `type` | `q`, `answer`: alternatives separated by `\|`. If the answer contains commas, the commas are checked too |
| `match` | `q`, `pairs[[left, right]]` (games only) |

Tutor help, optional on every question:
- `hint`: a nudge that doesn't give the answer away;
- `why`: the explanation;
- `wrong: { "<wrong answer>": "why it is wrong" }`;
- `pic`: one picture-guide card.

## `results/*`: progress

- `results/<gameId>`: `{ best, lastScore, lastTotal, plays, at }`.
- `results/dict-<lessonId>`: `{ words: { word: { box 0–3, n } }, best }`. This is the dictation word garden.
- `results/tt`: `{ facts: { "4x6": { box 0–3, n } }, speed }`. This is the times tables trainer; box 3 means the fact is mastered.

On the student copy, progress is not written to the database. It stays in the browser, in `localStorage["nay-progress"]`. The storage keys keep their original names (`nay-progress`, `nay-ui`, `nay-voice`) so the first family's saved progress is not lost.

## The snapshot

The snapshot is the read-only copy embedded in `<script type="application/json" id="snap">`:

```json
{ "v": 1, "at": "ISO date", "nexUrl": "", "tables": [0,1,2,3,4,5,10], "student": null,
  "weeks": [ … ], "lessons": [ … ], "items": [ … ] }
```

Items of kind `photo`, `file` and `link` are left out, as is every `files` field: the student copy carries no school files or photos. [sample/snapshot.json](sample/snapshot.json) is an example. To put a snapshot into the page, run `scripts/embed-snapshot.ps1`.
