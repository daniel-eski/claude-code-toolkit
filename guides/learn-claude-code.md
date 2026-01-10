# Learn Claude Code

> Understand Claude Code deeply through documentation, plugins, and educational resources

---

## When to Use This

You want to go beyond basic usage and truly understand how Claude Code works. Maybe you're curious about its architecture, want to use advanced features effectively, or need to debug unexpected behavior. These resources help you build mental models of Claude Code's internals and best practices.

## Quick Start

1. Install the claude-code-advisor plugin for instant feature explanations
2. Read the Claude Code Best Practices doc for core patterns
3. Use context-introspection to see what's loaded in your session

---

## Resources

### Primary Tools

| Resource | Type | Location | Why |
|----------|------|----------|-----|
| claude-code-advisor | Plugin (local) | `library/plugins/local/claude-code-advisor/` | Deep feature knowledge with 10 specialized agents covering skills, hooks, MCP, subagents, and more |
| context-introspection | Plugin (local) | `library/plugins/local/context-introspection/` | See exactly what context is loaded in your current session |
| explanatory-output-style | Plugin (official) | `library/plugins/official/CATALOG.md` | Makes Claude Code explain its reasoning and decisions as it works |
| learning-output-style | Plugin (official) | `library/plugins/official/CATALOG.md` | Interactive learning mode with quizzes and explanations |

### Supporting Resources

| Resource | Type | Location | Why |
|----------|------|----------|-----|
| Plugin deployment guide | Doc | `library/plugins/README.md` | How to install and configure plugins |
| Plugin catalog | Reference | `library/plugins/CATALOG.md` | Browse all available plugins |

### Documentation

| Doc | Location | When to Read |
|-----|----------|--------------|
| Claude Code Best Practices | `docs/best-practices/claude-code-best-practices.md` | Core patterns for effective usage - read first |
| Context Engineering | `docs/best-practices/context-engineering.md` | How Claude Code manages context and memory |
| Building Effective Agents | `docs/best-practices/building-effective-agents.md` | Agent architecture and patterns |
| Anthropic Academy | `docs/external/tutorials-courses.md` | Video courses and structured learning paths |

---

## Recommended Workflow

1. **Start with fundamentals** - Read the Claude Code Best Practices doc to understand core patterns and mental models

2. **Install the advisor plugin** - Deploy claude-code-advisor for on-demand explanations:
   ```bash
   cd library/tools/
   ./deploy-plugin.sh ../plugins/local/claude-code-advisor/
   ```

3. **Explore specific features** - Use the advisor's commands to dive deep:
   - `/cc-advisor` - General feature questions
   - `/cc-analyze` - Understand how a feature works
   - `/cc-verify` - Check if you're using something correctly
   - `/cc-design` - Get implementation guidance

4. **See your context** - Use context-introspection to understand what Claude Code "sees":
   - Install the plugin
   - Run `/context-introspection:report` to see loaded files, settings, and context

5. **Enable learning mode** - Install explanatory-output-style or learning-output-style for ongoing education as you work

6. **Go deeper** - Read Context Engineering and Building Effective Agents docs for advanced understanding

7. **Structured learning** - Check Anthropic Academy for video courses if you prefer that format

---

## Related Intents

- [extend-claude-code](extend-claude-code.md) - Build plugins and customize Claude Code
- [debug-problems](debug-problems.md) - Troubleshoot issues with deeper understanding
