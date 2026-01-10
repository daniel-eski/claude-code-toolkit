# MCP (Model Context Protocol) Deep Dive

MCP connects Claude Code to external tools and data sources via a standard protocol.

## What MCP Provides

MCP provides **tool availability**, not knowledge:
- Database queries
- API integrations
- External services
- Custom tools

**MCP + Skill = Tools + Knowledge**: Use skills to teach Claude how to use MCP tools effectively.

## Transport Types

| Type | Use Case | Command |
|------|----------|---------|
| **HTTP** | Cloud services (recommended) | `--transport http` |
| **SSE** | Server-Sent Events (deprecated) | `--transport sse` |
| **stdio** | Local processes | `--transport stdio` |

## Adding MCP Servers

```bash
# HTTP (remote)
claude mcp add --transport http notion https://mcp.notion.com/mcp

# stdio (local)
claude mcp add --transport stdio db -- npx -y @bytebase/dbhub --dsn "..."
```

## Configuration Scopes

| Scope | Location | Shared? |
|-------|----------|---------|
| **local** | `~/.claude.json` (project path) | No |
| **project** | `.mcp.json` | Yes (via git) |
| **user** | `~/.claude.json` | No (all projects) |

```bash
claude mcp add --scope project my-server ...
```

## MCP Tool Naming

MCP tools follow pattern `mcp__<server>__<tool>`:
```
mcp__github__create_issue
mcp__postgres__query
```

## MCP Resources and Prompts

**Resources** - Reference with `@`:
```
Analyze @github:issue://123
```

**Prompts** - Invoke as commands:
```
/mcp__github__list_prs
```

## Plugin MCP Servers

Plugins can bundle MCP servers in `.mcp.json`:
```json
{
  "database-tools": {
    "command": "${CLAUDE_PLUGIN_ROOT}/servers/db-server",
    "args": ["--config", "config.json"]
  }
}
```

Auto-start when plugin enabled.

## Environment Variables

In `.mcp.json`:
```json
{
  "mcpServers": {
    "api": {
      "type": "http",
      "url": "${API_BASE_URL}/mcp",
      "headers": { "Authorization": "Bearer ${API_KEY}" }
    }
  }
}
```

Supports `${VAR}` and `${VAR:-default}` syntax.

## Management Commands

```bash
claude mcp list        # Show all servers
claude mcp get github  # Server details
claude mcp remove github
/mcp                   # In-session management
```

## Best Practices

1. **Use project scope** for team-shared servers (`.mcp.json`)
2. **Combine with skills** - Skill teaches query patterns, MCP provides tools
3. **Hooks can monitor** MCP tools via `mcp__*` matchers
4. **OAuth authentication** - Use `/mcp` to authenticate

See also:
- `../patterns/composition-patterns.md` for MCP + Skill pattern
