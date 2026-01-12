# Workflow Optimizer Plugin

## Overview

This is a Claude Code plugin with three loosely-coupled skills:
1. **prompt-optimizer** — Clarify objectives before task execution
2. **planning-with-files** — Establish persistent context for extended work
3. **agent-architect** — Design Claude Code configuration based on context

## Project Structure

```
├── skills/
│   ├── prompt-optimizer/        # Task understanding
│   │   ├── SKILL.md
│   │   └── COMPLEXITY-GUIDE.md
│   ├── planning-with-files/     # Context management (Manus principles)
│   │   ├── SKILL.md
│   │   ├── reference.md
│   │   ├── examples.md
│   │   └── templates/
│   └── agent-architect/         # Configuration design
│       ├── SKILL.md
│       ├── references/          # Comprehensive syntax docs
│       └── templates/
│           ├── agents/          # Agent templates by category
│           ├── CLAUDE-TEMPLATES.md
│           └── HOOK-TEMPLATES.md
├── commands/
│   ├── optimize.md
│   ├── plan-files.md
│   └── architect.md
├── README.md                    # User documentation
├── PHILOSOPHY.md                # Design rationale
└── .claude-plugin/plugin.json
```

## Key Design Principles

1. **Workflow over reference** — Skills make decisions, not just provide information
2. **Loose coupling** — Each skill works independently but chains naturally
3. **Progressive disclosure** — Essential in SKILL.md, details in supporting files
4. **Context-informed design** — Architecture built for specific, understood tasks

## When Modifying

### prompt-optimizer
- Keep platform-agnostic (no Claude Code-specific config)
- Focus on task understanding and alignment
- Reference other skills for next steps, don't do their work

### planning-with-files
- Based on Manus context engineering principles
- Core rules: 2-Action Rule, Read Before Decide, 3-Strike Error Protocol
- Templates in templates/ directory

### agent-architect
- Should detect and use planning files when present
- Must read reference files before making recommendations
- Provides complete, ready-to-use configuration

## Commands

- `/workflow-optimizer:optimize` — Run prompt optimization
- `/workflow-optimizer:plan-files` — Set up planning files
- `/workflow-optimizer:architect` — Design agent architecture

## Testing

Test each skill independently AND in the full workflow sequence.
Verify loose coupling: each skill should work without the others.
