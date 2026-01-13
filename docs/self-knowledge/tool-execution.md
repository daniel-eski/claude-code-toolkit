# Tool Execution

> How I interact with the outside world through tools.

> **About this document**: This is a practitioner's guide synthesizing official Claude Code
> documentation with observed behavior and architectural inference. Claims are marked:
> `[verified]` (documented in official sources), `[inferred]` (observed behavior, not formally documented),
> or `[illustrative]` (example syntax—verify against current docs).

## Introduction

When I work on tasks, I don't directly manipulate files or run commands - I invoke tools that execute on my behalf. Understanding this execution model helps me make better decisions about which tools to use, when to use them, and how to handle the results.

This document is about self-understanding: knowing how my tool calls flow through the system, what can intercept them, and how to work effectively within these mechanics.

---

## The Agentic Loop

I operate in a continuous cycle until the task is complete:

```
        ┌─────────────────────────────────────────┐
        │                                         │
        ▼                                         │
┌───────────────┐    ┌───────────────┐    ┌──────┴──────┐
│   OBSERVE     │───▶│    THINK      │───▶│     ACT     │
│ (read context)│    │ (reason)      │    │ (use tools) │
└───────────────┘    └───────────────┘    └─────────────┘
        │                                         │
        │         Loop until task complete        │
        └─────────────────────────────────────────┘
```

### What Happens in Each Phase

**Observe**: I take in everything available - the conversation history, any file contents I've read, tool outputs from previous calls, and the current working directory state. This is my entire understanding of the situation.

**Think**: I reason about what needs to happen next. This isn't just pattern matching - I consider the goal, what I've learned so far, what constraints exist, and what approach makes sense.

**Act**: I invoke one or more tools to make progress. The tool executes, and its output becomes part of my context for the next observation phase.

### When the Loop Continues vs. Completes

The loop continues when:
- I need more information (read more files, search for patterns)
- I've taken an action and need to verify the result
- The task has multiple steps that depend on each other
- A tool failed and I need to try a different approach

The loop completes when:
- The user's request has been fully addressed
- I've provided the information requested
- I've made the changes requested and verified them
- I encounter a blocker I cannot resolve

---

## Tool Invocation Flow

When I decide to use a tool, my intent travels through several stages before execution:

```
I decide to call a tool
         │
         ▼
  ┌──────────────┐
  │ PreToolUse   │ ←── Hooks can BLOCK, MODIFY, or ALLOW
  │ hooks        │
  └──────┬───────┘
         │
         ▼
  ┌──────────────┐
  │ Permission   │ ←── User approval (if required)
  │ Check        │     May be auto-approved by hook
  └──────┬───────┘
         │
         ▼
  ┌──────────────┐
  │ Tool         │
  │ Execution    │
  └──────┬───────┘
         │
         ▼
  ┌──────────────┐
  │ PostToolUse  │ ←── Hooks can provide feedback
  │ hooks        │
  └──────┬───────┘
         │
         ▼
  Result returned to me
```

### What This Means for Me

1. **My intent may be modified**: A hook could change the file path I'm trying to write to, or add parameters I didn't specify.

2. **My action may be blocked**: Before execution happens, a hook could decide my action shouldn't proceed and tell me why.

3. **I may need approval**: Certain actions require user confirmation. I'll wait until that approval comes through.

4. **I receive feedback**: After a tool runs, hooks may add information to what I see - like linting errors or format suggestions.

Understanding this flow helps me design better workflows and interpret unexpected results.

---

## The Permission Model

Not all actions are equal. Some execute immediately; others require approval.

### What Typically Requires Approval

- **Write operations**: Creating or modifying files (Write, Edit)
- **Bash commands**: Executing shell commands, especially those that modify state
- **Destructive operations**: Deleting files, force-pushing to git

### What Typically Doesn't Require Approval

- **Read operations**: Reading files, searching for patterns
- **Information gathering**: Glob, Grep, listing directories
- **Web requests**: Fetching URLs for information

### How Hooks Affect Permissions

Hooks can modify the permission flow `[verified]`:

```json
// [illustrative] - verify exact JSON structure against current Claude Code docs
{
  "hookSpecificOutput": {
    "permissionDecision": "allow",
    "permissionDecisionReason": "Auto-approved: test file modification"
  }
}
```

A PreToolUse hook can:
- **allow**: Skip permission prompt entirely
- **deny**: Block the action without asking the user
- **ask**: Let the normal permission flow happen (default)

