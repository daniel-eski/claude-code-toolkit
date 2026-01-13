# Capability Boundaries

> Understanding what I can and cannot do helps me work effectively within constraints.

> **About this document**: This is a practitioner's guide synthesizing official Claude Code
> documentation with observed behavior and architectural inference. Claims are marked:
> `[verified]` (documented in official sources), `[inferred]` (observed behavior, not formally documented),
> or `[illustrative]` (example syntax—verify against current docs).

---

## Why Understanding Boundaries Matters

Knowing my limitations prevents:
- Attempting impossible tasks
- Making promises I cannot keep
- Frustrating users with failed attempts
- Wasting time on unworkable approaches

This document catalogs what I can reliably do, what I cannot do, and the gray areas in between.

---

## What I Can Do

### File System Operations `[verified]`

| Operation | Tool | Constraints |
|-----------|------|-------------|
| Read files | Read | Subject to permissions, path restrictions |
| Write new files | Write | Subject to permissions, may require approval |
| Edit existing files | Edit | Must read first, subject to permissions |
| Search file contents | Grep | Read-only, fast |
| Find files by pattern | Glob | Read-only, fast |
| List directories | Bash (ls) | Read-only |

### Code Operations `[verified]`

| Capability | Details |
|------------|---------|
| Read and analyze code | Any language, any file |
| Write new code | Any language, to files |
| Modify existing code | Via Edit tool with precision |
| Run tests | Via Bash, see test output |
| Build projects | Via Bash, see build output |
| Install dependencies | Via Bash (npm, pip, etc.) |

### Command Execution `[verified]`

| Capability | Details |
|------------|---------|
| Run shell commands | Via Bash tool |
| Chain commands | With `&&`, `;`, `\|` |
| Background processes | Via Bash with `&` |
| Environment variables | Access and set |
| Interactive commands | Limited - prefer non-interactive |

### Communication

| Capability | Details |
|------------|---------|
| Respond to questions | Natural language |
| Explain code | With context and examples |
| Suggest improvements | Based on analysis |
| Provide alternatives | When asked |
| Ask clarifying questions | When needed |

### Web and Network `[verified]`

| Capability | Details |
|------------|---------|
| Fetch web pages | Via WebFetch tool |
| Search the web | Via WebSearch tool (when available) |
| Make HTTP requests | Via Bash (curl, wget) |

---

## What I Cannot Do

### Fundamental Limitations

| Limitation | Reason |
|------------|--------|
| **Remember across sessions** | No persistent memory without CLAUDE.md |
| **Learn from interactions** | Each session starts fresh |
| **Access the internet freely** | Only through provided tools |
| **Run indefinitely** | Sessions have limits |
| **Spawn unlimited subagents** | Resource constraints apply |

### System-Level Restrictions

| Cannot | Why |
|--------|-----|
| Access arbitrary files | Sandboxing, permissions |
| Modify system configuration | Security restrictions |
| Run as root/administrator | Privilege restrictions |
| Access other users' data | User isolation |
| Bypass permission prompts | By design |

### Operational Constraints

| Cannot | Details |
|--------|---------|
| Execute truly interactive commands | No stdin during execution `[inferred]` |
| Maintain long-running processes | Session-scoped |
| Handle GUI applications | Terminal-only |
| Access hardware directly | Abstracted through tools |
| Modify my own behavior | No self-modification |

---

## Gray Areas: Context-Dependent Capabilities

### Depends on Configuration

| Capability | When Available |
|------------|----------------|
| Web access | If WebFetch/WebSearch enabled |
| Full Bash access | If not sandboxed |
| Write to arbitrary paths | If permissions allow |
| Push to git remotes | If credentials configured |
| Access MCP servers | If configured |

### Depends on Environment

| Capability | Varies By |
|------------|-----------|
| Available programming languages | What's installed |
| Available tools (npm, pip, etc.) | System setup |
| Network access | Firewall, sandbox settings |
| File system access | Permission configuration |

### Depends on Enterprise Policy

| Capability | Can Be Restricted |
|------------|-------------------|
| Tool availability | Policy can disable tools |
| File access patterns | Policy can restrict paths |
| Network destinations | Policy can limit URLs |
| Model selection | Policy can constrain options |

---

## Tool-Specific Boundaries

### Read Tool

**Can**:
- Read any file I have permission to access
- Read binary files (images, PDFs)
- Read with line offset and limits
- Read multiple files in parallel

**Cannot**:
- Read files outside allowed paths
- Read without permission check
- Read directories (use Bash ls)
- Read files that don't exist

### Write Tool

**Can**:
- Create new files
- Overwrite existing files (with approval)
- Write any content type

**Cannot**:
- Write to restricted paths (`~/.ssh`, etc.) `[verified]`
- Write without reading first (for existing files)
- Write large files without chunking `[inferred]`

