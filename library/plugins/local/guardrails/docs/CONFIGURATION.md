# Configuration Guide

This guide covers all configuration options for claude-guardrails, including how to customize protection rules and set up overrides for your workflow.

## Overview

claude-guardrails uses a layered configuration approach:

1. **Built-in defaults** - Sensible protections that work out of the box
2. **Source code constants** - Customizable lists in the hook files
3. **Override file** - User-specific exceptions in `~/.claude/guardrails-overrides.json`
4. **Hook timeouts** - Configured in Claude Code's `settings.json`

## Customizing Blocked Paths

The path-guardian hook maintains a list of paths that are **always blocked**, even if they fall within your working directory.

### Default Blocked Paths

Edit `/src/hooks/path-guardian.ts` and modify the `ALWAYS_BLOCKED_PATTERNS` array:

```typescript
const ALWAYS_BLOCKED_PATTERNS = [
  // SSH keys and configuration
  `${homedir()}/.ssh`,

  // AWS credentials
  `${homedir()}/.aws`,

  // GPG keys
  `${homedir()}/.gnupg`,

  // Guardrails self-protection
  `${homedir()}/.claude/guardrails-overrides.json`,
  `${homedir()}/.claude/hooks`,
  `${homedir()}/.claude/settings.json`,

  // System directories
  "/etc",
  "/usr",
  "/System",
  "/Library",
  "/bin",
  "/sbin",
  "/var/root",
];
```

### Adding Custom Blocked Paths

To protect additional paths, add them to the array:

```typescript
const ALWAYS_BLOCKED_PATTERNS = [
  // ... existing patterns ...

  // Custom additions
  `${homedir()}/.config/sensitive-app`,
  "/opt/production-secrets",
];
```

### Always-Safe Paths

Temporary directories are always writable regardless of working directory. Modify `ALWAYS_SAFE_PATTERNS` if needed:

```typescript
const ALWAYS_SAFE_PATTERNS = [
  "/tmp",
  "/var/tmp",
  tmpdir(),  // OS-specific temp directory
];
```

## Customizing Protected Branches

The git-guardian hook blocks direct pushes to protected branches.

### Default Protected Branches

Edit `/src/hooks/git-guardian.ts` and modify the `PROTECTED_BRANCHES` array:

```typescript
const PROTECTED_BRANCHES = [
  "main",
  "master",
  "production",
  "prod",
];
```

### Adding Custom Protected Branches

```typescript
const PROTECTED_BRANCHES = [
  "main",
  "master",
  "production",
  "prod",
  // Custom additions
  "staging",
  "release",
  "develop",
];
```

## Override File Format

The override file allows you to create exceptions without modifying source code. Located at:

```
~/.claude/guardrails-overrides.json
```

### Full Schema

```json
{
  "allowed_paths": ["glob patterns for writable paths"],
  "allowed_commands": ["exact git commands to permit"],
  "allowed_branches": ["branch patterns that can receive pushes"]
}
```

### Field Details

| Field | Used By | Description |
|-------|---------|-------------|
| `allowed_paths` | path-guardian | Glob patterns for paths that should be writable beyond the working directory |
| `allowed_commands` | git-guardian | Exact command strings that bypass all git checks |
| `allowed_branches` | git-guardian | Branch name patterns that can receive direct pushes |

### Glob Pattern Syntax

For `allowed_paths`:

- `*` - Matches any characters within a single path segment
- `**` - Matches any path including subdirectories
- `~` - Expands to your home directory

Examples:
- `~/Projects/**` - All files under ~/Projects
- `~/Projects/*` - Only direct children of ~/Projects
- `~/Projects/*.ts` - Only .ts files directly in ~/Projects
- `/opt/myapp/**` - All files under /opt/myapp

### Branch Pattern Syntax

For `allowed_branches`:

- `*` - Matches any characters

Examples:
- `main` - Exact match for "main"
- `release-*` - Matches "release-1.0", "release-2.0", etc.
- `hotfix-*` - Matches any hotfix branch

## Override Examples

### Allow Writes to a Specific Directory

Allow Claude to write to a shared documentation directory:

