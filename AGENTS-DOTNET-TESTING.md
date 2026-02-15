# .NET Testing Conventions for AI Agents

.NET-specific testing conventions for NUnit 4 + NSubstitute projects. For universal testing philosophy, see `AGENTS-TESTING.md`.

Use Context7 MCP server to look up current API syntax before writing test code.

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

Arrange / Act / Assert -- don't add these as comments in every test:

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
- **`[TestCase]` only for special cases** -- when many inputs map to the same behavior (e.g., various invalid inputs all producing the same error). Prefer separate named tests because the test name documents the scenario and expected outcome, which is lost with parameterization

---

## NUnit 4 -- Key Guidance

**Use the constraint model exclusively.** Classic assertions (`Assert.AreEqual`, `Assert.IsTrue`, etc.) have been moved to `NUnit.Framework.Legacy` -- do not use them for new code.

```csharp
// Always use Assert.That with constraints
Assert.That(actual, Is.EqualTo(expected));
Assert.That(result, Is.Not.Null);
Assert.That(list, Has.Count.EqualTo(3));

// Async -- use Assert.ThatAsync, not Assert.That with .Result
await Assert.ThatAsync(() => service.ProcessAsync(), Throws.TypeOf<InvalidOperationException>());

// Group related assertions -- all are evaluated even if one fails
Assert.Multiple(() =>
{
    Assert.That(order.Id, Is.EqualTo(1));
    Assert.That(order.Status, Is.EqualTo(OrderStatus.Active));
    Assert.That(order.Total, Is.GreaterThan(0));
});
```

For specific constraint syntax (`Is.*`, `Has.*`, `Does.*`, `Throws.*`), use **Context7 MCP server** to look up the current NUnit API.

---

## NSubstitute -- Key Guidance

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

---

## TestContainers

- Use **TestContainers** for integration tests needing real infrastructure (database, message broker, cache)
- Prefer real containers over in-memory fakes (e.g., real PostgreSQL over SQLite/in-memory EF)
- Share containers across test classes with `[OneTimeSetUp]` to avoid startup overhead
