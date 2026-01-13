---
description: Log an error or mistake for later review (forces type to warning)
argument-hint: [what went wrong]
---

# Log Error (Alias)

Entry: $ARGUMENTS

## Instructions

1. If no entry provided, respond: "Usage: /log_error [what went wrong]" and stop.

2. Read existing queue from ~/.claude/learnings/queue.json

3. Generate 8-character random ID (alphanumeric)

4. Append new entry with type FORCED to "warning":
   ```json
   {
     "id": "<8-char-id>",
     "timestamp": "<ISO 8601 timestamp>",
     "type": "warning",
     "raw": "<original entry text>",
     "context": {
       "cwd": "<current working directory>"
     },
     "status": "pending"
   }
   ```

5. Write updated queue back to ~/.claude/learnings/queue.json

6. Output ONLY: `Logged warning: "[first 50 chars]..."`

Do not ask questions. Do not elaborate. Just log and confirm.
