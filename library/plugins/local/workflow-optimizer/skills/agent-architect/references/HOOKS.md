# Hooks Reference

Complete reference for Claude Code hooks.

## What Are Hooks?

Hooks are automated actions triggered by events in Claude Code. They enable:
- Auto-formatting after edits
- Validation before commits
- Logging for compliance
- Custom automation workflows

## Configuration Location

Add hooks to `settings.json`:
- Personal: `~/.claude/settings.json`
- Project: `.claude/settings.json`
- Local: `.claude/settings.local.json`

## Basic Structure

```json
{
  "hooks": {
    "EVENT_NAME": [
      {
        "matcher": "TOOL_NAME_PATTERN",
        "hooks": [
          {
            "type": "command",
            "command": "your-command-here",
            "timeout": 60
          }
        ]
      }
    ]
  }
}
```

## All Hook Events

| Event | When It Fires | Common Use Cases |
|-------|---------------|------------------|
| `PreToolUse` | Before tool executes | Validation, blocking, modification |
| `PostToolUse` | After tool completes | Formatting, linting, logging |
| `UserPromptSubmit` | Before processing user input | Context injection, preprocessing |
| `PermissionRequest` | When permission dialog shown | Custom permission logic |
| `Stop` | When main agent finishes | Completion verification |
| `SubagentStop` | When subagent finishes | Post-subagent processing |
| `SessionStart` | Session begins/resumes | Environment setup, context loading |
| `SessionEnd` | Session ends | Cleanup, logging |
| `Notification` | When notifications sent | Custom notification handling |
| `PreCompact` | Before context compaction | Data preservation |

## Matchers

Matchers specify which tools trigger the hook:

```json
// Specific tool
"matcher": "Bash"

// Multiple tools (regex OR)
"matcher": "Write|Edit"

// All tools
"matcher": "*"
// or
"matcher": ""

// MCP tools
"matcher": "mcp__github__.*"
```

**Tool names for matching:**
- `Read`, `Write`, `Edit` — File operations
- `Bash` — Shell commands
- `Grep`, `Glob` — Search
- `WebFetch`, `WebSearch` — Web
- `Task` — Subagent spawning
- `mcp__[server]__[tool]` — MCP tools

## Hook Types

### Command Hook

Runs a shell command:

```json
{
  "type": "command",
  "command": "npx prettier --write \"$TOOL_INPUT_FILE_PATH\"",
  "timeout": 30
}
```

### Prompt Hook

Asks Claude to evaluate (returns JSON decision):

```json
{
  "type": "prompt",
  "prompt": "Evaluate if this change is safe: $ARGUMENTS",
  "timeout": 30
}
```

## Environment Variables

Available in command hooks:

| Variable | Description |
|----------|-------------|
| `$CLAUDE_PROJECT_DIR` | Absolute path to project root |
| `$CLAUDE_CODE_REMOTE` | "true" if web environment, empty for CLI |
| `$TOOL_INPUT_FILE_PATH` | File being operated on (for file tools) |
| `$CLAUDE_ENV_FILE` | (SessionStart only) Path to persist env vars |

## Hook Input (stdin)

Hooks receive JSON input via stdin:

```json
{
  "session_id": "abc123",
  "transcript_path": "/path/to/.jsonl",
  "cwd": "/current/working/dir",
  "permission_mode": "default",
  "hook_event_name": "PreToolUse",
  "tool_name": "Write",
  "tool_input": {
    "file_path": "/path/to/file.ts",
    "content": "file contents..."
  },
  "tool_use_id": "toolu_01ABC123"
}
```

## Hook Output & Exit Codes

### Exit Codes

| Code | Meaning |
|------|---------|
| `0` | Success (stdout shown in verbose mode) |
| `2` | Blocking error (stderr shown to user) |
| Other | Non-blocking error |

### JSON Output (exit 0)

```json
{
  "continue": true,
  "stopReason": "Message if continue=false",
  "suppressOutput": false,
  "systemMessage": "Warning to show user",
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow",
    "permissionDecisionReason": "Auto-approved by hook",
    "updatedInput": {
      "modified_field": "new_value"
    }
  }
}
```

### Permission Decisions (PreToolUse)

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow",  // or "deny" or "ask"
    "permissionDecisionReason": "Why this decision"
  }
}
```

### PostToolUse Decision Control

Block and provide feedback to Claude:

```json
{
  "decision": "block",
  "reason": "Linting failed: missing semicolon on line 42",
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Run 'npm run lint:fix' to auto-fix"
  }
}
```

## SessionStart: Persisting Environment

Use `$CLAUDE_ENV_FILE` to set environment variables for the session:

```bash
#!/bin/bash
if [ -n "$CLAUDE_ENV_FILE" ]; then
  echo 'export NODE_ENV=production' >> "$CLAUDE_ENV_FILE"
  echo 'export API_URL=https://api.example.com' >> "$CLAUDE_ENV_FILE"
fi
exit 0
```

## SessionStart Matchers

The SessionStart event supports special matchers:

| Matcher | When |
|---------|------|
| `startup` | Fresh session start |
| `resume` | Resuming existing session |
| `clear` | After /clear command |
| `compact` | After context compaction |

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup",
        "hooks": [{ "type": "command", "command": "./setup.sh" }]
      }
    ]
  }
}
```

## Common Patterns

### Auto-Format on Edit

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "if [[ \"$TOOL_INPUT_FILE_PATH\" == *.ts ]]; then npx prettier --write \"$TOOL_INPUT_FILE_PATH\" 2>/dev/null; fi",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

### Auto-Lint with Feedback

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "npx eslint \"$TOOL_INPUT_FILE_PATH\" --format compact 2>/dev/null || true",
            "timeout": 15
          }
        ]
      }
    ]
  }
}
```

### Protected Files Warning

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "case \"$TOOL_INPUT_FILE_PATH\" in *.env*|*secret*|*credential*) echo 'WARNING: Sensitive file' >&2; exit 2;; esac",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

### Task Completion Check

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Before stopping, verify: 1) All changes complete 2) Tests pass 3) No errors remain. Respond with {\"decision\": \"approve\"} or {\"decision\": \"block\", \"reason\": \"...\"}",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

### Git Context on Session Start

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup",
        "hooks": [
          {
            "type": "command",
            "command": "echo '{\"hookSpecificOutput\": {\"additionalContext\": \"Branch: '$(git branch --show-current 2>/dev/null)'. Recent: '$(git log --oneline -3 2>/dev/null | tr '\\n' '; ')'\"}}'",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

## Best Practices

1. **Quote variables** — Always use `"$VAR"` not `$VAR`
2. **Use absolute paths** — `"$CLAUDE_PROJECT_DIR"/scripts/hook.sh`
3. **Set timeouts** — Prevent hanging hooks
4. **Handle errors gracefully** — Use `|| true` for non-critical hooks
5. **Test hooks in isolation** — Verify scripts work before adding as hooks
6. **Use exit 2 for blocking** — Only when you want to stop the action

## Debugging Hooks

1. **Verbose mode** — See hook output with `--verbose`
2. **Test scripts manually** — Run hook commands directly first
3. **Check stderr** — Blocking hooks (exit 2) show stderr to user
4. **Log to file** — Add logging in hook scripts for debugging
