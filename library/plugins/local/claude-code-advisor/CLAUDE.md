# CLAUDE.md - Claude Code Advisor Plugin

> Instructions for Claude Code agents working on this plugin.

---

## Quick Orientation

This plugin helps Claude deeply understand its own Claude Code features (skills, subagents, hooks, memory, commands, MCP) and make informed architectural recommendations for users.

**If you're continuing development, read these files in order:**
1. `_PROJECT-CONTEXT.md` - Full project context and research (IMMUTABLE)
2. `_PROGRESS.md` - Current status and next steps (UPDATE THIS)
3. `_HANDOFF-GUIDE.md` - How to work effectively on this project

---

## Project Structure

```
claude-code-advisor/
├── _PROJECT-CONTEXT.md    # Immutable project context (read first)
├── _PROGRESS.md           # Dynamic progress tracking (update each session)
├── _HANDOFF-GUIDE.md      # Ramp-up instructions
├── CLAUDE.md              # This file
├── .claude-plugin/plugin.json
├── skills/claude-code-advisor/
│   ├── SKILL.md           # Main skill file (strategic layer)
│   └── references/        # On-demand reference files
├── agents/                # Subagent definitions
├── commands/              # Slash command definitions
└── docs/                  # Human documentation
```

---

## Development Workflow

1. **Check `_PROGRESS.md`** for current status and next actions
2. **Read relevant sections of `_PROJECT-CONTEXT.md`** for context needed
3. **Make changes** following the quality standards below
4. **Update `_PROGRESS.md`** before ending your session
5. **If context is filling up**, prepare for handoff (see _HANDOFF-GUIDE.md)

---

## Quality Standards

All files in this plugin must:

1. **Be grounded in official documentation** - No speculation or made-up features
2. **Respect token budgets** - See file tree in _PROJECT-CONTEXT.md for targets
3. **Use third-person voice** - "Processes PDFs" not "I process PDFs"
4. **Include cross-references** - "See references/X.md for details"
5. **Follow progressive disclosure** - SKILL.md → references → subagents
6. **Test before finalizing** - Verify references load correctly

---

## Key Files

| File | Purpose | When to Read |
|------|---------|--------------|
| `_PROJECT-CONTEXT.md` | All research, decisions, mental models | Before any work |
| `_PROGRESS.md` | Status, next actions | To know where to pick up |
| `_HANDOFF-GUIDE.md` | How to ramp up, quality checks | When starting |
| `skills/claude-code-advisor/SKILL.md` | Main skill file | When implementing |

---

## Source Documentation

**Local sources** are in the parent repository at:
- `02-core-features/` - skills.md, subagents.md, hooks.md, memory.md, etc.
- `07-plugins/` - plugins.md, plugins-reference.md

**External sources** (fetch when needed):
- `https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview`
- `https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices`
- `https://www.anthropic.com/engineering/claude-code-best-practices`

See `_PROJECT-CONTEXT.md` for full source mapping and key excerpts.

---

## Subagent Usage

When creating reference files, you can dispatch subagents:

- **Opus**: For complex synthesis (context-architecture.md, composition-patterns.md)
- **Sonnet**: For focused extraction (feature deep-dives, source curation)

**Max 2 subagents in parallel** for quality review.

See `_HANDOFF-GUIDE.md` for detailed subagent guidelines.

---

## Common Commands

```bash
# Verify plugin structure
ls -la .claude-plugin/
ls -la skills/claude-code-advisor/

# Check progress
cat _PROGRESS.md

# Read specific source docs
cat ../../02-core-features/skills.md | head -200
```

---

## Notes

- **DO NOT modify `_PROJECT-CONTEXT.md`** - It's immutable
- **DO update `_PROGRESS.md`** after each session
- **Token budgets are important** - Don't exceed them
- **All research is already done** - Trust _PROJECT-CONTEXT.md
