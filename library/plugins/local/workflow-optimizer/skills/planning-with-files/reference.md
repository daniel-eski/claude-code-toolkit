# Context Engineering Principles Reference

This skill is based on context engineering principles from Manus, the AI agent company acquired by Meta for $2 billion in December 2025.

## The 6 Core Principles

### Principle 1: Design Around KV-Cache

> "KV-cache hit rate is THE single most important metric for production AI agents."

**Why it matters:**
- Cached tokens: $0.30/MTok vs Uncached: $3/MTok (10x difference)
- Input-to-output token ratio is ~100:1
- Cache invalidation wastes significant compute

**Implementation:**
- Keep prompt prefixes STABLE (single-token change invalidates cache)
- NO timestamps in system prompts
- Make context APPEND-ONLY with deterministic serialization

### Principle 2: Mask, Don't Remove

Don't dynamically remove tools from the context (breaks KV-cache). Use logit masking instead.

**Best Practice:** Use consistent action prefixes (e.g., `browser_`, `shell_`, `file_`) for easier masking when certain tools aren't applicable.

### Principle 3: Filesystem as External Memory

> "Markdown is my 'working memory' on disk."

**The Formula:**
```
Context Window = RAM (volatile, limited)
Filesystem = Disk (persistent, unlimited)
```

**Compression Must Be Restorable:**
- Keep URLs even if web content is dropped
- Keep file paths when dropping document contents
- Never lose the pointer to full data

This is why we create `task_plan.md`, `findings.md`, and `progress.md` — they persist information that would otherwise be lost as the context grows.

### Principle 4: Manipulate Attention Through Recitation

> "Creates and updates todo.md throughout tasks to push global plan into model's recent attention span."

**The Problem:** After ~50 tool calls, models forget original goals ("lost in the middle" effect). Information at the start and end of context gets attention; the middle gets forgotten.

**The Solution:** Re-read `task_plan.md` before major decisions. This moves goals from the forgotten middle to the recent end of context.

```
Start of context: [Original goal - far away, may be forgotten]
...many tool calls...
End of context: [Recently read task_plan.md - gets ATTENTION!]
```

### Principle 5: Keep the Wrong Stuff In

> "Leave the wrong turns in the context."

**Why:**
- Failed actions with stack traces let the model implicitly update beliefs
- Reduces mistake repetition
- Error recovery is "one of the clearest signals of TRUE agentic behavior"

**Implementation:** Log errors in `task_plan.md` under "Errors Encountered" rather than hiding them.

### Principle 6: Don't Get Few-Shotted

> "Uniformity breeds fragility."

**The Problem:** Repetitive action-observation pairs cause drift and hallucination. The model starts pattern-matching rather than reasoning.

**The Solution:** Introduce controlled variation:
- Vary phrasings slightly
- Don't copy-paste patterns blindly
- Recalibrate periodically on repetitive tasks

---

## The 3 Context Engineering Strategies

### Strategy 1: Context Reduction

**Compaction:**
```
Tool call results have TWO representations:
├── FULL: Raw tool content (stored in filesystem)
└── COMPACT: Reference/file path only (in context)

RULES:
- Apply compaction to STALE (older) tool results
- Keep RECENT results FULL (to guide next decision)
```

**Summarization:**
- Applied when compaction reaches diminishing returns
- Generated using full tool results
- Creates standardized summary objects

### Strategy 2: Context Isolation (Multi-Agent)

**Architecture:**
```
┌─────────────────────────────────┐
│         PLANNER AGENT           │
│  └─ Assigns tasks to sub-agents │
├─────────────────────────────────┤
│       KNOWLEDGE MANAGER         │
│  └─ Reviews conversations       │
│  └─ Determines filesystem store │
├─────────────────────────────────┤
│      EXECUTOR SUB-AGENTS        │
│  └─ Perform assigned tasks      │
│  └─ Have own context windows    │
└─────────────────────────────────┘
```

**Key Insight:** Manus originally used `todo.md` for task planning but found ~33% of actions were spent updating it. They shifted to a dedicated planner agent coordinating executor sub-agents.

This is why the `agent-architect` skill can help design subagents for different phases of your plan.

### Strategy 3: Context Offloading

**Tool Design:**
- Use <20 atomic functions total
- Store full results in filesystem, not context
- Use `glob` and `grep` for searching stored information
- Progressive disclosure: load information only as needed

---

## The Agent Loop

The recommended 7-step execution loop:

```
┌─────────────────────────────────────────┐
│  1. ANALYZE CONTEXT                      │
│     - Understand current state           │
│     - Review recent observations         │
├─────────────────────────────────────────┤
│  2. THINK                                │
│     - Should I update the plan?          │
│     - What's the next logical action?    │
│     - Are there blockers?                │
├─────────────────────────────────────────┤
│  3. SELECT TOOL                          │
│     - Choose ONE tool                    │
│     - Ensure parameters available        │
├─────────────────────────────────────────┤
│  4. EXECUTE ACTION                       │
│     - Tool runs in sandbox               │
├─────────────────────────────────────────┤
│  5. RECEIVE OBSERVATION                  │
│     - Result appended to context         │
├─────────────────────────────────────────┤
│  6. ITERATE                              │
│     - Return to step 1                   │
│     - Continue until complete            │
├─────────────────────────────────────────┤
│  7. DELIVER OUTCOME                      │
│     - Send results to user               │
│     - Attach all relevant files          │
└─────────────────────────────────────────┘
```

---

## File Update Cadence

| File | When to Create | When to Update |
|------|----------------|----------------|
| `task_plan.md` | Task start | After completing phases, decisions, errors |
| `findings.md` | After first discovery | After ANY discovery, especially images/PDFs |
| `progress.md` | At session start | Throughout session, at breakpoints |

---

## Critical Constraints

- **Plan is Required:** Agent must ALWAYS know: goal, current phase, remaining phases
- **Files are Memory:** Context = volatile. Filesystem = persistent.
- **Never Repeat Failures:** If action failed, next action MUST be different
- **Single-Action Focus:** Complete one action fully before moving to the next

---

## Key Statistics from Manus

| Metric | Value |
|--------|-------|
| Average tool calls per task | ~50 |
| Input-to-output token ratio | 100:1 |
| Framework refactors since launch | 5 times |

---

## Key Quotes

> "KV-cache hit rate is the single most important metric for a production-stage AI agent."

> "Context window = RAM (volatile, limited). Filesystem = Disk (persistent, unlimited)."

> "Error recovery is one of the clearest signals of TRUE agentic behavior."

> "Leave the wrong turns in the context."

> "if action_failed: next_action != same_action. Track what you tried. Mutate the approach."

---

## Source

Based on Manus's official context engineering documentation:
https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus
