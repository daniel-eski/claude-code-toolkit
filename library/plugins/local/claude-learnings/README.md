# Claude Learnings Plugin

> **Toolkit Copy**: This is a shareable copy with standardized manifest structure
> (`plugin.json` moved to `.claude-plugin/plugin.json` for toolkit consistency).

A Claude Code plugin for thoughtful reflection and learning capture during workflow sessions. Designed to work with rewind: reflect mid-workflow, save learnings to a file, rewind, and continue — your learnings persist for later analysis.

## Why This Exists

When working with Claude Code on complex workflows, you accumulate learnings:
- Things Claude got wrong that you had to correct
- Instructions that were unclear or confusing
- Context that was missing from documentation
- Patterns that worked well

This plugin enables **thoughtful reflection** — Claude analyzes its own performance, produces structured learnings with specific file citations, and saves them to a folder that persists after rewind. A downstream agent can later process these learnings to improve workflow files.

## Features

| Command | Purpose |
|---------|---------|
| `/reflect [focus]` | Thoughtful analysis of what went well/poorly, with specific file citations |
| `/save-learnings [path]` | Persist reflection to folder (survives rewind) |
| `/checkpoint [name]` | Save state for potential rewind |
| `/restore [name]` | View/restore from checkpoint |

## The Reflect → Save → Rewind Workflow

```
[Working on a workflow...]
        ↓
User corrects Claude, asks questions, notices confusion
        ↓
/reflect                     ← Claude analyzes what happened
        ↓
[Review reflection output]
        ↓
/save-learnings              ← Save to .claude/learnings/
        ↓
/rewind                      ← Go back to before reflection
        ↓
[Continue workflow...]
        ↓
[Repeat as needed]
        ↓
[End: folder of learnings ready for downstream processing]
```

## Quick Start

```bash
# Install the plugin
claude plugins add https://github.com/danieleskenazi/claude-learnings-plugin

# Or manual install (copy to ~/.claude/plugins/)
git clone https://github.com/danieleskenazi/claude-learnings-plugin ~/.claude/plugins/claude-learnings

# Create learnings directory (optional - created automatically)
mkdir -p .claude/learnings
```

Then mid-workflow:
```
/reflect Phase 1 authentication work
[Claude produces detailed reflection with file citations]

/save-learnings
→ Saved: /project/.claude/learnings/2026-01-12-143052-phase-1-authentication.md

[Now you can /rewind and continue - the learning file persists]
```

## Commands Reference

### `/reflect [optional: focus area]`

Claude performs thoughtful analysis of the current session.

**What it analyzes:**
- **Corrections received** — What did the user correct? Why did Claude go wrong?
- **Gaps revealed by questions** — What user questions revealed missing context?
- **Points of confusion** — What was unclear in instructions or documentation?
- **What worked well** — What should be preserved?
- **Open reflection** — Broader patterns and insights

**Key requirement:** Every learning must cite specific files with line numbers and quoted text. Vague observations are not actionable.

**Example:**
```
/reflect Phase 1 API implementation

# Reflection: Phase 1 API Implementation
*Generated: 2026-01-12T14:30:52Z*
*Project: my-project*

---

## Corrections Received

### Correction: Used REST instead of GraphQL

**What happened**: Started implementing REST endpoints when project uses GraphQL.

**What led me astray**: In `CLAUDE.md` (line 23), the text "API development follows standard patterns" doesn't specify GraphQL. The `src/api/` directory structure suggested REST.

**What would have prevented it**:
Add to `CLAUDE.md` after line 23:
> ## API Conventions
> - This project uses GraphQL exclusively
> - All queries go through `src/graphql/`
> - Never create REST endpoints

...

## Actionable Items

| Priority | File | Line(s) | Change Type | Description |
|----------|------|---------|-------------|-------------|
| High | CLAUDE.md | 23 | Add section | Specify GraphQL-only API pattern |
| Medium | docs/setup.md | 45-50 | Clarify | Add GraphQL client setup steps |

---

*Ready to save? Use `/save-learnings` or `/save-learnings path/to/folder`*
```

### `/save-learnings [optional: path]`

Saves the most recent reflection to a file.

**Default location:**
- If in a git repo: `.claude/learnings/` at repo root
- Otherwise: `~/.claude/learnings/`

**Filename format:** `YYYY-MM-DD-HHMMSS-[focus-slug].md`

**Example:**
```
/save-learnings
→ Saved: /Users/you/project/.claude/learnings/2026-01-12-143052-phase-1-api.md

/save-learnings ./my-learnings/
→ Saved: /Users/you/project/my-learnings/2026-01-12-143052-phase-1-api.md
```

The saved file includes YAML frontmatter for programmatic processing:
```yaml
---
saved: 2026-01-12T14:30:52Z
project: my-project
workflow: kickoff
focus: phase-1-api-implementation
files_referenced:
  - CLAUDE.md
  - docs/setup.md
---
```

### `/checkpoint [name]`

Save current state for potential rewind.

```
/checkpoint before-big-refactor
→ Checkpoint 'before-big-refactor' saved. Restore with /restore before-big-refactor
```

Checkpoints capture:
- Git state (branch, commit, dirty status)
- Working directory
- Timestamp

### `/restore [name]`

View checkpoint state and optionally restore.

```
/restore before-big-refactor
→ Shows checkpoint info, git state diff, offers restore options

/restore
→ Lists available checkpoints
```

## Data Storage

```
.claude/learnings/              # Project-level (default)
├── 2026-01-12-143052-phase-1-api.md
├── 2026-01-12-160230-auth-flow.md
└── ...

~/.claude/learnings/            # Global fallback
├── checkpoints/                # Named state snapshots
│   └── {name}.json
└── ...
```

## Downstream Processing

The saved learnings are designed for consumption by another Claude agent. The format supports:

1. **YAML frontmatter** — Metadata for filtering and organization
2. **Actionable Items table** — Quick scan of what to change
3. **Files Referenced list** — Direct links to relevant files
4. **Full context** — Detailed explanation of each learning

**Example downstream prompt:**
```
Read all files in .claude/learnings/ and use them to improve the workflow files.
For each actionable item, make the suggested change to the referenced file.
```

## Installation Options

See [INSTALLATION.md](docs/INSTALLATION.md) for detailed instructions.

| Method | Command |
|--------|---------|
| Plugin (recommended) | `claude plugins add [repo-url]` |
| Manual global | Copy `commands/` to `~/.claude/commands/` |
| Manual project | Copy `commands/` to `.claude/commands/` |

## Design Philosophy

This plugin prioritizes **thoughtful reflection over quick capture**:

- **Depth over speed** — `/reflect` takes time to analyze, not quick one-liners
- **Specificity required** — Every learning must cite files and line numbers
- **Human review** — Reflection shown in conversation before saving
- **Rewind-compatible** — Saved files persist outside conversation state
- **Downstream-ready** — Structured format for agent processing

## Related Tools

Inspired by:
- [claude-reflect](https://github.com/BayramAnnakov/claude-reflect) — Passive correction capture via hooks
- [claude-diary](https://github.com/rlancemartin/claude-diary) — Session-based diary entries

## Contributing

Contributions welcome! Please open an issue first to discuss proposed changes.

## License

MIT License - see [LICENSE](LICENSE)
