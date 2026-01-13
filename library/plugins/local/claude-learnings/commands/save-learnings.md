---
description: Save approved reflection to designated folder (survives rewind)
argument-hint: [optional: path/to/folder]
---

# Save Learnings

## Purpose

Persist the most recent reflection output to a file that survives conversation rewind.

Destination: $ARGUMENTS

## The Process

### Step 1: Locate Reflection

Find the most recent reflection output in this conversation (output from `/reflect`).

If no reflection found in the conversation:
- Respond: "No reflection found in this conversation. Run `/reflect` first."
- Stop

### Step 2: Determine Destination

**If path was specified above** (e.g., `/save-learnings ./project-learnings/`):
- Use that path as the destination folder
- Create the directory if it doesn't exist

**If no path specified**:
- First, check if current directory is inside a git repository
- If yes: use `.claude/learnings/` relative to the git root
- If no git repo: use `~/.claude/learnings/` (global)
- Create the directory if it doesn't exist

### Step 3: Generate Filename

Format: `YYYY-MM-DD-HHMMSS-[focus-slug].md`

Rules:
- Use current timestamp
- If a focus area was specified in the reflection, slugify it (lowercase, hyphens for spaces, remove special chars)
- If no focus area, use "full-session"
- Truncate slug to 50 characters max

Examples:
- `2026-01-12-143052-phase-1-auth-refactor.md`
- `2026-01-12-160230-full-session.md`
- `2026-01-12-171545-api-integration.md`

### Step 4: Prepare Content

Prepend YAML frontmatter to the reflection content:

```yaml
---
saved: [ISO 8601 timestamp]
project: [repo name from git, or directory name]
workflow: [workflow name if identifiable from conversation]
focus: [focus area if specified, or "full-session"]
files_referenced:
  - [list of files from the Files Referenced section]
---
```

Then include the full reflection content.

### Step 5: Handle Collisions

If the generated filename already exists:
- Append a numeric suffix: `-1`, `-2`, etc.
- Example: `2026-01-12-143052-auth-refactor-1.md`

Never overwrite existing files.

### Step 6: Write File

Write the prepared content to the destination path.

### Step 7: Confirm

Output:

```
Saved: [full absolute path to file]

You can now use rewind and this learning will persist at:
[full absolute path]

To process accumulated learnings later, point a Claude agent at:
[directory path]
```

## Notes

- Creates directories as needed (including nested paths)
- Never overwrites existing files
- The saved file is completely self-contained and can be understood without the original conversation
- The YAML frontmatter enables programmatic processing by downstream agents
- The files_referenced list in frontmatter allows quick identification of relevant files

## Error Handling

If write fails:
- Report the error clearly
- Suggest checking permissions or trying a different path
- Do not lose the reflection content - it remains in the conversation

## Example Output

```
Saved: /Users/you/project/.claude/learnings/2026-01-12-143052-auth-refactor.md

You can now use rewind and this learning will persist at:
/Users/you/project/.claude/learnings/2026-01-12-143052-auth-refactor.md

To process accumulated learnings later, point a Claude agent at:
/Users/you/project/.claude/learnings/
```
