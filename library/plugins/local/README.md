# Local Plugins

> Plugins developed and owned locally.

---

## What's Here

| Plugin | Purpose | Commands |
|--------|---------|----------|
| `claude-code-advisor/` | Strategic advisor for Claude Code features | `/cc-advisor`, `/cc-analyze`, `/cc-verify`, `/cc-design` |
| `context-introspection/` | Session context reporting | `/context-introspection:report` |

---

## claude-code-advisor

A comprehensive strategic advisor plugin for Claude Code with:
- **10 specialized agents** for different advisory roles
- **22 reference files** with detailed Claude Code documentation
- **4 slash commands** for different use cases

### Commands
- `/cc-advisor` - General strategic advice
- `/cc-analyze` - Analyze a specific feature or pattern
- `/cc-verify` - Verify implementation against best practices
- `/cc-design` - Design architecture for Claude Code projects

### Structure
```
claude-code-advisor/
├── .claude-plugin/
│   └── plugin.json
├── agents/           # 10 specialized advisory agents
├── references/       # 22 documentation files
├── commands/         # 4 slash commands
└── skills/           # Supporting skills
```

---

## context-introspection

Generates comprehensive reports of all context sources active in a Claude Code session:
- CLAUDE.md files (global, project, local)
- Skills and their activation triggers
- Hooks and their configurations
- MCP servers and connections
- Custom agents and commands

### Usage
```bash
# Run the introspection report
/context-introspection:report
```

### Structure
```
context-introspection/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   └── report.md
└── README.md
```

---

## Installation

### Use Directly
```bash
claude --plugin-dir ./claude-code-advisor
```

### Add to Settings
Add to `~/.claude/settings.json`:
```json
{
  "plugins": {
    "directories": ["path/to/library/plugins/local/claude-code-advisor"]
  }
}
```

### Project-Specific
Add to `.claude/settings.json` in your project.

---

## Development

These plugins are production-ready but can be extended. To modify:
1. Edit files in the plugin directory
2. Test with `claude --plugin-dir ./[plugin-name]`
3. Document changes in the plugin's README

For WIP plugins, see `experimental/plugins/`.

---

## Status

MIGRATED - 2 production plugins from old repo.
Migrated: 2026-01-09
