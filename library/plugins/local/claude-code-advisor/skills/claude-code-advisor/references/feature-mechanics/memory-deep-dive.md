# Memory (CLAUDE.md) Deep Dive

Memory files provide persistent context that loads every session.

## Memory Hierarchy

```
HIGHEST PRIORITY (overrides lower)
┌─────────────────────────────────────────────────────┐
│ ENTERPRISE                                          │
│ /Library/Application Support/ClaudeCode/CLAUDE.md   │
│ Organization-wide policies, managed by IT           │
├─────────────────────────────────────────────────────┤
│ PROJECT                                             │
│ ./CLAUDE.md or ./.claude/CLAUDE.md                  │
│ Team-shared instructions, checked into git          │
├─────────────────────────────────────────────────────┤
│ PROJECT RULES                                       │
│ ./.claude/rules/*.md                                │
│ Modular, topic-specific rules                       │
├─────────────────────────────────────────────────────┤
│ USER                                                │
│ ~/.claude/CLAUDE.md                                 │
│ Personal preferences across all projects            │
├─────────────────────────────────────────────────────┤
│ PROJECT LOCAL                                       │
│ ./CLAUDE.local.md                                   │
│ Personal project-specific (gitignored)              │
└─────────────────────────────────────────────────────┘
LOWEST PRIORITY
```

## Path-Specific Rules

Rules can activate only for specific file patterns:

```yaml
---
paths: src/api/**/*.ts
---

# API Development Rules
- All endpoints need auth middleware
- Use standard error response format
```

**Without `paths` frontmatter**: Rule loads unconditionally.

### Glob Patterns

| Pattern | Matches |
|---------|---------|
| `**/*.ts` | All TypeScript files |
| `src/**/*` | All files under src/ |
| `src/**/*.{ts,tsx}` | TypeScript and TSX |
| `{src,lib}/**/*.ts` | Multiple directories |

## Import Syntax

CLAUDE.md files can import other files:

```markdown
See @README for overview and @package.json for commands.

# Team Instructions
- @docs/coding-standards.md
- @~/.claude/personal-prefs.md  # User's home directory
```

- Imports evaluated recursively (max 5 hops)
- Not evaluated inside code blocks
- `/memory` command shows loaded files

## Key Principles

1. **Always loaded** - Keep CLAUDE.md minimal
2. **Higher overrides lower** - Enterprise > Project > User
3. **Recursive discovery** - Found from cwd up to root
4. **Nested discovery** - Subtree CLAUDE.md loads when reading those files

## Best Practices

| Content Type | Put In |
|--------------|--------|
| Always-needed standards | CLAUDE.md |
| Language-specific rules | `.claude/rules/typescript.md` (with paths) |
| Personal preferences | `~/.claude/CLAUDE.md` |
| Sensitive local config | `CLAUDE.local.md` |
| Situational expertise | Skills (not memory) |

## The "Every Session?" Test

Ask: "Does Claude need this every single session?"

- **Yes** → Put in CLAUDE.md
- **No** → Put in a skill

## Organization Tips

```
.claude/
├── CLAUDE.md           # Main project instructions
└── rules/
    ├── code-style.md   # General style (no paths)
    ├── api/
    │   └── endpoints.md   # paths: src/api/**
    └── testing/
        └── standards.md   # paths: **/*.test.ts
```

See also:
- `../system-understanding/context-architecture.md` for context window implications
- `../decision-guides/memory-vs-skills.md` for choosing between them
