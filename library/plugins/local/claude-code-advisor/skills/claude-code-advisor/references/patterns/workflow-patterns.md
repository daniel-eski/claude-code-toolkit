# Workflow Patterns

Recommended workflows for effective Claude Code usage.

## Pattern 1: Explore → Plan → Code → Commit

The recommended development workflow.

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   EXPLORE   │────▶│    PLAN     │────▶│    CODE     │────▶│   COMMIT    │
│ Understand  │     │ Design      │     │ Implement   │     │ Review      │
│ codebase    │     │ approach    │     │ changes     │     │ & commit    │
└─────────────┘     └─────────────┘     └─────────────┘     └─────────────┘
```

**Tools for each phase**:
- **Explore**: Subagent (Explore type) for fast search
- **Plan**: Plan mode or dedicated planning subagent
- **Code**: Main conversation with relevant skills
- **Commit**: `/commit` command or commit skill

**User checkpoints**: Between Plan→Code, Code→Commit

---

## Pattern 2: Test-Driven Development (TDD)

Write tests first, then implement.

```
1. Understand requirements
2. Write failing tests
3. Run tests (confirm failure)
4. Implement until tests pass
5. Refactor
6. Repeat
```

**Why it works with Claude**: Clear evaluation criteria (tests passing) guide implementation.

**Configuration support**:
```yaml
# .claude/skills/tdd/SKILL.md
---
name: tdd-workflow
description: TDD expertise. Use when writing tests or implementing features with tests.
---

# TDD Workflow
1. Write test for smallest unit of functionality
2. Run test, confirm failure
3. Write minimal code to pass
4. Refactor while keeping tests green
```

---

## Pattern 3: Multi-Instance / Parallel Work

Use multiple Claude sessions for throughput.

```
┌─────────────────┐
│ ORCHESTRATOR    │
│ (Main session)  │
├─────────────────┤
│ Designs work    │
│ Coordinates     │
│ Reviews outputs │
└────────┬────────┘
         │
    ┌────┴────┐
    ▼         ▼
┌───────┐  ┌───────┐
│WORKER1│  │WORKER2│
│Session│  │Session│
└───────┘  └───────┘
```

**Use cases**:
- Parallel file processing
- Independent feature branches
- Batch operations

**Configuration**: Same CLAUDE.md/skills across instances for consistency.

---

## Pattern 4: Review Checkpoint

Insert review points in workflows.

```
Work → CHECKPOINT → Review → Continue/Fix
```

**Implement with hooks**:
```json
{
  "hooks": {
    "Stop": [{
      "hooks": [{
        "type": "prompt",
        "prompt": "Before stopping, verify: 1) Tests pass 2) No TODOs left 3) Code reviewed"
      }]
    }]
  }
}
```

---

## Pattern 5: Incremental Enhancement

Build features incrementally with user feedback.

```
Minimal viable → User feedback → Enhance → Repeat
```

**Steps**:
1. Implement core functionality
2. Get user approval
3. Add enhancements
4. Iterate

**Why it works**: Prevents over-engineering, ensures alignment.

---

## Pattern 6: Context-Preserving Handoff

For long tasks that may exceed context.

**During work**:
1. Use TodoWrite tool to track progress
2. Update CLAUDE.md notes section periodically
3. Commit partial work with clear messages

**Handoff prep**:
1. Document current state
2. List remaining work
3. Note any blockers or decisions needed

**New session**:
1. Read documentation
2. Check git log for recent changes
3. Continue from documented state

---

## Workflow Selection Guide

| Scenario | Workflow |
|----------|----------|
| New feature | Explore → Plan → Code → Commit |
| Bug fix | Explore → Fix → Test → Commit |
| With clear specs | TDD |
| Large batch work | Multi-Instance |
| Critical changes | Review Checkpoint |
| Uncertain requirements | Incremental Enhancement |
| Long task | Context-Preserving Handoff |

See also:
- `composition-patterns.md` for feature combinations
- `../decision-guides/architecture-selection.md` for choosing features
