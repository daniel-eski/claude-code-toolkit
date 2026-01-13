#!/bin/bash
#
# Claude Guardrails - Hook Test Suite
# Run this to verify all hooks are working correctly
#

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Counters
PASSED=0
FAILED=0

# Get script directory (works even if called from different location)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_DIR="$(dirname "$SCRIPT_DIR")"
HOOKS_DIR="$PACKAGE_DIR/src/hooks"

# Check if hooks exist in package
if [[ ! -d "$HOOKS_DIR" ]]; then
    echo -e "${RED}Error: Hooks not found at $HOOKS_DIR${NC}"
    echo "Make sure you're running from the claude-guardrails package directory"
    exit 1
fi

# Check for bun
BUN_PATH="$HOME/.bun/bin/bun"
if [[ ! -x "$BUN_PATH" ]]; then
    echo -e "${RED}Error: Bun not found at $BUN_PATH${NC}"
    exit 1
fi

echo "========================================"
echo "  Claude Guardrails - Test Suite"
echo "========================================"
echo ""
echo "Testing hooks from: $HOOKS_DIR"
echo ""

# Helper function to run a hook test
run_test() {
    local test_name="$1"
    local hook_file="$2"
    local input_json="$3"
    local expect_block="$4"  # "block" or "allow"

    echo -n "  Testing: $test_name... "

    local output
    local exit_code

    output=$(echo "$input_json" | "$BUN_PATH" run "$HOOKS_DIR/$hook_file" 2>&1) || exit_code=$?
    exit_code=${exit_code:-0}

    if [[ "$expect_block" == "block" ]]; then
        if [[ $exit_code -eq 2 ]]; then
            echo -e "${GREEN}PASS${NC} (blocked as expected)"
            ((PASSED++))
        else
            echo -e "${RED}FAIL${NC} (expected block, got exit code $exit_code)"
            echo "    Output: $output"
            ((FAILED++))
        fi
    else
        if [[ $exit_code -eq 0 ]]; then
            echo -e "${GREEN}PASS${NC} (allowed as expected)"
            ((PASSED++))
        else
            echo -e "${RED}FAIL${NC} (expected allow, got exit code $exit_code)"
            echo "    Output: $output"
            ((FAILED++))
        fi
    fi
}

# ========================================
# PATH GUARDIAN TESTS
# ========================================
echo "----------------------------------------"
echo "Path Guardian Tests"
echo "----------------------------------------"

# Test 1: Allow write within cwd
run_test "Allow write within cwd" "path-guardian.ts" \
    '{"tool_name":"Write","tool_input":{"file_path":"./test.txt"},"cwd":"/tmp","session_id":"test"}' \
    "allow"

# Test 2: Allow write to /tmp
run_test "Allow write to /tmp" "path-guardian.ts" \
    '{"tool_name":"Write","tool_input":{"file_path":"/tmp/test.txt"},"cwd":"/Users/test/project","session_id":"test"}' \
    "allow"

# Test 3: Block write outside cwd
run_test "Block write outside cwd" "path-guardian.ts" \
    '{"tool_name":"Write","tool_input":{"file_path":"/etc/passwd"},"cwd":"/tmp","session_id":"test"}' \
    "block"

# Test 4: Block write to ~/.ssh
run_test "Block write to ~/.ssh" "path-guardian.ts" \
    "{\"tool_name\":\"Write\",\"tool_input\":{\"file_path\":\"$HOME/.ssh/config\"},\"cwd\":\"/tmp\",\"session_id\":\"test\"}" \
    "block"

# Test 5: Block write to ~/.aws
run_test "Block write to ~/.aws" "path-guardian.ts" \
    "{\"tool_name\":\"Write\",\"tool_input\":{\"file_path\":\"$HOME/.aws/credentials\"},\"cwd\":\"/tmp\",\"session_id\":\"test\"}" \
    "block"

# Test 6: Block write to guardrails override file
run_test "Block write to override file" "path-guardian.ts" \
    "{\"tool_name\":\"Write\",\"tool_input\":{\"file_path\":\"$HOME/.claude/guardrails-overrides.json\"},\"cwd\":\"/tmp\",\"session_id\":\"test\"}" \
    "block"

echo ""

# ========================================
# GIT GUARDIAN TESTS
# ========================================
echo "----------------------------------------"
echo "Git Guardian Tests"
echo "----------------------------------------"

# Test 1: Allow push to feature branch
run_test "Allow push to feature branch" "git-guardian.ts" \
    '{"tool_name":"Bash","tool_input":{"command":"git push origin feature-branch"},"cwd":"/tmp","session_id":"test"}' \
    "allow"

# Test 2: Block push to main
run_test "Block push to main" "git-guardian.ts" \
    '{"tool_name":"Bash","tool_input":{"command":"git push origin main"},"cwd":"/tmp","session_id":"test"}' \
    "block"

# Test 3: Block push to master
run_test "Block push to master" "git-guardian.ts" \
    '{"tool_name":"Bash","tool_input":{"command":"git push origin master"},"cwd":"/tmp","session_id":"test"}' \
    "block"

# Test 4: Block force push
run_test "Block force push" "git-guardian.ts" \
    '{"tool_name":"Bash","tool_input":{"command":"git push --force origin feature-branch"},"cwd":"/tmp","session_id":"test"}' \
    "block"

# Test 5: Block force push (short flag)
run_test "Block force push (-f)" "git-guardian.ts" \
    '{"tool_name":"Bash","tool_input":{"command":"git push -f origin feature-branch"},"cwd":"/tmp","session_id":"test"}' \
    "block"

# Test 6: Allow force-with-lease
run_test "Allow force-with-lease" "git-guardian.ts" \
    '{"tool_name":"Bash","tool_input":{"command":"git push --force-with-lease origin feature-branch"},"cwd":"/tmp","session_id":"test"}' \
    "allow"

# Test 7: Allow non-git commands
run_test "Allow non-git commands" "git-guardian.ts" \
    '{"tool_name":"Bash","tool_input":{"command":"ls -la"},"cwd":"/tmp","session_id":"test"}' \
    "allow"

echo ""

# ========================================
# AUDIT LOGGER TESTS
# ========================================
echo "----------------------------------------"
echo "Audit Logger Tests"
echo "----------------------------------------"

# Create temp log directory for testing
TEST_LOG_DIR=$(mktemp -d)
export GUARDRAILS_LOG_DIR="$TEST_LOG_DIR"

# Test 1: Audit logger should never block
run_test "Audit logger never blocks" "audit-logger.ts" \
    '{"tool_name":"Bash","tool_input":{"command":"rm -rf /"},"cwd":"/tmp","session_id":"test-audit"}' \
    "allow"

# Note: Audit logger writes to ~/.claude/guardrails-logs/ by default
# We can't easily test log content without modifying the hook

echo ""

# Clean up
rm -rf "$TEST_LOG_DIR"

# ========================================
# SUMMARY
# ========================================
echo "========================================"
echo "  Test Summary"
echo "========================================"
echo ""
echo -e "  Passed: ${GREEN}$PASSED${NC}"
echo -e "  Failed: ${RED}$FAILED${NC}"
echo ""

if [[ $FAILED -eq 0 ]]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed. See above for details.${NC}"
    exit 1
fi
