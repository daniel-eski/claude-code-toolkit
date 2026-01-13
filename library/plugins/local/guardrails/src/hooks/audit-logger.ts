#!/usr/bin/env bun
/**
 * =============================================================================
 * AUDIT LOGGER HOOK
 * =============================================================================
 *
 * A PreToolUse hook that logs all tool calls to a JSONL audit trail.
 * This hook is purely observational - it NEVER blocks operations.
 *
 * WHAT THIS HOOK DOES:
 * --------------------
 * - Intercepts ALL tool invocations (Bash, Write, Edit, Read, etc.)
 * - Creates a summarized, redacted log entry for each operation
 * - Appends entries to a daily JSONL (JSON Lines) log file
 * - Hashes full tool input for forensic correlation without storing raw data
 *
 * WHAT IT LOGS:
 * -------------
 * For each tool call, the audit log captures:
 * - timestamp: ISO 8601 timestamp of when the operation occurred
 * - session_id: Unique identifier for the Claude Code session
 * - tool_name: Which tool was invoked (Bash, Write, Edit, etc.)
 * - tool_input_summary: Human-readable summary of what was done
 * - tool_input_hash: SHA256 hash of full input for forensic matching
 * - cwd: Working directory where the operation occurred
 *
 * SECURITY FEATURES:
 * ------------------
 * - Automatic redaction of sensitive patterns (API keys, passwords, tokens)
 * - Command truncation to prevent log bloat
 * - Hash-only storage of full input (no raw sensitive data in logs)
 * - Logs are stored locally in user's home directory
 *
 * WHY NEVER BLOCK:
 * ----------------
 * This hook is designed for observability, not enforcement. It:
 * - Always exits 0 (allow) regardless of any errors
 * - Silently fails if it cannot write to the log file
 * - Never interferes with the user's actual work
 *
 * The rationale: if logging fails, that's a minor inconvenience. Blocking
 * the user's work because logging failed would be a major disruption.
 *
 * LOG FILE LOCATION:
 * ------------------
 * Logs are stored at: ~/.claude/guardrails-logs/YYYY-MM-DD.jsonl
 *
 * Each day gets a new log file. Files are in JSONL format (one JSON object
 * per line) for easy parsing with tools like jq, grep, or custom scripts.
 *
 * READING LOGS:
 * -------------
 * # View today's log
 * cat ~/.claude/guardrails-logs/$(date +%Y-%m-%d).jsonl | jq
 *
 * # Find all Bash commands from today
 * cat ~/.claude/guardrails-logs/$(date +%Y-%m-%d).jsonl | jq 'select(.tool_name == "Bash")'
 *
 * # Search for operations in a specific directory
 * cat ~/.claude/guardrails-logs/*.jsonl | jq 'select(.cwd | contains("/my/project"))'
 *
 * CONFIGURATION:
 * --------------
 * 1. REDACT_PATTERNS: Regex patterns for sensitive data to redact.
 *    Add patterns for any custom secrets your organization uses.
 *
 * 2. Log directory: ~/.claude/guardrails-logs/ (created automatically)
 *
 * EXIT CODES:
 * -----------
 * - 0: Always (this hook never blocks operations)
 *
 * @see https://docs.anthropic.com/claude-code/hooks for hook documentation
 */

import { homedir } from "os";
import { appendFileSync, mkdirSync, existsSync } from "fs";
import { createHash } from "crypto";

// =============================================================================
// TYPE DEFINITIONS
// =============================================================================

/**
 * Structure of the JSON input received from Claude Code via stdin.
 * This is the standard PreToolUse hook input format.
 */
interface HookInput {
  /** The name of the tool being invoked */
  tool_name: string;
  /** The input parameters passed to the tool */
  tool_input: Record<string, unknown>;
  /** Current working directory of the Claude Code session */
  cwd: string;
  /** Unique identifier for the current session */
  session_id: string;
}

/**
 * Structure of each entry written to the audit log.
 * Designed to be useful for debugging while not storing sensitive data.
 */
interface AuditEntry {
  /** ISO 8601 timestamp when the operation occurred */
  timestamp: string;
  /** Unique identifier for the Claude Code session */
  session_id: string;
  /** Name of the tool that was invoked */
  tool_name: string;
  /** Human-readable summary of the operation (redacted) */
  tool_input_summary: string;
  /** SHA256 hash prefix of full input for forensic correlation */
  tool_input_hash: string;
  /** Working directory where the operation occurred */
  cwd: string;
}

