#!/bin/bash
# Check for updates to fetched skills by comparing with source repos
# Usage: ./update-sources.sh [--fetch]
#
# Without --fetch: Only reports which skills may have updates
# With --fetch: Re-fetches all skills from their sources

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESOURCES_DIR="$(dirname "$SCRIPT_DIR")"
DO_FETCH=false

if [ "$1" = "--fetch" ]; then
    DO_FETCH=true
fi

echo "Checking skill sources for updates..."
echo ""

CHECKED=0
UPDATES=0

# Find all .source files
for source_file in $(find "$RESOURCES_DIR/core-skills" "$RESOURCES_DIR/extended-skills" -name ".source" 2>/dev/null); do
    skill_dir=$(dirname "$source_file")
    skill_name=$(basename "$skill_dir")

    # Read source info
    SOURCE_URL=$(grep "^source:" "$source_file" | sed 's/source:[[:space:]]*//')
    FETCHED_DATE=$(grep "^fetched:" "$source_file" | sed 's/fetched:[[:space:]]*//')

    if [ -z "$SOURCE_URL" ]; then
        echo "SKIP: $skill_name (no source URL)"
        continue
    fi

    CHECKED=$((CHECKED + 1))

    if [ "$DO_FETCH" = true ]; then
        echo "Refetching: $skill_name"
        "$SCRIPT_DIR/fetch-skill.sh" "$SOURCE_URL" "$skill_dir"
        UPDATES=$((UPDATES + 1))
    else
        echo "  $skill_name"
        echo "    Source: $SOURCE_URL"
        echo "    Fetched: $FETCHED_DATE"
    fi
done

echo ""
if [ "$DO_FETCH" = true ]; then
    echo "Re-fetched $UPDATES skills"
else
    echo "Checked $CHECKED skills"
    echo ""
    echo "To re-fetch all skills, run: $0 --fetch"
fi
