# Testing Guide

## Manual Testing Checklist

Use this checklist to verify the plugin is working correctly after installation.

### Setup Verification

- [ ] `~/.claude/learnings/` directory exists
- [ ] `~/.claude/learnings/queue.json` exists and contains `{"entries":[]}`
- [ ] `~/.claude/learnings/checkpoints/` directory exists

### Command Tests

#### `/log` Command

```
/log Test pattern entry
```
- [ ] Output shows: `Logged insight: "Test pattern entry"`
- [ ] Entry appears in `~/.claude/learnings/queue.json`
- [ ] Entry has `status: "pending"`

```
/log This pattern should always be followed
```
- [ ] Output shows: `Logged pattern: "..."`  (detected "pattern" keyword)

```
/log The build failed due to missing dependency
```
- [ ] Output shows: `Logged warning: "..."` (detected "failed" keyword)

```
/log The fix worked perfectly
```
- [ ] Output shows: `Logged success: "..."` (detected "worked" and "perfectly" keywords)

#### `/log_error` Command

```
/log_error Claude used wrong API
```
- [ ] Output shows: `Logged warning: "Claude used wrong API"`
- [ ] Entry in queue has `type: "warning"`

#### `/log_success` Command

```
/log_success Refactoring improved readability
```
- [ ] Output shows: `Logged success: "Refactoring improved readability"`
- [ ] Entry in queue has `type: "success"`

#### `/review-learnings` Command

Prerequisites: Have at least 2 pending entries from above tests.

```
/review-learnings
```
- [ ] Shows summary with entry count by type
- [ ] Presents first entry with approve/edit/skip/quit options
- [ ] On approve: Entry added to `~/.claude/CLAUDE.md`
- [ ] On skip: Entry marked as "skipped"
- [ ] After review: Processed entries moved to `archive.json`

#### `/checkpoint` Command

```
/checkpoint test-checkpoint
```
- [ ] Output shows: `Checkpoint 'test-checkpoint' saved...`
- [ ] File created at `~/.claude/learnings/checkpoints/test-checkpoint.json`
- [ ] Checkpoint contains `learnings_snapshot` array
- [ ] If in git repo, checkpoint contains git state

#### `/restore` Command

```
/restore
```
- [ ] Lists available checkpoints

```
/restore test-checkpoint
```
- [ ] Shows checkpoint info
- [ ] Shows current state comparison
- [ ] If git differs, shows restore commands
- [ ] Asks about restoring queue

### Edge Cases

#### Empty Queue
```
/review-learnings  (with empty queue)
```
- [ ] Output shows: "No pending learnings to review."

#### Invalid Checkpoint Name
```
/checkpoint "invalid name with spaces"
```
- [ ] Shows error about invalid characters

#### Missing Checkpoint
```
/restore nonexistent-checkpoint
```
- [ ] Lists available checkpoints instead of error

### Cleanup After Testing

```bash
# Remove test entries
echo '{"entries":[]}' > ~/.claude/learnings/queue.json

# Remove test checkpoints
rm -f ~/.claude/learnings/checkpoints/test-checkpoint.json

# Remove test sections from CLAUDE.md (manual)
```

## Automated Test Ideas (Future)

For future development, consider adding:

1. **Unit tests** for JSON schema validation
2. **Integration tests** that run commands and verify file state
3. **Snapshot tests** for CLAUDE.md output format

These would require a test harness that can invoke Claude Code commands programmatically.
