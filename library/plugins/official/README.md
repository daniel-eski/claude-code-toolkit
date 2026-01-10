# Official Anthropic Plugins

> Reference documentation for the 13 official plugins maintained by Anthropic in the Claude Code repository.

## Overview

These plugins are developed and maintained by Anthropic engineers. They serve as both production-ready tools and reference implementations for plugin development.

**Source Repository**: https://github.com/anthropics/claude-code/tree/main/plugins

## Plugin Index

| Plugin | Category | Description |
|--------|----------|-------------|
| [agent-sdk-dev](#agent-sdk-dev) | Development | Create and verify Agent SDK applications in Python and TypeScript |
| [claude-opus-4-5-migration](#claude-opus-4-5-migration) | Migration | Migrate code and prompts to Opus 4.5 |
| [code-review](#code-review) | Code Quality | Automated PR review with multi-agent confidence-based analysis |
| [commit-commands](#commit-commands) | Git Workflow | Streamlined git commit, push, and PR creation |
| [explanatory-output-style](#explanatory-output-style) | Output Style | Educational insights on implementation choices |
| [feature-dev](#feature-dev) | Development | Structured 7-phase feature development workflow |
| [frontend-design](#frontend-design) | Design | Production-grade frontend interfaces with distinctive aesthetics |
| [hookify](#hookify) | Customization | Create custom hooks to prevent unwanted behaviors |
| [learning-output-style](#learning-output-style) | Output Style | Interactive learning with active code contribution |
| [plugin-dev](#plugin-dev) | Development | Comprehensive plugin development toolkit |
| [pr-review-toolkit](#pr-review-toolkit) | Code Quality | 6 specialized agents for thorough PR review |
| [ralph-wiggum](#ralph-wiggum) | Automation | Self-referential AI loops for iterative development |
| [security-guidance](#security-guidance) | Security | Security vulnerability warnings during file editing |

## Installation

Official plugins can be installed via the Claude Code plugin system:

```bash
# Install a specific plugin
/plugin install {plugin-name}

# Or from the marketplace
/plugin install {plugin-name}@claude-code-marketplace
```

For development/testing:
```bash
claude --plugin-dir /path/to/plugin-directory
```

## Plugin Categories

### Development Plugins
- **agent-sdk-dev** - Build Agent SDK applications
- **feature-dev** - Structured feature development
- **plugin-dev** - Create new plugins

### Code Quality Plugins
- **code-review** - Automated PR review
- **pr-review-toolkit** - Comprehensive review agents

### Git Workflow Plugins
- **commit-commands** - Simplified git operations

### Output Style Plugins
- **explanatory-output-style** - Educational explanations
- **learning-output-style** - Interactive learning mode

### Specialized Plugins
- **frontend-design** - Frontend UI development
- **hookify** - Custom hook creation
- **ralph-wiggum** - Autonomous iteration loops
- **security-guidance** - Security awareness
- **claude-opus-4-5-migration** - Model migration

---

## Detailed Plugin Documentation

See [CATALOG.md](./CATALOG.md) for comprehensive documentation of each plugin including:
- Full descriptions and purpose
- Commands and agents provided
- Usage examples
- Best practices

---

## Related Resources

- [Plugin Development Guide](https://github.com/anthropics/claude-code/tree/main/plugins/plugin-dev)
- [Claude Code Documentation](https://code.claude.com/docs)
- [Plugin System Reference](/Users/danieleskenazi/Desktop/Repos/Claude Code Docs with External plug ins/07-plugins/)
