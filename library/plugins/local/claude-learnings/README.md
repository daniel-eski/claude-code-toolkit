# Claude Learnings Plugin

> **Toolkit Copy**: This is a shareable copy with standardized manifest structure
> (`plugin.json` moved to `.claude-plugin/plugin.json` for toolkit consistency).

A Claude Code plugin for capturing learnings, errors, and successes during coding sessions. Review and sync approved learnings to CLAUDE.md for persistent workflow improvement.

## Why This Exists

When working with Claude Code, you discover patterns:
- Things that work well (and should be repeated)
- Things that fail (and should be avoided)
- Insights worth remembering

This plugin provides zero-friction capture of these learnings, with human-gated review before anything gets added to your CLAUDE.md.

## Features

| Command | Purpose |
|---------|---------|
| `/log [entry]` | Quick capture with auto-detected type |
| `/log_error [entry]` | Capture errors/mistakes (forces "warning" type) |
| `/log_success [entry]` | Capture what worked (forces "success" type) |
| `/review-learnings` | Batch review and sync to CLAUDE.md |
| `/checkpoint [name]` | Save state for potential rewind |
| `/restore [name]` | View/restore from checkpoint |

## Quick Start

```bash
# Install the plugin
claude plugins add https://github.com/danieleskenazi/claude-learnings-plugin

# Or manual install (copy to ~/.claude/plugins/)
git clone https://github.com/danieleskenazi/claude-learnings-plugin ~/.claude/plugins/claude-learnings

# Create required data directory
mkdir -p ~/.claude/learnings/checkpoints
echo '{"entries":[]}' > ~/.claude/learnings/queue.json
```

Then in Claude Code:
```
/log Always run tests before pushing to main
/log_error Claude ignored my TypeScript preference
/log_success The refactor made error handling much cleaner
/review-learnings
```

## How It Works

### Capture Flow

```
/log, /log_error, /log_success
           ↓
    queue.json (pending)
           ↓
    /review-learnings
           ↓
    Human approves/edits/skips
           ↓
    CLAUDE.md (synced)
```

### Type Detection

When using `/log`, the type is auto-detected from keywords:

| Keywords | Detected Type |
|----------|---------------|
| error, failed, wrong, mistake, bug, broke | `warning` |
| worked, success, solved, fixed, great, perfect | `success` |
| pattern, always, never, should, must, rule | `pattern` |
| (none of the above) | `insight` |

Use `/log_error` or `/log_success` to force a specific type.

### Checkpoint/Restore Flow

```
/checkpoint before-refactor
     ↓
  (experiment)
     ↓
/restore before-refactor
     ↓
  Compare states, optionally restore queue
```

Checkpoints capture:
- Learnings queue snapshot
- Git state (branch, commit, dirty status)
- Working directory
- Timestamp

## Commands Reference

### `/log [entry]`

Quick capture with minimal friction.

```
/log Always check for null before accessing nested properties
→ Logged pattern: "Always check for null before accessing..."
```

### `/log_error [entry]`

Explicitly log an error or mistake (forces type to "warning").

```
/log_error Claude kept using deprecated API despite instructions
→ Logged warning: "Claude kept using deprecated API..."
```

### `/log_success [entry]`

Explicitly log what worked well (forces type to "success").

```
/log_success The fix for CORS was adding origin header
→ Logged success: "The fix for CORS was adding origin..."
```

### `/review-learnings`

Interactive batch review of pending learnings.

1. Shows summary by type
2. For each entry: approve / edit / skip / quit
3. Approved entries sync to appropriate CLAUDE.md section
4. Processed entries archived

**CLAUDE.md sections created:**
- `## Learned Patterns` — patterns and insights
- `## What Works` — successes
- `## Known Pitfalls` — warnings

### `/checkpoint [name]`

Save current state for potential rewind.

```
/checkpoint before-big-refactor
→ Checkpoint 'before-big-refactor' saved. Restore with /restore before-big-refactor
```

### `/restore [name]`

View checkpoint state and optionally restore learnings queue.

```
/restore before-big-refactor
→ Shows checkpoint info, git state diff, asks to restore queue
```

Without a name, lists available checkpoints:
```
/restore
→ Available checkpoints: before-big-refactor, pre-migration. Usage: /restore [name]
```

## Data Storage

```
~/.claude/
├── learnings/
│   ├── queue.json          # Pending entries
│   ├── archive.json        # Processed entries (created on first review)
│   └── checkpoints/        # Named state snapshots
│       └── {name}.json
└── CLAUDE.md               # Sync target for approved learnings
```

### Queue Entry Schema

```json
{
  "entries": [
    {
      "id": "a1b2c3d4",
      "timestamp": "2026-01-09T14:30:00Z",
      "type": "pattern",
      "raw": "Always run tests before pushing",
      "context": {
        "cwd": "/Users/you/project"
      },
      "status": "pending"
    }
  ]
}
```

### Checkpoint Schema

```json
{
  "name": "before-refactor",
  "created": "2026-01-09T14:30:00Z",
  "cwd": "/Users/you/project",
  "git": {
    "branch": "main",
    "commit": "abc1234",
    "dirty": false
  },
  "learnings_snapshot": []
}
```

## Installation Options

See [INSTALLATION.md](docs/INSTALLATION.md) for detailed instructions.

**Quick options:**

| Method | Command |
|--------|---------|
| Plugin (recommended) | `claude plugins add [repo-url]` |
| Manual global | Copy `commands/` to `~/.claude/commands/` |
| Manual project | Copy `commands/` to `.claude/commands/` |

## Roadmap / Future Improvements

- [ ] **Passive hooks** — Auto-capture corrections (like claude-reflect)
- [ ] **Confidence scoring** — Prioritize frequently-occurring patterns
- [ ] **Project-scoped learnings** — Separate project vs global learnings
- [ ] **Deduplication** — Semantic similarity detection during review
- [ ] **Archive viewer** — Command to search/view archived learnings

## Related Tools

This plugin was inspired by:
- [claude-reflect](https://github.com/BayramAnnakov/claude-reflect) — Passive correction capture via hooks
- [claude-diary](https://github.com/rlancemartin/claude-diary) — Session-based diary entries

## Contributing

Contributions welcome! Please open an issue first to discuss proposed changes.

## License

MIT License - see [LICENSE](LICENSE)
