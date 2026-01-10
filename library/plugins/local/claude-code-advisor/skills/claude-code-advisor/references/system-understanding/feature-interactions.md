# Feature Interactions

Understanding how Claude Code features interact enables powerful compositions.

## Context Sharing Model

| Feature | Shares Main Context? | Notes |
|---------|---------------------|-------|
| **CLAUDE.md** | Yes (always) | Loaded every session |
| **Path Rules** | Yes (conditional) | Only when paths match |
| **Skills** | Yes (when active) | Body loads on trigger |
| **Slash Commands** | Yes | Executes in main context |
| **Subagents** | **No** (isolated) | Separate context window |
| **Hooks** | **No** (outside) | Pre/post processing only |
| **MCP** | N/A | Provides tools, not knowledge |

## Invocation Model

```
                    WHO TRIGGERS?
                         │
         ┌───────────────┼───────────────┐
         │               │               │
    AUTOMATIC       MODEL DECIDES    USER EXPLICIT
         │               │               │
    ┌────┴────┐    ┌────┴────┐    ┌────┴────┐
    │CLAUDE.md│    │ Skills  │    │Commands │
    │Path rule│    │Subagents│    │         │
    │  Hooks  │    │         │    │         │
    └─────────┘    └─────────┘    └─────────┘
```

- **Automatic**: Always happens without decision
- **Model decides**: Claude matches context to description
- **User explicit**: User types `/command` to trigger

## What Can Trigger What

```
┌─────────────────────────────────────────────────────────┐
│ CLAUDE.md/Rules                                         │
│   └── Always active, influences all decisions           │
│                                                         │
│ Skills                                                  │
│   ├── Can reference other files (references/)          │
│   ├── Can guide Claude to spawn subagents              │
│   └── Can invoke MCP tools                             │
│                                                         │
│ Slash Commands                                          │
│   ├── Can trigger skill loading                        │
│   └── Can invoke subagents                             │
│                                                         │
│ Subagents                                               │
│   ├── Can have pre-loaded skills                       │
│   ├── Can invoke MCP tools                             │
│   └── CANNOT spawn other subagents                     │
│                                                         │
│ Hooks                                                   │
│   ├── Can block/modify tool calls                      │
│   └── Can spawn subagents (via output)                 │
│                                                         │
│ MCP                                                     │
│   └── Provides tools (hooks can monitor MCP tools)     │
└─────────────────────────────────────────────────────────┘
```

## Feature Composition Patterns

### Pattern 1: Isolated Expert (Subagent + Skills)
```yaml
# .claude/agents/security-reviewer.md
---
name: security-reviewer
skills: owasp-checks, secure-coding
model: sonnet
---
```
- Subagent has isolated context
- Skills provide specialized knowledge inside subagent
- Main conversation stays clean

### Pattern 2: Event-Triggered Specialist (Hook + Subagent)
```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "prompt",
        "prompt": "Evaluate if security review needed..."
      }]
    }]
  }
}
```
- Hook detects event
- Complex analysis delegated to isolated context

### Pattern 3: Layered Context (CLAUDE.md + Rules + Skills)
```
CLAUDE.md: "We use TypeScript strict mode"
.claude/rules/api.md: "All endpoints need auth" (paths: src/api/**)
Skill: api-design (loaded when designing APIs)
```
- Global standards always present
- Path rules activate by context
- Skills add situational expertise

### Pattern 4: Command + Skill
```
User: /security-review
Command triggers → Skill loads → Guidance active
```
- User controls when capability activates
- Skill provides the expertise

### Pattern 5: MCP + Skill (Tool Teacher)
- MCP provides database tools
- Skill teaches query patterns and data model
- Result: Tools + knowledge of how to use them

## Information Flow Between Features

```
┌────────────────────────────────────────────────────────┐
│                 MAIN CONTEXT                            │
│                                                         │
│  CLAUDE.md ──────────────────────────────────────────▶ │
│  Path Rules ─────────────────────────────────────────▶ │
│  Active Skills ──────────────────────────────────────▶ │
│  Command Output ─────────────────────────────────────▶ │
│  Conversation ───────────────────────────────────────▶ │
│                                                         │
│  ◀────────────────────────────── Subagent RETURNS only │
│  (Subagent doesn't see main; main only sees summary)   │
│                                                         │
│  ◀─── Hooks add/modify (outside context, pre/post)     │
│                                                         │
│  ◀─── MCP tools return results                         │
└────────────────────────────────────────────────────────┘
```

## Design Decision Matrix

| Need | Use | Reason |
|------|-----|--------|
| Always-needed context | CLAUDE.md | Loads every session |
| Conditional context by file type | Path rules | Efficient, targeted |
| Domain expertise on-demand | Skills | Model-invoked, progressive |
| Explicit user trigger | Slash commands | User control |
| Heavy/isolated processing | Subagents | Context isolation |
| Automatic validation | Hooks | Event-driven, consistent |
| External tool access | MCP | Protocol-based integration |

See also:
- `../decision-guides/skills-vs-subagents.md` for detailed comparison
- `../patterns/composition-patterns.md` for more examples
