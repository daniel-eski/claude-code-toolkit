# Settings Reference

Complete reference for Claude Code settings.json configuration.

## Configuration Locations

Settings are loaded in precedence order (higher overrides lower):

1. **Managed settings** — System-wide enterprise policies
2. **CLI arguments** — Session-specific flags
3. **Local project** — `.claude/settings.local.json` (personal, not committed)
4. **Project** — `.claude/settings.json` (shared via git)
5. **User** — `~/.claude/settings.json` (personal, all projects)

## Complete Settings Structure

```json
{
  "model": "opus",
  "language": "english",
  "permissions": {
    "allow": [],
    "ask": [],
    "deny": [],
    "additionalDirectories": [],
    "defaultMode": "default"
  },
  "hooks": {},
  "env": {},
  "sandbox": {},
  "outputStyle": "Explanatory",
  "statusLine": {},
  "fileSuggestion": {},
  "attribution": {},
  "cleanupPeriodDays": 30,
  "alwaysThinkingEnabled": true,
  "enableAllProjectMcpServers": false
}
```

## Model Selection

```json
{
  "model": "opus"  // or "sonnet" or "haiku"
}
```

## Permissions

Control what Claude can do:

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run:*)",
      "Bash(git status:*)",
      "Read(~/.zshrc)",
      "WebFetch(domain:docs.example.com)"
    ],
    "ask": [
      "Bash(git push:*)",
      "Write(*.config.js)"
    ],
    "deny": [
      "Bash(curl:*)",
      "Read(.env*)",
      "Read(./secrets/**)"
    ],
    "additionalDirectories": [
      "../shared-libs/",
      "/opt/project-data/"
    ],
    "defaultMode": "default"
  }
}
```

### Permission Rules Syntax

| Pattern | Description |
|---------|-------------|
| `Tool` | Allow/deny entire tool |
| `Tool(pattern:*)` | Pattern matching for commands |
| `Tool(./path/**)` | Glob patterns for paths |
| `WebFetch(domain:example.com)` | Domain filtering |
| `Task(AgentName)` | Specific subagent |
| `mcp__server__*` | MCP tool wildcards |

### Default Modes

| Mode | Behavior |
|------|----------|
| `default` | Normal permission prompts |
| `acceptEdits` | Auto-accept edits, prompt for shell |
| `dontAsk` | No prompts for allowed actions |
| `bypassPermissions` | No restrictions |
| `plan` | Read-only mode |

## Sandbox Configuration

Isolate Claude's shell commands:

```json
{
  "sandbox": {
    "enabled": true,
    "autoAllowBashIfSandboxed": true,
    "excludedCommands": ["git", "docker"],
    "allowUnsandboxedCommands": false,
    "network": {
      "allowUnixSockets": ["~/.ssh/agent-socket"],
      "allowLocalBinding": true,
      "httpProxyPort": 8080
    }
  }
}
```

| Field | Description |
|-------|-------------|
| `enabled` | Enable sandboxing |
| `autoAllowBashIfSandboxed` | Skip prompts for sandboxed commands |
| `excludedCommands` | Commands that run outside sandbox |
| `allowUnsandboxedCommands` | Allow excluded commands |
| `network.allowUnixSockets` | Socket paths to allow |
| `network.allowLocalBinding` | Allow localhost binding |
| `network.httpProxyPort` | HTTP proxy port |

## Environment Variables

Set environment variables for Claude's shell:

```json
{
  "env": {
    "NODE_ENV": "development",
    "API_URL": "https://api.example.com",
    "DEBUG": "true"
  }
}
```

## Status Line

Custom status line command:

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/scripts/statusline.sh"
  }
}
```

The script should output status information.

## File Suggestion

Custom file suggestion command:

```json
{
  "fileSuggestion": {
    "type": "command",
    "command": "~/.claude/scripts/suggest-files.sh"
  }
}
```

## Attribution

Custom attribution for commits and PRs:

```json
{
  "attribution": {
    "commit": "Generated with Claude Code\n\nCo-Authored-By: Claude <noreply@anthropic.com>",
    "pr": "Generated with Claude Code"
  }
}
```

## Output Style

```json
{
  "outputStyle": "Explanatory"  // or "Concise"
}
```

## Other Settings

```json
{
  "cleanupPeriodDays": 30,
  "alwaysThinkingEnabled": true,
  "enableAllProjectMcpServers": false
}
```

## Common Configurations

### Development Setup

```json
{
  "model": "sonnet",
  "permissions": {
    "allow": [
      "Bash(npm:*)",
      "Bash(yarn:*)",
      "Bash(git:*)",
      "Bash(make:*)"
    ],
    "deny": [
      "Read(.env*)",
      "Write(.env*)"
    ]
  },
  "env": {
    "NODE_ENV": "development"
  }
}
```

### Security-Focused Setup

```json
{
  "permissions": {
    "allow": [
      "Read",
      "Grep",
      "Glob"
    ],
    "ask": [
      "Bash(*)",
      "Write(*)",
      "Edit(*)"
    ],
    "deny": [
      "Read(.env*)",
      "Read(**/secrets/**)",
      "Read(**/credentials/**)",
      "Bash(curl:*)",
      "Bash(wget:*)"
    ]
  },
  "sandbox": {
    "enabled": true,
    "autoAllowBashIfSandboxed": false
  }
}
```

### CI/CD Setup

```json
{
  "model": "sonnet",
  "permissions": {
    "allow": [
      "Bash(npm test:*)",
      "Bash(npm run build:*)",
      "Bash(npm run lint:*)"
    ],
    "deny": [
      "Bash(npm publish:*)",
      "Bash(git push:*)"
    ],
    "defaultMode": "dontAsk"
  }
}
```

### Team Project Setup

```json
{
  "permissions": {
    "allow": [
      "Bash(npm:*)",
      "Bash(git status:*)",
      "Bash(git diff:*)"
    ],
    "ask": [
      "Bash(git commit:*)",
      "Bash(git push:*)"
    ],
    "deny": [
      "Read(.env.local)",
      "Write(.env*)"
    ]
  },
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "npx prettier --write \"$TOOL_INPUT_FILE_PATH\" 2>/dev/null || true",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

## Merging Behavior

When multiple settings files exist:
- Arrays are **merged** (allow rules combine)
- Objects are **merged recursively**
- Primitives use **higher precedence value**

Example:
```
User settings: { "permissions": { "allow": ["Bash(npm:*)"] } }
Project settings: { "permissions": { "allow": ["Bash(yarn:*)"] } }
Result: { "permissions": { "allow": ["Bash(npm:*)", "Bash(yarn:*)"] } }
```

## Validation

Test your settings:
1. Create/edit `.claude/settings.json`
2. Start Claude Code
3. Check `/permissions` to see effective rules
4. Use `/` keyboard shortcut to filter permissions
