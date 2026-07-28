# .NET / C# Coding Conventions for AI Agents

Judgment calls only. Anything an analyzer or `.editorconfig` enforces is deliberately absent —
see the project's `.editorconfig`. For project-specific conventions, see the project's CLAUDE.md.

## Nullable

Do not use the null-forgiving operator (`!`) unless you justify why in a comment. Annotate
accurately — don't mark things nullable "just in case".

## Records vs Classes

- **Records** for immutable data/DTOs: API responses, configuration values, query results
- **Classes** for stateful objects with behavior: services, engines, providers
- **Record structs** for small value-type DTOs (2-3 fields max)
- **Primary constructors** are optional — avoid for complex classes

## XML Doc Comments

Only on public API surfaces where the name alone doesn't convey enough — non-obvious parameters,
edge cases, exceptions thrown, interface contracts. Never restate the method name.

```csharp
/// <summary>Gets the order.</summary>                    // adds nothing
/// <summary>
/// Returns the order with all line items eagerly loaded.
/// Throws <see cref="OrderNotFoundException"/> if the order does not exist.
/// </summary>                                            // explains non-obvious behaviour
public Order GetOrder(int id) { }
```

Inline comments: see the comment policy in CLAUDE.md.

## Error Handling

- Don't catch `Exception` except at top-level command handlers
- Guard clauses to fail fast: `ArgumentException.ThrowIfNullOrEmpty(input)`
- For expected failures (validation, parsing), consider a result type instead of throwing

## Async

Prefer `Task` over `ValueTask` unless the method frequently completes synchronously.

## Dependency Injection

- Constructor injection. No service locator, no resolving from `IServiceProvider` in business logic
- Program against interfaces
- Lifetimes: **Transient** stateless, **Scoped** per-request/operation, **Singleton** thread-safe
  shared state, configuration, caches

## Strings

Raw string literals (`"""..."""`) for multi-line strings or strings containing quotes.

## Logging

- `ILogger<T>` — never `Console.WriteLine` in library/service code
- Levels: Trace (verbose diagnostics), Debug (development), Information (normal flow),
  Warning (unexpected but handled), Error (failures), Critical (app-breaking)

## Configuration

Bind to strongly-typed classes and inject via DI. Don't read `IConfiguration` directly in services.

## LINQ

- Method syntax over query syntax
- Avoid multiple enumeration of `IEnumerable<T>` — materialize when needed
- `ToArray()` when the collection is final, `ToList()` when you need to mutate it
