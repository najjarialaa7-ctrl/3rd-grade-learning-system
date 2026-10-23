# Hosting plan

Today the system runs as a **Claude artifact**: the parent works in it signed in to claude.ai, and the child opens the same link with no account. Sharing it with other families raises two problems:

- every family needs its own data;
- the features that need Claude must keep working outside claude.ai.

## What the app needs from a host
The app only talks to the host through `window.claude.use(name)`. So a host must provide the same six capabilities ([architecture.md](architecture.md#runtime-capabilities)):

| Capability | On claude.ai | On our own hosting |
|---|---|---|
| `db` | Artifact database | A real database with per-family data, e.g. Supabase (Postgres with row-level security) or Firebase |
| `user` | Claude account | Parent accounts (email or Google sign-in), plus a child link or PIN that can only read |
| `assets` | Artifact file storage | Private object storage (Supabase Storage, S3, R2). Lesson photos must never be public |
| `sample` | Claude, billed to the signed-in user | A small server function that calls the Claude API with our key. It needs a limit per family, because every call costs money |
| `downloads` | Host download | An ordinary browser download |
| `artifact` (publish the student copy) | Republish the page | Not needed: the child signs in with a read-only link instead |

## Recommended path

### Phase 1: public demo (ready)
Serve `app/learning-system.html` on **GitHub Pages**. With no runtime, it runs on the embedded sample data in read-only mode: the games, sheets, picture guides and trainers all work. A yellow label on the cover says it is a demo and links to this guide. The label appears because the sample snapshot carries `"demo": {"url": …}`. This lets other families try it.

The workflow `.github/workflows/pages.yml` copies the app to the site's `index.html` and deploys it whenever `app/` changes on `main`. The job is skipped while the repository is private, because GitHub Pages needs a **public** repository on the free plan, or a paid GitHub plan.

To switch it on:
1. Make the repository public.
2. Open **Settings → Pages → Build and deployment → Source: GitHub Actions**, or run `gh api -X POST repos/OWNER/REPO/pages -f build_type=workflow`.
3. Run the workflow (**Actions → Deploy the demo to GitHub Pages → Run workflow**), or push a change to `app/`.

The demo is then at `https://OWNER.github.io/REPO/`.

### Phase 2: a `window.claude` adapter
Write a small script, `app/host-adapter.js`, that defines `window.claude.use()` with the same interface, backed by the chosen database, storage and Claude endpoint. The page itself barely changes: the same file then runs both as a Claude artifact and on our own site. This is the main engineering step.

### Phase 3: families
- Sign-up for parents.
- One notebook per child, with a profile (name and gender). This needs the Arabic interface strings for a boy.
- An invite link for the child.
- Usage limits for Claude calls.
- A privacy policy.

## Things to settle before going public
- **Children's data:** names, school, progress and photos of school books. A host must keep them private, and must follow the data-protection law of the families' country (for example Saudi Arabia's PDPL, or COPPA for US users).
- **Textbook copyright:** activities are made from photos of publishers' books for a family's own study. The service should never show one family's photos or activities to another.
- **Cost:** making activities calls Claude for every lesson. Either families bring their own Claude account, as today, or the service pays and charges a subscription.
- **License:** choose one before the repository becomes public.
