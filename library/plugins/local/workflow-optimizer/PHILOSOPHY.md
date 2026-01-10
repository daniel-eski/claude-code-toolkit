# Design Philosophy & Key Insights

This document captures the reasoning behind design decisions and the evolution of this plugin.

---

## The Core Insight

**You can't design optimal tooling until you deeply understand the problem.**

The original approach to Claude Code configuration was backwards:
1. Learn Claude Code features
2. Configure tools
3. Start working

The problem: Configuration designed in a vacuum doesn't fit real needs. You end up reconfiguring mid-task when you discover what you actually need.

**The better approach:**
1. Understand the task deeply (prompt-optimizer)
2. Establish persistent context (planning-with-files)
3. Design tooling based on that understanding (agent-architect)

Agent architecture becomes the **culmination** of understanding, not the starting point.

---

## Key Insight #1: Workflow Over Reference

### The Problem with Reference Tools

The original `claude-config-advisor` was essentially a pointer to documentation:
> "Before recommending anything, read CONFIG-TEMPLATES.md"

This makes the skill a redirect, not an intelligent advisor. It provides syntax but not decisions.

### What Valuable Skills Actually Do

According to skill design best practices:
- Valuable skills provide **decision trees** that route to the right workflow
- They **change behavior**, not just provide information
- They **encode knowledge into actionable patterns**

### Our Solution

Three skills that form a **workflow**, not just a reference:
- `prompt-optimizer` → Decision: Is this task understood?
- `planning-with-files` → Decision: Is context established?
- `agent-architect` → Decision: What architecture fits this specific context?

Each skill makes decisions, not just provides information.

---

## Key Insight #2: Context Engineering Principles

### The Manus Methodology

The `planning-with-files` skill is based on context engineering principles from Manus (acquired by Meta for $2B):

**Core formula:**
```
Context Window = RAM (volatile, limited)
Filesystem = Disk (persistent, unlimited)
```

After ~50 tool calls, original goals can be forgotten ("lost in the middle" effect). File-based planning solves this.

### Key Rules We Adopted
- **2-Action Rule:** Save findings every 2 operations
- **Read Before Decide:** Re-read planning files before major decisions
- **Keep the Wrong Stuff In:** Failed actions help the model update beliefs
- **Filesystem as Memory:** Critical information persisted to disk

### Why This Matters for Claude Code

Claude Code sessions can involve many tool calls. Without persistent context:
- Goals drift
- Decisions become inconsistent
- Previous discoveries are forgotten

Planning files create a "working memory" that survives context window limitations.

---

## Key Insight #3: Loose Coupling

### The Anti-Pattern

A single monolithic skill that does everything:
```
User → Master Skill (analyzes, plans, configures, executes)
```

Problems:
- Heavy for simple tasks
- Can't use parts independently
- Hard to maintain
- Conflates different concerns

### Our Pattern

Loosely coupled skills that chain naturally:
```
User → prompt-optimizer (understand)
     → planning-with-files (establish context)
     → agent-architect (design tooling)
     → Execute
```

Each skill:
- Works independently
- Has a single responsibility
- Chains naturally with others
- Can be skipped if not needed

### How Loose Coupling Works

```
prompt-optimizer outputs:
"For complex work, consider using planning-with-files
to establish persistent context."

planning-with-files outputs:
"Planning files created. agent-architect can design
architecture based on this context."

agent-architect inputs:
IF task_plan.md exists:
  "I see planning files. Designing architecture
   optimized for these phases..."
ELSE:
  Works standalone with generic recommendations
```

---

## Key Insight #4: Progressive Disclosure

### The Context Problem

Skills share Claude's context window with:
- Conversation history
- Other skills
- User requests

Loading everything wastes context budget.

### Our Solution

**Essential information in SKILL.md** (loaded when skill activates)
**Detailed reference in supporting files** (loaded only when needed)

```
agent-architect/
├── SKILL.md           # Essential: decision logic, when to use what
├── references/        # Detailed: loaded when recommending specific features
│   ├── SKILLS.md
│   ├── SUBAGENTS.md
│   └── ...
└── templates/         # Ready-to-use: loaded when generating config
```

Files don't consume tokens until accessed.

---

## Design Decisions

### Why three skills instead of one?

| Reason | Explanation |
|--------|-------------|
| Different frequencies | Prompt optimization: every complex task. Planning: extended work. Architecture: project setup. |
| Different dependencies | prompt-optimizer is platform-agnostic. agent-architect is Claude Code specific. |
| User control | User decides which steps to take. |
| Maintainability | Each skill can be updated independently. |

### Why fork planning-with-files?

The Manus context engineering principles are valuable and battle-tested ($2B acquisition). Forking rather than referencing allows:
- Integration with our workflow narrative
- Adaptation for Claude Code context
- Bundled templates

### Why rename config-advisor to agent-architect?

"Config advisor" implies syntax reference.
"Agent architect" implies designing systems.

The skill doesn't just advise on configuration—it architects agent systems based on context.

### Why detect planning files in agent-architect?

When context is established (task_plan.md exists), architecture can be **specifically optimized** for:
- The task's phases
- Discovered requirements
- Made decisions

Without planning files, the architect still works but recommendations are generic.

---

## Evolution of the Plugin

### Version 1.0 (Original)
Single `prompt-optimizer` skill that did everything:
- Clarified objectives
- Recommended subagents
- Suggested hooks
- Proposed CLAUDE.md additions

**Problem:** Conflated task understanding with tool configuration.

### Version 2.0 (Separation)
Two skills: `prompt-optimizer` and `claude-config-advisor`

**Problem:** Config advisor was just a reference tool, not an intelligent architect.

### Version 3.0 (Current)
Three skills forming a workflow:
1. `prompt-optimizer` — Task understanding
2. `planning-with-files` — Context establishment
3. `agent-architect` — Architecture design

**Key improvement:** Configuration comes AFTER understanding, informed by established context.

---

## Principles for Future Development

1. **Workflow over reference** — Skills should make decisions, not just provide information
2. **Loose coupling** — Skills should work independently but chain naturally
3. **Progressive disclosure** — Essential in main file, details in supporting files
4. **Context-informed design** — Architecture should be built for specific, understood tasks
5. **Filesystem as memory** — Persist critical information to survive context limitations

---

## Open Questions

1. **How automated should the workflow be?**
   - Currently: User invokes each skill explicitly
   - Alternative: Skills auto-chain based on task complexity

2. **Should agent-architect create planning files?**
   - Currently: Suggests using planning-with-files if files don't exist
   - Alternative: Create basic planning structure itself

3. **How opinionated should templates be?**
   - More opinionated = faster to use, less flexible
   - Less opinionated = more customization needed

---

## Sources & Inspiration

- Manus context engineering principles
- Claude Code official documentation
- Skill design best practices research
- Community feedback and real-world usage
