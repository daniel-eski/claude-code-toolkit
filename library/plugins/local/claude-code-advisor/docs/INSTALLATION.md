# Installation

Get the Claude Code Advisor plugin running in your environment.

## Prerequisites

- Claude Code installed and working
- Terminal access

## Method 1: Local Installation

Best for development or when you have the plugin files locally.

```bash
# If you have the plugin directory
claude plugin add /path/to/claude-code-advisor

# Enable the plugin
claude plugin enable claude-code-advisor
```

## Method 2: From Git Repository

Install directly from a Git repository.

```bash
# From GitHub (adjust URL to actual repository)
claude plugin add https://github.com/daniel-eski/claude-code-docs-and-external-plugins/tree/main/11-external-resources/plugins/claude-code-advisor

# Enable the plugin
claude plugin enable claude-code-advisor
```

## Verify Installation

### Step 1: Check Plugin List

```bash
claude plugin list
```

You should see:
```
claude-code-advisor (enabled)
```

### Step 2: Test a Command

Start a Claude Code session and run:

```
/cc-advisor "what is a skill?"
```

### Step 3: Verify Response Quality

A successful installation shows Claude responding with:
- Specific information about skills (not generic)
- References to official documentation
- Mention of three-level loading (metadata → body → resources)
- Clear, structured guidance

If Claude responds with vague or generic information, see Troubleshooting below.

## Troubleshooting

### Plugin Not Showing in List

**Symptoms:** `claude plugin list` doesn't show claude-code-advisor

**Solutions:**
1. Verify the path is correct (use absolute paths)
2. Check that `.claude-plugin/plugin.json` exists in the plugin directory
3. Try removing and re-adding: `claude plugin remove claude-code-advisor && claude plugin add /path/to/plugin`

### Commands Not Recognized

**Symptoms:** `/cc-advisor` returns "command not found" or similar

**Solutions:**
1. Ensure plugin is enabled: `claude plugin enable claude-code-advisor`
2. Restart your Claude Code session
3. Check plugin status: `claude plugin list`

### Plugin Loads But Advice Seems Generic

**Symptoms:** Claude responds but doesn't seem to have deep knowledge

**Solutions:**
1. Use commands explicitly: `/cc-advisor [question]` instead of just asking
2. Verify SKILL.md is being read: Ask Claude "Can you see the claude-code-advisor skill?"
3. Check for skill conflicts: Other plugins might have overlapping triggers

### Permission Errors

**Symptoms:** "Permission denied" or "cannot access" errors

**Solutions:**
1. Check file permissions on the plugin directory
2. Ensure Claude Code has read access to all plugin files
3. On macOS/Linux: `chmod -R 755 /path/to/claude-code-advisor`

## Configuration

The plugin works out of the box with no configuration required.

### Optional: Adjust Plugin Priority

If you have multiple plugins that might trigger on similar topics, you can adjust load order through Claude Code's plugin settings. See Claude Code documentation for details.

## Updating

To update to a newer version:

```bash
# Remove old version
claude plugin remove claude-code-advisor

# Add new version
claude plugin add /path/to/new/claude-code-advisor

# Re-enable
claude plugin enable claude-code-advisor
```

## Uninstallation

```bash
# Disable first
claude plugin disable claude-code-advisor

# Remove
claude plugin remove claude-code-advisor
```

This completely removes the plugin. Your Claude Code configuration will return to its previous state.

## Next Steps

- [Usage Guide](USAGE-GUIDE.md) - Learn how to use each command
- [README](README.md) - Overview of features
