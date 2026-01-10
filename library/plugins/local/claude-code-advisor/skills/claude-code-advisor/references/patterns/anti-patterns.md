# Anti-Patterns

Common mistakes to avoid when configuring Claude Code.

## Anti-Pattern 1: Monolithic CLAUDE.md

**Problem**: Everything in CLAUDE.md bloats every session.

```markdown
<!-- BAD: CLAUDE.md with everything -->
# Project Setup
[500 lines of setup instructions...]

# API Guidelines
[300 lines of API docs...]

# Security Checklist
[200 lines of security info...]

# Testing Guide
[400 lines of test patterns...]
```

**Why it's bad**: All of this loads EVERY session, even when not relevant.

**Fix**: Move situational content to skills or path rules.

```markdown
<!-- GOOD: Minimal CLAUDE.md -->
# Project
- Run tests: npm test
- Build: npm run build
- We use TypeScript strict mode
```

---

## Anti-Pattern 2: Skills for Simple Triggers

**Problem**: Using skills when slash commands are more appropriate.

```yaml
# BAD: Skill just to trigger a simple prompt
---
name: quick-deploy
description: Deploy to staging
---
Run: npm run deploy:staging
```

**Why it's bad**: Over-engineering. Skills are for domain expertise, not simple triggers.

**Fix**: Use slash command.

```markdown
<!-- GOOD: .claude/commands/deploy.md -->
Run: npm run deploy:$ARGUMENTS
```

---

## Anti-Pattern 3: Subagents for Knowledge Sharing

**Problem**: Using subagent expecting knowledge to flow back to main.

```
User: "Use the research-agent to learn about our auth system"
# Subagent researches, returns summary
# User expects main Claude to now "know" everything
```

**Why it's bad**: Subagent context is ISOLATED. Only summary returns.

**Fix**: Use skill for knowledge, subagent only for isolated work.

```yaml
# GOOD: Skill for knowledge
---
name: auth-patterns
description: Authentication expertise
---
[Auth patterns and guidelines...]
```

---

## Anti-Pattern 4: Everything in One Skill

**Problem**: Single massive skill with all domain content.

```
.claude/skills/everything/
├── SKILL.md (5000 lines)
└── references/ (empty)
```

**Why it's bad**: Loads too much context, poor discoverability.

**Fix**: Separate by domain with clear descriptions.

```
.claude/skills/
├── api-design/SKILL.md
├── database/SKILL.md
├── security/SKILL.md
└── testing/SKILL.md
```

---

## Anti-Pattern 5: Complex Hook Logic

**Problem**: Heavy processing in hook scripts.

```python
# BAD: Hook doing deep analysis
def on_post_tool(data):
    # Read 100 files
    # Run multiple tools
    # Complex analysis
    # Takes 30+ seconds
```

**Why it's bad**: Hooks should be lightweight. Delays tool completion.

**Fix**: Spawn subagent for complex work.

```python
# GOOD: Hook triggers analysis, doesn't do it
def on_post_tool(data):
    if needs_review(data):
        return {"decision": "block", "reason": "Needs security review"}
```

---

## Anti-Pattern 6: Blind File Generation

**Problem**: Generating config files without understanding context.

```
User: "Create a CLAUDE.md for my project"
Claude: [Generates generic template without reading codebase]
```

**Why it's bad**: Generic content, doesn't match actual project.

**Fix**: Verify understanding first.

```
1. Read existing files (package.json, etc.)
2. Understand project structure
3. Generate tailored content
```

---

## Anti-Pattern 7: Deeply Nested References

**Problem**: Skill references that chain multiple levels.

```
SKILL.md → reference-a.md → reference-b.md → reference-c.md
```

**Why it's bad**: Each hop costs context. Claude may lose track.

**Fix**: Keep references one level deep from SKILL.md.

```
SKILL.md
├── reference-a.md
├── reference-b.md
└── reference-c.md
```

---

## Anti-Pattern Summary

| Anti-Pattern | Problem | Fix |
|--------------|---------|-----|
| Monolithic CLAUDE.md | Bloats every session | Skills/path rules |
| Skills for triggers | Over-engineering | Slash commands |
| Subagents for knowledge | Context doesn't return | Skills |
| One massive skill | Poor discoverability | Separate by domain |
| Complex hooks | Slow, unreliable | Spawn subagent |
| Blind generation | Generic output | Verify first |
| Nested references | Context loss | One level deep |

See also:
- `composition-patterns.md` for what TO do
- `../decision-guides/` for feature selection guidance
