# Subagents Deep Dive

Subagents are specialized AI assistants with isolated context windows for task-specific work.

## Context Isolation (Key Concept)

```
MAIN CONVERSATION                    SUBAGENT
┌─────────────────┐                 ┌─────────────────┐
│ Full history    │                 │ FRESH context   │
│ All loaded      │  ──Prompt──▶    │ Only receives   │
│ skills/memory   │                 │ what's passed   │
│                 │  ◀──Summary──   │                 │
│ Continues with  │                 │ Work doesn't    │
│ summary only    │                 │ pollute main    │
└─────────────────┘                 └─────────────────┘
```

**Information flows IN via prompt only. Returns summary only.**

## Subagent Configuration

```yaml
# .claude/agents/my-agent.md
---
name: my-agent
description: When to invoke this agent
tools: Read, Grep, Bash  # Optional: restrict tools
model: sonnet  # sonnet|opus|haiku|inherit
permissionMode: default  # Permission handling
skills: skill1, skill2  # Pre-load skills
---

System prompt for the subagent...
```

## Configuration Fields

| Field | Required | Purpose |
|-------|----------|---------|
| `name` | Yes | Unique identifier (lowercase, hyphens) |
| `description` | Yes | When to invoke - "proactively" triggers automatic use |
| `tools` | No | Restrict tools (inherits all if omitted) |
| `model` | No | sonnet (default), opus, haiku, or inherit |
| `permissionMode` | No | default, acceptEdits, dontAsk, bypassPermissions |
| `skills` | No | Skills to pre-load (NOT inherited from main) |

## Built-in Subagents

| Subagent | Model | Tools | Purpose |
|----------|-------|-------|---------|
| **Explore** | Haiku | Read, Grep, Glob, Bash (read-only) | Fast codebase search |
| **Plan** | Sonnet | Read, Glob, Grep, Bash | Research for plan mode |
| **General-purpose** | Sonnet | All | Complex multi-step tasks |

## Subagent Locations

| Type | Location | Priority |
|------|----------|----------|
| Project | `.claude/agents/` | Highest |
| CLI-defined | `--agents` flag | Medium |
| User | `~/.claude/agents/` | Lower |
| Plugin | `agents/` in plugin | Lowest |

## Invoking Subagents

**Automatic**: Claude matches task to description
```yaml
description: Expert code reviewer. Use proactively after code changes.
```

**Explicit**: User requests specific agent
```
> Use the code-reviewer subagent to check my changes
```

## Resumable Subagents

Subagents can be resumed with preserved context:

```
> Use code-analyzer to review auth module
[Agent completes, returns agentId: "abc123"]

> Resume agent abc123 and now check authorization
[Continues with full previous context]
```

## Key Constraints

1. **Cannot spawn other subagents** - Main conversation orchestrates
2. **Don't inherit skills** - Must pre-load with `skills:` field
3. **Return summary only** - Full work stays in isolated context
4. **Fresh context each time** - Unless resumed

## When to Use Subagents

Use subagents when you need:
- **Context isolation** - Heavy work without polluting main
- **Parallel processing** - Multiple independent tasks
- **Specialized tooling** - Different tool access
- **Different model** - Haiku for speed, Opus for complex

See also:
- `../decision-guides/skills-vs-subagents.md` for comparison
- `../system-understanding/execution-model.md` for execution flow
