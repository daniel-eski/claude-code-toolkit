# Hook Implementation Guide

Step-by-step guide to implementing Claude Code hooks.

## Step 1: Choose the Right Event

| Event | Use For |
|-------|---------|
| `PreToolUse` | Block/modify tool calls |
| `PostToolUse` | React to tool completion |
| `UserPromptSubmit` | Validate/enhance user input |
| `Stop` | Ensure work completion |
| `SessionStart` | Setup environment |

## Step 2: Configure in Settings

Add to `.claude/settings.json` (project) or `~/.claude/settings.json` (user):

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/lint.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

## Step 3: Write Hook Script

### Basic Template

```bash
#!/bin/bash
# .claude/hooks/my-hook.sh

# Read JSON input from stdin
INPUT=$(cat)

# Parse with jq (install if needed)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name')
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Your logic here
if [[ "$FILE_PATH" == *.env* ]]; then
    echo "Cannot modify .env files" >&2
    exit 2  # Exit 2 = blocking error
fi

# Success
exit 0
```

### Python Template

```python
#!/usr/bin/env python3
import json
import sys

# Read input
input_data = json.load(sys.stdin)

tool_name = input_data.get("tool_name", "")
tool_input = input_data.get("tool_input", {})

# Your logic here
if ".env" in tool_input.get("file_path", ""):
    print("Cannot modify .env files", file=sys.stderr)
    sys.exit(2)  # Blocking error

sys.exit(0)
```

## Step 4: Handle Exit Codes

| Exit Code | Effect |
|-----------|--------|
| **0** | Success (stdout to Claude for UserPromptSubmit/SessionStart) |
| **2** | Blocking error (stderr shown to Claude) |
| **Other** | Non-blocking (stderr logged) |

## Step 5: Return JSON for Advanced Control

```python
import json

# Block with reason
output = {
    "decision": "block",
    "reason": "Security policy violation"
}
print(json.dumps(output))
sys.exit(0)
```

### PreToolUse JSON

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow|deny|ask",
    "permissionDecisionReason": "Why"
  }
}
```

### PostToolUse JSON

```json
{
  "decision": "block",
  "reason": "Linting failed, please fix errors"
}
```

## Common Hook Recipes

### Auto-Format After Write

```bash
#!/bin/bash
FILE=$(cat | jq -r '.tool_input.file_path')
if [[ "$FILE" == *.ts ]] || [[ "$FILE" == *.tsx ]]; then
    npx prettier --write "$FILE" 2>/dev/null
fi
exit 0
```

### Block Dangerous Commands

```python
#!/usr/bin/env python3
import json, sys, re

data = json.load(sys.stdin)
cmd = data.get("tool_input", {}).get("command", "")

dangerous = [r"rm\s+-rf", r"DROP\s+TABLE", r">\s*/dev/"]
for pattern in dangerous:
    if re.search(pattern, cmd, re.I):
        print(f"Blocked: {pattern}", file=sys.stderr)
        sys.exit(2)
sys.exit(0)
```

### Add Context to Prompts

```bash
#!/bin/bash
# UserPromptSubmit hook
echo "Current time: $(date)"
echo "Git branch: $(git branch --show-current 2>/dev/null || echo 'N/A')"
exit 0
```

## Step 6: Test Your Hook

1. Make script executable: `chmod +x .claude/hooks/my-hook.sh`
2. Test manually: `echo '{"tool_name":"Write"}' | .claude/hooks/my-hook.sh`
3. Check Claude Code: `/hooks` to verify registration
4. Trigger the event and observe behavior

## Checklist

- [ ] Script is executable
- [ ] Uses `$CLAUDE_PROJECT_DIR` for portable paths
- [ ] Handles missing input gracefully
- [ ] Returns correct exit codes
- [ ] Has reasonable timeout
- [ ] Tested manually first

See also:
- `../feature-mechanics/hooks-deep-dive.md` for mechanics
- `../decision-guides/hooks-usage-guide.md` for when to use
