# Memory (CLAUDE.md) vs Skills: Decision Guide

Both provide context to Claude, but with different loading patterns.

## The Core Difference

| Aspect | Memory (CLAUDE.md) | Skills |
|--------|-------------------|--------|
| **Loading** | Always loaded every session | On-demand when triggered |
| **Cost** | Constant context usage | Only when active |
| **Scope** | Project/user-wide | Task-specific |
| **Purpose** | Standards, always-needed rules | Situational expertise |

## The "Every Session?" Test

Ask yourself: **"Does Claude need this EVERY session?"**

```
Does Claude need this every single session?
│
├─YES─▶ Put in CLAUDE.md
│       (Standards, conventions, always-needed)
│
└─NO──▶ Put in a SKILL
        (Load only when relevant)
```

## Choose CLAUDE.md When

- It's a **project standard** (coding style, architecture)
- Claude needs it **regardless of task** (build commands, test patterns)
- It's **short and essential** (a few paragraphs)
- It applies to **all work** in the project

**Examples**:
- "We use TypeScript strict mode"
- "Run `npm test` for tests"
- "Follow conventional commits"
- "API endpoints are in `src/api/`"

## Choose SKILL When

- It's **domain-specific** (PDF processing, security review)
- Claude only needs it for **certain tasks**
- It's **extensive** (would bloat CLAUDE.md)
- It includes **reference files** or scripts

**Examples**:
- API design patterns (only when designing APIs)
- Database query optimization (only when writing queries)
- Accessibility guidelines (only when building UI)

## Choose PATH-SPECIFIC RULES When

You want CLAUDE.md behavior but only for certain files:

```yaml
# .claude/rules/api.md
---
paths: src/api/**/*.ts
---
# API Rules
- All endpoints need authentication
- Use standard error format
```

This loads only when working with API files.

## Common Mistakes

| Mistake | Problem | Fix |
|---------|---------|-----|
| Everything in CLAUDE.md | Bloats every session | Move situational content to skills |
| Large CLAUDE.md | Wastes context | Keep it focused, use skills |
| Skill for standards | Standards not always present | Put in CLAUDE.md |
| No CLAUDE.md | Repeating basics every session | Add essential project context |

## Comparison Table

| Content Type | CLAUDE.md | Path Rules | Skill |
|--------------|-----------|------------|-------|
| Code style | ✅ | | |
| Build commands | ✅ | | |
| API-specific rules | | ✅ | |
| Test patterns for tests/ | | ✅ | |
| PDF processing guide | | | ✅ |
| Security review checklist | | | ✅ |
| Framework expertise | | | ✅ |

## Key Insight

**CLAUDE.md**: Foundation that's always there

**Skills**: Expertise that loads when needed

**Path Rules**: CLAUDE.md behavior, targeted to specific files

See also:
- `../feature-mechanics/memory-deep-dive.md` for memory mechanics
- `../feature-mechanics/skills-deep-dive.md` for skill mechanics
