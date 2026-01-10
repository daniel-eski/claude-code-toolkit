---
description: Set up file-based planning for persistent context management using Manus principles.
argument-hint: [optional task description]
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Planning with Files Request

The user wants to establish persistent context management for their work.

**Context**: $ARGUMENTS

Please activate the planning-with-files skill and:

1. Assess if file-based planning is appropriate for this task
2. If appropriate, create the three planning files:
   - `task_plan.md` — Phases, decisions, status
   - `findings.md` — Research and discoveries
   - `progress.md` — Session logs, file changes
3. If a task description was provided, populate task_plan.md with initial phases
4. Explain the key rules (2-Action Rule, Read Before Decide, 3-Strike Error Protocol)

**Guidelines**:
- Use templates from `skills/planning-with-files/templates/` as a starting point
- Tailor the task_plan.md phases to the specific task if one was provided
- Explain how to use the planning files effectively

**Integration note**: After establishing planning files, suggest that `agent-architect` can design Claude Code configuration optimized for these phases.
