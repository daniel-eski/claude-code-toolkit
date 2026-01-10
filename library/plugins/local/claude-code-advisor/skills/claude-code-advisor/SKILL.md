---
name: claude-code-advisor
description: Provides deep understanding of Claude Code features (skills, subagents, hooks, memory, commands, MCP) and guides architectural decisions. Use when asked about Claude Code setup, feature selection, configuration design, or when comparing skills vs subagents vs hooks.
---

# Claude Code Advisor

Helps Claude understand its own extensibility features and make informed architectural recommendations for user projects.

## Claude Code as a System

```
┌─────────────────────────────────────────────────────────────────┐
│                    MAIN CONTEXT WINDOW                          │
│        (Shared resource - everything competes for space)        │
│                                                                 │
│  ┌────────────┐  ┌────────────┐  ┌────────────────┐            │
│  │ System     │  │ CLAUDE.md  │  │ Conversation   │            │
│  │ Prompt     │  │ (always)   │  │ History        │            │
│  └────────────┘  └────────────┘  └────────────────┘            │
│  ┌────────────┐  ┌────────────┐  ┌────────────────┐            │
│  │ Skill      │  │ Active     │  │ Path Rules     │            │
│  │ Metadata   │  │ Skill Body │  │ (when matched) │            │
│  │ (all)      │  │ (triggered)│  │                │            │
│  └────────────┘  └────────────┘  └────────────────┘            │
└─────────────────────────────────────────────────────────────────┘
                              │
    ┌─────────────────────────┼─────────────────────────┐
    │                         │                         │
    ▼                         ▼                         ▼
┌─────────┐            ┌─────────────┐           ┌─────────────┐
│SUBAGENTS│            │   HOOKS     │           │ MCP SERVERS │
│(isolated│            │(event-based)│           │(external    │
│context) │            │PreToolUse   │           │tools)       │
└─────────┘            │PostToolUse  │           └─────────────┘
                       └─────────────┘
```

**Critical insight**: The main context window is shared. CLAUDE.md and all skill metadata are always present. Subagents have ISOLATED context - this is the key differentiator.

## Feature Quick Reference

| Feature | Context | Trigger | Best For |
|---------|---------|---------|----------|
| **CLAUDE.md** | Always loaded | Every session | Project standards, always-needed rules |
| **Skills** | On-demand body | Model matches description | Domain expertise, specialized workflows |
| **Subagents** | Isolated | Model/user invokes | Heavy processing, parallel work |
| **Hooks** | Outside context | Events (tool use) | Automation, guardrails, validation |
| **Commands** | Shared | User types `/cmd` | Explicit user-triggered actions |
| **MCP** | Tool availability | Model calls tool | External tools, data sources |

## Core Design Principles

1. **Context window is precious** - CLAUDE.md loads every session; skills load on trigger; subagents get fresh context
2. **Progressive disclosure** - Put essentials in SKILL.md, details in references/, heavy work in subagents
3. **Isolation for heavy lifting** - Subagents don't pollute main context; use them for large tasks
4. **Composition over monoliths** - Combine features (skill + subagent, hook + subagent) for complex behavior
5. **Explicit over implicit** - Clear descriptions, obvious triggers, predictable behavior

## Decision Shortcuts

**"Should I put this in CLAUDE.md or a skill?"**
- Ask: "Does Claude need this every session?" Yes → CLAUDE.md. No → Skill.

**"Should I use a skill or subagent?"**
- Skill: Claude needs knowledge/guidance IN the conversation
- Subagent: Claude needs to do work WITHOUT polluting context

**"Should I use a skill or slash command?"**
- Skill: Claude should auto-detect when relevant
- Command: User explicitly triggers with `/command`

**"Should I use a hook?"**
- For automatic validation/enforcement on tool events
- Keep hook logic lightweight; spawn subagent for complex work

See `references/decision-guides/` for detailed comparison matrices.

## When to Invoke Specialized Subagents

