#!/usr/bin/env bun
/**
 * =============================================================================
 * GIT GUARDIAN HOOK
 * =============================================================================
 *
 * A PreToolUse hook for Bash commands that enforces git workflow safety rules.
 * Specifically designed to prevent accidental or unintended changes to version
 * control history on protected branches.
 *
 * WHAT THIS HOOK DOES:
 * --------------------
 * - Intercepts all Bash tool invocations that contain "git" commands
 * - Parses git push commands to extract target branch and force flags
 * - Blocks pushes to protected branches (main, master, production, prod)
 * - Blocks force pushes (--force, -f) but allows --force-with-lease
 * - Handles complex command strings (chained commands, shell wrappers)
 *
 * WHAT IT BLOCKS:
 * ---------------
 * - `git push origin main` - Direct push to protected branch
 * - `git push -f origin feature` - Force push (dangerous, rewrites history)
 * - `git push --force origin any-branch` - Force push with long flag
 * - `bash -c 'git push origin master'` - Push to protected branch via shell
 * - `git add . && git commit && git push origin prod` - Chained push to protected
 *
 * WHAT IT ALLOWS:
 * ---------------
 * - `git push origin feature-branch` - Push to non-protected branch
 * - `git push --force-with-lease origin feature` - Safe force push
 * - `git pull`, `git fetch`, `git status`, etc. - Non-push operations
 * - Branches listed in allowed_branches override
 * - Commands listed in allowed_commands override
 *
 * WHY --force-with-lease IS ALLOWED:
 * ----------------------------------
 * Unlike --force, --force-with-lease checks that the remote branch hasn't
 * been updated since you last fetched. This prevents accidentally overwriting
 * commits that someone else pushed. It's the "safe" way to rewrite history
 * when you need to (e.g., after rebase).
 *
 * FAIL-CLOSED BEHAVIOR:
 * ---------------------
 * This hook implements a fail-closed security model:
 * - If the hook cannot parse input JSON -> BLOCK
 * - If the hook encounters an unexpected error -> BLOCK
 * - If overrides file is malformed -> overrides are ignored
 *
 * RELATIONSHIP TO claude-code-safety-net:
 * ---------------------------------------
 * This hook focuses specifically on git push rules. Other destructive git
 * operations (reset --hard, clean -f, rebase -i, etc.) are handled by
 * claude-code-safety-net, which is built into Claude Code.
 *
 * CONFIGURATION:
 * --------------
 * 1. PROTECTED_BRANCHES: Branch names that cannot receive direct pushes.
 *    Modify this list to match your workflow.
 *
 * 2. Override file (~/.claude/guardrails-overrides.json):
 *    - allowed_branches: Branch patterns that can be pushed to
 *    - allowed_commands: Exact commands that bypass all checks
 *
 *    Example:
 *    {
 *      "allowed_branches": ["main", "release-*"],
 *      "allowed_commands": ["git push origin main --tags"]
 *    }
 *
 * EXIT CODES:
 * -----------
 * - 0: Operation is allowed (hook permits the tool call)
 * - 2: Operation is blocked (hook rejects the tool call)
 *
 * @see https://docs.anthropic.com/claude-code/hooks for hook documentation
 */

import { homedir } from "os";
import { existsSync, readFileSync } from "fs";

// =============================================================================
// TYPE DEFINITIONS
// =============================================================================

/**
 * Structure of the JSON input received from Claude Code via stdin.
 * This is the standard PreToolUse hook input format.
 */
interface HookInput {
  /** The name of the tool being invoked (always "Bash" for this hook) */
  tool_name: string;
  /** The input parameters passed to the tool */
  tool_input: {
    /** The shell command to execute */
    command?: string;
  };
  /** Current working directory of the Claude Code session */
  cwd: string;
  /** Unique identifier for the current session */
  session_id: string;
}

/**
 * Structure of the guardrails-overrides.json configuration file.
 */
interface Overrides {
  /** Glob patterns for paths (used by path-guardian, not this hook) */
  allowed_paths: string[];
  /** Exact commands that bypass all git-guardian checks */
  allowed_commands: string[];
  /** Branch patterns that can receive pushes despite being protected */
  allowed_branches: string[];
}

/**
 * Parsed information about a git push command.
 */
