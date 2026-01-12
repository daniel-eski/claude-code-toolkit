---
description: Reflect on completed work and suggest workflow optimizations
argument-hint: [optional: focus area]
allowed-tools: Bash(git status:*), Bash(git diff --stat:*)
---

# Workflow Reflection Request

## Session Context
Working tree: !`git status --short 2>/dev/null | head -10 || echo "Not a git repo"`
Recent changes: !`git diff --stat HEAD~3 2>/dev/null | tail -5 || echo "No recent commits"`

## Focus Area
$ARGUMENTS

## Analysis Required

1. **Summary** - What was accomplished
2. **What worked** - Patterns to preserve
3. **Friction points** - What slowed progress or needed correction
4. **Recommendations** - Claude Code optimizations:
   - CLAUDE.md: Missing context/conventions
   - Commands: Repeated prompt patterns
   - Skills: Domain expertise that should auto-invoke
   - Hooks: Automated validation checks

Provide copy-ready implementation for each recommendation.
Prioritize by impact-to-effort ratio.
