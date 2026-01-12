# Task Complexity Assessment Guide

Use this guide to quickly assess whether a task warrants full prompt optimization analysis or should proceed directly.

## Quick Decision: Simple vs Complex

### Proceed Directly (Skip Full Analysis)

The task is likely **simple** if ALL of these are true:

- [ ] **Bounded scope** — Changes are confined to a small, well-defined area
- [ ] **Clear requirements** — No ambiguity in what's being asked
- [ ] **Familiar pattern** — Similar to work done before
- [ ] **Low risk** — Mistakes are easily reversible
- [ ] **No cascading effects** — Changes won't ripple to other areas
- [ ] **Short execution** — Can be completed in a few steps

**Examples of simple tasks**:
- "Fix the typo in this error message"
- "Add a null check before this line"
- "Rename this variable from `x` to `userCount`"
- "Update the copyright year"
- "Add a console.log to debug this function"

### Use Full Optimization Analysis

The task is likely **complex** if ANY of these are true:

- [ ] **Multi-area changes** — Will touch multiple files or modules
- [ ] **Architectural decisions** — Requires choosing between approaches
- [ ] **Unfamiliar territory** — First time working in this area
- [ ] **Ambiguous requirements** — Multiple valid interpretations exist
- [ ] **High stakes** — Mistakes could cause significant problems
- [ ] **External dependencies** — Requires understanding integrations
- [ ] **Testing implications** — Will need new or modified tests
- [ ] **Performance concerns** — Could impact system performance
- [ ] **Security implications** — Touches sensitive areas

**Examples of complex tasks**:
- "Refactor the authentication system to use OAuth"
- "Add a caching layer to improve performance"
- "Implement a new notification feature"
- "Debug why users are randomly logged out"
- "Migrate from one framework to another"

---

## Complexity Signals

### Signals Suggesting Complexity (Use Full Analysis)

**In the request**:
- "I want to build..."
- "Help me design..."
- "What's the best way to..."
- "I'm not sure how to approach..."
- "This needs to work with..."
- "Refactor..."
- "Debug why..."
- "Implement [feature name]"
- Multiple requirements in one request
- Questions about architecture or patterns

**In the context**:
- Unfamiliar codebase or domain
- Multiple systems involved
- Unknown dependencies
- Previous attempts have failed
- Stakeholders have different expectations

### Signals Suggesting Simplicity (Proceed Directly)

**In the request**:
- "Fix this..."
- "Change X to Y"
- "Add [specific thing] to [specific location]"
- "Update the [specific value]"
- "Remove [specific thing]"
- Single, specific action requested
- Clear before/after state described

**In the context**:
- Familiar codebase
- Single file or module
- No dependencies to consider
- Straightforward pattern

---

## Partial Optimization

For tasks in the middle ground, consider **partial optimization**:

1. **Quick context check** — Scan relevant areas without deep analysis
2. **Key assumptions** — List 2-3 critical assumptions briefly
3. **Main risk** — Note any obvious concern
4. **Proceed** — Start work with invitation to pause if complexity emerges

**Format for partial optimization**:
```
This task appears moderately complex. Quick assessment:

**Key assumptions**: [1-2 critical assumptions]
**Main files**: [2-3 relevant files]
**Risk note**: [Any obvious concern]

Proceeding with implementation. I'll pause if I encounter unexpected complexity.
```

---

## Complexity Escalation

Sometimes tasks reveal complexity during execution. Watch for:

- **Unexpected dependencies** — Changes cascading to other areas
- **Missing context** — Realizing you need information you don't have
- **Conflicting patterns** — Finding inconsistent approaches
- **Scope expansion** — Discovering the "simple" fix requires more work
- **Test failures** — Changes breaking things unexpectedly

If these occur, pause and consider:
1. Communicating the discovered complexity to the user
2. Running a quick optimization analysis on the new understanding
3. Revising the approach before continuing

---

## Decision Flowchart

```
START
  │
  ▼
Is the task a single, specific action?
  │
  ├─ YES → Is the requirement unambiguous?
  │          │
  │          ├─ YES → PROCEED DIRECTLY
  │          │
  │          └─ NO → Clarify, then proceed or analyze
  │
  └─ NO → Does it involve multiple areas or decisions?
           │
           ├─ YES → USE FULL OPTIMIZATION
           │
           └─ NO → Is the domain/codebase familiar?
                    │
                    ├─ YES → PARTIAL OPTIMIZATION
                    │
                    └─ NO → USE FULL OPTIMIZATION
```

---

## Summary Checklist

Before starting any task:

```
□ Single, specific action? → Proceed directly
□ Multiple areas or files? → Consider full analysis
□ Unfamiliar territory? → Lean toward full analysis
□ Ambiguous requirements? → Definitely analyze
□ High stakes or risk? → Definitely analyze
□ User asked for planning? → Use full analysis
□ Simple fix or change? → Proceed directly
□ In the middle? → Use partial optimization
```

---

## Calibration Principle

Time spent on appropriate analysis saves time overall by preventing rework.
Time spent on unnecessary analysis is waste.

**Err toward analysis when**:
- The user seems uncertain
- The domain is unfamiliar
- The task description is vague
- Stakes are high

**Err toward proceeding when**:
- The user gives specific instructions
- The task is clearly bounded
- You've done similar work before
- Quick exploration reveals no surprises
