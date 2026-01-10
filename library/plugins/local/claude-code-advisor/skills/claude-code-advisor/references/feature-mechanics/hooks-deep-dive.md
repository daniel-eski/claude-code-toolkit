# Hooks Deep Dive

Hooks are event-driven scripts that run outside the conversation at specific points.

## Hook Events

| Event | When | Can Do |
|-------|------|--------|
| **PreToolUse** | Before tool runs | Block, modify, auto-approve |
| **PermissionRequest** | At permission dialog | Allow/deny for user |
| **PostToolUse** | After tool completes | Add feedback to Claude |
| **UserPromptSubmit** | User sends message | Add context, block prompt |
| **Stop** | Claude about to stop | Force continuation |
| **SubagentStop** | Subagent finishing | Force continuation |
| **SessionStart** | Session begins | Add context, set env vars |
| **SessionEnd** | Session ends | Cleanup |
| **Notification** | Notifications sent | Custom alerts |
| **PreCompact** | Before compaction | Custom handling |

## Configuration Structure

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "/path/to/script.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

## Hook Types

**Command hooks** - Run bash scripts:
```json
{ "type": "command", "command": "/path/to/script.sh" }
```

**Prompt hooks** - LLM evaluation (Stop/SubagentStop only):
```json
{ "type": "prompt", "prompt": "Evaluate if work is complete..." }
```

## Matchers

Pattern matching for tool-related events:

| Pattern | Matches |
|---------|---------|
| `Write` | Exact match |
| `Write\|Edit` | Either tool |
| `Notebook.*` | Regex pattern |
| `*` or `""` | All tools |
| `mcp__server__*` | MCP tools |

## Exit Codes

| Code | Effect |
|------|--------|
| **0** | Success - stdout to Claude (UserPromptSubmit, SessionStart) |
| **2** | Blocking error - stderr shown to Claude |
| **Other** | Non-blocking - stderr logged |

## JSON Output Format

For sophisticated control, return JSON:

```json
{
  "decision": "block",
  "reason": "Must fix linting errors first",
  "continue": true,
  "systemMessage": "Warning shown to user"
}
```

### PreToolUse Decisions

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow|deny|ask",
    "permissionDecisionReason": "Why",
    "updatedInput": { "field": "modified value" }
  }
}
```

## Input Data

Hooks receive JSON via stdin:

```json
{
  "session_id": "abc123",
  "transcript_path": "/path/to/session.jsonl",
  "cwd": "/project/dir",
  "hook_event_name": "PostToolUse",
  "tool_name": "Write",
  "tool_input": { "file_path": "..." },
  "tool_response": { "success": true }
}
```

## Configuration Locations

| Source | Location |
|--------|----------|
| User | `~/.claude/settings.json` |
| Project | `.claude/settings.json` |
| Local | `.claude/settings.local.json` |
| Plugin | `hooks/hooks.json` in plugin |

## Best Practices

1. **Keep hooks lightweight** - Complex logic → spawn subagent
2. **Use exit code 2 for blocking** - Error message goes to Claude
3. **Check stop_hook_active** - Prevent infinite loops
4. **Use $CLAUDE_PROJECT_DIR** - For portable script paths
5. **Test thoroughly** - Hooks run automatically

See also:
- `../system-understanding/execution-model.md` for hook injection points
- `../decision-guides/hooks-usage-guide.md` for when to use hooks