interface PushInfo {
  /** Whether this is a git push command */
  isPush: boolean;
  /** Whether --force or -f flag is present (excluding --force-with-lease) */
  isForce: boolean;
  /** Whether --force-with-lease flag is present */
  isForceWithLease: boolean;
  /** The target branch name, if specified */
  targetBranch: string | null;
  /** The remote name (e.g., "origin"), if specified */
  remote: string | null;
}

// =============================================================================
// CONFIGURATION - Modify these to customize behavior
// =============================================================================

/**
 * Branch names that are protected from direct pushes.
 *
 * Direct pushes to these branches are blocked because:
 * - main/master: Primary development branch, should use PRs
 * - production/prod: Production deployment branches, critical
 *
 * Add or remove branches based on your team's workflow.
 * Use allowed_branches in overrides for per-project exceptions.
 */
const PROTECTED_BRANCHES = [
  "main",       // GitHub's default branch name
  "master",     // Traditional Git default branch name
  "production", // Common production branch name
  "prod",       // Abbreviated production branch name
];

// =============================================================================
// RESPONSE FUNCTIONS
// =============================================================================

/**
 * Block the operation and exit with code 2.
 * Prints the reason to stderr so it appears in Claude Code's output.
 *
 * @param reason - Human-readable explanation of why the operation was blocked
 */
function block(reason: string): never {
  console.error(`BLOCKED by git-guardian: ${reason}`);
  process.exit(2);
}

/**
 * Allow the operation and exit with code 0.
 * No output is printed for allowed operations.
 */
function allow(): never {
  process.exit(0);
}

// =============================================================================
// OVERRIDE HANDLING
// =============================================================================

/**
 * Load the guardrails overrides configuration file.
 *
 * This file allows users to customize protection behavior.
 * Located at ~/.claude/guardrails-overrides.json
 *
 * FAIL-CLOSED: If the file doesn't exist, is unreadable, or is malformed,
 * we return empty overrides rather than failing open.
 *
 * @returns The parsed overrides, or empty defaults if unavailable
 */
function loadOverrides(): Overrides {
  const overridePath = `${homedir()}/.claude/guardrails-overrides.json`;
  try {
    if (existsSync(overridePath)) {
      const content = readFileSync(overridePath, "utf-8");
      const parsed = JSON.parse(content);
      return {
        allowed_paths: parsed.allowed_paths || [],
        allowed_commands: parsed.allowed_commands || [],
        allowed_branches: parsed.allowed_branches || [],
      };
    }
  } catch {
    // Fail-closed: if we can't read or parse overrides, ignore them
    // This is safer than potentially allowing unintended operations
  }
  return { allowed_paths: [], allowed_commands: [], allowed_branches: [] };
}

/**
 * Simple wildcard pattern matching for branch names.
 *
 * Supports:
 * - * : Matches any characters (e.g., "release-*" matches "release-1.0")
 *
 * @param value - The branch name to test
 * @param pattern - The pattern to match against
 * @returns true if the value matches the pattern
 */
function matchesPattern(value: string, pattern: string): boolean {
  // Convert wildcard pattern to regex: * becomes .*
  const regexPattern = pattern.replace(/\*/g, ".*");
  const regex = new RegExp(`^${regexPattern}$`);
  return regex.test(value);
}

/**
 * Check if a branch name is in the allowed_branches overrides.
 *
 * @param branch - The branch name to check
 * @param overrides - The loaded overrides configuration
 * @returns true if the branch matches an allowed pattern
 */
function isBranchInOverrides(branch: string, overrides: Overrides): boolean {
  for (const pattern of overrides.allowed_branches) {
    if (matchesPattern(branch, pattern)) {
      return true;
    }
  }
  return false;
}

/**
 * Check if a command exactly matches one in allowed_commands.
 *
 * Commands are normalized (whitespace collapsed) for comparison
 * to handle minor formatting differences.
 *
 * @param command - The command to check
 * @param overrides - The loaded overrides configuration
 * @returns true if the command is explicitly allowed
 */
function isCommandInOverrides(command: string, overrides: Overrides): boolean {
  // Normalize whitespace for comparison
  const normalizedCmd = command.trim().replace(/\s+/g, " ");

  for (const allowedCmd of overrides.allowed_commands) {
    const normalizedAllowed = allowedCmd.trim().replace(/\s+/g, " ");
    if (normalizedCmd === normalizedAllowed) {
      return true;
    }
  }
  return false;
}

