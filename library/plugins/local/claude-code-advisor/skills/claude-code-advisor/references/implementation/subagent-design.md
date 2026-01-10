# Subagent Design Guide

Step-by-step guide to creating effective Claude Code subagents.

## Step 1: Determine If You Need a Subagent

Ask yourself:
- Do I need **isolated context**? (heavy work shouldn't bloat main)
- Do I need **parallel processing**?
- Do I need **different tool access** or model?

If yes to any → use subagent.
If no → just use main conversation or skill.

## Step 2: Create Agent File

```bash
mkdir -p .claude/agents
```

Create `.claude/agents/my-agent.md`.

## Step 3: Write Agent Configuration

### Template

```yaml
---
name: my-agent-name
description: Clear description of when to invoke. Use proactively when [condition].
tools: Read, Grep, Glob, Bash  # Tools this agent can use
model: sonnet                   # sonnet|opus|haiku|inherit
permissionMode: default         # Permission handling
skills: skill-1, skill-2        # Pre-load these skills
---

# Agent System Prompt

You are a [role] specializing in [domain].

## Your Task
[Clear task description]

## Process
1. [Step 1]
2. [Step 2]
3. [Step 3]

## Output Format
[What to return to main conversation]
```

### Configuration Fields

| Field | Required | Options |
|-------|----------|---------|
| `name` | Yes | Lowercase, hyphens |
| `description` | Yes | Include "proactively" for auto-invoke |
| `tools` | No | Tool names (inherits all if omitted) |
| `model` | No | `sonnet` (default), `opus`, `haiku`, `inherit` |
| `permissionMode` | No | `default`, `acceptEdits`, `dontAsk`, `bypassPermissions` |
| `skills` | No | Comma-separated skill names |

## Step 4: Choose the Right Model

| Model | Use When |
|-------|----------|
| **haiku** | Fast searches, simple tasks, low cost |
| **sonnet** | Default balance of speed/quality |
| **opus** | Complex reasoning, synthesis, critical tasks |
| **inherit** | Match main conversation model |

## Step 5: Configure Tools

Restrict tools for focused agents:

```yaml
# Read-only explorer
tools: Read, Grep, Glob

# Full access reviewer
tools: Read, Grep, Glob, Bash, Edit, Write

# Search-focused
tools: Grep, Glob
```

## Step 6: Pre-load Skills (If Needed)

Subagents DON'T inherit skills from main. Pre-load them:

```yaml
skills: security-checks, coding-standards
```

The skill must exist in `.claude/skills/` or `~/.claude/skills/`.

## Example Agents

### Explorer Agent
```yaml
---
name: code-explorer
description: Fast codebase search. Use proactively when exploring code structure.
tools: Read, Grep, Glob
model: haiku
---

You are a code explorer. Quickly find relevant files and code patterns.
Respond with file paths and brief descriptions.
```

### Reviewer Agent
```yaml
---
name: code-reviewer
description: Thorough code review. Use when reviewing PRs or significant changes.
tools: Read, Grep, Glob
model: sonnet
skills: coding-standards, security-checks
---

You are a senior code reviewer. Check for:
1. Code quality and patterns
2. Security issues
3. Performance concerns

Provide specific line-by-line feedback.
```

### Researcher Agent
```yaml
---
name: deep-researcher
description: In-depth research. Use when thorough investigation is needed.
tools: Read, Grep, Glob, Bash, WebFetch
model: opus
---

You are a research specialist. Conduct thorough investigation.
Synthesize findings into actionable insights.
```

## Step 7: Test Your Agent

1. **Manual invocation**:
   ```
   > Use the code-reviewer agent to check my auth module
   ```

2. **Auto-invocation** (if "proactively" in description):
   ```
   > I just made some changes, can you review them?
   ```

3. **Resume test**:
   ```
   > Resume agent [id] and continue with [follow-up]
   ```

## Checklist Before Deployment

- [ ] `name` is unique and descriptive
- [ ] `description` is clear (includes "proactively" if auto-invoke)
- [ ] `model` matches task complexity
- [ ] `tools` are restricted appropriately
- [ ] `skills` are listed if needed
- [ ] System prompt is clear and focused

See also:
- `../feature-mechanics/subagents-deep-dive.md` for mechanics
- `../decision-guides/skills-vs-subagents.md` for when to use
