#!/bin/bash

# Claude Code Workflow Optimization Kit - Installer
# This script installs the workflow optimization configurations to your Claude Code setup.

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/config"
CLAUDE_DIR="$HOME/.claude"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Claude Code Workflow Optimization Kit - Installer         ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if config directory exists
if [ ! -d "$CONFIG_DIR" ]; then
    echo -e "${RED}Error: Config directory not found at $CONFIG_DIR${NC}"
    echo "Please run this script from the workflow-optimization-kit directory."
    exit 1
fi

# Function to backup existing file
backup_file() {
    local file="$1"
    if [ -f "$file" ]; then
        local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "${YELLOW}  Backing up existing file to: $(basename $backup)${NC}"
        cp "$file" "$backup"
    fi
}

# Function to install a file
install_file() {
    local src="$1"
    local dest="$2"
    local desc="$3"

    echo -e "${BLUE}Installing:${NC} $desc"

    # Create directory if needed
    mkdir -p "$(dirname "$dest")"

    # Backup existing file if present
    backup_file "$dest"

    # Copy file
    cp "$src" "$dest"
    echo -e "${GREEN}  ✓ Installed to: $dest${NC}"
}

echo -e "${BLUE}Step 1: Checking prerequisites...${NC}"
echo ""

# Check if ~/.claude exists
if [ ! -d "$CLAUDE_DIR" ]; then
    echo -e "${YELLOW}Creating ~/.claude directory...${NC}"
    mkdir -p "$CLAUDE_DIR"
fi

echo -e "${GREEN}  ✓ ~/.claude directory exists${NC}"
echo ""

echo -e "${BLUE}Step 2: Installing configuration files...${NC}"
echo ""

# Install CLAUDE.md
install_file \
    "$CONFIG_DIR/CLAUDE.md" \
    "$CLAUDE_DIR/CLAUDE.md" \
    "CLAUDE.md (foundational behavior with @import)"

echo ""

# Install rules
install_file \
    "$CONFIG_DIR/rules/planning.md" \
    "$CLAUDE_DIR/rules/planning.md" \
    "rules/planning.md (planning protocol)"

install_file \
    "$CONFIG_DIR/rules/typescript.md" \
    "$CLAUDE_DIR/rules/typescript.md" \
    "rules/typescript.md (path-specific example)"

echo ""

# Install workflow-reflection skill (3 files)
install_file \
    "$CONFIG_DIR/skills/workflow-reflection/SKILL.md" \
    "$CLAUDE_DIR/skills/workflow-reflection/SKILL.md" \
    "workflow-reflection/SKILL.md (main skill)"

install_file \
    "$CONFIG_DIR/skills/workflow-reflection/reference.md" \
    "$CLAUDE_DIR/skills/workflow-reflection/reference.md" \
    "workflow-reflection/reference.md (detailed docs)"

install_file \
    "$CONFIG_DIR/skills/workflow-reflection/examples.md" \
    "$CLAUDE_DIR/skills/workflow-reflection/examples.md" \
    "workflow-reflection/examples.md (scenarios)"

echo ""

# Install kickoff command
install_file \
    "$CONFIG_DIR/commands/kickoff.md" \
    "$CLAUDE_DIR/commands/kickoff.md" \
    "/kickoff command (positional args)"

echo ""

# Install reflect command
install_file \
    "$CONFIG_DIR/commands/reflect.md" \
    "$CLAUDE_DIR/commands/reflect.md" \
    "/reflect command (git context)"

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Installation Complete!                                    ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Important: You must restart Claude Code for changes to take effect.${NC}"
echo ""
echo -e "${BLUE}Verification steps after restart:${NC}"
echo "  1. Test planning: Type 'improve the code' (Claude should ask for clarification)"
echo "  2. Check skills: Type 'What skills are available?' (should list workflow-reflection)"
echo "  3. Check commands: Type '/help' (should show kickoff and reflect)"
echo ""
echo -e "${BLUE}Quick reference:${NC}"
echo "  /kickoff [task]  - Start a task with structured planning"
echo "  /reflect         - Analyze completed work for optimizations"
echo ""
echo -e "${BLUE}Installed files:${NC}"
echo "  ~/.claude/CLAUDE.md"
echo "  ~/.claude/rules/planning.md"
echo "  ~/.claude/rules/typescript.md"
echo "  ~/.claude/skills/workflow-reflection/SKILL.md"
echo "  ~/.claude/skills/workflow-reflection/reference.md"
echo "  ~/.claude/skills/workflow-reflection/examples.md"
echo "  ~/.claude/commands/kickoff.md"
echo "  ~/.claude/commands/reflect.md"
echo ""
echo "For detailed documentation, see: docs/TECHNICAL_REFERENCE.md"
