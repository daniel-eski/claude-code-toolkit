# Skill Authoring

Meta skills for creating new Claude Code skills from [anthropics/skills](https://github.com/anthropics/skills).

## Skills

| Skill | Description |
|-------|-------------|
| skill-creator | Anthropic's official skill development guide |
| template | Anthropic's skill creation template |

## Creating a New Skill

### 1. Start with the template

Copy the `template/` directory as a starting point:

```bash
cp -r template/ my-new-skill/
```

### 2. Follow the skill-creator guide

The `skill-creator` skill provides comprehensive guidance on:
- SKILL.md structure and frontmatter
- Writing effective descriptions (the trigger mechanism)
- Organizing scripts and references
- Best practices for skill design

### 3. SKILL.md Structure

```yaml
---
name: my-skill-name    # 1-64 chars, lowercase, hyphens only
description: >-        # 1-1024 chars - THIS IS THE TRIGGER
  Clear description of what this skill does and when to use it.
---

# Quick Start

Minimal steps to get started.

# Core Workflow

Main steps with code examples.

# Important Rules

Critical constraints using **ALWAYS** and **NEVER**.
```

### 4. Validate and deploy

```bash
cd ../../tools/
./validate-skill.sh ../core-skills/skill-authoring/my-new-skill
./deploy-skill.sh ../core-skills/skill-authoring/my-new-skill
```

## Key Principles

1. **Description is the trigger**: Claude uses only the description to decide when to invoke a skill
2. **Keep it concise**: SKILL.md should be under 500 lines
3. **Progressive disclosure**: Put details in `references/` directory
4. **Self-contained**: Include all necessary scripts and resources
