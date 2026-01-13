# Reflect Skill Design Plan

## Overview

Design a `/reflect` skill that enables Claude Code to thoughtfully analyze its own performance during a workflow session, producing structured learnings that:
1. Can be reviewed by the user before saving
2. Persist after rewind (saved to designated folder)
3. Are traceable to specific files/instructions for downstream agent consumption

---

## The Two-Command System

### Command 1: `/reflect [optional: focus area]`
Claude analyzes recent work and produces structured reflection output in conversation.

### Command 2: `/save-learnings [optional: path]`
Saves the approved reflection to a designated folder.

---

## `/reflect` Skill Design

### Frontmatter

```yaml
---
name: reflect
description: Use mid-workflow to analyze what went well/poorly, capturing learnings that can be saved and survive rewind for downstream improvement
argument-hint: [optional: focus area, e.g., "Phase 1 of auth refactor"]
---
```

### Core Philosophy

The reflection should:
- **Be specific and traceable** — cite files, quote instructions, reference conversation moments
- **Serve two audiences** — human (reviewing now) and downstream agent (processing later)
- **Discover, not confirm** — structured enough for consistency, open enough for unexpected insights
- **Be self-contained** — readable without the full conversation

### Structure

```markdown
# Thoughtful Reflection

## Overview

Reflection is not summary. Reflection is understanding WHY things happened and WHAT would make them better.

**Core principle:** Every learning must be traceable to something specific (a file, an instruction, a conversation moment) or it's not actionable.

## When to Use

Use `/reflect` when:
- You (the user) had to correct Claude's approach
- Claude struggled, got confused, or asked clarifying questions
- A phase or significant chunk of work completed
- You want to capture learnings before rewinding
- Something worked particularly well and should be preserved

## The Reflection Process

### Step 1: Scope Determination

If focus area specified (e.g., `/reflect Phase 1 authentication`):
- Concentrate reflection on that area
- Still note other significant observations briefly

If no focus area:
- Reflect on the entire conversation since session start
- Organize by natural phases or task groupings

### Step 2: Structured Analysis

For EACH section below, be specific. Cite files, quote text, reference conversation turns.

#### Section A: Corrections Received

Think about: What did the user correct you on?

For each correction:
1. **What happened**: Describe the specific mistake
2. **What you were trying to do**: Your intent at the time
3. **What led you astray**: Quote the specific file/instruction/context that was unclear, missing, or misinterpreted
4. **What would have prevented it**: Specific change to file, instruction, or context

Example format:
```
### Correction: Used REST instead of GraphQL

**What happened**: I started implementing REST endpoints when the project uses GraphQL.

**What I was trying to do**: Add the user profile API.

**What led me astray**: The `CLAUDE.md` mentions "API development" but doesn't specify GraphQL. I saw `src/api/` directory and assumed REST from the folder structure.

**What would have prevented it**: Add to `CLAUDE.md`:
> ## API Conventions
> - This project uses GraphQL exclusively. All data fetching goes through `src/graphql/`.
> - Never create REST endpoints.

