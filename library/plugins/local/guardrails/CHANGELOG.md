# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-12

### Added

- **path-guardian** hook - Blocks file writes outside working directory
  - Always blocks sensitive paths (~/.ssh, ~/.aws, ~/.gnupg)
  - Allows writes to temp directories (/tmp, /var/tmp)
  - Supports override file for exceptions
  - Fail-closed design

- **git-guardian** hook - Enforces git workflow rules
  - Blocks pushes to main/master branches
  - Blocks all force pushes (allows --force-with-lease)
  - Supports override file for exceptions

- **audit-logger** hook - Creates audit trail of all tool calls
  - JSONL format logs at ~/.claude/guardrails-logs/
  - Automatic sensitive data redaction
  - Never blocks operations

- **CLI management tool** (`guardrails`)
  - `status` - Check if hooks are active
  - `activate` / `deactivate` - Enable/disable hooks
  - `logs` - View audit logs
  - `test` - Run hook test suite
  - `override add/list/clear` - Manage overrides
  - `update` - Pull latest and reinstall

- **Install/uninstall scripts**
  - One-command installation
  - Checks for claude-code-safety-net dependency
  - Merges into existing settings.json
  - Clean uninstall preserving other settings

- **Comprehensive documentation**
  - README with quick start and reference
  - CONFIGURATION.md for customization
  - TROUBLESHOOTING.md for common issues
  - SECURITY.md for threat model

### Dependencies

- Requires Bun >= 1.0
- Integrates with [claude-code-safety-net](https://github.com/kenryu42/claude-code-safety-net) for semantic bash analysis
