---
description: Run prompt optimization analysis to clarify objectives, surface assumptions, identify context needs, and ensure alignment before executing a complex task.
argument-hint: [task description]
allowed-tools: Read, Grep, Glob
---

# Prompt Optimization Request

The user wants to run prompt optimization analysis on the following task:

**Task**: $ARGUMENTS

Please activate the prompt-optimizer skill and run the full analysis process:

1. Restate the objective clearly
2. Surface assumptions being made
3. Identify critical context needed (files, directories, information)
4. Flag risks and ambiguities
5. Propose a high-level approach
6. Ask any clarifying questions

Provide structured output following the skill's format.

**Important**: This is about understanding the task, not configuring tools. Do NOT recommend subagents, hooks, CLAUDE.md additions, or other Claude Code configuration.

**Workflow integration**:
- For complex multi-step tasks, suggest `planning-with-files` to establish persistent context
- For configuration needs, suggest `agent-architect` after alignment

If the task is simple and doesn't warrant full analysis, note that and proceed directly instead.
