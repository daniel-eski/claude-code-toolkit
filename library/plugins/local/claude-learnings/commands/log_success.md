---
description: Log a success or what worked well for later review (forces type to success)
argument-hint: [what worked]
---

# Log Success (Alias)

Entry: $ARGUMENTS

## Instructions

1. If no entry provided, respond: "Usage: /log_success [what worked]" and stop.

2. Read existing queue from ~/.claude/learnings/queue.json

3. Generate 8-character random ID (alphanumeric)

4. Append new entry with type FORCED to "success":
   ```json
   {
     "id": "<8-char-id>",
     "timestamp": "<ISO 8601 timestamp>",
     "type": "success",
     "raw": "<original entry text>",
     "context": {
       "cwd": "<current working directory>"
     },
     "status": "pending"
   }
   ```

5. Write updated queue back to ~/.claude/learnings/queue.json

6. Output ONLY: `Logged success: "[first 50 chars]..."`

Do not ask questions. Do not elaborate. Just log and confirm.
