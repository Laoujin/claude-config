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
Docs/command refs: state the command, not rationale, self-evident labels (`# run the tests`), or "NOT X" warnings against mistakes nobody made. Pitfalls go in a cheat-sheet/troubleshooting doc, not the quickstart.
Markdown tables: pad cells so columns line up in monospace. Use reference-style links **only inside tables** (`[label][slug]` with `[slug]: url` definitions placed *immediately below that table*, not at the bottom of the file). Outside tables, always use inline links `[label](url)`.

## Coding Rules
- TDD always. Tests mandatory.
- Comments explain WHY it **is** (constraint/pitfall/pointer), never WHY it **changed** and never WHAT the code plainly does. No history/changelog/dated/process-narration comments; no explaining standard language/library/tool behaviour a competent reader already knows (flagging it as a pitfall does not license it — that's still noise). Both tests must pass: *would a dev who never saw the old version still need this?* AND *would a competent dev not already know it from the code?* A genuine pitfall that is really a deploy/setup step belongs in the runbook, not inline. When a comment mixes one real constraint with obvious mechanism, keep only the constraint.
- KISS/YAGNI. Don't improve surrounding code.
- No empty scaffolding or placeholders.

## Workflow
- Run tests after changes.
- Don't commit/push/add deps without asking.
- Zero linter warnings.
- Use bun/bunx, not npm/npx.
- Never use the Superpowers brainstorming "visual companion" / browser-URL feature. Keep brainstorming in the terminal UI.

## Commits
One concern per commit. Imperative subject ≤72 chars. No noise (console.log, commented code, empty files). Stage deliberately.

## PRs
Small, one feature/fix. Title ≤72 chars. Body: Summary bullets + Test Plan checklist. No junk in diff, no attribution footers.

## Homelab
My projects are self-hosted on my homelab. When debugging something **deployed**, or when a task needs **deploy / logging / infra** access, read [`HOMELAB.md`](HOMELAB.md) first: deploys are almost always **Coolify**, logs almost always **Grafana/Loki**.

## Meta
Suggest persisting allow/deny rules to settings.json. Suggest CLAUDE.md updates for recurring guidance. Project CLAUDE.md overrides this.
