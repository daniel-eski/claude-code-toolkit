# Best Practices

> High-value guidance from Anthropic for building with Claude and Claude Code.

---

## Quick Navigation

| I want to... | Start here |
|--------------|------------|
| Set up Claude Code effectively | [Claude Code Best Practices](#claude-code-best-practices) |
| Build an agent | [Building Effective Agents](#building-effective-agents) |
| Manage context in long sessions | [Context Engineering](#context-engineering) |
| Design tools for Claude | [Writing Tools for Agents](#writing-tools-for-agents) |
| Learn prompt engineering | [Prompt Engineering Overview](#prompt-engineering-overview) |
| Use Claude 4.x effectively | [Claude 4 Prompting](#claude-4-prompting) |

---

## Engineering Blog Articles

### Claude Code Best Practices

**Source**: [anthropic.com/engineering/claude-code-best-practices](https://www.anthropic.com/engineering/claude-code-best-practices)

Comprehensive guide to agentic coding workflows, CLAUDE.md configuration, and optimization.

**Key Topics**:
- Writing effective CLAUDE.md files
- Structuring prompts for agentic workflows
- Managing context and memory
- Optimization patterns for complex tasks

**When to use**: Setting up a new project, optimizing existing Claude Code workflows, writing CLAUDE.md files.

---

### Building Effective Agents

**Source**: [anthropic.com/engineering/building-effective-agents](https://www.anthropic.com/engineering/building-effective-agents)

Foundational patterns for agent architecture: when to use workflows vs. autonomous agents.

**Key Topics**:
- Workflows vs. agents decision framework
- Prompt chaining patterns
- Routing and parallelization
- Orchestrator-worker architecture
- Evaluator-optimizer loops

**When to use**: Designing agent systems, choosing between workflow patterns, planning multi-step automations.

---

### Context Engineering

**Source**: [anthropic.com/engineering/effective-context-engineering-for-ai-agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)

Managing context windows for long-running agents, compaction strategies, and multi-agent architectures.

**Key Topics**:
- Writing context-efficient prompts
- Context window management
- Compaction and summarization strategies
- Memory across sessions
- Multi-agent context patterns

**When to use**: Long-running agent sessions, hitting context limits, designing memory systems.

---

### Multi-Agent Research System

**Source**: [anthropic.com/engineering/multi-agent-research-system](https://www.anthropic.com/engineering/multi-agent-research-system)

How Anthropic built their Research feature with orchestrator-worker pattern achieving 90% performance gains.

**Key Topics**:
- Orchestrator-worker architecture
- Task decomposition strategies
- Parallel execution patterns
- Result aggregation
- Real-world performance optimization

**When to use**: Building complex research systems, multi-agent architectures, understanding Anthropic's internal patterns.

---

### Writing Tools for Agents

**Source**: [anthropic.com/engineering/writing-tools-for-agents](https://www.anthropic.com/engineering/writing-tools-for-agents)

Tool design principles, evaluation-driven development, and MCP best practices.

**Key Topics**:
- Tool description guidelines
- Namespacing and organization
- Token-efficient responses
- Error handling patterns
- Evaluation-driven tool development

**When to use**: Creating MCP servers, designing tool interfaces, improving tool reliability.

---

### The "think" Tool

**Source**: [anthropic.com/engineering/claude-think-tool](https://www.anthropic.com/engineering/claude-think-tool)

Implementing intermediate reasoning during complex multi-step tool use.

**Key Topics**:
- When to use the think tool
- Implementation patterns
- Integration with tool chains
- Performance considerations

**When to use**: Complex tool sequences, debugging tool use, improving reasoning quality.

---

## Platform Documentation

### Prompt Engineering Overview

**Source**: [platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview)

Core prompt engineering techniques and when to apply them.

**Key Techniques**:
- Be clear and direct
- Use XML tags for structure
- Few-shot examples (multishot prompting)
- Chain of thought reasoning
- Role and system prompts
- Prefilling responses

**When to use**: Learning prompt engineering fundamentals, improving prompt quality, structured prompts.

---

### Claude 4 Prompting

**Source**: [platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-4-best-practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-4-best-practices)

Claude 4.x specific prompting techniques, parallel tools, and state management.

**Key Topics**:
- Model-specific behavior differences
- Parallel tool calling
- State management patterns
- Extended thinking prompts
- Performance optimization

**When to use**: Working with Claude 4.x models, migrating from earlier versions, optimizing for new capabilities.

---

### Tool Use Overview

**Source**: [platform.claude.com/docs/en/agents-and-tools/tool-use/overview](https://platform.claude.com/docs/en/agents-and-tools/tool-use/overview)

Tool use fundamentals, client vs. server tools, and MCP integration.

**Key Topics**:
- Client-side vs. server-side tools
- Tool definition schemas
- MCP protocol basics
- Tool use patterns

**When to use**: Adding tools to Claude, understanding tool architecture, MCP setup.

---

## Learning Paths

### New to Claude Code
1. Claude Code Best Practices
2. Prompt Engineering Overview
3. Context Engineering

### Building Agents
1. Building Effective Agents
2. Writing Tools for Agents
3. Multi-Agent Research System

### Advanced Usage
1. Context Engineering
2. The "think" Tool
3. Claude 4 Prompting

---

## Sources

- Engineering blog: https://anthropic.com/engineering
- Platform docs: https://platform.claude.com/docs
- Document fetch date: January 2026

---

## Design Decision

**Approach**: Pointers to external sources (not local copies)

**Rationale**:
- External sources stay current with upstream updates
- No maintenance burden for keeping local copies synchronized
- Summaries and "when to use" guidance provide contextual value
- Learning paths help navigate the material

**URLs Verified**: 2026-01-10 (anthropic.com/engineering, platform.claude.com, code.claude.com)
