# Skills Catalog

Complete indexed catalog of all available skills. Last updated: 2026-01-10

**Total: 28 working skills + 2 placeholders + 4 extended skills**

---

## Quick Start Examples

**Start a brainstorming session:**
```
> Let's brainstorm approaches for the authentication system
```

**Debug with systematic approach:**
```
> Use systematic-debugging to investigate the login timeout issue
```

**Create a document:**
```
> Use the xlsx skill to create a project tracking spreadsheet
```

**Git workflow:**
```
> Create a commit following conventional commits format
```

---

## Core Skills

### Workflow Skills (obra-workflow/)

Skills for strategic planning and workflow methodology by Jesse Vincent from [obra/superpowers](https://github.com/obra/superpowers).

**When to use**: Starting new projects, planning complex features, coordinating multi-agent work, working with interactive CLI tools.

| Skill | Lines | Description | Status |
|-------|-------|-------------|--------|
| brainstorming | 54 | Generate and explore ideas | Available |
| writing-plans | 116 | Create strategic documentation | Available |
| executing-plans | 76 | Implement and run strategic plans | Available |
| dispatching-parallel-agents | 180 | Coordinate multiple simultaneous agents | Available |
| using-superpowers | 87 | Leverage core platform capabilities | Available |
| using-tmux-for-interactive-commands | 178 | Control interactive CLI tools (vim, git) via tmux | Available |

Source: [obra/superpowers](https://github.com/obra/superpowers/tree/main/skills) and [obra/superpowers-lab](https://github.com/obra/superpowers-lab/tree/main/skills)

### Development Skills (obra-development/)

Skills for software development workflows from [obra/superpowers](https://github.com/obra/superpowers).

**When to use**: TDD workflows, debugging issues, code review process, managing Git branches, validating work before completion.

| Skill | Lines | Description | Status |
|-------|-------|-------------|--------|
| test-driven-development | 371 | Write tests before implementing code | Available |
| subagent-driven-development | 240 | Development using multiple sub-agents | Available |
| systematic-debugging | 296 | Methodical problem-solving in code | Available |
| finishing-a-development-branch | 200 | Complete Git code branches | Available |
| requesting-code-review | 105 | Initiate code review processes | Available |
| receiving-code-review | 213 | Process and incorporate code feedback | Available |
| using-git-worktrees | 217 | Manage multiple Git working trees | Available |
| verification-before-completion | 139 | Validate work before finalizing | Available |
| writing-skills | 655 | Develop and document capabilities | Available |

Source: [obra/superpowers](https://github.com/obra/superpowers/tree/main/skills)

### Git Workflow Skills (git-workflow/)

Skills for Git and GitHub automation from [fvadicamo/dev-agent-skills](https://github.com/fvadicamo/dev-agent-skills).

**When to use**: Creating conventional commits, managing pull requests, reviewing code changes, generating changelogs.

| Skill | Lines | Description | Status |
|-------|-------|-------------|--------|
| git-commit | 235 | Conventional Commits format | Available |
| github-pr-creation | 201 | Create pull requests | Available |
| github-pr-merge | 210 | Merge pull requests | Available |
| github-pr-review | 235 | Review pull requests | Available |
| creating-skills | 261 | Guide for creating Claude Code skills | Available |
| changelog-generator | - | Transform git commits into release notes | Placeholder |

Note: changelog-generator (ComposioHQ) repository not accessible.

### Testing Skills (testing/)

Skills for testing and quality assurance.

**When to use**: Web application testing with Playwright, pairwise test case generation.

| Skill | Lines | Description | Status |
|-------|-------|-------------|--------|
| webapp-testing | 95 | Test web applications using Playwright | Available |
| pypict-skill | - | Pairwise test generation | Placeholder |

Source: [anthropics/skills](https://github.com/anthropics/skills/tree/main/skills/webapp-testing)

Note: pypict-skill (omkamal) repository not accessible.

### Document Creation Skills (document-creation/)

Skills for creating and manipulating documents from [anthropics/skills](https://github.com/anthropics/skills).

**When to use**: Generating reports, creating presentations, building spreadsheets, extracting data from PDFs, collaborative document editing.

| Skill | Lines | Description | Status |
|-------|-------|-------------|--------|
| docx | 196 | Create, edit, and analyze Word documents | Available |
| doc-coauthoring | 375 | Collaborative document editing | Available |
| pptx | 483 | Create, edit, and analyze PowerPoint presentations | Available |
| xlsx | 288 | Create, edit, and analyze Excel spreadsheets | Available |
| pdf | 294 | Extract text, create PDFs, and handle forms | Available |

### Skill Authoring (skill-authoring/)

Meta skills for creating new skills from [anthropics/skills](https://github.com/anthropics/skills).

**When to use**: Creating custom skills for your workflows, understanding SKILL.md structure and best practices.

| Skill | Lines | Description | Status |
|-------|-------|-------------|--------|
| skill-creator | 356 | Anthropic's official skill development guide | Available |
| template | 6 | Anthropic's skill creation template | Available |

---

## Extended Skills

### AWS Skills (extended-skills/aws-skills/)

AWS development skills from [zxkane/aws-skills](https://github.com/zxkane/aws-skills).

**When to use**: AWS CDK development, serverless architecture design, cost optimization, building agentic AI on AWS.

| Skill | Lines | Description | Status |
|-------|-------|-------------|--------|
| aws-agentic-ai | 117 | Agentic AI development on AWS | Available |
| aws-cdk-development | 278 | AWS CDK infrastructure development | Available |
| aws-cost-operations | 317 | AWS cost optimization and operations | Available |
| aws-serverless-eda | 757 | Serverless event-driven architecture | Available |

### Context Engineering (extended-skills/context-engineering/)

Educational content on context engineering from [muratcankoylan/Agent-Skills-for-Context-Engineering](https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering). **Links only** - see [README](extended-skills/context-engineering/README.md).

| Topic | Description |
|-------|-------------|
| context-fundamentals | What context is, why it matters, anatomy of context |
| context-degradation | Patterns of context failure: lost-in-middle, poisoning |
| context-compression | Compression strategies for long-running sessions |
| context-optimization | Compaction, masking, and caching strategies |
| multi-agent-patterns | Orchestrator, peer-to-peer, hierarchical architectures |
| memory-systems | Short-term, long-term, graph-based memory architectures |
| tool-design | Building effective tools for agents |
| evaluation | Evaluation frameworks for agent systems |

---

## Quick Deploy Commands

```bash
# Deploy a single skill
./tools/deploy-skill.sh core-skills/obra-workflow/brainstorming

# Deploy all core skills
./tools/deploy-all.sh

# Deploy to project-specific location
./tools/deploy-all.sh .claude/skills

# Validate before deploying
./tools/validate-skill.sh core-skills/obra-workflow/brainstorming
```

---

## Status Legend

| Status | Meaning |
|--------|---------|
| Available | Skill fetched and ready to deploy |
| Placeholder | Repository not accessible (see .source file) |
| Links only | Educational content, reference links provided |
