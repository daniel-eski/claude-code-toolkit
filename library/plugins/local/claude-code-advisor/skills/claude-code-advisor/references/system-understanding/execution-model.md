# Execution Model

Understanding how Claude Code executes helps design effective configurations.

## The Agentic Loop

Claude Code operates in a continuous loop:

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

Each iteration:
1. **Observe**: Read current context (conversation, files, outputs)
2. **Think**: Reason about what to do next
3. **Act**: Execute a tool call (Read, Write, Bash, etc.)

## Tool Invocation Flow

When Claude calls a tool, hooks can intercept at multiple points:

```
Claude decides to call tool
           │
           ▼
    ┌──────────────┐
    │ PreToolUse   │ ←── Can BLOCK, MODIFY, or ALLOW
    │ hooks        │
    └──────┬───────┘
           │
           ▼
    ┌──────────────┐
    │ Permission   │ ←── User approval (if required)
    │ Check        │     Can be auto-approved by hook
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
    │ PostToolUse  │ ←── Can provide feedback to Claude
    │ hooks        │
    └──────┬───────┘
           │
           ▼
    Result returned to Claude
```

## Hook Injection Points

| Event | When | Can Do |
|-------|------|--------|
| **PreToolUse** | Before tool runs | Block, modify inputs, auto-approve |
| **PermissionRequest** | At permission dialog | Allow/deny on user's behalf |
| **PostToolUse** | After tool completes | Add feedback, flag issues |
| **UserPromptSubmit** | User sends message | Add context, block prompt |
| **Stop** | Claude about to stop | Force continuation |
| **SubagentStop** | Subagent about to stop | Force continuation |
| **SessionStart** | Session begins | Add context, set env vars |
| **SessionEnd** | Session ends | Cleanup |

## Subagent Execution

Subagents run in isolated processes with their own context:

```
Main Conversation
       │
       │ Invokes subagent via Task tool
       ▼
┌─────────────────────────────────┐
│ SUBAGENT (isolated context)    │
│                                 │
│  • Fresh context window         │
│  • Pre-loaded skills (if any)   │
│  • Own tool permissions         │
│  • Cannot spawn other subagents │
│                                 │
│  Runs until complete            │
└─────────────────────────────────┘
       │
       │ Returns summary only
       ▼
Main Conversation continues
```

**Key points**:
- Subagents CANNOT spawn other subagents (main orchestrates)
- Subagents can be RESUMED with their previous context
- Information flows IN via prompt, OUT via return value only

## Session Lifecycle

```
claude (start)
    │
    ├── SessionStart hooks run
    │   └── Can add context, set environment
    │
    ├── CLAUDE.md + skills loaded
    │
    ├── User interaction loop
    │   ├── UserPromptSubmit hooks
    │   ├── Tool calls (Pre/Post hooks)
    │   └── Repeat
    │
    ├── Stop hooks (can force continuation)
    │
    └── SessionEnd hooks
        └── Cleanup tasks
```

## Design Implications

1. **Hooks are lightweight**: Keep hook logic simple; spawn subagent for complex work
2. **PreToolUse for guardrails**: Block dangerous commands, enforce patterns
3. **PostToolUse for feedback**: Auto-lint, format, or flag issues
4. **Stop hooks carefully**: Prevent infinite loops with stop_hook_active check
5. **SessionStart for setup**: Load project context, install dependencies

See also:
- `context-architecture.md` for how context is managed
- `../feature-mechanics/hooks-deep-dive.md` for hook implementation details
