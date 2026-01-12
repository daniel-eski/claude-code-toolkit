# Maintenance Guide

> Comprehensive guide for maintaining the claude-code-toolkit repository

**Created**: 2026-01-10
**Tools Location**: `library/tools/`

---

## Quick Reference: Maintenance Schedule

| Frequency | Task | Command | Purpose |
|-----------|------|---------|---------|
| **After changes** | Validate links | `./validate-links.sh` | Catch broken internal links |
| **After changes** | Regenerate catalog | `./regenerate-catalog.sh --output ../skills/CATALOG.md` | Keep catalog in sync |
| **Monthly** | Freshness check | `./freshness-report.sh` | Detect upstream skill updates |
| **Monthly** | Check experimental | Manual review of `experimental/` | Evaluate for graduation |
| **Quarterly** | External link review | `./validate-links.sh --external` | Verify external URLs still work |
| **Quarterly** | Update statistics | `./generate-stats.sh --update-metadata` | Keep `.repo-metadata.json` current |

---

## Routine Maintenance Tasks

### After Any Content Changes

Run these tasks whenever you modify documentation or skills:

```bash
cd library/tools

# 1. Validate all internal links (fast, ~5 seconds)
./validate-links.sh

# 2. If skills were added/removed, regenerate the catalog
./regenerate-catalog.sh --output ../skills/CATALOG.md

# 3. If significant changes, update repository statistics
./generate-stats.sh --update-metadata
```

**What to look for**:
- Zero broken links (exit code 0)
- CATALOG.md accurately reflects available skills
- Statistics match actual file counts

### Monthly Maintenance (First Week)

```bash
cd library/tools

# 1. Check for upstream skill updates
./freshness-report.sh

# 2. Review output:
#    - "UP TO DATE" = no action needed
#    - "STALE" = consider re-fetching
#    - "UNKNOWN" = may need .source file migration
```

**If stale skills found**:
```bash
# Re-fetch a specific skill
./fetch-skill.sh https://github.com/obra/superpowers/tree/main/skills/brainstorming ../skills/core-skills/obra-workflow/brainstorming

# Or re-fetch all skills (slower, respects rate limits)
./update-sources.sh --fetch
```

**Review experimental plugins** (`experimental/plugins/`):
1. Check if plugins have been tested
2. Consider graduation to `library/plugins/local/`
3. Document status in `experimental/README.md`

### Quarterly Maintenance

```bash
cd library/tools

# 1. Full external link validation (slow, ~2-5 minutes)
./validate-links.sh --external

# 2. Update repository metadata
./generate-stats.sh --update-metadata

# 3. Review skill sources for deprecation
./freshness-report.sh --verbose
```

**Manual reviews**:
- Check if source repositories still exist
- Review `docs/external/` links for broken URLs
- Evaluate placeholder skills for possible recovery

---

## Tool Reference

### Link Validation

**Script**: `validate-links.sh`

Validates internal markdown links across the repository.

```bash
# Basic usage - validate all markdown files
./validate-links.sh

# Verbose mode - show all links, not just broken
./validate-links.sh --verbose

# Include external URL checks (slower)
./validate-links.sh --external

# Validate specific directory
./validate-links.sh ../guides/
```

| Flag | Purpose |
|------|---------|
| `--verbose` | Show all links including valid ones |
| `--external` | Also check external URLs via HTTP HEAD |
| `[path]` | Limit scope to specific directory |

**Exit codes**: 0 = all valid, 1 = broken links found

---

### Skill Deployment

**Scripts**: `deploy-skill.sh`, `deploy-all.sh`

Deploy skills to Claude Code's skill directory.

```bash
# Deploy single skill to default location (~/.claude/skills/)
./deploy-skill.sh ../skills/core-skills/obra-workflow/brainstorming

# Deploy to project-specific location
./deploy-skill.sh ../skills/core-skills/obra-workflow/brainstorming .claude/skills

# Deploy all core skills
./deploy-all.sh
```

**Default target**: `~/.claude/skills/`

---

### Skill Validation

**Script**: `validate-skill.sh`

Validates SKILL.md format for Claude Code compatibility.

