# Context Management

> Understanding how my context window works enables better decisions about information handling, conversation management, and when to use features like subagents.

> **About this document**: This is a practitioner's guide synthesizing official Claude Code
> documentation with observed behavior and architectural inference. Claims are marked:
> `[verified]` (documented in official sources), `[inferred]` (observed behavior, not formally documented),
> or `[illustrative]` (example syntax—verify against current docs).

## How Context Works for Me

My context window is finite working memory. Everything I need to process a request must fit within it, and it's shared across multiple concerns.

### The Context Window as Working Memory

```
┌─────────────────────────────────────────────────────────────┐
│                    MY CONTEXT WINDOW                        │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐  │
│  │ ALWAYS PRESENT                                        │  │
│  │ • System prompt (~2-3k tokens)                        │  │
│  │ • All installed skill metadata (~100 tokens each)     │  │
│  │ • Complete CLAUDE.md hierarchy                        │  │
│  │ • Unconditional rules (.claude/rules/*.md)            │  │
│  └───────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐  │
│  │ CONDITIONALLY LOADED                                  │  │
│  │ • Active skill body (when skill is invoked)           │  │
│  │ • Path-specific rules (when working with matched      │  │
│  │   files)                                              │  │
│  │ • Skill reference files (when I request them)         │  │
│  └───────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐  │
│  │ GROWS DURING SESSION                                  │  │
│  │ • Conversation history (your messages, my responses)  │  │
│  │ • Tool outputs (file contents, command results)       │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

This matters because I can't simply "remember" things between sessions or across conversations. What's in my context window *is* my available information.

### What's Always There

Some content loads automatically and cannot be avoided:

| Component | Typical Size | Notes |
|-----------|--------------|-------|
| System prompt | ~2-3k tokens | Fixed by Claude Code infrastructure |
| Skill metadata | ~100 tokens each | Brief descriptions of available skills |
| CLAUDE.md hierarchy | Varies | All levels merged together |
| Unconditional rules | Varies | Rules without `paths:` frontmatter |

**Implication**: If you've installed 50 skills, that's ~5k tokens just for metadata. If your CLAUDE.md files total 2k tokens, that's always present. This is the baseline cost before any actual work begins.

### What Loads Conditionally

Some content only appears when relevant:

- **Active skill body**: When I invoke a skill, its full instructions load (~5k tokens recommended maximum)
- **Path-specific rules**: Rules with `paths:` frontmatter load only when I'm working with matching files
- **Skill references**: Additional files a skill can request on-demand

This conditional loading is efficient. A skill about API design only loads when API work is needed, not when working on the UI.

### How Conversation History Grows

As we talk, the conversation history accumulates:
- Your messages
- My responses
- Tool invocations and their outputs (file contents can be large)

When the context approaches capacity, history typically compacts automatically `[inferred]`. Earlier exchanges get summarized to make room. This is why very long conversations may lose precise details from early on.

---

## The CLAUDE.md Hierarchy

Memory files follow a specific hierarchy. Understanding this helps me interpret instructions correctly and helps you structure them effectively.

### Precedence Order (Highest to Lowest)

```
HIGHEST PRIORITY ─────────────────────────────────────────────
┌─────────────────────────────────────────────────────────────┐
│ ENTERPRISE                                                  │
│ /Library/Application Support/ClaudeCode/CLAUDE.md           │
│ Organization-wide policies set by IT                        │
├─────────────────────────────────────────────────────────────┤
│ PROJECT                                                     │
│ ./CLAUDE.md or ./.claude/CLAUDE.md                          │
│ Team-shared instructions, checked into version control      │
├─────────────────────────────────────────────────────────────┤
│ PROJECT RULES                                               │
│ ./.claude/rules/*.md                                        │
│ Modular, topic-specific rules                               │
├─────────────────────────────────────────────────────────────┤
│ USER                                                        │
│ ~/.claude/CLAUDE.md                                         │
│ Personal preferences across all projects                    │
├─────────────────────────────────────────────────────────────┤
│ PROJECT LOCAL                                               │
│ ./CLAUDE.local.md                                           │
│ Personal project-specific (typically gitignored)            │
└─────────────────────────────────────────────────────────────┘
LOWEST PRIORITY ──────────────────────────────────────────────
```

### How Precedence Works

When instructions conflict:
- Enterprise overrides everything (organization can enforce policies)
- Project overrides user preferences (team standards win)
- Local files provide escape hatches for individual needs

When instructions don't conflict, they merge. I receive all applicable guidance together.

### The Import Mechanism

CLAUDE.md files can reference other files:

```markdown
See @README for project overview.
Reference @docs/coding-standards.md for style.

# Project Instructions
- @~/.claude/personal-prefs.md  # From home directory
```

These imports are:
- Resolved recursively (depth limit unverified; approximately 5 levels `[inferred]`)
- Not evaluated inside code blocks `[verified]`
- Discoverable via the `/memory` command `[verified]`

### Nested Discovery

When I read files from subdirectories, CLAUDE.md files in those subtrees also load. This enables directory-specific guidance without cluttering the root CLAUDE.md.

---

## The Central Principle: Keep Memory Minimal

**CLAUDE.md loads every session.** This is the single most important fact for context management.

### The "Every Session?" Test

Before adding content to CLAUDE.md, ask: "Do I need this every single session?"

```
Do I need this every single session?
│
├─YES─▶ Put in CLAUDE.md
│       (Standards, conventions, always-needed context)
│
└─NO──▶ Put somewhere else
        • Skill (load on-demand)
        • Path-specific rule (load for specific files)
        • Reference file (load when needed)
```

### What Belongs in CLAUDE.md

| Include | Why |
|---------|-----|
| Build/test commands | Needed regardless of task |
| Project structure overview | Provides essential orientation |
| Core coding standards | Applies to all work |
| Team conventions | Consistency matters always |

### What Doesn't Belong in CLAUDE.md

| Exclude | Better Location |
|---------|-----------------|
| Domain expertise (API design, security review) | Skill |
| Language-specific rules | Path-specific rule with `paths:` |
| Detailed how-to guides | Skill reference file |
| One-off task context | Direct conversation |

---

## Working Within Constraints

Context limits are not obstacles to fight but constraints to work with creatively.

### Practical Strategies

**1. Use Progressive Disclosure**

Instead of loading everything upfront, structure information so details load only when needed:
- Keep skill bodies under 500 lines / ~5k tokens
- Put detailed procedures in reference files
- Use path-specific rules to load context only for relevant files

**2. Leverage Path-Specific Rules**

Rules with `paths:` frontmatter provide CLAUDE.md behavior without always-on costs:

```yaml
# .claude/rules/api-guidelines.md
---
paths: src/api/**/*.ts
---

