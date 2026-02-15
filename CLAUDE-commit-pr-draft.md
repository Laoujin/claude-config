## Commit Hygiene

- **One concern per commit.** Each commit addresses a single logical change — don't mix a bug fix with a refactor or formatting cleanup.
- **Message format:** `<type>: <what changed and why>` — e.g. `fix: prevent null ref in deploy hook resolution`. No period at the end.
  - Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `build`, `ci`
- **Prefix with ticket ID** when a ticket/issue exists — e.g. `fix(#42): prevent null ref in deploy hook resolution`.
- **Subject line max 72 chars.** Add a blank line + body for context when the "why" isn't obvious from the diff.
- **No noise in commits:**
  - No `console.log`, `debugger`, commented-out code, or TODO leftovers.
  - No formatting-only changes mixed into feature commits.
  - No generated/empty files (empty `.spec`, empty `.scss`, etc.).
  - No local config, credentials, or machine-specific settings.
- **Stage deliberately.** Only stage files relevant to the commit — don't `git add -A` blindly.
- **Review before committing.** Mentally `git diff --staged` — verify every hunk belongs.
- **Drop the `Co-Authored-By` trailer.** Do not add co-author attribution lines.

## Pull Request Hygiene

- **Small, reviewable PRs.** One feature or fix per PR. If a PR touches 20+ files, consider splitting.
- **Title:** short imperative summary, max 72 chars — e.g. `Add symlink conflict detection`.
- **Body format:**
  ```
  ## Summary
  <2-4 bullet points: what changed and why>

  ## Test Plan
  - [ ] Relevant checklist items for verifying the change
  ```
- **Link issues** — use `Closes #N` / `Fixes #N` in the body when applicable.
- **No junk in the diff:**
  - No unrelated formatting, import reordering, or whitespace changes.
  - No leftover debug artifacts or unused dependencies.
  - Review "Files changed" before submitting — if something doesn't belong, drop it.
- **No promotional footers or tool attribution** in PR descriptions.
