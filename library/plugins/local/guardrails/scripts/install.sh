#!/usr/bin/env bash
set -euo pipefail

#
# Claude Guardrails - Installation Script
# Defense-in-depth safety hooks for Claude Code
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
PLUGINS_DIR="$CLAUDE_DIR/plugins"
SAFETY_NET_DIR="$PLUGINS_DIR/claude-code-safety-net"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"
OVERRIDES_FILE="$CLAUDE_DIR/guardrails-overrides.json"

# Get script directory (where the package is)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_DIR="$(dirname "$SCRIPT_DIR")"

# ============================================================================
# Banner
# ============================================================================
print_banner() {
    echo -e "${CYAN}"
    echo "  ╔═══════════════════════════════════════════════════════════════╗"
    echo "  ║                                                               ║"
    echo "  ║   ${BOLD}Claude Guardrails${NC}${CYAN}                                          ║"
    echo "  ║   Defense-in-depth safety hooks for Claude Code              ║"
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

# ============================================================================
# Prerequisite Checks
# ============================================================================
check_bun() {
    info "Checking for Bun..."

    if ! command -v bun &> /dev/null; then
        error "Bun is not installed."
        echo ""
        echo "  Claude Guardrails requires Bun >= 1.0"
        echo ""
        echo "  Install Bun with:"
        echo "    curl -fsSL https://bun.sh/install | bash"
        echo ""
        echo "  Or visit: https://bun.sh"
        echo ""
        exit 1
    fi

    # Check version
    BUN_VERSION=$(bun --version 2>/dev/null || echo "0.0.0")
    BUN_MAJOR=$(echo "$BUN_VERSION" | cut -d. -f1)

    if [[ "$BUN_MAJOR" -lt 1 ]]; then
        error "Bun version $BUN_VERSION is too old. Requires >= 1.0"
        echo ""
        echo "  Update Bun with:"
        echo "    bun upgrade"
        echo ""
        exit 1
    fi

    success "Bun $BUN_VERSION found"
}

check_jq() {
    if ! command -v jq &> /dev/null; then
        warn "jq is not installed. Using fallback JSON handling."
        return 1
    fi
    return 0
}

# ============================================================================
# Safety Net Plugin
# ============================================================================
check_safety_net() {
    info "Checking for claude-code-safety-net plugin..."

    if [[ -d "$SAFETY_NET_DIR" ]] && [[ -f "$SAFETY_NET_DIR/dist/bin/cc-safety-net.js" ]]; then
        success "claude-code-safety-net is already installed"
        return 0
    fi

    warn "claude-code-safety-net is not installed."
    echo ""
    echo -e "  This plugin provides command-level safety checks for Bash operations."
    echo ""
    read -p "  Would you like to install it now? [Y/n] " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Nn]$ ]]; then
        warn "Skipping safety-net installation. Some guardrails will not be active."
        return 1
    fi

    info "Installing claude-code-safety-net..."

    # Create plugins directory if needed
    mkdir -p "$PLUGINS_DIR"

    # Clone, install, and build
    if git clone https://github.com/kenryu42/claude-code-safety-net "$SAFETY_NET_DIR" 2>/dev/null; then
        cd "$SAFETY_NET_DIR"
        bun install
        bun run build
        cd - > /dev/null
        success "claude-code-safety-net installed successfully"
        return 0
    else
        error "Failed to clone claude-code-safety-net"
        warn "You can install it manually later:"
        echo "  git clone https://github.com/kenryu42/claude-code-safety-net $SAFETY_NET_DIR"
        echo "  cd $SAFETY_NET_DIR && bun install && bun run build"
        return 1
    fi
}

# ============================================================================
# Directory Setup
# ============================================================================
create_directories() {
    info "Creating directories..."

    mkdir -p "$HOOKS_DIR"
    mkdir -p "$LOGS_DIR"
    mkdir -p "$BIN_DIR"

    success "Directories created"
}

