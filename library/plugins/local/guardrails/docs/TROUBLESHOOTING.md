# Troubleshooting Guide

This guide helps diagnose and resolve common issues with claude-guardrails.

## Hooks Not Loading

### Restart Claude Code

Hooks are loaded when Claude Code starts a session. After installing or modifying hooks:

1. Close Claude Code completely
2. Reopen Claude Code
3. Start a new conversation

### Check settings.json Syntax

Invalid JSON in settings.json prevents hooks from loading:

```bash
cat ~/.claude/settings.json | jq .
```

If this shows an error, your settings.json has a syntax problem. Common issues:

- Trailing commas after the last item in arrays/objects
- Missing commas between items
- Unquoted strings
- Mismatched brackets

### Verify Bun Installation

The hooks require Bun to run. Check if it's installed:

```bash
~/.bun/bin/bun --version
```

If this fails, install Bun:

```bash
curl -fsSL https://bun.sh/install | bash
```

After installation, you may need to restart your terminal or run:

```bash
source ~/.bashrc  # or ~/.zshrc
```

### Check Hook File Permissions

The hook files must be readable:

```bash
ls -la ~/.claude/hooks/
```

All `.ts` files should have read permissions (`r--` for user). Fix if needed:

```bash
chmod 644 ~/.claude/hooks/*.ts
```

### Verify Hook Registration

Check that hooks are properly registered in settings.json:

```bash
cat ~/.claude/settings.json | jq '.hooks'
```

You should see `PreToolUse` entries for the guardrails hooks.

## Hooks Not Blocking as Expected

### Run Manual Test

Use the built-in test command to verify hooks are working:

```bash
guardrails test
```

This runs a series of test cases against each hook and reports results.

### Check Override File for Exceptions

Your override file may be allowing operations you expect to be blocked:

```bash
cat ~/.claude/guardrails-overrides.json | jq .
```

Review each entry:
- `allowed_paths` - Are glob patterns too broad?
- `allowed_commands` - Is the exact command listed?
- `allowed_branches` - Is the branch pattern matching?

### Verify Path Resolution

Path-guardian resolves symlinks and normalizes paths. A path you think should be blocked might resolve differently:

```bash
# Check what a path resolves to
readlink -f /path/to/check

# Check symlink targets
ls -la /suspicious/path
```

Common issues:
- Symlinks in the path that resolve outside blocked zones
- Tilde (`~`) expansion differences
- Relative vs absolute path handling

### Check for claude-code-safety-net Conflicts

Claude Code has a built-in safety system called `claude-code-safety-net` that may block operations before your hooks run. Check if operations are being blocked by:

1. The built-in safety-net (different error message format)
2. Your guardrails hooks (message starts with "BLOCKED by path-guardian:" or "BLOCKED by git-guardian:")

The safety-net and guardrails are complementary - both may block the same operation.

## Too Many False Positives

### Add Specific Path Overrides

Instead of disabling protection globally, add specific paths to your overrides:

```json
{
  "allowed_paths": [
    "~/specific/project/path/**"
  ]
}
```

This is safer than removing items from `ALWAYS_BLOCKED_PATTERNS`.

### Review Audit Logs

Check what's actually being blocked:

```bash
# See recent blocks (look for operations that failed)
cat ~/.claude/guardrails-logs/$(date +%Y-%m-%d).jsonl | jq 'select(.tool_name == "Write" or .tool_name == "Edit")'
```

### Consider Path Specificity

Overly broad blocked patterns can cause false positives. For example, blocking `/opt` would block all of `/opt/myapp/safe/file.txt`. Consider using more specific paths.

## Audit Logs Not Appearing

### Check Directory Exists

```bash
ls -la ~/.claude/guardrails-logs/
```

If the directory doesn't exist, create it:

```bash
mkdir -p ~/.claude/guardrails-logs
```

### Check File Permissions

The log directory must be writable:

```bash
ls -ld ~/.claude/guardrails-logs/
```

Should show `drwx` (read/write/execute) for your user. Fix if needed:

```bash
chmod 755 ~/.claude/guardrails-logs
```

### Note: Logs Use UTC Dates

