# Universal Testing Guidelines for AI Agents

Language-agnostic testing philosophy and principles. Language-specific conventions belong in their respective files (e.g., `AGENTS-DOTNET-TESTING.md`).

---

## Testing Philosophy

### FIRST Principles

- **Fast** -- avoid I/O (database, filesystem, network) for unit tests
- **Independent** -- tests should not interact with one another
- **Repeatable** -- without code changes, results don't change
- **Self-Validating** -- no manual verification steps
- **Thorough** -- don't just test the happy path

### What to Test

- Happy path / sunny day scenario
- Branches (if/switch) -- aim for branch coverage, not just line coverage
- Unhappy paths (guard clauses, exceptions)
- **Boundaries** -- equivalence partitioning, boundary value analysis, edge cases
- Common / real world scenarios

### What NOT to Test

Not everything needs a test. Skip:

- **Startup/bootstrapping code** -- DI registration, app configuration wiring
- **Trivial code** -- simple getters/setters with no logic
- **Branchless code** -- straight-line code with no conditionals or interesting behavior
- **Configuration as code** -- pure data declarations (route tables, mappings)
- **One-time migrations** -- throwaway scripts that run once and are verified manually

100% code coverage is not a goal -- it doesn't cover all bases. Focus testing effort on business logic, complex rules, and code that has broken before.

### Code Coverage vs Branch Coverage

Code coverage (line coverage) can be misleading. Two independent `if/else` blocks need 4 tests for full branch coverage but only 2 for 100% line coverage. Compound conditions (`if (a && (b || c))`) hide even more branches. **Aim for branch coverage**, not line coverage.

---

## Test Doubles

### Taxonomy

- **Dummy** -- passed around but not relevant for the test itself (satisfies a parameter)
- **Fake** -- has actual implementation but takes shortcuts (e.g., in-memory database)
- **Stub** -- provides canned return values
- **Spy** -- records what happened: what methods were (not) called
- **Mock** -- stub + spy combined

### State vs Behavior Testing

- **State testing** -- validate that a property has a certain value after an action
- **Behavior testing** -- validate that a method was (not) called

Prefer state testing when possible -- it couples tests to outcomes rather than implementation.

---

## Classicist over Mockist

- **Prefer sociable tests** -- use real implementations where possible
- Mock only **slow things** (database, filesystem, HTTP, network) and **awkward things** (payment systems, email, third-party APIs)
- Use real implementations for everything else -- business logic, mappers, validators
- What to mock depends on the level of test (unit vs integration)
- Tests should survive refactoring -- **test behavior, not implementation details**

| | Mockist / Solitary | Classicist / Sociable |
|---|---|---|
| Approach | Mock everything | Mock I/O and awkward things |
| Pro | Test complicated BL in isolation | Tests survive refactorings more easily |
| Risk | May test implementation instead of behavior | Danger of testing the same thing multiple times |

---

## Test Quality

- Each execution path tested ideally **once** -- avoid testing the same thing multiple times
- If something breaks, ideally **only one test fails** -- tests shouldn't cascade
- **Failures should be informative** -- a failing test tells you exactly what is wrong
- Avoid **tautological tests** -- don't just repeat the production code in the test
- Make sure your test **can fail** -- verify you're testing what you think you're testing
- Avoid **brittle tests** that break on refactoring

---

## Test Structure

Use the **Arrange / Act / Assert** (AAA) pattern, or equivalently **Given / When / Then** (GWT):

1. **Arrange** -- set up the system under test and its dependencies
2. **Act** -- invoke the behavior being tested
3. **Assert** -- verify the outcome

Don't add AAA/GWT as comments in every test -- the structure should be self-evident from whitespace separation.

---

## Common Pitfalls

- **Only test production code** -- don't test framework behavior, library internals, or your mocking setup
- **Make sure your test can fail** -- run it with a wrong assertion at least once to verify it's actually testing what you think
- **Avoid brittle tests** -- tests coupled to implementation details break on every refactor without catching real bugs
- **Failures should be informative** -- avoid opaque assertions on large collections; a failing test should tell you exactly what went wrong

---

## TDD

**Red -- Green -- Refactor:**

1. **Red** -- write a failing test for the next piece of behavior
2. **Green** -- write the simplest code that makes the test pass
3. **Refactor** -- clean up while keeping tests green

| Pros | Cons |
|---|---|
| Tests are actually written | May produce low-value tests if done mechanically |
| Forces thinking about design upfront | Initial slowdown on unfamiliar codebases |
| Guaranteed continuous progress | |
| Breaks the "cycle of fear" | |

---

## Legacy Code

### The Dilemma

> To change the code, we need tests. To test the code, we need to change it.

### Strategies for Tricky Code

- **Singletons** -- create an internal setter (or introduce an interface) so tests can substitute the instance
- **Service Locator** -- register stubs/fakes in the IoC container during test setup
- **Static methods** -- wrap behind an interface; switch to dependency injection where possible
