# Plugins

> Claude Code plugins: official, community, and locally-developed.

## What's Here

| Folder | Purpose |
|--------|---------|
| `official/` | Pointers to official Anthropic plugins |
| `community/` | Pointers to quality community plugins |
| `local/` | Plugins we own and develop |

## Quick Start

### Browse Available Plugins
See `CATALOG.md` for the complete inventory.

### Install an Official Plugin
```bash
/plugin install {plugin-name}@claude-plugin-directory
```

### Use a Local Plugin
Plugins in `local/` can be used directly or installed via:
```bash
claude --plugin-dir ./local/plugin-name
```

## Plugin Categories

### Official (Anthropic)
- Maintained by Anthropic
- High trust level
- Available via built-in marketplace

### Community
- Third-party plugins
- Quality varies - see evaluation notes
- Install commands provided

### Local
- Plugins developed/owned by the repository owner
- Production-ready: `claude-code-advisor`, `context-introspection`

## Source Material

Migrating from old repo:
- `11-external-resources/plugins/claude-code-advisor/`
- `11-external-resources/plugins/context-introspection/`
- `11-external-resources/plugins/REGISTRY.md` (community evaluations)

External sources:
- https://github.com/anthropics/claude-code/plugins
- https://github.com/anthropics/claude-plugins-official

## Status

PLACEHOLDER - Plugin migration and index creation pending.
