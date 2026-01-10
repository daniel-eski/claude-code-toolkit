---
paths: **/*.ts, **/*.tsx
---

# TypeScript Rules

Example path-specific rule file. This only applies to TypeScript files.

## Type Safety

- Prefer `unknown` over `any`
- Use strict null checks
- Define explicit return types for exported functions

## Patterns

- Use discriminated unions for state machines
- Prefer type inference for local variables
- Use `as const` for literal types

## Avoid

- Type assertions (`as`) without validation
- Non-null assertions (`!`) in production code
- `@ts-ignore` without explanation comment
