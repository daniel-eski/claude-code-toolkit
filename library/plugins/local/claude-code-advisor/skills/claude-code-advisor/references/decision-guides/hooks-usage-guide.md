# Hooks Usage Guide

When and how to use event-driven automation in Claude Code.

## When to Use Hooks

Hooks are for **automatic, event-driven behavior**:

| Use Case | Event | Example |
|----------|-------|---------|
| Validate before action | PreToolUse | Block dangerous commands |
| Auto-approve safe actions | PreToolUse | Allow reads of docs |
| React to changes | PostToolUse | Auto-format after write |
| Add context to prompts | UserPromptSubmit | Inject current time |
| Ensure completion | Stop | Check if tests pass |
| Setup environment | SessionStart | Load env vars, install deps |
| Cleanup | SessionEnd | Log session stats |

## Event Selection Guide

```
What do you want to automate?
│
├─ Block/modify tool calls ──▶ PreToolUse
│
├─ Auto-approve permissions ──▶ PermissionRequest
│
├─ React to tool completion ──▶ PostToolUse
│
├─ Validate user input ──▶ UserPromptSubmit
│
├─ Ensure work is done ──▶ Stop / SubagentStop
│
├─ Setup at start ──▶ SessionStart
│
└─ Cleanup at end ──▶ SessionEnd
```

## Common Hook Patterns

### Guardrail Pattern (PreToolUse)
Block dangerous operations:
```json
{
  "PreToolUse": [{
    "matcher": "Bash",
    "hooks": [{ "type": "command", "command": "/path/to/validate-bash.py" }]
  }]
}
```

### Auto-Format Pattern (PostToolUse)
Format files after writing:
```json
{
  "PostToolUse": [{
    "matcher": "Write|Edit",
    "hooks": [{ "type": "command", "command": "prettier --write $file" }]
  }]
}
```

### Context Injection (UserPromptSubmit)
Add info to every prompt:
```json
{
  "UserPromptSubmit": [{
    "hooks": [{ "type": "command", "command": "echo Current time: $(date)" }]
  }]
}
```

### Completion Check (Stop)
Ensure work is done before stopping:
```json
{
  "Stop": [{
    "hooks": [{
      "type": "prompt",
      "prompt": "Check if all requested tasks are complete..."
    }]
  }]
}
```

## Anti-Patterns to Avoid

| Anti-Pattern | Problem | Fix |
|--------------|---------|-----|
| Complex logic in hooks | Slow, hard to debug | Spawn subagent |
| Hooks for knowledge | Wrong tool | Use skills |
| No timeout handling | Hung hooks | Set timeout |
| No stop_hook_active check | Infinite loops | Check flag |

## Hook vs Other Features

| Need | Use |
|------|-----|
| Automatic validation | Hook (PreToolUse) |
| Guidance/knowledge | Skill |
| User-triggered action | Slash Command |
| Heavy automated analysis | Hook + Subagent |

## Best Practices

1. **Keep hooks lightweight** - Complex logic → subagent
2. **Use exit code 2** for blocking errors
3. **Check `stop_hook_active`** in Stop hooks
4. **Use `$CLAUDE_PROJECT_DIR`** for portable paths
5. **Test thoroughly** - Hooks run automatically
6. **Set timeouts** for external calls

See also:
- `../feature-mechanics/hooks-deep-dive.md` for hook mechanics
- `../system-understanding/execution-model.md` for hook injection points
