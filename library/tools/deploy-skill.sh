#!/bin/bash
# Deploy a single skill to Claude Code skills directory
# Usage: ./deploy-skill.sh <skill-path> [target-dir]
#
# Default target: ~/.claude/skills/
# Alternative: .claude/skills/ (project-specific)

set -e

SKILL_PATH="$1"
TARGET="${2:-$HOME/.claude/skills}"

if [ -z "$SKILL_PATH" ]; then
    echo "Usage: $0 <skill-path> [target-dir]"
    echo ""
    echo "Examples:"
    echo "  $0 ../core-skills/obra-workflow/brainstorming"
    echo "  $0 ../core-skills/obra-workflow/brainstorming ~/.claude/skills"
    echo "  $0 ../core-skills/obra-workflow/brainstorming .claude/skills"
    exit 1
fi

# Resolve to absolute path
SKILL_PATH=$(cd "$SKILL_PATH" 2>/dev/null && pwd)
SKILL_NAME=$(basename "$SKILL_PATH")

# Verify SKILL.md exists
if [ ! -f "$SKILL_PATH/SKILL.md" ]; then
    echo "Error: No SKILL.md found in $SKILL_PATH"
    exit 1
fi

# Create target directory
mkdir -p "$TARGET/$SKILL_NAME"

# Copy skill contents
cp -r "$SKILL_PATH"/* "$TARGET/$SKILL_NAME/" 2>/dev/null || true
cp -r "$SKILL_PATH"/.[!.]* "$TARGET/$SKILL_NAME/" 2>/dev/null || true

# Verify deployment
if [ -f "$TARGET/$SKILL_NAME/SKILL.md" ]; then
    echo "Deployed: $SKILL_NAME"
    echo "  From: $SKILL_PATH"
    echo "  To:   $TARGET/$SKILL_NAME"

    # Show skill info
    NAME=$(head -20 "$TARGET/$SKILL_NAME/SKILL.md" | grep "^name:" | sed 's/name:[[:space:]]*//' | tr -d '"' | tr -d "'" || echo "$SKILL_NAME")
    echo "  Name: $NAME"
else
    echo "Error: Deployment verification failed"
    exit 1
fi
