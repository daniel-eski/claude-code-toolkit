# Workflow Reflection Examples

Concrete examples of friction points and their recommended optimizations.

## Contents

- [Example 1: Missing Project Context](#example-1-missing-project-context)
- [Example 2: Repeated Review Process](#example-2-repeated-review-process)
- [Example 3: Domain Expertise Gap](#example-3-domain-expertise-gap)
- [Example 4: Forgotten Validation Steps](#example-4-forgotten-validation-steps)
- [Anti-Patterns to Avoid](#anti-patterns-to-avoid)

---

## Example 1: Missing Project Context

### Friction Observed
Claude asked multiple clarifying questions about the project's testing framework, database conventions, and file structure before making changes.

### Analysis
- 3 back-and-forth exchanges to establish context
- Information was project-specific, not discoverable from code
- Same context would be needed in future sessions

### Recommendation

**Type**: CLAUDE.md Addition
**Scope**: Project-level (`.claude/CLAUDE.md`)
**Rationale**: Persistent context eliminates repeated explanations

**Implementation**:
```markdown
## Project Conventions

### Testing
- Framework: Jest with React Testing Library
- Files: `*.test.ts` adjacent to source files
- Pattern: "should [behavior] when [condition]"

### Database
- ORM: Prisma with PostgreSQL
- Naming: snake_case columns, [table]_id foreign keys
- Migrations: `npm run db:migrate`

### Structure
- Components: src/components/[Feature]/
- API routes: src/pages/api/[resource]/
- Shared types: src/types/
```

---

## Example 2: Repeated Review Process

### Friction Observed
User repeatedly typed detailed code review instructions across multiple sessions, always requesting the same checks: security, performance, and test coverage.

### Analysis
- Same prompt structure used 5+ times
- Consistent output format expected each time
- Could be invoked with a simple command

### Recommendation

**Type**: Custom Command
**Scope**: User-level (`~/.claude/commands/review.md`)
**Rationale**: Codifies repeated multi-step prompt into single invocation

**Implementation**:
```markdown
---
description: Comprehensive code review with security, performance, and coverage checks
argument-hint: <file-or-staged>
---

# Code Review

Review the specified target for quality issues.

## Target
$ARGUMENTS

If "staged" specified, review git staged changes.

## Checks Required
1. **Security**: Injection, auth bypass, data exposure
2. **Performance**: N+1 queries, memory leaks, unnecessary computation
3. **Coverage**: Missing test cases, edge conditions

## Output Format
| Severity | Location | Issue | Suggested Fix |
|----------|----------|-------|---------------|
| Critical/Warning/Info | file:line | Description | How to fix |
```

---

## Example 3: Domain Expertise Gap

### Friction Observed
When working on database migrations, Claude made assumptions about schema changes that conflicted with the team's migration philosophy (immutable migrations, no destructive changes in production).

### Analysis
- Domain knowledge not in codebase
- Applies whenever touching migrations
- Should auto-activate based on context, not explicit invocation

### Recommendation

**Type**: Custom Skill
**Scope**: User-level (`~/.claude/skills/database-migrations/`)
**Rationale**: Domain expertise that auto-invokes when context matches

**Implementation** (`SKILL.md`):
```markdown
---
name: database-migrations
description: >
  Guides safe database migration practices. Ensures immutable migrations,
  prevents destructive production changes, and validates rollback strategies.
  Activates when creating migrations, modifying schemas, or discussing
  database changes.
allowed-tools: Read, Glob, Grep
---

# Database Migration Guidelines

## Core Principles
- Migrations are immutable once deployed
- Never modify or delete existing migrations
- Always provide rollback strategy

## Creating New Migrations
1. Generate with timestamp: `npm run db:migrate:create`
2. Review for destructive operations
3. Test rollback locally before committing

## Forbidden in Production
- DROP TABLE/COLUMN without data backup plan
- ALTER COLUMN with data loss potential
- DELETE without WHERE clause verification
```

---

## Example 4: Forgotten Validation Steps

### Friction Observed
After editing TypeScript files, Claude didn't run type checking, leading to type errors discovered later in the workflow.

### Analysis
- Type check should run automatically after edits
- Manual reminder was forgotten
- Clear pass/fail criteria exists

### Recommendation

**Type**: Automation Hook
**Scope**: Project-level (`.claude/settings.json`)
**Rationale**: Automated check ensures consistent validation

**Implementation**:
```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "command",
        "command": "npx tsc --noEmit 2>&1 | head -20 || true"
      }]
    }]
  }
}
```

---

## Anti-Patterns to Avoid

### Don't Over-Engineer

**Bad**: Creating a skill for a one-time task
```markdown
# Bad: Single-use skill
---
name: fix-login-bug-january
description: Fixes the specific login bug from January 2024
---
```

**Good**: Only codify patterns with clear, repeatable value

---

### Don't Duplicate Built-in Capabilities

**Bad**: Command that just wraps git
```markdown
---
description: Show git status
---
Run git status and explain the output.
```

**Good**: Commands should add significant value beyond what Claude does by default

---

### Don't Create Vague Instructions

**Bad**: Vague CLAUDE.md entry
```markdown
## Code Quality
Write good code. Follow best practices. Be careful.
```

**Good**: Specific, actionable instructions
```markdown
## Code Quality
- Max function length: 50 lines
- Extract repeated code after 2 occurrences
- Prefer composition over inheritance
```

---

### Don't Over-Specify Scope

**Bad**: Overly narrow skill activation
```markdown
description: >
  Only activates when user types exactly "help me with migrations"
```

**Good**: Natural trigger phrases
```markdown
description: >
  Guides database migrations. Activates when creating migrations,
  modifying schemas, discussing database changes, or planning data model updates.
```

---

## Recommendation Quality Checklist

Before recommending an optimization, verify:

- [ ] **Repeatable**: Will this be useful more than once?
- [ ] **Specific**: Are instructions actionable, not vague?
- [ ] **Appropriate type**: Does activation method match use case?
- [ ] **Correct scope**: Personal vs team-shared decision made?
- [ ] **Minimal**: Is this the simplest solution that works?
