---
name: agent-architect
description: Design optimal Claude Code agent architecture (CLAUDE.md, subagents, hooks, skills, settings, MCP) based on project context. Use when setting up a new project, designing agent systems for complex tasks, optimizing workflow configuration, or when user asks about subagents, hooks, skills, settings, or MCP servers. Most powerful when used after establishing context with planning-with-files.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash(ls:*), Bash(cat:*)
---

# Agent Architect

Design optimal Claude Code agent architecture tailored to your specific project and task context.

## What This Skill Does

This skill **architects** agent systems—it doesn't just provide syntax reference. Given your project context, it designs:

- **CLAUDE.md** — Persistent memory tailored to your project
- **Subagents** — Specialized agents for different phases of your work
- **Hooks** — Automation triggered by events (edits, commits, etc.)
- **Skills** — Reusable capabilities for recurring tasks
- **Settings** — Permissions, sandbox, environment configuration
- **MCP Servers** — External tool integrations (GitHub, databases, APIs)

## When to Use This Skill

**Ideal use:** After establishing project context with `planning-with-files`

When planning files exist (`task_plan.md`, `findings.md`), this skill reads them to design architecture specifically optimized for your task phases, discoveries, and decisions.

**Standalone use:** Can also assess any project and recommend architecture, but recommendations are more generic without established context.

**Trigger phrases:**
- "Design my agent architecture"
- "Set up Claude Code for this project"
- "Help me configure subagents/hooks/skills"
- "Optimize my workflow"
- "What agents should I create?"

## The Architecture Design Process

### Step 1: Assess Context

First, I check for existing context:

```bash
# Check for planning files (from planning-with-files skill)
ls task_plan.md findings.md progress.md 2>/dev/null

# Check existing Claude Code configuration
ls -la .claude/ 2>/dev/null
cat CLAUDE.md 2>/dev/null
cat .claude/settings.json 2>/dev/null
ls .claude/agents/ 2>/dev/null
```

**If planning files exist:** I read them to understand your task phases, findings, and decisions. Architecture will be tailored to these specifics.

**If no planning files:** I assess the project structure and ask clarifying questions about your workflow.

### Step 2: Identify Architecture Needs

Based on context, I determine what you need:

| Your Situation | Recommended Architecture |
|----------------|-------------------------|
| Multi-phase complex task | Subagents for each phase |
| Recurring specialized work | Custom skill |
| Need automation on edits/commits | Hooks |
| Project-specific knowledge | CLAUDE.md |
| Permission restrictions needed | Settings |
| External tool access needed | MCP servers |

### Step 3: Design Tailored Architecture

For each component, I provide:
- **What:** Complete, ready-to-use configuration
- **Why:** How it addresses your specific needs
- **Where:** Exact file path
- **Integration:** How components work together

### Step 4: Provide Implementation

Complete files with:
- Correct syntax (validated against current Claude Code specs)
- Comments explaining purpose
- Integration points between components

## Decision Framework

Use this to determine what to architect:

```
What do you need?
│
├─► Isolated context for specialized task?
│   └─► SUBAGENT
│       When: Debugging, code review, research, testing
│       Why: Separate context window, can use different model
│
├─► Persistent project knowledge?
│   └─► CLAUDE.md
│       When: Conventions, commands, architecture notes
│       Why: Loaded every session, shared with team
│
├─► Automatic action on events?
│   └─► HOOK
│       When: Auto-format, auto-lint, validation, logging
│       Why: Deterministic, always runs
│
├─► Reusable knowledge/process?
│   └─► SKILL
│       When: Recurring specialized capability
│       Why: Auto-discovered, progressive disclosure
│
├─► Permission control?
│   └─► SETTINGS
│       When: Restrict commands, protect files, sandbox
│       Why: Enforced security boundaries
│
└─► External tool access?
    └─► MCP SERVER
        When: GitHub, databases, APIs, custom tools
        Why: Extends Claude's capabilities
```

## Architecture Patterns

### Pattern 1: Phase-Based Subagents

When your task has distinct phases (from task_plan.md), create specialized subagents:

