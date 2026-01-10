# Plugin Structure Guide

Step-by-step guide to creating Claude Code plugins.

## What is a Plugin?

A plugin bundles related Claude Code components:
- Skills
- Agents (subagents)
- Commands
- Hooks
- MCP servers

## Step 1: Create Plugin Directory

```bash
mkdir -p my-plugin/.claude-plugin
```

## Step 2: Create plugin.json

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "Brief description of the plugin",
  "skills": "./skills/",
  "agents": "./agents/",
  "commands": "./commands/",
  "hooks": "./hooks/hooks.json"
}
```

### Required Fields

| Field | Description |
|-------|-------------|
| `name` | Unique plugin identifier |
| `version` | Semantic version |

### Optional Fields

| Field | Description |
|-------|-------------|
| `description` | What the plugin does |
| `skills` | Path to skills directory |
| `agents` | Path to agents directory |
| `commands` | Path to commands directory |
| `hooks` | Path to hooks config file |
| `mcpServers` | Inline MCP server definitions |

## Step 3: Add Components

### Directory Structure

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   └── my-skill/
│       └── SKILL.md
├── agents/
│   └── my-agent.md
├── commands/
│   └── my-command.md
├── hooks/
│   └── hooks.json
└── docs/
    └── README.md
```

### Skills

Same format as project skills:

```yaml
# skills/my-skill/SKILL.md
---
name: my-skill
description: Plugin-provided skill...
---
# Skill content...
```

### Agents

Same format as project agents:

```yaml
# agents/my-agent.md
---
name: my-agent
description: Plugin-provided agent...
---
# Agent system prompt...
```

### Commands

Same format as project commands:

```markdown
<!-- commands/my-command.md -->
---
description: Plugin-provided command
---
# Command content...
```

### Hooks

```json
{
  "description": "Plugin hook description",
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [{
          "type": "command",
          "command": "${CLAUDE_PLUGIN_ROOT}/scripts/format.sh"
        }]
      }
    ]
  }
}
```

Use `${CLAUDE_PLUGIN_ROOT}` for plugin-relative paths.

### MCP Servers

Inline in plugin.json:

```json
{
  "mcpServers": {
    "my-server": {
      "command": "${CLAUDE_PLUGIN_ROOT}/servers/my-server",
      "args": ["--config", "${CLAUDE_PLUGIN_ROOT}/config.json"]
    }
  }
}
```

Or in separate `.mcp.json`:

```json
{
  "my-server": {
    "command": "${CLAUDE_PLUGIN_ROOT}/servers/my-server"
  }
}
```

## Step 4: Test Locally

```bash
# From your project
claude plugin add ../path/to/my-plugin
claude plugin list
claude plugin enable my-plugin
```

## Step 5: Distribution

### Via Git

```bash
claude plugin add https://github.com/user/my-plugin
```

### Via Marketplace

Publish to Claude Code marketplace (when available).

## Example: Minimal Plugin

```
minimal-plugin/
├── .claude-plugin/
│   └── plugin.json
└── skills/
    └── helper/
        └── SKILL.md
```

**plugin.json**:
```json
{
  "name": "minimal-plugin",
  "version": "1.0.0",
  "skills": "./skills/"
}
```

## Checklist

- [ ] `plugin.json` is valid JSON
- [ ] `name` is unique
- [ ] All paths are relative
- [ ] Scripts use `${CLAUDE_PLUGIN_ROOT}`
- [ ] Tested locally before distribution
- [ ] Documentation in `docs/README.md`

See also:
- `../feature-mechanics/` for component details
- Official plugin documentation at code.claude.com
