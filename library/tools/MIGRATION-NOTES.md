# Migration Notes

Migration of utility tools from old repository to new toolkit.

## Migration Summary

Date: January 9, 2026

### Files Migrated

Script                    Status
deploy-skill.sh           Copied
deploy-all.sh             Copied
validate-skill.sh         Copied
fetch-skill.sh            Copied
update-sources.sh         Copied
freshness-report.sh       Copied
regenerate-catalog.sh     Copied
generate-stats.sh         Copied
migrate-source-files.sh   Copied
fix-unknown-shas.sh       Copied

### Source Location

Original: 11-external-resources/tools/

### Path Changes Required

OLD: RESOURCES_DIR/core-skills
NEW: RESOURCES_DIR/skills/core-skills

Affected scripts: deploy-all.sh, freshness-report.sh, generate-stats.sh

### Future Work

1. Path Normalization - Add configurable SKILLS_DIR variable
2. Testing - Test each script in new repo structure
