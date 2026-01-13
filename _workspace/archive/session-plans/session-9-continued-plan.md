# Plan: Quick Wins, Evaluation Framework & Link Fixes

> **Status**: Ready for approval
> **Created**: 2026-01-12 (Session 9 continued)
> **Scope**: library/ only (experimental/ excluded per user decision)

---

## Summary

**Three phases**:
1. **Quick Wins** (4 items, ~1-1.5 hours) - Low effort, immediate value
2. **Evaluation Framework** (~1-2 hours) - Foundation for future expansion
3. **Broken Links Fix** (~2-3 hours) - Quality improvement (library/ only)

**Strategic Order Rationale**:
- Quick wins first → immediate value, build momentum
- Framework before links → establishes standards for evaluating what to fix vs. remove
- Links last → tedious work benefits from clear decision framework

---

## Phase 1: Quick Wins

### 1A. Add HUD Plugin to External Plugins (~5 min)

**File**: `_workspace/backlog/external-expansion.md`

**Add under "Plugins" section**:
```markdown
#### jarrodwatts/claude-hud - USING
- **URL**: https://github.com/jarrodwatts/claude-hud
- **What it does**: Real-time session info in terminal statusline
- **Features**: Context usage bar, tool activity, git status, usage monitoring
- **Status**: ✅ Currently installed and configured
- **Notes**: Integrates via statusLine config in settings.json
```

---

### 1B. Complete CONTRIBUTING.md Config Kit Section (~10 min)

**File**: `CONTRIBUTING.md`
**Action**: Replace `<!-- TODO: Configuration kit contribution -->` with:

```markdown
### Configuration Kits

Configuration kits live in `library/configs/`. To add a new config kit:

1. Create a directory with the kit name
2. Include at minimum:
   - `README.md` - Overview, installation, usage
   - `config/` - The actual configuration files
   - `install.sh` (optional) - Automated installation script

3. Follow the structure of `workflow-optimizer-kit/` as a template

4. Document:
   - What problem this config solves
   - Prerequisites and dependencies
   - Step-by-step installation
   - Verification steps
   - Customization options
```

---

### 1C. Add Plugin vs Config Kit Guidance (~10 min)

**File**: `library/configs/README.md`
**Action**: Add new section after line 76:

```markdown
---

## Choosing Between Plugin and Config Kit

| Use Case | Recommendation |
|----------|----------------|
| I want reusable skills for any project | workflow-optimizer plugin |
| I want to change Claude's behavior globally | workflow-optimizer-kit config |
| I want explicit /commands | Both (different commands) |
| I want automatic skill activation | workflow-optimizer plugin |
| I want CLAUDE.md behavioral shaping | workflow-optimizer-kit config |

**Can I use both?** Yes! They complement each other:
- **Plugin** provides skills: prompt-optimizer, planning-with-files, agent-architect
- **Kit** provides meta-cognitive behavior via CLAUDE.md + /kickoff, /reflect commands

**Related**: See `library/plugins/local/workflow-optimizer/` for the plugin version.
```

---

### 1D. Update Stale AWS Skills (~15 min)

**Commands**:
```bash
# Check current staleness
./library/tools/freshness-report.sh

# Update from upstream (if update-sources.sh exists)
./library/tools/update-sources.sh --fetch

# Or manually fetch each:
cd library/skills/extended-skills/aws-skills/
git -C aws-agentic-ai pull origin main  # if they're git repos
# Or re-fetch from source
```

**Skills to update**:
- aws-agentic-ai
- aws-cdk-development
- aws-cost-operations
- aws-serverless-eda

**Note**: These skills have many internal broken links (22 in aws-agentic-ai alone). Updating may or may not fix them - they may be broken upstream.

---

### Phase 1 Execution Strategy

| Item | Parallelizable | Agent Needed |
|------|----------------|--------------|
| 1A | Yes | No |
| 1B | Yes | No |
| 1C | Yes | No |
| 1D | No (sequential) | No |

