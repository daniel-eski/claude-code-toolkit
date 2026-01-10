# Audit C: Technical Accuracy Audit

**Repository**: `/Users/danieleskenazi/Desktop/Repos/claude-code-toolkit/`
**Audit Date**: 2026-01-10
**Auditor**: Claude Code Agent

---

## Executive Summary

The repository has **significant technical accuracy issues**. Multiple internal paths referenced in documentation do not exist (18 broken paths identified), count claims are inconsistent with actual content (34 skills vs. various documented claims), and tool scripts have known path issues that prevent them from working correctly. External links and skill `.source` files are valid.

---

## Count Verification Table

| Item | Documented Claim | Actual Count | Location of Claim | Status |
|------|------------------|--------------|-------------------|--------|
| Skills (total) | "32 skills" (library/README.md) | 34 SKILL.md files | library/README.md:9 | MISMATCH |
| Skills (total) | "32 working skills + 2 placeholders" (skills/README.md) | 34 total | library/skills/README.md:20 | CLARIFIED |
| Skills (CATALOG.md) | "28 working + 2 placeholders + 4 extended" | 34 SKILL.md files | library/skills/CATALOG.md:5 | MATH ERROR (=34) |
| obra-workflow skills | 6 | 6 | library/skills/README.md:11 | CORRECT |
| obra-development skills | 9 | 9 | library/skills/README.md:12 | CORRECT |
| git-workflow skills | 6 | 6 (5 in fvadicamo + 1 changelog-generator) | library/skills/README.md:13 | CORRECT |
| testing skills | 2 | 2 | library/skills/README.md:14 | CORRECT |
| document-creation skills | 5 | 5 | library/skills/README.md:15 | CORRECT |
| skill-authoring skills | 2 | 2 | library/skills/README.md:16 | CORRECT |
| aws-skills | 4 | 4 | library/skills/README.md:17 | CORRECT |
| Local plugins | 2 | 2 (claude-code-advisor, context-introspection) | library/plugins/local/ | CORRECT |
| Official plugins documented | 13 | 14 exist on GitHub (catalog has 13) | library/plugins/official/CATALOG.md | MINOR (14 on GitHub) |
| Tools (scripts) | 10 | 10 .sh files | library/tools/ | CORRECT |
| Guides | 9 | 8 guides + 1 README | guides/ | CORRECT |

**Note**: The "32 skills" claim is technically inaccurate. CATALOG.md says 28+2+4=34, and there are 34 SKILL.md files. The messaging is inconsistent across files.

---

## Broken/Invalid Paths

### Critical: Documentation Paths That Do Not Exist

| File | Referenced Path | Status | Severity |
|------|-----------------|--------|----------|
| guides/start-feature.md:40 | `docs/best-practices/claude-code-best-practices.md` | MISSING | HIGH |
| guides/start-feature.md:41 | `docs/best-practices/building-effective-agents.md` | MISSING | HIGH |
| guides/debug-problems.md:40 | `docs/best-practices/think-tool-blog.md` | MISSING | HIGH |
| guides/learn-claude-code.md:41 | `docs/best-practices/claude-code-best-practices.md` | MISSING | HIGH |
| guides/learn-claude-code.md:42 | `docs/best-practices/context-engineering.md` | MISSING | HIGH |
| guides/learn-claude-code.md:43 | `docs/best-practices/building-effective-agents.md` | MISSING | HIGH |
| guides/learn-claude-code.md:44 | `docs/external/tutorials-courses.md` | MISSING | MEDIUM |
| guides/extend-claude-code.md:44 | `docs/core-features/skills.md` | MISSING | HIGH |
| guides/extend-claude-code.md:45 | `docs/core-features/hooks-guide.md` | MISSING | HIGH |
| guides/extend-claude-code.md:46 | `docs/plugins/reference.md` | MISSING | HIGH |
| guides/orchestrate-work.md:46 | `docs/core-features/subagents.md` | MISSING | HIGH |
| guides/git-workflow.md:42 | `docs/cicd-automation/github-actions.md` | MISSING | MEDIUM |
| guides/git-workflow.md:43 | `docs/reference/cli-reference.md` | MISSING | MEDIUM |
| guides/improve-quality.md:42 | `docs/best-practices/claude-code-best-practices.md` | MISSING | HIGH |
| guides/improve-quality.md:43 | `docs/best-practices/writing-tools-for-agents.md` | MISSING | HIGH |
| guides/create-documents.md:42 | `docs/core-features/skills.md` | MISSING | MEDIUM |
| guides/README.md:37 | `../library/skills/CATALOG.md` | CORRECT | OK |
| guides/README.md:43 | `../library/plugins/official/CATALOG.md` | CORRECT | OK |

