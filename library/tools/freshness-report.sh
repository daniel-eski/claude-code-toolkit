#!/bin/bash
# Check for upstream updates to fetched skills
# Usage: ./freshness-report.sh [--verbose] [--json]
#
# Options:
#   --verbose  Show all skills including up-to-date ones
#   --json     Output in JSON format

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESOURCES_DIR="$(dirname "$SCRIPT_DIR")"

VERBOSE=false
JSON_OUTPUT=false

for arg in "$@"; do
    case "$arg" in
        --verbose) VERBOSE=true ;;
        --json) JSON_OUTPUT=true ;;
    esac
done

# Initialize counters
UP_TO_DATE=0
STALE=0
UNKNOWN=0
TOTAL=0

# Arrays for JSON output
declare -a STALE_SKILLS
declare -a UNKNOWN_SKILLS
declare -a UPTODATE_SKILLS

check_skill() {
    local source_file="$1"
    local skill_dir=$(dirname "$source_file")
    local skill_name=$(basename "$skill_dir")
    local rel_path="${skill_dir#$RESOURCES_DIR/}"

    TOTAL=$((TOTAL + 1))

    # Read .source file
    local SOURCE_URL=$(grep "^source:" "$source_file" 2>/dev/null | sed 's/source:[[:space:]]*//')
    local LOCAL_SHA=$(grep "^commit_sha:" "$source_file" 2>/dev/null | sed 's/commit_sha:[[:space:]]*//')
    local FETCHED=$(grep "^fetched:" "$source_file" 2>/dev/null | sed 's/fetched:[[:space:]]*//')

    # Check if we can compare
    if [ -z "$SOURCE_URL" ] || [ -z "$LOCAL_SHA" ] || [ "$LOCAL_SHA" = "unknown" ]; then
        UNKNOWN=$((UNKNOWN + 1))
        if [ "$JSON_OUTPUT" = true ]; then
            UNKNOWN_SKILLS+=("{\"name\": \"$skill_name\", \"path\": \"$rel_path\", \"reason\": \"no commit SHA\"}")
        else
            echo "  ? $skill_name - cannot check (no commit SHA)"
        fi
        return
    fi

    # Check if placeholder
    if grep -q "skill could not be fetched\|repository could not be found\|Not Available" "$skill_dir/SKILL.md" 2>/dev/null; then
        UNKNOWN=$((UNKNOWN + 1))
        if [ "$JSON_OUTPUT" = true ]; then
            UNKNOWN_SKILLS+=("{\"name\": \"$skill_name\", \"path\": \"$rel_path\", \"reason\": \"placeholder\"}")
        else
            echo "  ? $skill_name - placeholder skill"
        fi
        return
    fi

    # Extract repo and path from URL
    local COMMIT_API=""
    if [[ "$SOURCE_URL" == *"/tree/main/"* ]]; then
        local REPO_PART=$(echo "$SOURCE_URL" | sed -E 's|https://github.com/([^/]+/[^/]+)/tree/main/(.*)|\1|')
        local PATH_PART=$(echo "$SOURCE_URL" | sed -E 's|https://github.com/([^/]+/[^/]+)/tree/main/(.*)|\2|')
        COMMIT_API="https://api.github.com/repos/$REPO_PART/commits?path=$PATH_PART&per_page=1"
    else
        local REPO_PATH=$(echo "$SOURCE_URL" | sed 's|https://github.com/||')
        COMMIT_API="https://api.github.com/repos/$REPO_PATH/commits?per_page=1"
    fi

    # Query GitHub API
    local COMMIT_RESPONSE=$(curl -sL "$COMMIT_API" 2>/dev/null)

    if [ -z "$COMMIT_RESPONSE" ]; then
        UNKNOWN=$((UNKNOWN + 1))
        if [ "$JSON_OUTPUT" = true ]; then
            UNKNOWN_SKILLS+=("{\"name\": \"$skill_name\", \"path\": \"$rel_path\", \"reason\": \"API error\"}")
        else
            echo "  ? $skill_name - could not reach GitHub API"
        fi
        return
    fi

    # Extract remote SHA
    local REMOTE_SHA=$(echo "$COMMIT_RESPONSE" | grep -o '"sha": *"[^"]*"' | head -1 | sed 's/"sha": *"\([^"]*\)"/\1/')

    if [ -z "$REMOTE_SHA" ]; then
        UNKNOWN=$((UNKNOWN + 1))
        if [ "$JSON_OUTPUT" = true ]; then
            UNKNOWN_SKILLS+=("{\"name\": \"$skill_name\", \"path\": \"$rel_path\", \"reason\": \"no remote SHA\"}")
        else
            echo "  ? $skill_name - could not get remote SHA"
        fi
        return
    fi

    # Compare (first 40 chars should match)
    if [ "${LOCAL_SHA:0:40}" = "${REMOTE_SHA:0:40}" ]; then
        UP_TO_DATE=$((UP_TO_DATE + 1))
        if [ "$VERBOSE" = true ]; then
            if [ "$JSON_OUTPUT" = true ]; then
                UPTODATE_SKILLS+=("{\"name\": \"$skill_name\", \"path\": \"$rel_path\", \"sha\": \"${LOCAL_SHA:0:7}\"}")
            else
                echo "  OK $skill_name (${LOCAL_SHA:0:7})"
            fi
        fi
    else
        STALE=$((STALE + 1))
        if [ "$JSON_OUTPUT" = true ]; then
            STALE_SKILLS+=("{\"name\": \"$skill_name\", \"path\": \"$rel_path\", \"local_sha\": \"${LOCAL_SHA:0:7}\", \"remote_sha\": \"${REMOTE_SHA:0:7}\", \"fetched\": \"$FETCHED\", \"source\": \"$SOURCE_URL\"}")
        else
            echo "  ! $skill_name - STALE"
            echo "      Local:  ${LOCAL_SHA:0:7} (fetched: $FETCHED)"
            echo "      Remote: ${REMOTE_SHA:0:7}"
            echo "      URL: $SOURCE_URL"
        fi
    fi
}

