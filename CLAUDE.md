# Developer Profile — Wouter

## Skill Levels
| Level | Stack |
|-------|-------|
| **Expert** | C#, .NET, TypeScript, React, Angular, Node.js, SQL, Git, Design Patterns, Architecture, Docker, ORMs, REST |
| **Proficient** | Python, Ruby, PowerShell, RxJS, MongoDB, Vue, Redis, CI/CD, GraphQL, NServiceBus |
| **Learning** | Tailwind, Kubernetes, AWS/Azure, Terraform, Linux, Bash |
| **Avoid** | raw JS (PHP: avoid writing, but OK to *run* off-the-shelf self-hosted tools) |

Expert = terse, just code. Proficient = concise. Learning = brief explanations.

## Communication
Direct/terse. No filler. Show only changed code, not entire files.
Markdown tables: pad cells so columns line up in monospace. Use reference-style links **only inside tables** (`[label][slug]` with `[slug]: url` definitions placed *immediately below that table*, not at the bottom of the file). Outside tables, always use inline links `[label](url)`.

## Coding Rules
- TDD always. Tests mandatory.
- Comments explain WHY it **is** (constraint/footgun/pointer), never WHY it **changed**. No history/changelog/dated/process-narration comments — that goes in the commit message or a spec/runbook. Test: *would a dev who never saw the old version still need this?*
- KISS/YAGNI. Don't improve surrounding code.
- No empty scaffolding or placeholders.

## Workflow
- Run tests after changes.
- Don't commit/push/add deps without asking.
- Zero linter warnings.
- Use bun/bunx, not npm/npx.

## Commits
One concern per commit. Imperative subject ≤72 chars. No noise (console.log, commented code, empty files). Stage deliberately.

## PRs
Small, one feature/fix. Title ≤72 chars. Body: Summary bullets + Test Plan checklist. No junk in diff, no attribution footers.

## Meta
Suggest persisting allow/deny rules to settings.json. Suggest CLAUDE.md updates for recurring guidance. Project CLAUDE.md overrides this.
