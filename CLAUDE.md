# Developer Profile — Wouter

## Skill Levels (calibrate verbosity)

| Level | Stack | Implication |
|-------|-------|-------------|
| **Expert** | C#, .NET, TypeScript, React, Angular, Node.js, SQL, Git, Design Patterns, Architecture, Docker, ORMs, REST | Terse. Just code. No explanations unless I ask. |
| **Proficient** | Python, Ruby, PowerShell, RxJS, MongoDB, Vue, Redis, CI/CD, GraphQL, NServiceBus/Message Queues | Concise. Explain only non-obvious things. |
| **Learning** | Tailwind CSS, Kubernetes, Cloud (AWS/Azure), Terraform/IaC, Linux admin, Bash | Explain concepts briefly, show examples. |
| **Avoid** | PHP, raw JavaScript (use TypeScript instead) | Steer away. Suggest alternatives. |

When I'm in expert territory, skip the preamble and give me the answer. Don't explain what a record type is. Don't explain async/await. Don't tell me how dependency injection works.

## Communication

- Direct and terse. No filler, no "Great question!", no "Let me help you with that."
- No emoji unless I ask.
- When showing code changes, show just the change — not the entire file.
- If something is a one-liner, say so in one line.

## Universal Coding Rules

- **TDD.** Write failing test first, then make it pass. Always.
- **Test coverage is mandatory.** Touching code without tests? Add tests — even for legacy code.
- **No comment spam.** Comments explain WHY, never WHAT. No docstrings on obvious methods.
- **KISS / YAGNI.** Only build what was asked for. A bug fix is just a bug fix.
- **Don't "improve" surrounding code** unless asked.
- **Prefer editing existing files** over creating new ones.
- **No empty scaffolding.** Don't create files with TODO placeholders or stub implementations.

## Workflow

- Run tests after changes. They must pass.
- Don't commit, push, or add dependencies without me asking.
- When a project has linters/analyzers configured, respect them — zero warnings.

## Commit Hygiene

- **One concern per commit.** Each commit addresses a single logical change — don't mix a bug fix with a refactor or formatting cleanup.
- **Short imperative subject line, max 72 chars.** Describe what changed and why. No period at the end.
- **Add a body when the "why" isn't obvious** from the diff — blank line after subject, then explain context.
- **No noise in commits:**
  - No `console.log`, `debugger`, commented-out code, or TODO leftovers.
  - No formatting-only changes mixed into feature commits.
  - No generated/empty files (empty `.spec`, empty `.scss`, etc.).
  - No local config, credentials, or machine-specific settings.
- **Stage deliberately.** Only stage files relevant to the commit — don't `git add -A` blindly.
- **Review before committing.** Mentally `git diff --staged` — verify every hunk belongs.
- **No `Co-Authored-By` trailers.** Never add co-author attribution lines.

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

## Self-Improving Config

- When I allow/deny a command, suggest adding a general allow/deny rule to `~/.claude/settings.json` so the preference persists across sessions.
- When I guide you down a particular path or request a general change, suggest adding it to `~/.claude/CLAUDE.md` where applicable.

## Per-Project Instructions

Project-specific CLAUDE.md files override anything here. Defer to them for architecture, naming, tech stack, and build commands.
