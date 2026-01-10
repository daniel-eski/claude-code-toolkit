# Claude Code Workflow Optimization Implementation Guide

This guide documents the workflow optimization system designed to maximize Claude Code's meta-cognitive capabilities for planning, execution, and continuous improvement.

---

## Table of Contents

1. [System Overview](#system-overview)
2. [Component Reference](#component-reference)
3. [Usage Instructions](#usage-instructions)
4. [Verification Tests](#verification-tests)
5. [Customization Guide](#customization-guide)
6. [Troubleshooting](#troubleshooting)

---

## System Overview

### Design Philosophy

This system addresses a core gap: Claude Code's default behavior doesn't include structured meta-cognition for ambiguous tasks. The solution implements three layers:

```
┌─────────────────────────────────────────────────────────────┐
│  Layer 3: EXPLICIT INVOCATION                               │
│  /kickoff, /reflect commands                                │
│  User triggers structured planning or reflection            │
├─────────────────────────────────────────────────────────────┤
│  Layer 2: AUTO-INVOKED CAPABILITIES                         │
│  workflow-reflection skill                                  │
│  Claude automatically uses when context matches             │
├─────────────────────────────────────────────────────────────┤
│  Layer 1: FOUNDATIONAL BEHAVIOR (Always Active)             │
│  CLAUDE.md instructions                                     │
│  Shapes Claude's default behavior every session             │
└─────────────────────────────────────────────────────────────┘
```

### What Was Created

| Component | Location | Purpose |
|-----------|----------|---------|
| CLAUDE.md | `~/.claude/CLAUDE.md` | Core behavioral instructions (always loaded) |
| workflow-reflection | `~/.claude/skills/workflow-reflection/` | Post-task optimization analysis |
| /kickoff | `~/.claude/commands/kickoff.md` | Explicit structured planning |
| /reflect | `~/.claude/commands/reflect.md` | Explicit reflection trigger |

### Interaction Model

```
Short/Ambiguous Prompt → CLAUDE.md triggers planning protocol → Alignment → Execution
                                                                      ↓
                                                           Significant work completed
                                                                      ↓
                                                    Claude offers reflection (CLAUDE.md)
                                                           or
                                                    User invokes /reflect
                                                                      ↓
                                                    workflow-reflection skill activates
                                                                      ↓
                                                    Optimization recommendations
                                                                      ↓
                                                    User implements selected optimizations
                                                                      ↓
                                                    Improved future workflows
```

---

## Component Reference

### 1. CLAUDE.md (Foundational Behavior)

**Location**: `~/.claude/CLAUDE.md`

**Function**: Loaded automatically at session start, shapes Claude's default behavior.

**Key Behaviors Configured**:

| Behavior | Trigger | What Claude Does |
|----------|---------|------------------|
| Planning Protocol | Short/ambiguous prompts (<50 words) | Restates understanding, identifies unknowns, proposes approaches, seeks alignment |
| Context-Seeking | Before significant changes | Checks for existing patterns, documentation, tests |
| Reflection Trigger | After substantial work | Offers to analyze workflow for optimizations |
| Communication Style | Always | Direct, recommendation-led, concrete |

**When It Activates**: Every Claude Code session, automatically.

**When It Doesn't Apply**: Simple, unambiguous requests (Claude proceeds directly).

---

### 2. workflow-reflection Skill

**Location**: `~/.claude/skills/workflow-reflection/SKILL.md`

**Function**: Provides comprehensive workflow analysis and generates concrete optimization recommendations.

**Auto-Invocation Triggers** (phrases in your prompt that activate it):
- "reflect on what we did"
- "how can we improve this workflow"
- "optimize for next time"
- "make similar tasks faster"
- "what would help in the future"

**Output Structure**:
1. Session Summary
2. What Worked Well
3. Friction Points Identified
4. Recommended Optimizations (with exact implementation code)
5. Implementation Priority

**Recommendation Types Generated**:
- CLAUDE.md additions
- Custom slash commands
- Custom skills
- Hooks for automation

---

### 3. /kickoff Command

**Location**: `~/.claude/commands/kickoff.md`

**Function**: Explicit invocation of structured planning before task execution.

**Usage**: `/kickoff [task description]`

**Example**:
```
/kickoff implement user authentication with OAuth2 and session management
```

**What Claude Does**:
1. Restates task understanding
2. Assesses available context
3. Presents 2-3 approach options with tradeoffs
4. Flags concerns and risks
5. Requests explicit alignment before proceeding

**When to Use**:
- Complex multi-file changes
- Architectural decisions
- Unfamiliar codebases
- When you want guaranteed alignment before work begins

---

### 4. /reflect Command

**Location**: `~/.claude/commands/reflect.md`

**Function**: Explicitly triggers workflow reflection (invokes the workflow-reflection skill).

**Usage**:
- `/reflect` - Comprehensive reflection
- `/reflect [focus area]` - Focused reflection on specific aspect

**Examples**:
```
/reflect
/reflect the debugging process
/reflect file discovery patterns
```

**When to Use**:
- After completing significant work
- When you feel a workflow could be improved
- Before starting a similar task to capture learnings

---

## Usage Instructions

### Session Start Behavior

When you start a new Claude Code session:

1. **CLAUDE.md loads automatically** - No action needed
2. **Skills are available** - Type "What skills are available?" to confirm
3. **Commands are available** - Type `/help` to see kickoff and reflect listed

### Recommended Workflow Patterns

#### Pattern A: Quick Task (Unambiguous)
```
You: fix the typo on line 42 of auth.ts
Claude: [Proceeds directly - no planning needed]
```

#### Pattern B: Ambiguous Task (Auto-Planning)
```
You: improve the authentication
Claude: [CLAUDE.md triggers]
        "Let me make sure I understand: you want to improve the authentication system.
         Before I explore, I have some questions:
         1. What specific aspects - security, UX, performance?
         2. Are there known issues you want addressed?
         ..."
```

#### Pattern C: Complex Task (Explicit Planning)
```
You: /kickoff implement a new caching layer for the API
Claude: [Follows full kickoff protocol]
        "## Understanding Check
         You want to add caching to reduce API response times...

         ## Approach Options
         1. In-memory with Redis...
         2. HTTP cache headers...
         3. Application-level memoization...

         ## My Recommendation: Option 1 because...

         ## Concerns
         - Cache invalidation strategy needed...

         Shall I proceed with Option 1?"
```

#### Pattern D: Post-Task Optimization
```
[After completing significant work]
Claude: "Would you like me to reflect on this workflow to identify potential optimizations?"
You: yes

[Or explicitly:]
You: /reflect
Claude: [Analyzes session, generates recommendations]
```

### Quick Reference Card

| Situation | Action |
|-----------|--------|
| Simple, clear task | Just ask - Claude proceeds directly |
| Vague or complex task | Claude auto-triggers planning (CLAUDE.md) |
| Want guaranteed planning | Use `/kickoff [task]` |
| After significant work | Claude offers reflection, or use `/reflect` |
| Want focused reflection | Use `/reflect [specific aspect]` |
| Check available tools | "What skills are available?" or `/help` |

---

## Verification Tests

### Test 1: CLAUDE.md Planning Protocol

**Purpose**: Verify short prompts trigger planning behavior.

**Steps**:
1. Start a new Claude Code session (or `/clear`)
2. Enter: `improve the code`

**Expected Behavior**:
- Claude should NOT immediately start making changes
- Claude SHOULD restate what it understands
- Claude SHOULD ask clarifying questions
- Claude SHOULD seek alignment before proceeding

**Pass Criteria**: Claude asks for clarification rather than acting immediately.

---

### Test 2: CLAUDE.md Direct Execution

**Purpose**: Verify unambiguous requests bypass planning.

**Steps**:
1. In any session, enter: `what time is it`

**Expected Behavior**:
- Claude should answer directly without planning protocol

**Pass Criteria**: No unnecessary planning steps for simple requests.

---

### Test 3: Skill Availability

**Purpose**: Verify workflow-reflection skill is loaded.

**Steps**:
1. Start a new Claude Code session
2. Enter: `What skills are available?`

**Expected Behavior**:
- List should include `workflow-reflection`
- Description should mention workflow optimization

**Pass Criteria**: Skill appears in available skills list.

---

### Test 4: Skill Auto-Invocation

**Purpose**: Verify skill activates on matching phrases.

**Steps**:
1. Complete some work in a session (even simple file reads)
2. Enter: `how can we improve this workflow for next time?`

**Expected Behavior**:
- Claude should invoke the workflow-reflection skill
- Output should follow the structured format (Session Summary, What Worked, etc.)

**Pass Criteria**: Structured reflection output with optimization recommendations.

---

### Test 5: /kickoff Command

**Purpose**: Verify kickoff command provides structured planning.

**Steps**:
1. Enter: `/kickoff add dark mode support to the application`

**Expected Behavior**:
- Claude follows the 5-step kickoff protocol
- Presents approach options
- Waits for alignment before proceeding

**Pass Criteria**: All 5 steps visible, Claude waits for confirmation.

---

### Test 6: /reflect Command

**Purpose**: Verify reflect command triggers reflection.

**Steps**:
1. Do some work in a session
2. Enter: `/reflect`

**Expected Behavior**:
- Comprehensive reflection on session work
- Concrete optimization recommendations

**Pass Criteria**: Structured output with actionable recommendations.

---

### Test 7: /reflect with Focus

**Purpose**: Verify focused reflection works.

**Steps**:
1. Enter: `/reflect the file discovery process`

**Expected Behavior**:
- Reflection focused specifically on file discovery
- Recommendations related to that aspect

**Pass Criteria**: Focused rather than comprehensive reflection.

---

### Test 8: Commands in /help

**Purpose**: Verify commands appear in help.

**Steps**:
1. Enter: `/help`

**Expected Behavior**:
- `kickoff` should appear with "(user)" designation
- `reflect` should appear with "(user)" designation

**Pass Criteria**: Both commands visible in help output.

---

## Customization Guide

### Adding Project-Specific Instructions

Create `.claude/CLAUDE.md` in your project root:

```markdown
# Project: [Name]

## Tech Stack
- Frontend: React/TypeScript
- Backend: Node.js/Express
- Database: PostgreSQL

## Conventions
- Use functional components with hooks
- API endpoints follow REST conventions
- Tests required for all new features

## Common Commands
- `npm run dev` - Start development server
- `npm test` - Run test suite
- `npm run lint` - Check code style
```

### Creating Project-Specific Commands

Create `.claude/commands/[name].md`:

```markdown
---
description: [What this command does]
argument-hint: [expected arguments]
---

[Prompt content]

$ARGUMENTS
```

### Creating Project-Specific Skills

Create `.claude/skills/[name]/SKILL.md`:

```markdown
---
name: [skill-name]
description: [When to use - include trigger phrases users would say]
---

[Instructions for Claude when this skill is active]
```

### Modifying User-Level CLAUDE.md

Edit `~/.claude/CLAUDE.md` to adjust global behavior:

```bash
# Open in your editor
code ~/.claude/CLAUDE.md
# or
vim ~/.claude/CLAUDE.md
```

### Adding Hooks for Automation

Edit `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "command",
        "command": "echo 'File modified: checking lint...' && npm run lint --silent"
      }]
    }]
  }
}
```

---

## Troubleshooting

### Problem: Planning Protocol Not Triggering

**Symptoms**: Claude proceeds directly on ambiguous prompts.

**Solutions**:
1. Verify CLAUDE.md exists: `cat ~/.claude/CLAUDE.md`
2. Restart Claude Code (CLAUDE.md loads at session start)
3. Check for syntax errors in CLAUDE.md

### Problem: Skill Not Appearing

**Symptoms**: workflow-reflection not in available skills.

**Solutions**:
1. Verify file exists: `cat ~/.claude/skills/workflow-reflection/SKILL.md`
2. Check YAML frontmatter syntax (must have `name` and `description`)
3. Restart Claude Code

### Problem: Commands Not in /help

**Symptoms**: /kickoff or /reflect not listed.

**Solutions**:
1. Verify files exist in `~/.claude/commands/`
2. Check file extension is `.md`
3. Restart Claude Code

### Problem: Skill Not Auto-Invoking

**Symptoms**: Saying "reflect on workflow" doesn't trigger skill.

**Solutions**:
1. Try more explicit phrasing: "Use the workflow-reflection skill to analyze what we did"
2. Check skill description includes matching keywords
3. Restart Claude Code to reload skills

### Viewing Debug Information

Run Claude with debug mode:
```bash
claude --debug
```

This shows skill loading and matching information.

---

## File Locations Summary

```
~/.claude/
├── CLAUDE.md                           # Global behavior with @import
├── settings.json                       # User settings (hooks, plugins, etc.)
├── rules/
│   ├── planning.md                     # Planning protocol (imported)
│   └── typescript.md                   # Example path-specific rule
├── commands/
│   ├── kickoff.md                      # /kickoff command (positional args)
│   └── reflect.md                      # /reflect command (git context)
└── skills/
    └── workflow-reflection/
        ├── SKILL.md                    # Main skill file (~70 lines)
        ├── reference.md                # Optimization type docs (detailed)
        └── examples.md                 # Before/after scenarios

[Project Directory]/
├── .claude/
│   ├── CLAUDE.md                       # Project-specific instructions
│   ├── rules/                          # Project-specific rules
│   ├── settings.json                   # Project settings
│   ├── commands/                       # Project commands
│   └── skills/                         # Project skills
├── CLAUDE.md                           # Alternative project instructions location
└── CLAUDE.local.md                     # Personal project preferences (gitignored)
```

### Progressive Disclosure Pattern

Skills use a three-file structure:
- `SKILL.md` - Main instructions, kept concise (~70 lines max)
- `reference.md` - Detailed documentation with TOC
- `examples.md` - Concrete scenarios and anti-patterns

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2025-01-06 | Initial implementation |

---

## Next Steps

After verifying all tests pass:

1. **Use it for a real task** - The best test is actual usage
2. **Run /reflect after** - See what optimizations it suggests
3. **Implement suggestions** - Build your personalized configuration over time
4. **Share project configs** - If you create useful project-level configs, commit them for your team