Log files are named using UTC dates, not your local timezone. If it's January 15th at 11pm in your timezone, the log might be in `2024-01-16.jsonl` (already the 16th in UTC).

To find today's log accounting for timezone:

```bash
# List recent log files
ls -lt ~/.claude/guardrails-logs/*.jsonl | head -5
```

### Audit Logger Never Blocks

The audit-logger is designed to silently fail. If logging fails, it won't produce any error message - operations simply won't be logged. Check:

1. Disk space: `df -h ~`
2. File handle limits: Too many open files can prevent writes
3. Directory permissions (see above)

## Performance Issues

### Hook Timeouts

If operations are being incorrectly blocked due to timeouts, increase the timeout values in `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit|NotebookEdit",
        "hooks": [
          {
            "type": "command",
            "command": "~/.bun/bin/bun run ~/.claude/hooks/path-guardian.ts",
            "timeout": 5000
          }
        ]
      }
    ]
  }
}
```

Default timeouts:
- path-guardian: 2000ms (2 seconds)
- git-guardian: 2000ms (2 seconds)
- audit-logger: 1000ms (1 second)

Maximum recommended: 10000ms (10 seconds)

### Check Bun Installation

Slow hook execution is often due to Bun issues:

```bash
# Time a simple Bun operation
time ~/.bun/bin/bun --version
```

This should complete in under 100ms. If slow:

1. Reinstall Bun: `curl -fsSL https://bun.sh/install | bash`
2. Check for antivirus interference
3. Ensure Bun isn't being loaded from a network drive

### Audit Logger Performance

The audit-logger is designed to be non-blocking:
- Uses synchronous writes (atomic, no race conditions)
- Minimal processing (summary + hash only)
- Fails silently on error

If audit logging seems slow, check disk I/O:

```bash
# Check disk activity
iostat -x 1 5
```

## Common Error Messages

### "Path is outside working directory"

**What it means:** You tried to write to a path that's not within Claude Code's current working directory.

**Resolution options:**

1. Change to the correct working directory before the operation
2. Add the path to `allowed_paths` in your override file:

```json
{
  "allowed_paths": [
    "/path/to/directory/**"
  ]
}
```

### "Push to protected branch"

**What it means:** You tried to push directly to a branch like `main`, `master`, `production`, or `prod`.

**Resolution options:**

1. Push to a feature branch instead:
   ```bash
   git push origin feature-branch
   ```

2. Create a pull request for the changes

3. Add the branch to `allowed_branches` if direct pushes are intended:
   ```json
   {
     "allowed_branches": ["main"]
   }
   ```

### "Force push blocked"

**What it means:** You used `git push --force` or `git push -f`, which can overwrite remote history.

**Resolution options:**

1. Use `--force-with-lease` instead (safer):
   ```bash
   git push --force-with-lease origin branch-name
   ```
   This checks that the remote hasn't changed since your last fetch.

2. If you must force push, add the specific command to overrides:
   ```json
   {
     "allowed_commands": [
       "git push --force origin specific-branch"
     ]
   }
   ```

### "Path matches always-blocked pattern"

**What it means:** The target path is in a protected location like `~/.ssh`, `~/.aws`, or system directories.

**Resolution:** These paths cannot be overridden - they're protected for security reasons. If you need to modify these files, do so outside of Claude Code.

### "Failed to parse hook input (fail-closed)"

**What it means:** The hook received invalid JSON input from Claude Code.

**Resolution:** This usually indicates a Claude Code internal issue. Try:
1. Restart Claude Code
2. Update Claude Code to the latest version
3. Report the issue if it persists

### "Unexpected error (fail-closed)"

**What it means:** The hook crashed due to an unexpected error.

**Resolution:**
1. Check that Bun is properly installed
2. Verify hook files aren't corrupted: `cat ~/.claude/hooks/*.ts`
3. Check for permission issues on hook files
4. Review recent changes to hook configurations

## Getting Help

If you're still experiencing issues:

1. **Check the audit logs** for patterns in blocked operations
2. **Run `guardrails test`** to verify hook functionality
3. **Review your overrides** for unintended exceptions
4. **Open an issue** with:
   - Your `settings.json` (remove sensitive paths)
   - Your `guardrails-overrides.json`
   - The error message
   - Steps to reproduce
