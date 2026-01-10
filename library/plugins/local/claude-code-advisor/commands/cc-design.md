---
description: Design a Claude Code configuration for a specific goal
argument-hint: [goal or requirements]
---

# Design Claude Code Configuration

Design an architecture combining Claude Code features to meet a specific goal.

## When Invoked

Use the cc-architecture-designer subagent to create a cohesive configuration design.

## Your Task

1. **Understand the goal** from $ARGUMENTS
2. **Gather requirements** if not clear:
   - What should Claude do better?
   - How often is this needed?
   - Project-specific or user-wide?
   - Any external integrations?
3. **Dispatch cc-architecture-designer** with requirements
4. **Present the design** for user approval
5. **Optionally generate files** using specialized generators:
   - **cc-skill-generator** for SKILL.md files
   - **cc-agent-generator** for subagent definitions
   - **cc-config-generator** for commands, hooks, CLAUDE.md, MCP

## Design Output

The architecture design will include:

1. **Memory configuration** (CLAUDE.md locations and content)
2. **Skills** (reusable workflows with triggers)
3. **Subagents** (isolated specialized tasks)
4. **Hooks** (automated responses to events)
5. **MCP servers** (external tool integrations)
6. **Commands** (explicit user actions)

## Workflow

```
/cc-design [goal]
    ↓
Gather/clarify requirements
    ↓
cc-architecture-designer produces design
    ↓
User reviews and approves
    ↓
For skills: cc-skill-generator
For agents: cc-agent-generator
For config: cc-config-generator
    ↓
cc-implementation-reviewer validates
```

## Examples

- `/cc-design improve code review workflow`
- `/cc-design enforce security policies before commits`
- `/cc-design automate testing and deployment`
- `/cc-design add domain-specific coding guidelines`
