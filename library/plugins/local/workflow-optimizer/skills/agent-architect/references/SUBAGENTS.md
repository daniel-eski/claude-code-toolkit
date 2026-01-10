# Subagents Reference

Complete reference for Claude Code custom subagents.

## What Are Subagents?

Subagents are specialized agents with:
- Isolated context (separate conversation history)
- Custom tool access
- Optional different model
- Custom system prompt

Use them for tasks that benefit from focused context or specialized behavior.

## File Structure

Subagents are single markdown files with YAML frontmatter:

```
.claude/agents/[agent-name].md
```

**Locations:**
- Personal: `~/.claude/agents/[name].md` (all projects)
- Project: `.claude/agents/[name].md` (team-shared via git)

## YAML Frontmatter

```yaml
---
name: agent-name
description: When to delegate to this agent (Claude uses this to decide)
tools: Read, Edit, Bash, Grep, Glob
model: sonnet
permissionMode: default
skills: code-review, security-check
hooks:
  PreToolUse:
    - matcher: "Edit|Write"
      hooks:
        - type: command
          command: "./scripts/lint.sh"
---

Your system prompt here.

Define the agent's role, capabilities, approach, and constraints.
```

## Field Reference

### Required Fields

| Field | Description | Constraints |
|-------|-------------|-------------|
| `name` | Unique identifier | Lowercase, alphanumeric + hyphens |
| `description` | When to use this agent | Natural language, specific triggers |

### Optional Fields

| Field | Description | Values |
|-------|-------------|--------|
| `tools` | Available tools | Comma-separated; omit to inherit all |
| `model` | Model to use | `inherit`, `sonnet`, `opus`, `haiku`, or model ID |
| `permissionMode` | Permission behavior | See Permission Modes below |
| `skills` | Skills to load | Comma-separated; does NOT inherit from parent |
| `hooks` | Agent-scoped hooks | PreToolUse, PostToolUse, Stop |

## Permission Modes

| Mode | Behavior |
|------|----------|
| `default` | Normal permission prompts |
| `acceptEdits` | Auto-accept file edits, prompt for others |
| `dontAsk` | No prompts (within allowed permissions) |
| `bypassPermissions` | No restrictions (use carefully) |
| `plan` | Read-only mode |
| `ignore` | Skip this agent |

## tools Syntax

```yaml
# Inherit all tools from main agent
tools: (omit field)

# Specific tools only
tools: Read, Edit, Bash, Grep, Glob

# Bash with patterns
tools: Read, Bash(npm:*), Bash(git:*)
```

**Available tools:**
- `Read`, `Write`, `Edit` — File operations
- `Grep`, `Glob` — Search
- `Bash` — Shell commands
- `WebFetch`, `WebSearch` — Web access
- `Task` — Spawn nested subagents

## skills Field

**Important:** Skills do NOT inherit from parent agent. You must explicitly list needed skills:

```yaml
skills: code-review, security-check
```

## Agent-Scoped Hooks

Subagents can define hooks that only apply during their execution:

```yaml
hooks:
  PostToolUse:
    - matcher: "Edit|Write"
      hooks:
        - type: command
          command: "npm run lint"
          timeout: 30
```

## Built-In Agents

Claude Code includes these built-in agents:

| Agent | Purpose | Model | Tools |
|-------|---------|-------|-------|
| `Plan` | Read-only research in plan mode | Sonnet | Read, Glob, Grep, Bash |
| `Explore` | Fast codebase search | Haiku | Glob, Grep, Read |
| `general-purpose` | Multi-step tasks with modifications | Sonnet | All tools |

## CLI Configuration

Agents can also be configured via CLI:

```bash
claude --agents '{
  "code-reviewer": {
    "description": "Expert code reviewer",
    "prompt": "You are a senior code reviewer...",
    "tools": ["Read", "Grep", "Glob", "Bash"],
    "model": "sonnet"
  }
}'
```

## System Prompt Best Practices

The content below the frontmatter is the agent's system prompt:

```markdown
---
name: debugger
description: Debug errors and test failures systematically
tools: Read, Edit, Bash, Grep, Glob
---

You are an expert debugger. Your approach:

## Process
1. **Capture** — Get exact error and stack trace
2. **Isolate** — Find minimal reproduction
3. **Hypothesize** — List possible causes by likelihood
4. **Test** — Verify or eliminate each hypothesis
5. **Fix** — Minimal change for root cause
6. **Verify** — Confirm fix works

## Guidelines
- Fix root causes, not symptoms
- Prefer minimal, targeted fixes
- Check for similar patterns elsewhere

## Output Format
For each issue:
- **Root cause:** [explanation]
- **Fix:** [what was changed]
- **Verification:** [how confirmed]
```

**Tips:**
- Be specific about the process
- Define output format
- Include constraints and guidelines
- Keep focused on the agent's specialty

## When to Use Subagents vs Skills

| Need | Use |
|------|-----|
| Isolated context for focused task | Subagent |
| Specialized knowledge/instructions | Either |
| Different tool access | Subagent |
| Different model | Subagent |
| Auto-discovered capability | Skill |
| Reusable across projects | Skill |

**Key difference:** Subagents get isolated context. Skills add to current context.

## Agent Templates

For ready-to-use agent configurations, see:

- [templates/agents/](../templates/agents/) — Complete agent templates organized by category:
  - **Development**: debugger, test-runner, implementer
  - **Review**: code-reviewer, security-auditor
  - **Research**: researcher
  - **Non-coding**: documentation-writer, project-manager, technical-writer
  - **Orchestration**: multi-agent patterns
