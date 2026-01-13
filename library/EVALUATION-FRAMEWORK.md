# External Resource Evaluation Framework

> How we evaluate external plugins, skills, and configuration kits before adding to the toolkit.

---

## Purpose

This framework ensures consistent quality when evaluating external resources for inclusion in the toolkit. It applies to:
- Plugins from community repositories
- Skills from external collections
- Configuration kits from other sources

**Design principle**: Pointer-first. We prefer referencing external resources over copying them, unless there's clear value in local inclusion.

---

## Quick Assessment (5 minutes)

Use this checklist for initial screening:

| Criterion | Weight | Question |
|-----------|--------|----------|
| **Works** | Critical | Does it actually run without errors? |
| **Documented** | High | Does README explain installation and usage? |
| **Maintained** | High | Recent commits? Issues addressed? |
| **Safe** | Critical | No obvious security issues or suspicious behavior? |
| **Non-redundant** | Medium | Does it add value beyond existing content? |

**Quick decision**:
- All Critical items must pass
- If 2+ High items fail → Skip or Defer
- If passes all → Proceed to detailed assessment

---

## Detailed Assessment (15-30 minutes)

### Quality Score (0-10)

| Factor | 0-3 (Poor) | 4-6 (Acceptable) | 7-10 (Good) |
|--------|------------|------------------|-------------|
| **Code quality** | Messy, hard to read | Works but needs cleanup | Clean, well-structured |
| **Documentation** | Missing or wrong | Basic README | Complete with examples |
| **Testing** | None | Some manual testing | Automated tests |
| **Error handling** | Crashes on errors | Basic error messages | Graceful failures |

### Fit Score (0-10)

| Factor | 0-3 (Poor) | 4-6 (Acceptable) | 7-10 (Good) |
|--------|------------|------------------|-------------|
| **Problem solved** | Niche, unclear value | Useful for some | Broadly valuable |
| **Integration** | Conflicts with existing | Coexists | Complements existing |
| **Conventions** | Ignores Claude Code patterns | Partially follows | Follows best practices |
| **Complexity** | Over-engineered | Some bloat | Right-sized |

### Trust Score (0-10)

| Factor | 0-3 (Poor) | 4-6 (Acceptable) | 7-10 (Good) |
|--------|------------|------------------|-------------|
| **Author** | Unknown, no history | Some track record | Known, reputable |
| **License** | Unclear or restrictive | Common open source | MIT/Apache/similar |
| **Permissions** | Suspicious access | Understandable access | Minimal needed access |
| **Community** | None | Some stars/forks | Active community |

---

## Decision Matrix

| Total Score (0-30) | Decision | Action |
|--------------------|----------|--------|
| **25-30** | **Add** | Copy to `library/` with full documentation |
| **18-24** | **Index** | Add reference to backlog, don't copy |
| **12-17** | **Defer** | Note for future reconsideration |
| **<12** | **Skip** | Not suitable for this toolkit |

### Special Cases

| Situation | Guidance |
|-----------|----------|
| High trust, low quality | Index only - potential future improvement |
| High quality, low fit | Index only - may suit other toolkits |
| Critical security concerns | Skip regardless of other scores |
| Abandonment risk (no commits >1 year) | Prefer indexing over copying |

---

## Evaluation Record Template

When evaluating a resource, create a record in `_workspace/backlog/external-expansion.md`:

```yaml
### [resource-name]
- **Type**: plugin/skill/config-kit
- **URL**: [github url]
- **Evaluated**: [YYYY-MM-DD]
- **Scores**:
  - Quality: [0-10]
  - Fit: [0-10]
  - Trust: [0-10]
  - Total: [0-30]
- **Decision**: add/index/defer/skip
- **Quick assessment**:
  - Works: yes/no/untested
  - Documented: yes/partial/no
  - Maintained: active/stale/abandoned
  - Safe: yes/concerns/no
  - Non-redundant: yes/partial/no
- **Notes**: [Key observations, concerns, recommendations]
```

---

## Where Evaluated Resources Go

| Decision | Location | Format |
|----------|----------|--------|
| **Add** | `library/plugins/community/` or `library/skills/community/` | Full copy with `.source` file |
| **Index** | `_workspace/backlog/external-expansion.md` | Reference with evaluation record |
| **Defer** | `_workspace/backlog/external-expansion.md` | Note with reason for deferral |
| **Skip** | Not recorded | Unless helpful to document why |

---

## Evaluation Workflow

### For Plugins

```bash
# 1. Clone/download locally
git clone [repo-url] /tmp/eval-plugin

# 2. Quick functionality test
claude --plugin-dir /tmp/eval-plugin

# 3. Check for security concerns
# - Review hooks for suspicious commands
# - Check for network calls
# - Review file access patterns

# 4. Score and decide
# 5. If adding: copy to library/plugins/community/
```

### For Skills

```bash
# 1. Fetch skill
./library/tools/fetch-skill.sh [url] /tmp/eval-skill

# 2. Validate format
./library/tools/validate-skill.sh /tmp/eval-skill

# 3. Manual review
# - Read SKILL.md for quality
# - Check for conflicts with existing skills

# 4. Score and decide
# 5. If adding: copy to library/skills/community/
```

### For Config Kits

```bash
# 1. Review structure
# - Check for install.sh
# - Review CLAUDE.md content
# - Check for hooks and their behavior

# 2. Test in isolation
# - Backup existing ~/.claude/
# - Test installation
# - Verify functionality

# 3. Score and decide
# 4. If adding: copy to library/configs/
```

---

## Maintenance

### Re-evaluation Triggers

Re-evaluate indexed resources when:
- Major version update released
- Significant star/fork growth
- User request
- Related resource added (may change fit score)

### Update Frequency

| Category | Check Frequency |
|----------|-----------------|
| Added resources | Monthly (freshness-report.sh) |
| Indexed resources | Quarterly |
| Deferred resources | Annually |

---

## Related Documentation

- **Contributing guide**: `CONTRIBUTING.md` - How to add resources to the toolkit
- **External expansion backlog**: `_workspace/backlog/external-expansion.md` - Resources to evaluate
- **Maintenance guide**: `_workspace/planning/maintenance-guide.md` - Ongoing maintenance

---

*Created: 2026-01-12*
*Framework version: 1.0*
