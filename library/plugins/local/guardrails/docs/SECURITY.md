# Security Documentation

This document explains the security model, threat assumptions, and design decisions behind claude-guardrails.

## Threat Model

### What This Protects Against

claude-guardrails is designed to protect against **accidental damage** from AI assistants, not sophisticated attacks.

#### Claude Making Honest Mistakes

AI assistants can misunderstand instructions or context:

- **Wrong path interpretation:** "Delete the old config" might target the wrong file
- **Overly broad operations:** "Clean up the project" might delete more than intended
- **Path confusion:** Similar directory names leading to operations in wrong locations
- **Misunderstood scope:** "Push these changes" when changes aren't ready

#### Runaway Autonomous Sessions

When Claude operates with extended autonomy:

- **Cascading errors:** One mistake leading to attempts to "fix" it, making things worse
- **Scope creep:** Operations expanding beyond the intended task
- **Lost context:** Long sessions where original constraints are forgotten
- **Unexpected side effects:** Changes that seem logical but have unintended consequences

#### Accidental Data Loss

Common scenarios that can destroy work:

- **Accidental file deletion:** `rm` with wrong path or flags
- **Overwriting git history:** Force push that destroys commits
- **Overwriting files:** Write to wrong file path
- **Credential exposure:** Accidentally committing secrets

### What This Does NOT Protect Against

Be aware of these limitations:

#### Sophisticated Adversarial Attacks

If someone crafts prompts specifically designed to evade detection:

- Complex command obfuscation
- Multi-step attacks that individually appear safe
- Exploiting race conditions or timing windows
- Social engineering through the AI

#### Malicious Code Within Project Files

The hooks examine Claude's actions, not file contents:

- A malicious script in your project could be executed
- Trojan code could be introduced through dependencies
- Existing malware in your system is not detected

#### Supply Chain Attacks

Dependencies are not validated:

- npm/pip/cargo packages could contain malware
- Compromised build tools
- Malicious container images

#### Operations Within the Safe Envelope

Operations that stay within allowed boundaries:

- Deleting files within the working directory
- Making incorrect code changes
- Breaking functionality without touching protected resources
- Reading sensitive files (hooks only protect writes)

## Defense in Depth

claude-guardrails is ONE layer in your security strategy. Consider these additional protections:

### Git Branches for All Work

```bash
# Always work on feature branches
git checkout -b feature/new-work

# Never work directly on main
```

Benefits:
- Easy to discard unwanted changes
- Protected branches remain clean
- Review before merging

### Regular Commits

Ask Claude to commit frequently:

> "Commit after each significant change with a descriptive message"

Benefits:
- Easy rollback points
- Change history for debugging
- Prevents loss of work in progress

### Time Machine or Other Backup

Enable continuous backup:

- **macOS:** Time Machine with hourly backups
- **Linux:** Timeshift, restic, or borgbackup
- **Cloud:** Backblaze, Arq, or similar

Benefits:
- Recovery from catastrophic mistakes
- Point-in-time restoration
- Protection against disk failure

### Container/VM Isolation

For high-risk work:

```bash
# Use Docker for isolated environments
docker run -it --rm -v $(pwd):/work ubuntu bash

# Or lightweight VMs like Lima
limactl start default
```

Benefits:
- Complete isolation from host system
- Easy to destroy and recreate
- Prevents any escape from sandbox

## Why Fail-Closed?

claude-guardrails implements a **fail-closed** security model: if a hook crashes or encounters an unexpected error, the operation is **blocked** rather than allowed.

### The Alternative: Fail-Open

A fail-open system would allow operations when hooks fail. Problems:

- Hook bugs become security vulnerabilities
- Crash = bypass protection
- Attacker could potentially trigger crashes to bypass checks

### Why Fail-Closed is Better

- Hook bugs become availability issues, not security issues
- Crashes prevent potentially dangerous operations
- Incentivizes fixing hook issues quickly
- Users can explicitly override if needed

### The Tradeoff

Fail-closed can block legitimate operations due to:

- Timeout (slow filesystem, network)
- Parse errors (unusual input)
- Unexpected edge cases

This is an acceptable tradeoff: a momentarily blocked operation is inconvenient, but accidental data destruction is permanent.

## Why Not Just Use settings.json Deny Rules?

Claude Code's built-in `settings.json` supports deny rules with prefix matching:

```json
{
  "permissions": {
    "deny": [
      "Bash(rm -rf /)"
    ]
  }
}
```

### Limitations of Prefix Matching

**Flag reordering:**
```bash
rm -rf /     # Blocked
rm -r -f /   # Different flag arrangement - might not match
rm -fr /     # Combined flags - might not match
```