```
task_plan.md phases:
- Phase 1: Research existing system
- Phase 2: Design solution
- Phase 3: Implement changes
- Phase 4: Test and verify

Recommended architecture:
├── .claude/agents/researcher.md    (Phase 1)
├── .claude/agents/implementer.md   (Phases 2-3)
├── .claude/agents/tester.md        (Phase 4)
└── CLAUDE.md (shared context from findings.md)
```

### Pattern 2: Workflow Automation

When you have repetitive actions, automate with hooks:

```
Workflow need: Auto-format and lint after every edit

Architecture:
└── .claude/settings.json
    └── hooks:
        └── PostToolUse (Edit|Write)
            ├── prettier --write
            └── eslint --fix
```

### Pattern 3: Team Standardization

When sharing configuration with a team:

```
Architecture:
├── .claude/settings.json      (shared permissions)
├── .claude/CLAUDE.md          (shared context)
├── .claude/agents/*.md        (shared subagents)
├── .claude/rules/*.md         (path-specific rules)
└── .mcp.json                  (shared MCP servers)

All committed to git for team access.
```

### Pattern 4: Security-First Setup

When working with sensitive systems:

```
Architecture:
└── .claude/settings.json
    ├── permissions:
    │   ├── deny: [".env*", "secrets/*", "credentials/*"]
    │   └── ask: ["Bash(git push:*)"]
    └── sandbox:
        └── enabled: true
```

## Output Format

When I design architecture, I provide:

```
## Agent Architecture Design

### Context Assessment
[What I learned from planning files or project structure]

### Architecture Overview
[Diagram or summary of recommended components]

### Components

#### 1. CLAUDE.md
**Purpose:** [Why this is needed]
**Location:** `CLAUDE.md`

```markdown
[Complete file contents]
```

#### 2. Subagent: [name]
**Purpose:** [What this agent does]
**Location:** `.claude/agents/[name].md`

```markdown
[Complete file contents]
```

#### 3. Hooks
**Purpose:** [What these automate]
**Location:** `.claude/settings.json`

```json
[Complete configuration]
```

[Additional components as needed...]

### Implementation Steps
1. [Step-by-step instructions]
2. [Including any CLI commands]
3. Restart Claude Code

### Verification
- [How to verify each component works]
```

## Integration with Workflow

This skill is part of the workflow-optimizer plugin:

1. **prompt-optimizer** — Clarify objectives first
2. **planning-with-files** — Establish persistent context
3. **agent-architect** (this skill) — Design architecture informed by context

The workflow ensures you don't design tooling in a vacuum. Architecture is most effective when it's built for a specific, well-understood task.

## Reference Documentation

For comprehensive syntax and all options:

- [references/SKILLS.md](references/SKILLS.md) — Skills configuration
- [references/SUBAGENTS.md](references/SUBAGENTS.md) — Subagent configuration
- [references/HOOKS.md](references/HOOKS.md) — Hook events and syntax
- [references/MEMORY.md](references/MEMORY.md) — CLAUDE.md and rules
- [references/SETTINGS.md](references/SETTINGS.md) — Settings and permissions
- [references/MCP.md](references/MCP.md) — MCP server integration

## Templates

For quick-start configurations:

- [templates/agents/](templates/agents/) — Subagent templates by category:
  - [development/](templates/agents/development/) — debugger, test-runner, implementer
  - [review/](templates/agents/review/) — code-reviewer, security-auditor
  - [research/](templates/agents/research/) — researcher
  - [non-coding/](templates/agents/non-coding/) — documentation-writer, project-manager, technical-writer
  - [orchestration/](templates/agents/orchestration/) — multi-agent patterns
- [templates/CLAUDE-TEMPLATES.md](templates/CLAUDE-TEMPLATES.md) — CLAUDE.md templates
- [templates/HOOK-TEMPLATES.md](templates/HOOK-TEMPLATES.md) — Common hook patterns

## What This Skill Does NOT Do

- **Plan your task** — Use `prompt-optimizer` for that
- **Establish persistent context** — Use `planning-with-files` for that
- **Execute your task** — Architecture is setup, not execution

This skill designs the agent system. The actual work happens after.
