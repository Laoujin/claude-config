# TODO — ~/.claude config repo

## Commit Hygiene section (CLAUDE.md)
- [ ] Decide on commit message convention: Conventional Commits (`feat:`, `fix:`) vs freeform
- [ ] Decide on ticket prefix format: `#42` (GitHub) vs `PROJ-42` (Jira) vs none
- [ ] Review and merge `CLAUDE-commit-pr-draft.md` into `CLAUDE.md`
- [ ] Delete `CLAUDE-commit-pr-draft.md` after merge

## PR Hygiene section (CLAUDE.md)
- [ ] Review PR body template (Summary + Test Plan) — adjust if needed
- [ ] Decide on file-count threshold for "consider splitting" (currently 20+)

## Project Scaffolding Skill
- [ ] Create a `/scaffold` or `/init-project` skill that bootstraps new projects
- [ ] Evaluate approach: Claude Code skill vs GitHub template repos vs both
- [ ] Templates needed:
  - [ ] .NET WebAPI (with .editorconfig, analyzers, NUnit, CI workflow)
  - [ ] React + TypeScript (Vite? Next.js?)
  - [ ] TypeScript library/CLI (Node)
  - [ ] Angular (if still used)
- [ ] Common files every template should include:
  - [ ] `.editorconfig` (copy from `dotnet.editorconfig` or a universal one)
  - [ ] `.gitignore` (language-appropriate)
  - [ ] `CLAUDE.md` (project-specific skeleton)
  - [ ] CI workflow (GitHub Actions)
  - [ ] Linter/formatter config
- [ ] GitHub template repos: create org-level templates at github.com/itenium-be?

## Other
- [ ] Review `memory/` — decide what to track vs gitignore
- [ ] Audit `settings.json` deny rules — are all sensitive patterns covered?
- [ ] Clean up `claude-investigate.md` — is it still relevant?
