#!/bin/bash
# Fetch a skill from GitHub repository
# Usage: ./fetch-skill.sh <github-url> <local-path>
#
# Examples:
#   ./fetch-skill.sh https://github.com/obra/brainstorming ../core-skills/obra-workflow/brainstorming
#   ./fetch-skill.sh https://github.com/anthropics/skills/tree/main/skills/xlsx ../core-skills/document-creation/xlsx

set -e

GITHUB_URL="$1"
LOCAL_PATH="$2"

if [ -z "$GITHUB_URL" ] || [ -z "$LOCAL_PATH" ]; then
    echo "Usage: $0 <github-url> <local-path>"
    echo ""
    echo "Examples:"
    echo "  $0 https://github.com/obra/brainstorming ./core-skills/obra-workflow/brainstorming"
    echo "  $0 https://github.com/anthropics/skills/tree/main/skills/xlsx ./core-skills/document-creation/xlsx"
    exit 1
fi

# Create target directory
mkdir -p "$LOCAL_PATH"

# Determine the raw content URL based on GitHub URL format
if [[ "$GITHUB_URL" == *"/tree/main/"* ]]; then
    # URL format: github.com/owner/repo/tree/main/path
    # Extract: owner/repo and path
    REPO_PART=$(echo "$GITHUB_URL" | sed -E 's|https://github.com/([^/]+/[^/]+)/tree/main/(.*)|\1|')
    PATH_PART=$(echo "$GITHUB_URL" | sed -E 's|https://github.com/([^/]+/[^/]+)/tree/main/(.*)|\2|')
    RAW_BASE="https://raw.githubusercontent.com/$REPO_PART/main/$PATH_PART"
    API_URL="https://api.github.com/repos/$REPO_PART/contents/$PATH_PART"
else
    # URL format: github.com/owner/repo (skill at root)
    REPO_PATH=$(echo "$GITHUB_URL" | sed 's|https://github.com/||')
    RAW_BASE="https://raw.githubusercontent.com/$REPO_PATH/main"
    API_URL="https://api.github.com/repos/$REPO_PATH/contents"
fi

echo "Fetching from: $GITHUB_URL"
echo "Target: $LOCAL_PATH"

# Try to fetch SKILL.md first (required)
SKILL_URL="$RAW_BASE/SKILL.md"
echo "  Fetching SKILL.md..."
HTTP_CODE=$(curl -sL -w "%{http_code}" "$SKILL_URL" -o "$LOCAL_PATH/SKILL.md")

if [ "$HTTP_CODE" != "200" ]; then
    echo "  Warning: SKILL.md not found at root, trying skills/ subdirectory..."
    SKILL_URL="$RAW_BASE/skills/SKILL.md"
    HTTP_CODE=$(curl -sL -w "%{http_code}" "$SKILL_URL" -o "$LOCAL_PATH/SKILL.md")

    if [ "$HTTP_CODE" != "200" ]; then
        echo "  Error: Could not find SKILL.md (HTTP $HTTP_CODE)"
        rm -f "$LOCAL_PATH/SKILL.md"
        # Create placeholder
        cat > "$LOCAL_PATH/SKILL.md" << 'PLACEHOLDER'
---
name: placeholder
description: This skill could not be fetched. See .source file for original URL.
---

# Skill Not Available

This skill could not be automatically fetched from GitHub.

## Manual Download

Please visit the source URL in the `.source` file to download manually.
PLACEHOLDER
    fi
fi

# Try to fetch README.md if it exists
README_URL="$RAW_BASE/README.md"
curl -sL -w "%{http_code}" "$README_URL" -o "$LOCAL_PATH/README.md" 2>/dev/null | grep -q "200" || rm -f "$LOCAL_PATH/README.md"

# Get commit SHA for change detection
COMMIT_SHA="unknown"
BRANCH="main"
if [[ "$GITHUB_URL" == *"/tree/main/"* ]]; then
    COMMIT_API="https://api.github.com/repos/$REPO_PART/commits?path=$PATH_PART&per_page=1"
elif [[ -n "$REPO_PATH" ]]; then
    COMMIT_API="https://api.github.com/repos/$REPO_PATH/commits?per_page=1"
else
    COMMIT_API=""
fi

if [ -n "$COMMIT_API" ]; then
    echo "  Fetching commit SHA..."
    COMMIT_RESPONSE=$(curl -sL "$COMMIT_API" 2>/dev/null)
    if [ -n "$COMMIT_RESPONSE" ]; then
        # Extract SHA using grep/sed (avoid jq dependency)
        COMMIT_SHA=$(echo "$COMMIT_RESPONSE" | grep -o '"sha": *"[^"]*"' | head -1 | sed 's/"sha": *"\([^"]*\)"/\1/')
        if [ -z "$COMMIT_SHA" ]; then
            COMMIT_SHA="unknown"
            echo "  Warning: Could not extract commit SHA"
        else
            echo "  Commit SHA: ${COMMIT_SHA:0:7}"
        fi
    fi
fi

# Record source for tracking
cat > "$LOCAL_PATH/.source" << EOF
source: $GITHUB_URL
fetched: $(date -u +%Y-%m-%dT%H:%M:%SZ)
commit_sha: $COMMIT_SHA
branch: $BRANCH
raw_base: $RAW_BASE
EOF

# Check if SKILL.md has content
if [ -f "$LOCAL_PATH/SKILL.md" ] && [ -s "$LOCAL_PATH/SKILL.md" ]; then
    LINES=$(wc -l < "$LOCAL_PATH/SKILL.md" | tr -d ' ')
    echo "  Success: SKILL.md ($LINES lines)"
else
    echo "  Warning: SKILL.md is empty or missing"
fi

echo "Done: $LOCAL_PATH"
