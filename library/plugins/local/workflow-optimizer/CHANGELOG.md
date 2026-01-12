# Changelog

All notable changes to this project will be documented in this file.

## [3.0.0] - 2025-01-08

### Changed
- **Breaking**: Replaced `claude-config-advisor` with `agent-architect` skill
- **Breaking**: Reorganized agent templates into categorized directory structure
- Transformed plugin from "reference tool" to "workflow system"

### Added
- `planning-with-files` skill — Persistent context management using Manus principles
- `agent-architect` skill — Designs architecture based on established context
- Agent templates organized by category:
  - **Development**: debugger, test-runner, implementer
  - **Review**: code-reviewer, security-auditor
  - **Research**: researcher
  - **Non-coding**: documentation-writer, project-manager, technical-writer
  - **Orchestration**: multi-agent patterns (parallel, pipeline, fan-out)
- Orchestration patterns documentation for multi-agent workflows
- Agent templates README with selection guide

### Removed
- `claude-config-advisor` skill (replaced by `agent-architect`)
- Flat AGENT-TEMPLATES.md (replaced by categorized structure)
- Duplicate example agents from SUBAGENTS.md reference

### Improved
- Progressive disclosure: agent templates split into individual files by category
- Workflow integration: skills now chain naturally together
- agent-architect reads planning files when present for context-aware recommendations
- Comprehensive reference documentation for all Claude Code features

## [2.0.0] - 2025-01-07

### Changed
- **Breaking**: Refactored from single combined skill into two separate skills
- Renamed plugin from `prompt-optimizer` to `workflow-optimizer`

### Added
- `prompt-optimizer` skill — Platform-agnostic prompt optimization
- `claude-config-advisor` skill — Claude Code configuration recommendations
- PHILOSOPHY.md documenting design rationale and key insights
- CLAUDE.md for Claude Code context when working in this project
- QUICK-REFERENCE.md with essential configuration syntax
- TESTS.md with validation criteria
- LICENSE (MIT)
- .gitignore

### Removed
- Combined "prompt optimization + configuration" logic (separated into two skills)
- Claude Code configuration content from prompt-optimizer skill

### Fixed
- Separation of concerns: prompt-optimizer no longer recommends Claude Code configuration
- Knowledge gap: claude-config-advisor now requires reading templates before recommending

## [1.0.0] - 2025-01-07

### Added
- Initial combined prompt-optimizer skill
- CONFIG-TEMPLATES.md with subagent, hook, CLAUDE.md templates
- COMPLEXITY-GUIDE.md for assessing task complexity
- Basic README.md

### Known Issues (Fixed in 2.0.0)
- Conflated prompt optimization with Claude Code configuration
- Knowledge gap not properly addressed
- Skill too heavy for simple prompt optimization needs
