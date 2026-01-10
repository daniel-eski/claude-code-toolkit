# Claude Code Workflow Optimization Kit

A set of configurations that enhance Claude Code's meta-cognitive capabilities—making it think before acting, seek alignment on ambiguous tasks, and continuously improve workflows through structured reflection.

---

## The Problem

Claude Code is powerful out of the box, but its default behavior has a gap: **when you give it a short or ambiguous prompt, it tends to dive straight into execution.** This can lead to:

- **Misaligned work**: Claude interprets your intent differently than you meant
- **Wasted context**: Deep exploration in the wrong direction before course-correcting
- **Missed optimizations**: No systematic way to capture learnings and improve future workflows
- **Repeated friction**: The same inefficiencies occur across similar tasks

### Example of the Problem

```
You: improve the authentication
Claude: [Immediately starts modifying files, possibly in ways you didn't intend]
```

What you probably wanted was for Claude to first ask: *"What aspect of authentication? Security? UX? Performance? Are there specific issues?"*

---

## The Solution

This kit implements a **three-layer system** that shapes Claude's behavior:

```
┌─────────────────────────────────────────────────────────────┐
│  Layer 3: EXPLICIT INVOCATION                               │
│  /kickoff, /reflect commands                                │
│  You trigger structured planning or reflection on demand    │
├─────────────────────────────────────────────────────────────┤
│  Layer 2: AUTO-INVOKED CAPABILITIES                         │
│  workflow-reflection skill                                  │
│  Claude automatically uses when context matches             │
├─────────────────────────────────────────────────────────────┤
│  Layer 1: FOUNDATIONAL BEHAVIOR (Always Active)             │
│  CLAUDE.md instructions                                     │
│  Shapes every interaction without explicit invocation       │
└─────────────────────────────────────────────────────────────┘
```

### After Installing

```
You: improve the authentication

Claude: Let me make sure I understand. You want to improve the authentication system.

        Before I explore, I have some questions:
        - What aspect: security, UX, performance, or something else?
        - Are there known issues you want addressed?
        - Any constraints I should know about?
```

---

## What's Included

| Component | File | Purpose |
|-----------|------|---------|
| **CLAUDE.md** | `config/CLAUDE.md` | Core behavioral instructions with @import |
| **Modular rules** | `config/rules/*.md` | Path-specific and topic-specific rules |
| **workflow-reflection skill** | `config/skills/workflow-reflection/` | Post-task optimization analysis (3 files) |
| **/kickoff command** | `config/commands/kickoff.md` | Explicit structured planning |
| **/reflect command** | `config/commands/reflect.md` | Explicit reflection trigger |

---

## Quick Start

### Option 1: Automated Install (Recommended)

```bash
cd workflow-optimization-kit
chmod +x install.sh
./install.sh
```

Then restart Claude Code.

### Option 2: Manual Install

```bash
# Create directories
mkdir -p ~/.claude/skills/workflow-reflection
mkdir -p ~/.claude/commands
mkdir -p ~/.claude/rules

# Copy files
cp config/CLAUDE.md ~/.claude/CLAUDE.md
cp config/rules/*.md ~/.claude/rules/
cp config/skills/workflow-reflection/*.md ~/.claude/skills/workflow-reflection/
cp config/commands/*.md ~/.claude/commands/
```

Then restart Claude Code.

### Verify Installation

After restarting:

```bash
# Test 1: Ambiguous prompt triggers planning
> improve the code
# Expected: Claude asks for clarification instead of acting

# Test 2: Skill is loaded
> What skills are available?
# Expected: workflow-reflection in list

# Test 3: Commands are available
> /help
# Expected: kickoff and reflect with (user) tag
```

---

## Usage Guide

### Quick Reference

| Situation | What to Do |
|-----------|------------|
| Simple, clear task | Just ask normally → Claude proceeds directly |
| Ambiguous task | Just ask normally → Claude auto-triggers planning |
| Complex task, want guaranteed planning | `/kickoff [task description]` |
| After completing significant work | Say "let's reflect" or `/reflect` |
| Want focused reflection | `/reflect [specific aspect]` |

### The /kickoff Command

Use for guaranteed structured planning before complex tasks:

```
/kickoff migrate the database from MySQL to PostgreSQL
```

Claude will:
1. Restate understanding of the task
2. Assess available context vs. unknowns
3. Present 2-3 approach options with tradeoffs
4. Identify risks and concerns
5. Wait for your explicit approval

### The /reflect Command

Use after completing work to capture optimizations:

```
/reflect                           # Full session reflection
/reflect the debugging process     # Focused reflection
```

Claude will analyze:
- What was accomplished
- What worked well
- Friction points encountered
- **Concrete optimization recommendations** with exact implementation code

---

## How It Works

### Layer 1: CLAUDE.md (Always Active)

The `CLAUDE.md` file is loaded automatically at every session start. It configures Claude to:

- **Detect ambiguous prompts** (short, lacking specifics)
- **Restate understanding** before exploring
- **Identify unknowns** and ask clarifying questions
- **Propose multiple approaches** with tradeoffs
- **Seek alignment** before major work
- **Offer reflection** after significant tasks

**Exception handling**: Simple, unambiguous requests bypass the planning protocol—Claude proceeds directly.

### Layer 2: workflow-reflection Skill (Auto-Invoked)