### Research & Verification
- **cc-understanding-verifier**: Quick fact-check of single claims (fast, haiku)
- **cc-deep-researcher**: Comprehensive topic research (thorough, sonnet)

### Analysis
- **cc-config-analyzer**: Review existing Claude Code setup
- **cc-troubleshooter**: Debug why configurations aren't working
- **cc-pattern-matcher**: Quick match to known patterns (fast, haiku)

### Design & Generation
- **cc-architecture-designer**: After requirements gathered, design configuration
- **cc-skill-generator**: Generate SKILL.md files (complex, specialized)
- **cc-agent-generator**: Generate agent definitions (model/tool expertise)
- **cc-config-generator**: Generate commands, hooks, CLAUDE.md, MCP

### Review
- **cc-implementation-reviewer**: Before deployment, validate quality

**Coordination flow**:
1. Pattern match to identify approach (quick)
2. Verify understanding if uncertain (quick)
3. Analyze existing setup if present
4. Design architecture
5. USER APPROVAL CHECKPOINT
6. Generate files (skill → agent → config)
7. Review implementation

## Navigation Index

Load reference files based on what you need:

| When You Need To... | Read This |
|---------------------|-----------|
| Understand context window mechanics | `references/system-understanding/context-architecture.md` |
| Understand the agentic execution loop | `references/system-understanding/execution-model.md` |
| See how features interact | `references/system-understanding/feature-interactions.md` |
| Deep dive on skills mechanics | `references/feature-mechanics/skills-deep-dive.md` |
| Deep dive on subagents mechanics | `references/feature-mechanics/subagents-deep-dive.md` |
| Deep dive on hooks mechanics | `references/feature-mechanics/hooks-deep-dive.md` |
| Deep dive on memory/CLAUDE.md | `references/feature-mechanics/memory-deep-dive.md` |
| Deep dive on slash commands | `references/feature-mechanics/commands-deep-dive.md` |
| Deep dive on MCP servers | `references/feature-mechanics/mcp-deep-dive.md` |
| Choose between skills vs subagents | `references/decision-guides/skills-vs-subagents.md` |
| Choose between skills vs commands | `references/decision-guides/skills-vs-commands.md` |
| Choose between memory vs skills | `references/decision-guides/memory-vs-skills.md` |
| Decide when to use hooks | `references/decision-guides/hooks-usage-guide.md` |
| Full architecture decision flowchart | `references/decision-guides/architecture-selection.md` |
| See feature composition patterns | `references/patterns/composition-patterns.md` |
| Avoid common mistakes | `references/patterns/anti-patterns.md` |
| Learn recommended workflows | `references/patterns/workflow-patterns.md` |
| See real-world examples | `references/patterns/architecture-examples.md` |
| Write a skill | `references/implementation/skill-authoring.md` |
| Design a subagent | `references/implementation/subagent-design.md` |
| Implement a hook | `references/implementation/hook-implementation.md` |
| Structure a plugin | `references/implementation/plugin-structure.md` |

## Common Anti-Patterns

Avoid these mistakes when designing Claude Code configurations:

1. **Monolithic CLAUDE.md** - Everything in CLAUDE.md bloats every session
2. **Skills for simple triggers** - Use slash commands for explicit user actions
3. **Subagents for knowledge sharing** - Subagent context doesn't flow back; use skills for knowledge
4. **Everything in one skill** - Separate by domain, use clear descriptions
5. **Complex hook logic** - Hooks should be lightweight; spawn subagent for complex work
6. **Blind file generation** - Verify understanding first, use templates
7. **Deeply nested references** - Keep references one level deep from SKILL.md

See `references/patterns/anti-patterns.md` for detailed explanations and fixes.

## Verification Prompts

Before finalizing any Claude Code configuration, ask:

- [ ] Is CLAUDE.md limited to always-needed content?
- [ ] Do skill descriptions include clear triggers?
- [ ] Are heavy tasks delegated to subagents?
- [ ] Do hooks spawn subagents for complex logic?
- [ ] Is the configuration testable?
- [ ] Are all features grounded in official documentation?
