# Installation Guide

## Prerequisites

- Claude Code CLI installed and configured
- Git (for checkpoint features and project detection)

## Installation Methods

### Method 1: Plugin Install (Recommended)

```bash
# Install from repository
claude plugins add https://github.com/danieleskenazi/claude-learnings-plugin

# Create checkpoints directory (optional - for checkpoint/restore features)
mkdir -p ~/.claude/learnings/checkpoints
```

The plugin will be installed to `~/.claude/plugins/claude-learnings/` and commands will be available globally.

### Method 2: Manual Global Install

For commands available across all projects:

```bash
# Clone or download the repository
git clone https://github.com/danieleskenazi/claude-learnings-plugin /tmp/claude-learnings

# Copy commands to global location
cp /tmp/claude-learnings/commands/*.md ~/.claude/commands/

# Create checkpoints directory (optional)
mkdir -p ~/.claude/learnings/checkpoints

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

# Cleanup
rm -rf /tmp/claude-learnings
```

## Post-Installation

### Verify Installation

Start a new Claude Code session (or run `/clear`), then:

```
/reflect
```

Claude should begin analyzing the conversation and producing structured reflection output.

### Directory Structure After Installation

```
~/.claude/
├── commands/                    # (if manual install)
│   ├── reflect.md
│   ├── save-learnings.md
│   ├── checkpoint.md
│   └── restore.md
├── plugins/                     # (if plugin install)
│   └── claude-learnings/
│       ├── .claude-plugin/
│       │   └── plugin.json
│       └── commands/
│           └── *.md
└── learnings/                   # Data storage
    └── checkpoints/             # Named state snapshots

.claude/learnings/               # Project-level (default for saved reflections)
├── 2026-01-12-143052-auth-work.md
└── ...
```

## Configuration

### Default Save Location

By default, `/save-learnings` saves reflections to:
1. `.claude/learnings/` in the project root (if inside a git repo)
2. `~/.claude/learnings/` (global fallback)

You can always specify a custom path: `/save-learnings ./my-learnings/`

### Project-Level vs Global

**Project-level (default):** Reflections saved to `.claude/learnings/` in your project. Consider adding to `.gitignore` or committing for team sharing.

**Global:** Use `~/.claude/learnings/` for cross-project learnings.

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
rm ~/.claude/commands/reflect.md
rm ~/.claude/commands/save-learnings.md
rm ~/.claude/commands/checkpoint.md
rm ~/.claude/commands/restore.md

# Optionally remove data (WARNING: loses all learnings)
rm -rf ~/.claude/learnings/
rm -rf .claude/learnings/
```

## Troubleshooting

### Commands not recognized

1. Restart Claude Code session or run `/clear`
2. Verify files exist in correct location
3. Check file permissions: `ls -la ~/.claude/commands/`

### Save fails with permission error

Ensure the destination directory is writable:
```bash
mkdir -p .claude/learnings
chmod 755 .claude/learnings
```

### Checkpoints not finding git state

Checkpoints only capture git state when run inside a git repository. Verify with:
```bash
git rev-parse --is-inside-work-tree
```

### Reflection output is too vague

The `/reflect` command requires specific citations with file paths and line numbers. If output is vague:
1. Check that you're in a project with files to reference
2. Ensure there was actual work/conversation to reflect on
3. Use a focus area to narrow the scope: `/reflect Phase 1 work`