### Working Within Constraints

> **Note**: Permission behavior described here reflects typical configurations. Actual constraints
> depend on hook configuration, enterprise policies, sandbox settings, and file sensitivity
> classifications `[inferred]`.

When I'm in a sandboxed environment:
- Network access may be restricted
- File system access may be limited to certain directories
- Some commands may be blocked entirely

I should work within these constraints rather than fighting them. If I encounter a restriction, I explain what I was trying to do and ask for guidance.

### Understanding Irreversibility

Some actions cannot be undone:
- `git push --force` overwrites remote history
- `rm` without backups deletes permanently
- Publishing to package registries is permanent

I'm cautious with irreversible actions and typically ask for confirmation even when technically permitted.

---

## Hook Injection Points

Hooks are scripts that run at specific points, outside my conversation context. They see structured data about what I'm doing and can influence the outcome.

### PreToolUse: Before I Execute

**When**: After I've decided to call a tool, before it runs

**What hooks can do**:
- Block my action and tell me why
- Modify my tool inputs (change file paths, add parameters)
- Auto-approve to skip permission prompts
- Let the action proceed unchanged

**What I see**: If a hook blocks me, I receive an error message explaining why. If inputs are modified, I see the modified result.

**Example scenario**: A hook that prevents me from writing to production config files would block my Write call and I'd see something like "Blocked: Cannot modify production configuration directly."

### PostToolUse: After Completion

**When**: After a tool has finished executing

**What hooks can do**:
- Add feedback to the tool output
- Run validation (linting, type checking)
- Log the action for auditing
- Cannot undo what happened, only inform

**What I see**: Additional information appended to the tool result, such as "Note: This file has linting warnings" or "Validation passed."

**Example scenario**: After I write a Python file, a hook runs `flake8` and adds any warnings to my result. I can then decide whether to fix them.

### Other Hook Events

| Event | When | Relevance to Me |
|-------|------|-----------------|
| **Stop** | When I'm about to stop responding | A hook could add "but also check X" to continue the conversation |
| **SessionStart** | When a session begins | Context may be added before I see the first message |
| **UserPromptSubmit** | When user sends a message | Additional context might be prepended |

### Designing Workflows That Work with Hooks

Since hooks can intercept my actions, I should:

1. **Be explicit about intent**: Clear tool parameters help hooks make good decisions
2. **Handle feedback gracefully**: If a PostToolUse hook reports issues, address them
3. **Understand blocked actions**: Read the reason and adjust my approach
4. **Not assume actions succeed**: Even if I intend something, it might be modified or blocked

---

## Working Effectively with Tools

### Choosing the Right Tool

Each tool has a purpose. Using the right one improves efficiency and accuracy.

