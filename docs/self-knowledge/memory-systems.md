# Memory Systems

> Understanding how I persist and retrieve information across sessions.

> **About this document**: This is a practitioner's guide synthesizing official Claude Code
> documentation with observed behavior and architectural inference. Claims are marked:
> `[verified]` (documented in official sources), `[inferred]` (observed behavior, not formally documented),
> or `[illustrative]` (example syntax—verify against current docs).

---

## What "Memory" Means for Me

I don't have persistent memory in the human sense. I cannot recall previous conversations unless that information has been explicitly stored somewhere I can access. Understanding this fundamental constraint is key to working with me effectively.

### Types of Memory

| Type | Persistence | Location | Access |
|------|-------------|----------|--------|
| **Session context** | Current session only | My context window | Always present |
| **CLAUDE.md files** | Across sessions | File system | Loaded at session start `[verified]` |
| **Project files** | Permanent | File system | Must be read explicitly |
| **User memory** | Across sessions | `~/.claude/` | User-controlled |

### What I "Remember"

Within a single session:
- Everything in my context window
- All conversation history (until compaction)
- All tool outputs I've received
- All skills and CLAUDE.md content loaded

Across sessions:
- Nothing inherently
- Only what's written to CLAUDE.md or other persistent files
- Only what's stored in user memory systems

---

## The CLAUDE.md System

CLAUDE.md files are my primary mechanism for cross-session persistence `[verified]`.

### How Loading Works

At session start, Claude Code automatically loads CLAUDE.md files from a hierarchy of locations:

```
Load Order (all merged into context):
1. Enterprise CLAUDE.md (if present)
2. User CLAUDE.md (~/.claude/CLAUDE.md)
3. User rules (~/.claude/rules/*.md)
4. Project CLAUDE.md (./CLAUDE.md or ./.claude/CLAUDE.md)
5. Project rules (./.claude/rules/*.md)
6. Local CLAUDE.md (./CLAUDE.local.md)
```

> **Note**: This loading happens automatically before I see any user input `[verified]`. I cannot
> choose to skip or selectively load these files.

### What Goes Where

| Location | Best For | Precedence |
|----------|----------|------------|
| **Enterprise** | Organization-wide policies | Highest (cannot be overridden) `[verified]` |
| **User** | Personal preferences, coding style | Medium |
| **Project** | Team standards, build commands | Medium |
| **Local** | Personal project-specific, experimental | Lowest `[verified]` |

### Precedence Behavior `[verified]`

When instructions conflict:
- Higher precedence levels override lower ones
- Enterprise can enforce policies that cannot be overridden
- Local provides escape hatches for individual experimentation

When instructions don't conflict:
- All content merges together
- I receive cumulative guidance from all levels

---

## The /memory Command

The `/memory` command provides visibility into and control over what's loaded `[verified]`.

### What It Shows

```
/memory
```

Displays:
- All loaded CLAUDE.md files and their locations
- Content preview of each loaded file
- Import relationships (what references what)
- Effective merged memory

### Editing Memory

```
/memory edit [scope]
```

Opens the relevant CLAUDE.md file for editing:
- `/memory edit user` → `~/.claude/CLAUDE.md`
- `/memory edit project` → `./CLAUDE.md` or `./.claude/CLAUDE.md`
- `/memory edit local` → `./CLAUDE.local.md`

### Adding to Memory

I can suggest additions to CLAUDE.md through conversation, but:
- I don't automatically persist learnings
- User must approve changes to CLAUDE.md
- Adding memory is an explicit action, not automatic

---

## Persistence Patterns

### What Persists Automatically

| Item | Persists? | Mechanism |
|------|-----------|-----------|
| CLAUDE.md content | Yes | File system |
| Skills in `~/.claude/skills/` | Yes | File system |
| Project files | Yes | File system |
| Conversation history | No | Gone after session ends |
| Tool outputs | No | Part of conversation |
| My reasoning | No | Part of conversation |

### Explicit Persistence Strategies

To remember something across sessions, it must be stored:

**Option 1: Add to CLAUDE.md**
```
# Via /memory command
/memory edit project
# Then add the learning
```

**Option 2: Create a project file**
```
# Write to docs/decisions/some-decision.md
# Reference from CLAUDE.md if needed always
```

**Option 3: User memory file**
```
# Write to ~/.claude/CLAUDE.md for personal cross-project memory
```

### The Import Mechanism

CLAUDE.md files can reference other files `[verified]`:

```markdown
# In CLAUDE.md
See @docs/architecture.md for system overview.
Follow @.claude/rules/coding-style.md for conventions.
```

These `@` references:
- Are resolved when CLAUDE.md loads
- Can reference any readable file
- Follow relative or absolute paths
- Home directory with `@~/...` syntax

---

## Memory vs. Context

Understanding the relationship between memory (persistent) and context (session) is crucial.

### Key Differences

