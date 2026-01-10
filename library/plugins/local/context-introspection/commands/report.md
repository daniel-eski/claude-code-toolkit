---
description: Generate a report of all context sources influencing this Claude Code session
allowed-tools: Bash(python3:*), Bash(open:*)
argument-hint: [--no-open]
---

# Context Introspection Report

Generate a comprehensive markdown report showing all context sources currently influencing this Claude Code session, including:

- Memory files (CLAUDE.md hierarchy from enterprise → user → project → local)
- Skills (user and project level)
- Hooks configuration
- MCP servers
- Custom agents/subagents
- Custom slash commands

## Instructions

1. Run the introspection script to generate the report:

!`python3 "${CLAUDE_PLUGIN_ROOT}/scripts/introspect.py" "$CLAUDE_PROJECT_DIR" "$CLAUDE_PROJECT_DIR/.claude/context-report.md"`

2. The report has been generated at `.claude/context-report.md`

3. Open the report for the user (unless --no-open was specified):

If the user passed `--no-open` as an argument, skip opening the file. Otherwise, open it with the system default application using `open` (macOS) or `xdg-open` (Linux).

$ARGUMENTS

4. Provide a brief summary of what was found, mentioning:
   - How many memory files were found
   - How many skills are available
   - Whether any hooks are configured
   - How many MCP servers are configured
   - How many custom agents exist
   - How many custom commands exist

5. Let the user know they can:
   - View the full report at `.claude/context-report.md`
   - Ask you about any specific section
   - Use `/memory`, `/mcp`, `/agents`, or `/hooks` to manage those resources
