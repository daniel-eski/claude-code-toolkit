# Slash Commands Deep Dive

Slash commands are user-triggered prompts that run explicitly when typed.

## Command Types

| Type | Location | Scope |
|------|----------|-------|
| Built-in | N/A | `/help`, `/clear`, `/compact`, etc. |
| Project | `.claude/commands/` | Team (via git) |
| Personal | `~/.claude/commands/` | You, all projects |
| Plugin | `commands/` in plugin | Plugin users |
| MCP | From MCP servers | `/mcp__server__prompt` |

## Creating Custom Commands

```markdown
<!-- .claude/commands/review.md -->
---
description: Review code for quality issues
allowed-tools: Read, Grep
argument-hint: [file-or-directory]
---

Review the code at $ARGUMENTS for:
- Security vulnerabilities
- Performance issues
- Code style violations
```

## Frontmatter Options

| Field | Purpose |
|-------|---------|
| `description` | Brief description (shows in `/help`) |
| `allowed-tools` | Restrict available tools |
| `argument-hint` | Shows expected args in autocomplete |
| `model` | Force specific model |
| `disable-model-invocation` | Prevent SlashCommand tool from calling |

## Arguments

**All arguments** - `$ARGUMENTS`:
```
/fix-issue 123 high-priority
# $ARGUMENTS = "123 high-priority"
```

**Positional** - `$1`, `$2`, etc.:
```
/review-pr 456 high alice
# $1="456", $2="high", $3="alice"
```

## Special Features

**Bash execution** (prefix with `!`):
```markdown
---
allowed-tools: Bash(git:*)
---

## Context
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -5`

## Task
Create a commit based on staged changes.
```

**File references** (prefix with `@`):
```markdown
Review @src/utils.js and compare with @src/helpers.js
```

## Commands vs Skills

| Aspect | Commands | Skills |
|--------|----------|--------|
| Trigger | User types `/command` | Claude auto-detects |
| Complexity | Single file | Directory with resources |
| Discovery | Explicit | Semantic matching |
| Use case | Repeatable prompts | Domain expertise |

**Use commands for**: Quick prompts, explicit user control, simple triggers

**Use skills for**: Complex workflows, auto-discovery, multi-file resources

## Namespacing

Subdirectories create namespaced commands:
```
.claude/commands/frontend/deploy.md  → /deploy (project:frontend)
.claude/commands/backend/deploy.md   → /deploy (project:backend)
```

See also:
- `../decision-guides/skills-vs-commands.md` for detailed comparison
