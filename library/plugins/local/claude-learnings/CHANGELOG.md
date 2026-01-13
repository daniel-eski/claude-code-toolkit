# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-01-12

### Changed - Breaking

Complete redesign of the plugin. **This version is not backward compatible with v1.x.**

The plugin now focuses on **thoughtful reflection** rather than quick capture:

- Removed `/log`, `/log_error`, `/log_success`, `/review-learnings` commands
- Replaced with `/reflect` and `/save-learnings` workflow
- No longer uses queue.json for staged entries
- Learnings now saved directly as markdown files

### Added

- **`/reflect [focus]`** - Thoughtful analysis command
  - Analyzes corrections, gaps, confusion, and what worked well
  - Requires specific file citations with line numbers and quoted text
  - Produces structured output for human review and downstream agent consumption
  - Includes Actionable Items table and Files Referenced list

- **`/save-learnings [path]`** - Save reflection to file
  - Saves to project-level `.claude/learnings/` by default
  - Files persist after conversation rewind
  - YAML frontmatter for programmatic processing
  - Timestamped filenames with focus area slug

### Kept

- **`/checkpoint [name]`** - State snapshot (unchanged from v1)
- **`/restore [name]`** - View/restore checkpoint (unchanged from v1)

### Removed

- `/log [entry]` - Quick capture command
- `/log_error [entry]` - Error logging alias
- `/log_success [entry]` - Success logging alias
- `/review-learnings` - Batch review and CLAUDE.md sync
- `queue.json` - Staged entries storage
- `archive.json` - Processed entries archive

### Migration

If upgrading from v1.x:

1. Any entries in `queue.json` will not be migrated - review and save manually first
2. Remove old queue/archive files: `rm ~/.claude/learnings/queue.json ~/.claude/learnings/archive.json`
3. The new workflow is: work → `/reflect` → review → `/save-learnings` → continue or rewind

## [1.0.0] - 2026-01-09

### Added

- **`/log [entry]`** - Quick capture command with auto-detected type
  - Detects `warning`, `success`, `pattern`, or `insight` from keywords
  - Appends to `~/.claude/learnings/queue.json`
  - Zero-friction single-line confirmation

- **`/log_error [entry]`** - Alias that forces type to "warning"

- **`/log_success [entry]`** - Alias that forces type to "success"

- **`/review-learnings`** - Batch review command
  - Interactive approve/edit/skip/quit flow
  - Syncs approved entries to CLAUDE.md sections
  - Archives processed entries

- **`/checkpoint [name]`** - State snapshot for rewind workflow
  - Captures learnings queue snapshot
  - Captures git state (branch, commit, dirty status)
  - Stores named checkpoints in `~/.claude/learnings/checkpoints/`

- **`/restore [name]`** - Checkpoint viewer and restore
  - Shows checkpoint state vs current state
  - Provides git commands to restore code (doesn't auto-execute)
  - Optionally restores learnings queue

- Plugin manifest (`plugin.json`) for Claude Code plugin system
- Comprehensive documentation (README, INSTALLATION guide)
- Example files (queue, checkpoint, CLAUDE.md output)