**File to update**: `CLAUDE.md` (project root)
```

#### Section B: Gaps Revealed by Questions

Think about: What questions did the user ask that revealed something you didn't know or couldn't find?

User questions are signals of missing context. Each question implies: "This should have been obvious or documented."

For each revealing question:
1. **The question**: What the user asked
2. **What it revealed**: What you were missing
3. **Where it should live**: Which file should contain this information
4. **Suggested addition**: The specific text to add

#### Section C: Points of Confusion

Think about: What were you uncertain about? What made you pause or ask for clarification?

For each point of confusion:
1. **What was confusing**: The specific instruction, file, or situation
2. **Why it was confusing**: Ambiguous wording? Missing context? Contradictory information?
3. **How it was resolved**: What clarified it (if resolved)
4. **Suggested improvement**: How to make it clearer for future

Be honest. If something in the workflow instructions didn't make sense, say exactly what and why.

#### Section D: What Worked Well

Think about: What went smoothly? What was well-documented or well-structured?

For each positive:
1. **What worked**: The specific instruction, file, or pattern
2. **Why it worked**: What made it effective
3. **Preserve/replicate note**: Flag this as something to NOT change, or to apply elsewhere

This prevents the downstream agent from "fixing" things that aren't broken.

### Step 3: Open Reflection

After completing the structured sections, think more broadly:

- What patterns do you notice across the corrections and confusions?
- What surprised you about this work?
- What assumptions did you make that turned out wrong?
- What would you do differently if starting over?
- Are there structural issues (not just content issues) in the workflow or instructions?
- What did you learn that doesn't fit the categories above?

This section is for unexpected insights. Don't force it if nothing emerges, but don't skip it if something did.

### Step 4: Summary for Downstream Agent

Compile a structured summary that a future agent can act on:

```
## Actionable Items

| Priority | File | Change Type | Description |
|----------|------|-------------|-------------|
| High | path/to/file.md | Add section | [Brief description] |
| Medium | path/to/other.md | Clarify | [Brief description] |
| Low | CLAUDE.md | Add pattern | [Brief description] |

## Files Referenced
- `path/to/file.md:45-52` — [why referenced]
- `path/to/other.md` — [why referenced]
```

## Output Format

Present the reflection in conversation using this structure:

```
# Reflection: [Focus Area or "Full Session"]
*Generated: [timestamp]*
*Workflow: [workflow name if identifiable]*
*Project: [repo/project name]*

---

## Corrections Received
[Section A content]

## Gaps Revealed
[Section B content]

## Points of Confusion
[Section C content]

## What Worked Well
[Section D content]

## Open Reflection
[Step 3 content]

---

## Actionable Items
[Summary table]

## Files Referenced
[File list]

---

*Ready to save? Use `/save-learnings` or `/save-learnings path/to/folder`*
```

## Important Notes

- **Be brutally honest**: The value is in accurate assessment, not diplomatic phrasing
- **Cite with full specificity** (REQUIRED):
  - BAD: "The instructions were unclear"
  - GOOD: "Line 45 of `library/skills/kickoff.md` says 'handle errors appropriately' which doesn't specify try-catch vs error boundaries vs validation"
  - Include: file path, line number when possible, quoted text
- **Include conversation evidence**: Reference what turn/exchange revealed something when possible
- **Don't invent**: If a section is empty (no corrections received), say so briefly and move on
- **Quantity isn't quality**: 3 specific, traceable learnings beat 10 vague observations
- **Every actionable item must have a file path**: The downstream agent needs to know exactly where to make changes
```

---

## `/save-learnings` Skill Design

### Frontmatter

```yaml
---
name: save-learnings
description: Save approved reflection to designated folder (survives rewind)
argument-hint: [optional: path/to/folder]
---
```

### Behavior

```markdown
# Save Learnings

## Purpose

Persist the most recent reflection output to a file that survives conversation rewind.

## The Process

### Step 1: Locate Reflection

Find the most recent reflection output in this conversation.

If no reflection found:
- Respond: "No reflection found in this conversation. Run `/reflect` first."
- Stop

### Step 2: Determine Destination

**If path specified** (e.g., `/save-learnings ./project-learnings/`):
- Use that path
- Create directory if it doesn't exist

**If no path specified**:
- Check for project-level: `.claude/learnings/`
- If not exists, use global: `~/.claude/learnings/`
- Create directory if needed

### Step 3: Generate Filename

Format: `YYYY-MM-DD-HHMMSS-[focus-slug].md`

Examples:
- `2026-01-12-143052-auth-refactor.md`
- `2026-01-12-160230-full-session.md`

If focus area was specified in reflection, slugify it. Otherwise use "full-session" or infer from context.

### Step 4: Add Metadata Header

Prepend to the reflection content:

```
---
saved: [ISO timestamp]
conversation_id: [if available]
project: [repo name]
workflow: [workflow name if identifiable]
focus: [focus area if specified]
---

