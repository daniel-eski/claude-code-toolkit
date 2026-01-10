# Skills vs Slash Commands: Decision Guide

Both customize Claude's behavior, but differ in how they're triggered.

## The Core Difference

| Aspect | Skills | Slash Commands |
|--------|--------|----------------|
| **Trigger** | Claude auto-detects from request | User types `/command` |
| **Discovery** | Semantic matching | Explicit invocation |
| **Structure** | Directory with SKILL.md + resources | Single .md file |
| **Complexity** | Multi-file, scripts, templates | Simple prompts |

## Decision Flowchart

```
Should Claude automatically detect when to use this?
│
├─YES─▶ Is it complex (multiple files, scripts)?
│       │
│       ├─YES─▶ Use SKILL
│       │
│       └─NO──▶ Does it need specific trigger words?
│               │
│               ├─YES─▶ Use SKILL (good description)
│               │
│               └─NO──▶ Could be either; prefer SKILL
│                       for discoverability
│
└─NO──▶ User wants explicit control
        │
        └─────▶ Use SLASH COMMAND
```

## Choose SKILL When

- Claude should **auto-detect** relevance
- Capability has **multiple files** (reference docs, scripts)
- You want **progressive disclosure** (load details on-demand)
- Task is a **domain** (e.g., "PDF processing", "security review")

## Choose SLASH COMMAND When

- User wants **explicit control** over when it runs
- It's a **simple prompt** that fits in one file
- You use it **repeatedly** and want quick access
- It's a **specific action** (e.g., `/deploy`, `/commit`)

## Comparison Table

| Scenario | Skill | Command |
|----------|-------|---------|
| Review code for security | ✅ Auto-detects "review" | `/security-review` works too |
| Deploy to staging | ❌ Too specific | ✅ `/deploy staging` |
| Explain code with diagrams | ✅ Detects "explain" | Could use `/explain` |
| Run standard test suite | ❌ Just an action | ✅ `/test` |
| Generate commit message | Either works | ✅ `/commit` is explicit |
| Domain expertise (PDF, API) | ✅ Rich capability | ❌ Too complex |

## Both Can Coexist

You might have:
- **Skill**: `code-review` (auto-triggers on review requests)
- **Command**: `/quick-review` (explicit, simpler prompt)

The skill provides depth; the command provides quick access.

## Key Insight

**Skills**: "Claude figures out when this is relevant"

**Commands**: "User decides when to trigger this"

See also:
- `../feature-mechanics/skills-deep-dive.md` for skill mechanics
- `../feature-mechanics/commands-deep-dive.md` for command mechanics