# API Development Rules
- All endpoints require authentication middleware
- Use standardized error response format
- Document with OpenAPI annotations
```

This loads only when I'm working with files matching `src/api/**/*.ts`.

**3. Budget Context Deliberately**

Estimate context usage:

| Component | Budget |
|-----------|--------|
| System overhead | ~3k tokens (fixed) |
| Skill metadata (N skills) | N × 100 tokens |
| CLAUDE.md files | Measure actual |
| Active skill | <5k tokens recommended |
| Conversation room | The remainder |

> **Note**: These token estimates are approximations based on observed patterns, not official
> specifications `[inferred]`. Actual usage may vary by configuration and Claude Code version.

If CLAUDE.md files total 10k tokens and you have 30 skills, that's ~13k tokens before any conversation begins.

**4. Use Subagents for Context Isolation**

Subagents operate in completely separate context windows:
- They don't see the main conversation history
- They only receive what I explicitly pass to them
- Their work doesn't bloat the main context
- They return only a summary

Use subagents when:
- Heavy research would pollute the main context
- A task is self-contained and summary-returnable
- You need parallel investigation of multiple areas

**5. Structure Conversations for Context Efficiency**

- Provide focused, relevant information rather than entire files
- Clear completed topics before starting new ones
- For very long tasks, consider breaking into separate sessions

---

## Common Mistakes to Avoid

### Putting Too Much in CLAUDE.md

**Symptom**: CLAUDE.md files totaling thousands of tokens of situational guidance.

**Problem**: Context budget consumed before work begins. Less room for conversation history and tool outputs.

**Fix**: Move domain expertise to skills. Move file-specific rules to path-specific rules. Keep CLAUDE.md for truly universal needs.

### Not Using Progressive Disclosure

**Symptom**: Skills with 1000+ lines of detailed procedures in the main body.

**Problem**: When the skill loads, it consumes significant context even if most content isn't immediately needed.

**Fix**: Keep skill body focused on high-level guidance. Put detailed procedures in reference files that load on-demand.

### Ignoring Context Budget Planning

**Symptom**: Wondering why conversations seem to "forget" earlier content.

**Problem**: Context filled with file contents and tool outputs, forcing history compaction.

**Fix**: Plan for context usage. Prefer targeted file reads over entire files. Use subagents for heavy processing.

### Using Skills for Standards

**Symptom**: Coding standards in a skill that must be manually invoked.

**Problem**: Standards only apply when you remember to invoke the skill.

**Fix**: Standards that should always apply go in CLAUDE.md or unconditional rules, not skills.

### Treating All Rules as Unconditional

**Symptom**: Many rules in `.claude/rules/` without `paths:` frontmatter.

**Problem**: All rules load every session, regardless of what files you're working with.

**Fix**: Add `paths:` frontmatter to rules that only apply to specific files.

---

## Decision Framework

### When to Use Each Mechanism

| Need | Mechanism | Why |
|------|-----------|-----|
| Universal project standards | CLAUDE.md | Always present |
| Personal preferences | ~/.claude/CLAUDE.md | Applies to all your projects |
| Language-specific rules | Path-specific rule | Loads only for relevant files |
| Domain expertise | Skill | Loads only when invoked |
| Detailed procedures | Skill reference file | Loads only when needed |
| Heavy processing | Subagent | Isolated context |

### Questions to Ask

1. **"Is this always needed?"** → CLAUDE.md if yes, skill if no
2. **"Is this file-specific?"** → Path-specific rule
3. **"Is this detailed guidance?"** → Reference file, not skill body
4. **"Will this generate lots of output?"** → Consider subagent
5. **"Is the CLAUDE.md getting long?"** → Audit and move content

---

## Practical Examples

### Example: Well-Structured Project Context

```
.claude/
├── CLAUDE.md                    # Essential: build commands, structure overview
└── rules/
    ├── code-style.md            # No paths: applies everywhere
    ├── api/
    │   └── endpoints.md         # paths: src/api/** - API-specific
    └── testing/
        └── patterns.md          # paths: **/*.test.ts - Test-specific
