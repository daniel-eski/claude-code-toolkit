# Claude Code Toolkit

A curated knowledge base for Claude Code: documentation, skills, plugins, and development resources.

## Purpose

This repository helps you and Claude Code agents:
- **Find documentation** about Claude Code features and best practices
- **Deploy skills and plugins** from curated collections
- **Develop and test** new skills and plugins
- **Share resources** with collaborators

## Quick Start

### For Claude Code Agents
Read `CLAUDE.md` for navigation guidance.

### For Humans

**By intent** (recommended):
| I want to... | Guide |
|--------------|-------|
| Start a new feature | [guides/start-feature.md](guides/start-feature.md) |
| Debug problems | [guides/debug-problems.md](guides/debug-problems.md) |
| Improve code quality | [guides/improve-quality.md](guides/improve-quality.md) |
| Work with Git/GitHub | [guides/git-workflow.md](guides/git-workflow.md) |
| Create documents | [guides/create-documents.md](guides/create-documents.md) |
| Learn Claude Code | [guides/learn-claude-code.md](guides/learn-claude-code.md) |
| Build skills/plugins | [guides/extend-claude-code.md](guides/extend-claude-code.md) |
| Orchestrate work | [guides/orchestrate-work.md](guides/orchestrate-work.md) |

→ **All guides**: [guides/](guides/)

**By type**:
| Category | Location |
|----------|----------|
| Official docs | `docs/claude-code/` |
| Best practices | `docs/best-practices/` |
| Skills | `library/skills/` |
| Plugins | `library/plugins/` |
| Experimental | `experimental/` |

## Repository Structure

```
/
├── docs/                 # Documentation indexes and pointers
│   ├── claude-code/      # Official docs (→ code.claude.com)
│   ├── best-practices/   # High-value guidance
│   ├── self-knowledge/   # [Planned] Claude self-understanding
│   └── external/         # Curated external resources
│
├── library/              # Deployable assets
│   ├── skills/           # Production-ready skills
│   ├── plugins/          # Plugins (official, community, local)
│   ├── configs/          # [Planned] Configuration templates
│   └── tools/            # Utility scripts
│
├── experimental/         # Work in progress
│   ├── skills/           # WIP skills
│   ├── plugins/          # WIP plugins
│   └── ideas/            # Ideas backlog
│
└── _workspace/           # Development (not end-user content)
    ├── planning/         # Architecture, vision
    ├── progress/         # Status tracking
    ├── backlog/          # Future work
    └── notes/            # Scratch space
```

## Design Philosophy

- **Progressive disclosure**: Each folder explains what's inside
- **Pointer-first**: Indexes to external sources; local copies only when valuable
- **Single source of truth**: CATALOG.md files are authoritative inventories
- **Self-contained**: Enter at any folder and understand context

## Status

This repository is under active development.

**Current Phase**: Foundation
**See**: `_workspace/progress/current-status.md`

## Contributing

Check `experimental/` for development work. See `_workspace/planning/repo-vision.md` for architectural context.

## Related

- Old repository: `/Users/danieleskenazi/Desktop/Repos/Claude Code Docs with External plug ins/`
- Official docs: https://code.claude.com
