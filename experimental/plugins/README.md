# Experimental Plugins

> Work in progress plugins being developed and tested.

---

## What's Here

| Plugin | Description | Status |
|--------|-------------|--------|
| `workflow-optimizer-plugin/` | 3 skills (prompt-optimizer, planning-with-files, agent-architect) + 3 commands | WIP - needs testing |
| `workflow-optimizer-kit/` | CLAUDE.md config, rules, /kickoff + /reflect commands, workflow-reflection skill | WIP - needs testing |

---

## Workflow Optimizer Plugin

**Source**: https://github.com/daniel-eski/ClaudeCodeWorkflowOptimizerPluginBasicV1
**Branch**: `feature/v3-workflow-system`
**Cloned**: 2026-01-09

### Skills Included
- **prompt-optimizer**: Clarify objectives before complex tasks (6-step analysis process)
- **planning-with-files**: Persistent context management with task plans and findings
- **agent-architect**: Design and configure Claude Code agent setups

### Commands Included
- `/optimize` - Run prompt optimization
- `/plan-files` - Planning with file context
- `/architect` - Agent architecture design

### Key Files
- `skills/prompt-optimizer/SKILL.md` - Main prompt optimization skill
- `skills/prompt-optimizer/COMPLEXITY-GUIDE.md` - When to use full analysis
- `skills/planning-with-files/` - File-based planning with templates
- `skills/agent-architect/references/` - Reference docs for Claude Code features

---

## Workflow Optimizer Kit

**Source**: https://github.com/daniel-eski/ClaudeCodeWorkflowOptimizerKitV1
**Branch**: `best-practices-v2`
**Cloned**: 2026-01-09

### Contents
- **CLAUDE.md config**: Optimized configuration for Claude Code
- **Rules**: Planning and TypeScript rules
- **Commands**: `/kickoff` and `/reflect` for workflow management
- **Skills**: workflow-reflection skill

### Key Files
- `config/CLAUDE.md` - Ready-to-use Claude Code configuration
- `config/commands/kickoff.md` - Start task with structured planning
- `config/commands/reflect.md` - Post-task reflection for optimization
- `config/skills/workflow-reflection/SKILL.md` - Analyze completed work

---

## How to Use

### Testing a WIP Plugin
1. Review the plugin's README for setup instructions
2. Copy relevant configs/skills to your project's `.claude/` folder
3. Test in real usage scenarios
4. Document what works and what doesn't

### Development Workflow
1. Make changes in this folder
2. Test thoroughly
3. Document improvements
4. When ready, graduate to `library/plugins/local/`

---

## Graduation Path

When a plugin is production-ready:

```
experimental/plugins/[name]/ → library/plugins/local/[name]/
```

Requirements for graduation:
- [ ] Works as intended
- [ ] Properly documented
- [ ] Has plugin.json (if applicable)
- [ ] README explains usage
- [ ] Tested in real scenarios

---

## Status

ACTIVE - Contains 2 WIP plugins cloned from owner's GitHub repos.