| Aspect | Memory (CLAUDE.md) | Context (Session) |
|--------|-------------------|-------------------|
| Lifespan | Permanent until changed | Current session only |
| Loading | Automatic at start | Grows during session |
| Size | Should be minimal | Can fill entire window |
| Control | User edits files | Accumulates from work |
| Cost | Paid every session | Paid once per session |

### The Cost Tradeoff

Every token in CLAUDE.md loads every session. This creates a tradeoff:

```
More in CLAUDE.md = Less room for conversation

Guideline: CLAUDE.md should contain only what's needed EVERY session
```

See `context-management.md` for detailed guidance on managing this tradeoff.

### When to Use Each

| Need | Use |
|------|-----|
| Always need this info | CLAUDE.md |
| Need it sometimes | Skill (loads on demand) |
| Need it for specific files | Path-specific rule |
| Need it this session only | Tell me directly |
| Need it permanently but not every session | Project file + reference when needed |

---

## Common Patterns

### Pattern: Session Learnings → Memory

When you want me to remember something from our session:

1. Identify what's worth persisting
2. Decide where it belongs (user, project, local)
3. Use `/memory edit [scope]` or ask me to suggest the addition
4. Approve and save the change

### Pattern: Project Context Setup

For a new project:

1. Create `.claude/CLAUDE.md` with:
   - Build/test commands
   - Project structure overview
   - Key conventions
2. Create `.claude/rules/` for file-specific rules
3. Keep content minimal - link to docs rather than duplicating

### Pattern: Personal Preferences

For cross-project personal preferences:

1. Edit `~/.claude/CLAUDE.md`
2. Add coding style preferences
3. Add workflow preferences
4. Keep minimal - these load for every project

### Pattern: Experimental Settings

For trying new approaches without affecting team:

1. Create `./CLAUDE.local.md` (typically gitignored)
2. Add experimental instructions
3. Local has lowest precedence - won't override team settings

---

## Limitations

### What I Cannot Do

| Limitation | Reason |
|------------|--------|
| Automatically persist learnings | No mechanism for auto-write `[inferred]` |
| Remember previous sessions | No cross-session memory unless in files |
| Skip loading CLAUDE.md | It's automatic and unconditional |
| Prioritize some memory over other | Precedence rules are fixed |

### Memory Doesn't Mean Understanding

Having information in CLAUDE.md doesn't guarantee I'll use it appropriately:
- Large CLAUDE.md files can be overwhelming
- Conflicting instructions can cause confusion
- I follow instructions literally - unclear guidance causes unpredictable behavior

### Context Window Limits Apply

All loaded memory counts against context:
- Very large CLAUDE.md files reduce conversation room
- Many imports compound the effect
- Skills, rules, and CLAUDE.md all compete for space

---

## Best Practices

### Keep Memory Minimal

```
Good: Build with `npm run build`, test with `npm test`
Bad: Complete npm documentation embedded in CLAUDE.md
```

### Use Progressive Disclosure

Instead of putting everything in CLAUDE.md:
- Put essentials in CLAUDE.md
- Put domain knowledge in skills
- Put detailed procedures in reference files
- Put file-specific rules in path-specific rules

### Structure for Clarity

```markdown
# Project: MyApp

## Build & Test
- Build: `npm run build`
- Test: `npm test`

## Structure
- src/: Source code
- tests/: Test files
- docs/: Documentation

## Conventions
- See @.claude/rules/style.md for coding style
```

### Avoid Duplication

- Don't repeat information across CLAUDE.md levels
- Don't duplicate what's in project files
- Link to authoritative sources with `@` imports

---

## Summary

My memory system is file-based and explicit:

1. **CLAUDE.md files** are my persistent memory across sessions
2. **Loading is automatic** - I get all applicable CLAUDE.md content at session start
3. **Hierarchy matters** - Enterprise > Project > User > Local
4. **Persistence requires action** - Nothing auto-saves; changes must be written
5. **Context cost is real** - Every byte of memory loads every session

Effective memory management means:
- Putting the right information in the right place
- Keeping always-loaded content minimal
- Using skills and rules for conditional content
- Understanding what persists and what doesn't

---

## See Also

- `context-management.md` - Detailed context window management strategies
- `tool-execution.md` - How file operations work
- Official memory documentation at code.claude.com

---

## Sources and Confidence

| Section | Confidence | Source |
|---------|------------|--------|
| CLAUDE.md hierarchy and precedence | VERIFIED | code.claude.com/docs/memory |
| /memory command functionality | VERIFIED | Built-in Claude Code command |
| Automatic loading at session start | VERIFIED | Documented behavior |
| Import mechanism with `@` syntax | VERIFIED | Official documentation |
| Enterprise override behavior | VERIFIED | Enterprise documentation |
| Persistence requires explicit action | INFERRED | No auto-save mechanism observed |
| Context cost tradeoffs | INFERRED | Derived from context window mechanics |
| Best practices | INFERRED | Synthesized from observed patterns |

*Document created: 2026-01-12*
*Created with confidence framework*
