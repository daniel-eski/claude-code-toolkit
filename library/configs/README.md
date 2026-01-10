# Configurations

> Reusable configuration templates and kits for Claude Code.

## What's Here

| Kit | Purpose | Components |
|-----|---------|------------|
| `workflow-optimizer-kit/` | Meta-cognitive workflow optimization | CLAUDE.md, 2 commands, 1 skill, rules |

---

## workflow-optimizer-kit

A configuration bundle that enhances Claude Code's meta-cognitive capabilities—making it think before acting, seek alignment on ambiguous tasks, and continuously improve workflows through reflection.

### The Problem It Solves

When you give Claude Code a short or ambiguous prompt, it tends to dive straight into execution. This can lead to:
- Misaligned work (Claude interprets differently than you meant)
- Wasted context (exploration in wrong direction)
- Missed optimizations (no systematic learning)

### Three-Layer System

```
┌─────────────────────────────────────────────────────────────┐
│  Layer 3: EXPLICIT INVOCATION                               │
│  /kickoff, /reflect commands                                │
├─────────────────────────────────────────────────────────────┤
│  Layer 2: AUTO-INVOKED CAPABILITIES                         │
│  workflow-reflection skill                                  │
├─────────────────────────────────────────────────────────────┤
│  Layer 1: FOUNDATIONAL BEHAVIOR (Always Active)             │
│  CLAUDE.md instructions                                     │
└─────────────────────────────────────────────────────────────┘
```

### Components

| Component | File | Purpose |
|-----------|------|---------|
| **CLAUDE.md** | `config/CLAUDE.md` | Core behavioral instructions |
| **Modular rules** | `config/rules/*.md` | Path-specific and topic-specific rules |
| **workflow-reflection skill** | `config/skills/workflow-reflection/` | Post-task optimization analysis |
| **/kickoff command** | `config/commands/kickoff.md` | Explicit structured planning |
| **/reflect command** | `config/commands/reflect.md` | Explicit reflection trigger |

### Installation

```bash
cd workflow-optimizer-kit
chmod +x install.sh
./install.sh
```

Or manual install - copy files to `~/.claude/`:
```bash
cp config/CLAUDE.md ~/.claude/CLAUDE.md
cp -r config/rules ~/.claude/rules
cp -r config/skills ~/.claude/skills
cp -r config/commands ~/.claude/commands
```

### Usage

| Situation | What to Do |
|-----------|------------|
| Simple, clear task | Just ask normally → Claude proceeds directly |
| Ambiguous task | Just ask normally → Claude auto-triggers planning |
| Complex task, want guaranteed planning | `/kickoff [task description]` |
| After completing significant work | Say "let's reflect" or `/reflect` |

See `workflow-optimizer-kit/README.md` for full documentation.

Source: Graduated from `experimental/plugins/` (2026-01-10)

---

## Purpose

Configuration kits provide ready-to-use templates for:
- CLAUDE.md files for different project types
- Hook configuration examples
- Settings.json examples
- MCP server configurations
- Behavioral shaping for specific workflows

---

## Status

ACTIVE - 1 configuration kit available.
Graduated from experimental/ (2026-01-10)
