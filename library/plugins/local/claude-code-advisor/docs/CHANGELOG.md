# Changelog

All notable changes to the Claude Code Advisor plugin are documented here.

Format based on [Keep a Changelog](https://keepachangelog.com/).
Versioning follows [Semantic Versioning](https://semver.org/).

---

## [1.1.0] - 2026-01-08

### Changed

**Agent Restructuring** - Replaced monolithic generator with specialized agents for better context efficiency

**New Subagents (5 added)**
- `cc-skill-generator` - Expert SKILL.md generation with progressive disclosure guidance (Sonnet)
- `cc-agent-generator` - Subagent definitions with model selection expertise (Sonnet)
- `cc-config-generator` - Commands, hooks, CLAUDE.md, MCP configs (Sonnet)
- `cc-troubleshooter` - Debug why configurations aren't working (Sonnet)
- `cc-pattern-matcher` - Fast pattern matching to known patterns (Haiku)

**Removed**
- `cc-file-generator` - Replaced by 3 specialized generators above

**Updated**
- `cc-understanding-verifier` - Sharpened for single-claim verification
- `cc-deep-researcher` - Clarified for comprehensive research (vs verification)
- `SKILL.md` - New categorized subagent dispatch guidance
- `/cc-design` command - Updated workflow for specialized generators

### Notes

- Total subagents: 10 (was 6)
- Specialized generators provide more targeted expertise with less context bloat
- Clear distinction between quick verification and comprehensive research

---

## [1.0.0] - 2026-01-08

### Added

**Core Skill**
- `claude-code-advisor` skill with strategic mental models and navigation
- 22 reference files covering all Claude Code extensibility features

**Reference Documentation**
- System understanding: context architecture, execution model, feature interactions
- Feature mechanics: skills, subagents, hooks, memory, commands, MCP deep dives
- Decision guides: skills-vs-subagents, skills-vs-commands, memory-vs-skills, hooks usage, architecture selection
- Patterns: composition patterns, anti-patterns, workflow patterns, architecture examples
- Implementation guides: skill authoring, subagent design, hook implementation, plugin structure

**Subagents (6)**
- `cc-understanding-verifier` - Fast documentation verification (Haiku)
- `cc-config-analyzer` - Configuration audit specialist (Sonnet)
- `cc-deep-researcher` - Multi-source research (Sonnet)
- `cc-architecture-designer` - Configuration designer (Sonnet)
- `cc-file-generator` - Config file generator (Sonnet)
- `cc-implementation-reviewer` - Pre-deployment review (Sonnet)

**Commands (4)**
- `/cc-advisor` - Get expert advice on Claude Code features
- `/cc-analyze` - Audit existing Claude Code configuration
- `/cc-verify` - Verify claims against official documentation
- `/cc-design` - Design configuration for specific goals

**Documentation**
- README with quick start guide
- Installation guide with troubleshooting
- Usage guide with real examples
- This changelog

### Notes

- Initial public release
- All content grounded in official Claude Code documentation
- Designed for progressive disclosure (loads only what's needed)

---

## Future Roadmap

Planned for future releases:

- **Source documentation curation** - Offline excerpts from official docs
- **Additional patterns** - More real-world configuration examples
- **Integration testing** - Verification that all components work together
- **Community contributions** - Patterns and examples from users
