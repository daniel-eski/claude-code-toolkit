# Skills Reference

Complete reference for Claude Code skills configuration.

## What Are Skills?

Skills are reusable knowledge and capabilities that Claude can invoke when relevant. They provide:
- Specialized instructions for specific task types
- Progressive disclosure (load details only when needed)
- Auto-discovery based on task context

## File Structure

```
.claude/skills/[skill-name]/
├── SKILL.md              # Required: Main skill file with frontmatter
├── reference.md          # Optional: Detailed reference docs
├── examples.md           # Optional: Usage examples
└── scripts/              # Optional: Utility scripts
    └── helper.py
```

**Locations (precedence order):**
1. Enterprise: System-wide managed skills
2. Personal: `~/.claude/skills/[name]/SKILL.md`
3. Project: `.claude/skills/[name]/SKILL.md`
4. Plugin: Bundled with plugins

## YAML Frontmatter

```yaml
---
name: skill-name
description: What this skill does and when to use it (max 1024 chars)
allowed-tools: Read, Grep, Glob
model: claude-sonnet-4-20250514
context: fork
agent: Explore
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate.sh"
          once: true
user-invocable: true
disable-model-invocation: false
---

# Skill Content

Your skill instructions in markdown...
```

## Field Reference

### Required Fields

| Field | Description | Constraints |
|-------|-------------|-------------|
| `name` | Unique identifier | Lowercase, alphanumeric + hyphens, max 64 chars |
| `description` | When to use this skill | Max 1024 chars, used for auto-discovery |

### Optional Fields

| Field | Description | Values |
|-------|-------------|--------|
| `allowed-tools` | Tools allowed when skill is active | Comma-separated or YAML list |
| `model` | Model to use | `sonnet`, `opus`, `haiku`, or specific model ID |
| `context` | Run in isolated context | `fork` (creates sub-agent context) |
| `agent` | Agent to use with context:fork | `Explore`, `Plan`, `general-purpose`, or custom |
| `hooks` | Skill-scoped hooks | PreToolUse, PostToolUse, Stop events |
| `user-invocable` | Show in slash menu | `true` (default) or `false` |
| `disable-model-invocation` | Hide from Skill tool | `true` or `false` (default) |

## allowed-tools Syntax

Two formats supported:

```yaml
# Comma-separated (traditional)
allowed-tools: Read, Grep, Glob, Bash(npm:*)

# YAML list (more readable)
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash(npm:*)
```

**Common tools:**
- `Read`, `Write`, `Edit` — File operations
- `Grep`, `Glob` — Search operations
- `Bash`, `Bash(pattern:*)` — Shell commands
- `WebFetch`, `WebSearch` — Web access
- `Task` — Spawn subagents

## Context Forking

When `context: fork` is set, the skill runs in an isolated sub-agent context:

```yaml
---
name: isolated-researcher
description: Research that doesn't pollute main context
context: fork
agent: Explore
---
```

**Use cases:**
- Research that generates lots of context
- Exploratory work that might not be needed
- Tasks that need different tool access

## Skill-Scoped Hooks

Skills can define hooks that only run when the skill is active:

```yaml
---
name: secure-skill
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/security-check.sh"
          once: true  # Run only once per session
---
```

**Supported events:** PreToolUse, PostToolUse, Stop

## Progressive Disclosure

Keep SKILL.md under 500 lines. Use supporting files for details:

```markdown
# SKILL.md

## Quick Start
[Essential instructions]

## When to Use
[Trigger conditions]

## Process
[Step-by-step workflow]

For complete API reference, see [reference.md](reference.md).
For examples, see [examples.md](examples.md).
```

**Key principle:** Supporting files don't consume tokens until accessed.

## Auto-Discovery

Claude uses the `description` field to decide when to invoke skills.

**Good description:**
```yaml
description: Extract text and tables from PDF files, fill forms, merge documents.
Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
```

**Bad description:**
```yaml
description: Helps with documents
```

**Include:**
- Specific capabilities (extract, fill, merge)
- Trigger terms users would say (PDF, forms)
- Context for when it applies

## Scripts

Scripts in the skill directory execute without loading into context:

```markdown
Validate the configuration:

```bash
python scripts/validate.py config.json
```
```

The script runs, only output enters context.

## Best Practices

1. **One skill = one responsibility** — Don't create master skills
2. **Write specific descriptions** — Include trigger terms
3. **Use progressive disclosure** — Details in supporting files
4. **Limit allowed-tools** — Only what the skill needs
5. **Test with real tasks** — Verify auto-discovery works
6. **Don't duplicate native knowledge** — Skills add YOUR context, not general knowledge

## Example: Complete Skill

```yaml
---
name: code-review
description: Review code for quality, security, and maintainability.
Use when reviewing PRs, assessing code changes, or when user asks for code review.
allowed-tools: Read, Grep, Glob, Bash(git diff:*)
---

# Code Review Skill

## When This Activates
- User asks to review code
- PR review requests
- Code quality assessments

## Review Process

1. **Understand scope** — What files changed?
2. **Check quality** — Readability, naming, patterns
3. **Check security** — Vulnerabilities, input validation
4. **Check tests** — Coverage, edge cases

## Checklist

See [checklist.md](checklist.md) for the full review checklist.

## Output Format

```
## Code Review Summary

**Files reviewed:** [list]

### Critical Issues
- [Issue with file:line and fix suggestion]

### Warnings
- [Issue with file:line and fix suggestion]

### Positive Notes
- [What was done well]
```
```
