# Changelog

All notable changes to the Claude Code Toolkit repository will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-01-10

### Added

#### Self-Knowledge Documentation (Phase C)
- `docs/self-knowledge/context-management.md` - Comprehensive guide to context windows and CLAUDE.md hierarchy (365 lines)
- `docs/self-knowledge/subagent-mechanics.md` - Orchestration patterns, constraints, and best practices (410 lines)
- `docs/self-knowledge/tool-execution.md` - Agentic loop mechanics, permissions, and hooks (382 lines)

#### Graduated Plugins (Phase D)
- `library/plugins/local/workflow-optimizer/` - Graduated from experimental, includes 3 skills (prompt-optimizer, planning-with-files, agent-architect)
- `library/configs/workflow-optimizer-kit/` - First content in configs category, includes CLAUDE.md config, 2 commands, and workflow rules

#### Link Validation (Phase B)
- `library/tools/validate-links.sh` - New utility script for validating internal markdown links with `--verbose` and `--external` flags

#### External References (Phase D)
- Added ComposioHQ/awesome-claude-skills reference (~70+ skills) to `library/skills/extended-skills/README.md`

### Changed

#### Guide Path Fixes (Phase A)
- Updated 8 guide files to replace non-existent internal paths with working external URLs
- `guides/start-feature.md` - Updated to code.claude.com and anthropic.com/engineering links
- `guides/debug-problems.md` - Fixed documentation references
- `guides/improve-quality.md` - Fixed documentation references
- `guides/git-workflow.md` - Fixed documentation references
- `guides/create-documents.md` - Fixed documentation references
- `guides/learn-claude-code.md` - Fixed documentation references
- `guides/extend-claude-code.md` - Fixed documentation references
- `guides/orchestrate-work.md` - Fixed documentation references

#### Tool Script Path Fixes (Phase A)
- `library/tools/deploy-all.sh` - Fixed `$RESOURCES_DIR/core-skills` to `$RESOURCES_DIR/skills/core-skills`
- `library/tools/freshness-report.sh` - Fixed paths for both core-skills and extended-skills directories
- `library/tools/generate-stats.sh` - Fixed paths for both core-skills and extended-skills directories
- `library/tools/regenerate-catalog.sh` - Fixed paths discovered during validation (Phase B)

#### Shareability Improvements (Phase A)
- `CLAUDE.md` - Removed hardcoded user paths, updated repository status
- `README.md` - Removed hardcoded user paths, updated repository status
- `docs/README.md` - Removed local copies section that referenced old repo
- `docs/claude-code/README.md` - Removed offline access section
- `docs/best-practices/README.md` - Removed local copies section, added "Design Decision" section
- `docs/external/README.md` - Removed source material section
- `library/plugins/official/README.md` - Fixed plugin system reference link

#### Navigation Enhancements (Phase C)
- `guides/README.md` - Added descriptions for each guide and "Quick Comparisons" section
- `library/skills/CATALOG.md` - Added "Quick Start Examples" and "When to use" guidance per category

### Fixed

- All 18+ broken internal paths in guide documentation
- 4 tool scripts with incorrect directory path references
- 10 files with hardcoded user-specific paths (shareability issue)
- Count consistency verified: 32 working skills + 2 placeholders = 34 total SKILL.md files

---

## [0.0.4] - 2026-01-09 (Session 4)

### Added

#### Comprehensive Assessment
- `_workspace/assessments/audit-a-navigation.md` - Navigation and discoverability audit (found 18+ broken links)
- `_workspace/assessments/audit-b-content-quality.md` - Content quality audit (B+ rating)
- `_workspace/assessments/audit-c-technical-accuracy.md` - Technical accuracy audit (path issues identified)
- `_workspace/assessments/audit-d-vision-alignment.md` - Vision alignment analysis (78% score)
- `_workspace/assessments/audit-e-strategic-review.md` - Strategic review with prioritized recommendations
- `_workspace/assessments/comprehensive-review-2026-01-09.md` - Synthesized findings from all 5 audits

#### Strategic Planning
- `_workspace/planning/strategic-roadmap.md` - 5-phase improvement roadmap (A: Critical Fixes, B: Validation, C: Content Enhancement, D: Expansion, E: Sustainability)

---

## [0.0.3] - 2026-01-09 (Session 3)

### Added

#### Purpose-Based Navigation
- `guides/README.md` - Navigation hub with quick selector for intent-based discovery
- `guides/start-feature.md` - Pathway for starting new work (feature-dev, brainstorming, writing-plans)
- `guides/debug-problems.md` - Pathway for debugging (systematic-debugging, context-introspection)
- `guides/improve-quality.md` - Pathway for code review (pr-review-toolkit, TDD)
- `guides/git-workflow.md` - Pathway for Git/GitHub automation (commit-commands, git-commit)
- `guides/create-documents.md` - Pathway for document generation (docx, xlsx, pptx, pdf)
- `guides/learn-claude-code.md` - Pathway for learning Claude Code (claude-code-advisor, best-practices)
- `guides/extend-claude-code.md` - Pathway for building extensions (plugin-dev, hookify, skill-authoring)
- `guides/orchestrate-work.md` - Pathway for complex orchestration (ralph-wiggum, parallel-agents)