**Shell wrappers:**
```bash
bash -c 'rm -rf /'      # Wrapped in bash -c
sh -c "rm -rf /"        # Wrapped in sh -c
eval 'rm -rf /'         # Using eval
```

**Interpreter one-liners:**
```bash
python -c 'import os; os.system("rm -rf /")'
node -e 'require("child_process").execSync("rm -rf /")'
ruby -e '`rm -rf /`'
```

**Encoding and escaping:**
```bash
rm -rf $(echo "Lwo=" | base64 -d)  # Encoded path
rm -rf /$(printf '\x00')           # Null bytes
```

### How Guardrails Addresses This

The git-guardian hook:

1. **Extracts** git commands from shell wrappers
2. **Parses** git push specifically to understand intent
3. **Identifies** force flags regardless of position
4. **Handles** chained commands (&&, ||, ;)

The path-guardian hook:

1. **Resolves** the actual target path
2. **Follows** symlinks to find the real destination
3. **Normalizes** paths to catch traversal attempts
4. **Validates** against known-bad patterns

## Sensitive Path Protection

These paths are **always blocked** and cannot be overridden:

### ~/.ssh - Authentication Keys

Contains:
- Private keys for server authentication
- `authorized_keys` for incoming access
- `known_hosts` fingerprint database
- SSH config with host aliases

Risk: Compromise allows impersonation, lateral movement, persistent access.

### ~/.aws - Cloud Credentials

Contains:
- Access keys for AWS services
- Secret access keys
- Session tokens
- Configuration files

Risk: Compromise allows cloud resource access, data exfiltration, resource abuse (crypto mining), significant financial impact.

### ~/.gnupg - Encryption Keys

Contains:
- GPG private keys
- Trust database
- Key revocation certificates

Risk: Compromise allows decryption of encrypted data, forgery of signatures, identity theft.

### ~/.claude/* - Guardrails Self-Protection

Contains:
- `settings.json` - Hook configuration
- `hooks/` - Hook implementations
- `guardrails-overrides.json` - Override rules

Risk: An AI that can modify its own guardrails can disable all protections.

### System Directories

- `/etc` - System configuration
- `/usr` - System programs
- `/bin`, `/sbin` - Essential binaries
- `/System`, `/Library` - macOS system files

Risk: System instability, privilege escalation vectors, boot failure.

## Override Security

The override file (`~/.claude/guardrails-overrides.json`) provides a safe way to customize protection without compromising security.

### Why Overrides Are Safe

**Location is protected:**
The override file is in `~/.claude/`, which is:
- Outside typical project working directories
- Not writable through normal Claude Code operations
- Explicitly listed in `ALWAYS_BLOCKED_PATTERNS`

**Self-modification prevented:**
path-guardian explicitly blocks writes to:
```typescript
`${homedir()}/.claude/guardrails-overrides.json`,
`${homedir()}/.claude/hooks`,
`${homedir()}/.claude/settings.json`,
```

**Requires human action:**
To modify overrides, you must:
1. Use an editor outside Claude Code, OR
2. Explicitly acknowledge and bypass the block

**Fail-closed on parse error:**
If the override file is malformed:
- JSON parse fails
- Empty overrides are used
- Protection remains in effect

### Override Best Practices

1. **Be specific:** Use precise paths, not broad wildcards
2. **Document why:** Add comments explaining each override
3. **Review periodically:** Remove overrides no longer needed
4. **Version control:** Consider tracking overrides in your dotfiles

## Audit Trail

The audit-logger provides accountability and forensics:

### What's Logged

- Timestamp (UTC)
- Session ID
- Tool name
- Summarized input (redacted)
- Input hash (for correlation)
- Working directory

### What's NOT Logged

- Full file contents
- Credentials or secrets (redacted)
- Raw command arguments beyond summary
- Read operations (optional future feature)

### Log Security

- Stored locally in `~/.claude/guardrails-logs/`
- Daily rotation prevents single large files
- Hash allows correlation without storing sensitive data
- Automatic redaction of common secret patterns

## Reporting Security Issues

If you discover a security vulnerability in claude-guardrails:

1. **Do not** open a public issue
2. **Do not** discuss publicly until fixed
3. **Do** email the maintainers privately with:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact assessment
   - Any suggested fixes

We aim to:
- Acknowledge reports within 48 hours
- Provide an initial assessment within 7 days
- Release fixes for critical issues within 30 days
- Credit reporters (unless anonymity requested)

## Security Checklist

Use this checklist to verify your setup:

- [ ] Hooks are loading (restart Claude Code after installation)
- [ ] `guardrails test` passes
- [ ] Override file is minimal and documented
- [ ] Audit logs are being written
- [ ] Git branches are used for all work
- [ ] Regular commits are made during sessions
- [ ] Backup solution is active (Time Machine, etc.)
- [ ] Sensitive credentials are not in working directories
