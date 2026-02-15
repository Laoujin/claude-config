# .NET / C# Coding Conventions for AI Agents

General conventions for C#/.NET code. For project-specific conventions, see the project's CLAUDE.md.

---

## Naming Conventions

| Element | Style | Example |
|---------|-------|---------|
| Namespace | PascalCase | `MyApp.Services` |
| Class / Struct / Record | PascalCase | `OrderService` |
| Interface | `I` + PascalCase | `IOrderRepository` |
| Method | PascalCase | `GetActiveOrders` |
| Property | PascalCase | `TotalAmount` |
| Event | PascalCase | `OrderPlaced` |
| Public field | PascalCase | `MaxRetries` (prefer properties) |
| Private field | `_camelCase` | `_orderRepository` |
| Parameter | camelCase | `orderId` |
| Local variable | camelCase | `itemCount` |
| Constant | PascalCase | `DefaultPageSize` |
| Type parameter | `T` + PascalCase | `TResult` |
| Enum | PascalCase (type and values) | `OrderStatus.Pending` |
| Async method suffix | `Async` | `GetOrdersAsync` |

## File Organization

- **At least one type per file must match the file name** (`OrderService.cs` contains `OrderService`)
- Small closely-related types (e.g., a record and its companion enum) may share a file
- **Folder structure mirrors namespaces.** `MyApp.Services` -> `src/MyApp/Services/`

## Using Directives

- Use `ImplicitUsings=enable` in project settings — the SDK provides common global usings automatically
- Add a `GlobalUsings.cs` per project only for additional project-wide usings if needed
- Keep project-specific and third-party `using` directives in individual files
- Place `using` directives **outside** the namespace
- Use `using` aliases sparingly — only to resolve ambiguity

## Nullable Reference Types

- **Enabled project-wide** (`<Nullable>enable</Nullable>`)
- Do **not** use the null-forgiving operator (`!`) unless you can justify why in a comment
- Prefer null checks, `??` / `??=` over suppression
- Annotate parameters and return types accurately — don't mark things nullable "just in case"

## Type Declarations

### `var` Usage

Use `var` when the type is obvious from context — `new`, method name, or readability:

```csharp
var service = new OrderService();               // obvious: new
var orders = GetActiveOrders();                  // obvious: method name implies List<Order>
var stream = File.OpenRead(path);               // obvious: returns a stream
var result = Process(input);                    // NOT obvious: what is result?
OperationResult result = Process(input);        // better

// var acceptable to keep long lines readable
var thing = serviceProvider.GetRequiredService<ISomeVeryLongGenericInterface<Foo, Bar>>();
```

### Records vs Classes

- **Records** for immutable data/DTOs: API responses, configuration values, query results
  ```csharp
  public record OrderSummary(int Id, string CustomerName, decimal Total);
  ```
- **Classes** for stateful objects with behavior: services, engines, providers
- **Record structs** for small, value-type DTOs (2-3 fields max)
- **Primary constructors** can be used for simple classes — not mandatory, especially for complex classes

### Pattern Matching

Prefer pattern matching for type checks:

```csharp
// Good
if (result is SuccessResult success)
    Log(success.Message);

// Good — switch expressions for simple mappings (not mandatory)
return status switch
{
    Status.Active   => "Active",
    Status.Inactive => "Inactive",
    _               => "Unknown"
};

// Avoid
if (result is SuccessResult)
    Log(((SuccessResult)result).Message);
```

### Null Comparisons

Use `==` / `!=` for null checks by default. `is null` / `is not null` is allowed when operator overloading is a concern.

## Expression-Bodied Members

Use expression-bodied members for single-expression methods and properties:

```csharp
public string FullPath => Path.Combine(_basePath, RelativePath);
public override string ToString() => $"{Name} ({Status})";
```

Don't use them for methods with side effects or complex logic — use block bodies instead.

## String Handling

- Use **string interpolation** (`$"..."`) over `string.Format` or concatenation
- Use **raw string literals** (`"""..."""`) for multi-line strings or strings containing quotes
- For case-insensitive comparison: `ToLowerInvariant()` or `StringComparison.OrdinalIgnoreCase` — both fine. Avoid culture-sensitive `ToLower()`

## File-Scoped Namespaces

Use `namespace MyApp.Services;` (file-scoped), not block-scoped.

## Sealed by Default

Mark classes `sealed` unless they are explicitly designed for inheritance.

---

## Comments & Documentation

### XML Doc Comments

- Add XML docs **only** on public API surfaces where the name alone doesn't convey enough:
  - Non-obvious parameters, edge cases, exceptions thrown
  - Interface methods that define a contract
- **Do not** add XML docs that restate the method name:
  ```csharp
  // Bad — adds nothing
  /// <summary>Gets the order.</summary>
  public Order GetOrder(int id) { }

  // Good — explains non-obvious behavior
  /// <summary>
  /// Returns the order with all line items eagerly loaded.
  /// Throws <see cref="OrderNotFoundException"/> if the order does not exist.
  /// </summary>
  public Order GetOrder(int id) { }
  ```

### Inline Comments

- Comments explain **why**, not **what**
- No `// TODO` without a linked GitHub issue: `// TODO(#42): Handle rate limiting`
- No commented-out code — delete it; git has history
- No `// end if`, `// end for`, etc.
- **Don't remove existing useful comments** — if a comment explains non-obvious reasoning, keep it

