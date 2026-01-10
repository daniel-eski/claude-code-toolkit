# Contributing to Claude Code Toolkit

Thank you for your interest in contributing to the Claude Code Toolkit. This guide will help you understand how to add skills, plugins, configurations, and documentation effectively.

---

## Table of Contents

- [Overview](#overview)
- [Before You Start](#before-you-start)
- [Contributing Skills](#contributing-skills)
- [Contributing Plugins](#contributing-plugins)
- [Contributing Configuration Kits](#contributing-configuration-kits)
- [Contributing Documentation](#contributing-documentation)
- [The Experimental to Library Path](#the-experimental-to-library-path)
- [Quality Standards](#quality-standards)
- [Testing Requirements](#testing-requirements)
- [Pull Request Process](#pull-request-process)

---

## Overview

This repository contains several types of contributions:

| Type | Location | Purpose |
|------|----------|---------|
| Skills | `library/skills/` | Reusable SKILL.md files for Claude Code |
| Plugins | `library/plugins/local/` | Commands, agents, and hooks bundles |
| Config Kits | `library/configs/` | Ready-to-use configuration templates |
| Documentation | `docs/`, `guides/` | Indexes, guides, and best practices |
| Tools | `library/tools/` | Utility scripts for working with assets |

All new development should start in `experimental/` before moving to `library/`.

---

## Before You Start

### Repository Design Principles

Understanding these principles will help your contribution fit naturally:

1. **Progressive disclosure** - Each level explains what's below
2. **Pointer-first** - Default to indexes and links; local copies only when valuable
3. **Single source of truth** - CATALOG.md files are authoritative inventories
4. **Self-contained folders** - Enter at any level and understand context

### Recommended Reading

- `CLAUDE.md` - Navigation guidance for agents
- `README.md` - Repository overview and structure
- `library/README.md` - Overview of deployable assets
- `guides/extend-claude-code.md` - Building extensions workflow

---

## Contributing Skills

Skills are SKILL.md files that provide Claude Code with reusable instructions and methodologies.

### Option 1: Fetch from an Existing GitHub Repository

Use the `fetch-skill.sh` tool to import a skill from GitHub:

```bash
cd library/tools

# From a dedicated skill repo
./fetch-skill.sh https://github.com/author/skill-name ../skills/core-skills/category/skill-name

# From a path within a larger repo
./fetch-skill.sh https://github.com/author/repo/tree/main/skills/skill-name ../skills/core-skills/category/skill-name
```

This will:
- Download the SKILL.md and README.md files
- Create a `.source` file with the origin URL, fetch timestamp, and commit SHA
- Enable change detection for future upstream updates

### Option 2: Create a New Skill Manually

1. **Create the skill directory in experimental**:
   ```bash
   mkdir -p experimental/skills/your-skill-name
   ```

2. **Create the SKILL.md file** with the required format:
   ```markdown
   ---
   name: your-skill-name
   description: "A clear description of when and how this skill should be used."
   ---

   # Skill Title

   ## Overview

   Brief explanation of what this skill does.

   ## The Process

   Step-by-step instructions for Claude Code to follow.

   ## Key Principles

   - Important guidelines
   - Best practices
   ```

3. **Validate your skill**:
   ```bash
   cd library/tools
   ./validate-skill.sh ../../experimental/skills/your-skill-name
   ```

### SKILL.md Requirements

| Requirement | Details |
|------------|---------|
| YAML frontmatter | Must start and end with `---` |
| `name` field | Required in frontmatter |
| `description` field | Required, under 1024 characters recommended |
| Line count | Warning if over 500 lines (consider splitting) |
| File name | Must be `SKILL.md` (uppercase) |

### Skill Organization

Skills are organized by source and purpose:

```
library/skills/
├── core-skills/
│   ├── obra-workflow/       # Workflow methodology skills
│   ├── obra-development/    # Development practice skills
│   ├── git-workflow/        # Git and GitHub automation
│   ├── testing/             # Testing and QA skills
│   ├── document-creation/   # Document generation
│   └── skill-authoring/     # Meta skills for creating skills
└── extended-skills/
    ├── aws-skills/          # AWS-specific skills
    └── context-engineering/ # Context management
```

Choose the appropriate category or propose a new one if none fits.

---

## Contributing Plugins

Plugins bundle commands, agents, skills, and hooks into cohesive packages.

### Plugin Structure

A minimal plugin requires:

```
your-plugin/
├── .claude-plugin/
│   └── plugin.json         # Required: plugin manifest
├── commands/               # Optional: slash commands (*.md)
├── agents/                 # Optional: agent definitions (*.md)
├── skills/                 # Optional: bundled skills
├── hooks/                  # Optional: hook configurations
└── README.md               # Required: documentation
```

### plugin.json Manifest

```json
{
  "name": "your-plugin-name",
  "version": "1.0.0",
  "description": "Clear description of what this plugin does",
  "author": {
    "name": "Your Name",
    "url": "https://github.com/your-username"
  },
  "license": "MIT",
  "keywords": ["relevant", "keywords"],
  "skills": "./skills/",
  "agents": "./agents/",
  "commands": "./commands/"
}
```

### Creating a New Plugin

1. **Start in experimental**:
   ```bash
   mkdir -p experimental/plugins/your-plugin/.claude-plugin
   ```

2. **Create the manifest** at `experimental/plugins/your-plugin/.claude-plugin/plugin.json`

3. **Add components** (commands, agents, skills as needed)

4. **Test the plugin**:
   ```bash
   claude --plugin-dir experimental/plugins/your-plugin
   ```

5. **Document** with a README.md explaining purpose, commands, and usage

### Plugin Development Resources

- Official `plugin-dev` plugin: See `library/plugins/official/CATALOG.md`
- Claude Code Advisor: `library/plugins/local/claude-code-advisor/`
- Plugin Reference: https://code.claude.com/docs/en/plugins-reference

---

## Contributing Configuration Kits

Configuration kits are bundles of CLAUDE.md files, rules, commands, and settings that implement a coherent workflow.

### Kit Structure

```
your-kit/
├── config/
│   ├── CLAUDE.md           # Core behavioral instructions
│   ├── rules/              # Optional: modular rule files
│   ├── skills/             # Optional: kit-specific skills
│   └── commands/           # Optional: kit-specific commands
├── install.sh              # Installation script
└── README.md               # Documentation
```

### Requirements

1. **Clear purpose** - The kit should solve a specific workflow problem
2. **Installation script** - Make setup easy with `install.sh`
3. **Documentation** - Explain the problem, components, and usage
4. **Non-destructive** - Installation should not silently overwrite existing config

---

## Contributing Documentation

### Adding to Existing Documentation

- **Official docs** (`docs/claude-code/`): These mirror code.claude.com - propose changes upstream
- **Best practices** (`docs/best-practices/`): Local copies of key documents - additions welcome
- **Guides** (`guides/`): Intent-based navigation - improvements welcome

### Documentation Standards

- Use clear, actionable language
- Include practical examples
- Follow existing formatting patterns
- Keep intent-based structure in guides

### Proposing New Guides

Guides answer "I want to..." questions. If you identify a missing intent:

1. Check if existing guides cover it partially
2. Propose the new guide with a clear intent statement
3. Follow the format of existing guides in `guides/`

---

## The Experimental to Library Path

All new skills, plugins, and config kits should start in `experimental/`.

### Graduation Criteria

| Criterion | Requirement |
|-----------|-------------|
| **Works as intended** | Tested and verified functional |
| **Properly documented** | README.md, SKILL.md/plugin.json complete |
| **Validated** | Passes `validate-skill.sh` for skills |
| **Follows standards** | Matches existing patterns in `library/` |
| **Clear value** | Solves a real problem or fills a gap |

### Graduation Process

1. **Verify functionality** - Test all features work as documented
2. **Complete documentation** - README, manifest, inline docs
3. **Run validation** - Use appropriate validation scripts
4. **Move to library** - Copy from `experimental/` to `library/`
5. **Update catalogs** - Add to appropriate CATALOG.md
6. **Clean up experimental** - Remove from `experimental/`

Example:
```bash
# After completing a plugin in experimental/
cp -r experimental/plugins/my-plugin library/plugins/local/

# Update library/plugins/local/README.md to include the new plugin
# Update library/README.md if needed

# Remove from experimental
rm -rf experimental/plugins/my-plugin
```

---

## Quality Standards

### Code and Content Standards

| Standard | Details |
|----------|---------|
| **Clarity** | Instructions should be unambiguous |
| **Completeness** | Include all necessary context |
| **Consistency** | Match existing patterns and formatting |
| **Conciseness** | Remove unnecessary content |

### Naming Conventions

- **Skill directories**: lowercase-with-hyphens
- **Plugin directories**: lowercase-with-hyphens
- **SKILL.md**: uppercase (Claude Code requirement)
- **README.md**: uppercase (convention)

### File Organization

- Keep related files together in their directory
- Include a README.md in every directory that needs explanation
- Use .source files for tracking external origins

---

## Testing Requirements

### Skills

Before graduation, skills must pass:

```bash
# Validation (required)
./library/tools/validate-skill.sh path/to/skill

# Manual testing (required)
# 1. Deploy the skill
# 2. Trigger it with an appropriate prompt
# 3. Verify the behavior matches documentation
```

### Plugins

Before graduation, plugins must:

1. **Load without errors**: `claude --plugin-dir path/to/plugin`
2. **Commands work**: Test each slash command
3. **Agents function**: Invoke each agent and verify behavior
4. **Documentation accurate**: Commands and usage match reality

### Configuration Kits

Before graduation, config kits must:

1. **Install cleanly**: Run `install.sh` on a fresh setup
2. **Components load**: Verify CLAUDE.md, skills, commands work
3. **Behavior matches docs**: Test the documented workflows

---

## Pull Request Process

### Preparing Your Contribution

1. **Fork the repository** (external contributors)
2. **Create a feature branch**: `feature/add-my-skill`
3. **Make your changes** following this guide
4. **Test thoroughly** per the testing requirements
5. **Update relevant catalogs** (CATALOG.md, README.md)

### PR Checklist

Before submitting, verify:

- [ ] New assets start in `experimental/` OR are graduated with justification
- [ ] SKILL.md passes `validate-skill.sh` (for skills)
- [ ] plugin.json is valid JSON (for plugins)
- [ ] README.md exists and is complete
- [ ] CATALOG.md updated if adding to `library/`
- [ ] No sensitive information (keys, tokens, personal data)
- [ ] Tested manually and working

### PR Description Template

```markdown
## What

Brief description of what this PR adds or changes.

## Type

- [ ] New skill
- [ ] New plugin
- [ ] New config kit
- [ ] Documentation
- [ ] Bug fix
- [ ] Other: ___

## Testing Done

Describe how you tested this contribution.

## Checklist

- [ ] Follows contribution guidelines
- [ ] Passes validation scripts
- [ ] Documentation complete
```

---

## Getting Help

If you have questions:

1. **Check existing examples** in `library/` for patterns to follow
2. **Use claude-code-advisor** (`/cc-advisor`) for feature questions
3. **Open an issue** for clarification before starting complex contributions

---

## Thank You

Your contributions help make Claude Code more useful for everyone. We appreciate your time and effort in following these guidelines to maintain quality and consistency.
