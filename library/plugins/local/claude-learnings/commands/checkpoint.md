---
description: Save current state for potential rewind
argument-hint: [checkpoint-name]
---

# Create Checkpoint

Name: $ARGUMENTS

## Instructions

1. Validate name:
   - If empty, respond: "Usage: /checkpoint [name]" and stop.
   - If contains spaces or special chars (allow only alphanumeric, hyphens, underscores), respond: "Checkpoint name must be alphanumeric (hyphens and underscores allowed)." and stop.

2. Gather current state:

   a. Get current working directory

   b. Check if in a git repo:
      - Run: `git rev-parse --is-inside-work-tree 2>/dev/null`
      - If yes, capture:
        - Branch: `git branch --show-current`
        - Commit: `git rev-parse --short HEAD`
        - Dirty: `git status --porcelain` (non-empty = dirty)
      - If no git, set git fields to null

   c. Read current ~/.claude/learnings/queue.json

3. Create checkpoint file at ~/.claude/learnings/checkpoints/[name].json:
   ```json
   {
     "name": "[name]",
     "created": "[ISO 8601 timestamp]",
     "cwd": "[current working directory]",
     "git": {
       "branch": "[branch or null]",
       "commit": "[short SHA or null]",
       "dirty": [true/false or null]
     },
     "learnings_snapshot": [copy of queue.json entries array]
   }
   ```

4. Output ONLY:
   ```
   Checkpoint '[name]' saved. Restore with /restore [name]
   ```

Do not elaborate. Do not suggest next steps.