// =============================================================================
// CONFIGURATION - Modify these to customize behavior
// =============================================================================

/**
 * Regular expressions for sensitive data patterns to redact from logs.
 *
 * When these patterns match in command strings or other tool input,
 * the matched portion is replaced with [REDACTED] (keeping a few chars
 * for debugging context).
 *
 * Add patterns for any custom secret formats your organization uses.
 *
 * SECURITY NOTE: This is defense-in-depth. The primary protection is that
 * we only log summaries, not full content. But we still redact summaries
 * to catch secrets that might appear in commands or file paths.
 */
const REDACT_PATTERNS = [
  // API keys and tokens (generic patterns)
  // Matches: api_key=xxx, apikey="xxx", token: xxx, bearer xxx, auth=xxx
  /(?:api[_-]?key|apikey|token|bearer|auth)[=:\s]["']?([a-zA-Z0-9_\-]{20,})/gi,

  // AWS Access Key IDs (always start with AKIA)
  /AKIA[0-9A-Z]{16}/g,

  // AWS Secret Access Keys
  /(?:aws[_-]?secret[_-]?access[_-]?key)[=:\s]["']?([a-zA-Z0-9/+=]{40})/gi,

  // Password patterns
  // Matches: password=xxx, passwd: xxx, pwd="xxx"
  /(?:password|passwd|pwd)[=:\s]["']?([^\s"']+)/gi,

  // Generic secret patterns
  // Matches: secret=xxx, private_key: xxx, private-key="xxx"
  /(?:secret|private[_-]?key)[=:\s]["']?([^\s"']+)/gi,

  // JWT tokens (three base64 segments separated by dots)
  /eyJ[a-zA-Z0-9_-]*\.eyJ[a-zA-Z0-9_-]*\.[a-zA-Z0-9_-]*/g,
];

/**
 * Maximum length for command summaries.
 * Commands longer than this are truncated to prevent log bloat.
 */
const MAX_COMMAND_SUMMARY_LENGTH = 200;

/**
 * Number of characters to keep visible when redacting.
 * Helps with debugging while still protecting the secret.
 */
const REDACT_VISIBLE_CHARS = 4;

// =============================================================================
// LOG DIRECTORY CONFIGURATION
// =============================================================================

/**
 * Base directory for guardrails log files.
 * Created automatically if it doesn't exist.
 */
const LOG_DIRECTORY = `${homedir()}/.claude/guardrails-logs`;

// =============================================================================
// REDACTION AND SUMMARIZATION
// =============================================================================

/**
 * Redact sensitive information from a text string.
 *
 * Matches patterns in REDACT_PATTERNS and replaces them with a partially
 * visible prefix followed by [REDACTED]. This helps with debugging
 * (you can see the start of the pattern) while protecting the actual secret.
 *
 * Example: "api_key=sk-1234567890abcdef" -> "api_[REDACTED]"
 *
 * @param text - The text to redact
 * @returns The text with sensitive patterns redacted
 */
function redactSensitive(text: string): string {
  let redacted = text;

  for (const pattern of REDACT_PATTERNS) {
    redacted = redacted.replace(pattern, (match) => {
      // Keep first few characters for debugging context
      // But limit to 1/4 of the match length to ensure most is hidden
      const visibleChars = Math.min(REDACT_VISIBLE_CHARS, Math.floor(match.length / 4));
      return match.slice(0, visibleChars) + "[REDACTED]";
    });
  }

  return redacted;
}

/**
 * Create a human-readable summary of tool input.
 *
 * Different tools have different input structures, so we handle each
 * tool type specifically to extract the most relevant information.
 *
 * The summary is:
 * - Short (typically under 200 chars)
 * - Redacted (no sensitive data)
 * - Useful for understanding what happened
 *
 * @param toolName - The name of the tool
 * @param toolInput - The full tool input object
 * @returns A summary string for the log
 */
function summarizeToolInput(toolName: string, toolInput: Record<string, unknown>): string {
  switch (toolName) {
    // Bash: Log the command (truncated and redacted)
    case "Bash": {
      const cmd = toolInput.command as string | undefined;
      if (!cmd) return "(no command)";
      // Truncate long commands to prevent log bloat
      const truncated = cmd.slice(0, MAX_COMMAND_SUMMARY_LENGTH);
      const suffix = cmd.length > MAX_COMMAND_SUMMARY_LENGTH ? "..." : "";
      return redactSensitive(truncated + suffix);
    }

    // Write/Edit: Log the file path (most important info)
    case "Write":
    case "Edit": {
      const filePath = toolInput.file_path as string | undefined;
      return filePath ? `file: ${filePath}` : "(no file_path)";
    }

    // NotebookEdit: Log the notebook path
    case "NotebookEdit": {
      const notebookPath = toolInput.notebook_path as string | undefined;
      return notebookPath ? `notebook: ${notebookPath}` : "(no notebook_path)";
    }

    // Read: Log what file is being read
    case "Read": {
      const readPath = toolInput.file_path as string | undefined;
      return readPath ? `read: ${readPath}` : "(no file_path)";
    }

    // Glob: Log the pattern being searched
    case "Glob": {
      const pattern = toolInput.pattern as string | undefined;
      return pattern ? `pattern: ${pattern}` : "(no pattern)";
    }

    // Grep: Log the search pattern
    case "Grep": {
      const grepPattern = toolInput.pattern as string | undefined;
      return grepPattern ? `grep: ${grepPattern}` : "(no pattern)";
    }

    // Task: Log the task description
    case "Task": {
      const description = toolInput.description as string | undefined;
      return description ? `task: ${description}` : "(no description)";
    }

    // Unknown tools: List the input keys (helpful for debugging)
    default: {
      const keys = Object.keys(toolInput);
      return keys.length > 0 ? `keys: ${keys.join(", ")}` : "(empty input)";
    }
  }
}

// =============================================================================
// HASHING AND LOG FILE MANAGEMENT
// =============================================================================

/**
 * Create a hash of the full tool input for forensic correlation.
 *
 * This allows matching log entries to actual operations without storing
 * the full (potentially sensitive) input in the log.
 *
 * The hash is truncated to 16 hex chars (64 bits) which is sufficient
 * for correlation while keeping logs compact.
 *
 * @param toolInput - The full tool input object
 * @returns A prefixed hash string (e.g., "sha256:a1b2c3d4e5f6g7h8")
 */
function hashToolInput(toolInput: Record<string, unknown>): string {
  const json = JSON.stringify(toolInput);
  const hash = createHash("sha256").update(json).digest("hex");
  // Prefix with algorithm for future-proofing, truncate for readability
  return "sha256:" + hash.slice(0, 16);
}

/**
 * Get the path to today's log file.
 *
 * Log files are organized by date for easy rotation and searching.
 * Format: ~/.claude/guardrails-logs/YYYY-MM-DD.jsonl
 *
 * @returns The full path to today's log file
 */
function getLogPath(): string {
  const date = new Date().toISOString().split("T")[0]; // YYYY-MM-DD
  return `${LOG_DIRECTORY}/${date}.jsonl`;
}

// =============================================================================
// MAIN ENTRY POINT
// =============================================================================

/**
 * Main function - logs the tool call and always allows it to proceed.
 *
 * Flow:
 * 1. Parse input from stdin (silently fail if unable)
 * 2. Create log directory if needed
 * 3. Build audit entry with summary and hash
 * 4. Append entry to today's log file
 * 5. Always exit 0 (allow) regardless of any errors
 *
 * This hook is designed to be invisible to the user - it should never
 * cause any delays or errors in their workflow.
 */
async function main() {
  try {
    // Parse the JSON input from stdin
    const stdin = await Bun.stdin.text();
    const input: HookInput = JSON.parse(stdin);

    const { tool_name, tool_input, cwd, session_id } = input;

    // Ensure log directory exists
    // Using recursive: true so it works even if parent dirs don't exist
    if (!existsSync(LOG_DIRECTORY)) {
      mkdirSync(LOG_DIRECTORY, { recursive: true });
    }

    // Build the audit entry
    const entry: AuditEntry = {
      timestamp: new Date().toISOString(),
      session_id: session_id || "unknown",
      tool_name,
      tool_input_summary: summarizeToolInput(tool_name, tool_input || {}),
      tool_input_hash: hashToolInput(tool_input || {}),
      cwd: cwd || "unknown",
    };

    // Write to today's log file
    // Using appendFileSync for atomic writes (no async race conditions)
    const logPath = getLogPath();
    appendFileSync(logPath, JSON.stringify(entry) + "\n");

  } catch {
    // Silently fail - logging should NEVER block operations
    // If we can't log, that's unfortunate but not critical
  }

  // ALWAYS allow the operation to proceed
  // This hook is for observability only, not enforcement
  process.exit(0);
}

// Run main (no catch needed - we silently fail inside main)
main();
