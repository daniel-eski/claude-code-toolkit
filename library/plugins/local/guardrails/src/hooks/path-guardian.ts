#!/usr/bin/env bun
/**
 * =============================================================================
 * PATH GUARDIAN HOOK
 * =============================================================================
 *
 * A PreToolUse hook that protects the filesystem by blocking Write, Edit, and
 * NotebookEdit operations outside of a safe operating envelope.
 *
 * WHAT THIS HOOK DOES:
 * --------------------
 * - Intercepts all file write operations (Write, Edit, NotebookEdit tools)
 * - Validates that the target path is within an allowed zone
 * - Blocks operations that target sensitive system directories or files
 * - Resolves symlinks to prevent symlink-based escapes
 * - Detects and blocks path traversal attempts (../)
 *
 * WHAT IT BLOCKS:
 * ---------------
 * - Any write to paths outside the current working directory (cwd)
 * - Any write to sensitive directories (~/.ssh, ~/.aws, /etc, /System, etc.)
 * - Any write to the guardrails configuration itself (prevent self-modification)
 * - Path traversal attempts that try to escape the safe zone
 *
 * WHAT IT ALLOWS:
 * ---------------
 * - Writes within the current working directory (cwd)
 * - Writes to temp directories (/tmp, /var/tmp, system temp)
 * - Writes to paths explicitly listed in guardrails-overrides.json
 *
 * FAIL-CLOSED BEHAVIOR:
 * ---------------------
 * This hook implements a fail-closed security model:
 * - If the hook cannot parse input JSON -> BLOCK
 * - If the hook encounters an unexpected error -> BLOCK
 * - If symlink resolution fails -> uses normalized path (safer)
 * - If overrides file is malformed -> overrides are ignored
 *
 * The rationale: it's safer to accidentally block a legitimate operation
 * (which the user can then override) than to accidentally allow a dangerous one.
 *
 * CONFIGURATION:
 * --------------
 * 1. ALWAYS_BLOCKED_PATTERNS: Paths that are NEVER writable, even if within cwd.
 *    These protect critical system and user configuration files.
 *
 * 2. ALWAYS_SAFE_PATTERNS: Temp directories that are always safe for writes.
 *    These bypass the cwd check.
 *
 * 3. Override file (~/.claude/guardrails-overrides.json):
 *    Add paths to allowed_paths array using glob patterns:
 *    {
 *      "allowed_paths": [
 *        "~/Projects/**",
 *        "/opt/myapp/*"
 *      ]
 *    }
 *
 * EXIT CODES:
 * -----------
 * - 0: Operation is allowed (hook permits the tool call)
 * - 2: Operation is blocked (hook rejects the tool call)
 *
 * @see https://docs.anthropic.com/claude-code/hooks for hook documentation
 */

import { homedir, tmpdir } from "os";
import { resolve, normalize } from "path";
import { existsSync, readFileSync, realpathSync } from "fs";

// =============================================================================
// TYPE DEFINITIONS
// =============================================================================

/**
 * Structure of the JSON input received from Claude Code via stdin.
 * This is the standard PreToolUse hook input format.
 */
