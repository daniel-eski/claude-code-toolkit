# Context Introspection Plugin

> ⚠️ **Experimental**: This plugin is functional but under active development.
> See [ROADMAP.md](ROADMAP.md) for planned enhancements and known limitations.

A Claude Code plugin that generates a comprehensive report of all context sources influencing your current session.

## The Problem

When starting a Claude Code session, you often don't know:
- Which CLAUDE.md files are active and what they contain
- What skills, hooks, agents, or MCP servers are loaded
- How these might shape Claude's behavior on your next prompt

The built-in `/context` command shows token usage, but not *content*. This plugin shows you the substance of what's loaded.

## Installation

### From Local Directory (Development)
```bash
claude --plugin-dir /path/to/context-introspection
```

### From Marketplace (when available)
```bash
claude plugin install context-introspection@marketplace-name
```

## Usage

```
/context-introspection:report           # Generate report and open it
/context-introspection:report --no-open # Generate without opening
```

The report is saved to `.claude/context-report.md` in your project directory.

## What the Report Shows

| Section | What's Included |
|---------|-----------------|
| **Summary** | Quick counts for all categories |
| **Memory Files** | Enterprise → User → Project → Local hierarchy with previews |
| **Skills** | Name, description, allowed-tools, instruction preview |
| **Hooks** | Full JSON of configured hooks per source |
| **MCP Servers** | Server names, types, URLs/commands |
| **Agents** | Description, tools, model configuration |
| **Commands** | Name, namespace, arguments, preview |

Each item includes:
- Clickable `file://` links to the source file
- File size and modification date
- Collapsible `<details>` previews (first 10-15 lines)

## Context Sources Enumerated

### Memory Files (CLAUDE.md)
- Enterprise: `/Library/Application Support/ClaudeCode/CLAUDE.md` (macOS)
- User: `~/.claude/CLAUDE.md`
- User Rules: `~/.claude/rules/*.md`
- Project: `./CLAUDE.md` or `./.claude/CLAUDE.md` (recursive up to root)
- Project Rules: `./.claude/rules/*.md`
- Local: `./CLAUDE.local.md`

### Skills
- User: `~/.claude/skills/*/SKILL.md`
- Project: `.claude/skills/*/SKILL.md`

### Hooks
- User: `~/.claude/settings.json` → hooks
- Project: `.claude/settings.json` → hooks
- Local: `.claude/settings.local.json` → hooks
- Enterprise: `managed-settings.json` → hooks

### MCP Servers
- User: `~/.claude.json` → mcpServers
- Project: `.mcp.json`
- Enterprise: `managed-mcp.json`

### Agents
- User: `~/.claude/agents/*.md`
- Project: `.claude/agents/*.md`

### Custom Commands
- User: `~/.claude/commands/*.md`
- Project: `.claude/commands/*.md`

## Requirements

- Python 3.9+
- Claude Code v2.1.x or later

## Plugin Structure

```
context-introspection/
├── .claude-plugin/
│   └── plugin.json       # Plugin manifest
├── commands/
│   └── report.md         # The /report slash command
├── scripts/
│   └── introspect.py     # Python enumeration script
└── README.md
```

## License

MIT
