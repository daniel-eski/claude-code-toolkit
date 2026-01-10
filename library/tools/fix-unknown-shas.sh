#!/bin/bash
# Fix .source files that have "unknown" commit SHAs
# Usage: ./fix-unknown-shas.sh [--dry-run]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESOURCES_DIR="$(dirname "$SCRIPT_DIR")"

DRY_RUN=false
[ "$1" = "--dry-run" ] && DRY_RUN=true

FIXED=0
FAILED=0
SKIPPED=0

echo "Fix Unknown Commit SHAs"
echo "======================="
echo ""

while IFS= read -r source_file; do
    [ -z "$source_file" ] && continue

    skill_dir=$(dirname "$source_file")
    skill_name=$(basename "$skill_dir")

    # Check if this has unknown SHA
    if ! grep -q "^commit_sha: unknown" "$source_file" 2>/dev/null; then
        continue
    fi

    # Get the source URL
    SOURCE_URL=$(grep "^source:" "$source_file" 2>/dev/null | sed 's/source:[[:space:]]*//')

    if [ -z "$SOURCE_URL" ]; then
        echo "  SKIP: $skill_name (no source URL)"
        SKIPPED=$((SKIPPED + 1))
        continue
    fi

    # Check if placeholder skill
    if grep -q "skill could not be fetched\|repository could not be found\|Not Available" "$skill_dir/SKILL.md" 2>/dev/null; then
        echo "  SKIP: $skill_name (placeholder skill)"
        SKIPPED=$((SKIPPED + 1))
        continue
    fi

    # Build API URL
    COMMIT_API=""
    if [[ "$SOURCE_URL" == *"/tree/main/"* ]]; then
        REPO_PART=$(echo "$SOURCE_URL" | sed -E 's|https://github.com/([^/]+/[^/]+)/tree/main/(.*)|\1|')
        PATH_PART=$(echo "$SOURCE_URL" | sed -E 's|https://github.com/([^/]+/[^/]+)/tree/main/(.*)|\2|')
        COMMIT_API="https://api.github.com/repos/$REPO_PART/commits?path=$PATH_PART&per_page=1"
    else
        REPO_PATH=$(echo "$SOURCE_URL" | sed 's|https://github.com/||')
        COMMIT_API="https://api.github.com/repos/$REPO_PATH/commits?per_page=1"
    fi

    if [ -z "$COMMIT_API" ]; then
        echo "  FAIL: $skill_name (could not build API URL)"
        FAILED=$((FAILED + 1))
        continue
    fi

    # Query GitHub API
    echo -n "  Fetching $skill_name... "
    RESPONSE=$(curl -sL "$COMMIT_API" 2>/dev/null)

    # Check for rate limit
    if echo "$RESPONSE" | grep -q "API rate limit exceeded"; then
        echo "RATE LIMITED"
        echo ""
        echo "GitHub API rate limit exceeded. Try again later."
        break
    fi

    # Extract SHA
    COMMIT_SHA=$(echo "$RESPONSE" | grep -o '"sha": *"[^"]*"' | head -1 | sed 's/"sha": *"\([^"]*\)"/\1/')

    if [ -z "$COMMIT_SHA" ] || [ ${#COMMIT_SHA} -lt 40 ]; then
        echo "FAILED (no SHA in response)"
        FAILED=$((FAILED + 1))
        continue
    fi

    if [ "$DRY_RUN" = true ]; then
        echo "OK (dry run) - would set ${COMMIT_SHA:0:7}"
    else
        # Update the file - replace unknown with actual SHA
        sed -i '' "s/^commit_sha: unknown/commit_sha: $COMMIT_SHA/" "$source_file"
        echo "OK - ${COMMIT_SHA:0:7}"
        FIXED=$((FIXED + 1))
    fi

    # Rate limiting delay
    sleep 1

done < <(find "$RESOURCES_DIR/core-skills" "$RESOURCES_DIR/extended-skills" -name ".source" 2>/dev/null | sort)

echo ""
echo "======================="
echo "Summary:"
echo "  Fixed: $FIXED"
echo "  Skipped: $SKIPPED"
echo "  Failed: $FAILED"
