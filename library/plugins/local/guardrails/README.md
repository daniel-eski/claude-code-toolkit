# Claude Guardrails

Defense-in-depth safety hooks for Claude Code.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/yourusername/claude-guardrails/pulls)

> **Toolkit Copy**: This is a shareable copy of claude-guardrails for distribution with the claude-code-toolkit.
> For personal use, the user's active installation at `~/.claude/` takes precedence.
> To sync changes, update from the source repo and re-copy.

## What It Does

- **Blocks file writes outside your working directory** - Prevents accidental writes to system files or unrelated projects
- **Blocks pushes to main/master branches** - Protects production branches from direct pushes
- **Blocks all force pushes** - Prevents destructive history rewrites (allows `--force-with-lease`)
- **Logs all tool calls for audit trail** - Creates detailed JSONL logs of every operation
- **Integrates with claude-code-safety-net** - Works alongside semantic bash analysis for comprehensive protection

## Quick Start

```bash
git clone https://github.com/yourusername/claude-guardrails ~/Projects/claude-guardrails
cd ~/Projects/claude-guardrails
./scripts/install.sh
# Restart Claude Code
```

After installation, verify the hooks are active:

```bash
guardrails status
```

## What Gets Blocked

### File Operations (path-guardian)

| Operation | Result |
|-----------|--------|
| Write within project | Allowed |
| Write to /tmp | Allowed |
| Write outside project | Blocked |
| Write to ~/.ssh | Always Blocked |
| Write to ~/.aws | Always Blocked |

### Git Operations (git-guardian)

| Command | Result |
|---------|--------|
| `git push origin feature-branch` | Allowed |
| `git push origin main` | Blocked |
| `git push origin master` | Blocked |
| `git push --force` | Blocked |
| `git push -f` | Blocked |
| `git push --force-with-lease` | Allowed |

## How to Override

Overrides are managed through a JSON file that **Claude cannot modify**:

```
~/.claude/guardrails-overrides.json
```

### Override File Format

```json
{
  "allowed_paths": [
    "/var/log/myapp",
    "/opt/custom-project"
  ],
  "allowed_commands": [
    "rm -rf ./cache"
  ],
  "allowed_branches": [
    "develop",
    "staging"
  ]
}
```

### Managing Overrides via CLI

```bash
# Add overrides
guardrails override add path /var/log/myapp
guardrails override add branch develop
guardrails override add command "rm -rf ./cache"

# List current overrides
guardrails override list

# Clear all overrides
guardrails override clear
```

**Important**: The override file is outside Claude's allowed write paths by design. Only you can modify it.

## CLI Reference

| Command | Description |
|---------|-------------|
| `guardrails status` | Show if hooks are active and list configured hooks |
| `guardrails activate` | Enable hooks in settings.json |
| `guardrails deactivate` | Disable hooks (keeps files, removes from config) |
| `guardrails logs [YYYY-MM-DD]` | View audit logs (today by default) |
| `guardrails test` | Run test suite to verify all hooks work |
| `guardrails override add <type> <value>` | Add an override (type: path, command, branch) |
| `guardrails override list` | Show current overrides |
| `guardrails override clear` | Clear all overrides |
| `guardrails update` | Pull latest from repo and reinstall |
| `guardrails help` | Show help message |

## How It Works

```
┌─────────────────────────────────────────────────────────────────┐
│                        Claude Code                               │
│                                                                  │
│  Tool Call (Write, Bash, etc.)                                  │
│       │                                                          │
│       ▼                                                          │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                   PreToolUse Hooks                       │    │
│  │                                                          │    │
│  │  ┌──────────────┐   ┌──────────────┐   ┌─────────────┐  │    │
│  │  │path-guardian │──▶│ git-guardian │──▶│audit-logger │  │    │
│  │  └──────────────┘   └──────────────┘   └─────────────┘  │    │
│  │         │                  │                  │          │    │
│  │         ▼                  ▼                  ▼          │    │
│  │     allow/block        allow/block         always       │    │
│  │                                             allow       │    │
│  └─────────────────────────────────────────────────────────┘    │
│       │                                                          │
│       ▼                                                          │
│  Execute (if all hooks allow) or Block (if any hook blocks)     │
└─────────────────────────────────────────────────────────────────┘
```

