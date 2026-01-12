# Strategic Roadmap

> Prioritized improvement plan based on comprehensive assessment

**Created**: 2026-01-09
**Based On**: 5-audit comprehensive review

---

## Roadmap Overview

| Phase | Focus | Priority | Scope |
|-------|-------|----------|-------|
| **A** | Critical Fixes | IMMEDIATE | Fix broken paths, tool scripts, shareability |
| **B** | Validation | HIGH | Test migrated content, verify links |
| **C** | Content Enhancement | MEDIUM | Self-knowledge, best-practices decision |
| **D** | Expansion | MEDIUM | Official plugins, WIP graduation |
| **E** | Sustainability | LOW-MEDIUM | Maintenance automation, contribution guidelines |

---

## Phase A: Critical Fixes (IMMEDIATE)

### A1. Fix Broken Paths in Guides

**Problem**: 18+ broken internal references in guides/ folder

**Decision Required**: How to handle docs/ references?

| Option | Pros | Cons | Recommendation |
|--------|------|------|----------------|
| Create missing .md files | Guides work as written | Content duplication, maintenance | NO |
| Update to README.md#anchors | No new files | Requires anchor creation | MAYBE |
| Update to external URLs | Simplest, always current | Requires online access | **YES** |

**Tasks**:
1. Audit all guides for path references
2. Replace `docs/best-practices/*.md` with URLs to engineering blog
3. Replace `docs/core-features/*.md` with URLs to code.claude.com
4. Replace `docs/plugins/*.md` with URLs to code.claude.com
5. Fix `library/plugins/CATALOG.md` → `library/plugins/official/CATALOG.md`
6. Remove reference to non-existent `deploy-plugin.sh`

**Files to Edit**: 9 guides + guides/README.md

---

### A2. Fix Tool Script Paths

**Problem**: Scripts use old path structure

**Tasks**:
1. Edit `deploy-all.sh`: Change `$RESOURCES_DIR/core-skills` → `$RESOURCES_DIR/skills/core-skills`
2. Apply same fix to `freshness-report.sh`
3. Apply same fix to `generate-stats.sh`
4. Test each script after fix

**Files to Edit**: 3 scripts in library/tools/

---

### A3. Fix Shareability

**Problem**: 10 files contain hardcoded user paths

**Tasks**:
1. Remove old repo references OR replace with placeholder text
2. Decision: Remove local copy references from docs/ READMEs OR provide setup instructions

**Recommended Approach**:
```markdown
<!-- Replace this: -->
Local copies in: /Users/danieleskenazi/Desktop/Repos/Claude Code Docs...

<!-- With this: -->
For offline access, see the official docs or your local clone.
```

**Files to Edit**:
- CLAUDE.md
- README.md
- docs/README.md
- docs/claude-code/README.md
- docs/best-practices/README.md
- docs/external/README.md
- library/plugins/official/README.md

---

### A4. Fix Count Inconsistencies

**Tasks**:
1. Update library/README.md: "34 skills" (32 core + 2 placeholders + 4 extended... or however it counts)
2. Update library/skills/README.md to match
3. Ensure CATALOG.md is source of truth

---

## Phase B: Validation (HIGH PRIORITY)

### B1. Link Validation

**Tasks**:
1. Create `library/tools/validate-links.sh` script
2. Run against all README.md and guides
3. Fix any remaining broken references
4. Add to Phase 7 checklist

---

### B2. Skill Deployment Testing

**Tasks**:
1. Test `deploy-skill.sh` with 3 different skills
2. Test `deploy-all.sh` runs without errors
3. Verify deployed skills are accessible
4. Document any issues in MIGRATION-NOTES.md

---

### B3. Tool Script Verification

**Tasks**:
1. Run `validate-skill.sh` on 3 skills
2. Run `freshness-report.sh` and verify output
3. Run `regenerate-catalog.sh` and compare output
4. Document script status

---

## Phase C: Content Enhancement (MEDIUM PRIORITY)

### C1. Best Practices Decision

**Decision Needed**: Keep as pointers OR migrate content locally?

| Option | Implementation |
|--------|----------------|
| Keep as pointers | Update guides to use URLs; remove local copy claims |
| Migrate locally | Copy 9 files from old repo; add .source tracking |

**Recommendation**: Keep as pointers (simpler, always current)

---

### C2. Begin Self-Knowledge Content

**Priority Order**:
1. `context-management.md` - How CLAUDE.md, skills, memory work together
2. `subagent-mechanics.md` - How to deploy and coordinate subagents
3. `tool-execution.md` - How tools work, permissions, sandboxing

**Sources**:
- claude-code-advisor plugin references
- Engineering blog articles
- Platform documentation
- code.claude.com docs

**Approach**: Synthesis, not just aggregation

---

### C3. Enhance Guides

**Quick Improvements**:
1. Add usage examples to skills in CATALOG.md
2. Enrich guides/README.md with brief descriptions
3. Add comparison tables ("X vs Y" guidance)

---

## Phase D: Expansion (MEDIUM PRIORITY)

### D1. Graduate Experimental Plugins

