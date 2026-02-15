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

## Self-Improving Config

- When I allow/deny a command, suggest adding a general allow/deny rule to `~/.claude/settings.json` so the preference persists across sessions.
- When I guide you down a particular path or request a general change, suggest adding it to `~/.claude/CLAUDE.md` where applicable.

## Per-Project Instructions

Project-specific CLAUDE.md files override anything here. Defer to them for architecture, naming, tech stack, and build commands.
