#!/usr/bin/env bash
set -euo pipefail

#
# Claude Guardrails - Uninstallation Script
# Removes safety hooks while preserving other Claude Code settings
#

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Paths
CLAUDE_DIR="$HOME/.claude"
HOOKS_DIR="$CLAUDE_DIR/hooks"
LOGS_DIR="$CLAUDE_DIR/guardrails-logs"
BIN_DIR="$CLAUDE_DIR/bin"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"
OVERRIDES_FILE="$CLAUDE_DIR/guardrails-overrides.json"

# Hook files to remove
HOOK_FILES=(
    "path-guardian.ts"
    "git-guardian.ts"
    "audit-logger.ts"
)

# ============================================================================
# Banner
# ============================================================================
print_banner() {
    echo -e "${CYAN}"
    echo "  ╔═══════════════════════════════════════════════════════════════╗"
    echo "  ║                                                               ║"
    echo "  ║   ${BOLD}Claude Guardrails - Uninstaller${NC}${CYAN}                            ║"
    echo "  ║                                                               ║"
    echo "  ╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
}

# ============================================================================
# Helper Functions
# ============================================================================
info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_jq() {
    if ! command -v jq &> /dev/null; then
        return 1
    fi
    return 0
}

# ============================================================================
# Remove Hook Files
# ============================================================================
remove_hook_files() {
    info "Removing hook files..."

    for hook_file in "${HOOK_FILES[@]}"; do
        local filepath="$HOOKS_DIR/$hook_file"
        if [[ -f "$filepath" ]]; then
            rm -f "$filepath"
            success "Removed $hook_file"
        else
            warn "$hook_file not found (already removed?)"
        fi
    done
}

# ============================================================================
# Remove Hook Entries from Settings
# ============================================================================
remove_hook_settings() {
    info "Removing hook entries from settings..."

    if [[ ! -f "$SETTINGS_FILE" ]]; then
        warn "settings.json not found - nothing to remove"
        return 0
    fi

    if check_jq; then
        # Use jq to remove the hooks section while preserving everything else
        local temp_file=$(mktemp)

        jq 'del(.hooks)' "$SETTINGS_FILE" > "$temp_file"

        if [[ -s "$temp_file" ]] && jq empty "$temp_file" 2>/dev/null; then
            mv "$temp_file" "$SETTINGS_FILE"
            success "Hook settings removed"
        else
            error "Failed to update settings - invalid JSON"
            rm -f "$temp_file"
            return 1
        fi
    else
        # Fallback: Use bun/node to remove hooks
        warn "Using fallback JSON handling (install jq for more reliable handling)"

        local temp_script=$(mktemp)
        cat > "$temp_script" << 'SCRIPT_EOF'
const fs = require('fs');
const settingsPath = process.argv[2];

let settings = {};
try {
    settings = JSON.parse(fs.readFileSync(settingsPath, 'utf8'));
} catch (e) {
    console.log('Could not read settings file');
    process.exit(0);
}

// Remove hooks section
delete settings.hooks;

fs.writeFileSync(settingsPath, JSON.stringify(settings, null, 2));
console.log('Hook settings removed');
SCRIPT_EOF

        if bun "$temp_script" "$SETTINGS_FILE" 2>/dev/null; then
            success "Hook settings removed"
        else
            # Try with node as fallback
            if node "$temp_script" "$SETTINGS_FILE" 2>/dev/null; then
                success "Hook settings removed"
            else
                error "Failed to update settings"
            fi
        fi
        rm -f "$temp_script"
    fi
}

# ============================================================================
# Remove CLI
# ============================================================================
remove_cli() {
    info "Removing guardrails CLI..."

    local cli_path="$BIN_DIR/guardrails"
    if [[ -f "$cli_path" ]]; then
        rm -f "$cli_path"
        success "Removed $cli_path"
    else
        warn "CLI not found (already removed?)"
    fi
}

# ============================================================================
# Prompt for Logs and Overrides Removal
# ============================================================================
remove_logs_and_overrides() {
    echo ""
    echo -e "${YELLOW}Optional cleanup:${NC}"
    echo ""
    echo "  The following items can be preserved or removed:"
    echo "    - Logs directory: $LOGS_DIR"
    echo "    - Overrides file: $OVERRIDES_FILE"
    echo ""
    read -p "  Remove logs and overrides? [y/N] " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        info "Removing logs and overrides..."

        if [[ -d "$LOGS_DIR" ]]; then
            rm -rf "$LOGS_DIR"
            success "Removed logs directory"
        fi

        if [[ -f "$OVERRIDES_FILE" ]]; then
            rm -f "$OVERRIDES_FILE"
            success "Removed overrides file"
        fi
    else
        info "Keeping logs and overrides"
    fi
}

# ============================================================================
# Print Success
# ============================================================================
print_success() {
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                               ║${NC}"
    echo -e "${GREEN}║   ${BOLD}Uninstallation Complete!${NC}${GREEN}                                   ║${NC}"
    echo -e "${GREEN}║                                                               ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}${BOLD}IMPORTANT:${NC} Restart Claude Code for changes to take effect"
    echo ""
    echo "  Note: The claude-code-safety-net plugin was NOT removed."
    echo "  To remove it manually:"
    echo "    rm -rf $HOME/.claude/plugins/claude-code-safety-net"
    echo ""
    echo "  To reinstall guardrails:"
    echo "    ./scripts/install.sh"
    echo ""
}

# ============================================================================
# Main
# ============================================================================
main() {
    print_banner

    echo -e "${YELLOW}This will remove Claude Guardrails from your system.${NC}"
    echo ""
    read -p "Continue with uninstallation? [y/N] " -n 1 -r
    echo ""

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        info "Uninstallation cancelled"
        exit 0
    fi

    echo ""

    remove_hook_files
    remove_hook_settings
    remove_cli
    remove_logs_and_overrides

    print_success
}

main "$@"
