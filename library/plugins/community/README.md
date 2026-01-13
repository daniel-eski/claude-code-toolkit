# Community Plugins

> Evaluated external plugins that have been added to the toolkit.

---

## What's Here

This directory contains community plugins that have passed our evaluation framework and been added to the toolkit for local use.

| Plugin | Source | Score | Added |
|--------|--------|-------|-------|
| *(None yet)* | - | - | - |

---

## Evaluation Status

See `_workspace/backlog/external-expansion.md` for:
- Plugins pending evaluation
- Plugins indexed but not copied
- Evaluation records

---

## Adding a Community Plugin

1. **Evaluate** using the framework: `../EVALUATION-FRAMEWORK.md`
2. **Score** must be 25+ to add here (see decision matrix)
3. **Copy** the plugin with full structure
4. **Create** a `.source` file tracking origin
5. **Update** this README table
6. **Update** `../README.md` with the new plugin

### .source File Format

```json
{
  "origin": "[github-url]",
  "fetched_date": "[YYYY-MM-DD]",
  "source_commit": "[commit-sha]",
  "asset_type": "plugin",
  "status": "community",
  "evaluation_score": [0-30],
  "notes": "[any relevant notes]"
}
```

---

## Quality Expectations

Community plugins in this directory have been:
- ✅ Evaluated against our framework
- ✅ Tested for basic functionality
- ✅ Reviewed for security concerns
- ✅ Documented appropriately

They may not be:
- Actively maintained (check `.source` for last update)
- Compatible with all Claude Code versions
- As polished as official or local plugins

---

## Candidates for Evaluation

High-priority plugins to evaluate (from backlog):

| Plugin | Stars | Notes |
|--------|-------|-------|
| compound-engineering-plugin | 4.3k★ | "80% planning, 20% execution" philosophy |
| claude-workflow-v2 | - | 7 agents, 17 commands |
| claude-hud | - | Status line (already using) |

See `_workspace/backlog/external-expansion.md` for full list.

---

## Related

- **Evaluation framework**: `../EVALUATION-FRAMEWORK.md`
- **Official plugins**: `../official/CATALOG.md`
- **Local plugins**: `../local/README.md`
- **Backlog**: `_workspace/backlog/external-expansion.md`

---

*Updated: 2026-01-12*