**workflow-optimizer-plugin**:
1. Install and test: `claude --plugin-dir experimental/plugins/workflow-optimizer-plugin`
2. Test commands: /workflow-optimizer:optimize, /plan-files, /architect
3. Document results
4. If successful: Move to library/plugins/local/
5. Add to guides/

**workflow-optimizer-kit**:
1. Create test project
2. Copy config/ to ~/.claude/
3. Test ambiguous prompt handling
4. Test /kickoff and /reflect
5. If successful: Move to library/plugins/local/

---

### D2. Expand Official Plugins Catalog

**Current**: 13 plugins documented
**Target**: All available from anthropics/claude-plugins-official

**Tasks**:
1. Fetch full plugin list from GitHub
2. Add missing plugins to CATALOG.md
3. Follow existing format

---

### D3. External Skills Evaluation (Optional)

**Source**: ComposioHQ/awesome-claude-skills (~60 skills)

**Approach**:
1. Review repository
2. Cherry-pick high-value skills
3. Add to extended-skills/ with .source tracking
4. Update CATALOG.md

---

## Phase E: Sustainability (LOW-MEDIUM PRIORITY)

### E1. Maintenance Automation

**Tasks**:
1. Create link checker script
2. Document freshness-report.sh usage in maintenance guide
3. Consider CI job for link validation

---

### E2. Repository Hygiene

**Tasks**:
1. Add CHANGELOG.md (initialize from session logs)
2. Add CONTRIBUTING.md (guidelines for additions)
3. Clean up empty directories (library/skills/anthropic/, etc.)

---

### E3. Ongoing Maintenance Process

| Task | Frequency | Method |
|------|-----------|--------|
| Run freshness-report.sh | Monthly | Manual |
| Validate links | After changes | Automated script |
| Update CATALOG.md | After additions | regenerate-catalog.sh |
| Check experimental/ | Monthly | git fetch |
| Review external links | Quarterly | Manual |

---

## Implementation Order

```
Phase A (Critical) → Phase B (Validation) → Phase C (Enhancement) → Phase D (Expansion) → Phase E (Sustainability)
     ↓                      ↓                      ↓                      ↓                      ↓
 Fix broken          Test everything          Add content           Expand scope          Automate
    refs                                                                                  maintenance
```

---

## Success Criteria

### Phase A Complete When: ✅ COMPLETED 2026-01-10
- [x] All guides have working internal links
- [x] Tool scripts run without path errors
- [x] No hardcoded user paths in shared files
- [x] Count claims match reality

### Phase B Complete When: ✅ COMPLETED 2026-01-10
- [x] Link validation script exists and passes (0 broken links in core docs)
- [x] 4 skills successfully deployed with deploy-skill.sh
- [x] All tool scripts verified working (validate, deploy, freshness, generate, regenerate)

### Phase C Complete When: ✅ COMPLETED 2026-01-10
- [x] Best practices approach decided and implemented (pointer-based, URLs verified)
- [x] 3 self-knowledge documents created (context-management, subagent-mechanics, tool-execution)
- [x] Skills have usage examples and "When to use" guidance in CATALOG.md

### Phase D Complete When: ✅ COMPLETED 2026-01-10
- [x] Both experimental plugins evaluated (Grade A) and graduated
- [x] workflow-optimizer-plugin → library/plugins/local/workflow-optimizer/
- [x] workflow-optimizer-kit → library/configs/workflow-optimizer-kit/
- [x] Official plugins catalog verified complete (13/13)
- [x] External skills reference added (ComposioHQ link)

### Phase E Complete When: ✅ COMPLETED 2026-01-10
- [x] Maintenance processes documented (`_workspace/planning/maintenance-guide.md` - 538 lines)
- [x] CHANGELOG.md and CONTRIBUTING.md exist (root level: 208 and 425 lines respectively)
- [x] Automation scripts in place (validate-links.sh exists, CI/CD guidance in maintenance guide)
- [x] Empty directories cleaned up (removed obra, anthropic, community from library/skills/)

---

## Roadmap Complete

All 5 phases of the strategic roadmap have been successfully completed:

| Phase | Focus | Status |
|-------|-------|--------|
| **A** | Critical Fixes | ✅ COMPLETED 2026-01-10 |
| **B** | Validation | ✅ COMPLETED 2026-01-10 |
| **C** | Content Enhancement | ✅ COMPLETED 2026-01-10 |
| **D** | Expansion | ✅ COMPLETED 2026-01-10 |
| **E** | Sustainability | ✅ COMPLETED 2026-01-10 |

### Key Deliverables

| Document | Lines | Purpose |
|----------|-------|---------|
| `CHANGELOG.md` | 208 | Repository change history |
| `CONTRIBUTING.md` | 425 | Contribution guidelines |
| `maintenance-guide.md` | 538 | Ongoing maintenance documentation |
| 3 self-knowledge docs | 1,157 | context-management, subagent-mechanics, tool-execution |

### Ongoing Maintenance

See `_workspace/planning/maintenance-guide.md` for:
- Routine maintenance tasks and schedule
- Tool reference documentation
- Health checks and troubleshooting
- CI/CD considerations

---

*Roadmap created: 2026-01-09*
*Roadmap completed: 2026-01-10*
*Based on comprehensive 5-audit assessment*
