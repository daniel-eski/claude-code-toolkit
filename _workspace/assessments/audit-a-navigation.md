# Navigation and Discoverability Audit

**Audit Date**: 2026-01-09
**Auditor**: Claude Opus 4.5
**Repository**: `/Users/danieleskenazi/Desktop/Repos/claude-code-toolkit/`

---

## Executive Summary

The repository has a well-structured intent-based navigation system through the `guides/` folder, but suffers from **significant broken link issues** where guides reference documentation paths that do not exist (e.g., `docs/core-features/`, `docs/plugins/`). The progressive disclosure model is sound at the top level but inconsistent at deeper levels. The pointer-first approach is correctly implemented, but several internal links assume a different folder structure than what exists.

---

## Task 1: Path Tracing (10 Scenarios)

### Scenario 1: Fresh agent reads CLAUDE.md -> wants to deploy a skill -> finds it

| Step | Path | Result |
|------|------|--------|
| 1 | Read CLAUDE.md | Clear "Navigation by Intent" table |
| 2 | See "work with skills" not directly listed | Must infer from context |
| 3 | Navigate to library/README.md | Links to `skills/CATALOG.md` |
| 4 | Read library/skills/CATALOG.md | Full skill inventory with deploy commands |
| 5 | Deploy | `./tools/deploy-skill.sh core-skills/obra-workflow/brainstorming` |

**Verdict**: SUCCESS (4 clicks)
**Friction**: CLAUDE.md lacks direct "deploy a skill" entry; agent must understand the library structure.

---

### Scenario 2: Human reads README.md -> wants to understand what's here -> orients

| Step | Path | Result |
|------|------|--------|
| 1 | Read README.md | Purpose, quick start, structure diagram |
| 2 | See "Repository Structure" tree | Clear visual of folder organization |
| 3 | Choose intent or browse by type | Both options well-documented |

**Verdict**: SUCCESS (1 click)
**Friction**: None. README.md provides excellent orientation.

---

### Scenario 3: Agent wants "systematic debugging" skill -> finds it

| Step | Path | Result |
|------|------|--------|
| 1 | Read CLAUDE.md | See guides/ table |
| 2 | Navigate to guides/debug-problems.md | Lists systematic-debugging skill |
| 3 | Path: `library/skills/core-skills/obra-development/systematic-debugging/` | EXISTS - confirmed |

**Verdict**: SUCCESS (2 clicks)
**Friction**: None. Direct intent-based path.

---

### Scenario 4: Agent continuing work -> finds _workspace/progress/current-status.md -> understands state

| Step | Path | Result |
|------|------|--------|
| 1 | CLAUDE.md section "For Agents Continuing Work" | Points to `_workspace/progress/current-status.md` |
| 2 | Read current-status.md | Comprehensive status with phases, next actions, session log |

**Verdict**: SUCCESS (1 click)
**Friction**: None. Well-designed continuation workflow.

---

### Scenario 5: User wants to install a plugin -> finds instructions

| Step | Path | Result |
|------|------|--------|
| 1 | README.md -> "Plugins" row | Points to `library/plugins/` |
| 2 | library/plugins/README.md | Has installation section |
| 3 | Instructions | `claude --plugin-dir ./[plugin-name]` and settings.json approaches |

**Verdict**: SUCCESS (2 clicks)
**Friction**: Minor - installation instructions are in library/plugins/local/README.md, not the parent README.

---

### Scenario 6: Agent wants to create documents -> finds relevant skills

| Step | Path | Result |
|------|------|--------|
| 1 | CLAUDE.md -> guides table | See "Create documents" |
| 2 | guides/create-documents.md | Lists docx, xlsx, pptx, pdf skills with paths |
| 3 | Paths verified | All 5 document skills exist at stated locations |

**Verdict**: SUCCESS (2 clicks)
**Friction**: None.

---

### Scenario 7: User wants to understand Claude Code features -> finds learning resources

| Step | Path | Result |
|------|------|--------|
| 1 | CLAUDE.md or README.md | See "Learn Claude Code" in guides |
| 2 | guides/learn-claude-code.md | Points to claude-code-advisor plugin |
| 3 | Plugin exists | YES at library/plugins/local/claude-code-advisor/ |
| 4 | BROKEN LINK | References `docs/best-practices/claude-code-best-practices.md` - FILE DOES NOT EXIST |

