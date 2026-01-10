#!/bin/bash
# Validate SKILL.md format for Claude Code compatibility
# Usage: ./validate-skill.sh <skill-directory>
#
# Checks:
# - SKILL.md exists
# - Has YAML frontmatter with --- delimiters
# - Has required 'name' field
# - Has required 'description' field
# - Line count warning if > 500 lines

set -e

SKILL_DIR="$1"

if [ -z "$SKILL_DIR" ]; then
    echo "Usage: $0 <skill-directory>"
    exit 1
fi

SKILL_MD="$SKILL_DIR/SKILL.md"
ERRORS=0
WARNINGS=0

echo "Validating: $SKILL_DIR"

# Check SKILL.md exists
if [ ! -f "$SKILL_MD" ]; then
    echo "  FAIL: SKILL.md not found"
    exit 1
fi

# Check file is not empty
if [ ! -s "$SKILL_MD" ]; then
    echo "  FAIL: SKILL.md is empty"
    exit 1
fi

# Check for opening frontmatter delimiter
if ! head -1 "$SKILL_MD" | grep -q "^---"; then
    echo "  FAIL: Missing YAML frontmatter (no opening ---)"
    ERRORS=$((ERRORS + 1))
fi

# Check for closing frontmatter delimiter
FRONTMATTER_END=$(awk '/^---$/{count++; if(count==2) print NR}' "$SKILL_MD")
if [ -z "$FRONTMATTER_END" ]; then
    echo "  FAIL: Missing YAML frontmatter (no closing ---)"
    ERRORS=$((ERRORS + 1))
fi

# Check required 'name' field in frontmatter
if ! head -20 "$SKILL_MD" | grep -q "^name:"; then
    echo "  FAIL: Missing 'name' field in frontmatter"
    ERRORS=$((ERRORS + 1))
else
    NAME=$(head -20 "$SKILL_MD" | grep "^name:" | sed 's/name:[[:space:]]*//' | tr -d '"' | tr -d "'")
    echo "  OK: name = $NAME"
fi

# Check required 'description' field in frontmatter
if ! head -50 "$SKILL_MD" | grep -q "^description:"; then
    echo "  FAIL: Missing 'description' field in frontmatter"
    ERRORS=$((ERRORS + 1))
else
    DESC_LENGTH=$(head -50 "$SKILL_MD" | grep "^description:" | sed 's/description:[[:space:]]*//' | wc -c | tr -d ' ')
    if [ "$DESC_LENGTH" -gt 1024 ]; then
        echo "  WARNING: description exceeds 1024 characters ($DESC_LENGTH chars)"
        WARNINGS=$((WARNINGS + 1))
    else
        echo "  OK: description ($DESC_LENGTH chars)"
    fi
fi

# Check line count
LINES=$(wc -l < "$SKILL_MD" | tr -d ' ')
if [ "$LINES" -gt 500 ]; then
    echo "  WARNING: SKILL.md exceeds 500 lines ($LINES lines)"
    WARNINGS=$((WARNINGS + 1))
else
    echo "  OK: $LINES lines"
fi

# Check for .source tracking file
if [ -f "$SKILL_DIR/.source" ]; then
    echo "  OK: .source tracking file present"
else
    echo "  INFO: No .source tracking file"
fi

# Summary
echo ""
if [ $ERRORS -eq 0 ]; then
    if [ $WARNINGS -eq 0 ]; then
        echo "PASS: Skill is valid"
    else
        echo "PASS: Skill is valid ($WARNINGS warnings)"
    fi
    exit 0
else
    echo "FAIL: $ERRORS validation errors, $WARNINGS warnings"
    exit 1
fi
