# Skills vs Subagents: Decision Guide

The most common architectural decision in Claude Code configuration.

## The Core Difference

| Aspect | Skills | Subagents |
|--------|--------|-----------|
| **Context** | Shares main context | Isolated context |
| **Purpose** | Add knowledge/guidance | Do isolated work |
| **Information flow** | Bidirectional in conversation | IN via prompt, OUT via summary |
| **Trigger** | Model matches description | Model/user invokes |
| **Persistence** | Active until task complete | Fresh each invocation (unless resumed) |

## Decision Flowchart

```
Do you need Claude to have specialized knowledge?
│
├─YES─▶ Does it need to do heavy processing?
│       │
│       ├─YES─▶ Use SUBAGENT with pre-loaded SKILL
│       │       (Isolated Expert pattern)
│       │
│       └─NO──▶ Use SKILL
│               (Knowledge stays in conversation)
│
└─NO──▶ Do you need isolated processing?
        │
        ├─YES─▶ Use SUBAGENT
        │       (Clean context, returns summary)
        │
        └─NO──▶ You may not need either
                (Just conversation + CLAUDE.md)
```

## Choose SKILL When

- Claude needs **guidance during the conversation**
- Knowledge should **persist** across multiple turns
- User wants to **see Claude's reasoning** with this knowledge
- Content is **reference material** Claude consults
- Work is **lightweight** (won't bloat context)

**Examples**:
- Code style guidelines
- API documentation
- Best practices for a framework
- Domain-specific terminology

## Choose SUBAGENT When

- Task is **heavy or extensive** (many file reads, searches)
- You want to **preserve main context** for other work
- Task is **independent** (doesn't need conversation history)
- You need **different tool access** or model
- You want **parallel execution** of multiple tasks

**Examples**:
- Deep codebase exploration
- Comprehensive code review
- Multi-file refactoring analysis
- Security audit

## Choose BOTH (Isolated Expert Pattern)

When you need isolated processing WITH specialized knowledge:

```yaml
# .claude/agents/security-reviewer.md
---
name: security-reviewer
skills: owasp-checks, secure-coding-patterns
model: sonnet
tools: Read, Grep, Glob
---

You are a security expert. Review code for vulnerabilities.
```

- Subagent provides **context isolation**
- Skills provide **domain expertise**
- Main conversation stays **clean**

## Common Mistakes

| Mistake | Problem | Fix |
|---------|---------|-----|
| Skill for heavy work | Bloats main context | Use subagent |
| Subagent to "teach" main | Context doesn't flow back | Use skill for knowledge |
| Subagent for quick tasks | Unnecessary overhead | Just do in main context |
| Skill for one-off prompts | Over-engineering | Use slash command |

## Quick Reference

**Skill**: "Claude, use this knowledge while we work together"

**Subagent**: "Claude, go do this separately and tell me what you found"

**Both**: "Claude, send an expert with this knowledge to investigate"

See also:
- `../feature-mechanics/skills-deep-dive.md` for skill mechanics
- `../feature-mechanics/subagents-deep-dive.md` for subagent mechanics
- `../patterns/composition-patterns.md` for the Isolated Expert pattern
