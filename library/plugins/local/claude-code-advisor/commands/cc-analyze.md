---
description: Analyze existing Claude Code configuration in a project
argument-hint: [path (optional, defaults to current project)]
---

# Analyze Claude Code Configuration

Analyze a project's existing Claude Code setup and provide recommendations.

## When Invoked

Use the cc-config-analyzer subagent to:
1. Scan the project for Claude Code configuration files
2. Inventory all configured features (skills, agents, hooks, etc.)
3. Identify issues and improvement opportunities
4. Provide prioritized recommendations

## Your Task

1. **Determine the path** to analyze (from $ARGUMENTS or current project)
2. **Dispatch the cc-config-analyzer subagent** with the target path
3. **Summarize the findings** clearly for the user

## What Gets Analyzed

- `.claude/settings.json` - Project settings
- `CLAUDE.md` files - Memory hierarchy
- `.claude/skills/` - Custom skills
- `.claude/agents/` - Subagent definitions
- `.claude/commands/` - Custom commands
- Hook configurations
- MCP server configurations
- Plugin references

## Output Format

Provide:
1. Configuration inventory (what was found)
2. Issues identified (critical, warnings, suggestions)
3. Prioritized recommendations
4. Next steps for improvement
