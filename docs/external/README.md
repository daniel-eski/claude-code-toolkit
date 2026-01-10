# External Resources

> Curated links to official Anthropic documentation, tutorials, and community resources.

---

## Quick Navigation

| I want to... | Start here |
|--------------|------------|
| Use the Claude API | [API Reference](#api-reference) |
| Learn through tutorials | [Tutorials and Courses](#tutorials-and-courses) |
| Find GitHub repositories | [GitHub Repositories](#github-repositories) |
| Work with MCP | [MCP Resources](#mcp-resources) |
| Build agents | [Agent Development](#agent-development) |
| Learn prompt engineering | [Prompt Engineering](#prompt-engineering) |

---

## API Reference

Resources for working with the Claude API programmatically.

### Primary Documentation

| Resource | Description |
|----------|-------------|
| [API Overview](https://platform.claude.com/docs/en/api/overview) | REST API basics, authentication |
| [Messages API](https://platform.claude.com/docs/en/api/messages) | Core conversational endpoint |
| [Models Overview](https://platform.claude.com/docs/en/about-claude/models/overview) | Model comparison, pricing |
| [What's New in Claude 4.5](https://platform.claude.com/docs/en/about-claude/models/whats-new-claude-4-5) | Latest capabilities |

### API Features

| Feature | Description |
|---------|-------------|
| [Streaming](https://platform.claude.com/docs/en/build-with-claude/streaming) | SSE streaming, event types |
| [Prompt Caching](https://platform.claude.com/docs/en/build-with-claude/prompt-caching) | 90% cost reduction |
| [Batch Processing](https://platform.claude.com/docs/en/build-with-claude/batch-processing) | 50% cost savings for async |
| [Extended Thinking](https://platform.claude.com/docs/en/build-with-claude/extended-thinking) | Step-by-step reasoning |
| [Vision](https://platform.claude.com/docs/en/build-with-claude/vision) | Image analysis |
| [PDF Support](https://platform.claude.com/docs/en/build-with-claude/pdf-support) | PDF extraction |
| [Structured Outputs](https://platform.claude.com/docs/en/build-with-claude/structured-outputs) | JSON schema conformance |

### Official SDKs

| SDK | Repository |
|-----|------------|
| Python | [anthropics/anthropic-sdk-python](https://github.com/anthropics/anthropic-sdk-python) |
| TypeScript | [anthropics/anthropic-sdk-typescript](https://github.com/anthropics/anthropic-sdk-typescript) |
| Java | [anthropics/anthropic-sdk-java](https://github.com/anthropics/anthropic-sdk-java) |
| Go | [anthropics/anthropic-sdk-go](https://github.com/anthropics/anthropic-sdk-go) |
| C# (beta) | [anthropics/anthropic-sdk-csharp](https://github.com/anthropics/anthropic-sdk-csharp) |
| Ruby | [anthropics/anthropic-sdk-ruby](https://github.com/anthropics/anthropic-sdk-ruby) |
| PHP (beta) | [anthropics/anthropic-sdk-php](https://github.com/anthropics/anthropic-sdk-php) |

### Developer Console

| Resource | Description |
|----------|-------------|
| [Claude Console](https://console.anthropic.com) | API keys, Workbench, usage |
| [Workbench](https://console.anthropic.com/workbench) | Interactive prompt testing |

---

## Tutorials and Courses

### Anthropic Academy

Official video courses with certificates at [anthropic.skilljar.com](https://anthropic.skilljar.com/).

| Course | Level | Description |
|--------|-------|-------------|
| API Fundamentals | Beginner | SDK essentials, API keys, model parameters |
| Prompt Engineering Tutorial | Beginner-Intermediate | Comprehensive prompting techniques |
| [Claude Code in Action](https://anthropic.skilljar.com/claude-code-in-action) | Intermediate | Practical workflow training |
| Real World Prompting | Intermediate | Complex, production-level prompts |
| Tool Use | Intermediate | Implementing tools in workflows |
| [Introduction to MCP](https://anthropic.skilljar.com/introduction-to-model-context-protocol) | Intermediate | Building MCP servers/clients |

### Interactive Tutorials

| Resource | Stars | Description |
|----------|-------|-------------|
| [Prompt Engineering Tutorial](https://github.com/anthropics/prompt-eng-interactive-tutorial) | 28.6k | 9-chapter Jupyter notebook course |
| [Anthropic Courses](https://github.com/anthropics/courses) | 18k | Full curriculum with exercises |
| [Anthropic Cookbook](https://github.com/anthropics/anthropic-cookbook) | - | Jupyter notebooks for common tasks |

### External Courses

| Course | Provider | Description |
|--------|----------|-------------|
| [Claude Code Short Course](https://www.deeplearning.ai/short-courses/claude-code-a-highly-agentic-coding-assistant/) | DeepLearning.AI | Agentic coding patterns |

### Documentation Sites

| Site | Focus |
|------|-------|
| [code.claude.com/docs](https://code.claude.com/docs) | Claude Code CLI |
| [platform.claude.com/docs](https://platform.claude.com/docs) | Claude API |
| [modelcontextprotocol.io](https://modelcontextprotocol.io) | MCP specification |

---

## GitHub Repositories

### Core Documentation and Learning

| Repository | Stars | Description |
|------------|-------|-------------|
| [anthropics/courses](https://github.com/anthropics/courses) | 18k | Full learning curriculum |
| [anthropics/prompt-eng-interactive-tutorial](https://github.com/anthropics/prompt-eng-interactive-tutorial) | 28.6k | Interactive prompt engineering |
| [anthropics/anthropic-cookbook](https://github.com/anthropics/anthropic-cookbook) | - | Vision, PDF, RAG recipes |
| [anthropics/claude-quickstarts](https://github.com/anthropics/claude-quickstarts) | - | Deployable application templates |

### Claude Code

| Repository | Description |
|------------|-------------|
| [anthropics/claude-code](https://github.com/anthropics/claude-code) | Claude Code source and documentation |
| [anthropics/claude-code-action](https://github.com/anthropics/claude-code-action) | GitHub Action for PRs/issues |
| [anthropics/claude-code-security-review](https://github.com/anthropics/claude-code-security-review) | Security review action |
| [anthropics/devcontainer-features](https://github.com/anthropics/devcontainer-features) | Dev Container with Claude Code |

### Agent SDKs

| Repository | Description |
|------------|-------------|
| [anthropics/claude-agent-sdk-python](https://github.com/anthropics/claude-agent-sdk-python) | Python Agent SDK |
| [anthropics/claude-agent-sdk-typescript](https://github.com/anthropics/claude-agent-sdk-typescript) | TypeScript Agent SDK |
| [anthropics/claude-agent-sdk-demos](https://github.com/anthropics/claude-agent-sdk-demos) | Multi-agent demonstrations |

### Skills and Plugins

| Repository | Description |
|------------|-------------|
| [anthropics/skills](https://github.com/anthropics/skills) | Official Agent Skills |
| [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) | Vetted plugin directory |

### Community Resources

| Repository | Description |
|------------|-------------|
| [awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) | Community-curated commands, workflows |
| [awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents) | 100+ community subagents |

---

## MCP Resources

### Official Documentation

| Resource | Description |
|----------|-------------|
| [modelcontextprotocol.io](https://modelcontextprotocol.io) | Official MCP documentation |
| [MCP Specification](https://modelcontextprotocol.io/docs/concepts) | Protocol concepts and design |
| [MCP Quickstart](https://modelcontextprotocol.io/docs/quickstart) | Getting started guide |
| [MCP in Claude Code](https://code.claude.com/docs/en/mcp) | Configuring MCP servers |

### MCP SDKs

| SDK | Repository |
|-----|------------|
| Python | [modelcontextprotocol/python-sdk](https://github.com/modelcontextprotocol/python-sdk) |
| TypeScript | [modelcontextprotocol/typescript-sdk](https://github.com/modelcontextprotocol/typescript-sdk) |

### Pre-Built Servers

Reference implementations at [modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers):
- Google Drive, Slack, GitHub, Git
- Postgres, Filesystem, Puppeteer

### MCP Commands in Claude Code

```bash
# Add an MCP server
claude mcp add <name> <command> [args...]

# Debug MCP connections
claude --mcp-debug
```

---

## Agent Development

### Engineering Blog

| Article | Description |
|---------|-------------|
| [Building Effective Agents](https://www.anthropic.com/engineering/building-effective-agents) | Workflows vs agents, patterns |
| [Context Engineering](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) | Context management |
| [Multi-Agent Research System](https://www.anthropic.com/engineering/multi-agent-research-system) | Orchestrator-worker pattern |
| [Building Agents with SDK](https://www.anthropic.com/engineering/building-agents-with-the-claude-agent-sdk) | SDK patterns, subagents |
| [Writing Tools for Agents](https://www.anthropic.com/engineering/writing-tools-for-agents) | Tool design |
| [The "think" Tool](https://www.anthropic.com/engineering/claude-think-tool) | Intermediate reasoning |

### Platform Documentation

| Resource | Description |
|----------|-------------|
| [Agent Skills Overview](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview) | Skills architecture |
| [Agent Skills Best Practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices) | Writing effective skills |

### Key Patterns

| Pattern | When to Use |
|---------|-------------|
| Single LLM + tools | Most tasks - start simple |
| Prompt chaining | Fixed subtasks, accuracy over latency |
| Routing | Distinct categories needing specialization |
| Parallelization | Independent subtasks or voting |
| Orchestrator-workers | Complex tasks with unpredictable subtasks |
| Evaluator-optimizer | Iterative refinement with clear criteria |
| Full agents | Open-ended problems, unpredictable steps |

---

## Prompt Engineering

### Platform Documentation

| Resource | Description |
|----------|-------------|
| [Overview](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview) | When and how to prompt engineer |
| [Be Clear and Direct](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/be-clear-and-direct) | Clarity principles |
| [Use Examples](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/multishot-prompting) | Few-shot prompting |
| [Chain of Thought](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/chain-of-thought) | Step-by-step reasoning |
| [Use XML Tags](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/use-xml-tags) | Structure with semantic tags |
| [System Prompts](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/system-prompts) | Role and context setting |
| [Claude 4 Best Practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-4-best-practices) | Model-specific techniques |

### Resources

| Resource | Description |
|----------|-------------|
| [Prompt Library](https://platform.claude.com/docs/en/resources/prompt-library/library) | 50+ ready-to-use templates |
| [Platform Cookbooks](https://platform.claude.com/cookbook) | 60+ practical guides |

---

## Community

| Resource | Description |
|----------|-------------|
| [Claude Developers Discord](https://discord.com/invite/6PPFFzqPDZ) | Official community (~51K members) |
| [Support Center](https://support.claude.com) | 26 video tutorials, FAQ |