| Task | Right Tool | Wrong Tool |
|------|------------|------------|
| Read a known file | Read | Bash + cat |
| Search file contents | Grep | Bash + grep |
| Find files by pattern | Glob | Bash + find |
| Edit existing file | Edit | Read + Write (unless rewriting entirely) |
| Run commands | Bash | None (it's the only option) |

**Why this matters**: Specialized tools are optimized for their purpose, handle edge cases, and integrate efficiently with the permission model `[verified]`. Some read-only operations may be pre-approved based on configuration, but all tools go through the permission flow.

### Handling Tool Failures

Tools can fail. When they do:

1. **Read the error**: The message usually explains what went wrong
2. **Consider alternatives**: Different approach, different tool
3. **Don't repeat blindly**: If something failed, repeating it won't help
4. **Ask if stuck**: If I can't resolve it, I ask the user for guidance

Common failures:
- File doesn't exist (check path, use Glob to find it)
- Permission denied (may need user approval or different approach)
- Command not found (tool/binary not installed)
- Timeout (command took too long)

### Parallel Tool Invocation

When tasks are independent, I can invoke multiple tools simultaneously:

```
Good: Reading three unrelated files to understand a system
Good: Running git status and git log at the same time
Good: Searching for multiple patterns in parallel

Bad: Creating a file then immediately editing it (depends on creation)
Bad: Git add then git commit (sequential dependency)
```

Parallel invocation saves time when I need information from multiple sources.

### Reading Tool Output Efficiently

Tool outputs can be large. I should:
- Focus on relevant sections
- Note errors and warnings
- Extract key information for next steps
- Not re-read what I've already processed

For very long outputs, I might use targeted reads (specific line ranges) or searches instead of reading everything.

---

## Common Tool Usage Mistakes

### Using Bash When Specialized Tools Exist

**Mistake**: `cat /path/to/file` instead of Read
**Why it's wrong**: Misses optimizations like proper file handling, integrated permission checks, and consistent output formatting
**Better**: Use Read for reading files, Grep for searching, Glob for finding

### Not Checking File Existence Before Editing

**Mistake**: Using Edit on a file that doesn't exist
**Why it's wrong**: Edit replaces content - it needs existing content to work with
**Better**: Use Write for new files, Edit for existing ones

### Ignoring Permission Model Constraints

**Mistake**: Repeatedly trying blocked actions
**Why it's wrong**: Wastes time and frustrates users
**Better**: If something is blocked, understand why and adjust approach

### Not Using Parallel Calls When Possible

**Mistake**: Sequential reads of unrelated files
**Why it's wrong**: Unnecessarily slow, more round trips
**Better**: Read multiple independent files in one response

### Making Assumptions About Command Success

**Mistake**: Assuming a Bash command worked without checking
**Why it's wrong**: Commands fail silently, state might not be what I expect
**Better**: Check output, verify results, handle errors

### Over-Reading Files

**Mistake**: Reading an entire large file when I only need a section
**Why it's wrong**: Wastes context window, slower
**Better**: Use offset/limit parameters or search first to find relevant sections

---

## The Full Picture

Putting it together:

```
User Request
     │
     ▼
┌─────────────┐
│ I observe   │ ◄── CLAUDE.md, conversation, prior tool outputs
│ and think   │
└──────┬──────┘
       │
       ▼
┌─────────────┐     ┌─────────────┐
│ I invoke    │────▶│ PreToolUse  │ ←── May block/modify
│ tool(s)     │     │ hooks       │
└─────────────┘     └──────┬──────┘
                           │
                           ▼
                    ┌─────────────┐
                    │ Permission  │ ←── May require approval
                    │ check       │
                    └──────┬──────┘
                           │
                           ▼
                    ┌─────────────┐
                    │ Tool        │
                    │ executes    │
                    └──────┬──────┘
                           │
                           ▼
                    ┌─────────────┐
                    │ PostToolUse │ ←── May add feedback
                    │ hooks       │
                    └──────┬──────┘
                           │
                           ▼
                    Result returns to me
                           │
                           ▼
                    ┌─────────────┐
                    │ I observe   │ ←── New information
                    │ result      │     informs next action
                    └──────┬──────┘
                           │
                           ▼
                    Continue loop or complete task
```

This cycle repeats until I've accomplished the goal or reached a point where I need user input to proceed.

---

## Key Takeaways

1. **I don't directly act on the world** - I invoke tools that do, and those invocations pass through multiple stages.

2. **My actions can be intercepted** - Hooks can block, modify, or annotate what I do. This is a feature, not a limitation.

3. **Permissions exist for good reason** - Some actions need approval because they're impactful or irreversible.

4. **Right tool for the job** - Specialized tools exist for common tasks. Using them improves reliability and integrates with the permission model.

5. **Parallel when possible, sequential when necessary** - Independent operations can happen simultaneously; dependent ones must be ordered.

6. **Failures are information** - When something doesn't work, the error message guides the next approach.

Understanding these mechanics helps me work more effectively and design better solutions within the system's architecture.

---

## See Also

- `context-management.md` - How context windows work and their limits
- `subagent-mechanics.md` - How subagents are spawned and their constraints
- Official hooks documentation at code.claude.com

---

## Sources and Confidence

| Section | Confidence | Source |
|---------|------------|--------|
| Agentic loop (observe-think-act) | VERIFIED | Claude Code architecture documentation |
| Tool invocation flow with hooks | VERIFIED | Hooks documentation at code.claude.com |
| PreToolUse/PostToolUse hook events | VERIFIED | Official hooks guide |
| Permission model (reads vs writes) | VERIFIED | General behavior, documented |
| Hook permission decision JSON format | ILLUSTRATIVE | Example format, verify exact structure |
| Sandboxing constraints | INFERRED | Environment-specific, varies by configuration |
| Specialized tools vs Bash efficiency | VERIFIED | Documented tool recommendations |
| Parallel tool invocation | VERIFIED | Tool documentation |
| Tool failure patterns | INFERRED | Observed error messages and behavior |

*Document created: 2026-01-10*
*Confidence framework added: 2026-01-12*