**Verdict**: PARTIAL SUCCESS with BROKEN LINK
**Issue**: Critical - guide references non-existent specific file in docs/best-practices/

---

### Scenario 8: Agent looking for git workflow help -> finds it

| Step | Path | Result |
|------|------|--------|
| 1 | CLAUDE.md -> guides table | See "Work with Git/GitHub" |
| 2 | guides/git-workflow.md | Lists commit-commands plugin, git skills |
| 3 | Skills verified | All git-workflow skills exist |
| 4 | BROKEN LINKS | References `docs/cicd-automation/github-actions.md` and `docs/reference/cli-reference.md` - FOLDERS DO NOT EXIST |

**Verdict**: PARTIAL SUCCESS with BROKEN LINKS
**Issue**: High - documentation path references are incorrect.

---

### Scenario 9: Developer wants to test a WIP plugin -> finds experimental/

| Step | Path | Result |
|------|------|--------|
| 1 | README.md -> "Experimental" row | Points to `experimental/` |
| 2 | experimental/README.md | Lists skills/, plugins/, ideas/ |
| 3 | experimental/plugins/README.md | Documents both WIP plugins with testing instructions |

**Verdict**: SUCCESS (2 clicks)
**Friction**: None. Well-documented experimental path.

---

### Scenario 10: Agent wants to know what official Anthropic plugins exist -> finds catalog

| Step | Path | Result |
|------|------|--------|
| 1 | library/README.md | See "Official (13): `plugins/official/CATALOG.md`" |
| 2 | library/plugins/official/CATALOG.md | Comprehensive 779-line catalog of all 13 plugins |

**Verdict**: SUCCESS (2 clicks)
**Friction**: None.

---

## Task 2: Dead End Detection

### Broken Links Identified

| Severity | Location | Broken Reference | Issue |
|----------|----------|------------------|-------|
| **Critical** | guides/README.md | `../_workspace/backlog/purpose-navigation.md` | File EXISTS but wrong relative path |
| **Critical** | guides/extend-claude-code.md | `docs/core-features/skills.md` | Folder `docs/core-features/` DOES NOT EXIST |
| **Critical** | guides/extend-claude-code.md | `docs/core-features/hooks-guide.md` | Folder DOES NOT EXIST |
| **Critical** | guides/extend-claude-code.md | `docs/plugins/reference.md` | Folder `docs/plugins/` DOES NOT EXIST |
| **Critical** | guides/git-workflow.md | `docs/cicd-automation/github-actions.md` | Folder `docs/cicd-automation/` DOES NOT EXIST |
| **Critical** | guides/git-workflow.md | `docs/reference/cli-reference.md` | Folder `docs/reference/` DOES NOT EXIST |
| **Critical** | guides/orchestrate-work.md | `docs/core-features/subagents.md` | Folder DOES NOT EXIST |
| **Critical** | guides/debug-problems.md | `docs/best-practices/think-tool-blog.md` | FILE does not exist |
| **Critical** | guides/learn-claude-code.md | `docs/best-practices/claude-code-best-practices.md` | FILE does not exist |
| **Critical** | guides/learn-claude-code.md | `docs/best-practices/context-engineering.md` | FILE does not exist |
| **Critical** | guides/learn-claude-code.md | `docs/best-practices/building-effective-agents.md` | FILE does not exist |
| **Critical** | guides/learn-claude-code.md | `docs/external/tutorials-courses.md` | FILE does not exist |
| **High** | guides/learn-claude-code.md | `library/plugins/CATALOG.md` | FILE DOES NOT EXIST (wrong path) |
| **High** | guides/improve-quality.md | `docs/best-practices/claude-code-best-practices.md` | FILE does not exist |
| **High** | guides/improve-quality.md | `docs/best-practices/writing-tools-for-agents.md` | FILE does not exist |
| **High** | guides/create-documents.md | `docs/core-features/skills.md` | Folder DOES NOT EXIST |
| **Medium** | library/tools/README.md | `MIGRATION-NOTES.md` | File not found (may be external reference) |

### Folders Without README.md

