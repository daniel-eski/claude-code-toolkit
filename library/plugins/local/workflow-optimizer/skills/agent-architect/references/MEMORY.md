# Memory Reference

Complete reference for Claude Code memory (CLAUDE.md, rules, imports).

## What Is Claude Memory?

Claude's "memory" is persistent context loaded at session start. It includes:
- Project knowledge and conventions
- Commands and workflows
- Architecture notes
- Rules and constraints

## Memory Hierarchy

Files are loaded in precedence order (higher = more authority):

### 1. Enterprise Policy (Highest)
System-wide policies managed by organization.

**Locations:**
- macOS: `/Library/Application Support/ClaudeCode/CLAUDE.md`
- Linux: `/etc/claude-code/CLAUDE.md`
- Windows: `C:\Program Files\ClaudeCode\CLAUDE.md`

### 2. Project Memory (Shared)
Committed to git, shared with team.

**Locations:**
- `./CLAUDE.md` (project root)
- `./.claude/CLAUDE.md`

### 3. Modular Rules
Path-specific rules with frontmatter.

**Location:** `./.claude/rules/*.md`

### 4. User Memory (Personal)
Personal preferences across all projects.

**Location:** `~/.claude/CLAUDE.md`

### 5. Project Local (Personal, Not Shared)
Personal notes for this project only. Auto-gitignored.

**Location:** `./CLAUDE.local.md`

## CLAUDE.md Best Practices

### Structure

```markdown
# Project Name

## Overview
[1-2 sentence description]

## Tech Stack
- Language: TypeScript 5.x
- Framework: Next.js 14
- Database: PostgreSQL with Prisma
- Testing: Jest + React Testing Library

## Key Commands
- `npm run dev` — Start development
- `npm test` — Run tests
- `npm run lint` — Lint code
- `npm run build` — Production build

## Architecture
- API routes in `/app/api/`
- Server actions for mutations
- Database via Prisma in `/lib/db`

## Conventions
- Named exports over default exports
- React components in PascalCase
- Utilities in camelCase
- Tests co-located as `*.test.ts`

## Off-Limits
- Do not modify `/generated/`
- Do not edit `.env` directly
- Do not bypass TypeScript strict mode
```

### Guidelines

1. **Be specific** — "Use 2-space indentation" not "Format code properly"
2. **Use structure** — Group related info under headings
3. **Include commands** — Build, test, lint, deploy
4. **Document conventions** — Naming, patterns, style
5. **Keep current** — Update as project evolves
6. **Be concise** — Loaded every session

## Modular Rules (.claude/rules/)

For path-specific rules, use `.claude/rules/*.md` with frontmatter:

```markdown
---
paths: src/**/*.ts
---

# TypeScript Rules

- Use strict mode
- No `any` without justification
- Prefer interfaces over types
```

```markdown
---
paths: tests/**/*
---

# Test Rules

- Use describe/it blocks
- Mock external dependencies
- Test edge cases
```

**How it works:**
- Rules apply only to files matching the `paths` glob
- Multiple rules files can exist
- More specific paths take precedence

## Imports (@path syntax)

Reference other files from CLAUDE.md:

```markdown
# Project Overview

See @README.md for detailed documentation.
See @package.json for available scripts.

## Architecture
See @docs/architecture.md for details.

## Personal Notes
@~/.claude/my-preferences.md
```

**Supported:**
- Relative paths: `@./docs/file.md`
- Absolute paths: `@/path/to/file.md`
- Home directory: `@~/.claude/file.md`
- Recursive (max 5 hops depth)

## Memory Scoping Guide

| Content Type | Where to Put It |
|--------------|-----------------|
| Team conventions | `.claude/CLAUDE.md` (committed) |
| Project architecture | `CLAUDE.md` (project root) |
| Path-specific rules | `.claude/rules/*.md` |
| Personal preferences | `~/.claude/CLAUDE.md` |
| Private project notes | `CLAUDE.local.md` |
| Enterprise policies | System CLAUDE.md |

## Template: Project CLAUDE.md

```markdown
# [Project Name]

## Overview
[Brief project description]

## Stack
- [Language/Framework]
- [Database]
- [Key dependencies]

## Commands
- `[cmd]` — [Description]
- `[cmd]` — [Description]

## Structure
```
src/
├── api/          # API routes
├── components/   # React components
├── lib/          # Utilities
└── types/        # TypeScript types
```

## Conventions
- [Convention 1]
- [Convention 2]

## Patterns
- [Pattern explanation]

## Do Not
- [Constraint]
- [Constraint]
```

## Template: Debugging Session

```markdown
# Debugging: [Issue Name]

## Problem
[Description of the bug]

## Error
```
[Exact error message/stack trace]
```

## Reproduction
1. [Step 1]
2. [Step 2]

## Tried
- [Approach 1]: [Result]
- [Approach 2]: [Result]

## Hypotheses
- [ ] [Hypothesis 1]
- [ ] [Hypothesis 2]

## Relevant Files
- `path/to/file.ts` — [Why relevant]
```

## Template: Refactoring Session

```markdown
# Refactoring: [Component Name]

## Goal
[What the refactoring achieves]

## Current State
[Problems with current implementation]

## Target State
[Desired outcome]

## Constraints
- Maintain backward compatibility with [X]
- Keep public API of [Y] unchanged
- Tests must pass

## Approach
1. [Phase 1]
2. [Phase 2]

## Scope
**In scope:**
- `path/to/file.ts`

**Out of scope:**
- `path/to/other.ts`
```

## Combining with Planning Files

When using `planning-with-files` skill, CLAUDE.md complements your planning files:

- **task_plan.md** — Current task phases and status
- **findings.md** — Discoveries for this task
- **CLAUDE.md** — Persistent project knowledge

After completing a task, consider promoting key findings to CLAUDE.md for future sessions.
