#!/bin/bash
# Validate internal links in markdown files
# Usage: ./validate-links.sh [--verbose] [--external] [path]
#
# Options:
#   --verbose    Show all links, not just broken ones
#   --external   Also check external URLs (requires curl)
#   path         Directory to scan (default: repository root)
#
# Checks:
#   - Markdown links [text](path) resolve to existing files
#   - Relative paths are correctly formed
#   - Anchor links point to existing files (anchor validation not implemented)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

VERBOSE=false
CHECK_EXTERNAL=false
SCAN_PATH="$REPO_ROOT"

# Parse arguments
for arg in "$@"; do
    case "$arg" in
        --verbose) VERBOSE=true ;;
        --external) CHECK_EXTERNAL=true ;;
        -*) echo "Unknown option: $arg"; exit 1 ;;
        *) SCAN_PATH="$arg" ;;
    esac
done

# Counters
TOTAL_FILES=0
TOTAL_LINKS=0
BROKEN_LINKS=0
VALID_LINKS=0
EXTERNAL_LINKS=0
SKIPPED_LINKS=0

# Arrays for reporting
declare -a BROKEN_REPORTS

echo "Link Validation Report"
echo "======================"
echo "Scanning: $SCAN_PATH"
echo "Generated: $(date -u +%Y-%m-%d)"
echo ""

# Function to check if a link target exists
check_link() {
    local source_file="$1"
    local link_target="$2"
    local source_dir=$(dirname "$source_file")

    # Skip empty links
    if [ -z "$link_target" ]; then
        return 0
    fi

    # Skip external URLs
    if [[ "$link_target" =~ ^https?:// ]]; then
        EXTERNAL_LINKS=$((EXTERNAL_LINKS + 1))
        if [ "$CHECK_EXTERNAL" = true ]; then
            # Basic HTTP check (just HEAD request)
            if curl -sI --max-time 5 "$link_target" | head -1 | grep -q "200\|301\|302"; then
                VALID_LINKS=$((VALID_LINKS + 1))
                if [ "$VERBOSE" = true ]; then
                    echo "  OK (external): $link_target"
                fi
            else
                BROKEN_LINKS=$((BROKEN_LINKS + 1))
                BROKEN_REPORTS+=("$source_file: $link_target (external - unreachable)")
            fi
        else
            SKIPPED_LINKS=$((SKIPPED_LINKS + 1))
        fi
        return 0
    fi

    # Skip mailto, tel, and other protocols
    if [[ "$link_target" =~ ^[a-z]+: ]]; then
        SKIPPED_LINKS=$((SKIPPED_LINKS + 1))
        return 0
    fi

    # Skip pure anchor links (start with #)
    if [[ "$link_target" =~ ^# ]]; then
        SKIPPED_LINKS=$((SKIPPED_LINKS + 1))
        return 0
    fi

    # Handle anchor in path (file.md#section)
    local path_only="${link_target%%#*}"

    # Skip if just an anchor reference within same file
    if [ -z "$path_only" ]; then
        SKIPPED_LINKS=$((SKIPPED_LINKS + 1))
        return 0
    fi

    # Resolve the path
    local resolved_path
    if [[ "$path_only" =~ ^/ ]]; then
        # Absolute path from repo root (rare in markdown)
        resolved_path="$REPO_ROOT$path_only"
    else
        # Relative path from source file's directory
        resolved_path="$source_dir/$path_only"
    fi

    # Normalize the path (resolve .. and .)
    resolved_path=$(cd "$source_dir" 2>/dev/null && realpath -m "$path_only" 2>/dev/null || echo "$resolved_path")

    # Check if target exists
    if [ -e "$resolved_path" ]; then
        VALID_LINKS=$((VALID_LINKS + 1))
        if [ "$VERBOSE" = true ]; then
            echo "  OK: $link_target"
        fi
    else
        BROKEN_LINKS=$((BROKEN_LINKS + 1))
        local rel_source="${source_file#$REPO_ROOT/}"
        BROKEN_REPORTS+=("$rel_source: $link_target")
        if [ "$VERBOSE" = true ]; then
            echo "  BROKEN: $link_target -> $resolved_path"
        fi
    fi
}

# Function to extract and check links from a markdown file
process_file() {
    local file="$1"
    local rel_file="${file#$REPO_ROOT/}"

    TOTAL_FILES=$((TOTAL_FILES + 1))

    if [ "$VERBOSE" = true ]; then
        echo ""
        echo "File: $rel_file"
    fi

    # Extract markdown links: [text](url)
    # Using grep to find patterns, then sed to extract just the URL part
    local links=$(grep -oE '\[[^]]+\]\([^)]+\)' "$file" 2>/dev/null | sed -E 's/\[[^]]+\]\(([^)]+)\)/\1/' || true)

    for link in $links; do
        TOTAL_LINKS=$((TOTAL_LINKS + 1))
        check_link "$file" "$link"
    done
}

# Find and process all markdown files
while IFS= read -r file; do
    [ -z "$file" ] && continue
    process_file "$file"
done < <(find "$SCAN_PATH" -name "*.md" -type f \
    ! -path "*/.git/*" \
    ! -path "*/node_modules/*" \
    ! -path "*/.claude/*" \
    2>/dev/null | sort)

# Report broken links
if [ ${#BROKEN_REPORTS[@]} -gt 0 ]; then
    echo ""
    echo "Broken Links Found:"
    echo "-------------------"
    for report in "${BROKEN_REPORTS[@]}"; do
        echo "  $report"
    done
fi

# Summary
echo ""
echo "======================================"
echo "Summary:"
echo "  Files scanned:    $TOTAL_FILES"
echo "  Total links:      $TOTAL_LINKS"
echo "  Valid links:      $VALID_LINKS"
echo "  Broken links:     $BROKEN_LINKS"
echo "  External links:   $EXTERNAL_LINKS"
if [ "$CHECK_EXTERNAL" = false ] && [ $EXTERNAL_LINKS -gt 0 ]; then
    echo "  (external links not checked - use --external to validate)"
fi
if [ $SKIPPED_LINKS -gt 0 ]; then
    echo "  Skipped:          $SKIPPED_LINKS (anchors, mailto, etc.)"
fi

# Exit status
if [ $BROKEN_LINKS -gt 0 ]; then
    echo ""
    echo "FAIL: $BROKEN_LINKS broken link(s) found"
    exit 1
else
    echo ""
    echo "PASS: All internal links are valid"
    exit 0
fi