---

## Complexity & Analyzers

### Project Settings

All projects should set:

```xml
<PropertyGroup>
    <TreatWarningsAsErrors>true</TreatWarningsAsErrors>
    <EnforceCodeStyleInBuild>true</EnforceCodeStyleInBuild>
    <AnalysisLevel>latest</AnalysisLevel>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
</PropertyGroup>
```

- `EnforceCodeStyleInBuild` ensures `.editorconfig` style rules are enforced at build time, not just in IDEs
- `AnalysisLevel` set to `latest` enables the newest analyzer rules for the target SDK

### Analyzers

- **Roslynator.Analyzers** (RCS1xxx) — C# code style, simplification, readability, redundancy, performance patterns
- **Roslynator.Formatting.Analyzers** (RCS0xxx) — whitespace and formatting rules
- **Microsoft.CodeAnalysis.NetAnalyzers** (CA/IDE rules) — security, design, performance, complexity (included by default in .NET 5+)

These are complementary with minimal overlap. Fix all warnings — do not suppress without justification.

Configure Roslynator rules in `.editorconfig`:
```ini
# Set baseline severity for all Roslynator rules
dotnet_analyzer_diagnostic.category-roslynator.severity = suggestion

# Promote important rules to warning
dotnet_diagnostic.RCS1018.severity = warning   # Add accessibility modifiers
dotnet_diagnostic.RCS1077.severity = warning   # Optimize LINQ method call
dotnet_diagnostic.RCS1198.severity = warning   # Avoid unnecessary boxing
```

### Cyclomatic Complexity

- Target: **max 17** per method
- Enforced via **CA1502** (`Microsoft.CodeAnalysis.NetAnalyzers`) — defaults to 25, configure to 17
- Enable in `.editorconfig`: `dotnet_diagnostic.CA1502.severity = warning`
- If a method exceeds the limit, refactor by extracting well-named helper methods

### .editorconfig

Projects should include a `.editorconfig`. Generate with `dotnet new editorconfig` as a starting point, then customize. A reference `.editorconfig` is available at `~/.claude/dotnet.editorconfig`.

---

## Error Handling

- Use **specific exception types** — `FileNotFoundException`, `InvalidOperationException`, `ArgumentException`, etc.
- **Don't catch just to rethrow** — only catch if you're adding context:
  ```csharp
  // Bad — pointless
  try { DoWork(); }
  catch (Exception ex) { throw; }

  // Acceptable — adding context
  try { DoWork(); }
  catch (IOException ex) { throw new ProcessingException($"Failed to process {item.Name}", ex); }
  ```
- **No empty catch blocks** — ever. If you must swallow, log and explain why
- **Don't catch `Exception`** at low levels — only at top-level command handlers
- Use **guard clauses** to fail fast:
  ```csharp
  public void Process(string input)
  {
      ArgumentException.ThrowIfNullOrEmpty(input);
      // ...
  }
  ```
- For expected failures (validation, parsing), consider returning a **result type** instead of throwing. Use exceptions for truly exceptional conditions

---

## Async

- **Async all the way** — never use `.Result`, `.Wait()`, or `.GetAwaiter().GetResult()`
- Every `async` method must have the `Async` suffix
- Thread `CancellationToken` through all public API methods:
  ```csharp
  public async Task<Order> GetOrderAsync(int id, CancellationToken cancellationToken = default)
  {
      cancellationToken.ThrowIfCancellationRequested();
      // ...
  }
  ```
- **Library projects:** Use `ConfigureAwait(false)` on all `await` calls to avoid capturing the synchronization context
- **Application projects:** Do **not** use `ConfigureAwait(false)` — let the default context flow
- Prefer `Task` over `ValueTask` unless the method frequently completes synchronously (e.g., cached lookups)

---

## Dependency Injection

- **Constructor injection** — the default. No service locator pattern
- Program against interfaces, not implementations
- Register services with appropriate lifetimes:
  - **Transient** — lightweight, stateless services
  - **Scoped** — per-request (web) or per-operation
  - **Singleton** — thread-safe shared state, configuration, caches
- Don't resolve services from `IServiceProvider` directly in business logic

## Logging

- Use `ILogger<T>` — never `Console.WriteLine` in library/service code
- Use **message templates**, not string interpolation:
  ```csharp
  // Good — structured logging, parameters captured as structured data
  logger.LogInformation("Order {OrderId} placed by {CustomerId}", orderId, customerId);

  // Bad — interpolation prevents structured logging
  logger.LogInformation($"Order {orderId} placed by {customerId}");
  ```
- Use appropriate log levels: Trace (verbose diagnostics), Debug (development), Information (normal flow), Warning (unexpected but handled), Error (failures), Critical (app-breaking)

## Configuration

- Bind settings to **strongly-typed classes** and inject via DI
- Don't read `IConfiguration` directly in services

## LINQ

- Prefer LINQ over manual loops for filtering, projecting, and aggregating
- **Method syntax** preferred over query syntax
- Avoid multiple enumeration of `IEnumerable<T>` — materialize when needed
- `ToArray()` when the collection is final (nothing will be added/removed), `ToList()` when you need to mutate the collection