interface HookInput {
  /** The name of the tool being invoked (e.g., "Write", "Edit", "NotebookEdit") */
  tool_name: string;
  /** The input parameters passed to the tool */
  tool_input: {
    /** File path for Write/Edit tools */
    file_path?: string;
    /** Notebook path for NotebookEdit tool */
    notebook_path?: string;
    /** File content (not used by this hook, but present in input) */
    content?: string;
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
  /** Glob patterns for paths that should be allowed beyond the cwd */
  allowed_paths: string[];
  /** Commands that bypass the git-guardian (not used by this hook) */
  allowed_commands: string[];
  /** Branch names that can receive pushes (not used by this hook) */
  allowed_branches: string[];
}

// =============================================================================
// CONFIGURATION - Modify these to customize behavior
// =============================================================================

/**
 * Paths that are ALWAYS blocked, even if they fall within the current
 * working directory. These protect critical system and user files.
 *
 * Add paths here that should NEVER be writable by Claude Code, regardless
 * of what directory the user is working in.
 *
 * SECURITY NOTE: The hooks directory and overrides file are included here
 * to prevent Claude from modifying its own guardrails.
 */
const ALWAYS_BLOCKED_PATTERNS = [
  // SSH keys and configuration - protect remote access credentials
  `${homedir()}/.ssh`,

  // AWS credentials - protect cloud access
  `${homedir()}/.aws`,

  // GPG keys - protect encryption keys
  `${homedir()}/.gnupg`,

  // Guardrails self-protection - prevent Claude from disabling its own guardrails
  `${homedir()}/.claude/guardrails-overrides.json`,
  `${homedir()}/.claude/hooks`,
  `${homedir()}/.claude/settings.json`,

  // System directories - protect OS integrity
  "/etc",           // System configuration
  "/usr",           // System programs and libraries
  "/System",        // macOS system files
  "/Library",       // macOS system libraries
  "/bin",           // Essential system binaries
  "/sbin",          // System administration binaries
  "/var/root",      // Root user's home directory
];

/**
 * Directories that are always safe for writing, regardless of cwd.
 * These are temporary directories used for scratch files.
 *
 * Files written here are expected to be ephemeral and are cleaned
 * up by the system periodically.
 */
const ALWAYS_SAFE_PATTERNS = [
  "/tmp",           // Standard Unix temp directory
  "/var/tmp",       // Persistent temp directory (survives reboots)
  tmpdir(),         // OS-specific temp directory (e.g., $TMPDIR on macOS)
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
  console.error(`BLOCKED by path-guardian: ${reason}`);
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
// PATH RESOLUTION AND VALIDATION
// =============================================================================

/**
 * Resolve a potentially relative path to an absolute, normalized path.
 *
 * This function:
 * 1. Expands ~ to the user's home directory
 * 2. Resolves relative paths against the provided cwd
 * 3. Normalizes the path (removes redundant slashes, resolves . and ..)
 * 4. Attempts to resolve symlinks to get the real path
 *
 * The symlink resolution is important for security - it prevents attacks
 * where a symlink in an allowed directory points to a protected location.
 *
 * @param filePath - The path to resolve (may be relative, may contain ~)
 * @param cwd - The current working directory for relative path resolution
 * @returns The resolved absolute path
 */
function resolvePath(filePath: string, cwd: string): string {
  // Handle tilde expansion (~ -> /Users/username or /home/username)
  if (filePath.startsWith("~")) {
    filePath = filePath.replace(/^~/, homedir());
  }

  // Resolve to absolute path and normalize
  // This handles relative paths like "./foo" or "../bar"
  let resolved = normalize(resolve(cwd, filePath));

  // Try to resolve symlinks to get the real path
  // This is critical for security - prevents symlink-based escapes
  try {
    if (existsSync(resolved)) {
      resolved = realpathSync(resolved);
    }
  } catch {
    // If we can't resolve symlinks (e.g., permission denied),
    // use the normalized path. This is fail-safe since we're
    // being conservative rather than permissive.
  }

  return resolved;
}

/**
 * Check if a path matches any of the always-blocked patterns.
 *
 * @param absPath - The absolute path to check
 * @returns A reason string if blocked, null if not blocked
 */
function isPathBlocked(absPath: string): string | null {
  for (const blocked of ALWAYS_BLOCKED_PATTERNS) {
    // Check for exact match or if path is inside blocked directory
    if (absPath === blocked || absPath.startsWith(blocked + "/")) {
      return `Path "${absPath}" matches always-blocked pattern: ${blocked}`;
    }
  }
  return null;
}

/**
 * Check if a path is within a safe zone (cwd or temp directories).
 *
 * @param absPath - The absolute path to check
 * @param cwd - The current working directory
 * @returns true if the path is in a safe zone
 */
function isPathInSafeZone(absPath: string, cwd: string): boolean {
  // Resolve cwd to absolute path for accurate comparison
  const absCwd = resolvePath(cwd, cwd);

  // Check if within current working directory
  if (absPath.startsWith(absCwd + "/") || absPath === absCwd) {
    return true;
  }

  // Check if within any of the always-safe temp directories
  for (const safe of ALWAYS_SAFE_PATTERNS) {
    if (absPath.startsWith(safe + "/") || absPath === safe) {
      return true;
    }
  }

  return false;
}

// =============================================================================
// OVERRIDE HANDLING
// =============================================================================

/**
 * Load the guardrails overrides configuration file.
 *
 * This file allows users to extend the safe zones beyond cwd.
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
    // This is safer than potentially allowing unintended access
  }
  return { allowed_paths: [], allowed_commands: [], allowed_branches: [] };
}

/**
 * Simple glob pattern matching.
 *
 * Supports:
 * - ** : Matches any path (including subdirectories)
 * - *  : Matches any characters within a single path segment
 *
 * Examples:
 * - "~/Projects/**" matches any file under ~/Projects
 * - "~/Projects/*" matches only direct children of ~/Projects
 * - "~/Projects/*.ts" matches .ts files directly in ~/Projects
 *
 * @param path - The path to test
 * @param pattern - The glob pattern to match against
 * @returns true if the path matches the pattern
 */
function matchesGlob(path: string, pattern: string): boolean {
  // Convert glob pattern to regex:
  // 1. First, protect ** by replacing with a placeholder
  // 2. Replace * with [^/]* (match anything except path separator)
  // 3. Replace ** placeholder with .* (match anything including /)
  const regexPattern = pattern
    .replace(/\*\*/g, "<<<DOUBLESTAR>>>")
    .replace(/\*/g, "[^/]*")
    .replace(/<<<DOUBLESTAR>>>/g, ".*");

  const regex = new RegExp(`^${regexPattern}$`);
  return regex.test(path);
}

/**
 * Check if a path matches any of the allowed patterns in overrides.
 *
 * @param absPath - The absolute path to check
 * @param overrides - The loaded overrides configuration
 * @returns true if the path matches an allowed pattern
 */
function isPathInOverrides(absPath: string, overrides: Overrides): boolean {
  for (const pattern of overrides.allowed_paths) {
    // Expand ~ in override patterns for consistent matching
    const expandedPattern = pattern.startsWith("~")
      ? pattern.replace(/^~/, homedir())
      : pattern;

    if (matchesGlob(absPath, expandedPattern)) {
      return true;
    }
  }
  return false;
}

// =============================================================================
// MAIN ENTRY POINT
// =============================================================================

/**
 * Main function - processes the hook input and decides allow/block.
 *
 * Flow:
 * 1. Parse input from stdin (fail-closed on parse error)
 * 2. Extract and resolve the file path
 * 3. Check for path traversal attacks
 * 4. Check against always-blocked patterns
 * 5. Check if in safe zone (cwd or temp)
 * 6. Check if in overrides
 * 7. Block if none of the above allow it
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

  const { tool_name, tool_input, cwd } = input!;

  // Get the file path from the tool input
  // Write and Edit use file_path, NotebookEdit uses notebook_path
  const filePath = tool_input.file_path || tool_input.notebook_path;

  if (!filePath) {
    // No file path to check - this shouldn't happen for Write/Edit/NotebookEdit
    // but if it does, allow it (the tool will likely fail anyway)
    allow();
  }

  // Resolve to absolute path, handling ~, relative paths, and symlinks
  const absPath = resolvePath(filePath, cwd);

  // Check for path traversal attempts
  // Even after resolution, if ".." appears in the path, something is wrong
  // This catches edge cases that might slip through symlink resolution
  if (absPath.includes("/../") || absPath.endsWith("/..")) {
    block(`Path traversal detected: "${filePath}" resolves to "${absPath}"`);
  }

  // Check always-blocked paths first
  // These CANNOT be overridden - they're the absolute blocklist
  const blockReason = isPathBlocked(absPath);
  if (blockReason) {
    block(blockReason);
  }

  // Check if in safe zone (cwd or temp directories)
  if (isPathInSafeZone(absPath, cwd)) {
    allow();
  }

  // Check user-defined overrides
  const overrides = loadOverrides();
  if (isPathInOverrides(absPath, overrides)) {
    allow();
  }

  // Not in any allowed zone - block with helpful message
  block(
    `Path "${absPath}" is outside the working directory.\n` +
    `Working directory: ${cwd}\n` +
    `To allow this operation, add the path to ~/.claude/guardrails-overrides.json`
  );
}

// Run main and handle any unexpected errors with fail-closed behavior
main().catch((error) => {
  block(`Unexpected error (fail-closed): ${error}`);
});
