---
description: View checkpoint state and optionally restore learnings queue
argument-hint: [checkpoint-name]
---

# Restore Checkpoint

Name: $ARGUMENTS

## Instructions

1. If no name provided:
   - List available checkpoints from ~/.claude/learnings/checkpoints/
   - Show each with created date
   - Respond: "Available checkpoints: [list]. Usage: /restore [name]"
   - Stop.

2. Load checkpoint file ~/.claude/learnings/checkpoints/[name].json
   - If not found, list available checkpoints and stop.

3. Gather current state for comparison:
   - Current learnings queue entry count
   - Current git state (if in repo)

4. Display checkpoint info:
   ```
   ## Checkpoint: [name]
   Created: [timestamp]
   Directory: [cwd]

   ### Git State at Checkpoint
   Branch: [branch]
   Commit: [commit]
   Status: [clean/dirty]

   ### Learnings at Checkpoint
   [N] entries

   ### Current State
   Learnings queue: [M] entries ([diff from checkpoint])
   Git: [current branch] @ [current commit]
   ```

5. If git state differs from checkpoint, show restore commands:
   ```
   ### To restore code state:
   ```bash
   git checkout [branch]
   git reset --hard [commit]
   ```
   ⚠️ WARNING: This will discard uncommitted changes
   ```

6. Use AskUserQuestion to ask:
   "Restore learnings queue to checkpoint state? (Currently [M] entries, checkpoint has [N])"
   Options: Yes / No

7. On **Yes**:
   - Read checkpoint's learnings_snapshot
   - Write to ~/.claude/learnings/queue.json as {"entries": [snapshot]}
   - Respond: "Learnings queue restored to checkpoint state ([N] entries)."

8. On **No**:
   - Respond: "Queue unchanged. Git commands shown above if you want to restore code state manually."
