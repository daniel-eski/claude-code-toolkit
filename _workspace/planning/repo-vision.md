# Repository Vision

> **IMMUTABLE DOCUMENT** - This captures the foundational vision and decisions. Do not modify. For updates, create new decision records in `_workspace/decisions/`.

**Created**: 2026-01-09
**Source**: Planning session with user

---

## Purpose

This repository is a navigable knowledge base that helps Claude Code agents (and humans) find useful resources efficiently. It serves four core purposes:

1. **Curated toolkit** - Point any Claude Code agent toward verified, useful resources (skills, plugins, configs, docs)
2. **Development sandbox** - A place to test and develop new skills/plugins before they're production-ready
3. **Self-knowledge resource** - Help Claude understand itself better (how context works, how subagents deploy, etc.) with verified documentation
4. **Shareable** - Designed so the owner can share with friends who can also use and contribute

---

## Core Design Principles

### Progressive Disclosure
Every folder answers: "What's here and why would you want it?"
- Root level: Overview of everything available
- Second level: What's in this category
- Third level: How to use this specific thing

As you go deeper, content becomes more specific and actionable (similar to best practices for skill design).

### Navigation-First
This is fundamentally a multi-layered table of contents. The repo's main job is to help Claude Code find and use content effectively, whether that content lives locally or externally.

### Pointer-First
Default to indexes pointing to external sources. Only store content locally when:
- It's owned/developed by the user
- It's frequently referenced and benefits from offline access
- There's a specific reason local copies are valuable

### Single Source of Truth
- Navigation files (READMEs) don't duplicate each other
- CATALOG.md files are the authoritative source for inventories
- If content changes, update one place, not many

### Clear Separation of Concerns
- `docs/` = Documentation (indexes to official docs, best practices, external resources)
- `library/` = Deployable assets (skills, plugins, configs, tools)
- `experimental/` = Work in progress (mirrors library/ structure)
- `_workspace/` = Development process (not end-user content)

---

## Architecture

```
/
├── CLAUDE.md                     # Concise AI entry point (<100 lines)
├── README.md                     # Human overview
├── .claude/                      # Claude Code configuration
│
├── docs/                         # All documentation (indexes + pointers)
│   ├── claude-code/              # Official docs → code.claude.com
│   ├── best-practices/           # High-value guidance with summaries
│   ├── self-knowledge/           # [DEFERRED] Claude self-understanding
│   └── external/                 # Curated external resources
│
├── library/                      # Deployable assets
│   ├── skills/                   # Production-ready skills (by source)
│   ├── plugins/                  # Plugins (official/, community/, local/)
│   ├── configs/                  # [DEFERRED] Configuration templates
│   └── tools/                    # Utility scripts
│
├── experimental/                 # Work in progress
│   ├── skills/
│   ├── plugins/
│   └── ideas/
│
└── _workspace/                   # Development process
    ├── planning/                 # This file, architecture decisions
    ├── progress/                 # Status tracking, session logs
    ├── decisions/                # ADR-style records
    ├── backlog/                  # Future work items
    └── notes/                    # Scratch space
```

---

## Key Decisions

### 1. New Repo vs. Modify Existing
**Decision**: Create new repo alongside old one (do NOT replace)
**Rationale**: Clean architecture without legacy constraints; old repo remains as reference

### 2. Local Copies vs. Indexes
**Decision**: Index-first; consider local copies as deferred work
**Rationale**: Start simple; evaluate what's actually referenced frequently during use

### 3. Skills Organization
**Decision**: Keep current category/source-based folders; note potential reorganization as deferred
**Rationale**: Current organization works; enhancement can come after base is stable

### 4. Self-Knowledge Section
**Decision**: Defer for deliberate, thoughtful development
**Rationale**: This is important enough to do right, not rush

### 5. Purpose-Oriented Navigation
**Decision**: Defer until base content is in place
**Rationale**: Requires analysis of existing content to design well

---

## Content Sources

### From Old Repository
- `/Users/danieleskenazi/Desktop/Repos/Claude Code Docs with External plug ins/`
- 49 official docs in folders 01-10
- 32 working skills in 11-external-resources/core-skills/
- 2 plugins in 11-external-resources/plugins/
- 10 utility scripts in 11-external-resources/tools/
- 9 best practices docs in 12-best-practices/
- External links in 13-external-resources-guide/

### External Sources (For Indexes)
- Official Claude Code docs: https://code.claude.com
- Anthropic engineering blog: https://anthropic.com/engineering
- Platform docs: https://platform.claude.com
- Official plugins: https://github.com/anthropics/claude-code/plugins
- Official plugin marketplace: https://github.com/anthropics/claude-plugins-official

---

## User's Expressed Goals

From the planning session:

1. **Easy navigation** - Claude Code agents can find what they need efficiently
2. **Purpose-driven discovery** - Not just catalogs, but guidance for "if you want X, look at Y"
3. **Development support** - Place to test and develop new assets
4. **Self-contained context** - Each folder's documentation is comprehensive for agents entering at that point
5. **No prescriptive guidance** - Future agents are capable; give them context, not instructions
6. **Accuracy** - No misleading counts or outdated information
7. **Modularity** - Different agents can work on different sections independently

---

## Deferred Work Summary

These items require comprehensive context written in `_workspace/backlog/`:

1. **docs/self-knowledge/** - Claude self-understanding content
2. **Purpose-oriented navigation** - Intent-based discovery pathways
3. **library/configs/** - Configuration templates
4. **Additional local copies** - Frequently-referenced content
5. **Skills organization enhancement** - Beyond source-based grouping
6. **User's WIP assets** - Testing and integration of user's projects
7. **External resources expansion** - New skills/plugins from external sources
8. **Future ideas** - Personal commands, automation, etc.

---

## Agent Guidelines

### For Future Claude Code Agents

1. **Read `_workspace/progress/current-status.md` first** - Know where we are
2. **Use Opus for parallel subagents** - Quality and capability matter
3. **Provide targeted context** - Each subagent gets focused context, not everything
4. **Write self-contained documentation** - Context should work for agents entering at any folder
5. **Don't be prescriptive** - Future agents are as capable as you; give context, not instructions
6. **Update progress tracking** - Before ending session, update current-status.md

### Quality Standards

- No hardcoded stats (CATALOG.md is source of truth)
- No duplicate content across files
- Every folder reachable via navigation
- Links verified as working
- Placeholder content clearly marked

---

## Origin

This repository was created from a planning session on 2026-01-09. The full implementation plan is available at:
- `~/.claude/plans/quiet-drifting-dijkstra.md` (session plan file)
- Copied to `_workspace/planning/implementation-plan.md` for persistence

The old repository remains at:
- `/Users/danieleskenazi/Desktop/Repos/Claude Code Docs with External plug ins/`
