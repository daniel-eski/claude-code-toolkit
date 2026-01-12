# Tools

Utility scripts for working with skills, plugins, and repository maintenance.

## Scripts

| Script | Purpose |
|--------|---------|
| validate-links.sh | Validate internal links in markdown files |
| deploy-skill.sh | Deploy a single skill to Claude Code |
| deploy-all.sh | Deploy all core skills |
| validate-skill.sh | Validate SKILL.md format |
| fetch-skill.sh | Download skill from GitHub |
| update-sources.sh | Re-fetch all skills from upstream |
| freshness-report.sh | Check for upstream changes |
| regenerate-catalog.sh | Auto-generate CATALOG.md |
| generate-stats.sh | Generate repository statistics |
| migrate-source-files.sh | Add commit SHA tracking to .source files |
| fix-unknown-shas.sh | Fix .source files with unknown SHAs |

## Usage Examples

### Link Validation

    # Validate all markdown links in the repository
    ./validate-links.sh

    # Validate a specific directory
    ./validate-links.sh ../skills/

    # Verbose mode (show all links, not just broken)
    ./validate-links.sh --verbose

    # Also check external URLs (slower)
    ./validate-links.sh --external

### Deployment

    # Deploy a single skill (default: ~/.claude/skills/)
    ./deploy-skill.sh ../skills/core-skills/obra-workflow/brainstorming

    # Deploy to project-specific location
    ./deploy-skill.sh ../skills/core-skills/obra-workflow/brainstorming .claude/skills

    # Deploy all core skills
    ./deploy-all.sh

### Validation

    ./validate-skill.sh ../skills/core-skills/obra-workflow/brainstorming

### Fetching from GitHub

    # From a dedicated skill repo
    ./fetch-skill.sh https://github.com/obra/brainstorming ../skills/core-skills/obra-workflow/brainstorming

    # From a path within a larger repo
    ./fetch-skill.sh https://github.com/anthropics/skills/tree/main/skills/xlsx ../skills/core-skills/document-creation/xlsx

### Maintenance

    # Check for upstream updates
    ./freshness-report.sh

    # Re-fetch all skills from upstream
    ./update-sources.sh --fetch

    # Regenerate catalog from skill files
    ./regenerate-catalog.sh --output ../skills/CATALOG.md

    # Generate repository statistics
    ./generate-stats.sh --update-metadata

## Path Notes

Scripts use relative path resolution. In this repository:
- Tools: `library/tools/`
- Skills: `library/skills/core-skills/`, `library/skills/extended-skills/`

Scripts correctly resolve to `RESOURCES_DIR/skills/core-skills`.

## File Dependencies

| Script | Depends On |
|--------|------------|
| deploy-all.sh | deploy-skill.sh |
| update-sources.sh | fetch-skill.sh |
| freshness-report.sh | .source files in skills |
| generate-stats.sh | Repository structure, .repo-metadata.json |
| regenerate-catalog.sh | SKILL.md files in skills |

## Source

Migrated from: Claude Code Docs with External plug ins/11-external-resources/tools/
Migration date: January 9, 2026
