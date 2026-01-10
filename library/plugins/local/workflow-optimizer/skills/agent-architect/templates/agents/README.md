# Agent Templates

Quick reference for selecting the right agent template for your task.

## Selection Guide

| Task Type | Agent | Model | Key Strength |
|-----------|-------|-------|--------------|
| Debug errors | [debugger](development/debugger.md) | inherit | Root cause analysis |
| Run/fix tests | [test-runner](development/test-runner.md) | inherit | Test suite management |
| Implement features | [implementer](development/implementer.md) | inherit | Focused code writing |
| Code review | [code-reviewer](review/code-reviewer.md) | inherit | Quality + security |
| Security audit | [security-auditor](review/security-auditor.md) | inherit | Vulnerability detection |
| Research codebase | [researcher](research/researcher.md) | sonnet | Deep understanding |
| Write documentation | [documentation-writer](non-coding/documentation-writer.md) | inherit | Clear technical docs |
| Track progress | [project-manager](non-coding/project-manager.md) | haiku | Lightweight updates |
| Write tutorials | [technical-writer](non-coding/technical-writer.md) | inherit | Educational content |

## Categories

### Development
Agents for writing, fixing, and testing code.
- **[debugger](development/debugger.md)** — Systematic error diagnosis and fixes
- **[test-runner](development/test-runner.md)** — Execute tests, fix failures
- **[implementer](development/implementer.md)** — Focused feature implementation

### Review
Agents for code quality and security assessment.
- **[code-reviewer](review/code-reviewer.md)** — Quality, security, maintainability review
- **[security-auditor](review/security-auditor.md)** — Security vulnerability audit

### Research
Agents for understanding codebases.
- **[researcher](research/researcher.md)** — Deep codebase exploration and analysis

### Non-Coding
Agents for documentation and project management.
- **[documentation-writer](non-coding/documentation-writer.md)** — READMEs, API docs, changelogs
- **[project-manager](non-coding/project-manager.md)** — Progress tracking, planning updates
- **[technical-writer](non-coding/technical-writer.md)** — Tutorials, guides, explanations

### Orchestration
Patterns for multi-agent workflows.
- **[patterns](orchestration/patterns.md)** — Parallel, pipeline, fan-out patterns

## Multi-Agent Workflows

See [orchestration/patterns.md](orchestration/patterns.md) for guidance on:
- Running multiple agents in parallel
- Chaining agents in pipelines
- Fan-out/fan-in patterns for large tasks
- Conditional agent routing

## Usage

1. Copy the agent template to `.claude/agents/[name].md`
2. Customize the system prompt for your project
3. Adjust tools and model as needed
4. The agent is automatically available for delegation

## Model Selection Guide

| Model | Best For | Cost |
|-------|----------|------|
| `inherit` | Most tasks, follows parent | Default |
| `haiku` | Quick, lightweight tasks | Lowest |
| `sonnet` | Complex reasoning | Medium |
| `opus` | Highest capability needs | Highest |