[Original reflection content]
```

### Step 5: Write File

Write to the destination path.

### Step 6: Confirm

Output:
```
Saved: [full path to file]

You can now `/rewind` and this learning will persist at:
[full path]
```

## Notes

- Creates directories as needed
- Never overwrites existing files (adds numeric suffix if collision)
- The saved file should be completely self-contained
```

---

## File Organization

### Recommended Structure

```
.claude/learnings/           # Project-level (committed or gitignored)
├── 2026-01-12-143052-auth-refactor.md
├── 2026-01-12-160230-api-integration.md
└── ...

~/.claude/learnings/         # Global fallback
├── ...
```

### For Downstream Agent Consumption

The downstream agent should be able to:
1. Read all `.md` files in the learnings folder
2. Parse the YAML frontmatter for metadata
3. Use the "Actionable Items" table to identify what to update
4. Use "Files Referenced" to find specific locations
5. Read the full context in each section to understand the change needed

---

## Implementation Plan

### Phase 1: Remove Old Commands

**Files to delete**:
- `library/plugins/local/claude-learnings/commands/log.md`
- `library/plugins/local/claude-learnings/commands/log_error.md`
- `library/plugins/local/claude-learnings/commands/log_success.md`
- `library/plugins/local/claude-learnings/commands/review-learnings.md`

### Phase 2: Create `/reflect` Command

**Create**: `library/plugins/local/claude-learnings/commands/reflect.md`

Write the full skill content as specified in the design above.

### Phase 3: Create `/save-learnings` Command

**Create**: `library/plugins/local/claude-learnings/commands/save-learnings.md`

Write the command for saving reflections to file.

### Phase 4: Update Plugin Documentation

**Modify**: `library/plugins/local/claude-learnings/README.md`
- Remove references to old commands
- Document new `/reflect` + `/save-learnings` workflow
- Add usage examples
- Document the reflect → save → rewind pattern

**Modify**: `library/plugins/local/claude-learnings/.claude-plugin/plugin.json`
- Update command list if needed

### Phase 5: Clean Up Related Files

**Consider removing** (if no longer needed):
- `examples/queue-example.json` (queue pattern removed)
- `docs/TESTING.md` (update for new commands)

**Keep**:
- `commands/checkpoint.md`
- `commands/restore.md`
- `examples/checkpoint-example.json`

---

## Verification Criteria

**The skill works if**:
1. `/reflect` produces specific, traceable observations (not generic platitudes)
2. Each correction/confusion cites a specific file or instruction
3. The "Actionable Items" table is parseable by another agent
4. `/save-learnings` creates a self-contained file
5. The file survives rewind
6. A downstream agent can read the file and understand what to change without additional context

---

## What This Replaces in claude-learnings Plugin

**Decision: Replace existing commands entirely.**

The existing commands (`/log`, `/log_error`, `/log_success`, `/review-learnings`) will be removed. The new `/reflect` + `/save-learnings` approach:
- **Replaces the queue/review pattern** with direct, thoughtful output
- **Adds reasoning** — Claude thinks about *why*, not just *what*
- **Improves traceability** — every learning cites specific files with line numbers and quoted text
- **Serves the downstream use case** — structured for agent consumption

Commands to remove:
- `commands/log.md`
- `commands/log_error.md`
- `commands/log_success.md`
- `commands/review-learnings.md`

Commands to keep (still useful):
- `commands/checkpoint.md`
- `commands/restore.md`

---

## Design Decisions (Confirmed)

1. **Replace existing commands** — `/reflect` + `/save-learnings` fully replaces the quick-log pattern
2. **Project-level first** — Default to `.claude/learnings/` in project root, global fallback
3. **Very specific citations required** — File paths, line numbers, and quoted text when possible