```bash
./validate-skill.sh ../skills/core-skills/obra-workflow/brainstorming
```

**Checks performed**:
- SKILL.md exists and is not empty
- Has YAML frontmatter with `---` delimiters
- Contains required `name` field
- Contains required `description` field
- Warns if description > 1024 characters
- Warns if file > 500 lines
- Notes presence of `.source` tracking file

---

### Skill Fetching

**Scripts**: `fetch-skill.sh`, `update-sources.sh`

Fetch skills from GitHub repositories.

```bash
# Fetch from dedicated skill repo
./fetch-skill.sh https://github.com/obra/brainstorming ../skills/core-skills/obra-workflow/brainstorming

# Fetch from path within larger repo
./fetch-skill.sh https://github.com/anthropics/skills/tree/main/skills/xlsx ../skills/core-skills/document-creation/xlsx

# Re-fetch all skills from upstream sources
./update-sources.sh --fetch

# Preview what would be updated (no changes)
./update-sources.sh
```

**Created files**:
- `SKILL.md` - The skill definition
- `README.md` - If present in source
- `.source` - Tracking metadata (URL, timestamp, commit SHA)

---

### Freshness Checking

**Script**: `freshness-report.sh`

Compares local skills against upstream sources to detect updates.

```bash
# Standard report
./freshness-report.sh

# Include up-to-date skills in output
./freshness-report.sh --verbose

# JSON output for automation
./freshness-report.sh --json
```

| Flag | Purpose |
|------|---------|
| `--verbose` | Show all skills, not just stale/unknown |
| `--json` | Machine-readable JSON output |

**Output categories**:
- `OK` - Local matches upstream
- `STALE` - Upstream has newer commits
- `?` (Unknown) - Cannot check (missing SHA, placeholder, API error)

**Note**: Includes 0.5s rate limiting between API calls.

---

### Catalog Generation

**Script**: `regenerate-catalog.sh`

Auto-generates CATALOG.md from actual skill files.

```bash
# Preview to stdout
./regenerate-catalog.sh

# Write to file
./regenerate-catalog.sh --output ../skills/CATALOG.md
```

**Generated sections**:
- Core skills by category
- Extended skills by category
- Placeholder identification
- Quick deploy commands

---

### Statistics Generation

**Script**: `generate-stats.sh`

Generates repository statistics in various formats.

```bash
# JSON output (default)
./generate-stats.sh --json

# Human-readable markdown
./generate-stats.sh --markdown

# Update .repo-metadata.json in place
./generate-stats.sh --update-metadata
```

**Metrics included**:
- Documentation file counts by folder
- Skill counts (total, working, placeholders)
- Skills by category
- Individual skill details

---

### Source File Migration

**Scripts**: `migrate-source-files.sh`, `fix-unknown-shas.sh`

One-time migration scripts for updating `.source` file format.

```bash
# Add commit SHA tracking to old .source files
./migrate-source-files.sh

# Preview changes without applying
./migrate-source-files.sh --dry-run

# Fix .source files that have "unknown" SHAs
./fix-unknown-shas.sh

# Preview fixes
./fix-unknown-shas.sh --dry-run
```

**When to use**:
- After migrating skills from an older repository structure
- When `freshness-report.sh` shows many "unknown" statuses
- If GitHub API was rate-limited during initial fetch

---

## Health Checks

### Quick Health Check (30 seconds)

```bash
cd library/tools

# Run link validation
./validate-links.sh

# Check skill count
./generate-stats.sh --markdown | head -20
```

**Expected results**:
- 0 broken links
- Statistics show expected skill counts

### Full Health Check (5-10 minutes)

```bash
cd library/tools

# 1. Validate all internal links
./validate-links.sh

# 2. Validate external links (slow)
./validate-links.sh --external

# 3. Check skill freshness
./freshness-report.sh --verbose

# 4. Validate skill format for each skill
for skill in ../skills/core-skills/*/SKILL.md ../skills/extended-skills/*/SKILL.md; do
  ./validate-skill.sh "$(dirname "$skill")"
done

# 5. Regenerate catalog and compare
./regenerate-catalog.sh > /tmp/new-catalog.md
diff ../skills/CATALOG.md /tmp/new-catalog.md
```

