# .NET / C# Coding Conventions for AI Agents

Judgment calls only. Anything an analyzer or `.editorconfig` enforces is deliberately absent —
see the project's `.editorconfig`. For project-specific conventions, see the project's CLAUDE.md.

## Nullable

Do not use the null-forgiving operator (`!`) unless you justify why in a comment. Annotate
accurately — don't mark things nullable "just in case".

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

## Error Handling

Don't catch `Exception` except at top-level command handlers.

## Dependency Injection

- Constructor injection. No service locator, no resolving from `IServiceProvider` in business logic
- Lifetimes: **Transient** stateless, **Scoped** per-request/operation, **Singleton** thread-safe
  shared state, configuration, caches

## Configuration

Bind to strongly-typed classes and inject via DI. Don't read `IConfiguration` directly in services.

## LINQ

Avoid multiple enumeration of `IEnumerable<T>` — materialize when needed.
