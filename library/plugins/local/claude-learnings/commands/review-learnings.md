---
description: Review pending learnings and sync approved ones to CLAUDE.md
---

# Review Pending Learnings

## Instructions

1. Read ~/.claude/learnings/queue.json
   - If file missing or entries array empty, respond: "No pending learnings to review." and stop.

2. Filter to only "pending" status entries

3. If no pending entries, respond: "No pending learnings to review." and stop.

4. Show summary:
   ```
   Pending learnings: [N] total
   - Patterns: [count]
   - Insights: [count]
   - Successes: [count]
   - Warnings: [count]
   ```

5. For each pending entry, use AskUserQuestion tool to present:
   - Show the entry type and raw text
   - Propose a formatted CLAUDE.md addition
   - Options: Approve / Edit / Skip / Quit review

6. On **Approve**:
   - Read ~/.claude/CLAUDE.md
   - Find or create appropriate section based on type:
     - "pattern" or "insight" → `## Learned Patterns`
     - "success" → `## What Works`
     - "warning" → `## Known Pitfalls`
   - Append formatted entry: `- **[YYYY-MM-DD]** [entry text]`
   - Write updated CLAUDE.md
   - Mark entry status as "synced" in queue.json

7. On **Edit**:
   - Accept user's revised text
   - Use revised text for CLAUDE.md addition
   - Proceed with append as in Approve

8. On **Skip**:
   - Mark entry status as "skipped" in queue.json
   - Continue to next entry

9. On **Quit**:
   - Save current queue state
   - Report: "Review paused. [N] entries remaining."
   - Stop processing

10. After all entries processed:
    - Move processed entries (synced/skipped) to ~/.claude/learnings/archive.json
    - Keep only "pending" entries in queue.json
    - Report: "Review complete. Synced [N], skipped [M]."

## CLAUDE.md Section Format

If section doesn't exist, create it with this format:
```markdown
## Learned Patterns
<!-- Synced from /review-learnings -->

```

Then append entries below the comment line.