All folders have README.md files. No issues found.

### Circular References

No circular references detected.

---

## Task 3: Progressive Disclosure Assessment

### Root Level (CLAUDE.md, README.md)

| Aspect | Assessment | Score |
|--------|------------|-------|
| Explains what's below | YES - clear folder table in both files | Good |
| Links to next level | YES - links to guides/, library/, docs/, experimental/ | Good |
| Entry points clear | YES - "Navigation by Intent" and "Browse by Type" | Good |

**Score**: 9/10

### Second Level (docs/, library/, experimental/, _workspace/)

| Folder | Has README | Explains Contents | Links Below |
|--------|------------|-------------------|-------------|
| docs/ | YES | YES - Quick Navigation table | YES |
| library/ | YES | YES - Table of what's here | YES |
| experimental/ | YES | YES - Purpose and contents | YES |
| _workspace/ | YES | YES - Purpose and key files | YES |
| guides/ | YES | YES - Quick selector | YES |

**Score**: 9/10

### Third Level (skills/, plugins/, etc.)

| Folder | Has README | Explains Contents |
|--------|------------|-------------------|
| library/skills/ | NO - only CATALOG.md | Catalog serves purpose |
| library/skills/core-skills/ | YES | YES |
| library/plugins/ | YES | YES |
| library/plugins/official/ | YES (CATALOG.md) | YES - comprehensive |
| library/plugins/local/ | YES | YES |
| library/plugins/community/ | YES | YES (placeholder) |
| library/configs/ | YES | YES (placeholder) |
| library/tools/ | YES | YES |
| docs/claude-code/ | YES | YES - link index |
| docs/best-practices/ | YES | YES - summaries |
| docs/external/ | YES | YES - link index |
| docs/self-knowledge/ | YES | YES (placeholder) |
| experimental/skills/ | YES | YES |
| experimental/plugins/ | YES | YES |
| experimental/ideas/ | YES | YES |

**Score**: 8/10 (Missing library/skills/README.md)

### Deeper Levels (individual skills, etc.)

| Level | Assessment |
|-------|------------|
| Individual skill folders | Have SKILL.md but no README.md (appropriate for skills) |
| Skill category folders | Have README.md (obra-workflow, obra-development, etc.) |
| Plugin folders | Have README.md or plugin.json |

**Score**: 8/10

---

## Task 4: Guides Effectiveness Assessment

### Overview

The `guides/` folder contains 9 intent-based pathway documents designed to help users find resources based on what they want to accomplish.

### Pathway Accuracy

| Guide | Pathways Sensible | Resource Links Accurate | Context Sufficient |
|-------|-------------------|-------------------------|-------------------|
| start-feature.md | YES | MOSTLY - some doc links broken | YES |
| debug-problems.md | YES | MOSTLY - think-tool-blog.md broken | YES |
| improve-quality.md | YES | MOSTLY - best-practices links broken | YES |
| git-workflow.md | YES | MOSTLY - docs/ links broken | YES |
| create-documents.md | YES | MOSTLY - skills.md link broken | YES |
| learn-claude-code.md | YES | MOSTLY - many doc links broken | YES |
| extend-claude-code.md | YES | MOSTLY - many doc links broken | YES |
| orchestrate-work.md | YES | MOSTLY - subagents.md broken | YES |
| README.md | YES | MOSTLY - plugins/CATALOG.md wrong | YES |

### Recommendations Sensibility

| Guide | Workflow Logical | Tools Appropriate |
|-------|------------------|-------------------|
| start-feature.md | YES - brainstorm -> plan -> execute | YES |
| debug-problems.md | YES - reproduce -> isolate -> fix -> verify | YES |
| improve-quality.md | YES - TDD -> review -> security -> verify | YES |
| git-workflow.md | YES - develop -> commit -> PR -> review -> merge | YES |
| create-documents.md | YES - identify type -> deploy -> describe -> iterate | YES |
| learn-claude-code.md | YES - fundamentals -> advisor -> explore | YES |
| extend-claude-code.md | YES - clarify -> review -> create -> validate -> test | YES |
| orchestrate-work.md | YES - assess -> choose pattern -> configure safety | YES |

### Decision Context