# Main execution
if [ "$JSON_OUTPUT" = false ]; then
    echo "Freshness Report - $(date -u +%Y-%m-%d)"
    echo "======================================"
    echo ""
    echo "Checking skills for upstream changes..."
    echo ""
fi

# Check all skills with .source files
while IFS= read -r source_file; do
    [ -z "$source_file" ] && continue
    check_skill "$source_file"
    # Rate limiting - be nice to GitHub API
    sleep 0.5
done < <(find "$RESOURCES_DIR/core-skills" "$RESOURCES_DIR/extended-skills" -name ".source" 2>/dev/null | sort)

# Output summary
if [ "$JSON_OUTPUT" = true ]; then
    # Build JSON arrays
    stale_json="["
    first=true
    for item in "${STALE_SKILLS[@]}"; do
        if [ "$first" = true ]; then first=false; else stale_json+=","; fi
        stale_json+="$item"
    done
    stale_json+="]"

    unknown_json="["
    first=true
    for item in "${UNKNOWN_SKILLS[@]}"; do
        if [ "$first" = true ]; then first=false; else unknown_json+=","; fi
        unknown_json+="$item"
    done
    unknown_json+="]"

    uptodate_json="["
    first=true
    for item in "${UPTODATE_SKILLS[@]}"; do
        if [ "$first" = true ]; then first=false; else uptodate_json+=","; fi
        uptodate_json+="$item"
    done
    uptodate_json+="]"

    cat << EOF
{
  "generated": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "summary": {
    "total": $TOTAL,
    "up_to_date": $UP_TO_DATE,
    "stale": $STALE,
    "unknown": $UNKNOWN
  },
  "stale": $stale_json,
  "unknown": $unknown_json,
  "up_to_date": $uptodate_json
}
EOF
else
    echo ""
    echo "======================================"
    echo "Summary:"
    echo "  Total checked: $TOTAL"
    echo "  Up to date:    $UP_TO_DATE"
    echo "  Stale:         $STALE"
    echo "  Unknown:       $UNKNOWN"

    if [ $STALE -gt 0 ]; then
        echo ""
        echo "To update stale skills, run:"
        echo "  ./update-sources.sh --fetch"
        echo ""
        echo "Or re-fetch individual skills with:"
        echo "  ./fetch-skill.sh <github-url> <local-path>"
    fi

    if [ $UNKNOWN -gt 0 ]; then
        echo ""
        echo "Skills with 'unknown' status need their .source files migrated."
        echo "Run: ./migrate-source-files.sh"
    fi
fi

# Exit with non-zero if stale skills found
if [ $STALE -gt 0 ]; then
    exit 1
fi
