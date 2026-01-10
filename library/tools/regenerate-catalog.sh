#!/bin/bash
# Regenerate CATALOG.md from actual skill files
# Usage: ./regenerate-catalog.sh [--output FILE]
#
# By default, outputs to stdout. Use --output to write directly to a file.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESOURCES_DIR="$(dirname "$SCRIPT_DIR")"

OUTPUT_FILE=""
if [ "$1" = "--output" ] && [ -n "$2" ]; then
    OUTPUT_FILE="$2"
fi

# Function to extract description from SKILL.md YAML frontmatter
get_description() {
    local skill_md="$1"
    grep "^description:" "$skill_md" 2>/dev/null | head -1 | \
        sed "s/description:[[:space:]]*//" | \
        sed "s/^'//" | sed "s/'$//" | \
        sed 's/^"//' | sed 's/"$//' | \
        cut -c1-60
}

# Function to check if skill is placeholder
is_placeholder() {
    local skill_md="$1"
    # Check for both placeholder text variants
    grep -q "skill could not be fetched\|repository could not be found\|Not Available" "$skill_md" 2>/dev/null
}

# Function to generate section for a category
generate_section() {
    local category_path="$1"
    local category_title="$2"
    local source_url="$3"

    if [ ! -d "$category_path" ]; then
        return
    fi

    # Count skills in this category
    local count=$(find "$category_path" -maxdepth 2 -name "SKILL.md" -type f 2>/dev/null | wc -l | tr -d ' ')
    if [ "$count" -eq 0 ]; then
        return
    fi

    echo "## $category_title"
    echo ""

    if [ -n "$source_url" ]; then
        echo "**Source**: [$source_url]($source_url)"
        echo ""
    fi

    echo "| Skill | Lines | Description | Status |"
    echo "|-------|-------|-------------|--------|"

    # Handle nested directories (e.g., git-workflow/fvadicamo-dev-agent/)
    while IFS= read -r skill_md; do
        [ -z "$skill_md" ] && continue
        local skill_dir="$(dirname "$skill_md")"
        local skill_name="$(basename "$skill_dir")"
        local lines=$(wc -l < "$skill_md" 2>/dev/null | tr -d ' ')
        local desc=$(get_description "$skill_md")

        local status="Available"
        if is_placeholder "$skill_md"; then
            status="Placeholder"
        fi

        echo "| $skill_name | $lines | $desc | $status |"
    done < <(find "$category_path" -name "SKILL.md" -type f 2>/dev/null | sort)

    echo ""
}

# Generate the catalog
generate_catalog() {
    cat << 'HEADER'
# Skills Catalog

Complete indexed catalog of all available skills in this repository.

> **Note**: This file is auto-generated. Run `tools/regenerate-catalog.sh --output CATALOG.md` to update.

HEADER

    echo "**Last generated**: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo ""

    # Count totals
    local total_skills=$(find "$RESOURCES_DIR/skills/core-skills" "$RESOURCES_DIR/skills/extended-skills" -name "SKILL.md" -type f 2>/dev/null | wc -l | tr -d ' ')
    local placeholder_count=0
    while IFS= read -r skill_md; do
        [ -z "$skill_md" ] && continue
        if is_placeholder "$skill_md"; then
            placeholder_count=$((placeholder_count + 1))
        fi
    done < <(find "$RESOURCES_DIR/skills/core-skills" "$RESOURCES_DIR/skills/extended-skills" -name "SKILL.md" -type f 2>/dev/null)
    local working_count=$((total_skills - placeholder_count))

    echo "**Total skills**: $total_skills ($working_count available, $placeholder_count placeholders)"
    echo ""
    echo "---"
    echo ""
    echo "# Core Skills"
    echo ""

    # Core skills sections
    generate_section "$RESOURCES_DIR/skills/core-skills/obra-workflow" \
        "Workflow Skills (obra-workflow)" \
        "https://github.com/obra/superpowers"

    generate_section "$RESOURCES_DIR/skills/core-skills/obra-development" \
        "Development Skills (obra-development)" \
        "https://github.com/obra/superpowers"

    # Git workflow has multiple sources
    echo "## Git Workflow Skills (git-workflow)"
    echo ""
    echo "| Skill | Lines | Description | Status |"
    echo "|-------|-------|-------------|--------|"
    while IFS= read -r skill_md; do
        [ -z "$skill_md" ] && continue
        local skill_dir="$(dirname "$skill_md")"
        local skill_name="$(basename "$skill_dir")"
        local lines=$(wc -l < "$skill_md" 2>/dev/null | tr -d ' ')
        local desc=$(get_description "$skill_md")
        local status="Available"
        if is_placeholder "$skill_md"; then
            status="Placeholder"
        fi
        echo "| $skill_name | $lines | $desc | $status |"
    done < <(find "$RESOURCES_DIR/skills/core-skills/git-workflow" -name "SKILL.md" -type f 2>/dev/null | sort)
    echo ""

    generate_section "$RESOURCES_DIR/skills/core-skills/testing" \
        "Testing Skills (testing)" \
        ""

    generate_section "$RESOURCES_DIR/skills/core-skills/document-creation" \
        "Document Creation Skills (document-creation)" \
        "https://github.com/anthropics/skills"

    generate_section "$RESOURCES_DIR/skills/core-skills/skill-authoring" \
        "Skill Authoring (skill-authoring)" \
        "https://github.com/anthropics/skills"

    echo "---"
    echo ""
    echo "# Extended Skills"
    echo ""

    generate_section "$RESOURCES_DIR/skills/extended-skills/aws-skills" \
        "AWS Skills (aws-skills)" \
        "https://github.com/zxkane/aws-skills"

    # Check for context-engineering (links only)
    if [ -d "$RESOURCES_DIR/skills/extended-skills/context-engineering" ]; then
        echo "## Context Engineering (context-engineering)"
        echo ""
        echo "**Status**: Links only (not downloaded locally)"
        echo ""
        echo "See: [README.md](extended-skills/context-engineering/README.md) for external links to context engineering skills."
        echo ""
    fi

    echo "---"
    echo ""
    cat << 'FOOTER'
# Quick Deploy Commands

```bash
# Deploy a single skill
./tools/deploy-skill.sh core-skills/obra-workflow/brainstorming

# Deploy all core skills
./tools/deploy-all.sh

# Validate before deploying
./tools/validate-skill.sh core-skills/obra-workflow/brainstorming

# Check for upstream updates
./tools/freshness-report.sh
```

# Skill Status Legend

| Status | Meaning |
|--------|---------|
| Available | Skill is fully functional and ready to use |
| Placeholder | Skill could not be fetched from source (see .source file) |
FOOTER
}

# Main execution
if [ -n "$OUTPUT_FILE" ]; then
    generate_catalog > "$OUTPUT_FILE"
    echo "Catalog written to: $OUTPUT_FILE"
else
    generate_catalog
fi