All guides provide adequate context for decision-making through:
- "When to Use This" sections
- Primary vs Supporting resource distinction
- Related Intents cross-references

**Overall Guides Score**: 7/10 (concept excellent, execution has broken links)

---

## Task 5: Consistency Check

### Navigation Pattern Consistency

| Aspect | Consistent? | Notes |
|--------|-------------|-------|
| README.md structure | YES | All use tables for navigation |
| "What's Here" sections | YES | Consistent in library/, experimental/, _workspace/ |
| Intent-based navigation | YES | guides/ folder consistently structured |
| CATALOG.md usage | YES | library/skills/ and library/plugins/official/ |

### Naming Conventions

| Convention | Consistent? | Examples |
|------------|-------------|----------|
| Folder names | YES | lowercase-with-dashes |
| README.md | YES | Present in all navigable folders |
| CATALOG.md | YES | For inventories |
| SKILL.md | YES | For skill definitions |
| plugin.json | YES | For plugin manifests |

### Terminology Consistency

| Term | Usage | Consistent? |
|------|-------|-------------|
| "Skills" | library/skills/, SKILL.md | YES |
| "Plugins" | library/plugins/, .claude-plugin/ | YES |
| "Tools" | library/tools/ (scripts) | YES |
| "Guides" | guides/ | YES |
| "Experimental" | experimental/ | YES |

**Consistency Score**: 9/10

---

## Issues Summary by Severity

### Critical (Must Fix)

1. **Multiple broken documentation links in guides/** - 15+ broken references to non-existent `docs/core-features/`, `docs/plugins/`, `docs/cicd-automation/`, `docs/reference/` folders and specific files in `docs/best-practices/`.

2. **Pointer-first approach incomplete** - The `docs/` folder correctly uses pointer-first design (linking to external URLs), but guides assume individual .md files exist that were never created.

### High (Should Fix)

3. **Missing library/plugins/CATALOG.md** - Referenced in guides/README.md but does not exist. The catalog is at library/plugins/official/CATALOG.md.

4. **Missing library/skills/README.md** - No README at the skills root level; users must go directly to CATALOG.md.

5. **Best practices docs are pointers only** - docs/best-practices/README.md contains summaries and links but no individual .md files. Guides reference files like `claude-code-best-practices.md` that don't exist.

### Medium (Nice to Fix)

6. **Inconsistent relative paths** - Some guides use `../library/` while others use `library/` without the leading `../`.

7. **Missing MIGRATION-NOTES.md** - Referenced in library/tools/README.md.

### Low (Optional)

8. **Old repo path hardcoded** - Several files reference `/Users/danieleskenazi/Desktop/Repos/Claude Code Docs with External plug ins/` which is machine-specific.

---

## Recommendations

### Immediate Actions (Critical)

1. **Fix broken links in guides/** - Either:
   - (a) Create the missing individual .md files in docs/best-practices/, docs/core-features/, etc.
   - (b) Update guides to link to README.md files with anchors instead of non-existent individual files

2. **Decide on documentation structure** - The guides assume individual doc files exist, but the pointer-first design only created README.md indexes. This is a fundamental design inconsistency.

### Short-Term Actions (High)

3. **Create library/plugins/CATALOG.md** - Or update guides/README.md to use correct path `library/plugins/official/CATALOG.md`.

4. **Add library/skills/README.md** - Brief README pointing to CATALOG.md.

5. **Audit all guide links** - Run a link checker to identify all broken internal references.

### Medium-Term Actions

6. **Standardize relative paths** - All guides should use `../` for parent directory references consistently.

7. **Add local copies of key docs** - Consider adding the 9 best-practices documents locally for offline access and direct linking.

---

## Conclusion

The repository's navigation architecture is well-designed with a clear intent-based system through `guides/` and progressive disclosure through layered README.md files. However, the execution has a significant gap: the guides were written assuming individual documentation files exist, but the pointer-first approach only created index/README.md files. This results in 15+ broken links across the guides folder.

**Overall Navigation Score**: 6.5/10

- Architecture: 9/10
- Implementation: 5/10 (broken links)
- Consistency: 9/10
- Progressive Disclosure: 8/10

The fix is straightforward: either create the missing individual .md files or update the guides to reference the README.md files with section anchors.
