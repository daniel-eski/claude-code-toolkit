# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

## [Unreleased]

### Planned

- Passive hooks for auto-capturing corrections
- Confidence scoring for pattern prioritization
- Project-scoped learnings (separate from global)
- Semantic deduplication during review
- Archive search/viewer command
