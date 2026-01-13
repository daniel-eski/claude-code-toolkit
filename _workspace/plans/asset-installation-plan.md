# Plan: Strategic Claude Code Asset Installation

> **Status**: Ready for Execution
> **Created**: 2026-01-12
> **Objective**: Install 6 skills + evaluate claude-learnings plugin

---

## Summary

Install 6 high-value skills at once, then evaluate claude-learnings plugin. Conservative, selective approach that amplifies existing workflow patterns.

**Current State**: 1 skill installed, 3 hooks active, claude-hud working
**Target State**: 7 skills + claude-learnings plugin (if evaluation passes)

---

## Phase 1: Skill Installation (All 6 at Once)

### Tier 1 Skills (Amplify Orchestration)

| Skill | Lines | Purpose |
|-------|-------|---------|
| `dispatching-parallel-agents` | 180 | Decision framework for parallel subagent work |
| `subagent-driven-development` | 240 | Full workflow for plan execution with subagents |
| `writing-plans` | 116 | Structures strategic documentation |

### Tier 2 Skills (Fill Gaps)

| Skill | Lines | Purpose |
|-------|-------|---------|
| `git-commit` | 235 | Conventional Commits standardization |
| `systematic-debugging` | 296 | Methodical root cause investigation |
| `verification-before-completion` | 139 | Checklist before marking done |

### Installation Commands

```bash
cd /Users/danieleskenazi/Desktop/Repos/claude-code-toolkit

# Tier 1
./library/tools/deploy-skill.sh core-skills/obra-workflow/dispatching-parallel-agents
./library/tools/deploy-skill.sh core-skills/obra-development/subagent-driven-development
./library/tools/deploy-skill.sh core-skills/obra-workflow/writing-plans

# Tier 2
./library/tools/deploy-skill.sh core-skills/git-workflow/fvadicamo-dev-agent/git-commit
./library/tools/deploy-skill.sh core-skills/obra-development/systematic-debugging
./library/tools/deploy-skill.sh core-skills/obra-development/verification-before-completion
```

### Verification

```bash
# Check skills deployed
ls ~/.claude/skills/

# Expected output:
# dispatching-parallel-agents/
# git-commit/
# subagent-driven-development/
# systematic-debugging/
# verification-before-completion/
# workflow-reflection/  (already existed)
# writing-plans/
```

---

## Phase 2: Plugin Evaluation (claude-learnings)

### Test in Isolation

```bash
claude --plugin-dir ./library/plugins/local/claude-learnings
```

### Evaluation Criteria

| Criterion | Check |
|-----------|-------|
| Commands load | `/log`, `/log_error`, `/log_success`, `/checkpoint`, `/restore`, `/review-learnings` visible |
| No conflicts | Existing hooks still trigger |
| Value-add | Learning capture useful for knowledge curation work |
| Context overhead | Acceptable impact on session context |

### If Evaluation Passes

Add to `~/.claude/settings.json`:
```json
{
  "plugins": {
    "directories": [
      "/path/to/library/plugins/local/claude-learnings"
    ]
  }
}
```

---

## Phase 3: Final Verification

1. **Start new Claude session**
2. **Check skills available**: Ask "What skills do I have?"
3. **Test hook functionality**:
   - Try to write outside working directory (should be blocked)
   - Try git push to main (should be blocked)
4. **Test a skill trigger**: Ask about parallel agent dispatch

---

## What We're NOT Installing

| Asset | Reason |
|-------|--------|
| AWS skills (4) | Not relevant to current work |
| Document skills (docx, xlsx, pdf) | Install on-demand when needed |
| test-driven-development | Install if doing more implementation work |
| claude-code-advisor plugin | Large context overhead - reserve for specific needs |
| compound-engineering-plugin | Deferred - separate evaluation task |
| workflow-optimizer plugin | Already have workflow-optimizer-kit installed |
| context-introspection plugin | Evaluate after claude-learnings |

---

## Rollback Strategy

**Remove a skill:**
```bash
rm -rf ~/.claude/skills/[skill-name]
```

**Remove plugin from settings:**
Edit `~/.claude/settings.json` and remove from plugins.directories array

**Full backup (before starting):**
```bash
cp -r ~/.claude ~/.claude.backup.$(date +%Y%m%d)
```

---

## Success Criteria

- [ ] 6 new skills deployed to `~/.claude/skills/`
- [ ] Total 7 skills available (including existing workflow-reflection)
- [ ] Existing hooks still function
- [ ] claude-learnings plugin evaluated
- [ ] Decision made on plugin installation

---

## Estimated Time

| Phase | Time |
|-------|------|
| Phase 1: Skill Installation | 10 min |
| Phase 2: Plugin Evaluation | 15 min |
| Phase 3: Verification | 5 min |
| **Total** | ~30 min |