### Design Principles

**Fail-Closed**: If a hook encounters an error or times out, the operation is blocked. This ensures safety even when things go wrong.

**Defense in Depth**: Multiple independent checks run in sequence. Each hook focuses on one concern:
- `path-guardian` - File system boundaries
- `git-guardian` - Git operation safety
- `audit-logger` - Observability (always allows, just logs)

**Integration with claude-code-safety-net**: For comprehensive bash command analysis, claude-guardrails works alongside [claude-code-safety-net](https://github.com/anthropics/claude-code-safety-net), which provides semantic analysis of shell commands to catch dangerous patterns.

## Configuration

Configuration lives in your Claude settings file:

```
~/.claude/settings.json
```

The `guardrails activate` command adds the hooks configuration automatically. For manual configuration or customization, see [docs/CONFIGURATION.md](docs/CONFIGURATION.md).

### Customizing Blocked Paths

Edit `src/hooks/path-guardian.sh` to modify the list of always-blocked paths:

```bash
ALWAYS_BLOCKED_PATHS=(
    "$HOME/.ssh"
    "$HOME/.aws"
    "$HOME/.gnupg"
    "/etc"
    "/var"
)
```

### Adding Protected Branches

Edit `src/hooks/git-guardian.sh` to modify protected branches:

```bash
PROTECTED_BRANCHES=(
    "main"
    "master"
    "production"
)
```

Or use overrides to allow specific branches without modifying the hook.

## Troubleshooting

For detailed troubleshooting, see [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md).

### Quick FAQ

**Hooks not loading after install?**
Restart Claude Code. Hooks are loaded at startup, so changes to settings.json require a restart.

**How do I check if hooks are active?**
```bash
guardrails status
```

**Where are the logs?**
```bash
guardrails logs          # Today's logs
guardrails logs 2024-01-15  # Specific date
```
Logs are stored in `~/.claude/guardrails-logs/` as JSONL files.

**Hook is blocking something I need?**
Add an override:
```bash
guardrails override add path /path/you/need
guardrails override add branch branch-name
```

**How do I temporarily disable all guardrails?**
```bash
guardrails deactivate
# ... do your work ...
guardrails activate
```

## Security Considerations

### What This Protects Against

- **Accidental file writes** outside your project directory
- **Accidental pushes** to protected branches
- **Destructive force pushes** that could rewrite git history
- **Lack of visibility** into what operations Claude performs

### What This Does NOT Protect Against

- **Malicious prompts** designed to circumvent safety measures
- **Commands that don't go through Claude Code hooks** (e.g., if Claude tells you to run something manually)
- **Sophisticated command obfuscation** (base64 encoding, variable expansion tricks)
- **Network exfiltration** via curl, wget, or other tools
- **Reading sensitive files** (use path-guardian's block list to restrict reads too)

For comprehensive bash command analysis, pair this with [claude-code-safety-net](https://github.com/anthropics/claude-code-safety-net).

For more details, see [docs/SECURITY.md](docs/SECURITY.md).

## Contributing

PRs are welcome! Here's how to contribute:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Make your changes
4. Test your changes:
   ```bash
   guardrails test
   ```
5. Commit with clear messages
6. Push and open a PR

### Testing Changes

The test suite validates all hooks work correctly:

```bash
guardrails test
```

For manual testing, you can invoke hooks directly:

```bash
echo '{"tool_name":"Write","tool_input":{"file_path":"/etc/passwd"}}' | ./src/hooks/path-guardian.sh
```

## License

MIT License - see [LICENSE](LICENSE) for details.
