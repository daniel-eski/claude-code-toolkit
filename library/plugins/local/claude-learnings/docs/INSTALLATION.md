# Installation Guide

## Prerequisites

- Claude Code CLI installed and configured
- Git (for checkpoint features)

## Installation Methods

### Method 1: Plugin Install (Recommended)

```bash
# Install from repository
claude plugins add https://github.com/danieleskenazi/claude-learnings-plugin

# Create data directory (required)
mkdir -p ~/.claude/learnings/checkpoints
echo '{"entries":[]}' > ~/.claude/learnings/queue.json
```

The plugin will be installed to `~/.claude/plugins/claude-learnings/` and commands will be available globally.

### Method 2: Manual Global Install

For commands available across all projects:

```bash
# Clone or download the repository
git clone https://github.com/danieleskenazi/claude-learnings-plugin /tmp/claude-learnings

# Copy commands to global location
cp /tmp/claude-learnings/commands/*.md ~/.claude/commands/

# Create data directory
mkdir -p ~/.claude/learnings/checkpoints
echo '{"entries":[]}' > ~/.claude/learnings/queue.json

# Cleanup
rm -rf /tmp/claude-learnings
```

### Method 3: Manual Project Install

For commands available only in a specific project:

```bash
# In your project root
mkdir -p .claude/commands

# Clone or download, then copy commands
git clone https://github.com/danieleskenazi/claude-learnings-plugin /tmp/claude-learnings
cp /tmp/claude-learnings/commands/*.md .claude/commands/

# For project-scoped learnings (optional)
mkdir -p .claude/learnings/checkpoints
echo '{"entries":[]}' > .claude/learnings/queue.json

# Cleanup
rm -rf /tmp/claude-learnings
```

**Note:** If using project-scoped learnings, you may want to add `.claude/learnings/` to `.gitignore`.

## Post-Installation

### Verify Installation

Start a new Claude Code session (or run `/clear`), then:

```
/log Test entry to verify installation
```

Expected output:
```
Logged insight: "Test entry to verify installation"
```

Verify the queue:
```bash
cat ~/.claude/learnings/queue.json
```

Should show your test entry.

### Directory Structure After Installation

```
~/.claude/
├── commands/                    # (if manual install)
│   ├── log.md
│   ├── log_error.md
│   ├── log_success.md
│   ├── review-learnings.md
│   ├── checkpoint.md
│   └── restore.md
├── plugins/                     # (if plugin install)
│   └── claude-learnings/
│       ├── plugin.json
│       └── commands/
│           └── *.md
├── learnings/                   # Data storage (created manually)
│   ├── queue.json
│   ├── archive.json            # Created on first review
│   └── checkpoints/
└── CLAUDE.md                   # Sync target (your existing file)
```

## Configuration

### Custom Queue Location

By default, learnings are stored in `~/.claude/learnings/`. To use a different location, edit the command files to change the path.

### Project-Scoped vs Global Learnings

**Global (default):** Learnings sync to `~/.claude/CLAUDE.md` and are available across all projects.

**Project-scoped:**
1. Create `.claude/learnings/queue.json` in your project
2. Edit command files to use `.claude/` instead of `~/.claude/`
3. Learnings sync to project's `CLAUDE.md`

## Updating

### Plugin Method

```bash
claude plugins update claude-learnings
```

### Manual Method

```bash
# Re-download and copy
git clone https://github.com/danieleskenazi/claude-learnings-plugin /tmp/claude-learnings
cp /tmp/claude-learnings/commands/*.md ~/.claude/commands/
rm -rf /tmp/claude-learnings
```

## Uninstalling

### Plugin Method

```bash
claude plugins remove claude-learnings
```

### Manual Method

```bash
# Remove commands
rm ~/.claude/commands/log.md
rm ~/.claude/commands/log_error.md
rm ~/.claude/commands/log_success.md
rm ~/.claude/commands/review-learnings.md
rm ~/.claude/commands/checkpoint.md
rm ~/.claude/commands/restore.md

# Optionally remove data (WARNING: loses all learnings)
rm -rf ~/.claude/learnings/
```

## Troubleshooting

### Commands not recognized

1. Restart Claude Code session or run `/clear`
2. Verify files exist in correct location
3. Check file permissions: `ls -la ~/.claude/commands/`

### Queue not found errors

Ensure the data directory exists:
```bash
mkdir -p ~/.claude/learnings/checkpoints
echo '{"entries":[]}' > ~/.claude/learnings/queue.json
```

### Git state not captured in checkpoints

Checkpoints only capture git state when run inside a git repository. Verify with:
```bash
git rev-parse --is-inside-work-tree
```

### CLAUDE.md not updated after review

1. Check that `~/.claude/CLAUDE.md` exists
2. Verify you approved (not skipped) entries during review
3. Check file permissions on CLAUDE.md
