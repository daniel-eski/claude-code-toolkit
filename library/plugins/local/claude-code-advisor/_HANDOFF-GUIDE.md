# Handoff Guide - How to Continue Development

> Instructions for Claude Code agents continuing work on this plugin.

---

## Before You Start

1. **Read `_PROJECT-CONTEXT.md` thoroughly** - Contains all research, decisions, and mental models
2. **Check `_PROGRESS.md`** - Shows current status and next actions
3. **Review `CLAUDE.md`** - Quality standards for this project

---

## Understanding the Project

You're continuing development of a Claude Code advisor plugin. A prior agent did extensive research on Claude Code's extensibility features (skills, subagents, hooks, memory, commands, MCP) and captured all insights in `_PROJECT-CONTEXT.md`.

**You don't need to re-research.** Trust the captured context. The research is comprehensive and includes:
- Official documentation from code.claude.com
- Platform documentation from platform.claude.com
- Engineering best practices from anthropic.com
- Community skill patterns

---

## Ramp-Up Reading by Task

### For Writing SKILL.md (Strategic Layer)

Read these sections in `_PROJECT-CONTEXT.md`:
- "Mental Models" - Has ASCII diagrams to adapt
- "Feature Relationship Map" - For the relationship overview
- "Key Research Insights" - For design principles
- "What Each Reference File Should Contain" - For navigation index

Read local source:
- `02-core-features/skills.md` (lines 1-150) - Skill structure and discovery

Optionally fetch for latest:
- `https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview`

**Target**: ~2500 tokens
**Focus**: Guide Claude, don't teach everything. Navigation to references is key.

### For Writing Reference Files

Read in `_PROJECT-CONTEXT.md`:
- "What Each Reference File Should Contain" - Describes each file's purpose
- "Key Research Insights" - For accurate content

Read the specific source docs listed for that file (see Source Documentation section).

**Target**: Token budgets in the file tree (800-1500 tokens each)
**Focus**: Extracted key concepts, not full copies

### For Writing Subagent Definitions

Read in `_PROJECT-CONTEXT.md`:
- "Subagent Coordination" - Orchestration patterns
- "Mental Models" - Subagent isolation concept

Template in `_PROJECT-CONTEXT.md` file tree shows the structure.

**Target**: ~500-600 tokens each
**Focus**: Clear purpose, specific tools, when to invoke

---

## Quality Checkpoints

Before finishing any file, verify:

- [ ] Content is grounded in official documentation (no speculation)
- [ ] Token budget is respected (check estimate in file tree)
- [ ] Cross-references to other files are correct paths
- [ ] Progressive disclosure principle maintained
- [ ] Third-person voice used throughout ("Processes X" not "I process X")
- [ ] Descriptions include "when to use" triggers

---

## Working with Subagents

When creating reference files, you can use subagents:

**Use Opus for complex synthesis:**
- context-architecture.md
- feature-interactions.md
- composition-patterns.md
- architecture-selection.md
- architecture-examples.md

**Use Sonnet for focused extraction:**
- Individual feature deep-dives
- Source documentation curation
- Decision guides
- Implementation guides

**Subagent context requirements:**
1. Provide the specific source doc(s)
2. Provide target file structure and token budget
3. Provide cross-reference list (what other files to link to)
4. Provide quality standards from this guide

**Max 2 subagents in parallel** for quality review.

---

## Updating Progress

After completing any file:

1. Edit `_PROGRESS.md`:
   - Change status: `⬜` → `✅`
   - Update "Last Updated" date
   - Update "Last Session Summary"
   - Add to "Session History" table

2. If issues encountered:
   - Add to "Known Issues" section
   - Note any blockers

3. Set clear next action for future agents

---

## If Context Is Filling Up

When your context window is getting full:

1. **Complete current file if possible** - Don't leave partial work

2. **Update `_PROGRESS.md`**:
   - Mark current file's status
   - Note any in-progress details
   - Set specific next action

3. **DO NOT modify `_PROJECT-CONTEXT.md`** - It's immutable

4. New agent will:
   - Read CLAUDE.md
   - Read _PROJECT-CONTEXT.md
   - Check _PROGRESS.md for where to pick up

---

## File Dependencies

Some files depend on others being complete first:

```
Phase 1: Foundation
└── SKILL.md (required first - defines navigation)

Phase 2-3: Can be done with SKILL.md complete
├── system-understanding/*
└── feature-mechanics/*

Phase 4-6: Can be done after Phase 3
├── decision-guides/*
├── patterns/*
└── implementation/*

Phase 7-9: Can be done in parallel with 4-6
├── source-documentation/*
├── agents/*
└── commands/*

Phase 10: Must be LAST
└── INDEX.md (links to all reference files)

Phase 11: Any time after core works
└── docs/*
```

---

## Common Mistakes to Avoid

1. **Don't re-research** - Trust _PROJECT-CONTEXT.md
2. **Don't exceed token budgets** - Check the file tree
3. **Don't use first-person** - "Processes" not "I process"
4. **Don't nest references deeply** - One level from SKILL.md
5. **Don't forget cross-references** - Include "See X for details"
6. **Don't skip _PROGRESS.md updates** - Future agents need this

---

## Getting Help

If you need current documentation:
- Use cc-understanding-verifier subagent (once agents are created)
- Fetch URLs listed in _PROJECT-CONTEXT.md "External URLs" section

If something is unclear:
- Ask the user for clarification
- Don't make assumptions about requirements

---

## Success Criteria

The plugin is successful when:
1. SKILL.md triggers on relevant questions ("Should I use a skill?")
2. Reference files load on-demand (progressive disclosure works)
3. Subagents spawn with correct configuration
4. Cross-references between files work
5. Token budgets are respected

Test by installing the plugin and asking:
- "Should I use a skill or subagent for code review?"
- "Analyze my current Claude Code setup"
- "Help me design a Claude Code configuration for my project"
