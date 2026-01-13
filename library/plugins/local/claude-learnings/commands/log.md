---
description: Log a learning, insight, or pattern for later review
argument-hint: [entry text]
---

# Quick Learning Capture

Entry: $ARGUMENTS

## Instructions

1. If no entry provided, respond: "Usage: /log [entry text]" and stop.

2. Read existing queue from ~/.claude/learnings/queue.json (create with empty array if missing)

3. Detect entry type from content:
   - Contains "error", "failed", "wrong", "mistake", "bug", "broke" → type: "warning"
   - Contains "worked", "success", "solved", "fixed", "great", "perfect" → type: "success"
   - Contains "pattern", "always", "never", "should", "must", "rule" → type: "pattern"
   - Otherwise → type: "insight"

4. Generate 8-character random ID (alphanumeric)

5. Append new entry to the entries array:
   ```json
   {
     "id": "<8-char-id>",
     "timestamp": "<ISO 8601 timestamp>",
     "type": "<detected type>",
     "raw": "<original entry text>",
     "context": {
       "cwd": "<current working directory>"
     },
     "status": "pending"
   }
   ```

6. Write updated queue back to ~/.claude/learnings/queue.json

7. Output ONLY this single line (no extra text):
   ```
   Logged [type]: "[first 50 chars of entry]..."
   ```
   If entry is under 50 chars, show full text without "..."

Do not ask questions. Do not elaborate. Do not suggest next steps. Just log and confirm.