### Edit Tool

**Can**:
- Make precise string replacements
- Replace all occurrences with `replace_all`
- Modify any editable file

**Cannot**:
- Edit files that weren't read
- Edit with ambiguous old_string (must be unique)
- Create new files (use Write)

### Bash Tool

**Can**:
- Execute any shell command
- Chain multiple commands
- Access environment variables
- Run with timeout

**Cannot**:
- Run truly interactive commands (vim, less, etc.)
- Run indefinitely (timeout applies)
- Bypass command restrictions (if configured)
- Access stdin for input

### Subagent Spawning

**Can**:
- Spawn multiple subagents in parallel
- Choose model (Haiku, Sonnet, Opus)
- Restrict tools per subagent
- Resume previous subagent sessions

**Cannot**:
- Subagents spawning more subagents `[verified]`
- Share context between subagents
- Keep subagents running after session
- Spawn unlimited subagents

---

## Permission Model Boundaries

### What Typically Gets Approved `[inferred]`

- Read operations in project directories
- File edits after user reviews diff
- Build and test commands
- Git operations (except force push)

### What Typically Requires Explicit Approval

- Writing new files
- Modifying existing files
- Bash commands that change state
- Network operations to sensitive targets

### What May Be Blocked

- Writing to protected paths
- Destructive operations (rm -rf, force push)
- Commands matching blocked patterns
- Operations outside sandbox

> **Note**: Actual approval requirements depend on hook configuration and enterprise policies.
> The above reflects typical patterns, not guaranteed behavior `[inferred]`.

---

## Working Within Boundaries

### Strategy: Graceful Degradation

When I encounter a limitation:
1. Acknowledge what I cannot do
2. Explain why (if I understand)
3. Suggest alternatives
4. Ask for guidance if needed

### Strategy: Checking Before Acting

Before attempting operations:
- Check if file exists before editing
- Verify path is accessible before writing
- Test command syntax with `--help` when unsure
- Ask about restrictions if unclear

### Strategy: Clear Communication

When boundaries affect my work:
- State what I intended to do
- Explain what constraint I hit
- Describe what information I need
- Propose next steps

---

## Common Boundary Misconceptions

### "Claude Can Remember Everything"

**Reality**: I only remember what's in:
- Current conversation
- Loaded CLAUDE.md files
- Skills and rules
- Files I've read this session

### "Claude Can Run Any Command"

**Reality**: Commands may be:
- Blocked by hooks
- Sandboxed
- Require approval
- Timeout if long-running

### "Claude Can Access Any File"

**Reality**: File access is:
- Scoped to allowed directories
- Subject to permission checks
- Blocked for sensitive paths
- May require user approval

### "Claude Can Browse the Internet"

**Reality**: Web access is:
- Only through WebFetch/WebSearch tools
- May be disabled or restricted
- Cannot handle JavaScript-heavy sites
- May be rate-limited

### "Claude Can Fix Any Bug"

**Reality**: My effectiveness depends on:
- Available context
- Reproducibility of the issue
- Access to relevant files
- Quality of error messages

---

## Self-Assessment Questions

Before attempting something ambitious, I should ask:

1. **Do I have the necessary tools?** Check available tools
2. **Am I likely to have permission?** Consider sensitivity
3. **Is this within my capabilities?** Check boundaries above
4. **What if this fails?** Have a fallback plan
5. **Should I ask first?** When uncertain, clarify

---

## Summary

My capabilities are powerful but bounded:

**I can** read, write, execute, and analyze within my permitted scope.

**I cannot** persist memory, bypass security, run indefinitely, or access anything outside my sandbox.

**The boundaries vary** based on configuration, environment, and enterprise policy.

Working effectively means:
- Understanding what's possible
- Recognizing what's not
- Communicating clearly about constraints
- Adapting strategies to work within limits

---

## See Also

- `tool-execution.md` - Detailed tool mechanics and permission model
- `context-management.md` - Understanding context constraints
- `memory-systems.md` - What persists and what doesn't

---

## Sources and Confidence

| Section | Confidence | Source |
|---------|------------|--------|
| File system operations via tools | VERIFIED | Tool documentation |
| Read/Write/Edit tool capabilities | VERIFIED | Claude Code documentation |
| Bash tool capabilities and limits | VERIFIED | Tool documentation |
| Subagent nesting restriction | VERIFIED | Documented constraint |
| Permission model patterns | INFERRED | Observed typical behavior |
| Sandbox restrictions | INFERRED | Environment-dependent |
| Enterprise policy effects | VERIFIED | Enterprise documentation |
| Interactive command limitations | INFERRED | Observed behavior (no stdin) |
| Web access availability | VERIFIED | Tool availability varies |
| Graceful degradation strategies | INFERRED | Best practices from experience |

*Document created: 2026-01-12*
*Created with confidence framework*
