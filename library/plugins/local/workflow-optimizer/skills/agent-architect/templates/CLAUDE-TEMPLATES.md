# CLAUDE.md Templates

Ready-to-use templates for different project types and situations.

---

## General Project Template

```markdown
# [Project Name]

## Overview
[1-2 sentence project description]

## Tech Stack
- Language: [e.g., TypeScript 5.x]
- Framework: [e.g., Next.js 14]
- Database: [e.g., PostgreSQL with Prisma]
- Testing: [e.g., Jest + React Testing Library]

## Key Commands
- `npm run dev` — Start development server
- `npm test` — Run tests
- `npm run lint` — Run linter
- `npm run build` — Production build

## Project Structure
```
src/
├── app/          # Next.js app router
├── components/   # React components
├── lib/          # Utilities and helpers
├── types/        # TypeScript types
└── tests/        # Test files
```

## Architecture Notes
- [Key pattern, e.g., "API routes in /app/api/"]
- [Important convention, e.g., "Server actions for mutations"]

## Conventions
- [Style note, e.g., "Named exports over default exports"]
- [Naming, e.g., "Components: PascalCase, utilities: camelCase"]
- [Testing, e.g., "Co-locate tests as *.test.ts"]

## Off-Limits
- Do not modify files in `/generated/`
- Do not edit `.env` files directly
- Do not bypass TypeScript strict mode
```

---

## API/Backend Project Template

```markdown
# [API Name]

## Overview
[API description and purpose]

## Stack
- Runtime: Node.js 20
- Framework: Express/Fastify/Hono
- Database: PostgreSQL
- ORM: Prisma/Drizzle

## Commands
- `npm run dev` — Development with hot reload
- `npm test` — Run tests
- `npm run db:migrate` — Run migrations
- `npm run db:seed` — Seed database

## API Structure
```
src/
├── routes/       # API endpoints
├── services/     # Business logic
├── models/       # Data models
├── middleware/   # Express middleware
└── utils/        # Helpers
```

## Endpoints
- `GET /api/v1/users` — List users
- `POST /api/v1/users` — Create user
- [Add more as needed]

## Database
- Migrations in `/prisma/migrations/`
- Schema in `/prisma/schema.prisma`

## Authentication
[Describe auth mechanism]

## Error Handling
[Describe error response format]

## Off-Limits
- Do not commit `.env`
- Do not modify migration files after deployment
```

---

## Frontend Project Template

```markdown
# [App Name]

## Overview
[Frontend app description]

## Stack
- Framework: React 18 / Next.js 14
- Styling: Tailwind CSS
- State: Zustand / React Query
- Testing: Vitest + Testing Library

## Commands
- `npm run dev` — Start dev server (localhost:3000)
- `npm test` — Run tests
- `npm run storybook` — Component playground
- `npm run build` — Production build

## Structure
```
src/
├── app/          # Routes (Next.js)
├── components/
│   ├── ui/       # Generic UI components
│   └── features/ # Feature-specific components
├── hooks/        # Custom hooks
├── lib/          # Utilities
└── stores/       # State management
```

## Component Guidelines
- Use composition over inheritance
- Props interface above component
- Extract logic to custom hooks

## Styling
- Use Tailwind utility classes
- Custom styles in component CSS modules
- Design tokens in `tailwind.config.js`

## Testing
- Unit tests for utilities
- Component tests for UI
- Integration tests for pages

## Off-Limits
- Do not use inline styles
- Do not install additional CSS frameworks
```

---

## CLI Tool Template

```markdown
# [CLI Name]

## Overview
[What this CLI does]

## Stack
- Language: TypeScript / Go / Rust
- Parsing: Commander / Cobra / Clap

## Commands
- `npm run build` — Compile
- `npm run dev` — Development with watch
- `npm test` — Run tests
- `npm link` — Install locally

## Usage
```bash
mycli <command> [options]

Commands:
  init        Initialize configuration
  run         Run the main process
  config      Manage configuration

Options:
  -h, --help  Show help
  -v, --version  Show version
```

## Structure
```
src/
├── commands/     # Command implementations
├── lib/          # Core logic
├── utils/        # Helpers
└── index.ts      # Entry point
```

## Configuration
- Config file: `~/.mycli/config.json`
- Env vars: `MYCLI_*`

## Testing
- Unit tests for each command
- Integration tests for CLI flow
```

---

## Debugging Session Template

```markdown
# Debugging: [Issue Name]

## Problem
[Clear description of the bug]

## Error
```
[Exact error message and stack trace]
```

## Reproduction
1. [Step 1]
2. [Step 2]
3. [Expected vs actual behavior]

## Environment
- OS: [e.g., macOS 14]
- Node: [e.g., 20.10.0]
- Browser: [if applicable]

## Already Tried
- [Approach 1]: [Result]
- [Approach 2]: [Result]

## Hypotheses
- [ ] [Hypothesis 1]
- [ ] [Hypothesis 2]

## Relevant Files
- `path/to/file.ts:123` — [Why relevant]
- `path/to/other.ts` — [Why relevant]

## Notes
[Any additional context]
```

---

## Refactoring Session Template

```markdown
# Refactoring: [Component/System]

## Goal
[What the refactoring achieves]

## Current Problems
- [Problem 1]
- [Problem 2]

## Target State
[What the code should look like after]

## Constraints
- Must maintain backward compatibility with [X]
- Public API of [Y] cannot change
- Tests must continue to pass

## Approach
1. [Phase 1: What changes]
2. [Phase 2: What changes]
3. [Phase 3: Validation]

## In Scope
- `path/to/file1.ts`
- `path/to/file2.ts`

## Out of Scope
- `path/to/other.ts` — [Why excluded]

## Risks
- [Risk and mitigation]
```

---

## Monorepo Template

```markdown
# [Monorepo Name]

## Overview
[Description of the monorepo]

## Packages
- `packages/core` — Core utilities
- `packages/ui` — UI components
- `apps/web` — Web application
- `apps/api` — API server

## Commands (Root)
- `npm run dev` — Start all in dev mode
- `npm run build` — Build all packages
- `npm run test` — Test all packages
- `npm run lint` — Lint all packages

## Package Commands
```bash
# Work on specific package
npm run dev --workspace=packages/ui
npm test --workspace=apps/web
```

## Structure
```
/
├── packages/
│   ├── core/
│   └── ui/
├── apps/
│   ├── web/
│   └── api/
├── package.json      # Root package
└── turbo.json        # Turborepo config
```

## Dependencies
- Shared deps in root `package.json`
- Package-specific deps in package `package.json`
- Use workspace protocol: `"@repo/ui": "workspace:*"`

## Conventions
- All packages use TypeScript
- Shared config in `/packages/config`
- Consistent naming across packages
```

---

## Integration Note

When using with `planning-with-files`, consider:
- Moving task-specific context to `task_plan.md`
- Keeping only persistent project knowledge in `CLAUDE.md`
- Promoting key findings to `CLAUDE.md` after task completion
