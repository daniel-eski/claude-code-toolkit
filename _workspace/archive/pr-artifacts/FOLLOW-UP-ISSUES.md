# Follow-Up Issues from PR Review

> These issues should be created in GitHub after the PR is merged.
> The critical issues (1-2) have been fixed in commit `10efeb7`.

**Update 2026-01-12 Session 9+**: Most issues have been addressed:
- Issue 1: ✅ COMPLETED - Confidence framework added to all 5 self-knowledge docs
- Issue 2: ✅ VERIFIED - CONTRIBUTING.md config kit section already complete
- Issue 3: ✅ ANALYZED - All 37 broken links are acceptable (code examples + upstream refs)
- Issue 4: ✅ COMPLETED - AWS skills updated with corrected upstream paths
- Issue 5: ✅ COMPLETED - Plugin vs kit guidance added to configs/README.md

---

## Issue 1: Add confidence levels and source citations to self-knowledge docs

**Labels**: `documentation`, `content-quality`

### Description

The three self-knowledge documents provide valuable practitioner guidance but present some inferred claims as verified facts. This could mislead users who treat them as authoritative technical references.

### Specific Concerns

**context-management.md**:
- Line ~71: "5 levels deep" import recursion limit - unverified, no official source
- Line ~122: Token budget estimate "13k tokens before any conversation begins" - calculation assumes facts not verified
- Line ~71: "When context approaches capacity, history compacts automatically" - mechanism stated as fact without source

**subagent-mechanics.md**:
- Lines 235-250: "Skills Are Not Inherited" - claims subagents don't get skills automatically. May not match actual Claude Code behavior.
- Lines 373-380: YAML agent configuration example with `skills:` field - syntax may not match official Claude Code format
- Line 352: Built-in agents table lists "Explore," "Plan," "General" - should be verified against official agent definitions

**tool-execution.md**:
- Lines 127-130: Permission decision logic with `permissionDecision: allow/deny/ask` - exact JSON structure unverified
- Lines 268-272: Claim that "specialized tools bypass permission model" - misleading; all tools go through permission flow

### Recommended Actions

1. Add a "Confidence Levels" section to each document explaining what's verified vs. synthesized
2. Add source citations for specific claims (e.g., "Based on platform docs at [URL]")
3. Add caveats where claims are inferred from architecture rather than documented
4. Consider adding footnotes distinguishing "verified from official docs" vs. "inferred"

### Acceptance Criteria

- [ ] Each self-knowledge doc has explicit confidence/source information
- [ ] Unverified claims are clearly marked as "inferred" or "author's understanding"
- [ ] External sources are cited where applicable

---

## Issue 2: Complete CONTRIBUTING.md config kit section

**Labels**: `documentation`

### Description

The CONTRIBUTING.md file has an incomplete section for configuration kit contributions.

### Location

`CONTRIBUTING.md` - search for `<!-- TODO: Configuration kit contribution -->`

### Recommended Content

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

### Acceptance Criteria

- [ ] TODO placeholder replaced with actual content
- [ ] Content matches the quality level of other sections in CONTRIBUTING.md

---

## Issue 3: Address 46 broken links in skills and plugins

**Labels**: `bug`, `documentation`, `low-priority`

### Description

The `validate-links.sh` script reports 46 broken internal links. While the guides/ folder has 0 broken links (success criteria met), other areas have issues.

### Affected Areas

**Skills with broken links**:
- `library/skills/core-skills/document-creation/docx/SKILL.md` - references docx-js.md, ooxml.md
- `library/skills/core-skills/document-creation/pptx/SKILL.md` - references html2pptx.md, scripts/html2pptx.js, ooxml.md
- `library/skills/core-skills/skill-authoring/skill-creator/SKILL.md` - references FORMS.md, REFERENCE.md, EXAMPLES.md, etc.
- `library/skills/extended-skills/aws-skills/aws-agentic-ai/SKILL.md` - references ../../docs/aws-mcp-setup.md and multiple service READMEs

**Plugins with broken links**:
- `library/plugins/local/workflow-optimizer/skills/agent-architect/references/SKILLS.md` - references reference.md, examples.md, checklist.md
- `library/plugins/local/claude-code-advisor/` - multiple broken references in skills-deep-dive.md, skill-authoring.md

### Recommended Approach

1. For skills: Determine if referenced files should be created or if references should be removed
2. For plugins: These may have been migrated without their reference files
3. Consider running `validate-links.sh` as a pre-commit hook

### Acceptance Criteria

- [ ] `validate-links.sh` passes with 0 broken links (or remaining links are documented as intentional)

---

## Issue 4: Update stale AWS skills from upstream

**Labels**: `maintenance`, `low-priority`

### Description

The freshness-report.sh shows 4 AWS skills are stale:
- aws-agentic-ai
- aws-cdk-development
- aws-cost-operations
- aws-serverless-eda

Local commit: `a7475d2` (fetched: 2026-01-07)
Remote commit: `ec188e4`

### Recommended Action

```bash
./library/tools/update-sources.sh --fetch
```

Or individually:
```bash
./library/tools/fetch-skill.sh https://github.com/zxkane/aws-skills <skill-path>
```

### Acceptance Criteria

- [ ] AWS skills updated to latest upstream versions
- [ ] .source files updated with new commit SHAs
- [ ] CATALOG.md updated if skill descriptions changed

---

## Issue 5: Clarify workflow-optimizer vs workflow-optimizer-kit usage

**Labels**: `documentation`, `enhancement`

### Description

Two graduated items solve related but different problems:
- **workflow-optimizer plugin** - 3 skills for task understanding + context management + agent design
- **workflow-optimizer-kit config** - 3-layer meta-cognitive system (CLAUDE.md + skill + commands)

Users may be confused about which to use.

### Recommended Action

Add a comparison section to either:
- `library/configs/README.md`
- `library/plugins/local/README.md`
- Or both

Example content:
```markdown
## Choosing Between Plugin and Config Kit

| Use Case | Recommendation |
|----------|----------------|
| I want reusable skills for any project | workflow-optimizer plugin |
| I want to change Claude's behavior globally | workflow-optimizer-kit config |
| I want explicit /commands | Both (different commands) |
| I want automatic skill activation | workflow-optimizer plugin |
| I want CLAUDE.md behavioral shaping | workflow-optimizer-kit config |
```

### Acceptance Criteria

- [ ] Clear guidance exists on when to use plugin vs config kit
- [ ] Users can make informed choice based on their needs

---

## Summary

| Issue | Priority | Effort | Status |
|-------|----------|--------|--------|
| 1. Self-knowledge doc confidence levels | Medium | ~2 hours | ✅ COMPLETED |
| 2. CONTRIBUTING.md completion | Low | ~30 min | ✅ VERIFIED (already done) |
| 3. Broken links in skills/plugins | Low | ~2-4 hours | ✅ ANALYZED (acceptable) |
| 4. Update stale AWS skills | Low | ~15 min | ✅ COMPLETED |
| 5. Plugin vs config kit guidance | Low | ~30 min | ✅ COMPLETED |

**All follow-up issues have been addressed.**

---

*Generated from PR review on 2026-01-12*
*Updated: Session 9+ (2026-01-12)*
