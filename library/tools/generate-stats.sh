#!/bin/bash
# Generate statistics for the repository
# Usage: ./generate-stats.sh [--json|--markdown|--update-metadata]
#
# Options:
#   --json            Output in JSON format (default)
#   --markdown        Output in human-readable markdown
#   --update-metadata Update .repo-metadata.json in place

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESOURCES_DIR="$(dirname "$SCRIPT_DIR")"
REPO_ROOT="$(dirname "$RESOURCES_DIR")"

OUTPUT_FORMAT="${1:---json}"

# Count documentation files (folders 01-10)
count_docs() {
    find "$REPO_ROOT"/0*-* -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' '
}

# Count docs per folder
count_docs_by_folder() {
    for folder in "$REPO_ROOT"/0*-*/; do
        if [ -d "$folder" ]; then
            name=$(basename "$folder")
            count=$(find "$folder" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
            echo "$name:$count"
        fi
    done
}

# Count total skills
count_skills() {
    find "$RESOURCES_DIR/skills/core-skills" "$RESOURCES_DIR/skills/extended-skills" -name "SKILL.md" -type f 2>/dev/null | wc -l | tr -d ' '
}

# Count placeholder skills
count_placeholders() {
    local count=0
    while IFS= read -r skill_md; do
        [ -z "$skill_md" ] && continue
        # Check for both placeholder text variants
        if grep -q "skill could not be fetched\|repository could not be found\|Not Available" "$skill_md" 2>/dev/null; then
            count=$((count + 1))
        fi
    done < <(find "$RESOURCES_DIR/skills/core-skills" "$RESOURCES_DIR/skills/extended-skills" -name "SKILL.md" -type f 2>/dev/null)
    echo "$count"
}

# Count core skills
count_core() {
    find "$RESOURCES_DIR/skills/core-skills" -name "SKILL.md" -type f 2>/dev/null | wc -l | tr -d ' '
}

# Count extended skills
count_extended() {
    find "$RESOURCES_DIR/skills/extended-skills" -name "SKILL.md" -type f 2>/dev/null | wc -l | tr -d ' '
}

# Count skills by category
count_by_category() {
    local base="$1"
    for category in "$base"/*/; do
        if [ -d "$category" ]; then
            name=$(basename "$category")
            count=$(find "$category" -name "SKILL.md" -type f 2>/dev/null | wc -l | tr -d ' ')
            if [ "$count" -gt 0 ]; then
                echo "$name:$count"
            fi
        fi
    done
}

# Get skill details
get_skill_details() {
    while IFS= read -r skill_md; do
        [ -z "$skill_md" ] && continue
        skill_dir="$(dirname "$skill_md")"
        skill_name="$(basename "$skill_dir")"
        lines=$(wc -l < "$skill_md" 2>/dev/null | tr -d ' ')
        rel_path="${skill_dir#$RESOURCES_DIR/}"

        # Check if placeholder
        if grep -q "skill could not be fetched\|repository could not be found\|Not Available" "$skill_md" 2>/dev/null; then
            status="placeholder"
        else
            status="available"
        fi

        # Extract description from YAML frontmatter
        desc=$(grep "^description:" "$skill_md" 2>/dev/null | head -1 | sed "s/description:[[:space:]]*//" | sed "s/'//g" | sed 's/"//g' | cut -c1-60)

        echo "$skill_name|$lines|$rel_path|$status|$desc"
    done < <(find "$RESOURCES_DIR/skills/core-skills" "$RESOURCES_DIR/skills/extended-skills" -name "SKILL.md" -type f 2>/dev/null | sort)
}

# Generate JSON output
generate_json() {
    local doc_count=$(count_docs)
    local skill_count=$(count_skills)
    local placeholder_count=$(count_placeholders)
    local working_count=$((skill_count - placeholder_count))
    local core_count=$(count_core)
    local extended_count=$(count_extended)

    cat << EOF
{
  "generated": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "documentation": {
    "file_count": $doc_count,
    "folders": {
EOF

    # Add folder counts
    first=true
    while IFS=: read -r name count; do
        if [ "$first" = true ]; then
            first=false
        else
            echo ","
        fi
        printf '      "%s": %s' "$name" "$count"
    done < <(count_docs_by_folder)
    echo ""

    cat << EOF
    }
  },
  "skills": {
    "total": $skill_count,
    "working": $working_count,
    "placeholders": $placeholder_count,
    "core": {
      "total": $core_count,
EOF

    # Add core category counts
    first=true
    while IFS=: read -r name count; do
        if [ "$first" = true ]; then
            first=false
        else
            echo ","
        fi
        printf '      "%s": %s' "$name" "$count"
    done < <(count_by_category "$RESOURCES_DIR/skills/core-skills")
    echo ""

    cat << EOF
    },
    "extended": {
      "total": $extended_count,
EOF

    # Add extended category counts
    first=true
    while IFS=: read -r name count; do
        if [ "$first" = true ]; then
            first=false
        else
            echo ","
        fi
        printf '      "%s": %s' "$name" "$count"
    done < <(count_by_category "$RESOURCES_DIR/skills/extended-skills")
    echo ""

    cat << EOF
    }
  },
  "skill_details": [
EOF

    # Add skill details
    first=true
    while IFS='|' read -r name lines path status desc; do
        if [ -n "$name" ]; then
            if [ "$first" = true ]; then
                first=false
            else
                echo ","
            fi
            # Escape special characters in description
            escaped_desc=$(echo "$desc" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g')
            printf '    {"name": "%s", "lines": %s, "path": "%s", "status": "%s", "description": "%s"}' \
                "$name" "$lines" "$path" "$status" "$escaped_desc"
        fi
    done < <(get_skill_details)
    echo ""

    cat << EOF
  ]
}
EOF
}

# Generate markdown output
generate_markdown() {
    local doc_count=$(count_docs)
    local skill_count=$(count_skills)
    local placeholder_count=$(count_placeholders)
    local working_count=$((skill_count - placeholder_count))
    local core_count=$(count_core)
    local extended_count=$(count_extended)

    cat << EOF
# Repository Statistics

Generated: $(date -u +%Y-%m-%d)

## Summary

| Metric | Value |
|--------|-------|
| Documentation files | $doc_count |
| Total skills | $skill_count |
| Working skills | $working_count |
| Placeholder skills | $placeholder_count |
| Core skills | $core_count |
| Extended skills | $extended_count |

## Documentation by Folder

| Folder | Files |
|--------|-------|
EOF

    while IFS=: read -r name count; do
        echo "| $name | $count |"
    done < <(count_docs_by_folder)

    cat << EOF

## Core Skills by Category

| Category | Count |
|----------|-------|
EOF

    while IFS=: read -r name count; do
        echo "| $name | $count |"
    done < <(count_by_category "$RESOURCES_DIR/skills/core-skills")

    cat << EOF

## Extended Skills by Category

| Category | Count |
|----------|-------|
EOF

    while IFS=: read -r name count; do
        echo "| $name | $count |"
    done < <(count_by_category "$RESOURCES_DIR/skills/extended-skills")

    cat << EOF

## All Skills

| Name | Lines | Path | Status |
|------|-------|------|--------|
EOF

    while IFS='|' read -r name lines path status desc; do
        if [ -n "$name" ]; then
            echo "| $name | $lines | $path | $status |"
        fi
    done < <(get_skill_details)
}

# Update .repo-metadata.json
update_metadata() {
    local metadata_file="$REPO_ROOT/.repo-metadata.json"

    if [ ! -f "$metadata_file" ]; then
        echo "Error: $metadata_file not found"
        exit 1
    fi

    echo "Updating $metadata_file..."

    local doc_count=$(count_docs)
    local skill_count=$(count_skills)
    local placeholder_count=$(count_placeholders)
    local working_count=$((skill_count - placeholder_count))
    local core_count=$(count_core)
    local extended_count=$(count_extended)

    # Generate new metadata JSON
    generate_json > "$metadata_file.tmp"

    # Parse and merge with existing (keeping repository section)
    # For simplicity, we'll regenerate the full file
    cat > "$metadata_file" << EOF
{
  "version": "1.0",
  "repository": {
    "name": "Claude Code Docs with External plug ins",
    "description": "Offline documentation mirror + curated skills library for Claude Code",
    "created": "2026-01-06"
  },
  "documentation": {
    "source": "https://code.claude.com/docs",
    "llms_txt_url": "https://code.claude.com/docs/llms.txt",
    "last_synced": "2026-01-06T00:00:00Z",
    "sync_method": "manual",
    "file_count": $doc_count,
    "folders": {
EOF

    # Add folder counts
    first=true
    while IFS=: read -r name count; do
        if [ "$first" = true ]; then
            first=false
        else
            echo ","
        fi
        printf '      "%s": %s' "$name" "$count"
    done < <(count_docs_by_folder) >> "$metadata_file"

    cat >> "$metadata_file" << EOF

    }
  },
  "skills": {
    "last_bulk_update": "2026-01-07T00:17:35Z",
    "total": $skill_count,
    "working": $working_count,
    "placeholders": $placeholder_count,
    "categories": {
      "core": {
        "total": $core_count,
EOF

    first=true
    while IFS=: read -r name count; do
        if [ "$first" = true ]; then
            first=false
        else
            echo ","
        fi
        printf '        "%s": %s' "$name" "$count"
    done < <(count_by_category "$RESOURCES_DIR/skills/core-skills") >> "$metadata_file"

    cat >> "$metadata_file" << EOF

      },
      "extended": {
        "total": $extended_count,
EOF

    first=true
    while IFS=: read -r name count; do
        if [ "$first" = true ]; then
            first=false
        else
            echo ","
        fi
        printf '        "%s": %s' "$name" "$count"
    done < <(count_by_category "$RESOURCES_DIR/skills/extended-skills") >> "$metadata_file"

    cat >> "$metadata_file" << EOF

      }
    },
    "sources": [
      "https://github.com/obra/superpowers",
      "https://github.com/obra/superpowers-lab",
      "https://github.com/anthropics/skills",
      "https://github.com/fvadicamo/dev-agent-skills",
      "https://github.com/zxkane/aws-skills"
    ]
  },
  "generated": {
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "by": "generate-stats.sh"
  }
}
EOF

    rm -f "$metadata_file.tmp"
    echo "Done: $metadata_file updated"
}

# Main
case "$OUTPUT_FORMAT" in
    --json)
        generate_json
        ;;
    --markdown)
        generate_markdown
        ;;
    --update-metadata)
        update_metadata
        ;;
    *)
        echo "Usage: $0 [--json|--markdown|--update-metadata]"
        echo ""
        echo "Options:"
        echo "  --json            Output in JSON format (default)"
        echo "  --markdown        Output in human-readable markdown"
        echo "  --update-metadata Update .repo-metadata.json in place"
        exit 1
        ;;
esac
