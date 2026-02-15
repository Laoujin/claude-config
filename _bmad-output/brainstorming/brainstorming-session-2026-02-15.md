---
stepsCompleted: [1, 2, 3]
inputDocuments: []
session_topic: 'Agents and skills for Claude Code workspace with BMAD integration'
session_goals: 'Identify what agents/skills to build, map to daily dev workflows, leverage BMAD agent/workflow system'
selected_approach: 'ai-recommended'
techniques_used: ['Question Storming', 'Cross-Pollination', 'Morphological Analysis']
ideas_generated: 47
context_file: ''
technique_execution_complete: true
---

# Brainstorming Session Results

**Facilitator:** Wouter
**Date:** 2026-02-15

## Session Overview

**Topic:** Agents and skills for Claude Code workspace with BMAD integration
**Goals:** Identify what agents/skills to build, map to daily dev workflows, leverage BMAD agent/workflow system
**Stacks:** .NET (WebAPI, analyzers, NUnit) + TypeScript/React + monorepos

---

## Part 1: Decisions from Question Storming

### Core Workflow Decisions

| # | Question | Decision |
|---|---------|----------|
| 1 | Worktree: issue required? | Hybrid: issue-free default, `--issue N` optional |
| 2 | Branch naming | `feat/42-short-desc`, prefix matches type (`fix/`, `chore/`, etc.) |
| 3 | Skill granularity | Two bookends: `/wt-start` and `/wt-ship` |
| 4 | Test gating | Gate on ship only -- `/wt-ship` refuses PR until tests pass |
| 5 | Stack detection | Auto-detect (csproj/package.json), project CLAUDE.md can override |
| 6 | Code review | Both: `claude-code-action` CI + local `/review` skill |
| 7 | Browser open | Simple: `gh pr view --web` after PR creation |
| 8 | TDD skill | Not needed -- CLAUDE.md instruction is sufficient |
| 9 | Mixed-concern enforcement | No enforcement -- CLAUDE.md rule is enough |
| 10 | Review scope | Logic, architecture, bugs, test coverage only. Trust hooks for formatting. |

### Infrastructure Decisions

| # | Question | Decision |
|---|---------|----------|
| 11 | Scaffolding | `/scaffold <type>` -- single skill with argument |
| 12 | Prettier hook | TS/JS/CSS only |
| 13 | AGENTS files | Both: global defaults in `~/.claude/`, `/scaffold` copies into project |
| 14 | Kobozo plugins | Keep disabled, evaluate later |
| 15 | MCP servers | Playwright + DB (read-only/schema). Install on demand per project. |
| 16 | Memory | Keep as TODO, evaluate later |
| 17 | Hooks philosophy | Everything deterministic = hooks, not AI. Lint on edit, tsc at ship. |
| 18 | CI templates | Separate `/ci` skill, aware of monorepo vs standalone |
| 19 | ESLint/tsc timing | ESLint on every edit (PostToolUse), `tsc` at ship time only |

### Decisions Made by AI (Q21-24, "most logical")

| # | Question | Decision | Rationale |
|---|---------|----------|-----------|
| 20 | `/scaffold` + CI | Separate `/ci` skill | Monorepos need flexible CI independent of scaffolding |
| 21 | Cross-project config sync | YES -- build `/sync-config` skill | You maintain many repos with shared conventions. Like `dotnet-skills/sync.sh`. Push CLAUDE.md, AGENTS, hooks, editorconfig to all projects. |
| 22 | Dependency updates | Let `claude-code-action` review Dependabot PRs automatically | Already covered by CI review setup. No separate `/deps` skill needed. |
| 23 | Legacy code onboarding | YES -- build `/explore` skill | High value when returning to old projects. Generate summary + draft CLAUDE.md. Low effort to build. |
| 24 | Debug workflow | No dedicated skill | Claude handles debugging well inline. TDD mandate + CLAUDE.md is sufficient. |

---

## Part 2: Ecosystem Research -- Repos Worth Looking At

### Priority 1: MUST STUDY (directly solves your needs)