**Recommendation**: Do 1A, 1B, 1C in parallel (3 edits), then 1D.

---

## Phase 2: Evaluation Framework for External Plugins

### 2.1 What We're Creating

| Artifact | Location | Purpose |
|----------|----------|---------|
| Evaluation framework | `library/EVALUATION-FRAMEWORK.md` | Reusable criteria for plugins, skills, config kits |
| Community plugins README | `library/plugins/community/README.md` | Index of evaluated external plugins |

### 2.2 Framework Content

**File**: `library/EVALUATION-FRAMEWORK.md`

```markdown
# External Resource Evaluation Framework

> How we evaluate external plugins, skills, and configuration kits before adding to the toolkit.

## Quick Assessment (5 minutes)

| Criterion | Weight | Question |
|-----------|--------|----------|
| **Works** | Critical | Does it actually run without errors? |
| **Documented** | High | Does README explain installation and usage? |
| **Maintained** | High | Recent commits? Issues addressed? |
| **Safe** | Critical | No obvious security issues or suspicious behavior? |
| **Non-redundant** | Medium | Does it add value beyond existing content? |

## Detailed Assessment (15-30 minutes)

### Quality Score (0-10)
- Code quality: Clean, well-structured, follows conventions?
- Documentation: Complete, accurate, helpful examples?
- Testing: Any tests? Do they pass?
- Error handling: Fails gracefully with clear messages?

### Fit Score (0-10)
- Solves real problem for this toolkit's audience?
- Integrates naturally with existing content?
- Follows Claude Code conventions?
- Appropriate complexity (not over-engineered)?

### Trust Score (0-10)
- Known author or organization?
- Open source with clear license?
- No suspicious permissions, network calls, or file access?
- Community adoption (stars, forks, issues)?

## Decision Matrix

| Total Score (0-30) | Decision |
|--------------------|----------|
| 25-30 | **Add**: Copy to library/ with full documentation |
| 18-24 | **Index**: Reference in backlog, don't copy |
| 12-17 | **Defer**: Note for future consideration |
| <12 | **Skip**: Not suitable for this toolkit |

## Evaluation Record Template

When evaluating a resource, create a record:

```yaml
name: [resource-name]
type: [plugin/skill/config-kit]
url: [github url]
evaluated_date: [YYYY-MM-DD]
evaluator: [who - human/Claude]

scores:
  quality: [0-10]
  fit: [0-10]
  trust: [0-10]
  total: [0-30]

decision: [add/index/defer/skip]

quick_assessment:
  works: [yes/no/untested]
  documented: [yes/partial/no]
  maintained: [active/stale/abandoned]
  safe: [yes/concerns/no]
  non_redundant: [yes/partial/no]

notes: |
  [Key observations, concerns, or recommendations]
```

## Where Records Go

- **Add decisions**: Create entry in appropriate catalog
- **Index decisions**: Add to `_workspace/backlog/external-expansion.md`
- **Defer/Skip**: Note in backlog with reason
```

### 2.3 Subagent Strategy

**Recommended**: Use 1 Plan agent to:
- Review existing patterns in the repo
- Ensure framework fits with CONTRIBUTING.md guidelines
- Consider edge cases (skills vs plugins vs config kits)

### 2.4 Files to Create/Modify

| File | Action |
|------|--------|
| `library/EVALUATION-FRAMEWORK.md` | Create |
| `library/plugins/community/README.md` | Create (placeholder for future evaluations) |
| `_workspace/backlog/external-expansion.md` | Update to reference framework |

---

## Phase 3: Fix Broken Links (Library Only)

### 3.1 Scope

**In scope**: `library/` directory only
**Out of scope**: `experimental/` (reference copies, not maintained)

### 3.2 Current Broken Links Analysis

