# Context Architecture

Understanding how the context window works is essential for designing efficient Claude Code configurations.

## The Context Window as Shared Resource

The context window is finite and shared by everything Claude needs to process:

```
┌─────────────────────────────────────────────────────┐
│            MAIN CONTEXT WINDOW                      │
│                                                     │
│  ┌─────────────────────────────────────────────┐   │
│  │ ALWAYS PRESENT (Cannot avoid)               │   │
│  │ • System prompt (~2-3k tokens)              │   │
│  │ • All skill metadata (~100 tokens/skill)    │   │
│  │ • CLAUDE.md (entire hierarchy)              │   │
│  │ • Unconditional .claude/rules/*.md          │   │
│  └─────────────────────────────────────────────┘   │
│                                                     │
│  ┌─────────────────────────────────────────────┐   │
│  │ CONDITIONALLY LOADED                        │   │
│  │ • Active skill body (<5k recommended)       │   │
│  │ • Path-specific rules (when file matched)   │   │
│  │ • Skill reference files (on-demand)         │   │
│  └─────────────────────────────────────────────┘   │
│                                                     │
│  ┌─────────────────────────────────────────────┐   │
│  │ GROWS DURING SESSION                        │   │
│  │ • Conversation history                      │   │
│  │ • Tool outputs (file contents, etc.)        │   │
│  └─────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────┘
```

## Token Budget Planning

| Component | Typical Size | Control |
|-----------|--------------|---------|
| System prompt | ~2-3k | Fixed by Claude Code |
| Skill metadata (each) | ~100 | Write concise descriptions |
| CLAUDE.md (full hierarchy) | Varies | Keep minimal |
| Active skill body | <5k recommended | Progressive disclosure |
| Path-specific rules | Varies | Only load when relevant |
| Conversation history | Grows | Compacts automatically |

## Memory Hierarchy

Claude Code loads memory in a specific order. Higher levels take precedence:

1. **Enterprise** - Organization-wide (`/Library/Application Support/ClaudeCode/CLAUDE.md`)
2. **Project** - Team-shared (`./CLAUDE.md` or `./.claude/CLAUDE.md`)
3. **Project rules** - Modular (`./.claude/rules/*.md`)
4. **User** - Personal across all projects (`~/.claude/CLAUDE.md`)
5. **Project local** - Personal project-specific (`./CLAUDE.local.md`)

**Key insight**: All levels are loaded together. Keep CLAUDE.md minimal - it loads every session.

## Path-Specific Rules

Rules with `paths` frontmatter only load when working with matching files:

```yaml
---
paths: src/api/**/*.ts
---
# API Development Rules
Only active when working with API files.
```

This is more efficient than putting everything in CLAUDE.md.

## Context Isolation: Subagents

Subagents operate in completely separate context windows:
- They don't see main conversation history
- They only receive what's explicitly passed to them
- Their work doesn't bloat main context
- They return only a summary

**Use subagents when**: You need heavy processing without polluting main context.

## Design Implications

1. **CLAUDE.md test**: "Does Claude need this every session?" If no, use a skill instead.
2. **Skill body limit**: Keep under 500 lines / 5k tokens. Use references for details.
3. **Many skills are cheap**: Metadata is ~100 tokens. Having many skills is fine.
4. **Path rules for conditional content**: Don't load API rules when working on UI.
5. **Subagents for isolation**: Heavy research or analysis should use subagents.

See also:
- `execution-model.md` for how context flows through the execution loop
- `feature-interactions.md` for how features share context