// =============================================================================
// GIT COMMAND PARSING
// =============================================================================

/**
 * Extract git commands from a shell command string.
 *
 * This handles various ways git commands can be invoked:
 * - Direct: `git push origin main`
 * - Shell wrapper: `bash -c 'git push origin main'`
 * - Chained: `git add . && git commit -m "msg" && git push`
 * - Piped: `echo "password" | git push` (extracts git part)
 *
 * We need this complexity because Claude can construct commands
 * in many ways, and we need to catch all of them.
 *
 * @param command - The full shell command string
 * @returns Array of extracted git command strings
 */
function extractGitCommands(command: string): string[] {
  const gitCommands: string[] = [];

  // Case 1: Direct git command (most common)
  // e.g., "git push origin main" or just "git"
  if (command.trim().startsWith("git ") || command.trim() === "git") {
    gitCommands.push(command.trim());
  }

  // Case 2: Git command inside shell wrapper
  // e.g., bash -c 'git push origin main', sh -c "git status", zsh -c '...'
  const shellPatterns = [
    /bash\s+-c\s+['"]([^'"]+)['"]/g,
    /sh\s+-c\s+['"]([^'"]+)['"]/g,
    /zsh\s+-c\s+['"]([^'"]+)['"]/g,
  ];

  for (const pattern of shellPatterns) {
    let match;
    while ((match = pattern.exec(command)) !== null) {
      const innerCmd = match[1];
      // Look for git command within the shell wrapper
      if (innerCmd.includes("git ")) {
        const gitMatch = innerCmd.match(/git\s+[^\s;|&]+.*/);
        if (gitMatch) {
          gitCommands.push(gitMatch[0]);
        }
      }
    }
  }

  // Case 3: Chained commands (&&, ||, ;)
  // e.g., "git add . && git commit -m 'msg' && git push"
  const chainedCommands = command.split(/\s*(?:&&|\|\||;)\s*/);
  for (const cmd of chainedCommands) {
    const trimmed = cmd.trim();
    // Only add if it's a git command and not already captured
    if (trimmed.startsWith("git ") && !gitCommands.includes(trimmed)) {
      gitCommands.push(trimmed);
    }
  }

  return gitCommands;
}

/**
 * Parse a git push command and extract relevant information.
 *
 * Extracts:
 * - Whether this is a push command
 * - Whether force flags are present
 * - The target remote (e.g., "origin")
 * - The target branch (e.g., "main")
 *
 * Handles various push syntaxes:
 * - `git push` (uses defaults)
 * - `git push origin` (uses current branch)
 * - `git push origin main` (explicit remote and branch)
 * - `git push origin local:remote` (refspec syntax)
 * - `git push -u origin feature` (with tracking)
 *
 * @param gitCommand - A git command string to parse
 * @returns Parsed push information
 */
function parseGitPush(gitCommand: string): PushInfo {
  const result: PushInfo = {
    isPush: false,
    isForce: false,
    isForceWithLease: false,
    targetBranch: null,
    remote: null,
  };

  // Check if this is a push command
  const pushMatch = gitCommand.match(/^git\s+push\b/);
  if (!pushMatch) {
    return result;
  }
  result.isPush = true;

  // Check for --force-with-lease FIRST (it's the safe variant)
  // This must be checked before --force because --force-with-lease contains "force"
  result.isForceWithLease = /--force-with-lease\b/.test(gitCommand);

  // Check for dangerous force flags (but NOT force-with-lease)
  // -f is the short form of --force
  result.isForce =
    !result.isForceWithLease &&
    (/\s--force\b/.test(gitCommand) || /\s-f\b/.test(gitCommand));

  // Extract remote and branch by removing flags first
  // This leaves us with just the positional arguments
  let cleaned = gitCommand
    .replace(/^git\s+push\s*/, "")     // Remove "git push "
    .replace(/--force-with-lease\b/g, "")  // Remove safe force flag
    .replace(/--force\b/g, "")         // Remove force flag
    .replace(/-f\b/g, "")              // Remove short force flag
    .replace(/-u\b/g, "")              // Remove upstream flag
    .replace(/--set-upstream\b/g, "")  // Remove long upstream flag
    .replace(/--all\b/g, "")           // Remove all flag
    .replace(/--tags\b/g, "")          // Remove tags flag
    .replace(/--delete\b/g, "")        // Remove delete flag
    .replace(/-d\b/g, "")              // Remove short delete flag
    .trim();

  // Parse remaining positional arguments
  // Format is typically: [remote] [branch] or [remote] [local:remote]
  const args = cleaned.split(/\s+/).filter((a) => a.length > 0);

  if (args.length >= 1) {
    result.remote = args[0];  // First arg is remote (e.g., "origin")
  }

  if (args.length >= 2) {
    // Second arg is branch or refspec
    const refspec = args[1];
    if (refspec.includes(":")) {
      // Refspec format: local:remote (e.g., "feature:main")
      // The target branch is after the colon
      result.targetBranch = refspec.split(":")[1] || refspec.split(":")[0];
    } else {
      result.targetBranch = refspec;
    }
  }

  return result;
}

