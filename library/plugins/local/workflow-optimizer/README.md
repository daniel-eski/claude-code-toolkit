# Workflow Optimizer Plugin

A Claude Code plugin providing a complete workflow system for tackling complex projects. Three loosely-coupled skills that work independently or chain together:

1. **prompt-optimizer** — Clarify objectives and ensure alignment
2. **planning-with-files** — Establish persistent context for extended work
3. **agent-architect** — Design optimal agent architecture based on context

---

## The Workflow

For complex projects, use the skills in sequence:

```
┌─────────────────────────────────────────────┐
│  1. PROMPT OPTIMIZER                        │
│     Clarify objectives                      │
│     Surface assumptions                     │
│     Align on what we're building            │
└─────────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────┐
│  2. PLANNING WITH FILES                     │
│     Create task_plan.md                     │
│     Establish findings.md, progress.md      │
│     Persistent "working memory on disk"     │
└─────────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────┐
│  3. AGENT ARCHITECT                         │
│     Design CLAUDE.md based on context       │
│     Create task-specific subagents          │
│     Set up automation hooks                 │
│     Architecture INFORMED by the plan       │
└─────────────────────────────────────────────┘
                    │
                    ▼
              [Execute Work]
```

Each skill works independently. Use what you need.

---

## Why This Workflow?

**The insight:** You can't design optimal tooling until you deeply understand the problem.

Traditional approach:
> "Set up Claude Code" → Start working → Realize setup doesn't fit → Reconfigure

This workflow:
> Understand the task → Establish context → THEN design tooling → Execute with optimal setup

The agent architecture becomes the **culmination** of understanding, not the starting point.

---

## Skill 1: prompt-optimizer

### Purpose
Clarify objectives and ensure alignment before executing complex tasks.

### When It Activates
- Multi-step or complex tasks
- Unfamiliar codebases or domains
- User says "help me plan", "I want to build"
- Ambiguous requirements

### What It Does
- Restates objectives clearly
- Surfaces assumptions
- Identifies critical context (files to read)
- Flags risks and ambiguities
- Proposes high-level approach
- Asks clarifying questions

### Usage
Automatic activation based on task complexity, or explicit:
```
/workflow-optimizer:optimize Build a real-time notification system
```

### Output
```
## Prompt Optimization Analysis

### Objective
[Clear restatement of what you're building]

### Assumptions
[List of assumptions that could affect approach]

### Critical Context
[Files and information needed]

### Risks & Ambiguities
[What could go wrong]

### Proposed Approach
[High-level phases]

### Clarifying Questions
[Questions if any]
```

---

## Skill 2: planning-with-files

### Purpose
Establish persistent context management for extended work using markdown files as "working memory on disk."

### Core Concept
```
Context Window = RAM (volatile, limited)
Filesystem = Disk (persistent, unlimited)
```

After ~50 tool calls, original goals can be forgotten. File-based planning solves this.

### The Three Files
1. **task_plan.md** — Phases, decisions, status
2. **findings.md** — Research and discoveries
3. **progress.md** — Session logs, file changes

### Key Rules
- **2-Action Rule:** After every 2 search/view operations, save findings to files
- **Read Before Decide:** Re-read task_plan.md before major decisions
- **3-Strike Error Protocol:** Log failures, try alternatives, escalate if stuck

### When to Use
- Multi-step tasks (3+ steps)
- Research projects
- Feature development
- Complex debugging
- Any extended work with many tool calls

### Usage
```
/workflow-optimizer:plan-files Set up planning for API authentication feature
```

### Based On
Manus context engineering principles. See `skills/planning-with-files/reference.md` for the complete methodology.

---

## Skill 3: agent-architect

### Purpose
Design optimal Claude Code agent architecture based on your established context.

### What It Designs
- **CLAUDE.md** — Project memory tailored to your task
- **Subagents** — Specialized agents for different phases
- **Hooks** — Automation triggered by events
- **Skills** — Reusable capabilities
- **Settings** — Permissions and sandbox
- **MCP Servers** — External tool integrations

### Enhanced with Planning Files
When `task_plan.md` exists, the architect reads it to design architecture specifically optimized for your task phases.

Without planning files, it still works but recommendations are more generic.

### Usage
```
/workflow-optimizer:architect Design agents for debugging workflow
```

### Output
Complete, ready-to-use configuration files:
- CLAUDE.md content
- Subagent markdown files
- settings.json hooks
- Implementation steps

