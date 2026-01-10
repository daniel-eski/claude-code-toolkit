---
description: Get advice about Claude Code features, architecture, and best practices
argument-hint: [question or topic]
---

# Claude Code Advisor

Help the user understand Claude Code features and make architectural decisions.

## When Invoked

This command activates the claude-code-advisor skill to answer questions about:
- Skills, subagents, hooks, memory, commands, MCP
- When to use each feature
- How to combine features effectively
- Best practices and anti-patterns

## Your Task

1. **Understand the question** in $ARGUMENTS
2. **Load the claude-code-advisor skill** for context
3. **Provide clear, actionable guidance** based on official documentation

## Response Guidelines

- Be specific and practical
- Reference official documentation when possible
- Provide examples when helpful
- If uncertain, acknowledge limitations
- For complex topics, suggest reading specific reference files

## Examples

If asked about skills vs subagents:
- Explain the key differences (context sharing vs isolation)
- Provide decision criteria
- Reference `skills-vs-subagents.md` for details

If asked about hooks:
- Explain what hooks do and when to use them
- Cover common patterns (linting, security checks)
- Reference `hooks-deep-dive.md` for mechanics