| Location | Count | Root Cause |
|----------|-------|------------|
| `library/skills/core-skills/document-creation/docx/` | 3 | Missing reference docs |
| `library/skills/core-skills/document-creation/pptx/` | 3 | Missing reference docs |
| `library/skills/core-skills/skill-authoring/skill-creator/` | 6 | Missing reference files |
| `library/skills/extended-skills/aws-skills/aws-agentic-ai/` | 22 | Missing service docs |
| `library/plugins/local/workflow-optimizer/` | 3 | Missing reference files |
| `library/plugins/local/claude-code-advisor/` | 6 | Missing reference files |
| **Total** | ~43 | (in library/ only) |

### 3.3 Decision Framework Per Link

| Option | When to Use |
|--------|-------------|
| **Create stub** | File should exist, create placeholder |
| **Remove reference** | Reference not needed, delete the link |
| **Replace with URL** | External docs exist, link to them |
| **Accept as-is** | Upstream issue, document and move on |

### 3.4 Subagent Strategy

**Recommended**: Use 2 Explore agents in parallel:

1. **Agent A: Skills Links**
   - Analyze all broken links in `library/skills/`
   - Categorize by fix type (create/remove/replace/accept)
   - Generate fix recommendations

2. **Agent B: Plugins Links**
   - Analyze all broken links in `library/plugins/local/`
   - Categorize by fix type
   - Generate fix recommendations

Then main agent executes fixes based on recommendations.

### 3.5 Expected Outcomes

| Category | Expected Count | Action |
|----------|----------------|--------|
| Create stub | ~5 | Create minimal placeholder files |
| Remove reference | ~15 | Delete broken references from source files |
| Replace with URL | ~8 | Link to official external docs |
| Accept as-is | ~15 | AWS skill internal refs (upstream issue) |

### 3.6 Verification

```bash
# After fixes
./library/tools/validate-links.sh

# Expected: Broken links < 15 (remaining are documented as intentional)
```

---

## Execution Summary

```
Phase 1: Quick Wins (~1 hour)
├── [Parallel] 1A, 1B, 1C edits
├── [Sequential] 1D AWS update
└── Verify with validate-links.sh

Phase 2: Evaluation Framework (~1.5 hours)
├── [Optional] Launch Plan agent for design review
├── Create EVALUATION-FRAMEWORK.md
├── Create community/README.md
└── Update external-expansion.md to reference framework

Phase 3: Broken Links (~2-3 hours)
├── Launch 2 Explore agents (Skills + Plugins)
├── Review findings and approve approach
├── Execute fixes
└── Final validate-links.sh verification
```

---

## Success Criteria

### Phase 1
- [ ] HUD plugin documented in external-expansion.md
- [ ] CONTRIBUTING.md TODO filled
- [ ] Plugin vs config kit guidance exists in configs/README.md
- [ ] AWS skills updated (or documented why not)

### Phase 2
- [ ] EVALUATION-FRAMEWORK.md exists and is comprehensive
- [ ] Framework covers plugins, skills, AND config kits
- [ ] community/README.md created
- [ ] external-expansion.md references framework

### Phase 3
- [ ] Broken links in library/ reduced significantly
- [ ] Remaining broken links documented with reason
- [ ] validate-links.sh shows improvement

---

## Appendix: Guardrails Override Instructions

To allow Claude Code to edit files in `~/.claude/plans/`:

**File location**: `~/.claude/guardrails-overrides.json`

**How to edit**:
```bash
# Open in your preferred editor
code ~/.claude/guardrails-overrides.json
# or
nano ~/.claude/guardrails-overrides.json
# or
vim ~/.claude/guardrails-overrides.json
```

**Add this content**:
```json
{
  "allowed_paths": [
    "/Users/danieleskenazi/.claude/plans"
  ]
}
```

**If file already has content**, add to the existing `allowed_paths` array:
```json
{
  "allowed_paths": [
    "/existing/path",
    "/Users/danieleskenazi/.claude/plans"
  ]
}
```

**After saving**: The override takes effect immediately (no restart needed).

**Security note**: This allows Claude to write to your plans directory. Since plans are just markdown files, this is low risk. You can remove the override after planning sessions.

---

*Plan created: 2026-01-12*
*Ready for approval*
