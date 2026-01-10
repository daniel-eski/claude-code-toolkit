# Usage Guide

Learn how to get the most out of the Claude Code Advisor plugin.

## Getting Started

After installation, you have access to:
- **4 slash commands** for explicit actions
- **The claude-code-advisor skill** that auto-triggers when discussing Claude Code features

You can either use the commands directly or just ask questions about Claude Code—the skill will activate automatically when relevant.

---

## The Commands

### /cc-advisor - Get Expert Advice

**When to use:** General questions about Claude Code features, best practices, or architectural decisions.

**Example 1: Feature comparison**
```
/cc-advisor "I want to add linting after every file write. Should I use a hook or a skill?"

Response:
For automated reactions to specific events, **hooks are the right choice**.

Here's why:
- Hooks are event-driven—they trigger on PostToolUse for Write/Edit
- Skills require semantic triggering from conversation content
- Your use case is "every time X happens, do Y" → that's a hook pattern

**Implementation:**
Add to `.claude/settings.json`:
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "command",
        "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/lint.sh"
      }]
    }]
  }
}

See: references/feature-mechanics/hooks-deep-dive.md for full details
```

**Example 2: Architecture question**
```
/cc-advisor "What's the difference between putting guidance in CLAUDE.md vs a skill?"

Response:
The key distinction is **loading behavior**:

**CLAUDE.md (Memory)**
- Loads automatically every session
- Content is always in context
- Use for: Project context, coding standards, team conventions
- Cost: Consumes tokens every conversation

**Skills**
- Load only when triggered by description match
- Content loads on-demand
- Use for: Specialized workflows, domain expertise
- Cost: Only consumes tokens when relevant

**Rule of thumb:** If Claude needs it every session → CLAUDE.md
If Claude needs it sometimes → Skill

See: references/decision-guides/memory-vs-skills.md
```

**Good questions for /cc-advisor:**
- "What's the difference between skills and subagents?"
- "When should I use a hook vs a skill?"
- "How do MCP servers compare to hooks?"
- "What are the best practices for skill descriptions?"

---

### /cc-analyze - Audit Your Configuration

**When to use:** Review an existing Claude Code setup for issues, improvements, or understanding.

**Example:**
```
/cc-analyze

Response:
## Configuration Inventory

### Memory (CLAUDE.md)
- `/CLAUDE.md`: Found (~1,200 tokens) - Project overview and coding standards
- `/src/CLAUDE.md`: Found (~400 tokens) - Source directory context

### Skills
| Skill | Description | Status |
|-------|-------------|--------|
| code-helper | "Helps with code" | ⚠️ Vague |
| api-docs | "Generates API documentation for TypeScript projects" | ✓ Good |

### Hooks
| Event | Matcher | Action |
|-------|---------|--------|
| PostToolUse | Write | Run prettier |

### MCP Servers
None configured.

---

## Issues Identified

### Warning: Vague Skill Description
**File:** `.claude/skills/code-helper/SKILL.md`
**Issue:** Description "Helps with code" is too vague to trigger reliably
**Fix:** Change to something specific like "Assists with Python code reviews,
identifying bugs, performance issues, and suggesting improvements"

### Suggestion: Consider Memory Hierarchy
**Observation:** You have directory-specific context in CLAUDE.md files
**Opportunity:** Good pattern! Consider adding CLAUDE.md files to other
key directories like `/tests/` or `/docs/`

---

## Recommendations

1. **High Priority:** Update code-helper skill description
2. **Medium Priority:** Add CLAUDE.md to test directory
3. **Low Priority:** Consider adding pre-commit hook for tests
```

**Use /cc-analyze when:**
- Setting up a new project and want to check your config
- Inheriting a project with existing Claude Code setup
- Periodically auditing configuration drift
- Debugging why Claude isn't behaving as expected

---

### /cc-verify - Fact-Check Your Understanding

**When to use:** Before making architectural decisions based on assumptions about how Claude Code works.

**Example 1: Verify a claim**
```
/cc-verify "subagents can spawn other subagents"

Response:
CLAIM: Subagents can spawn other subagents

VERDICT: CONFIRMED (with caveats)

EVIDENCE:
Source: https://code.claude.com/docs/subagents
Quote: "Subagents can spawn their own subagents, creating a hierarchy
of specialized workers."

EXPLANATION:
Subagents can indeed spawn other subagents. However:
- Each level has its own isolated context
- Deep nesting can be hard to manage
- Parent agents don't see child agent context

CURRENT BEHAVIOR:
A subagent uses the Task tool just like the main conversation.
The nested subagent is a fresh context with no inherited state.

RECOMMENDATION:
Use sparingly. Often better to have main conversation coordinate
multiple subagents than create deep hierarchies.
```

