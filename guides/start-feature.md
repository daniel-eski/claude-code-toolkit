# Start a New Feature or Project

> Plan, design, and implement new features with structured workflows and best practices.

---

## When to Use This

You want to begin work on a new feature, component, or project. This could be adding functionality to an existing codebase, starting a greenfield project, or building something from a design spec. Use these resources when you need structured planning before jumping into code.

## Quick Start

1. Run `/feature-dev` to activate the 7-phase feature development workflow
2. Use `/brainstorming` to generate and explore ideas before committing to an approach
3. Follow the CLAUDE.md best practices doc to set up project context

---

## Resources

### Primary Tools

| Resource | Type | Location | Why |
|----------|------|----------|-----|
| feature-dev | Plugin (official) | `library/plugins/official/CATALOG.md` | Complete 7-phase workflow: ideation, design, planning, implementation, testing, review, deployment |
| agent-sdk-dev | Plugin (official) | `library/plugins/official/CATALOG.md` | Specialized workflow for SDK and agent projects with multi-agent architecture |
| brainstorming | Skill | `library/skills/core-skills/obra-workflow/brainstorming/` | Structured idea generation with divergent/convergent thinking phases |
| writing-plans | Skill | `library/skills/core-skills/obra-workflow/writing-plans/` | Strategic planning with clear objectives, milestones, and success criteria |

### Supporting Resources

| Resource | Type | Location | Why |
|----------|------|----------|-----|
| executing-plans | Skill | `library/skills/core-skills/obra-workflow/executing-plans/` | Systematic plan execution with progress tracking and adaptation |

### Documentation

| Doc | Source | When to Read |
|-----|--------|--------------|
| Claude Code Best Practices | [anthropic.com/engineering](https://www.anthropic.com/engineering/claude-code-best-practices) | Before starting - learn CLAUDE.md setup and agentic coding patterns |
| Building Effective Agents | [anthropic.com/engineering](https://www.anthropic.com/engineering/building-effective-agents) | When designing agent architecture or multi-component systems |

> **Tip**: See [docs/best-practices/](../docs/best-practices/) for summaries of all key documents.

---

## Recommended Workflow

1. **Clarify the goal** - Use `/brainstorming` to explore the problem space and generate potential approaches
2. **Activate feature-dev** - Run `/feature-dev` to start the structured 7-phase workflow
3. **Create a plan** - Use `/writing-plans` to document objectives, constraints, and milestones
4. **Set up project context** - Configure CLAUDE.md with project-specific instructions per the best practices doc
5. **Execute iteratively** - Use `/executing-plans` to work through implementation systematically
6. **Review architecture decisions** - Consult the Building Effective Agents doc for complex systems

---

## Related Intents

- [improve-quality.md](improve-quality.md) - Apply code quality and testing practices to your new feature
- [orchestrate-work.md](orchestrate-work.md) - Coordinate multi-agent workflows for larger projects