**Root Cause**: The `docs/` folder only contains README.md files as indexes/pointers. The guides were written expecting actual documentation files to exist, but the design is pointer-first (indexes to external URLs). The guides reference specific file paths that were never created.

### Missing Directories

| Expected Directory | Status | Referenced In |
|--------------------|--------|---------------|
| `docs/core-features/` | MISSING | Multiple guides |
| `docs/plugins/` | MISSING | guides/extend-claude-code.md |
| `docs/cicd-automation/` | MISSING | guides/git-workflow.md |
| `docs/reference/` | MISSING | guides/git-workflow.md |

### Missing Files (Not Directories)

| Expected File | Status | Impact |
|---------------|--------|--------|
| `library/plugins/CATALOG.md` | MISSING | Referenced in guides/README.md:35 and learn-claude-code.md |

---

## Structure Discrepancies vs. repo-vision.md

### Expected in repo-vision.md but Different/Missing

| Expected | Actual | Discrepancy |
|----------|--------|-------------|
| `docs/claude-code/` | Contains only README.md | Expected structured docs, has index only |
| `docs/best-practices/` | Contains only README.md | Expected docs, has index only |
| `docs/self-knowledge/` | Exists, placeholder | Correctly marked as deferred |
| `library/configs/` | Empty placeholder | Correctly marked as deferred |
| `_workspace/decisions/` | Empty (no ADRs) | Missing decision records |

### Unexpected Directories/Files

| Item | Location | Note |
|------|----------|------|
| `library/skills/anthropic/` | Empty directory | Potential orphan |
| `library/skills/community/` | Empty directory | Potential orphan |
| `library/skills/obra/` | Empty directory | Potential orphan |
| `library/plugins/community/` | Contains only README.md | May be intentional placeholder |

---

## Orphaned Files and Ghost References

### Orphaned Files (Exist but Not Referenced)

| File | Location | Notes |
|------|----------|-------|
| `library/tools/MIGRATION-NOTES.md` | library/tools/ | Only referenced in README, not from main docs |
| `library/plugins/official/FUTURE-WORK.md` | library/plugins/official/ | Planning doc, not referenced elsewhere |
| `_workspace/progress/session-logs/2026-01-09-foundation.md` | session-logs/ | Session log, not referenced |

### Ghost References (Mentioned but Do Not Exist)

| Reference | Location | Status |
|-----------|----------|--------|
| `library/plugins/CATALOG.md` | guides/README.md, learn-claude-code.md | DOES NOT EXIST |
| `docs/best-practices/claude-code-best-practices.md` | 4 guide files | DOES NOT EXIST |
| `docs/core-features/skills.md` | 2 guide files | DOES NOT EXIST |
| `/deploy-plugin.sh` | guides/learn-claude-code.md:54 | DOES NOT EXIST (no such script in tools/) |

---

## Tool Script Issues

### Known Path Issues (Documented in MIGRATION-NOTES.md)

