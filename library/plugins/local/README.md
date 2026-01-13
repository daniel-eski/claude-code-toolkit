# Local Plugins

> Plugins developed and owned locally.

---

## What's Here

| Plugin | Purpose | Commands |
|--------|---------|----------|
| `claude-code-advisor/` | Strategic advisor for Claude Code features | `/cc-advisor`, `/cc-analyze`, `/cc-verify`, `/cc-design` |
| `claude-learnings/` | Capture learnings, errors, and successes | `/log`, `/log_error`, `/log_success`, `/review-learnings`, `/checkpoint`, `/restore` |
| `context-introspection/` | Session context reporting | `/context-introspection:report` |
| `guardrails/` | Defense-in-depth safety hooks | CLI: `guardrails status`, `guardrails activate`, etc. |
| `workflow-optimizer/` | Complete workflow system for complex projects | `/workflow-optimizer:optimize`, `/workflow-optimizer:plan-files`, `/workflow-optimizer:architect` |

---

## claude-code-advisor

A comprehensive strategic advisor plugin for Claude Code with:
- **10 specialized agents** for different advisory roles
- **22 reference files** with detailed Claude Code documentation
- **4 slash commands** for different use cases

### Commands
- `/cc-advisor` - General strategic advice
- `/cc-analyze` - Analyze a specific feature or pattern
- `/cc-verify` - Verify implementation against best practices
- `/cc-design` - Design architecture for Claude Code projects

### Structure
```
claude-code-advisor/
├── .claude-plugin/
│   └── plugin.json
├── agents/           # 10 specialized advisory agents
├── references/       # 22 documentation files
├── commands/         # 4 slash commands
└── skills/           # Supporting skills
```

---

## context-introspection

Generates comprehensive reports of all context sources active in a Claude Code session:
- CLAUDE.md files (global, project, local)
- Skills and their activation triggers
- Hooks and their configurations
- MCP servers and connections
- Custom agents and commands

### Usage
```bash
# Run the introspection report
/context-introspection:report
```

### Structure
```
context-introspection/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   └── report.md
└── README.md
```

---

## claude-learnings

Zero-friction capture of learnings, errors, and successes during sessions. Human-gated review before anything gets added to CLAUDE.md.

### Commands
- `/log [entry]` - Quick capture with auto-detected type
- `/log_error [entry]` - Capture errors/mistakes (forces "warning" type)
- `/log_success [entry]` - Capture what worked (forces "success" type)
- `/review-learnings` - Batch review and sync to CLAUDE.md
- `/checkpoint [name]` - Save state for potential rewind
- `/restore [name]` - View/restore from checkpoint

### Structure
```
claude-learnings/
├── .claude-plugin/
│   └── plugin.json
├── commands/         # 6 slash commands
├── docs/             # Installation and testing docs
├── examples/         # Queue and checkpoint examples
└── README.md
```

---

## guardrails

Defense-in-depth safety hooks that:
- Block file writes outside your working directory
- Block pushes to main/master branches
- Block force pushes (allows `--force-with-lease`)
- Log all tool calls for audit trail

### CLI Commands
```bash
guardrails status      # Check if hooks are active
guardrails activate    # Enable hooks
guardrails deactivate  # Disable hooks
guardrails logs        # View audit logs
guardrails override add path /path  # Add override
```

### Structure
```
guardrails/
├── .claude-plugin/
│   └── plugin.json
├── src/hooks/        # path-guardian, git-guardian, audit-logger
├── bin/guardrails    # CLI tool
├── config/           # hooks.json, overrides.example.json
├── docs/             # Configuration, security, troubleshooting
├── scripts/          # install.sh, uninstall.sh
└── README.md
```

---

## workflow-optimizer

A complete workflow system for complex projects with three loosely-coupled skills:

1. **prompt-optimizer** - Clarify objectives and ensure alignment before complex tasks
2. **planning-with-files** - Establish persistent context using markdown files as "working memory"
3. **agent-architect** - Design optimal Claude Code architecture based on established context

### Commands
- `/workflow-optimizer:optimize` - Clarify objectives for complex tasks
- `/workflow-optimizer:plan-files` - Set up file-based planning (task_plan.md, findings.md, progress.md)
- `/workflow-optimizer:architect` - Design CLAUDE.md, subagents, and hooks for your task

### The Workflow
```
1. OPTIMIZE → Clarify objectives and assumptions
       ↓
2. PLAN-FILES → Establish persistent context
       ↓
3. ARCHITECT → Design tooling based on context
       ↓
[Execute Work with optimal setup]
```

### Structure
```
workflow-optimizer/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   ├── prompt-optimizer/       # Objective clarification
│   ├── planning-with-files/    # File-based context management
│   └── agent-architect/        # Architecture design + templates
├── commands/                   # 3 slash commands
├── README.md
├── PHILOSOPHY.md               # Design rationale
└── CHANGELOG.md
```

---

## Installation

### Use Directly
```bash
claude --plugin-dir ./claude-code-advisor
```

### Add to Settings
Add to `~/.claude/settings.json`:
```json
{
  "plugins": {
    "directories": ["path/to/library/plugins/local/claude-code-advisor"]
  }
}
```

### Project-Specific
Add to `.claude/settings.json` in your project.

---

## Development

These plugins are production-ready but can be extended. To modify:
1. Edit files in the plugin directory
2. Test with `claude --plugin-dir ./[plugin-name]`
3. Document changes in the plugin's README

For WIP plugins, see `experimental/plugins/`.

---

## Status

5 production plugins available.
