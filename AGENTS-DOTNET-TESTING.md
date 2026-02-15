# .NET Testing Conventions for AI Agents

Testing conventions for NUnit 4 + NSubstitute projects. Use Context7 MCP server to look up current API syntax before writing test code.

---

## Testing Philosophy

### FIRST Principles

- **Fast** — avoid I/O (database, filesystem, network) for unit tests
- **Independent** — tests should not interact with one another
- **Repeatable** — without code changes, results don't change
- **Self-Validating** — no manual verification steps
- **Thorough** — don't just test the happy path

### What to Test

- Happy path / sunny day scenario
- Branches (if/switch) — aim for branch coverage, not just line coverage
- Unhappy paths (guard clauses, exceptions)
- **Boundaries** — equivalence partitioning, boundary value analysis, edge cases
- Common / real world scenarios

### Classicist over Mockist

- **Prefer sociable tests** — use real implementations where possible
- Mock only **slow things** (database, filesystem, HTTP, network) and **awkward things** (payment systems, email, third-party APIs)
- Use real implementations for everything else — business logic, mappers, validators
- What to mock depends on the level of test (unit vs integration)
- Tests should survive refactoring — **test behavior, not implementation details**

### Test Quality

- Each execution path tested ideally **once** — avoid testing the same thing multiple times
- If something breaks, ideally **only one test fails** — tests shouldn't cascade
- **Failures should be informative** — a failing test tells you exactly what is wrong
- Avoid **tautological tests** — don't just repeat the production code in the test
- Make sure your test **can fail** — verify you're testing what you think you're testing
- Avoid **brittle tests** that break on refactoring

### TestContainers

- Use **TestContainers** for integration tests needing real infrastructure (database, message broker, cache)
- Prefer real containers over in-memory fakes (e.g., real PostgreSQL over SQLite/in-memory EF)
- Share containers across test classes with `[OneTimeSetUp]` to avoid startup overhead

---

## Test Project Setup

- Package references: `NUnit`, `NUnit3TestAdapter`, `Microsoft.NET.Test.Sdk`, `NSubstitute`, `Testcontainers` (for integration tests)
- File-scoped namespaces matching the tested type's namespace: `MyApp.Tests.Services`

## Test Naming

Use the pattern: **`MethodName_Scenario_ExpectedResult`**

```csharp
[Test]
public void Calculate_NegativeQuantity_ThrowsArgumentException()
[Test]
public void Calculate_ValidOrder_ReturnsTotalWithTax()
[Test]
public async Task GetOrderAsync_NonExistentId_ReturnsNull()
```

## Test Structure

Arrange / Act / Assert — don't add these as comments in every test:

```csharp
[Test]
public void Discover_TwoModulesInDirectory_ReturnsBoth()
{
    var fileSystem = Substitute.For<IFileSystem>();
    fileSystem.GetDirectories(Arg.Any<string>())
        .Returns(new[] { "/config/git", "/config/vscode" });
    var discovery = new ModuleDiscovery(fileSystem);

    var modules = discovery.Discover("/config");

    Assert.That(modules, Has.Count.EqualTo(2));
    Assert.That(modules[0].Name, Is.EqualTo("git"));
}
```

## Test Organization

- One test class per production class: `OrderServiceTests` for `OrderService`
- Use `[TestFixture]` on all test classes
- Use `[SetUp]` for shared arrangement that most tests need
- **`[TestCase]` only for special cases** — when many inputs map to the same behavior (e.g., various invalid inputs all producing the same error). Prefer separate named tests because the test name documents the scenario and expected outcome, which is lost with parameterization

---

## NUnit 4 — Key Guidance

**Use the constraint model exclusively.** Classic assertions (`Assert.AreEqual`, `Assert.IsTrue`, etc.) have been moved to `NUnit.Framework.Legacy` — do not use them for new code.

```csharp
// Always use Assert.That with constraints
Assert.That(actual, Is.EqualTo(expected));
Assert.That(result, Is.Not.Null);
Assert.That(list, Has.Count.EqualTo(3));

// Async — use Assert.ThatAsync, not Assert.That with .Result
await Assert.ThatAsync(() => service.ProcessAsync(), Throws.TypeOf<InvalidOperationException>());

// Group related assertions — all are evaluated even if one fails
Assert.Multiple(() =>
{
    Assert.That(order.Id, Is.EqualTo(1));
    Assert.That(order.Status, Is.EqualTo(OrderStatus.Active));
    Assert.That(order.Total, Is.GreaterThan(0));
});
```

For specific constraint syntax (`Is.*`, `Has.*`, `Does.*`, `Throws.*`), use **Context7 MCP server** to look up the current NUnit API.

---

## NSubstitute — Key Guidance

Create substitutes for interfaces, configure returns, and verify calls:

```csharp
var repo = Substitute.For<IOrderRepository>();

// Configure returns
repo.GetByIdAsync(Arg.Any<int>(), Arg.Any<CancellationToken>())
    .Returns(new Order { Id = 1 });

// Verify calls
repo.Received(1).GetByIdAsync(1, Arg.Any<CancellationToken>());
repo.DidNotReceive().DeleteAsync(Arg.Any<int>());
```

For specific patterns (`Arg.*` matchers, `Returns`, `Throws`, `When/Do`, `Received.InOrder`), use **Context7 MCP server** to look up the current NSubstitute API.