### Reference Documentation
Comprehensive syntax for all Claude Code features in `skills/agent-architect/references/`:
- SKILLS.md, SUBAGENTS.md, HOOKS.md
- MEMORY.md, SETTINGS.md, MCP.md

---

## Loose Coupling

Each skill works independently:

**prompt-optimizer alone:**
- Great for any complex task
- No dependency on other skills

**planning-with-files alone:**
- Great for extended work
- Use whenever context management matters

**agent-architect alone:**
- Great for Claude Code configuration
- Enhanced when planning files exist

**All three together:**
- Comprehensive project setup
- Each step informs the next
- Most powerful for complex, multi-phase projects

---

## Installation

### Option 1: Plugin (Recommended)

**From Git repository:**
```bash
claude /plugin install https://github.com/daniel-eski/workflow-optimizer
```

**Local testing:**
```bash
claude --plugin-dir /path/to/workflow-optimizer
```

### Option 2: Personal Skills

Copy skills to your personal directory:
```bash
cp -r workflow-optimizer/skills/prompt-optimizer ~/.claude/skills/
cp -r workflow-optimizer/skills/planning-with-files ~/.claude/skills/
cp -r workflow-optimizer/skills/agent-architect ~/.claude/skills/
```

### Option 3: Project Skills

Copy to project for team sharing:
```bash
cp -r workflow-optimizer/skills/* .claude/skills/
```

Commit to version control.

---

## File Structure

```
workflow-optimizer/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   ├── prompt-optimizer/
│   │   ├── SKILL.md
│   │   └── COMPLEXITY-GUIDE.md
│   ├── planning-with-files/
│   │   ├── SKILL.md
│   │   ├── reference.md
│   │   ├── examples.md
│   │   └── templates/
│   └── agent-architect/
│       ├── SKILL.md
│       ├── references/
│       │   ├── SKILLS.md
│       │   ├── SUBAGENTS.md
│       │   ├── HOOKS.md
│       │   ├── MEMORY.md
│       │   ├── SETTINGS.md
│       │   └── MCP.md
│       └── templates/
│           ├── agents/
│           │   ├── README.md
│           │   ├── development/
│           │   │   ├── debugger.md
│           │   │   ├── test-runner.md
│           │   │   └── implementer.md
│           │   ├── review/
│           │   │   ├── code-reviewer.md
│           │   │   └── security-auditor.md
│           │   ├── research/
│           │   │   └── researcher.md
│           │   ├── non-coding/
│           │   │   ├── documentation-writer.md
│           │   │   ├── project-manager.md
│           │   │   └── technical-writer.md
│           │   └── orchestration/
│           │       └── patterns.md
│           ├── CLAUDE-TEMPLATES.md
│           └── HOOK-TEMPLATES.md
├── commands/
│   ├── optimize.md
│   ├── plan-files.md
│   └── architect.md
├── README.md
├── PHILOSOPHY.md
├── CHANGELOG.md
└── CLAUDE.md
```

---

## Example: Full Workflow

**Task:** "Build a real-time chat feature for our app"

### Step 1: prompt-optimizer
```
/workflow-optimizer:optimize Build real-time chat feature
```
Output: Aligned on objectives, identified WebSocket vs SSE decision, noted authentication integration.

### Step 2: planning-with-files
```
/workflow-optimizer:plan-files
```
Creates:
- `task_plan.md` with phases: Research → Design → Implement → Test
- `findings.md` for discoveries
- `progress.md` for tracking

### Step 3: agent-architect
```
/workflow-optimizer:architect
```
Reads task_plan.md, designs:
- CLAUDE.md with project context and chat-specific notes
- `researcher.md` subagent for Phase 1
- `implementer.md` subagent for Phase 3
- Hooks for auto-formatting

### Step 4: Execute
Work through phases with persistent context, specialized agents, and automated formatting.

---

## Troubleshooting

### Skills don't activate
1. Check skills are loaded: "What skills are available?"
2. Use explicit commands: `/workflow-optimizer:optimize`
3. Restart Claude Code after installation

### Planning files not detected by architect
1. Ensure files are named exactly: `task_plan.md`, `findings.md`, `progress.md`
2. Files should be in project root or current directory
3. architect will note if files found/not found

### Configuration syntax errors
1. agent-architect reads reference files before recommending
2. Check `skills/agent-architect/references/` for correct syntax
3. Templates in `templates/` are validated

---

## Contributing

Contributions welcome! Areas of interest:
- Additional templates for specific workflows
- Enhanced planning file patterns
- MCP server integrations
- Domain-specific variations

---

## License

MIT — Use, modify, and share freely.
