# Orchestrate Complex Work

> Coordinate multi-step tasks, parallel agents, and autonomous workflows.

---

## When to Use This

You have work that is too complex for a single linear conversation. This includes tasks requiring parallel investigation, multi-agent coordination, iterative refinement loops, or sustained autonomous operation. Whether you are researching across multiple codebases, running tests while implementing fixes, or building entire features with minimal intervention, this guide covers orchestration patterns.

---

## Quick Start

1. **For parallel work**: Use `dispatching-parallel-agents` skill to coordinate multiple subagents
2. **For autonomous iteration**: Install `ralph-wiggum` plugin and run `/ralph-loop`
3. **For architecture guidance**: Read "Building Effective Agents" to choose the right orchestration pattern

---

## Resources

### Primary Tools

| Resource | Type | Location | Why |
|----------|------|----------|-----|
| ralph-wiggum | Plugin (official) | [library/plugins/official/CATALOG.md](../library/plugins/official/CATALOG.md#12-ralph-wiggum) | Autonomous iteration loops for sustained work |
| dispatching-parallel-agents | Skill | [library/skills/core-skills/obra-workflow/dispatching-parallel-agents/](../library/skills/core-skills/obra-workflow/dispatching-parallel-agents/) | Coordinate multiple subagents simultaneously |
| subagent-driven-development | Skill | [library/skills/core-skills/obra-development/subagent-driven-development/](../library/skills/core-skills/obra-development/subagent-driven-development/) | Multi-agent development workflows |

### Supporting Resources

| Resource | Type | Location | Why |
|----------|------|----------|-----|
| using-superpowers | Skill | [library/skills/core-skills/obra-workflow/using-superpowers/](../library/skills/core-skills/obra-workflow/using-superpowers/) | Leverage platform capabilities for orchestration |
| using-tmux-for-interactive-commands | Skill | [library/skills/core-skills/obra-workflow/using-tmux-for-interactive-commands/](../library/skills/core-skills/obra-workflow/using-tmux-for-interactive-commands/) | Run interactive tools alongside Claude |
| feature-dev | Plugin (official) | [library/plugins/official/CATALOG.md](../library/plugins/official/CATALOG.md#6-feature-dev) | 7-phase structured feature development |

### Documentation

| Doc | Location | When to Read |
|-----|----------|--------------|
| Multi-Agent Research System | [docs/best-practices/](../docs/best-practices/) | Anthropic's orchestrator-worker pattern case study |
| Building Effective Agents | [docs/best-practices/](../docs/best-practices/) | Fundamental agent architecture patterns |
| Context Engineering | [docs/best-practices/](../docs/best-practices/) | Managing context across multiple agents |
| Subagents | [docs/core-features/subagents.md](../docs/core-features/subagents.md) | Claude Code's subagent capabilities |

---

## Recommended Workflow

1. **Assess complexity**: Determine if you need parallel execution, iteration, or sequential phases
2. **Choose pattern**: Select workflow vs. autonomous agent approach based on predictability
3. **Define success criteria**: For autonomous loops, establish clear completion conditions
4. **Set up coordination**: Use dispatching-parallel-agents for multi-subagent work
5. **Configure safety bounds**: Set max-iterations and completion promises for ralph-wiggum loops
6. **Monitor and intervene**: Keep watch during long autonomous runs; use `/cancel-ralph` if needed

---

## Orchestration Pattern Decision Guide

| Your situation | Recommended pattern | Key resource |
|----------------|---------------------|--------------|
| Well-defined phases, predictable flow | Workflow (prompt chaining) | Building Effective Agents |
| Need multiple perspectives simultaneously | Parallel agents | dispatching-parallel-agents |
| Task requires iteration until tests pass | Autonomous loop | ralph-wiggum |
| Complex feature with exploration needed | Structured phases | feature-dev plugin |
| Research across many sources | Orchestrator-worker | Multi-Agent Research System |

---

## Safety Considerations

- **Set max-iterations**: Always use `--max-iterations` with ralph-wiggum to prevent runaway loops
- **Clear completion criteria**: Define explicit success signals (e.g., `<promise>COMPLETE</promise>`)
- **Monitor token usage**: Long orchestration runs can consume significant context
- **Checkpoint work**: For multi-hour runs, ensure work is committed regularly

---

## Related Intents

- [start-feature.md](start-feature.md) - Use orchestration for structured feature development
- [extend-claude-code.md](extend-claude-code.md) - Build custom orchestration plugins and skills
