---
name: planning-with-files
description: Establish persistent context management for complex, multi-step tasks using markdown files as working memory. Use when starting multi-step projects (3+ steps), research tasks, feature development, debugging sessions, or any work requiring many tool calls. Creates task_plan.md, findings.md, and progress.md to prevent context loss.
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Planning with Files

This skill implements file-based planning for complex tasks, creating persistent markdown files as "working memory on disk" for multi-step projects.

## Core Concept

**Context Window = RAM (volatile, limited)**
**Filesystem = Disk (persistent, unlimited)**

Anything important should be written to disk rather than relying solely on the context window. After ~50 tool calls, original goals can be forgotten ("lost in the middle" effect). File-based planning solves this.

## When to Use This Skill

**Use for:**
- Multi-step tasks (3+ steps)
- Research projects
- Feature development
- Debugging sessions
- Complex refactoring
- Any work requiring many tool calls

**Skip for:**
- Simple questions
- Single-file edits
- Quick lookups
- Tasks completable in 1-2 actions

## The Three Essential Files

Create these in the project root or a dedicated directory:

### 1. task_plan.md
Tracks phases, decisions, and overall progress.

```markdown
# Task Plan: [Task Name]

## Goal
[Clear statement of what we're trying to accomplish]

## Phases
- [ ] Phase 1: [Description]
- [ ] Phase 2: [Description]
- [ ] Phase 3: [Description]

## Key Questions
1. [Question that needs answering]
2. [Question that needs answering]

## Decisions Made
- [Decision and rationale]

## Errors Encountered
- [Error and how it was resolved]

## Status
**Currently in Phase X** - [What's happening now]
```

### 2. findings.md
Stores research, discoveries, and important information found during the task.

```markdown
# Findings: [Task Name]

## Key Discoveries
- [Discovery 1]
- [Discovery 2]

## Files Examined
- `path/to/file.ts` - [What we learned]

## External Research
- [Source]: [Key information]

## Notes
[Any other relevant information]
```

### 3. progress.md
Maintains session logs, tracks what's done, and records file changes.

```markdown
# Progress Log: [Task Name]

## Current Phase: [X]
## Overall Status: [In Progress / Blocked / Complete]

## Session Log

### [Date/Session]
**Completed:**
- [Action taken]
- [Action taken]

**Next:**
- [Upcoming action]

## Files Changed
| File | Action | Notes |
|------|--------|-------|
| path/file.ts | Modified | [What changed] |

## Blockers
[Any blockers or None]
```

## Critical Rules

### The 2-Action Rule
> After every 2 view/browser/search operations, IMMEDIATELY save key findings to files.

This prevents loss of information, especially from visual or multimodal content that can't be perfectly retained in context.

### Read Before Decide
> Before major decisions, re-read task_plan.md.

This brings your goals back into the recent attention window, preventing drift during long tool-use sequences.

### Update After Act
> After completing any phase, update the files.

- Mark phase status from `[ ]` to `[x]`
- Log any errors encountered
- Note file changes in progress.md

### The 3-Strike Error Protocol
When something fails:
1. **Strike 1:** Attempt targeted diagnosis and fix
2. **Strike 2:** Try an alternative approach
3. **Strike 3:** Step back and rethink the entire approach

After three failures on the same issue, escalate to the user with specific details about what was tried.

**Critical:** If an action failed, the next action MUST be different. Track what you tried. Mutate the approach.

## The Planning Loop

```
┌─────────────────────────────────────────┐
│  1. READ task_plan.md (refresh goals)   │
├─────────────────────────────────────────┤
│  2. ASSESS current phase and blockers   │
├─────────────────────────────────────────┤
│  3. EXECUTE next action                 │
├─────────────────────────────────────────┤
│  4. WRITE findings to files             │
├─────────────────────────────────────────┤
│  5. UPDATE progress.md                  │
├─────────────────────────────────────────┤
│  6. ITERATE (return to step 1)          │
└─────────────────────────────────────────┘
```

## Quick Start

When starting a complex task:

1. **Create task_plan.md** with goal, phases, and key questions
2. **Create findings.md** (can start empty)
3. **Create progress.md** with initial status
4. Begin work, following the critical rules

## 5-Question Reboot Test

If you feel lost during a long task, answer these:
1. **Where am I?** (Current phase)
2. **Where am I going?** (Next phase)
3. **What's the goal?** (Overall objective)
4. **What have I learned?** (Key findings)
5. **What have I done?** (Completed actions)

If you can't answer these from memory, read your planning files.

## Integration with Workflow

This skill is part of the workflow-optimizer plugin. For complex projects:

1. **First:** Use `prompt-optimizer` to clarify objectives and align understanding
2. **Then:** Use this skill (`planning-with-files`) to establish persistent context
3. **Finally:** Use `agent-architect` to design CLAUDE.md and agent architecture informed by your plan

Each skill works independently, but they chain naturally for comprehensive project setup.

## Templates

See [templates/](templates/) for ready-to-use file templates:
- `task_plan_template.md`
- `findings_template.md`
- `progress_template.md`

## Reference

For the complete context engineering principles this skill is based on, see [reference.md](reference.md).

For practical examples of this pattern in action, see [examples.md](examples.md).
