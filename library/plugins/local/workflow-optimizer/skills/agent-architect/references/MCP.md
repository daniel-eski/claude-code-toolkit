# MCP Servers Reference

Complete reference for Claude Code MCP (Model Context Protocol) server integration.

## What Are MCP Servers?

MCP servers extend Claude's capabilities by providing:
- External tool access (GitHub, databases, APIs)
- Custom functionality
- Third-party integrations

## Adding MCP Servers

### Via CLI

```bash
# HTTP server (recommended)
claude mcp add --transport http github https://api.githubcopilot.com/mcp/

# SSE server (deprecated but supported)
claude mcp add --transport sse asana https://mcp.asana.com/sse

# Local stdio server
claude mcp add --transport stdio database -- npx mcp-server-sqlite

# With environment variables
claude mcp add --transport stdio myserver \
  --env API_KEY=secret \
  --env DB_URL=postgres://... \
  -- ./my-server
```

### Via Configuration File

Create `.mcp.json` in project root (shared with team):

```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/",
      "headers": {
        "Authorization": "Bearer ${GITHUB_TOKEN}"
      }
    },
    "database": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "mcp-server-sqlite"],
      "env": {
        "DB_PATH": "${CLAUDE_PROJECT_DIR}/data.db"
      }
    },
    "custom-api": {
      "type": "http",
      "url": "https://api.example.com/mcp/",
      "headers": {
        "X-API-Key": "${API_KEY:-default_key}"
      }
    }
  }
}
```

## Transport Types

| Transport | Description | Use Case |
|-----------|-------------|----------|
| `http` | HTTP/HTTPS endpoint | Cloud services, remote APIs |
| `sse` | Server-Sent Events | Real-time services (deprecated) |
| `stdio` | Local process | Local tools, custom servers |

## Configuration Structure

### HTTP Server

```json
{
  "type": "http",
  "url": "https://api.example.com/mcp/",
  "headers": {
    "Authorization": "Bearer ${TOKEN}",
    "X-Custom-Header": "value"
  }
}
```

### SSE Server

```json
{
  "type": "sse",
  "url": "https://mcp.example.com/sse",
  "headers": {
    "Authorization": "Bearer ${TOKEN}"
  }
}
```

### Stdio Server

```json
{
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "mcp-server-name"],
  "env": {
    "CONFIG_PATH": "/path/to/config",
    "API_KEY": "${API_KEY}"
  }
}
```

## Installation Scopes

| Scope | Location | Use Case |
|-------|----------|----------|
| Local | `~/.claude.json` | Personal, default |
| Project | `.mcp.json` | Team-shared, committed to git |
| User | `~/.claude.json` | Personal, all projects |

```bash
# Install to specific scope
claude mcp add --scope project github https://...
claude mcp add --scope user github https://...
```

## Environment Variable Expansion

Variables in configuration are expanded:

```json
{
  "env": {
    "TOKEN": "${GITHUB_TOKEN}",
    "URL": "${API_URL:-https://default.com}",
    "PATH": "${CLAUDE_PROJECT_DIR}/data"
  }
}
```

**Syntax:**
- `${VAR}` — Use variable value
- `${VAR:-default}` — Use default if not set

**Special variables:**
- `${CLAUDE_PROJECT_DIR}` — Project root path
- `${CLAUDE_PLUGIN_ROOT}` — Plugin root (for plugin-bundled servers)

## Plugin-Bundled MCP Servers

Plugins can include MCP servers in `.mcp.json` or `plugin.json`:

```json
{
  "mcpServers": {
    "plugin-api": {
      "command": "${CLAUDE_PLUGIN_ROOT}/servers/api-server",
      "args": ["--port", "8080"]
    }
  }
}
```

## Managing MCP Servers

```bash
# List configured servers
claude mcp list

# Remove a server
claude mcp remove github

# View server details
claude mcp info github
```

## Permissions for MCP Tools

Control MCP tool access in settings.json:

```json
{
  "permissions": {
    "allow": [
      "mcp__github__*",
      "mcp__database__query"
    ],
    "deny": [
      "mcp__database__delete"
    ]
  }
}
```

**Pattern syntax:**
- `mcp__server__*` — All tools from server
- `mcp__server__tool` — Specific tool

## Managed MCP Configuration

For enterprise control:

### Option 1: Exclusive Control

Deploy `managed-mcp.json` to system directories:
- macOS: `/Library/Application Support/ClaudeCode/managed-mcp.json`
- Linux: `/etc/claude-code/managed-mcp.json`

### Option 2: Policy Control

In `managed-settings.json`:

```json
{
  "allowedMcpServers": [
    { "serverName": "github" },
    { "serverCommand": ["npx", "-y", "approved-server"] },
    { "serverUrl": "https://mcp.company.com/*" }
  ],
  "deniedMcpServers": [
    { "serverName": "untrusted-server" },
    { "serverUrl": "https://external-*" }
  ]
}
```

## Common MCP Servers

### GitHub

```json
{
  "github": {
    "type": "http",
    "url": "https://api.githubcopilot.com/mcp/",
    "headers": {
      "Authorization": "Bearer ${GITHUB_TOKEN}"
    }
  }
}
```

### SQLite Database

```json
{
  "sqlite": {
    "type": "stdio",
    "command": "npx",
    "args": ["-y", "@anthropic/mcp-server-sqlite"],
    "env": {
      "SQLITE_PATH": "${CLAUDE_PROJECT_DIR}/database.db"
    }
  }
}
```

### PostgreSQL

```json
{
  "postgres": {
    "type": "stdio",
    "command": "npx",
    "args": ["-y", "mcp-server-postgres"],
    "env": {
      "DATABASE_URL": "${DATABASE_URL}"
    }
  }
}
```

### Filesystem (Extended Access)

```json
{
  "filesystem": {
    "type": "stdio",
    "command": "npx",
    "args": ["-y", "@anthropic/mcp-server-filesystem"],
    "env": {
      "ALLOWED_PATHS": "/data,/shared"
    }
  }
}
```

## Best Practices

1. **Use project scope for team tools** — Commit `.mcp.json` to git
2. **Use environment variables for secrets** — Never hardcode tokens
3. **Prefer HTTP transport** — More reliable than SSE
4. **Set up permissions** — Restrict MCP tools as needed
5. **Test locally first** — Verify server works before adding

## Troubleshooting

### Server Not Connecting

1. Check server is running (for stdio)
2. Verify URL is correct (for http/sse)
3. Check authentication headers
4. Review Claude Code logs

### Tools Not Appearing

1. Restart Claude Code after adding server
2. Check MCP server is properly configured
3. Verify permissions allow the tools

### Environment Variables Not Expanding

1. Ensure variable is set in shell
2. Check syntax (`${VAR}` not `$VAR`)
3. For defaults, use `${VAR:-default}`
