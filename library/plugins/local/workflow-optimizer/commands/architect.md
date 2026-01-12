---
description: Design optimal Claude Code agent architecture (CLAUDE.md, subagents, hooks, skills, MCP) based on project context.
argument-hint: [workflow type or task description]
allowed-tools: Read, Write, Edit, Glob, Grep, Bash(ls:*), Bash(cat:*)
---

# Agent Architecture Request

The user wants Claude Code architecture designed for their project.

**Context**: $ARGUMENTS

Please activate the agent-architect skill and:

1. **Check for planning files** — Look for task_plan.md, findings.md, progress.md
   - If found: Read them to understand the task phases and context
   - If not found: Note this and proceed with the provided context

2. **Assess current configuration** — Check for existing .claude/, CLAUDE.md, etc.

3. **Read reference documentation** — Before recommending, read the appropriate reference files:
   - `skills/agent-architect/references/SUBAGENTS.md` for subagent syntax
   - `skills/agent-architect/references/HOOKS.md` for hook syntax
   - `skills/agent-architect/references/MEMORY.md` for CLAUDE.md patterns
   - etc.

4. **Design architecture** — Based on context, recommend:
   - CLAUDE.md content tailored to the project
   - Subagents for specific phases/tasks
   - Hooks for automation
   - Any other relevant configuration

5. **Provide complete files** — Output ready-to-use file contents with exact paths

**Guidelines**:
- Focus on configuration, not task planning
- If no planning files exist and the task seems complex, suggest using `planning-with-files` first
- Use templates from `skills/agent-architect/templates/` as starting points
- Ensure all syntax matches current Claude Code specifications
