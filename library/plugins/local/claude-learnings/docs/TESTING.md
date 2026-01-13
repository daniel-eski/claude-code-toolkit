# Testing Guide

## Manual Testing Checklist

Use this checklist to verify the plugin is working correctly after installation.

### Setup Verification

- [ ] Plugin is installed (check `claude plugins list`)
- [ ] `.claude/learnings/` directory can be created in project root
- [ ] `~/.claude/learnings/checkpoints/` directory exists (for global checkpoints)

### Command Tests

#### `/reflect` Command

**Basic reflection (no focus area):**
```
/reflect
```
- [ ] Claude analyzes the conversation
- [ ] Output includes all sections: Corrections, Gaps, Confusion, What Worked, Open Reflection
- [ ] Actionable Items table is present
- [ ] Files Referenced list is present
- [ ] Ends with prompt to use `/save-learnings`

**Focused reflection:**
```
/reflect Phase 1 authentication work
```
- [ ] Output title shows: "Reflection: Phase 1 authentication work"
- [ ] Analysis focuses on the specified area
- [ ] Still includes all required sections

**Specificity check:**
- [ ] Each correction cites specific file paths
- [ ] Line numbers included where applicable
- [ ] Problematic text is quoted
- [ ] Suggested changes include exact text to add/modify

#### `/save-learnings` Command

**Prerequisites:** Run `/reflect` first to have content to save.

**Default save location:**
```
/save-learnings
```
- [ ] File created in `.claude/learnings/` (project root)
- [ ] Filename format: `YYYY-MM-DD-HHMMSS-[slug].md`
- [ ] YAML frontmatter present with: saved, project, workflow, focus, files_referenced
- [ ] Full reflection content preserved

**Custom save location:**
```
/save-learnings ./my-learnings/
```
- [ ] Directory created if needed
- [ ] File saved to specified location
- [ ] Confirmation shows full path

**No reflection available:**
```
/save-learnings  (without running /reflect first)
```
- [ ] Shows error: "No reflection found in this conversation. Run `/reflect` first."

#### `/checkpoint` Command

```
/checkpoint test-checkpoint
```
- [ ] Output shows: `Checkpoint 'test-checkpoint' saved...`
- [ ] File created at `~/.claude/learnings/checkpoints/test-checkpoint.json`
- [ ] If in git repo, checkpoint contains git state (branch, commit, dirty)
- [ ] Checkpoint contains timestamp and cwd

#### `/restore` Command

**List checkpoints:**
```
/restore
```
- [ ] Lists available checkpoints with creation dates

**View specific checkpoint:**
```
/restore test-checkpoint
```
- [ ] Shows checkpoint info (created, directory, git state)
- [ ] Shows current state comparison
- [ ] If git state differs, shows commands to restore

### Integration Test: Full Workflow

Test the complete reflect → save → rewind workflow:

1. Start a conversation with some work
2. Run `/reflect` with a focus area
3. Review the output for quality and specificity
4. Run `/save-learnings`
5. Verify file was created
6. Use `/rewind` to go back
7. Verify the saved file still exists (survives rewind)

### Edge Cases

#### Invalid Checkpoint Name
```
/checkpoint "invalid name with spaces"
```
- [ ] Shows error about invalid characters

#### Missing Checkpoint
```
/restore nonexistent-checkpoint
```
- [ ] Lists available checkpoints instead of crashing

#### Empty Conversation Reflection
```
/reflect  (at start of conversation with no work done)
```
- [ ] Handles gracefully, notes "None identified" for empty sections

### Quality Checks for Reflection Output

When reviewing `/reflect` output, verify:

- [ ] Corrections include "What led me astray" with file citations
- [ ] Gaps include "Where it should live" with specific file paths
- [ ] Confusion points include "Suggested improvement" with exact text
- [ ] What Worked Well identifies patterns to preserve
- [ ] Actionable Items table has Priority, File, Line(s), Change Type, Description
- [ ] No vague statements like "the instructions were unclear"

### Cleanup After Testing

```bash
# Remove test checkpoints
rm -f ~/.claude/learnings/checkpoints/test-checkpoint.json

# Remove test learnings (if created)
rm -rf .claude/learnings/
```

## Downstream Agent Test (Optional)

To verify learnings are usable by a downstream agent:

1. Accumulate 2-3 reflection files in `.claude/learnings/`
2. Start a new Claude conversation
3. Provide prompt: "Read all files in .claude/learnings/ and summarize the actionable items"
4. Verify the agent can:
   - Parse the YAML frontmatter
   - Read the Actionable Items tables
   - Understand what changes to make and where