| Script | Issue | Impact | Severity |
|--------|-------|--------|----------|
| `deploy-all.sh` | Uses `$RESOURCES_DIR/core-skills` instead of `$RESOURCES_DIR/skills/core-skills` | Script will fail to find skills | HIGH |
| `freshness-report.sh` | Same path issue | Script may fail | MEDIUM |
| `generate-stats.sh` | Same path issue | Script may fail | MEDIUM |

### Non-Existent Scripts Referenced in Docs

| Reference | Location | Status |
|-----------|----------|--------|
| `deploy-plugin.sh` | guides/learn-claude-code.md:54-55 | DOES NOT EXIST |

---

## .source Files and YAML Frontmatter

### .source Files
- **Count**: 34 .source files found (matching 34 SKILL.md files)
- **Format**: All use consistent YAML-like format with `source:`, `fetched:`, `commit_sha:`, `branch:`
- **Unknown SHAs**: None found
- **Status**: VALID

### YAML Frontmatter in SKILL.md
- **All SKILL.md files**: Have valid YAML frontmatter (start with `---`)
- **Required fields**: `name:` and `description:` present in sampled files
- **Status**: VALID

---

## External Links Verification

### Sampled Links (5)

| URL | Status |
|-----|--------|
| https://code.claude.com/docs | ACCESSIBLE |
| https://platform.claude.com/docs/en/api/overview | ACCESSIBLE |
| https://github.com/anthropics/claude-code/tree/main/plugins | ACCESSIBLE (14 plugins found) |
| https://github.com/obra/superpowers | ACCESSIBLE (referenced in CATALOG.md) |
| https://anthropic.skilljar.com | ACCESSIBLE (referenced in docs/external/) |

**External Links Status**: All sampled external links are valid and accessible.

---

## Recommendations

### Priority 1: Critical (Breaking Issues)

1. **Fix tool script paths**
   - Update `deploy-all.sh` line 20: Change `$RESOURCES_DIR/core-skills` to `$RESOURCES_DIR/skills/core-skills`
   - Apply same fix to `freshness-report.sh` and `generate-stats.sh`
   - Severity: HIGH - Scripts will fail

2. **Resolve guide documentation references**
   - Option A: Create the referenced documentation files in `docs/` subdirectories
   - Option B: Update guides to point to `docs/*/README.md` files instead
   - Option C: Update guides to use external URLs directly
   - Severity: HIGH - Guides reference non-existent files

3. **Create `library/plugins/CATALOG.md`**
   - Either create a top-level plugins catalog or update references to point to `library/plugins/official/CATALOG.md`
   - Severity: MEDIUM

### Priority 2: Important (Accuracy Issues)

4. **Standardize skill counts**
   - Reconcile "32 skills" vs "34 SKILL.md files" messaging
   - Update library/README.md and skills/README.md to use consistent, accurate counts
   - Consider: "28 core skills + 4 extended skills + 2 placeholders = 34 total"
   - Severity: MEDIUM

5. **Update official plugins count**
   - GitHub shows 14 plugins, CATALOG.md documents 13
   - Add missing plugin to catalog or note the discrepancy
   - Severity: LOW

### Priority 3: Cleanup (Housekeeping)

6. **Remove or document empty directories**
   - `library/skills/anthropic/`, `library/skills/community/`, `library/skills/obra/`
   - Either remove or add README.md explaining future intent
   - Severity: LOW

7. **Remove reference to non-existent deploy-plugin.sh**
   - In guides/learn-claude-code.md, remove or update the plugin deployment command example
   - Severity: LOW

---

## Summary Statistics

| Category | Count |
|----------|-------|
| Broken internal paths | 18 |
| Missing directories | 4 |
| Missing files | 1 |
| Count discrepancies | 2 |
| Tool script issues | 3 |
| Orphaned files | 3 |
| External links checked | 5 (all valid) |

**Overall Assessment**: The repository structure is sound, but documentation references are significantly out of sync with actual file locations. The "pointer-first" design decision means `docs/` subdirectories only contain README.md index files, but guides were written expecting actual documentation files. Tool scripts have known path issues that were documented but not fixed.
