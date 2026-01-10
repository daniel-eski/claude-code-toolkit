# Skills

> Production-ready skills for Claude Code.

---

## What's Here

| Folder | Skills | Source |
|--------|--------|--------|
| `core-skills/obra-workflow/` | 6 | Jesse Vincent's workflow methodology |
| `core-skills/obra-development/` | 9 | Jesse Vincent's development practices |
| `core-skills/git-workflow/` | 6 | fvadicamo Git/GitHub automation |
| `core-skills/testing/` | 2 | Testing and QA skills |
| `core-skills/document-creation/` | 5 | Anthropic document skills |
| `core-skills/skill-authoring/` | 2 | Skill creation templates |
| `extended-skills/aws-skills/` | 4 | zxkane AWS development |
| `extended-skills/context-engineering/` | - | Educational links only |

**Total**: 32 working skills + 2 placeholders

---

## Quick Start

### Browse Available Skills
See `CATALOG.md` for the complete indexed catalog with descriptions.

### Deploy a Skill
```bash
cd ../tools/
./deploy-skill.sh ../skills/core-skills/obra-workflow/brainstorming
```

### Deploy All Skills
```bash
cd ../tools/
./deploy-all.sh
```

### Validate Before Deploy
```bash
cd ../tools/
./validate-skill.sh ../skills/core-skills/obra-workflow/brainstorming
```

---

## Skill Categories

### Workflow Skills (obra-workflow/)
Strategic planning and workflow methodology:
- `brainstorming` - Generate and explore ideas
- `writing-plans` - Create strategic documentation
- `executing-plans` - Implement strategic plans
- `dispatching-parallel-agents` - Coordinate multiple agents
- `using-superpowers` - Leverage platform capabilities
- `using-tmux-for-interactive-commands` - Control interactive CLI

### Development Skills (obra-development/)
Software development workflows:
- `test-driven-development` - TDD workflow
- `subagent-driven-development` - Multi-agent development
- `systematic-debugging` - Methodical debugging
- `finishing-a-development-branch` - Git branch completion
- `requesting-code-review` - Initiate reviews
- `receiving-code-review` - Process feedback
- `using-git-worktrees` - Multiple working trees
- `verification-before-completion` - Pre-completion validation
- `writing-skills` - Skill development guide

### Git Workflow Skills (git-workflow/)
Git and GitHub automation:
- `git-commit` - Conventional Commits format
- `github-pr-creation` - Create PRs
- `github-pr-merge` - Merge PRs
- `github-pr-review` - Review PRs
- `creating-skills` - Skill creation guide
- `changelog-generator` - (Placeholder)

### Document Creation Skills (document-creation/)
Document manipulation:
- `docx` - Word documents
- `pptx` - PowerPoint presentations
- `xlsx` - Excel spreadsheets
- `pdf` - PDF handling
- `doc-coauthoring` - Collaborative editing

### AWS Skills (extended-skills/aws-skills/)
AWS development:
- `aws-agentic-ai` - Agentic AI on AWS
- `aws-cdk-development` - CDK infrastructure
- `aws-cost-operations` - Cost optimization
- `aws-serverless-eda` - Event-driven architecture

---

## Source Tracking

Skills downloaded from GitHub include `.source` files tracking:
- Original URL
- Fetch timestamp
- Commit SHA
- Branch

Use `../tools/freshness-report.sh` to check for upstream changes.

---

## Placeholders

Two skills are placeholders (source repos were inaccessible):
- `core-skills/git-workflow/changelog-generator/`
- `core-skills/testing/pypict-skill/`

---

## Future Work

See `_workspace/backlog/skills-organization.md` for plans to enhance discoverability with purpose-based navigation.

---

## Status

MIGRATED - 32 working skills + 2 placeholders from old repo.
Migrated: 2026-01-09
