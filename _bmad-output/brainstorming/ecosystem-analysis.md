# Claude Code Ecosystem Analysis

**Date:** 2026-02-15
**Context:** Solo dev, .NET + TypeScript/React, Windows, git worktrees, TDD-first
**Goal:** Automate worktree -> branch -> code -> test -> commit -> PR -> browser -> code review

---

## How to Read This

Each item has:
- **Killer Feature** -- the single most valuable thing it offers you
- **MoSCoW** -- Must / Should / Could / Won't (for now)
- **Action** -- Adopt (use as-is) / Cherry-pick (extract parts) / Study (learn patterns) / Skip

---

## 1. Worktree + Branch Automation

| Repo | Killer Feature | MoSCoW | Action |
|------|---------------|--------|--------|
| [forrestchang/worktree-workflow](https://github.com/forrestchang/worktree-workflow) | Complete 3-file template: `claude-wt` bash script + `/worktree` SKILL.md + `/pr` command. Two-bookend pattern. Windows-compatible (Git Bash). Auto-detects default branch, converts slash branches to safe dir names. | **Must** | **Cherry-pick** -- Adapt `claude-wt` + SKILL.md for your branch naming (`feat/42-short-desc`). Replace Linear integration with GitHub-only. |
| [automazeio/ccpm](https://github.com/automazeio/ccpm) worktree rules | `worktree-operations.md` and `agent-coordination.md` -- battle-tested rules for how agents should behave in worktrees: file-level boundaries, atomic commits, conflict detection, never force-push. | **Should** | **Cherry-pick** -- Extract the rules files as AGENTS-level docs for your worktree workflow. |
| [EveryInc/compound-engineering-plugin](https://github.com/EveryInc/compound-engineering-plugin) git-worktree skill | `worktree-manager.sh` handles worktree creation, `.env` copying, cleanup. Integrated into work + review commands. | **Could** | **Study** -- Compare with worktree-workflow's approach. Pick the cleaner one. |

### Verdict
**Primary template:** `worktree-workflow`. Supplement with CCPM's rule files for agent behavior.

---

## 2. PR Creation + Shipping

| Repo | Killer Feature | MoSCoW | Action |
|------|---------------|--------|--------|
| [forrestchang/worktree-workflow](https://github.com/forrestchang/worktree-workflow) `/pr` command | Auto-detects base branch, checks for uncommitted changes, pushes with `-u`, creates PR via `gh pr create` with conventional commit title + Summary + Test Plan body. 40 lines of markdown. | **Must** | **Cherry-pick** -- Direct template for `/wt-ship`. Add test gating before push. |
| [forrestchang/worktree-workflow](https://github.com/forrestchang/worktree-workflow) `/done` command | Summarizes work, offers PR creation, optional worktree cleanup. Issue detection from branch name. | **Should** | **Cherry-pick** -- Merge cleanup logic into `/wt-ship`. |
| [evmts `/commit`](https://github.com/evmts/tevm-monorepo/blob/main/.claude/commands/commit.md) | Conventional commit formatting as a slash command. | **Could** | **Study** -- Your CLAUDE.md already covers commit style. Only adopt if Claude struggles. |
| [toyamarinyon `/create-pr`](https://github.com/toyamarinyon/giselle/blob/main/.claude/commands/create-pr.md) | Full PR workflow: branch + commit + format + submit. | **Could** | **Study** -- Alternative to worktree-workflow's `/pr`. Compare approaches. |

### Verdict
**Primary template:** worktree-workflow `/pr` + `/done`. Combine into single `/wt-ship` with test gate.

---

## 3. Code Review (Local + CI)

| Repo | Killer Feature | MoSCoW | Action |
|------|---------------|--------|--------|
| [anthropics/claude-code-action](https://github.com/anthropics/claude-code-action) | **Official.** Auto-detects PR/comment/issue mode. Inline code comments via MCP. `@claude` mention support. "Fix this" links that open Claude Code locally. Path-specific reviews. Structured JSON output. Dependabot auto-review. | **Must** | **Adopt** -- Set up `claude-review.yml` on one repo. Use the prompt from the research (logic, architecture, bugs, test coverage focus). |
| [EveryInc/compound-engineering `kieran-typescript-reviewer`](https://github.com/EveryInc/compound-engineering-plugin) | Strict TS review agent: no `any`, 5-second naming rule, "duplication > complexity", critical deletion checks, import organization, testability focus. | **Must** | **Cherry-pick** -- Copy this agent definition. Use as template for your `/review` skill's TS mode. Excellent quality bar. |
| [EveryInc/compound-engineering generic reviewers](https://github.com/EveryInc/compound-engineering-plugin) | `security-sentinel`, `performance-oracle`, `architecture-strategist`, `code-simplicity-reviewer` -- language-agnostic, work for both .NET and TS. | **Should** | **Cherry-pick** -- Extract these 4 agent definitions. Use as review sub-agents. |
| [ChrisWiles/claude-code-showcase](https://github.com/ChrisWiles/claude-code-showcase) | GitHub Actions workflows for PR review + weekly quality sweeps + monthly docs sync + dependency audits. Skill evaluation hooks (pattern-match prompts to auto-activate skills). | **Should** | **Study** -- Best reference for multi-workflow CI setup. Borrow the quality sweep cron pattern. |
| [Aaronontheweb/dotnet-skills `slopwatch`](https://github.com/Aaronontheweb/dotnet-skills) | Detects LLM anti-patterns in real-time: disabled tests, pragma warning suppress, empty catches, `Task.Delay` in tests, CPM bypass. Has PostToolUse hook integration. | **Must** | **Adopt** -- Install via plugin marketplace. Wire as PostToolUse hook for .NET projects. This catches exactly the kind of slop Claude introduces. |

### Verdict
**CI:** `claude-code-action` with focused prompt. **Local TS:** Cherry-pick `kieran-typescript-reviewer`. **Local .NET:** Create equivalent using `slopwatch` patterns + generic agents. **Cron:** Study showcase's weekly quality sweep.

---

## 4. Quality Hooks & Gates

| Repo | Killer Feature | MoSCoW | Action |
|------|---------------|--------|--------|
| [bartolli/claude-code-typescript-hooks](https://github.com/bartolli/claude-code-typescript-hooks) | TS compilation + ESLint auto-fix + Prettier on every file write. Sub-5ms via SHA256 config caching. Drop-in PostToolUse hooks. | **Must** | **Cherry-pick** -- Extract the hook definitions for your `settings.json`. The SHA256 caching pattern is clever -- adopt it for performance. |
| [disler/claude-code-hooks-mastery](https://github.com/disler/claude-code-hooks-mastery) | All 13 hook events documented with examples. Builder/validator team pattern. Meta-agent that generates other agents. | **Should** | **Study** -- Best hooks reference. Read the builder/validator pattern for your ship-time gates. |
| [nizos/tdd-guard](https://github.com/nizos/tdd-guard) | Hooks that **block** implementation code written before tests. Real-time TDD enforcement, not guidance. | **Could** | **Study** -- Interesting enforcement model. Your CLAUDE.md TDD rule + test gating at ship time may be sufficient. Evaluate if Claude still skips tests. |
| [johnlindquist/claude-hooks](https://github.com/johnlindquist/claude-hooks) | Write hooks in TypeScript instead of bash/JSON. Full TS expressiveness for quality gates. | **Could** | **Study** -- You're TS-expert. If bash hooks become painful, switch to this. But bash hooks are simpler for lint/format. |
| [nulone/claude-rules-doctor](https://github.com/nulone/claude-rules-doctor) | Catches dead `.claude/rules/` where path globs no longer match after refactoring. CI mode with exit code. | **Could** | **Adopt** -- Tiny, focused. Add to CI once you have rules files. |

### Verdict
**Immediate:** bartolli's TS hooks for Prettier + ESLint. **Study:** hooks-mastery for builder/validator pattern. **Later:** tdd-guard if TDD compliance is poor.

---

## 5. .NET Skills & Knowledge

| Repo | Killer Feature | MoSCoW | Action |
|------|---------------|--------|--------|
| [Aaronontheweb/dotnet-skills](https://github.com/Aaronontheweb/dotnet-skills) (full plugin) | 30 skills + 5 agents. Install via `/plugin install`. Routing snippets for CLAUDE.md. Most comprehensive .NET skill set available. | **Must** | **Adopt** -- Install the plugin. Cherry-pick relevant skills via CLAUDE.md routing. |
| `slopwatch` (from above) | LLM slop detection as PostToolUse hook. | **Must** | **Adopt** -- Already listed above. Your #1 .NET quality gate. |
| `crap-analysis` | CRAP score (complexity x untested code). Data-driven test prioritization. Uses ReportGenerator. | **Should** | **Adopt** -- Supports your TDD mandate with metrics. Run periodically or at ship time. |
| `package-management` | "Never edit XML directly" for NuGet. Enforces `dotnet add/remove/list` CLI. Prevents a common LLM mistake. | **Should** | **Adopt** -- Claude frequently edits csproj directly. This stops it. |
| `testcontainers` | Docker-based integration tests (PostgreSQL, SQL Server, Redis, RabbitMQ). Includes Respawn for fast reset. | **Should** | **Adopt** -- For WebAPI integration testing with real databases. |
| `database-performance` | CQRS read/write separation, N+1 prevention, AsNoTracking, row limits. | **Should** | **Adopt** -- Reference skill for data access patterns. |
| `efcore-patterns` | NoTracking by default, migrations, query splitting, ExecutionStrategy. | **Could** | **Adopt** -- Good companion to database-performance. |
| `dotnet-project-structure` | Directory.Build.props, CPM, .slnx, global.json, SourceLink. | **Could** | **Adopt** -- Ensures Claude respects your build infrastructure. |
| `csharp-coding-standards` | Records, pattern matching, Result types, no AutoMapper, composition over inheritance. Largest skill (~40KB). | **Could** | **Adopt** -- You already know this, but it teaches Claude your conventions. |
| [davidfowl/dotnet-skillz](https://github.com/davidfowl/dotnet-skillz) | `ilspy-decompile` by the ASP.NET Core architect. | **Won't** | **Skip** -- One skill, already in dotnet-skills. Repo too nascent (v0.0.1). |

### Verdict
**Install `dotnet-skills` plugin.** Route `slopwatch`, `crap-analysis`, `package-management`, `testcontainers`, `database-performance` via CLAUDE.md. Skip Akka/Aspire/email skills.

---

## 6. TypeScript/React Skills & Knowledge

| Repo | Killer Feature | MoSCoW | Action |
|------|---------------|--------|--------|
| `kieran-typescript-reviewer` (compound-engineering) | Already covered in Code Review section. Strict TS agent with excellent philosophy. | **Must** | **Cherry-pick** |
| [bartolli TS hooks](https://github.com/bartolli/claude-code-typescript-hooks) | Already covered in Hooks section. Real-time TS quality enforcement. | **Must** | **Cherry-pick** |
| [giuseppe-trisciuoglio/developer-kit](https://github.com/giuseppe-trisciuoglio/developer-kit) | Modular plugin system with TS/NestJS/React plugin. Agents for backend dev, frontend dev, TS refactoring. | **Could** | **Study** -- Check if the React agent has patterns worth extracting. |
| [davila7/claude-code-templates](https://github.com/davila7/claude-code-templates) | npm-based catalog (`npx claude-code-templates@latest`). Browse + install pre-built configs. 20k stars. | **Could** | **Study** -- Browse the catalog for TS/React templates. May have useful AGENTS files. |

### Verdict
**Primary:** `kieran-typescript-reviewer` agent + bartolli TS hooks. **Later:** Browse claude-code-templates catalog for React-specific patterns.

---

## 7. Testing Enforcement (TDD)

| Repo | Killer Feature | MoSCoW | Action |
|------|---------------|--------|--------|
| [zscott/pane `/tdd`](https://github.com/zscott/pane/blob/main/.claude/commands/tdd.md) | Enforces Red-Green-Refactor discipline. Integrates with git workflow + PR creation. | **Could** | **Study** -- Your CLAUDE.md TDD mandate may be sufficient. Read this for the enforcement pattern in case you need a skill. |
| [jerseycheese `/tdd-implement`](https://github.com/jerseycheese/Narraitor/blob/feature/issue-227-ai-suggestions/.claude/commands/tdd-implement.md) | Feature-requirements angle: analyze requirements -> write tests first (red) -> implement (green) -> refactor. | **Could** | **Study** -- Same as above. Alternative approach from the feature side. |
| [nizos/tdd-guard](https://github.com/nizos/tdd-guard) | Hooks-based real-time enforcement. **Blocks** implementation before tests. | **Could** | **Study** -- Most aggressive TDD enforcement. Try if CLAUDE.md proves insufficient. |
| `crap-analysis` (dotnet-skills) | CRAP score for quantifying test coverage risk. | **Should** | **Adopt** -- Already listed in .NET skills. Complements TDD with metrics. |

### Verdict
**Default:** Trust CLAUDE.md TDD mandate + test gate at ship time. **Fallback:** Install `tdd-guard` if Claude consistently writes implementation before tests.

---

## 8. Project Scaffolding & CI

| Repo | Killer Feature | MoSCoW | Action |
|------|---------------|--------|--------|
| [ChrisWiles/claude-code-showcase](https://github.com/ChrisWiles/claude-code-showcase) | Full `.claude/` directory structure reference. GitHub Actions for PR review, quality sweeps, docs sync, dependency audits. `/ticket` command (read ticket -> implement -> PR -> update status). | **Should** | **Study** -- Best overall reference for structuring your `.claude/` setup and CI workflows. |
| [akin-ozer/cc-devops-skills](https://github.com/akin-ozer/cc-devops-skills) | DevOps skills: IaC, deployment, CI generation. Matches your "Learning" level for K8s/Cloud/Terraform. | **Could** | **Study** -- When you need CI/IaC generation, these skills guide Claude with explanations matching your learning level. |
| [davila7/claude-code-templates](https://github.com/davila7/claude-code-templates) | `npx claude-code-templates@latest` -- browse and install configs. | **Could** | **Study** -- Check for existing scaffolding templates before building custom `/scaffold`. |

### Verdict
**Study showcase for CI patterns** before building `/ci` skill. Check claude-code-templates catalog before building `/scaffold`.

---

## 9. Full Workflow Orchestration

These repos attempt to solve the entire workflow end-to-end. Compare with building custom skills.

| Repo | Killer Feature | MoSCoW | Action |
|------|---------------|--------|--------|
| [obra/superpowers](https://github.com/obra/superpowers) | Plugin with 7-phase workflow: brainstorm -> worktree -> plan -> subagent execution -> TDD -> review -> branch finish. Auto-activating skills. Strict RED-GREEN-REFACTOR. Install via `/plugin install`. | **Should** | **Adopt (trial)** -- Install and test on one project. If it covers `/wt-start` + `/wt-ship` well enough, skip building custom. If too opinionated, cherry-pick phases. |
| [EveryInc/compound-engineering-plugin](https://github.com/EveryInc/compound-engineering-plugin) | `/lfg` = one command for plan -> deepen -> work -> review -> resolve -> test. Knowledge compounding via `docs/solutions/`. 29 agents. Stack auto-detection. | **Should** | **Cherry-pick** -- The full plugin has too much Rails baggage (~50% irrelevant). Extract: `kieran-typescript-reviewer`, generic review agents, worktree skill, knowledge compounding pattern. |
| [automazeio/ccpm](https://github.com/automazeio/ccpm) | PRD -> epic -> GitHub Issues -> parallel worktree agents. Spec-driven. "No vibe coding." `/pm:next` for intelligent task prioritization. | **Could** | **Study** -- Overkill for solo dev daily work, but the spec-driven discipline and agent coordination rules are gold. Extract rules, skip the PM layer. |
| [AndyMik90/Auto-Claude](https://github.com/AndyMik90/Auto-Claude) | Autonomous multi-agent: spec -> plan -> code -> QA (50 iterations) -> merge. Electron + Python. 12 parallel agents. Graphiti memory. | **Won't** | **Skip** -- Too heavy for solo dev (Electron app + Python backend). The QA reviewer/fixer loop pattern (up to 50 iterations) is worth knowing about conceptually, but you don't need this infrastructure. |
| [undeadlist/claude-code-agents](https://github.com/undeadlist/claude-code-agents) | "E2E workflow for solo devs." Parallel auditors, fix cycles, micro-checkpoint protocols. Anti-rogue-AI safeguards. | **Could** | **Study** -- The "solo dev" framing and micro-checkpoint pattern are relevant. Check if the auditor pattern adds value beyond `/review`. |
| [wshobson/commands](https://github.com/wshobson/commands) | 57 production commands (15 workflows + 42 tools). Multi-agent orchestration patterns. | **Could** | **Study** -- Browse for individual commands worth stealing. Large catalog. |
| [qdhenry/Claude-Command-Suite](https://github.com/qdhenry/Claude-Command-Suite) | 148+ commands, 54 agents. Code review, security audit, architectural analysis. | **Could** | **Study** -- Massive catalog. Likely has specific commands worth cherry-picking. |

### Verdict
**Try `superpowers` first** -- it's a plugin, easy to install/remove. If it doesn't fit, build custom `/wt-start` + `/wt-ship` using worktree-workflow as template. Cherry-pick from compound-engineering (review agents, compounding pattern). Study CCPM rules.

---

## 10. Developer Experience (DX)

| Repo | Killer Feature | MoSCoW | Action |
|------|---------------|--------|--------|
| [foxj77/claudectx](https://github.com/foxj77/claudectx) | Switch entire Claude Code config with one command. Useful for .NET vs TS/React context switching. | **Could** | **Study** -- Evaluate if you need this for monorepo vs single-project switching. Your auto-detection may be sufficient. |
| [ctoth/claudio](https://github.com/ctoth/claudio) | OS-native sounds when Claude finishes a task. Hooks-based, trivial install. | **Could** | **Adopt** -- Genuinely useful for background agent work. You hear when it's done. Zero effort. |
| [ryoppippi/ccusage](https://github.com/ryoppippi/ccusage) / [better-ccflare](https://github.com/tombii/better-ccflare) | Token/cost tracking dashboards. | **Won't** | **Skip** -- Not urgent. Revisit when running many parallel sessions. |
| [Piebald-AI/claude-code-system-prompts](https://github.com/Piebald-AI/claude-code-system-prompts) | All Claude Code system prompt internals exposed. Updated per version. | **Won't** | **Bookmark** -- Reference for debugging unexpected Claude behavior. Not actionable now. |
| [aRustyDev/pre-commit-hooks](https://github.com/aRustyDev/pre-commit-hooks) | Exemplary CLAUDE.md -- "thorough but not verbose, doesn't shout in all-caps." | **Could** | **Study** -- Read once for CLAUDE.md writing style reference. |
| [trailofbits/claude-code-config](https://github.com/trailofbits/claude-code-config) | Security-focused opinionated config from Trail of Bits. | **Could** | **Study** -- Check their deny rules against yours. May have patterns you missed. |

### Verdict
**Quick win:** Install `claudio` for audio notifications. **When needed:** `claudectx` for context switching, Trail of Bits for security rules.

---

## 11. Issue-to-Code Automation

| Repo | Killer Feature | MoSCoW | Action |
|------|---------------|--------|--------|
| [jerseycheese `/analyze-issue`](https://github.com/jerseycheese/Narraitor/blob/feature/issue-227-ai-suggestions/.claude/commands/analyze-issue.md) | Fetches GitHub issue details, creates implementation spec. | **Could** | **Study** -- Useful if you adopt issue-driven development. Fits the `--issue N` flag on `/wt-start`. |
| [jeremymailen `/fix-github-issue`](https://github.com/jeremymailen/kotlinter-gradle/blob/master/.claude/commands/fix-github-issue.md) | Full pipeline: analyze issue -> implement -> test -> commit. One command. | **Could** | **Study** -- More aggressive version. Compare with your two-bookend approach. |
| [ChrisWiles/claude-code-showcase `/ticket`](https://github.com/ChrisWiles/claude-code-showcase) | Read ticket -> implement -> PR -> update ticket status. | **Could** | **Study** -- Similar pattern. Check implementation details. |
| [hackdays-io `/run-ci`](https://github.com/hackdays-io/toban-contribution-viewer/blob/main/.claude/commands/run-ci.md) | Local CI: run checks, iteratively fix errors until all pass. | **Should** | **Cherry-pick** -- Simple command, useful pattern for `/wt-ship`'s test gate. Run tests, fix failures, repeat. |

### Verdict
**Later:** Once `/wt-start --issue N` is built, study these for richer issue integration.

---

## Priority Matrix (Executive Summary)

### Must Have (build/adopt immediately)

| # | What | Source | Action |
|---|------|--------|--------|
| 1 | Worktree + branch skill template | worktree-workflow | Cherry-pick into `/wt-start` |
| 2 | PR creation + ship skill template | worktree-workflow `/pr` + `/done` | Cherry-pick into `/wt-ship` |
| 3 | CI PR review | claude-code-action | Adopt -- set up workflow YAML |
| 4 | .NET skills plugin | Aaronontheweb/dotnet-skills | Adopt -- `/plugin install` |
| 5 | .NET slop detection | slopwatch (from dotnet-skills) | Adopt -- PostToolUse hook |
| 6 | TS reviewer agent | kieran-typescript-reviewer (compound-engineering) | Cherry-pick agent definition |
| 7 | TS quality hooks | bartolli/claude-code-typescript-hooks | Cherry-pick hook config |

### Should Have (high value, build soon after)

| # | What | Source | Action |
|---|------|--------|--------|
| 8 | Worktree agent behavior rules | CCPM `worktree-operations.md` + `agent-coordination.md` | Cherry-pick as AGENTS docs |
| 9 | Generic review agents (security, perf, arch, simplicity) | compound-engineering | Cherry-pick agent definitions |
| 10 | Superpowers plugin trial | obra/superpowers | Adopt (trial) -- may replace custom skills |
| 11 | CRAP score analysis | dotnet-skills `crap-analysis` | Adopt via plugin |
| 12 | Package management enforcement | dotnet-skills `package-management` | Adopt via plugin |
| 13 | Testcontainers skill | dotnet-skills `testcontainers` | Adopt via plugin |
| 14 | Iterative test-fix pattern for ship gate | hackdays-io `/run-ci` | Cherry-pick pattern |
| 15 | CI workflow patterns | claude-code-showcase | Study for `/ci` skill |
| 16 | Hooks reference | disler/claude-code-hooks-mastery | Study |

### Could Have (nice to have, evaluate when time permits)

| # | What | Source | Action |
|---|------|--------|--------|
| 17 | Knowledge compounding (docs/solutions/) | compound-engineering `/compound` | Cherry-pick pattern |
| 18 | TDD guard hooks | nizos/tdd-guard | Study -- fallback if CLAUDE.md insufficient |
| 19 | Audio notifications | ctoth/claudio | Adopt (trivial) |
| 20 | Dead rules detection | nulone/claude-rules-doctor | Adopt once rules exist |
| 21 | TS hooks in TypeScript | johnlindquist/claude-hooks | Study -- if bash hooks become painful |
| 22 | DevOps skills for K8s/Cloud | akin-ozer/cc-devops-skills | Study for learning areas |
| 23 | Config context switching | foxj77/claudectx | Study |
| 24 | CLAUDE.md writing reference | aRustyDev/pre-commit-hooks | Study once |
| 25 | Security deny rules | trailofbits/claude-code-config | Study |
| 26 | claude-code-templates catalog | davila7/claude-code-templates | Browse before building /scaffold |

### Won't Have (now)

| # | What | Source | Reason |
|---|------|--------|--------|
| 27 | Auto-Claude desktop app | AndyMik90/Auto-Claude | Too heavy -- Electron + Python. Solo dev doesn't need 12 parallel agents or Kanban board. |
| 28 | CCPM full PM system | automazeio/ccpm | Overkill -- PRD-to-epic discipline is for teams. Rules files are gold though (listed in Should). |
| 29 | Claude CodePro | maxritter/claude-codepro | Overlaps with BMAD + custom setup. Too opinionated. |
| 30 | Token tracking | ccusage / better-ccflare | Not urgent. Revisit when running many sessions. |
| 31 | Fowler's dotnet-skillz | davidfowl/dotnet-skillz | One skill (ilspy), already in dotnet-skills. Repo v0.0.1. |
| 32 | Parallel session managers | Claude Squad, viwo-cli, crystal, workmux | Not needed yet. Solo dev + worktrees is sufficient. Revisit when running overnight batches. |
| 33 | RIPER / Simone workflows | tony/claude-code-riper-5, Helmi/claude-simone | Conflicts with BMAD's own workflow phases. |
| 34 | AgentSys | avifenesh/agentsys | Overlaps with BMAD. Drift detection interesting but niche. |

---

## Quick Start Order

When you're ready to build, do this:

1. **Install `dotnet-skills` plugin** -- immediate value, zero effort
   ```
   /plugin install dotnet-skills
   ```

2. **Try `superpowers` plugin** -- if it covers worktree-to-PR, skip building custom
   ```
   /plugin install superpowers@superpowers-marketplace
   ```

3. **If superpowers doesn't fit:** Build `/wt-start` + `/wt-ship` using worktree-workflow as template

4. **Add TS quality hooks** to `settings.json` from bartolli's repo

5. **Set up `claude-code-action`** on one repo for PR review

6. **Cherry-pick `kieran-typescript-reviewer`** agent for local `/review`

7. **Wire `slopwatch`** as PostToolUse hook for .NET projects
