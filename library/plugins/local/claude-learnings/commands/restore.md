---
description: View checkpoint state and optionally see git restore commands
argument-hint: [checkpoint-name]
---

# Restore Checkpoint

Name: $ARGUMENTS

## Instructions

1. If no name provided:
   - List available checkpoints from ~/.claude/learnings/checkpoints/
   - Show each with created date and note
   - Respond: "Available checkpoints: [list]. Usage: /restore [name]"
   - Stop.

2. Load checkpoint file ~/.claude/learnings/checkpoints/[name].json
   - If not found, list available checkpoints and stop.

3. Gather current state for comparison:
   - Current git state (if in repo)

4. Display checkpoint info:
   ```
   ## Checkpoint: [name]
   Created: [timestamp]
   Directory: [cwd]

   ### Note
   [What you were about to try]

   ### Git State at Checkpoint
   Branch: [branch]
   Commit: [commit]
   Status: [clean/dirty]

   ### Current State
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

6. Remind about saved learnings:
   ```
   Note: Any reflections saved with /save-learnings persist in .claude/learnings/
   and are NOT affected by git restore or conversation rewind.
   ```

## Notes

- Checkpoints only store git state and a contextual note
- They do NOT store conversation history or reflection content
- Use /save-learnings before rewinding to persist any reflections
- Git restore commands are shown but not auto-executed for safety
