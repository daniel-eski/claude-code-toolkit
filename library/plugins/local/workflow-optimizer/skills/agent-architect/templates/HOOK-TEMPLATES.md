# Hook Templates

Ready-to-use hook configurations for common automation patterns.

---

## Auto-Formatting

### Prettier (TypeScript/JavaScript)

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "if [[ \"$TOOL_INPUT_FILE_PATH\" == *.ts ]] || [[ \"$TOOL_INPUT_FILE_PATH\" == *.tsx ]] || [[ \"$TOOL_INPUT_FILE_PATH\" == *.js ]] || [[ \"$TOOL_INPUT_FILE_PATH\" == *.jsx ]]; then npx prettier --write \"$TOOL_INPUT_FILE_PATH\" 2>/dev/null; fi",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

### Black (Python)

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "if [[ \"$TOOL_INPUT_FILE_PATH\" == *.py ]]; then black \"$TOOL_INPUT_FILE_PATH\" 2>/dev/null; fi",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

### gofmt (Go)

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "if [[ \"$TOOL_INPUT_FILE_PATH\" == *.go ]]; then gofmt -w \"$TOOL_INPUT_FILE_PATH\" 2>/dev/null; fi",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

### rustfmt (Rust)

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "if [[ \"$TOOL_INPUT_FILE_PATH\" == *.rs ]]; then rustfmt \"$TOOL_INPUT_FILE_PATH\" 2>/dev/null; fi",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

---

## Auto-Linting

### ESLint with Feedback

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "if [[ \"$TOOL_INPUT_FILE_PATH\" == *.ts ]] || [[ \"$TOOL_INPUT_FILE_PATH\" == *.tsx ]]; then npx eslint \"$TOOL_INPUT_FILE_PATH\" --format compact 2>/dev/null || true; fi",
            "timeout": 15
          }
        ]
      }
    ]
  }
}
```

### Ruff (Python)

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "if [[ \"$TOOL_INPUT_FILE_PATH\" == *.py ]]; then ruff check \"$TOOL_INPUT_FILE_PATH\" 2>/dev/null || true; fi",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

---

## Protected Files

### Warn on Sensitive Files

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "case \"$TOOL_INPUT_FILE_PATH\" in *.env*|*secret*|*credential*|*config/prod*) echo 'WARNING: Attempting to modify sensitive file' >&2; exit 2;; esac",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

### Block Certain Files

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "case \"$TOOL_INPUT_FILE_PATH\" in */generated/*|*/dist/*|*/node_modules/*) echo 'BLOCKED: Cannot modify generated/vendor files' >&2; exit 2;; esac",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

---

## Session Context

### Load Git Context on Start

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup",
        "hooks": [
          {
            "type": "command",
            "command": "echo '{\"hookSpecificOutput\": {\"hookEventName\": \"SessionStart\", \"additionalContext\": \"Branch: '$(git branch --show-current 2>/dev/null || echo 'not a git repo')'. Recent commits: '$(git log --oneline -3 2>/dev/null | tr '\\n' '; ' || echo 'none')'\"}}'",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

### Set Environment Variables

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup",
        "hooks": [
          {
            "type": "command",
            "command": "if [ -n \"$CLAUDE_ENV_FILE\" ]; then echo 'export NODE_ENV=development' >> \"$CLAUDE_ENV_FILE\"; echo 'export DEBUG=true' >> \"$CLAUDE_ENV_FILE\"; fi",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

---

## Task Completion

### Verify Before Stop

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Before stopping, verify: 1) All requested changes are complete 2) Tests pass (if applicable) 3) No obvious errors remain. If incomplete, respond with {\"decision\": \"block\", \"reason\": \"[what remains]\"}. If complete, respond with {\"decision\": \"approve\"}.",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

### Run Tests Before Stop

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "npm test 2>&1 | tail -20 || echo 'Tests may have issues'",
            "timeout": 60
          }
        ]
      }
    ]
  }
}
```

---

## Combined Configurations

### TypeScript Development Setup

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "if [[ \"$TOOL_INPUT_FILE_PATH\" == *.ts ]] || [[ \"$TOOL_INPUT_FILE_PATH\" == *.tsx ]]; then npx prettier --write \"$TOOL_INPUT_FILE_PATH\" 2>/dev/null && npx eslint \"$TOOL_INPUT_FILE_PATH\" --format compact 2>/dev/null || true; fi",
            "timeout": 15
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "case \"$TOOL_INPUT_FILE_PATH\" in *.env*|*secret*) echo 'WARNING: Sensitive file' >&2; exit 2;; esac",
            "timeout": 5
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "matcher": "startup",
        "hooks": [
          {
            "type": "command",
            "command": "echo '{\"hookSpecificOutput\": {\"additionalContext\": \"Branch: '$(git branch --show-current 2>/dev/null)'\"}}'",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

### Python Development Setup

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "if [[ \"$TOOL_INPUT_FILE_PATH\" == *.py ]]; then black \"$TOOL_INPUT_FILE_PATH\" 2>/dev/null && ruff check \"$TOOL_INPUT_FILE_PATH\" --fix 2>/dev/null || true; fi",
            "timeout": 15
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "case \"$TOOL_INPUT_FILE_PATH\" in *.env*|*secret*|*credentials*) echo 'WARNING: Sensitive file' >&2; exit 2;; esac",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

---

## Notes

- Always quote `$TOOL_INPUT_FILE_PATH` to handle spaces
- Use `2>/dev/null` to suppress stderr for non-critical hooks
- Use `|| true` to prevent non-zero exit from blocking
- Set appropriate timeouts to prevent hanging
- Test hooks manually before adding to configuration