**Example 2: Verify behavior**
```
/cc-verify "skills automatically inherit into subagents"

Response:
CLAIM: Skills automatically inherit into subagents

VERDICT: REFUTED

EVIDENCE:
Source: https://code.claude.com/docs/subagents
Quote: "Subagents do not inherit active skills from the main conversation.
Skills must be explicitly listed in the agent's skills field."

EXPLANATION:
Subagents start with a fresh context. Skills active in the main
conversation are NOT available to subagents unless you explicitly
specify them in the agent definition.

CURRENT BEHAVIOR:
To give a subagent access to a skill:

---
name: my-agent
skills: skill-name-1, skill-name-2
---

The skills must exist in .claude/skills/ or ~/.claude/skills/
```

**Use /cc-verify when:**
- You've heard something about Claude Code and want to confirm
- Documentation might have changed since you last checked
- Making important architectural decisions
- Debugging unexpected behavior

---

### /cc-design - Design a New Configuration

**When to use:** Planning a Claude Code architecture for specific goals.

**Example:**
```
/cc-design "I want Claude to enforce our team's coding standards and
run tests before commits"

Response:
## Architecture Design for: Code Standards Enforcement

### Requirements Analysis
- Enforce coding standards: Continuous (every code change)
- Run tests before commits: Triggered (pre-commit)
- Scope: Project-specific

### Recommended Architecture

#### 1. Memory Configuration (CLAUDE.md)
**Location:** Project root
**Purpose:** Coding standards available every session

Content:
- Team style guide summary
- Naming conventions
- Architecture patterns to follow
- Common mistakes to avoid

**Estimated tokens:** ~800

#### 2. Hooks Configuration

| Event | Matcher | Action | Purpose |
|-------|---------|--------|---------|
| PostToolUse | `Write\|Edit` | Run linter | Auto-format on save |
| PreToolUse | `Bash` + `git commit` | Run tests | Block bad commits |

**Implementation:**
```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "command",
        "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/lint.sh",
        "timeout": 30
      }]
    }],
    "PreToolUse": [{
      "matcher": "Bash",
      "hooks": [{
        "type": "command",
        "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/pre-commit.sh"
      }]
    }]
  }
}
```

#### 3. No Skills Needed
Your use case is enforcement (hooks) + context (memory).
Skills would be appropriate if you needed reusable review workflows.

### Why This Design

- **Standards in CLAUDE.md:** Needed every session, not triggered
- **Hooks for enforcement:** Automatic, event-driven, consistent
- **No skills:** Not a triggered workflow, just enforcement

### Implementation Order

1. Create CLAUDE.md with coding standards (~30 min)
2. Create lint.sh hook script (~15 min)
3. Create pre-commit.sh hook script (~15 min)
4. Add hooks to settings.json (~5 min)
5. Test each component individually

### Testing Plan

- [ ] Write a file with style violations → lint.sh corrects it
- [ ] Attempt commit with failing tests → pre-commit.sh blocks it
- [ ] Ask Claude about standards → references CLAUDE.md content
```

**Use /cc-design when:**
- Starting a new Claude Code configuration from scratch
- Adding significant new capabilities
- Refactoring an existing setup
- Unsure which features to combine

---

## Tips for Best Results

### 1. Be Specific in Questions

**Less effective:**
> "What should I use?"

**More effective:**
> "Should I use a skill or subagent for code review that reads many files?"

Specific scenarios get specific recommendations.

### 2. Verify Before Building

If you're making an architectural decision based on an assumption:

```
/cc-verify "hooks can modify the tool input before execution"
```

Better to spend 10 seconds verifying than hours debugging.

### 3. Analyze Periodically

Run `/cc-analyze` on your projects occasionally. Configuration drift happens, and it catches:
- Skills with descriptions that no longer match their content
- Hooks that might conflict
- Memory that's grown too large

### 4. Let /cc-design Ask Questions

The design command works best when it can clarify requirements. Don't try to specify everything upfront—let it ask what it needs.

---

## What This Plugin Doesn't Do

Be aware of limitations:

- **Execute configurations** - It advises and generates, but you implement
- **Access your actual setup** - `/cc-analyze` reads files, but can't test runtime behavior
- **Guarantee correctness** - Grounded in docs, but documentation can change
- **Replace understanding** - Use it to learn, not to blindly copy

The plugin makes you more effective at Claude Code configuration—it doesn't do the configuration for you.

---

## Quick Reference

| Goal | Command |
|------|---------|
| General advice | `/cc-advisor "question"` |
| Audit existing setup | `/cc-analyze` |
| Fact-check a claim | `/cc-verify "claim"` |
| Design new config | `/cc-design "goal"` |

---

## Next Steps

- [README](README.md) - Overview of the plugin
- [Installation](INSTALLATION.md) - Setup and troubleshooting
- [Changelog](CHANGELOG.md) - What's new
