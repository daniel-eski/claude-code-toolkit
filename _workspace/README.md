# Development Workspace

> Development process files. NOT end-user content.

## Purpose

This folder contains:
- Architecture and planning documents
- Progress tracking for multi-session work
- Decision records
- Backlog of future work
- Scratch notes

**For AI agents**: This is where you track work and handoff context.
**For end users**: You can ignore this folder unless contributing to development.

## What's Here

| Folder | Purpose | How to Use |
|--------|---------|------------|
| `planning/` | Vision, architecture | Read `repo-vision.md` for context |
| `progress/` | Status, session logs | Read `current-status.md` first |
| `backlog/` | Future work items | Deferred tasks with context |
| `assessments/` | Audit reports | Historical reference from reviews |
| `archive/` | Completed artifacts | PR materials, session plans |

## For Agents Continuing Work

1. **Read first**: `progress/current-status.md`
2. **Understand vision**: `planning/repo-vision.md`
3. **Check backlog**: `backlog/` for deferred work context
4. **Update before ending**: Always update `current-status.md`

## Key Files

| File | Type | Purpose |
|------|------|---------|
| `planning/repo-vision.md` | IMMUTABLE | Foundational vision, don't modify |
| `progress/current-status.md` | DYNAMIC | Update each session |
| `progress/session-logs/` | APPEND-ONLY | One file per session |
| `backlog/*.md` | REFERENCE | Context for deferred work |

## Status

ACTIVE - This folder is actively used for development tracking.
