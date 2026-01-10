#!/bin/bash
# Migrate existing .source files to include commit SHA
# Usage: ./migrate-source-files.sh [--dry-run]
#
# This script adds commit_sha and branch fields to existing .source files
# that were created before these fields were added to fetch-skill.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESOURCES_DIR="$(dirname "$SCRIPT_DIR")"
DRY_RUN=false

if [ "$1" = "--dry-run" ]; then
    DRY_RUN=true
    echo "DRY RUN MODE - No changes will be made"
    echo ""
fi

echo "Migrate Source Files to Include Commit SHA"
echo "==========================================="
echo "Scanning: $RESOURCES_DIR"
echo ""

TOTAL=0
MIGRATED=0
SKIPPED=0
FAILED=0

while IFS= read -r source_file; do
    [ -z "$source_file" ] && continue
    TOTAL=$((TOTAL + 1))
    skill_dir="$(dirname "$source_file")"
    skill_name="$(basename "$skill_dir")"

    # Check if already migrated
    if grep -q "^commit_sha:" "$source_file" 2>/dev/null; then
        echo "  SKIP: $skill_name (already has commit_sha)"
        SKIPPED=$((SKIPPED + 1))
        continue
    fi

    # Read source URL
    SOURCE_URL=$(grep "^source:" "$source_file" | sed 's/source:[[:space:]]*//')

    if [ -z "$SOURCE_URL" ]; then
        echo "  FAIL: $skill_name (no source URL)"
        FAILED=$((FAILED + 1))
        continue
    fi

    # Extract repo and path from URL
    if [[ "$SOURCE_URL" == *"/tree/main/"* ]]; then
        REPO_PART=$(echo "$SOURCE_URL" | sed -E 's|https://github.com/([^/]+/[^/]+)/tree/main/(.*)|\1|')
        PATH_PART=$(echo "$SOURCE_URL" | sed -E 's|https://github.com/([^/]+/[^/]+)/tree/main/(.*)|\2|')
        COMMIT_API="https://api.github.com/repos/$REPO_PART/commits?path=$PATH_PART&per_page=1"
    else
        REPO_PATH=$(echo "$SOURCE_URL" | sed 's|https://github.com/||')
        COMMIT_API="https://api.github.com/repos/$REPO_PATH/commits?per_page=1"
    fi

    # Query GitHub API for commit SHA
    echo "  Fetching SHA for: $skill_name"
    COMMIT_RESPONSE=$(curl -sL "$COMMIT_API" 2>/dev/null)

    if [ -z "$COMMIT_RESPONSE" ]; then
        COMMIT_SHA="unknown"
        echo "    Warning: No API response"
    else
        COMMIT_SHA=$(echo "$COMMIT_RESPONSE" | grep -o '"sha": *"[^"]*"' | head -1 | sed 's/"sha": *"\([^"]*\)"/\1/')
        if [ -z "$COMMIT_SHA" ]; then
            COMMIT_SHA="unknown"
            echo "    Warning: Could not extract SHA"
        else
            echo "    SHA: ${COMMIT_SHA:0:7}"
        fi
    fi

    if [ "$DRY_RUN" = true ]; then
        echo "    Would add: commit_sha: $COMMIT_SHA"
        echo "    Would add: branch: main"
    else
        # Add commit_sha and branch to .source file
        echo "commit_sha: $COMMIT_SHA" >> "$source_file"
        echo "branch: main" >> "$source_file"
        echo "    Added commit_sha and branch"
    fi

    MIGRATED=$((MIGRATED + 1))

    # Rate limiting - be nice to GitHub API
    sleep 1
done < <(find "$RESOURCES_DIR/core-skills" "$RESOURCES_DIR/extended-skills" -name ".source" 2>/dev/null | sort)

echo ""
echo "==========================================="
echo "Summary:"
echo "  Total .source files: $TOTAL"
echo "  Migrated: $MIGRATED"
echo "  Skipped (already migrated): $SKIPPED"
echo "  Failed: $FAILED"

if [ "$DRY_RUN" = true ]; then
    echo ""
    echo "This was a dry run. Run without --dry-run to apply changes."
fi
