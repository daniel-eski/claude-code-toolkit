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

## Files

| File | Status | Topic |
|------|--------|-------|
| `context-management.md` | ✅ Complete | How context windows work, limits, strategies |
| `subagent-mechanics.md` | ✅ Complete | How subagents are spawned, orchestration, constraints |
| `tool-execution.md` | ✅ Complete | How tools execute, permission model |
| `memory-systems.md` | ✅ Complete | CLAUDE.md, memory persistence |
| `capability-boundaries.md` | ✅ Complete | What Claude can/cannot do |

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

COMPLETE - All five self-knowledge documents finished with confidence framework applied.

All documents include:
- Front matter explaining document nature and confidence markers
- Inline `[verified]`, `[inferred]`, `[illustrative]` confidence markers
- "Sources and Confidence" appendix table

*Last updated: 2026-01-12*
