# Backlog: User's WIP Assets

> Help user develop, test, and potentially integrate their work-in-progress projects.

---

## Goal

Support the repository owner in developing, testing, and eventually integrating their personal work-in-progress projects.

## User's WIP Projects

### ClaudeCodeWorkflowOptimizerPluginBasicV1
- **Branch**: feature/v3-workflow-system
- **URL**: https://github.com/daniel-eski/ClaudeCodeWorkflowOptimizerPluginBasicV1
- **Contains**:
  - 3 skills (prompt-optimizer, planning-with-files, agent-architect)
  - 3 commands
  - Reference docs
- **Status**: "probably needs more development after more testing" (user's words)

### ClaudeCodeWorkflowOptimizerKitV1
- **Branch**: best-practices-v2
- **URL**: https://github.com/daniel-eski/ClaudeCodeWorkflowOptimizerKitV1
- **Contains**:
  - CLAUDE.md config
  - Rules
  - /kickoff and /reflect commands
  - workflow-reflection skill
- **Status**: "probably needs more development after more testing" (user's words)

### Safety System - INTEGRATED
- **Components**: Hooks and claude-code-safety-net integration
- **Custom additions**: User has developed additional custom hooks
- **Status**: ~~"still WIP, just note I will eventually test and add in once it works well" (user's words)~~
- **Integrated**: `library/plugins/local/guardrails/` (2026-01-12)
- **Note**: User maintains active installation at `~/.claude/`. Toolkit copy provided for shareability.

## How to Help

### For Testing
1. Pull the relevant branch
2. Test functionality in real usage scenarios
3. Document what works and what doesn't
4. Provide feedback on improvements

### For Development
1. Understand the project's goals
2. Identify areas that need work
3. Propose improvements
4. Implement changes if requested

### For Integration
When a project is ready:
1. Add to `experimental/` first
2. Test in context of this repo
3. Move to `library/` when stable
4. Document properly

## Integration Path

```
User's external repo → experimental/plugins/[name]/ → library/plugins/local/[name]/
```

## Notes

- These are the user's personal projects
- Respect their development timeline
- Don't push integration before they're ready
- Testing should be in sandbox/experimental first

## What Claude Code Agents Can Do

When asked to help with these projects:
1. Clone/pull the relevant branch
2. Explore the codebase
3. Test functionality
4. Provide analysis and suggestions
5. Make improvements if requested
6. Document findings

---

## Status

DEFERRED - User will indicate when ready for testing/integration.
