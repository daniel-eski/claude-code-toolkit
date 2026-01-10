# Self-Knowledge

> Help Claude understand how it works internally.

## Purpose

This section provides curated content to help Claude Code agents understand:
- How context windows work and their limits
- How subagents are spawned and their constraints
- How tools execute and the permission model
- How memory systems (CLAUDE.md) work
- What Claude can and cannot do

## Why This Matters

When Claude understands its own mechanics, it can:
- Make better decisions about subagent deployment
- Manage context more effectively
- Avoid capability assumptions
- Work within constraints productively

## Content Approach

This section should contain:
- **Curated content** written specifically for Claude's self-understanding
- **Embedded references** to official docs for deeper reading
- **Practical guidance** on working within constraints

This is NOT just links to docs - it's synthesized knowledge.

## Files (Planned)

| File | Topic |
|------|-------|
| `context-management.md` | How context windows work, limits, strategies |
| `subagent-mechanics.md` | How subagents are spawned, constraints |
| `tool-execution.md` | How tools execute, permission model |
| `memory-systems.md` | CLAUDE.md, memory persistence |
| `capability-boundaries.md` | What Claude can/cannot do |

## Quality Standards

Content here must be:
- **Accurate** - Based on verified understanding of Claude's mechanics
- **Useful** - Actionable guidance, not just facts
- **Not prescriptive** - Context and principles, not rigid rules

## Sources to Research

- Official Claude Code docs (code.claude.com)
- Anthropic engineering blog
- Platform documentation (platform.claude.com)
- Claude model card and documentation

## Status

DEFERRED - This section requires deliberate, thoughtful development. See `_workspace/backlog/` for planning.