// =============================================================================
// MAIN ENTRY POINT
// =============================================================================

/**
 * Main function - processes the hook input and decides allow/block.
 *
 * Flow:
 * 1. Parse input from stdin (fail-closed on parse error)
 * 2. Skip if not a git command (allow non-git commands)
 * 3. Check if entire command is in allowed_commands override
 * 4. Extract and parse all git commands from the input
 * 5. For each push command:
 *    a. Block if --force (not --force-with-lease)
 *    b. Block if pushing to protected branch (unless overridden)
 * 6. Allow if all checks pass
 */
async function main() {
  let input: HookInput;

  // Parse the JSON input from stdin
  // FAIL-CLOSED: If we can't parse input, we block the operation
  try {
    const stdin = await Bun.stdin.text();
    input = JSON.parse(stdin);
  } catch (error) {
    block(`Failed to parse hook input (fail-closed): ${error}`);
  }

  const { tool_input, cwd } = input!;
  const command = tool_input.command;

  // No command to check - allow (tool will likely fail anyway)
  if (!command) {
    allow();
  }

  // Quick check: skip if not a git command at all
  // This is a performance optimization - most commands aren't git
  if (!command.includes("git")) {
    allow();
  }

  const overrides = loadOverrides();

  // Check if the entire command is explicitly allowed
  // This provides an escape hatch for specific known-good commands
  if (isCommandInOverrides(command, overrides)) {
    allow();
  }

  // Extract all git commands from the input
  // This handles chained commands, shell wrappers, etc.
  const gitCommands = extractGitCommands(command);

  // Analyze each git command
  for (const gitCmd of gitCommands) {
    const pushInfo = parseGitPush(gitCmd);

    // Skip non-push commands - they're handled by other mechanisms
    // (claude-code-safety-net handles reset --hard, clean -f, etc.)
    if (!pushInfo.isPush) {
      continue;
    }

    // RULE 1: Block force pushes (but allow --force-with-lease)
    // Force pushes rewrite history and can cause data loss
    if (pushInfo.isForce) {
      block(
        `Force push detected: "${gitCmd}"\n` +
        `Force pushes are blocked to protect version history.\n` +
        `Safe alternative: Use --force-with-lease instead.\n` +
        `To override: Add command to ~/.claude/guardrails-overrides.json`
      );
    }

    // RULE 2: Block pushes to protected branches
    // These branches should only receive changes via PR
    if (pushInfo.targetBranch) {
      const branch = pushInfo.targetBranch;

      // Skip if branch is explicitly allowed in overrides
      if (isBranchInOverrides(branch, overrides)) {
        continue;
      }

      // Check against protected branches list
      for (const protected_branch of PROTECTED_BRANCHES) {
        if (branch === protected_branch) {
          block(
            `Push to protected branch detected: "${gitCmd}"\n` +
            `Direct pushes to "${branch}" are blocked.\n` +
            `Alternatives:\n` +
            `  - Push to a feature branch: git push origin feature-branch\n` +
            `  - Create a pull request for review\n` +
            `To override: Add "${branch}" to allowed_branches in ~/.claude/guardrails-overrides.json`
          );
        }
      }
    }
  }

  // All checks passed - allow the command
  allow();
}

// Run main and handle any unexpected errors with fail-closed behavior
main().catch((error) => {
  block(`Unexpected error (fail-closed): ${error}`);
});