### Changed

- `CLAUDE.md` - Enhanced with intent-based navigation section
- `README.md` - Added purpose-based navigation pathways
- `library/README.md` - Updated navigation to include guides references
- `_workspace/backlog/purpose-navigation.md` - Marked as COMPLETED

---

## [0.0.2] - 2026-01-09 (Session 2)

### Added

#### Skills Library
- `library/skills/` - 32 production skills migrated from source repository
  - `core-skills/obra-workflow/` - 6 workflow methodology skills
  - `core-skills/obra-development/` - 9 development practice skills
  - `core-skills/git-workflow/` - 6 Git/GitHub automation skills
  - `core-skills/testing/` - 2 testing skills
  - `core-skills/document-creation/` - 5 document generation skills
  - `core-skills/skill-authoring/` - 2 skill creation templates
  - `extended-skills/` - 4 AWS skills + context engineering links
- `library/skills/CATALOG.md` - Authoritative skill index

#### Local Plugins
- `library/plugins/local/claude-code-advisor/` - Claude Code feature advisor plugin
- `library/plugins/local/context-introspection/` - Session context reporting plugin

#### Utility Tools
- `library/tools/` - 10 utility scripts migrated:
  - `deploy-skill.sh` - Deploy single skill
  - `deploy-all.sh` - Deploy all core skills
  - `validate-skill.sh` - Validate SKILL.md format
  - `fetch-skill.sh` - Download skill from GitHub
  - `update-sources.sh` - Re-fetch all skills
  - `freshness-report.sh` - Check for upstream changes
  - `regenerate-catalog.sh` - Auto-generate CATALOG.md
  - `generate-stats.sh` - Generate repository statistics
  - `migrate-source-files.sh` - One-time migration utility
  - `fix-unknown-shas.sh` - Fix rate-limited commit SHA entries

#### Experimental Content
- `experimental/plugins/workflow-optimizer-plugin/` - WIP plugin (branch: feature/v3-workflow-system)
- `experimental/plugins/workflow-optimizer-kit/` - WIP config kit (branch: best-practices-v2)

#### Documentation Indexes
- `docs/claude-code/README.md` - Index to code.claude.com official documentation (168 lines)
- `docs/best-practices/README.md` - Best practices summaries and pointers (221 lines)
- `docs/external/README.md` - Curated external resource links (265 lines)
- `library/plugins/official/CATALOG.md` - All 13 Anthropic plugins documented (779 lines)

### Changed

- `library/skills/README.md` - Enhanced with navigation and usage guidance
- `library/plugins/local/README.md` - Updated with plugin descriptions
- `library/tools/README.md` - Added tool descriptions and usage

---

## [0.0.1] - 2026-01-09 (Session 1)

### Added

#### Foundation Structure
- Complete directory structure for the new toolkit repository
- `_workspace/planning/repo-vision.md` - Immutable vision document defining repository purpose
- `CLAUDE.md` - Root-level Claude Code instructions
- `README.md` - Repository overview and navigation

#### Placeholder Documentation
- 21 placeholder README.md files across all folders establishing structure:
  - `docs/` (claude-code, best-practices, external, self-knowledge subdirectories)
  - `library/` (skills, plugins, tools, configs subdirectories)
  - `experimental/` (plugins, skills subdirectories)
  - `guides/`
  - `_workspace/` (planning, progress, backlog, assessments subdirectories)

#### Backlog Items
- 6 comprehensive backlog items in `_workspace/backlog/`:
  - `purpose-navigation.md` - Intent-based navigation system
  - `self-knowledge-content.md` - Internal mechanics documentation
  - `tool-audit.md` - Utility script review
  - `plugin-ecosystem.md` - Plugin documentation
  - `config-examples.md` - Configuration collection
  - `skill-freshness.md` - Upstream tracking system

---

## Summary Statistics

| Metric | Count |
|--------|-------|
| Working Skills | 32 |
| Placeholder Skills | 2 |
| Local Plugins | 3 |
| Official Plugins Documented | 13 |
| Configuration Kits | 1 |
| Utility Tools | 11 |
| Self-Knowledge Documents | 3 of 5 |
| Intent-Based Guides | 9 |
| Assessment Documents | 6 |

---

[0.1.0]: https://github.com/daniel-eski/claude-code-toolkit/compare/v0.0.4...v0.1.0
[0.0.4]: https://github.com/daniel-eski/claude-code-toolkit/compare/v0.0.3...v0.0.4
[0.0.3]: https://github.com/daniel-eski/claude-code-toolkit/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/daniel-eski/claude-code-toolkit/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/daniel-eski/claude-code-toolkit/releases/tag/v0.0.1
