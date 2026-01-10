# Skill Authoring Guide

Step-by-step guide to creating effective Claude Code skills.

## Step 1: Plan Your Skill

Before writing, answer:

1. **What domain?** (e.g., security review, API design)
2. **What triggers it?** (keywords users might say)
3. **What content?** (guidance, references, scripts)
4. **How much content?** (keep SKILL.md under 500 lines)

## Step 2: Create Directory Structure

```bash
mkdir -p .claude/skills/my-skill/references
```

Minimal structure:
```
.claude/skills/my-skill/
└── SKILL.md
```

With resources:
```
.claude/skills/my-skill/
├── SKILL.md
├── references/
│   ├── checklist.md
│   └── examples.md
└── scripts/
    └── validate.sh
```

## Step 3: Write SKILL.md

### Template

```yaml
---
name: my-skill-name
description: Third-person description with trigger keywords. Use when [triggers].
allowed-tools: Read, Grep  # Optional: restrict tools
model: claude-sonnet-4     # Optional: specific model
---

# Skill Name

## Overview
Brief introduction to this skill's purpose.

## When to Use
- Trigger scenario 1
- Trigger scenario 2

## Guidance
Main instructions for Claude...

## References
- See [checklist.md](references/checklist.md) for detailed checklist
- Run `./scripts/validate.sh` for validation
```

### Frontmatter Rules

| Field | Required | Guidelines |
|-------|----------|------------|
| `name` | Yes | Lowercase, hyphens, max 64 chars |
| `description` | Yes | Third-person, include triggers, max 1024 chars |
| `allowed-tools` | No | Comma-separated tool names |
| `model` | No | Specific model if needed |

### Description Best Practices

**Good**:
```yaml
description: Security review expertise. Checks for OWASP Top 10 vulnerabilities,
  injection risks, and authentication issues. Use when reviewing code for security,
  auditing authentication, or checking for vulnerabilities.
```

**Bad**:
```yaml
description: Helps with security stuff
```

## Step 4: Add References (Optional)

Create reference files for detailed content:

```markdown
<!-- references/security-checklist.md -->
# Security Checklist

## Injection Prevention
- [ ] Parameterized queries
- [ ] Input validation
- [ ] Output encoding

## Authentication
- [ ] Password hashing (bcrypt/argon2)
- [ ] Session management
- [ ] MFA support
```

Reference from SKILL.md:
```markdown
See [security-checklist.md](references/security-checklist.md) for full checklist.
```

## Step 5: Add Scripts (Optional)

For executable validation or processing:

```bash
#!/bin/bash
# scripts/lint-check.sh
npm run lint
echo "Lint check complete"
```

Reference from SKILL.md:
```markdown
Run `./scripts/lint-check.sh` to check code style.
```

## Step 6: Test Your Skill

1. **Discovery test**: Ask something that should trigger the skill
   ```
   > "Can you review this code for security issues?"
   ```

2. **Verify loading**: Check skill appears in context

3. **Test references**: Confirm Claude reads reference files when needed

4. **Test scripts**: Verify scripts execute correctly

## Checklist Before Deployment

- [ ] `name` is unique and descriptive
- [ ] `description` includes trigger keywords
- [ ] SKILL.md is under 500 lines
- [ ] References are one level deep (no nesting)
- [ ] All file paths are relative
- [ ] Scripts are executable (`chmod +x`)

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Vague description | Add specific trigger keywords |
| SKILL.md too long | Move details to references |
| Nested references | Keep one level deep |
| Absolute paths | Use relative paths |
| Non-executable scripts | `chmod +x script.sh` |

See also:
- `../feature-mechanics/skills-deep-dive.md` for mechanics
- `../patterns/composition-patterns.md` for skill patterns
