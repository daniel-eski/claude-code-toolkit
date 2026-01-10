# Architecture Examples

Real-world Claude Code configurations for common project types.

## Example 1: TypeScript Web Application

```
project/
├── CLAUDE.md
├── .claude/
│   ├── rules/
│   │   ├── api.md                    # paths: src/api/**
│   │   └── components.md             # paths: src/components/**
│   ├── skills/
│   │   └── react-patterns/SKILL.md
│   └── commands/
│       ├── test.md
│       └── deploy.md
└── .mcp.json                          # Database connection
```

**CLAUDE.md**:
```markdown
# Web App
- TypeScript strict, ESLint enforced
- Run: npm test | npm run build | npm run dev
- Commits follow conventional format
```

**Path rule (api.md)**:
```yaml
---
paths: src/api/**/*.ts
---
# API Rules
- All endpoints need auth middleware
- Use Zod for validation
- Return standard error format
```

---

## Example 2: Python Data Science

```
project/
├── CLAUDE.md
├── .claude/
│   ├── skills/
│   │   ├── pandas-patterns/SKILL.md
│   │   └── ml-workflow/SKILL.md
│   └── agents/
│       └── data-explorer.md
└── .mcp.json                          # Database for queries
```

**CLAUDE.md**:
```markdown
# Data Project
- Python 3.11, use virtual env
- Run: pytest | python -m mypy .
- Data in data/, outputs in outputs/
```

**Subagent (data-explorer.md)**:
```yaml
---
name: data-explorer
description: Explore datasets. Use proactively when analyzing data.
model: sonnet
tools: Read, Bash
---
Analyze data files, compute statistics, identify patterns.
```

---

## Example 3: Microservices Platform

```
platform/
├── CLAUDE.md
├── .claude/
│   ├── rules/
│   │   ├── services/
│   │   │   └── auth-service.md       # paths: services/auth/**
│   │   └── shared/
│   │       └── grpc.md               # paths: **/*.proto
│   ├── skills/
│   │   ├── k8s-deployment/SKILL.md
│   │   └── observability/SKILL.md
│   ├── agents/
│   │   └── service-reviewer.md
│   └── settings.json                  # Hooks for validation
└── .mcp.json
```

**Hooks (settings.json)**:
```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "command",
        "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/lint-check.sh"
      }]
    }]
  }
}
```

---

## Example 4: CLI Tool

```
cli-tool/
├── CLAUDE.md
├── .claude/
│   ├── skills/
│   │   └── cli-patterns/SKILL.md
│   └── commands/
│       ├── release.md
│       └── docs.md
```

**CLAUDE.md**:
```markdown
# CLI Tool
- Go 1.21, use cobra for commands
- Run: go test ./... | go build
- Follow 12-factor for config
```

**Skill (cli-patterns)**:
```yaml
---
name: cli-patterns
description: CLI development patterns. Use when building commands or parsing args.
---
# CLI Patterns
- Use cobra for command structure
- Viper for configuration
- Exit codes: 0=success, 1=error, 2=usage error
```

---

## Example 5: Minimal Setup

For simple projects:

```
project/
├── CLAUDE.md
└── .claude/
    └── commands/
        └── test.md
```

**CLAUDE.md**:
```markdown
# Project
- Node.js, npm for package management
- Run tests: npm test
- Build: npm run build
```

Start minimal, add features as needed.

---

## Configuration Checklist

Before deploying a configuration:

- [ ] CLAUDE.md is minimal (only always-needed)
- [ ] Skills have clear trigger descriptions
- [ ] Path rules target specific patterns
- [ ] Subagents have purpose and tools defined
- [ ] Hooks are lightweight (no complex logic)
- [ ] Commands have descriptions and argument hints

See also:
- `composition-patterns.md` for feature combinations
- `anti-patterns.md` for what to avoid
