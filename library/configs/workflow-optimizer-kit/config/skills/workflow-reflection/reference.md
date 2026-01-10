# Optimization Types Reference

Detailed documentation for each optimization type that workflow reflections can recommend.

## Contents

- [CLAUDE.md Additions](#claudemd-additions)
- [Custom Slash Commands](#custom-slash-commands)
- [Custom Skills](#custom-skills)
- [Automation Hooks](#automation-hooks)
- [Choosing the Right Type](#choosing-the-right-type)

---

## CLAUDE.md Additions

Persistent instructions added to memory files that shape Claude's behavior across sessions.

### When to Recommend

- Recurring conventions not discoverable from code
- Communication preferences that apply broadly
- Project-specific knowledge requiring repeated explanation
- Context that was missing and caused friction

### File Locations

| Location | Scope | Shared? |
|----------|-------|---------|
| `~/.claude/CLAUDE.md` | All your projects | No (personal) |
| `.claude/CLAUDE.md` | This project | Yes (git) |
| `CLAUDE.md` | This project | Yes (git) |
| `CLAUDE.local.md` | This project | No (gitignored) |

### Implementation Template

```markdown
## [Section Name]

[Concise, actionable instructions]
- Use bullet points for clarity
- Be specific, not vague
- Include examples where helpful
```

### Scope Decision Guide

| Use User-Level (`~/.claude/`) | Use Project-Level (`.claude/`) |
|-------------------------------|--------------------------------|
| Personal communication style | Team coding conventions |
| Cross-project preferences | Project-specific tech stack |
| Individual workflow habits | Repository structure info |
| Tool preferences | Shared testing patterns |

---

## Custom Slash Commands

Reusable prompt templates invoked with `/command-name`.

### When to Recommend

- Multi-step prompt used repeatedly during session
- Complex instructions needed each time for a task type
- User said "every time I do X, I need to explain Y"
- Workflow has consistent structure worth codifying

### File Locations

| Location | Scope | Label in /help |
|----------|-------|----------------|
| `~/.claude/commands/name.md` | Personal | (user) |
| `.claude/commands/name.md` | Project | (project) |

### Implementation Template

```markdown
---
description: Brief description shown in /help
argument-hint: <required> [optional]
---

# Command Title

[Instructions for Claude]

## Input
$ARGUMENTS

## Process
[Step-by-step instructions]
```

### Argument Patterns

**Single string** - Use `$ARGUMENTS`:
```markdown
Fix the bug described: $ARGUMENTS
```

**Structured input** - Use positional `$1`, `$2`:
```markdown
---
argument-hint: <pr-number> [priority]
---
Review PR #$1 with priority $2.
```

### Advanced Features

**Bash execution** - Capture context with `!` prefix:
```markdown
---
allowed-tools: Bash(git status:*)
---
Current status: !`git status --short`
```

**File references** - Include file content with `@`:
```markdown
Review @src/main.ts against our conventions.
```

---

## Custom Skills

Domain knowledge that auto-invokes when conversation context matches the description.

### When to Recommend

- Domain expertise needed repeatedly (API design, migrations, etc.)
- External knowledge not in codebase was required
- Capability should activate on context, not explicit invocation
- Complex analysis patterns emerged

### File Structure

```
~/.claude/skills/skill-name/
├── SKILL.md           # Required: main instructions
├── reference.md       # Optional: detailed docs
└── examples.md        # Optional: usage examples
```

### Implementation Template

```markdown
---
name: skill-name
description: >
  [Third-person description of what it does].
  [When it activates - include natural trigger phrases].
allowed-tools: Read, Glob, Grep
---

# Skill Title

[Concise instructions - keep under 500 lines]

## Instructions
[Step-by-step guidance]

## Additional Resources
See [reference.md](reference.md) for detailed documentation.
```

### Description Best Practices

**Must be third person** (critical for discovery):
- Good: "Analyzes database schemas and generates migration scripts."
- Bad: "Use this to analyze database schemas."
- Bad: "I can help you analyze database schemas."

**Include trigger phrases**:
```yaml
description: >
  Generates commit messages from staged changes. Activates when
  writing commits, reviewing diffs, or preparing code for push.
```

### Skill vs Command Decision

| Use a Skill | Use a Command |
|-------------|---------------|
| Should auto-invoke on context | Requires explicit invocation |
| Domain knowledge/expertise | Task-specific workflow |
| Background capability | Foreground action |
| "Know how to do X" | "Do X right now" |

---

## Automation Hooks

Scripts that run automatically in response to Claude Code events.

### When to Recommend

- Check should run automatically (lint, format, test)
- Validation needed before/after file changes
- Consistent cleanup required after certain operations
- Manual steps were forgotten during session

### Configuration Location

Add to `~/.claude/settings.json` or `.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "command",
        "command": "npm run lint --silent 2>&1 | head -20 || true"
      }]
    }]
  }
}
```

### Hook Events

| Event | Triggers When |
|-------|---------------|
| `PreToolUse` | Before a tool executes |
| `PostToolUse` | After a tool completes |

### Matcher Patterns

- `Write` - Matches Write tool
- `Edit` - Matches Edit tool
- `Write|Edit` - Matches either
- `Bash` - Matches any Bash command

### Implementation Guidelines

**Always include error handling**:
```bash
command || true          # Don't block on failure
command 2>/dev/null      # Suppress errors
command | head -20       # Limit output
```

**Only recommend hooks for**:
- Genuinely automatable checks with clear pass/fail
- Operations that won't significantly slow workflow
- Validations manually forgotten during session

**Avoid hooks for**:
- General guidance (use CLAUDE.md instead)
- Complex conditional logic
- Operations requiring user judgment

---

## Choosing the Right Type

### Decision Flowchart

```
Is this persistent context/preferences?
├─ Yes → CLAUDE.md
└─ No ↓

Should it auto-invoke based on context?
├─ Yes → Skill
└─ No ↓

Is it a repeated prompt pattern?
├─ Yes → Command
└─ No ↓

Is it an automatable check?
├─ Yes → Hook
└─ No → Probably not worth codifying
```

### Quick Reference

| Optimization Type | Activation | Best For |
|-------------------|------------|----------|
| CLAUDE.md | Always loaded | Conventions, preferences, context |
| Command | Explicit `/name` | Workflows, multi-step prompts |
| Skill | Auto on context match | Domain expertise, capabilities |
| Hook | Auto on tool events | Validation, formatting, checks |