Skills are automatically invoked when conversation context matches their description. The workflow-reflection skill triggers on phrases like:

- "reflect on what we did"
- "how can we improve this workflow"
- "optimize for next time"
- "what would help in the future"

It produces structured analysis with **deployable configurations**:
- CLAUDE.md additions
- New custom commands
- New custom skills
- Automation hooks

### Layer 3: Commands (Explicit Invocation)

`/kickoff` and `/reflect` provide on-demand access to planning and reflection when you want guaranteed behavior regardless of how you phrase things.

---

## Design Philosophy

### Why This Architecture?

| Design Choice | Rationale |
|---------------|-----------|
| **CLAUDE.md for behavioral shaping** | Always active, no context window overhead, no explicit invocation needed |
| **Skills for complex capabilities** | Auto-invoke when relevant, structured output format |
| **Commands for guaranteed access** | Explicit control when you want specific behavior |
| **Post-task reflection (not pre-task speculation)** | Optimizations grounded in real experience beat predictions |

### Why Lightweight Defaults?

We considered elaborate multi-step meta-planning workflows but rejected them:

1. **Planning overhead can exceed task effort** for many requests
2. **Plans are hypotheses**—you can't truly validate until execution
3. **Iteration beats prediction**—quick execution → reflection → improvement

The system is **lightweight by default** (behavioral nudges) with **heavier tools on demand** (/kickoff for complex tasks).

---

## Customization

### Project-Specific Instructions

Create `.claude/CLAUDE.md` in any project:

```markdown
# Project: MyApp

## Tech Stack
- React 18 / TypeScript / Node.js / PostgreSQL

## Conventions
- Functional components with hooks
- REST API, kebab-case endpoints
- All new code requires tests

## Key Commands
- npm run dev / npm test / npm run db:migrate
```

### Custom Commands

Create `.claude/commands/[name].md`:

```markdown
---
description: What this command does
argument-hint: [expected arguments]
---

Your prompt content.
$ARGUMENTS
```

### Custom Skills

Create `.claude/skills/[name]/SKILL.md`:

```markdown
---
name: skill-name
description: When to use (include trigger phrases users might say)
---

Instructions for Claude when this skill is active.
```

---

## Troubleshooting

| Problem | Likely Cause | Solution |
|---------|--------------|----------|
| Planning not triggering | CLAUDE.md not loaded | Verify file exists: `cat ~/.claude/CLAUDE.md`, restart Claude |
| Skill not in list | Wrong location or syntax | Check path and YAML frontmatter |
| Commands not in /help | Wrong location or extension | Must be `~/.claude/commands/*.md` |

**Debug mode**: Run `claude --debug` to see loading information.

See `docs/TECHNICAL_REFERENCE.md` for comprehensive troubleshooting and verification tests.

---

## Package Contents

```
workflow-optimization-kit/
├── README.md                          # This file
├── install.sh                         # Automated installation script
├── config/
│   ├── CLAUDE.md                      # Foundational behavior with @import
│   ├── rules/
│   │   ├── planning.md                # Planning protocol (imported by CLAUDE.md)
│   │   └── typescript.md              # Example path-specific rule
│   ├── commands/
│   │   ├── kickoff.md                 # /kickoff command (positional args)
│   │   └── reflect.md                 # /reflect command (git context)
│   └── skills/
│       └── workflow-reflection/
│           ├── SKILL.md               # Main skill (third-person, allowed-tools)
│           ├── reference.md           # Optimization type documentation
│           └── examples.md            # Concrete before/after scenarios
├── docs/
│   └── TECHNICAL_REFERENCE.md         # Detailed reference & verification tests
└── examples/
    ├── project-claude-md.md           # Example project-specific CLAUDE.md
    └── custom-command-template.md     # Template for custom commands
```

---

## Best Practices Applied

This kit follows Claude Code best practices from official documentation:

| Practice | Implementation |
|----------|----------------|
| **Third-person skill descriptions** | "Analyzes completed work..." not "Use when..." |
| **Progressive disclosure** | SKILL.md ~70 lines, details in reference.md/examples.md |
| **allowed-tools restrictions** | Skills limited to Read, Glob, Grep |
| **Structured bullets** | CLAUDE.md uses bullets not prose paragraphs |
| **@import syntax** | Modular rules imported into CLAUDE.md |
| **Path-specific rules** | `rules/typescript.md` with `paths:` frontmatter |
| **Git context capture** | `/reflect` uses `!git status` for session context |
| **Positional arguments** | `/kickoff` supports `$1` and `$2` for structured input |

---

## Background & Motivation

This kit emerged from exploring how to maximize Claude Code's effectiveness through meta-cognitive optimization.

**Core insight**: Claude Code's default behavior is optimized for clear, well-specified tasks. But real-world usage involves ambiguous prompts, complex multi-step work, and repeated similar tasks. A small amount of behavioral shaping creates disproportionate improvements in alignment and efficiency.

**Design priorities**:
- Lightweight defaults (behavioral nudges, not heavyweight processes)
- On-demand depth (heavier tools available when needed)
- Continuous improvement (systematic reflection → actionable optimizations)
- Practicality over perfection (working solutions now)

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-01-06 | Initial release |

---

## License

MIT License - Use freely, modify as needed, share improvements.

---

## Contributing

Improvements welcome! Please:
1. Test changes locally
2. Document rationale for behavioral changes
3. Include verification steps
