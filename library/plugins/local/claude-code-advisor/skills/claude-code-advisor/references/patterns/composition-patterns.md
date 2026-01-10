# Composition Patterns

Proven patterns for combining Claude Code features effectively.

## Pattern 1: Isolated Expert

**Combine**: Subagent + Pre-loaded Skills

**Purpose**: Heavy processing with domain expertise, without polluting main context.

```yaml
# .claude/agents/security-reviewer.md
---
name: security-reviewer
description: Security expert. Use proactively after code changes.
skills: owasp-checks, secure-coding
model: sonnet
tools: Read, Grep, Glob
---

You are a security expert reviewing code for vulnerabilities.
Check for OWASP Top 10 issues, injection risks, auth problems.
```

**When to use**:
- Deep code review
- Security audits
- Complex analysis
- Heavy file processing

---

## Pattern 2: Event-Triggered Specialist

**Combine**: Hook + Subagent

**Purpose**: Automatic quality gates with complex analysis.

```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "prompt",
        "prompt": "Evaluate if this code change needs security review. If yes, respond with decision:block and reason explaining what to check."
      }]
    }]
  }
}
```

**When to use**:
- Auto-triggered reviews
- Conditional deep analysis
- Quality enforcement
- Compliance checks

---

## Pattern 3: Layered Context

**Combine**: CLAUDE.md + Path Rules + Skills

**Purpose**: Progressive context based on what's being worked on.

```
.claude/
├── CLAUDE.md              # Always: "We use TypeScript, run npm test"
└── rules/
    ├── api/
    │   └── endpoints.md   # paths: src/api/** - API auth rules
    └── ui/
        └── components.md  # paths: src/components/** - React patterns
```

Plus skill:
```yaml
# .claude/skills/api-design/SKILL.md
---
name: api-design
description: API design expertise. Use when designing or reviewing APIs.
---
```

**When to use**:
- Different rules for different code areas
- Layered standards
- Progressive disclosure of context

---

## Pattern 4: Tool Teacher

**Combine**: MCP + Skill

**Purpose**: External tools with usage knowledge.

```bash
# Add MCP server
claude mcp add --transport stdio db -- npx @bytebase/dbhub --dsn "..."
```

```yaml
# .claude/skills/database-queries/SKILL.md
---
name: database-queries
description: Database query expertise. Use when writing or optimizing SQL.
---

# Database Query Patterns

## Our Schema
- users: id, email, created_at
- orders: id, user_id, total, status

## Query Patterns
- Always use parameterized queries
- Join optimization: index on foreign keys
- Use EXPLAIN for complex queries
```

**When to use**:
- Database integrations
- API clients with patterns
- External services with conventions

---

## Pattern 5: Command + Skill

**Combine**: Slash Command + Skill

**Purpose**: User-controlled trigger with rich guidance.

```markdown
<!-- .claude/commands/deploy.md -->
---
description: Deploy to environment
argument-hint: [staging|production]
---
/deploy $ARGUMENTS
```

```yaml
# .claude/skills/deployment/SKILL.md
---
name: deployment
description: Deployment expertise. Use when deploying or discussing deployment.
---

# Deployment Checklist
1. Run tests: npm test
2. Build: npm run build
3. Environment check: verify .env
4. Deploy command: npm run deploy:$ENV
```

**When to use**:
- Complex workflows with explicit triggers
- Guided processes

---

## Pattern 6: Full Stack

**Combine**: All features for complex projects

```
Project/
├── CLAUDE.md                    # Foundation
├── .claude/
│   ├── rules/                   # Path-specific rules
│   │   ├── api/
│   │   └── frontend/
│   ├── skills/                  # Domain expertise
│   │   ├── security/
│   │   └── performance/
│   ├── agents/                  # Isolated processing
│   │   ├── code-reviewer.md
│   │   └── security-auditor.md
│   ├── commands/                # Explicit triggers
│   │   ├── deploy.md
│   │   └── release.md
│   └── settings.json            # Hooks
└── .mcp.json                    # External tools
```

**When to use**:
- Large team projects
- Complex codebases
- Multiple integrations

---

## Pattern Selection Guide

| Need | Pattern |
|------|---------|
| Heavy work + expertise | Isolated Expert |
| Auto-quality gates | Event-Triggered Specialist |
| Different rules per area | Layered Context |
| External tools + knowledge | Tool Teacher |
| User-controlled + guidance | Command + Skill |
| Everything | Full Stack |

See also:
- `anti-patterns.md` for what to avoid
- `../decision-guides/architecture-selection.md` for choosing features
