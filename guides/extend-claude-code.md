# Extend Claude Code

> Build skills, plugins, and hooks to customize and extend Claude Code capabilities.

---

## When to Use This

You want to add new capabilities to Claude Code beyond what comes built-in. This includes creating reusable skills for your workflows, developing plugins with commands and agents, or setting up hooks to automate behaviors. Whether you are packaging team knowledge, automating repetitive tasks, or integrating external tools, this guide provides the resources for extending Claude Code.

---

## Quick Start

1. **Choose your extension type**: Skills for reusable instructions, plugins for commands/agents/hooks, hooks for event-driven automation
2. **Install plugin-dev**: Use `/plugin-dev:create-plugin` for guided plugin creation or review skill templates
3. **Use claude-code-advisor**: Run `/cc-advisor` for feature guidance on any extension question

---

## Resources

### Primary Tools

| Resource | Type | Location | Why |
|----------|------|----------|-----|
| plugin-dev | Plugin (official) | [library/plugins/official/CATALOG.md](../library/plugins/official/CATALOG.md#10-plugin-dev) | Comprehensive toolkit for plugin development with 8-phase workflow |
| hookify | Plugin (official) | [library/plugins/official/CATALOG.md](../library/plugins/official/CATALOG.md#8-hookify) | Create custom hooks from natural language without writing JSON |
| claude-code-advisor | Plugin (local) | [library/plugins/local/claude-code-advisor/](../library/plugins/local/claude-code-advisor/) | Deep feature guidance with 10 specialized agents |

### Supporting Resources

| Resource | Type | Location | Why |
|----------|------|----------|-----|
| skill-creator | Skill | [library/skills/core-skills/skill-authoring/skill-creator/](../library/skills/core-skills/skill-authoring/skill-creator/) | SKILL.md template generator |
| writing-skills | Skill | [library/skills/core-skills/obra-development/writing-skills/](../library/skills/core-skills/obra-development/writing-skills/) | Comprehensive skill authoring guide |
| creating-skills | Skill | [library/skills/core-skills/git-workflow/fvadicamo-dev-agent/creating-skills/](../library/skills/core-skills/git-workflow/fvadicamo-dev-agent/creating-skills/) | Alternative skill creation approach |

### Documentation

| Doc | Source | When to Read |
|-----|--------|--------------|
| Writing Tools for Agents | [anthropic.com/engineering](https://www.anthropic.com/engineering/writing-tools-for-agents) | Designing tool interfaces and MCP servers |
| Skills | [code.claude.com](https://code.claude.com/docs/en/skills) | Understanding skill structure and loading |
| Hooks Guide | [code.claude.com](https://code.claude.com/docs/en/hooks-guide) | Hook events, patterns, and examples |
| Plugins Reference | [code.claude.com](https://code.claude.com/docs/en/plugins-reference) | Plugin manifest and component specs |

> **Tip**: See [docs/claude-code/](../docs/claude-code/) for a complete index of official documentation.

---

## Recommended Workflow

1. **Clarify intent**: Decide if you need a skill (instructions), plugin (commands/agents), or hook (automation)
2. **Review existing patterns**: Check official plugins in CATALOG.md for similar implementations
3. **Use guided creation**: Run `/plugin-dev:create-plugin` for plugins or review skill templates
4. **Consult claude-code-advisor**: Use `/cc-design` to get architecture recommendations
5. **Validate structure**: Use the plugin validator scripts in plugin-dev
6. **Test incrementally**: Load your extension and test each component before publishing

---

## Extension Type Decision Guide

| You want to... | Use | Example |
|----------------|-----|---------|
| Package reusable instructions | Skill | Code review checklist, debugging methodology |
| Add slash commands | Plugin with commands | `/commit`, `/deploy` |
| Create autonomous agents | Plugin with agents | Code explorer, test analyzer |
| Automate on events | Hook (standalone or in plugin) | Block dangerous commands, lint on save |
| Integrate external tools | MCP server | Database access, API calls |

---

## Related Intents

- [learn-claude-code.md](learn-claude-code.md) - Understand Claude Code features before extending them
- [orchestrate-work.md](orchestrate-work.md) - Use extensions in multi-agent workflows
