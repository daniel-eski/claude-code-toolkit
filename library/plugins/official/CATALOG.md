# Official Anthropic Plugins Catalog

> Comprehensive documentation for all 13 official Claude Code plugins.

**Source**: https://github.com/anthropics/claude-code/tree/main/plugins

---

## Table of Contents

1. [agent-sdk-dev](#1-agent-sdk-dev)
2. [claude-opus-4-5-migration](#2-claude-opus-4-5-migration)
3. [code-review](#3-code-review)
4. [commit-commands](#4-commit-commands)
5. [explanatory-output-style](#5-explanatory-output-style)
6. [feature-dev](#6-feature-dev)
7. [frontend-design](#7-frontend-design)
8. [hookify](#8-hookify)
9. [learning-output-style](#9-learning-output-style)
10. [plugin-dev](#10-plugin-dev)
11. [pr-review-toolkit](#11-pr-review-toolkit)
12. [ralph-wiggum](#12-ralph-wiggum)
13. [security-guidance](#13-security-guidance)

---

## 1. agent-sdk-dev

**Agent SDK Development Plugin**

| Property | Value |
|----------|-------|
| GitHub | [plugins/agent-sdk-dev](https://github.com/anthropics/claude-code/tree/main/plugins/agent-sdk-dev) |
| Author | Ashwin Bhat (ashwin@anthropic.com) |
| Version | 1.0.0 |

### Description

A comprehensive plugin for creating and verifying Claude Agent SDK applications in Python and TypeScript. Streamlines the entire lifecycle from initial scaffolding to verification against best practices.

### Commands

| Command | Description |
|---------|-------------|
| `/new-sdk-app` | Interactive command to create a new Agent SDK application |

### Agents

| Agent | Purpose |
|-------|---------|
| `agent-sdk-verifier-py` | Verify Python Agent SDK applications for correct setup and best practices |
| `agent-sdk-verifier-ts` | Verify TypeScript Agent SDK applications for correct setup and best practices |

### Usage

```bash
# Create a new project
/new-sdk-app my-project-name

# Answer interactive prompts:
# - Language: TypeScript or Python
# - Agent type: coding, business, custom
# - Starting point: minimal, basic, or specific example

# Verify after changes
"Verify my Python Agent SDK application"
"Verify my TypeScript Agent SDK application"
```

### What It Does

1. Checks for and installs the latest SDK version
2. Creates all necessary project files and configuration
3. Sets up environment files (.env.example, .gitignore)
4. Provides working examples tailored to use case
5. Runs type checking or syntax validation
6. Automatically verifies setup using appropriate verifier agent

### Best Practices

- Always use the latest SDK version (auto-checked)
- Verify before deploying to production
- Never commit .env files or hardcode API keys
- Run `npx tsc --noEmit` regularly for TypeScript projects

---

## 2. claude-opus-4-5-migration

**Claude Opus 4.5 Migration Plugin**

| Property | Value |
|----------|-------|
| GitHub | [plugins/claude-opus-4-5-migration](https://github.com/anthropics/claude-code/tree/main/plugins/claude-opus-4-5-migration) |
| Author | William Hu (whu@anthropic.com) |

### Description

Migrate your code and prompts from Sonnet 4.x and Opus 4.1 to Opus 4.5. Automates the migration process including model strings, beta headers, and other configuration details.

### Usage

```
"Migrate my codebase to Opus 4.5"
```

### What It Does

- Updates model strings throughout your codebase
- Adjusts beta headers for API compatibility
- Handles configuration updates
- Can be used for initial migration and ongoing adjustments

### Resources

- [Claude 4 Prompting Guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-4-best-practices)

---

## 3. code-review

**Code Review Plugin**

| Property | Value |
|----------|-------|
| GitHub | [plugins/code-review](https://github.com/anthropics/claude-code/tree/main/plugins/code-review) |

### Description

Automated code review for pull requests using multiple specialized agents with confidence-based scoring to filter false positives. Launches 4 parallel agents to independently audit changes from different perspectives.

### Commands

| Command | Options | Description |
|---------|---------|-------------|
| `/code-review` | `--comment` | Perform automated code review on a PR |

### How It Works

1. Checks if review is needed (skips closed, draft, trivial, or already-reviewed PRs)
2. Gathers relevant CLAUDE.md guideline files
3. Summarizes the PR changes
4. Launches 4 parallel agents:
   - **Agents #1 & #2**: Audit for CLAUDE.md compliance
   - **Agent #3**: Scan for obvious bugs in changes
   - **Agent #4**: Analyze git blame/history for context-based issues
5. Scores each issue 0-100 for confidence level
6. Filters out issues below 80 confidence threshold
7. Outputs review (terminal or PR comment)

### Usage

```bash
# Run locally (outputs to terminal)
/code-review

# Post review as PR comment
/code-review --comment
```

### When to Use

- All PRs with meaningful changes
- PRs touching critical code paths
- PRs from multiple contributors
- PRs where guideline compliance matters

### Requirements

- Git repository with GitHub integration
- GitHub CLI (`gh`) installed and authenticated
- CLAUDE.md files (optional but recommended)

---

## 4. commit-commands

**Commit Commands Plugin**

| Property | Value |
|----------|-------|
| GitHub | [plugins/commit-commands](https://github.com/anthropics/claude-code/tree/main/plugins/commit-commands) |

### Description

Streamline your git workflow with simple commands for committing, pushing, and creating pull requests. Reduces context switching and manual command execution.

### Commands

| Command | Description |
|---------|-------------|
| `/commit` | Create a commit with auto-generated message based on changes |
| `/commit-push-pr` | Commit, push, and create PR in one step |
| `/clean_gone` | Clean up local branches deleted from remote |

### Usage

```bash
# Quick commit
/commit

# Full workflow: commit + push + PR
/commit-push-pr

# Clean up merged branches
/clean_gone
```

### What Each Command Does

**`/commit`**:
- Analyzes git status and changes
- Examines recent commits to match repo's style
- Drafts appropriate commit message
- Stages and commits files
- Avoids committing files with secrets

**`/commit-push-pr`**:
- Creates new branch if on main
- Stages and commits with message
- Pushes branch to origin
- Creates PR using `gh pr create`
- Provides PR URL

**`/clean_gone`**:
- Lists local branches with [gone] status
- Removes associated worktrees
- Deletes branches marked as [gone]

### Requirements

- Git installed and configured
- GitHub CLI (`gh`) for `/commit-push-pr`

---

## 5. explanatory-output-style

**Explanatory Output Style Plugin**

| Property | Value |
|----------|-------|
| GitHub | [plugins/explanatory-output-style](https://github.com/anthropics/claude-code/tree/main/plugins/explanatory-output-style) |

### Description

Recreates the deprecated Explanatory output style as a SessionStart hook. Provides educational insights about implementation choices and codebase patterns.

**Warning**: Incurs additional token cost due to extra instructions and output.

### How It Works

Uses a SessionStart hook to inject context that instructs Claude to provide educational explanations:

```
 Insight
[2-3 key educational points]

```

### Insights Focus

- Specific implementation choices for your codebase
- Patterns and conventions in your code
- Trade-offs and design decisions
- Codebase-specific details (not general programming concepts)

### Usage

Once installed, activates automatically at the start of every session. No additional configuration needed.

### Migration

Replaces the deprecated output style setting:
```json
{
  "outputStyle": "Explanatory"
}
```

---

## 6. feature-dev

**Feature Development Plugin**

| Property | Value |
|----------|-------|
| GitHub | [plugins/feature-dev](https://github.com/anthropics/claude-code/tree/main/plugins/feature-dev) |
| Author | Sid Bidasaria (sbidasaria@anthropic.com) |
| Version | 1.0.0 |

### Description

A comprehensive, structured workflow for feature development with specialized agents for codebase exploration, architecture design, and quality review. Provides a systematic 7-phase approach instead of jumping straight into code.

### Commands

| Command | Description |
|---------|-------------|
| `/feature-dev` | Launch guided 7-phase feature development workflow |

### Agents

| Agent | Purpose |
|-------|---------|
| `code-explorer` | Analyze existing codebase features by tracing execution paths |
| `code-architect` | Design feature architectures and implementation blueprints |
| `code-reviewer` | Review code for bugs, quality issues, and conventions |

### The 7 Phases

1. **Discovery** - Clarify requirements and constraints
2. **Codebase Exploration** - Understand existing code using parallel agents
3. **Clarifying Questions** - Fill gaps and resolve ambiguities
4. **Architecture Design** - Design multiple implementation approaches
5. **Implementation** - Build following chosen architecture
6. **Quality Review** - Review with parallel agents for bugs/quality
7. **Summary** - Document accomplishments and next steps

### Usage

```bash
# Full workflow
/feature-dev Add user authentication with OAuth

# Manual agent invocation
"Launch code-explorer to trace how authentication works"
"Launch code-architect to design the caching layer"
"Launch code-reviewer to check my recent changes"
```

### When to Use

- New features touching multiple files
- Features requiring architectural decisions
- Complex integrations with existing code
- Features with unclear requirements

### When NOT to Use

- Single-line bug fixes
- Trivial changes
- Well-defined, simple tasks
- Urgent hotfixes

---

## 7. frontend-design

**Frontend Design Plugin**

| Property | Value |
|----------|-------|
| GitHub | [plugins/frontend-design](https://github.com/anthropics/claude-code/tree/main/plugins/frontend-design) |
| Authors | Prithvi Rajasekaran, Alexander Bricken |

### Description

Generates distinctive, production-grade frontend interfaces that avoid generic AI aesthetics. Automatically applied when working on frontend tasks.

### What It Does

Creates production-ready code with:
- Bold aesthetic choices
- Distinctive typography and color palettes
- High-impact animations and visual details
- Context-aware implementation

### Usage

Simply describe your frontend design needs:

```
"Create a dashboard for a music streaming app"
"Build a landing page for an AI security startup"
"Design a settings panel with dark mode"
```

Claude will choose a clear aesthetic direction and implement production code with meticulous attention to detail.

### Resources

- [Frontend Aesthetics Cookbook](https://github.com/anthropics/claude-cookbooks/blob/main/coding/prompting_for_frontend_aesthetics.ipynb)

---

## 8. hookify

**Hookify Plugin**

| Property | Value |
|----------|-------|
| GitHub | [plugins/hookify](https://github.com/anthropics/claude-code/tree/main/plugins/hookify) |

### Description

Easily create custom hooks to prevent unwanted behaviors by analyzing conversation patterns or from explicit instructions. Uses simple markdown configuration files instead of complex JSON.

### Commands

| Command | Description |
|---------|-------------|
| `/hookify` | Create custom hooks (with or without arguments) |
| `/hookify:list` | List all active rules |
| `/hookify:configure` | Enable/disable existing rules |
| `/hookify:help` | Get help documentation |

### Usage

```bash
# Create from explicit instruction
/hookify Don't use console.log in TypeScript files

# Analyze conversation for patterns
/hookify

# List active rules
/hookify:list
```

### Rule Configuration Format

```markdown
---
name: block-dangerous-rm
enabled: true
event: bash
pattern: rm\s+-rf
action: block
---

Warning message here...
```

### Event Types

| Event | Triggers On |
|-------|-------------|
| `bash` | Bash tool commands |
| `file` | Edit, Write, MultiEdit tools |
| `stop` | Claude wants to stop |
| `prompt` | User prompt submission |
| `all` | All events |

### Pattern Examples

| Pattern | Matches |
|---------|---------|
| `rm\s+-rf` | rm -rf commands |
| `console\.log\(` | console.log() calls |
| `\.env$` | Files ending in .env |
| `chmod\s+777` | chmod 777 commands |

### Requirements

- Python 3.7+ (no external dependencies)

---

## 9. learning-output-style

**Learning Style Plugin**

| Property | Value |
|----------|-------|
| GitHub | [plugins/learning-output-style](https://github.com/anthropics/claude-code/tree/main/plugins/learning-output-style) |

### Description

Combines Learning output style with explanatory functionality. Transforms interaction from passive observation to active participation by requesting meaningful code contributions at decision points.

**Warning**: Incurs additional token cost due to interactive nature.

### How It Works

Instead of implementing everything automatically, Claude will:
- Identify opportunities for you to write 5-10 lines of meaningful code
- Focus on business logic and design choices where input matters
- Prepare context and location for contribution
- Explain trade-offs and guide implementation
- Provide educational insights

### When Claude Requests Contributions

- Business logic with multiple valid approaches
- Error handling strategies
- Algorithm implementation choices
- Data structure decisions
- User experience decisions
- Design patterns and architecture

### When Claude Won't Request Contributions

- Boilerplate or repetitive code
- Obvious implementations
- Configuration or setup code
- Simple CRUD operations

### Example Interaction

```
Claude: I've set up the authentication middleware. The session timeout
behavior is a security vs. UX trade-off - should sessions auto-extend
on activity, or have a hard timeout?

In auth/middleware.ts, implement the handleSessionTimeout() function.

You: [Write 5-10 lines implementing your approach]
```

---

## 10. plugin-dev

**Plugin Development Toolkit**

| Property | Value |
|----------|-------|
| GitHub | [plugins/plugin-dev](https://github.com/anthropics/claude-code/tree/main/plugins/plugin-dev) |
| Author | Daisy Hollman (daisy@anthropic.com) |
| Version | 0.1.0 |

### Description

Comprehensive toolkit for developing Claude Code plugins with expert guidance on hooks, MCP integration, plugin structure, and marketplace publishing.

### Commands

| Command | Description |
|---------|-------------|
| `/plugin-dev:create-plugin` | End-to-end workflow for creating plugins from scratch |

### Core Skills

1. **Hook Development** - Advanced hooks API and event-driven automation
2. **MCP Integration** - Model Context Protocol server integration
3. **Plugin Structure** - Plugin organization and manifest configuration
4. **Plugin Settings** - Configuration patterns using `.local.md` files
5. **Command Development** - Creating slash commands with frontmatter
6. **Agent Development** - Creating autonomous agents
7. **Skill Development** - Creating skills with progressive disclosure

### Create Plugin Workflow (8 Phases)

1. **Discovery** - Understand plugin purpose and requirements
2. **Component Planning** - Determine needed skills, commands, agents, hooks, MCP
3. **Detailed Design** - Specify each component
4. **Structure Creation** - Set up directories and manifest
5. **Component Implementation** - Create components
6. **Validation** - Run plugin-validator
7. **Testing** - Verify in Claude Code
8. **Documentation** - Finalize README

### Usage

```bash
/plugin-dev:create-plugin

# Or with description
/plugin-dev:create-plugin A plugin for managing database migrations
```

### Content

- ~11,065 words of core skills
- 10,000+ words of references
- 12+ complete examples
- 6 production-ready validation scripts

---

## 11. pr-review-toolkit

**PR Review Toolkit Plugin**

| Property | Value |
|----------|-------|
| GitHub | [plugins/pr-review-toolkit](https://github.com/anthropics/claude-code/tree/main/plugins/pr-review-toolkit) |

### Description

Comprehensive collection of 6 specialized agents for thorough pull request review, covering comments, tests, error handling, types, quality, and simplification.

### Agents

| Agent | Focus |
|-------|-------|
| `comment-analyzer` | Code comment accuracy and maintainability |
| `pr-test-analyzer` | Test coverage quality and gaps |
| `silent-failure-hunter` | Error handling and silent failures |
| `type-design-analyzer` | Type design quality and invariants |
| `code-reviewer` | General code quality and CLAUDE.md compliance |
| `code-simplifier` | Code simplification and refactoring |

### Usage

```bash
# Individual agent triggers
"Can you check if the tests cover all edge cases?"
"Review the error handling in the API client"
"I've added documentation - is it accurate?"

# Comprehensive review
"I'm ready to create this PR. Please:
1. Review test coverage
2. Check for silent failures
3. Verify code comments are accurate
4. Review any new types
5. General code review"
```

### Recommended Workflow

1. Write code -> `code-reviewer`
2. Fix issues -> `silent-failure-hunter` (if error handling)
3. Add tests -> `pr-test-analyzer`
4. Document -> `comment-analyzer`
5. Polish -> `code-simplifier`
6. Create PR

---

## 12. ralph-wiggum

**Ralph Wiggum Plugin**

| Property | Value |
|----------|-------|
| GitHub | [plugins/ralph-wiggum](https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum) |

### Description

Implementation of the Ralph Wiggum technique for iterative, self-referential AI development loops. Enables continuous AI agent loops that allow Claude to autonomously iterate and improve work.

### Core Concept

"Ralph is a Bash loop" - a `while true` that repeatedly feeds an AI agent a prompt, allowing it to iteratively improve until completion. Uses a Stop hook to intercept exit attempts and feed the prompt back.

### Commands

| Command | Description |
|---------|-------------|
| `/ralph-loop` | Start a Ralph loop |
| `/cancel-ralph` | Cancel the active loop |

### Usage

```bash
/ralph-loop "<prompt>" --max-iterations <n> --completion-promise "<text>"

# Example
/ralph-loop "Build a REST API for todos. Requirements: CRUD operations,
input validation, tests. Output <promise>COMPLETE</promise> when done."
--completion-promise "COMPLETE" --max-iterations 50
```

### Prompt Best Practices

1. **Clear Completion Criteria**
   ```
   When complete:
   - All CRUD endpoints working
   - Tests passing (coverage > 80%)
   - Output: <promise>COMPLETE</promise>
   ```

2. **Incremental Goals**
   ```
   Phase 1: User authentication
   Phase 2: Product catalog
   Phase 3: Shopping cart
   Output <promise>COMPLETE</promise> when all phases done.
   ```

3. **Escape Hatches**
   Always use `--max-iterations` as safety net

### When to Use

**Good for**:
- Well-defined tasks with clear success criteria
- Tasks requiring iteration (getting tests to pass)
- Greenfield projects
- Tasks with automatic verification

**Not good for**:
- Tasks requiring human judgment
- One-shot operations
- Unclear success criteria
- Production debugging

### Real-World Results

- 6 repositories generated overnight in hackathon testing
- $50k contract completed for $297 in API costs
- Created entire programming language using this approach

---

## 13. security-guidance

**Security Guidance Plugin**

| Property | Value |
|----------|-------|
| GitHub | [plugins/security-guidance](https://github.com/anthropics/claude-code/tree/main/plugins/security-guidance) |
| Author | David Dworken (dworken@anthropic.com) |
| Version | 1.0.0 |

### Description

Security reminder hook that alerts developers to potential vulnerabilities during file editing. Monitors for command injection, cross-site scripting (XSS), and other problematic code patterns.

### How It Works

Uses a PreToolUse hook to monitor file operations and warn about security patterns including:

- Command injection vulnerabilities
- Cross-site scripting (XSS)
- SQL injection patterns
- Insecure deserialization
- Hardcoded credentials
- Insecure randomness
- Path traversal
- Unsafe redirects
- Missing input validation

### Monitored Patterns

The plugin monitors approximately 9 security patterns:
1. Shell command construction with user input
2. HTML output without sanitization
3. SQL query string concatenation
4. Pickle/eval with untrusted data
5. Hardcoded secrets/credentials
6. Math.random() for security purposes
7. File path construction with user input
8. URL redirects with user-controlled destinations
9. Missing validation on user inputs

### Usage

Once installed, runs automatically on file edits. No commands required.

---

## Quick Reference

### By Use Case

| Use Case | Plugin |
|----------|--------|
| Start new Agent SDK project | agent-sdk-dev |
| Migrate to Opus 4.5 | claude-opus-4-5-migration |
| Automated PR review | code-review, pr-review-toolkit |
| Git workflow automation | commit-commands |
| Build new features | feature-dev |
| Frontend development | frontend-design |
| Create custom hooks | hookify |
| Learn while coding | learning-output-style |
| Educational explanations | explanatory-output-style |
| Create new plugins | plugin-dev |
| Autonomous iteration | ralph-wiggum |
| Security awareness | security-guidance |

### By Component Type

| Component | Plugins |
|-----------|---------|
| Commands | agent-sdk-dev, code-review, commit-commands, feature-dev, hookify, plugin-dev, ralph-wiggum |
| Agents | agent-sdk-dev, feature-dev, pr-review-toolkit |
| Skills | claude-opus-4-5-migration, frontend-design, plugin-dev |
| Hooks | explanatory-output-style, learning-output-style, ralph-wiggum, security-guidance, hookify |

---

*Last updated: January 2026*
*Source: https://github.com/anthropics/claude-code/tree/main/plugins*