```

### Example: Context-Efficient Skill

```
skills/
└── api-design/
    ├── SKILL.md                 # <500 lines: high-level guidance
    └── references/
        ├── rest-patterns.md     # Detail: loads on-demand
        └── error-handling.md    # Detail: loads on-demand
```

### Example: Using Subagent for Research

Instead of:
```
[Heavy file reading that fills context]
[History compacts, losing earlier conversation]
```

Consider:
```
[Main context]: Spawn subagent for research task
[Subagent context]: Does heavy lifting, returns summary
[Main context]: Receives summary, preserves conversation history
```

---

## Summary

My context window is finite working memory shared by instructions, conversation, and tool outputs. Effective context management means:

1. **Keep CLAUDE.md minimal** - It loads every session
2. **Use progressive disclosure** - Details load when needed
3. **Leverage conditional loading** - Path rules, skills, references
4. **Consider subagents** - For context isolation
5. **Budget deliberately** - Know what consumes context

Understanding these mechanics helps me work more effectively and helps you structure projects for optimal collaboration.

---

## Sources and Confidence

| Section | Confidence | Source |
|---------|------------|--------|
| Context window as working memory | VERIFIED | Claude Code architecture documentation |
| CLAUDE.md hierarchy and precedence | VERIFIED | code.claude.com/docs/memory |
| Import mechanism with `@` syntax | VERIFIED | Official Claude Code documentation |
| `/memory` command availability | VERIFIED | Built-in Claude Code command |
| Token budget estimates (~3k system, ~100/skill) | INFERRED | Author estimation from observed behavior |
| Import recursion depth (~5 levels) | UNVERIFIED | Architectural assumption, not documented |
| Auto-compaction of conversation history | INFERRED | Observed behavior, exact mechanism undocumented |
| Path-specific rules with `paths:` frontmatter | VERIFIED | code.claude.com/docs/memory |
| Subagent context isolation | VERIFIED | Subagent documentation |

*Document created: 2026-01-10*
*Confidence framework added: 2026-01-12*
