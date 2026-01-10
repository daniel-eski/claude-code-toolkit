# Claude Code Advisor

A Claude Code plugin that gives Claude deep, accurate knowledge about its own extensibility features.

## Quick Start

```bash
# Add the plugin
claude plugin add /path/to/claude-code-advisor

# Enable it
claude plugin enable claude-code-advisor

# Try it
/cc-advisor "what's the difference between skills and subagents?"
```

## What It Does

Claude often gives generic advice about its own features. This plugin provides:

- **10 specialized subagents** for research, analysis, design, and generation
- **22 reference files** covering skills, subagents, hooks, memory, commands, MCP
- **4 slash commands**: `/cc-advisor`, `/cc-analyze`, `/cc-verify`, `/cc-design`
- **Decision frameworks** grounded in official documentation

## Documentation

| Document | Description |
|----------|-------------|
| [docs/README.md](docs/README.md) | Full feature overview |
| [docs/INSTALLATION.md](docs/INSTALLATION.md) | Setup and troubleshooting |
| [docs/USAGE-GUIDE.md](docs/USAGE-GUIDE.md) | Command examples |
| [docs/CHANGELOG.md](docs/CHANGELOG.md) | Version history |

## Plugin Structure

```
claude-code-advisor/
├── .claude-plugin/plugin.json    # Plugin manifest
├── skills/claude-code-advisor/   # Main skill + 22 references
├── agents/                       # 10 specialized subagents
├── commands/                     # 4 slash commands
└── docs/                         # Human documentation
```

## License

MIT - See [LICENSE](LICENSE)
