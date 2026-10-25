# 3rd Grade Learning System

**نظام التعلّم للصف الثالث**

A bilingual (Arabic and English) study notebook for a Grade 3 child, organised by school subject. A parent adds the school's weekly plan and photos of lesson pages. Claude turns them into lessons the child can listen to, picture guides, practice sheets and games. When the child makes a mistake, they explain it the way a private tutor would. The child opens the notebook on a tablet, with no account needed.

دفتر دراسة ثنائي اللغة لطالب الصف الثالث، مرتّب حسب المواد. يرفع ولي الأمر الخطة الأسبوعية وصور صفحات الدروس، فيحوّلها Claude إلى:

- قراءة مسموعة.
- شرح مصوّر.
- أوراق تدريب.
- ألعاب تشرح الخطأ كما يشرحه المعلّم الخصوصي.

ويفتحه الطالب على الآيباد من المتصفح بلا حساب.

## What it does

- **Weekly plan → lesson tables.** The school's weekly plan, as photos or a PDF, becomes one table per subject: math, science, English, Arabic, Islamic studies and computer. Each table lists periods, lessons, pages, homework and assessments. Older lessons can be added without a plan.
- **Lesson photos → study kit.** For each lesson, Claude makes the parts that suit its subject:
  - **Math:** a picture guide, a practice sheet and a game.
  - **English reading:** read-aloud text with the yellow vocabulary, a lesson map, a sheet and a game.
  - **Grammar and phonics:** a rule card, a picture guide, a sheet and a game.
  - **Other subjects:** a lesson map, a sheet and a game.
- **Tutor explanations.** Every question carries:
  - a hint;
  - the reason a wrong answer is wrong;
  - an explanation, with a picture where it helps.

  The first slip gets a nudge, and the second shows the answer with its explanation. Missed questions come back in a fix-it round.
- **Picture guides.** Instead of long text, ideas are drawn as diagrams: dot arrays, groups, number lines, split arrays, fact families, bar models, fractions, place value, coloured sentence parts, word changes, rule formulas, right-or-wrong comparisons, sorting, letter tiles with silent letters, and word families.
- **Dictation trainer.** English and Arabic dictation lists, practised step by step. Each word grows in a word garden as it is learned.
- **Times tables trainer.** Only the tables taught so far, practised in five ways: learn, skip-count jumps, smart practice, memory match and a one-minute race.
- **English library.** Every reading, grammar and phonics lesson in one place.
- **Reading voice.** The notebook picks the most natural voice on the device, and the child can choose another one.
- **Student copy.** The child opens the same link without an account and sees a read-only copy of the lessons. Their progress is saved on their own device.
- **Arabic / English interface** with one switch.

Full details: [docs/features.md](docs/features.md).

## How it runs

The whole app is **one HTML file**: [app/learning-system.html](app/learning-system.html).

| Where it is opened | What works |
|---|---|
| As a **Claude artifact**, by the parent signed in to claude.ai | Everything: saved data, photo uploads, and Claude making the activities |
| The same artifact link, opened by the child (no account) | The student copy: lessons, games, sheets and trainers, read-only; progress saved in the browser |
| Any other web host, or opened from disk | The embedded copy only: a read-only demo, which GitHub Pages serves through `.github/workflows/pages.yml` |

How the page is built, and how its modes work: [docs/architecture.md](docs/architecture.md). Plans for hosting it as a normal website: [docs/hosting.md](docs/hosting.md).

## Repository layout

```
app/learning-system.html     the app (one self-contained page, with the sample data embedded)
data/sample/snapshot.json    sample lessons and activities (no personal data, no textbook text)
data/README.md               the data model
docs/                        features, architecture, hosting plan, changelog
scripts/embed-snapshot.ps1   puts a snapshot of lessons into the app page
scripts/run-tests.ps1        runs the browser tests in headless Edge or Chrome
tests/                       one test page per feature
private/                     never committed: personal data exports and personal builds (git-ignored)
```

## Quick start

1. **Try the demo.** Open `app/learning-system.html` in a browser. It runs on the sample data in read-only mode.
2. **Use it for a child.** Ask Claude (in Claude Code or on claude.ai) to publish `app/learning-system.html` as an artifact with these capabilities: `db`, `user`, `assets`, `sample` (with images), `downloads` and `artifact`. Then, on the page:
   1. Press **Edit** on the cover label to enter the child's name.
   2. Add the school platform link.
   3. Upload the weekly plan.
   4. Add lesson photos.
   5. Press **Update the student's version** to refresh the child's copy.
3. **Run the tests** (Windows PowerShell 5.1 or PowerShell 7, with Edge or Chrome installed):
   ```
   ./scripts/run-tests.ps1
   ```

## Data and privacy

- This repository holds **no child's data**. The sample data was written for the project and contains no text from school books.
- Lesson photos stay in the artifact's private file storage. They are never written to the repository.
- `private/` is git-ignored. Use it for your own backups and personal builds.
- Activities are generated from photos of school books, for a family's own study. Do not publish activities made from copyrighted books.

## Status

Version 16. It is in daily use by one family as a Claude artifact. Next steps are in [docs/hosting.md](docs/hosting.md), and the version history is in [docs/changelog.md](docs/changelog.md).

The Arabic interface text currently speaks to a girl. The student profile can tell Claude to address a boy, but switching the interface text itself is still to do.

## License

Not chosen yet. All rights reserved until a license is added.