# ============================================================================
# Copy Hooks
# ============================================================================
copy_hooks() {
    info "Installing hooks..."

    local src_hooks_dir="$PACKAGE_DIR/src/hooks"

    if [[ ! -d "$src_hooks_dir" ]]; then
        error "Source hooks directory not found: $src_hooks_dir"
        exit 1
    fi

    # Copy each hook file
    for hook_file in "$src_hooks_dir"/*.ts; do
        if [[ -f "$hook_file" ]]; then
            local filename=$(basename "$hook_file")
            cp "$hook_file" "$HOOKS_DIR/$filename"
            success "Installed $filename"
        fi
    done
}

# ============================================================================
# Create Overrides File
# ============================================================================
create_overrides() {
    info "Checking overrides file..."

    if [[ -f "$OVERRIDES_FILE" ]]; then
        success "Overrides file already exists"
        return 0
    fi

    cat > "$OVERRIDES_FILE" << 'EOF'
{
  "path-guardian": {
    "allowedPaths": [],
    "blockedPaths": [],
    "blockedPatterns": []
  },
  "git-guardian": {
    "allowedOperations": [],
    "blockedOperations": [],
    "allowForceInBranches": []
  },
  "audit-logger": {
    "enabled": true,
    "logLevel": "all"
  }
}
EOF

    success "Created overrides file: $OVERRIDES_FILE"
}

# ============================================================================
# Merge Settings
# ============================================================================
merge_settings() {
    info "Configuring Claude Code settings..."

    # Define the hooks configuration
    local hooks_config
    read -r -d '' hooks_config << 'HOOKS_EOF' || true
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          "$HOME/.bun/bin/bun $HOME/.claude/plugins/claude-code-safety-net/dist/bin/cc-safety-net.js --claude-code",
          "$HOME/.bun/bin/bun run $HOME/.claude/hooks/git-guardian.ts"
        ]
      },
      {
        "matcher": "Write|Edit|NotebookEdit",
        "hooks": [
          "$HOME/.bun/bin/bun run $HOME/.claude/hooks/path-guardian.ts"
        ]
      },
      {
        "matcher": "*",
        "hooks": [
          "$HOME/.bun/bin/bun run $HOME/.claude/hooks/audit-logger.ts"
        ]
      }
    ]
  }
}
HOOKS_EOF

    # Create settings.json if it doesn't exist
    if [[ ! -f "$SETTINGS_FILE" ]]; then
        echo '{}' > "$SETTINGS_FILE"
        info "Created new settings.json"
    fi

    # Check if jq is available
    if check_jq; then
        # Use jq for safe JSON merging
        local temp_file=$(mktemp)
        local hooks_temp=$(mktemp)

        echo "$hooks_config" > "$hooks_temp"

        # Read existing settings and merge with hooks config
        # This preserves all existing settings and adds/replaces only the hooks section
        jq -s '.[0] * .[1]' "$SETTINGS_FILE" "$hooks_temp" > "$temp_file"

        if [[ -s "$temp_file" ]] && jq empty "$temp_file" 2>/dev/null; then
            mv "$temp_file" "$SETTINGS_FILE"
            rm -f "$hooks_temp"
            success "Settings merged successfully"
        else
            error "Failed to merge settings - invalid JSON produced"
            rm -f "$temp_file" "$hooks_temp"
            exit 1
        fi
    else
        # Fallback: Use bun/node for JSON merging
        warn "Using fallback JSON merge (install jq for more reliable merging)"

        local temp_script=$(mktemp)
        cat > "$temp_script" << 'SCRIPT_EOF'
const fs = require('fs');
const settingsPath = process.argv[2];
const hooksConfig = JSON.parse(process.argv[3]);

let settings = {};
try {
    settings = JSON.parse(fs.readFileSync(settingsPath, 'utf8'));
} catch (e) {
    settings = {};
}

// Deep merge - hooks config overwrites hooks section only
settings.hooks = hooksConfig.hooks;

fs.writeFileSync(settingsPath, JSON.stringify(settings, null, 2));
console.log('Settings merged');
SCRIPT_EOF

        if bun "$temp_script" "$SETTINGS_FILE" "$hooks_config" 2>/dev/null; then
            success "Settings merged successfully"
        else
            error "Failed to merge settings"
            rm -f "$temp_script"
            exit 1
        fi
        rm -f "$temp_script"
    fi
}

# ============================================================================
# Install CLI
# ============================================================================
install_cli() {
    info "Installing guardrails CLI..."

    local src_bin="$PACKAGE_DIR/bin/guardrails"

    if [[ ! -f "$src_bin" ]]; then
        warn "CLI binary not found: $src_bin"
        warn "Skipping CLI installation"
        return 1
    fi

    cp "$src_bin" "$BIN_DIR/guardrails"
    chmod +x "$BIN_DIR/guardrails"

    success "CLI installed to $BIN_DIR/guardrails"
}

# ============================================================================
# Print Success
# ============================================================================
print_success() {
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                               ║${NC}"
    echo -e "${GREEN}║   ${BOLD}Installation Complete!${NC}${GREEN}                                     ║${NC}"
    echo -e "${GREEN}║                                                               ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}${BOLD}IMPORTANT:${NC} Restart Claude Code for changes to take effect"
    echo ""
    echo "  Quick commands:"
    echo ""
    echo -e "    ${CYAN}Check status:${NC}"
    echo "      $BIN_DIR/guardrails status"
    echo ""
    echo -e "    ${CYAN}Run tests:${NC}"
    echo "      $BIN_DIR/guardrails test"
    echo ""
    echo -e "    ${CYAN}View logs:${NC}"
    echo "      ls -la $LOGS_DIR"
    echo ""
    echo -e "    ${CYAN}Customize behavior:${NC}"
    echo "      Edit $OVERRIDES_FILE"
    echo ""
}

# ============================================================================
# Main
# ============================================================================
main() {
    print_banner

    check_bun
    check_safety_net
    create_directories
    copy_hooks
    create_overrides
    merge_settings
    install_cli

    print_success
}

main "$@"