#### Worktree + PR Automation
| Repo | Stars | What to steal |
|------|-------|---------------|
| [forrestchang/worktree-workflow](https://github.com/forrestchang/worktree-workflow) | 87 | **Your direct template.** `claude-wt` bash script + `/worktree` SKILL.md + `/pr` command + `/done` command. Two-bookend pattern. Clean, purpose-built. Adapt for Windows + your branch naming convention. |
| [automazeio/ccpm](https://github.com/automazeio/ccpm) | 7.3k | Full PM system: PRD -> epic -> GitHub Issues -> parallel worktree agents. Borrow the `worktree-operations.md` rules and `agent-coordination.md` patterns. Overkill as a whole but excellent reference. |
| [anthropics/claude-code-action](https://github.com/anthropics/claude-code-action) | 5.7k | **Official PR review action.** Set up for auto-review on every PR. Supports inline code comments, `@claude` mentions, structured JSON output, path-specific reviews. Must-configure for your repos. |

#### .NET Skills
| Repo | Stars | What to steal |
|------|-------|---------------|
| [Aaronontheweb/dotnet-skills](https://github.com/Aaronontheweb/dotnet-skills) | 329 | **30 skills + 5 agents** for .NET. Best picks for you: `crap-analysis` (CRAP score = complexity x untested), `database-performance` (CQRS, N+1, AsNoTracking), `snapshot-testing` (Verify), `package-management` (CPM, never edit XML), `ilspy-decompile`, `dependency-injection-patterns`. Has `sync.sh`/`sync.ps1` for pushing to `~/.claude/`. |
| [davidfowl/dotnet-skillz](https://github.com/davidfowl/dotnet-skillz) | 213 | .NET skills by ASP.NET Core architect at Microsoft. Authoritative patterns. |

#### Reference Implementations
| Repo | Stars | What to steal |
|------|-------|---------------|
| [ChrisWiles/claude-code-showcase](https://github.com/ChrisWiles/claude-code-showcase) | 5.3k | **Best overall reference.** Full `.claude/` directory structure, GitHub Actions workflows (PR review, weekly quality sweeps, monthly docs sync, dependency audits), skill evaluation hooks (pattern-match prompts to auto-activate skills), `/ticket` command (read ticket -> implement -> PR -> update status), MCP configs. |
| [obra/superpowers](https://github.com/obra/superpowers) | -- | **Plugin for worktree-to-PR.** 7-phase workflow: brainstorm -> worktree -> plan -> subagent execution -> TDD -> review -> branch finish. Auto-activating skills. Strict RED-GREEN-REFACTOR. Install via `/plugin install superpowers@superpowers-marketplace` and evaluate. |

### Priority 2: WORTH EVALUATING (strong value-add)

#### Workflow & Review
| Repo | Stars | What it offers |
|------|-------|---------------|
| [EveryInc/compound-engineering-plugin](https://github.com/EveryInc/compound-engineering-plugin) | -- | **29 agents, 22 commands, 19 skills.** Stack-specific reviewers (TypeScript, Rails, Python). Setup command auto-detects stack and configures review agents. `/lfg` command chains: plan -> deepen-plan -> work -> review -> resolve TODOs -> test browser -> feature video. The `kieran-typescript-reviewer` agent is excellent -- strict type safety, 5-second naming rule, duplication > complexity philosophy. |
| [disler/claude-code-hooks-mastery](https://github.com/disler/claude-code-hooks-mastery) | -- | **Best hooks reference.** All 13 hook events with examples. Builder/validator team pattern. PostToolUse validators (lint + type-check after every write). Meta-agent that generates other agents. Uses Python/uv. |
| [wshobson/commands](https://github.com/wshobson/commands) | 1.9k | 57 production commands (15 workflows + 42 tools). Multi-agent orchestration patterns. |
| [levnikolaevich/claude-code-skills](https://github.com/levnikolaevich/claude-code-skills) | 89 | Full delivery workflow: epic -> task -> implement -> test -> review -> quality gate. |

#### Specialized Tools
| Repo | Stars | What it offers |
|------|-------|---------------|
| [davila7/claude-code-templates](https://github.com/davila7/claude-code-templates) | 20k | npm-based catalog for browsing/installing pre-built configs. `npx claude-code-templates@latest`. Browse for existing agents, commands, hooks. |
| [bartolli/claude-code-typescript-hooks](https://github.com/bartolli/claude-code-typescript-hooks) | -- | TS quality hooks: TypeScript compilation, ESLint auto-fix, Prettier formatting. Sub-5ms via SHA256 caching. Directly useful for your TS projects. |
| [giuseppe-trisciuoglio/developer-kit](https://github.com/giuseppe-trisciuoglio/developer-kit) | 99 | Modular plugin system with TS/NestJS/React plugin. Agents for backend dev, frontend dev, TS refactoring. |
| [qdhenry/Claude-Command-Suite](https://github.com/qdhenry/Claude-Command-Suite) | 937 | 148+ commands, 54 agents. Code review, security audit, architectural analysis patterns. |

### Priority 3: NICE TO KNOW (reference/niche)

| Repo | Stars | What it offers |
|------|-------|---------------|
| [AndyMik90/Auto-Claude](https://github.com/AndyMik90/Auto-Claude) | 12.1k | Full autonomous Electron app + Python backend. Spec-driven, QA loop (50 iterations), parallel agents, git worktrees. **Verdict: too heavy for solo dev** -- you want lightweight CLI skills, not a desktop app. But the QA reviewer/fixer loop pattern is worth studying. |
| [trailofbits/claude-code-config](https://github.com/trailofbits/claude-code-config) | 872 | Security-focused opinionated config from Trail of Bits. Good security patterns. |
| [OneRedOak/claude-code-workflows](https://github.com/OneRedOak/claude-code-workflows) | 3.6k | Dual-loop: slash commands + GitHub Actions for PR review. From an AI-native startup. |
| [raine/workmux](https://github.com/raine/workmux) | 710 | Worktree + tmux for zero-friction parallel dev. Linux/macOS. |
| [stravu/crystal](https://github.com/stravu/crystal) | 2.9k | Desktop app for parallel Claude Code sessions. |

---

## Part 3: What to Build -- Prioritized Backlog

### Tier 1: Core Workflow (build first)

#### 1. `/wt-start` -- Worktree Start Skill
**Priority:** Highest
**Reference:** `forrestchang/worktree-workflow` SKILL.md + `claude-wt` script
**What it does:**
- Creates git worktree + branch from latest main/master
- Branch naming: `<type>/<issue-number>-<short-desc>` (e.g., `feat/42-add-auth`)
- Optional `--issue N` links to GitHub Issue
- Auto-detects default branch
- Worktree at `../worktrees/<repo>-<branch>/`
- Windows-compatible (bash on Git Bash)

#### 2. `/wt-ship` -- Worktree Ship Skill
**Priority:** Highest
**Reference:** `forrestchang/worktree-workflow` `/pr` + `/done` commands
**What it does:**
1. Auto-detect stack (csproj -> `dotnet test`, package.json -> `npm test`)
2. Run full test suite -- **block if tests fail**
3. Run `tsc --noEmit` for TS projects -- **block if type errors**
4. Commit (respecting CLAUDE.md commit hygiene: one concern, imperative subject, no Co-Authored-By)
5. Push to remote
6. Create PR via `gh pr create` (title: short imperative, body: Summary + Test Plan, link issue if provided)
7. Open browser: `gh pr view --web`
8. Offer worktree cleanup

#### 3. `claude-code-action` CI Setup
**Priority:** Highest
**Reference:** `anthropics/claude-code-action` README + `ChrisWiles/claude-code-showcase` workflows
**What it does:**
- `.github/workflows/claude-review.yml` for automatic PR review
- Inline code comments on specific lines
- Focus: logic, architecture, bugs, test coverage
- Path-specific reviews optional (e.g., stricter on `src/api/`)
- `@claude` mention support in PR comments
- Dependabot PR auto-review

#### 4. `/review` -- Local Code Review Skill
**Priority:** High
**Reference:** `EveryInc/compound-engineering-plugin` `kieran-typescript-reviewer` + `code-simplicity-reviewer`
**What it does:**
- Reads diff (`git diff main...HEAD`)
- Reviews for: logic errors, architectural issues, bugs, test coverage gaps
- Posts line comments via `gh api`
- Stack-aware: .NET patterns (async/await misuse, N+1, missing disposal) + TS patterns (any usage, type safety, naming)
- Does NOT check formatting (trust hooks)

### Tier 2: Supporting Infrastructure (build second)

#### 5. Prettier PostToolUse Hook
**Priority:** High (trivial to add)
**Scope:** TS/JS/CSS files only
**Pattern:** Mirror existing `dotnet format` hook in settings.json

#### 6. ESLint PostToolUse Hook
**Priority:** High (trivial to add)
**Scope:** TS/JS files on every edit
**Pattern:** `eslint --fix` after Write|Edit on `.ts`, `.tsx`, `.js`, `.jsx`

#### 7. AGENTS-TYPESCRIPT-STYLE.md (global default)
**Priority:** High
**Content:** TS/React conventions, naming, import organization, type safety rules, component patterns
**Location:** `~/.claude/AGENTS-TYPESCRIPT-STYLE.md` (global) + copied by `/scaffold`

#### 8. AGENTS-TYPESCRIPT-TESTING.md (global default)
**Priority:** High
**Content:** Jest/Vitest conventions, mocking patterns, testing-library usage, snapshot testing, coverage thresholds
**Location:** `~/.claude/AGENTS-TYPESCRIPT-TESTING.md` (global) + copied by `/scaffold`

#### 9. `/scaffold <type>` -- Project Scaffolding Skill
**Priority:** Medium
**Types:** `dotnet-webapi`, `react`, `ts-lib`, `angular`
**What it creates:**
- `.editorconfig`
- `.gitignore`
- `CLAUDE.md` (project-specific skeleton)
- AGENTS files (copied from global defaults)
- Linter/formatter config
- Basic project structure
- Does NOT create CI (that's `/ci`)

#### 10. `/ci` -- CI Generation Skill
**Priority:** Medium
**What it does:**
- Detects repo structure (standalone vs monorepo)
- Generates GitHub Actions workflow
- .NET: `dotnet build` + `dotnet test` + `dotnet format --verify-no-changes`
- TS: `npm ci` + `npm run lint` + `npm test` + `tsc --noEmit`
- Monorepo: path filters per project
- Includes `claude-code-action` review step

### Tier 3: Quality of Life (build when needed)

#### 11. `/explore` -- Codebase Onboarding Skill
**Priority:** Medium
**What it does:**
- Reads project structure, key files, recent commits
- Generates summary: tech stack, architecture, key patterns, entry points
- Drafts a CLAUDE.md if none exists
- Useful when returning to old projects

#### 12. `/sync-config` -- Cross-Project Config Sync
**Priority:** Low
**Reference:** `Aaronontheweb/dotnet-skills` `sync.sh`/`sync.ps1`
**What it does:**
- Pushes updated CLAUDE.md, AGENTS files, hooks, editorconfig from `~/.claude/` to specified projects
- Dry-run mode
- Selective sync (only AGENTS, only hooks, etc.)

#### 13. Install .NET Skills from `dotnet-skills`
**Priority:** Low (evaluate and cherry-pick)
**Best candidates:**
- `crap-analysis` -- CRAP score for risk assessment
- `database-performance` -- CQRS, N+1, AsNoTracking patterns
- `snapshot-testing` -- Verify for .NET
- `package-management` -- CPM, never edit XML directly
- `dependency-injection-patterns` -- IServiceCollection extension methods

#### 14. Evaluate `obra/superpowers` Plugin
**Priority:** Low (install and test)
**Why:** Full worktree-to-PR pipeline as a plugin. May overlap with custom `/wt-start` + `/wt-ship`. Try it and decide if it replaces or complements your custom skills.

---

## Part 4: Hooks Summary

### Current Hooks
| Event | Matcher | Action |
|-------|---------|--------|
| PostToolUse | `Write\|Edit` on `.cs` | `dotnet format --include "$FILE"` |

### Hooks to Add

| Event | Matcher | Action | Priority |
|-------|---------|--------|----------|
| PostToolUse | `Write\|Edit` on `.ts,.tsx,.js,.jsx,.css` | `prettier --write "$FILE"` | High |
| PostToolUse | `Write\|Edit` on `.ts,.tsx` | `eslint --fix "$FILE"` | High |
| PreToolUse | `Bash` matching destructive commands | Block `rm -rf`, `git push --force`, `git reset --hard` | Medium |

### Hooks deferred to `/wt-ship` (not on every edit)
- `tsc --noEmit` (full project type check)
- `dotnet test` / `npm test` (full test suite)
- `dotnet build` (full build verification)

---

## Part 5: TODO.md Updates Needed

Based on this brainstorming session, these TODO items can be updated:

| TODO Item | Status | Action |
|-----------|--------|--------|
| Decide commit convention | **Decision pending** -- still open (Conventional Commits vs freeform) |
| Decide ticket prefix | **Decision pending** -- `#N` for GitHub, no Jira prefix |
| PR body template | **Confirmed** -- Summary + Test Plan format stays |
| File-count threshold | **Confirmed** -- 20+ stays |
| `/scaffold` skill | **Planned** -- `/scaffold <type>` with argument, Tier 2 |
| AGENTS-TYPESCRIPT-STYLE.md | **Planned** -- global + per-project, Tier 2 |
| AGENTS-TYPESCRIPT-TESTING.md | **Planned** -- global + per-project, Tier 2 |
| Granularity: one per stack or unified? | **Decision: unified** -- one TS file covers React/Angular/Node |
| MCP audit | **Decision** -- Context7 global, Playwright + DB on demand |
| Prettier hook | **Planned** -- TS/JS/CSS only, Tier 2 |
| Pre-commit lint hook | **Covered** -- ESLint PostToolUse hook instead |
| Keybindings | **Deferred** |
| Memory tracking | **Deferred** |
| Settings.json deny rules | **Looks good** -- current rules cover secrets |

---

## Part 6: Architecture Diagram

```
~/.claude/
  CLAUDE.md                          # Global dev profile (exists)
  settings.json                      # Permissions + hooks (exists, needs Prettier/ESLint hooks)
  AGENTS-TYPESCRIPT-STYLE.md         # NEW: global TS conventions
  AGENTS-TYPESCRIPT-TESTING.md       # NEW: global TS testing conventions
  skills/
    wt-start/SKILL.md               # NEW: worktree start
    wt-ship/SKILL.md                 # NEW: worktree ship (test gate + PR + browser)
    review/SKILL.md                  # NEW: local code review
    scaffold/SKILL.md                # NEW: project scaffolding
    ci/SKILL.md                      # NEW: CI workflow generation
    explore/SKILL.md                 # NEW: codebase onboarding
    sync-config/SKILL.md             # NEW: cross-project config sync
  _bmad/                             # BMAD framework (exists)
    core/                            # Core module (exists)
    bmb/                             # Module builder (exists)

Per-project:
  .claude/
    CLAUDE.md                        # Project-specific overrides
    AGENTS-TYPESCRIPT-STYLE.md       # Copied from global, customizable
    AGENTS-TYPESCRIPT-TESTING.md     # Copied from global, customizable
    settings.json                    # Project-specific hooks/permissions
  .github/workflows/
    claude-review.yml                # claude-code-action for PR review
    ci.yml                           # Generated by /ci skill
```

---

## Next Steps

1. **Start with `/wt-start` + `/wt-ship`** -- the core workflow. Use `forrestchang/worktree-workflow` as template.
2. **Set up `claude-code-action`** on one repo as proof of concept.
3. **Add Prettier + ESLint hooks** to `settings.json` (trivial, immediate value).
4. **Create AGENTS-TYPESCRIPT-STYLE.md** and test on a TS project.
5. **Build `/review`** skill borrowing patterns from compound-engineering's `kieran-typescript-reviewer`.
6. **Evaluate `obra/superpowers`** plugin -- if it covers `/wt-start` + `/wt-ship` well enough, skip building custom.
7. **Build `/scaffold`** and `/ci` once the core workflow is proven.

Use BMAD BMB (agent builder) for creating any agents needed by the skills. Start a fresh context window with the agent builder workflow when ready.