```json
{
  "allowed_paths": [
    "~/Documents/shared-docs/**"
  ],
  "allowed_commands": [],
  "allowed_branches": []
}
```

### Allow Push to a Release Branch

Allow pushing to release branches for deployment:

```json
{
  "allowed_paths": [],
  "allowed_commands": [],
  "allowed_branches": [
    "release-*"
  ]
}
```

### Allow a Specific Git Command

Allow a specific deployment command:

```json
{
  "allowed_paths": [],
  "allowed_commands": [
    "git push origin main --tags"
  ],
  "allowed_branches": []
}
```

### Combined Example

A more complete override file for a typical workflow:

```json
{
  "allowed_paths": [
    "~/Projects/**",
    "~/Documents/work/**",
    "/opt/mycompany/apps/**"
  ],
  "allowed_commands": [
    "git push origin main --tags",
    "git push --force-with-lease origin main"
  ],
  "allowed_branches": [
    "release-*",
    "hotfix-*"
  ]
}
```

## Hook Timeouts

Hook timeouts are configured in Claude Code's settings file:

```
~/.claude/settings.json
```

The guardrails hooks are registered with these default timeouts:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit|NotebookEdit",
        "hooks": [
          {
            "type": "command",
            "command": "~/.bun/bin/bun run ~/.claude/hooks/path-guardian.ts",
            "timeout": 2000
          }
        ]
      },
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.bun/bin/bun run ~/.claude/hooks/git-guardian.ts",
            "timeout": 2000
          },
          {
            "type": "command",
            "command": "~/.bun/bin/bun run ~/.claude/hooks/audit-logger.ts",
            "timeout": 1000
          }
        ]
      }
    ]
  }
}
```

### Timeout Values

| Hook | Default Timeout | Recommended Range |
|------|-----------------|-------------------|
| path-guardian | 2000ms | 1000-5000ms |
| git-guardian | 2000ms | 1000-5000ms |
| audit-logger | 1000ms | 500-2000ms |

Increase timeouts if you experience false blocks due to slow filesystem operations. The audit-logger can have a shorter timeout since it never blocks operations.

## Audit Log Location and Format

### Log Location

Audit logs are stored at:

```
~/.claude/guardrails-logs/YYYY-MM-DD.jsonl
```

Each day gets a new log file. The directory is created automatically on first use.

### Log Format

Logs use JSONL format (one JSON object per line). Each entry contains:

```json
{
  "timestamp": "2024-01-15T14:30:00.000Z",
  "session_id": "abc123",
  "tool_name": "Bash",
  "tool_input_summary": "git status",
  "tool_input_hash": "sha256:a1b2c3d4e5f6g7h8",
  "cwd": "/Users/you/project"
}
```

### Field Descriptions

| Field | Description |
|-------|-------------|
| `timestamp` | ISO 8601 UTC timestamp |
| `session_id` | Unique identifier for the Claude Code session |
| `tool_name` | The tool that was invoked (Bash, Write, Edit, etc.) |
| `tool_input_summary` | Redacted summary of the operation |
| `tool_input_hash` | SHA256 hash prefix for forensic correlation |
| `cwd` | Working directory when the operation occurred |

### Reading Logs

```bash
# View today's log (formatted)
cat ~/.claude/guardrails-logs/$(date +%Y-%m-%d).jsonl | jq

# Find all Bash commands from today
cat ~/.claude/guardrails-logs/$(date +%Y-%m-%d).jsonl | jq 'select(.tool_name == "Bash")'

# Search for operations in a specific directory
cat ~/.claude/guardrails-logs/*.jsonl | jq 'select(.cwd | contains("/my/project"))'

# Count operations by tool
cat ~/.claude/guardrails-logs/*.jsonl | jq -s 'group_by(.tool_name) | map({tool: .[0].tool_name, count: length})'
```

### Log Retention

Logs are not automatically rotated. To manage disk space, periodically archive or delete old logs:

```bash
# Delete logs older than 30 days
find ~/.claude/guardrails-logs -name "*.jsonl" -mtime +30 -delete

# Archive logs older than 7 days
find ~/.claude/guardrails-logs -name "*.jsonl" -mtime +7 -exec gzip {} \;
```
