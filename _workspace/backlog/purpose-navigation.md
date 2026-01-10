# Backlog: Purpose-Oriented Navigation

> Beyond catalogs, create navigation that helps agents find what they really need based on intent.

---

## Goal

Create navigation systems that guide users and Claude Code agents to the right resources based on **what they're trying to accomplish**, not just what's available.

## Why This Matters

Current catalog-based organization (CATALOG.md, folder structure) answers: "What's here?"

Purpose-oriented navigation answers: "What should I use for X?"

This is especially valuable when:
- Users don't know exactly what they're looking for
- There are multiple related resources
- Context matters for choosing between options

## Examples of Intent-Based Pathways

### For Documentation
- "I want to understand how subagents work" → Read X, then Y, then Z
- "I need to debug context issues" → Check these specific docs/skills
- "I want to build a multi-agent system" → Curated reading path

### For Skills
- "I want to improve my git workflow" → These skills work well together
- "I need to create documentation" → Comparison of doc-related skills
- "I want to plan and execute projects" → Workflow skill combinations

### For Plugins
- "I want better code review" → Compare these options
- "I need safety guards" → Here's what's available and why
- "I want context visibility" → These plugins help

## How This Differs from Current Organization

| Current | Purpose-Oriented |
|---------|------------------|
| Lists what exists | Guides to what's useful |
| Organized by source/type | Organized by goal |
| Requires user to know what they need | Helps users discover needs |
| Static catalogs | Dynamic recommendations |

## Suggested Implementation Approach

1. **Analyze existing content** - What resources exist? How do they relate?
2. **Identify common intents** - What do users typically want to accomplish?
3. **Map resources to intents** - Which resources serve which goals?
4. **Create pathway documents** - "I want to X" → curated resource list with context
5. **Add to navigation** - Link from main READMEs

## Where to Put This

Options:
- Top-level `guides/` folder with intent-based pathways
- Sections in existing READMEs ("When to use what")
- Cross-cutting navigation file at root

## Dependencies

- Base content migration should be complete first
- Requires analysis of skills, plugins, docs to create mappings

## Quality Standards

Purpose navigation should be:
- Genuinely helpful, not just re-organized lists
- Based on understanding of what resources actually do
- Updated when resources change
- Not prescriptive - offer options with context, not single answers

## Connection to Other Deferred Work

- Related to `skills-organization.md` - both enhance discoverability
- Could incorporate insights from `docs/self-knowledge/` once developed
- Should inform how we document `external-expansion.md` resources

---

## Status

COMPLETED - 2026-01-09

### Implementation Summary

Created `guides/` folder with 9 files:
- `README.md` - Navigation hub with quick selector
- `start-feature.md` - Starting new work
- `debug-problems.md` - Debugging and fixing
- `improve-quality.md` - Code review and quality
- `git-workflow.md` - Git/GitHub workflows
- `create-documents.md` - Document generation
- `learn-claude-code.md` - Learning resources
- `extend-claude-code.md` - Building extensions
- `orchestrate-work.md` - Complex coordination

Updated navigation in:
- `CLAUDE.md` - Added "Navigation by Intent" section
- `README.md` - Added intent-based quick start
- `library/README.md` - Added guides cross-reference
