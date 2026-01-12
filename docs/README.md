# Documentation

> Indexes and pointers to Claude Code documentation, best practices, and external resources.

---

## Quick Navigation

| I want to... | Go to |
|--------------|-------|
| Install or configure Claude Code | [claude-code/](#claude-code-official-documentation) |
| Learn agentic coding best practices | [best-practices/](#best-practices) |
| Find the Claude API docs | [external/](#external-resources) |
| Learn prompt engineering | [best-practices/](#best-practices) |
| Find tutorials and courses | [external/](#external-resources) |
| Work with MCP servers | [claude-code/](#claude-code-official-documentation) (setup) or [external/](#external-resources) (resources) |
| Build agents or subagents | [best-practices/](#best-practices) |

---

## Claude Code: Official Documentation

**Location**: [`claude-code/`](./claude-code/)

Index to official documentation at [code.claude.com](https://code.claude.com).

### Categories

| Category | What You'll Find |
|----------|------------------|
| Getting Started | Installation, setup, quickstart, interactive mode |
| Core Features | Skills, memory, hooks, MCP, subagents, slash commands |
| IDE Integration | VS Code, JetBrains, Desktop, Chrome |
| Cloud Providers | AWS Bedrock, Google Vertex AI, Microsoft Foundry, LLM Gateway |
| Enterprise | Security, IAM, sandboxing, monitoring, network config |
| CI/CD & Automation | GitHub Actions, GitLab CI/CD, headless mode, Slack |
| Plugins | Create plugins, plugin reference, discovery, marketplaces |
| Configuration | Settings, model config, terminal, statusline |
| Reference | CLI reference, troubleshooting, costs, analytics |

### Quick Links

- [Setup](https://code.claude.com/docs/en/setup) - Full installation guide
- [Skills](https://code.claude.com/docs/en/skills) - Create and manage skills
- [MCP](https://code.claude.com/docs/en/mcp) - Connect to external tools
- [Hooks](https://code.claude.com/docs/en/hooks-guide) - Customize Claude's behavior
- [VS Code](https://code.claude.com/docs/en/vs-code) - IDE extension
- [GitHub Actions](https://code.claude.com/docs/en/github-actions) - CI/CD integration

---

## Best Practices

**Location**: [`best-practices/`](./best-practices/)

High-value guidance from Anthropic's engineering blog and platform documentation.

### Documents

| Document | Source | Summary |
|----------|--------|---------|
| Claude Code Best Practices | anthropic.com/engineering | Agentic coding workflows, CLAUDE.md configuration |
| Building Effective Agents | anthropic.com/engineering | Workflows vs. agents, when to use each pattern |
| Context Engineering | anthropic.com/engineering | Managing context windows, compaction, memory |
| Multi-Agent Research System | anthropic.com/engineering | Orchestrator-worker pattern, 90% performance gains |
| Writing Tools for Agents | anthropic.com/engineering | Tool design principles, MCP best practices |
| The "think" Tool | anthropic.com/engineering | Intermediate reasoning for complex tool use |
| Prompt Engineering Overview | platform.claude.com | Core prompting techniques |
| Claude 4 Prompting | platform.claude.com | Claude 4.x specific techniques |
| Tool Use Overview | platform.claude.com | Tool use fundamentals |

### Learning Paths

**New to Claude Code**:
1. Claude Code Best Practices
2. Prompt Engineering Overview
3. Context Engineering

**Building Agents**:
1. Building Effective Agents
2. Writing Tools for Agents
3. Multi-Agent Research System

---

## External Resources

**Location**: [`external/`](./external/)

Curated links to documentation, tutorials, and community resources.

### Categories

| Category | What You'll Find |
|----------|------------------|
| API Reference | Claude API docs, SDKs, authentication, features |
| Tutorials & Courses | Anthropic Academy, interactive tutorials, cookbooks |
| GitHub Repositories | Official repos, community projects, agent SDKs |
| MCP Resources | MCP specification, SDKs, pre-built servers |
| Agent Development | Engineering blog articles, patterns, SDK demos |
| Prompt Engineering | Platform docs, prompt library, techniques |

### Quick Links

- [Anthropic Academy](https://anthropic.skilljar.com) - Official video courses
- [Anthropic Cookbook](https://github.com/anthropics/anthropic-cookbook) - Code examples
- [MCP Documentation](https://modelcontextprotocol.io) - Model Context Protocol
- [Claude Console](https://console.anthropic.com) - API keys and Workbench
- [Platform Cookbooks](https://platform.claude.com/cookbook) - 60+ practical guides

---

## Self-Knowledge

**Location**: [`self-knowledge/`](./self-knowledge/)

Resources to help Claude understand itself better.

**Status**: Deferred - structure created, content pending.

---

## Contributing

To update these indexes:
1. Check the source (code.claude.com, anthropic.com/engineering, platform.claude.com)
2. Update the relevant README in this folder
3. Note the update date in the file

For structural changes, see `_workspace/planning/` for design decisions.
