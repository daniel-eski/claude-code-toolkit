#!/bin/bash
# Deploy all skills from core-skills/ to Claude Code skills directory
# Usage: ./deploy-all.sh [target-dir]
#
# Default target: ~/.claude/skills/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESOURCES_DIR="$(dirname "$SCRIPT_DIR")"
TARGET="${1:-$HOME/.claude/skills}"

echo "Deploying all skills to: $TARGET"
echo ""

DEPLOYED=0
FAILED=0

# Find all directories containing SKILL.md in core-skills/
for skill_dir in $(find "$RESOURCES_DIR/core-skills" -name "SKILL.md" -exec dirname {} \;); do
    skill_name=$(basename "$skill_dir")

    # Skip if SKILL.md is a placeholder
    if grep -q "^name: placeholder" "$skill_dir/SKILL.md" 2>/dev/null; then
        echo "SKIP: $skill_name (placeholder)"
        continue
    fi

    if "$SCRIPT_DIR/deploy-skill.sh" "$skill_dir" "$TARGET" > /dev/null 2>&1; then
        echo "OK:   $skill_name"
        DEPLOYED=$((DEPLOYED + 1))
    else
        echo "FAIL: $skill_name"
        FAILED=$((FAILED + 1))
    fi
done

echo ""
echo "Summary: $DEPLOYED deployed, $FAILED failed"

if [ $FAILED -gt 0 ]; then
    exit 1
fi
