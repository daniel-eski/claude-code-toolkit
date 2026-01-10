# Claude Code Advisor

A plugin that gives Claude deep, accurate knowledge about Claude Code's extensibility features.

## The Problem

Claude gives generic—sometimes inaccurate—advice about its own features. When you ask "Should I use a skill or a subagent?", you get surface-level answers that miss important nuances like context isolation, token budgets, and trigger behavior.

Users building custom Claude Code configurations need reliable, grounded guidance.

## The Solution

This plugin loads Claude with comprehensive knowledge about Claude Code features (skills, subagents, hooks, memory, commands, MCP), grounded in official documentation. It provides:

- **Decision frameworks** for choosing between features
- **Architectural guidance** based on best practices
- **Verification** of claims against official docs
- **Configuration analysis** of existing setups

## Quick Example

```
User: "Should I use a skill or a subagent for code review?"

Claude (with plugin):
For code review, the key question is whether you need context isolation.

**Use a Skill if:**
- Reviews should see the full conversation context
- You want automatic triggering when code review is mentioned
- The review logic is reusable guidance (not heavy computation)

**Use a Subagent if:**
- Reviews involve reading many files (isolates context bloat)
- You want parallel reviews of different components
- You need a different model tier (e.g., Opus for thorough review)

For most code review workflows, I'd recommend a **skill** that dispatches
to a **subagent** for the actual review work—getting both semantic
triggering and context isolation.

See: references/decision-guides/skills-vs-subagents.md
```

## Quick Start

```bash
# Add the plugin
claude plugin add /path/to/claude-code-advisor

# Enable it
claude plugin enable claude-code-advisor

# Try it out
/cc-advisor "what's the difference between skills and subagents?"
```

## Features

### 4 Slash Commands

| Command | Purpose |
|---------|---------|
| `/cc-advisor` | Get expert advice on Claude Code features |
| `/cc-analyze` | Audit your existing configuration |
| `/cc-verify` | Fact-check claims against official docs |
| `/cc-design` | Design a configuration for your goals |

### 10 Specialized Subagents

**Research & Verification**
- **cc-understanding-verifier** - Fast single-claim verification (Haiku)
- **cc-deep-researcher** - Comprehensive multi-source research (Sonnet)

**Analysis**
- **cc-config-analyzer** - Configuration audit specialist (Sonnet)
- **cc-troubleshooter** - Debug configuration issues (Sonnet)
- **cc-pattern-matcher** - Quick pattern matching (Haiku)

**Design & Generation**
- **cc-architecture-designer** - Configuration designer (Sonnet)
- **cc-skill-generator** - Generate SKILL.md files (Sonnet)
- **cc-agent-generator** - Generate subagent definitions (Sonnet)
- **cc-config-generator** - Generate commands, hooks, memory, MCP (Sonnet)

**Review**
- **cc-implementation-reviewer** - Pre-deployment review (Sonnet)

### 22 Reference Files

Comprehensive coverage of:
- System understanding (context window, execution model)
- Feature mechanics (skills, subagents, hooks, memory, commands, MCP)
- Decision guides (when to use which feature)
- Patterns and anti-patterns
- Implementation guides

## Who This Is For

- **Teams building custom skills and plugins** - Get reliable guidance on skill structure
- **Developers setting up Claude Code workflows** - Make informed architecture decisions
- **Anyone configuring Claude Code** - Understand the tradeoffs between features

## Requirements

- Claude Code (any recent version)
- No external dependencies

## Documentation

- [Installation Guide](INSTALLATION.md) - Setup and verification
- [Usage Guide](USAGE-GUIDE.md) - Commands with real examples
- [Changelog](CHANGELOG.md) - Version history

## How It Works

The plugin provides a skill (`claude-code-advisor`) that loads automatically when you discuss Claude Code features. It includes:

1. **SKILL.md** - Mental models and navigation (~2500 tokens)
2. **Reference files** - Loaded on-demand for specific topics
3. **Subagents** - Dispatched for specialized tasks
4. **Commands** - Explicit entry points for common workflows

This follows Claude Code's progressive disclosure pattern—only loading what's needed for the current question.

## License

MIT