**All checks should pass with no errors.**

---

## Troubleshooting

### Common Issues

#### "SKILL.md not found" during fetch

**Cause**: Repository structure changed or skill moved.

**Fix**:
1. Visit the source URL manually
2. Locate the correct SKILL.md path
3. Re-fetch with corrected URL

```bash
./fetch-skill.sh https://github.com/owner/repo/tree/main/correct/path ../skills/category/skill-name
```

#### GitHub API rate limit exceeded

**Cause**: Too many API calls in short period.

**Fix**:
1. Wait 60 minutes for rate limit reset
2. Use `--dry-run` to preview without API calls
3. Consider authenticated requests (not implemented)

#### Many "unknown" status in freshness report

**Cause**: .source files missing commit SHA tracking.

**Fix**:
```bash
./migrate-source-files.sh
./fix-unknown-shas.sh
```

#### Catalog doesn't match actual skills

**Cause**: Skills added/removed without catalog update.

**Fix**:
```bash
./regenerate-catalog.sh --output ../skills/CATALOG.md
git diff ../skills/CATALOG.md
```

#### Broken links after refactoring

**Cause**: Paths changed without updating references.

**Fix**:
```bash
./validate-links.sh --verbose
# Review output and update broken references
```

---

## CI/CD Considerations

### Recommended Automated Checks

| Check | Trigger | Command | Fail Condition |
|-------|---------|---------|----------------|
| Link validation | Every commit/PR | `./validate-links.sh` | Exit code != 0 |
| Skill validation | Changes in `library/skills/` | `./validate-skill.sh $skill` | Exit code != 0 |
| Catalog sync | Changes in `library/skills/` | Compare regenerated vs committed | Diff found |

### GitHub Actions Example

```yaml
name: Maintenance Checks

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Validate internal links
        run: ./library/tools/validate-links.sh

      - name: Check catalog freshness
        run: |
          ./library/tools/regenerate-catalog.sh > /tmp/catalog.md
          diff library/skills/CATALOG.md /tmp/catalog.md
```

### Scheduled Jobs

```yaml
# Weekly freshness check (example)
on:
  schedule:
    - cron: '0 9 * * 1'  # Monday 9am UTC

jobs:
  freshness:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Check skill freshness
        run: ./library/tools/freshness-report.sh --json > freshness-report.json
      - name: Upload report
        uses: actions/upload-artifact@v3
        with:
          name: freshness-report
          path: freshness-report.json
```

---

## File Dependencies

Understanding how tools depend on each other:

```
Repository Files
      |
      v
validate-links.sh -----> Scans all *.md files
      |
generate-stats.sh -----> Reads folder structure + SKILL.md files
      |                        |
      v                        v
.repo-metadata.json       (stdout/markdown)

Skills Directory
      |
      v
fetch-skill.sh ---------> Creates SKILL.md + .source
      |
      v
validate-skill.sh ------> Validates SKILL.md format
      |
      v
deploy-skill.sh --------> Copies to ~/.claude/skills/
      |                   (uses deploy-all.sh for batch)
      v
freshness-report.sh ----> Reads .source files + GitHub API
      |
      v
update-sources.sh ------> Calls fetch-skill.sh for each
      |
regenerate-catalog.sh --> Reads all SKILL.md files
      |
      v
CATALOG.md
```

---

## Maintenance Checklist Template

Copy this template for monthly maintenance reviews:

```markdown
## Maintenance Review - [Month Year]

### Link Validation
- [ ] Ran `validate-links.sh`
- [ ] Fixed broken links: ___

### Skill Freshness
- [ ] Ran `freshness-report.sh`
- [ ] Stale skills found: ___
- [ ] Updated skills: ___

### Experimental Review
- [ ] Checked `experimental/plugins/`
- [ ] Graduation candidates: ___

### Statistics
- [ ] Updated `.repo-metadata.json`
- [ ] Skill count accurate: ___

### Notes
___
```

---

*Guide created: 2026-01-10*
*Based on: strategic-roadmap.md Phase E3, library/tools documentation*
