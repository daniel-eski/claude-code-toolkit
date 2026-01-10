# Skills Deep Dive

Skills teach Claude specialized capabilities through markdown files that load on-demand.

## Three-Level Loading Model

Skills use progressive disclosure to minimize context usage:

```
LEVEL 1: METADATA (Always loaded)
┌─────────────────────────────────────────────┐
│ name: my-skill                              │
│ description: Brief description...            │  ~100 tokens
│                                             │
│ Loaded at startup for ALL skills            │
│ Claude uses this to match requests          │
└─────────────────────────────────────────────┘
                    │
                    │ User request matches description
                    ▼
LEVEL 2: BODY (Loaded on trigger)
┌─────────────────────────────────────────────┐
│ Full SKILL.md content                       │
│ Instructions, guidance, workflows           │  <5k tokens
│                                             │  recommended
│ Only loads when skill activates             │
└─────────────────────────────────────────────┘
                    │
                    │ Claude reads reference files
                    ▼
LEVEL 3: RESOURCES (On-demand)
┌─────────────────────────────────────────────┐
│ references/*.md - Additional docs           │
│ scripts/*.py - Executable utilities         │
│ templates/* - Reusable templates            │
│                                             │  Unlimited
│ Only loaded when Claude reads them          │  (not in context
│ Scripts EXECUTED, not loaded into context   │   until needed)
└─────────────────────────────────────────────┘
```

## Skill File Structure

```yaml
---
name: skill-name
description: Third-person description with trigger keywords
allowed-tools: Tool1, Tool2  # Optional: restrict tools
model: claude-sonnet-4  # Optional: specific model
---

# Skill Name

## Instructions
Clear guidance for Claude...

## Additional Resources
- See [reference.md](reference.md) for details
- Run `python scripts/helper.py` for validation
```

## Required Fields

| Field | Required | Purpose |
|-------|----------|---------|
| `name` | Yes | Unique identifier (lowercase, hyphens, max 64 chars) |
| `description` | Yes | When to use (max 1024 chars) - CRITICAL for discovery |
| `allowed-tools` | No | Restrict available tools when skill is active |
| `model` | No | Force specific model |

## Discovery and Activation

Claude matches requests to skills via semantic similarity with descriptions.

**Good description**:
```yaml
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
```

**Bad description**:
```yaml
description: Helps with documents
```

## Skill Locations

| Location | Path | Scope |
|----------|------|-------|
| Enterprise | System managed settings | All org users |
| Personal | `~/.claude/skills/` | You, all projects |
| Project | `.claude/skills/` | Team via git |
| Plugin | `skills/` in plugin | Plugin users |

Higher rows override lower on name conflict.

## Progressive Disclosure Best Practices

1. **SKILL.md under 500 lines** - Essential content only
2. **References one level deep** - No nested chains (A→B→C)
3. **Scripts for execution** - Complex logic as scripts, not prose
4. **Link to references** - "See [details.md](details.md) for more"

## Tool Restrictions

```yaml
allowed-tools: Read, Grep, Glob
```

When active, Claude can ONLY use specified tools without permission. Useful for:
- Read-only skills
- Sandboxed operations
- Security-sensitive workflows

## Skills with Subagents

Subagents DON'T inherit skills from main conversation. Pre-load them:

```yaml
# .claude/agents/reviewer.md
---
name: code-reviewer
skills: security-check, style-guide
---
```

See also:
- `../decision-guides/skills-vs-subagents.md` for when to use each
- `../../SKILL.md` for navigation to all references
