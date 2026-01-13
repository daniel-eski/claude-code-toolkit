# Subagent Mechanics

> Understanding how I spawn, orchestrate, and coordinate with other instances of myself.

> **About this document**: This is a practitioner's guide synthesizing official Claude Code
> documentation with observed behavior and architectural inference. Claims are marked:
> `[verified]` (documented in official sources), `[inferred]` (observed behavior, not formally documented),
> or `[illustrative]` (example syntax—verify against current docs).

---

## What Subagents Are to Me

When I spawn a subagent, I'm creating another instance of Claude that operates in complete isolation from my current conversation. This isn't like calling a function or running a script - it's dispatching another AI with its own fresh context window to handle work independently.

### The Relationship

```
ME (Main Conversation)              SUBAGENT (Isolated Instance)
┌─────────────────────────┐        ┌─────────────────────────┐
│ Full conversation       │        │ FRESH context           │
│ history                 │        │ - No memory of our      │
│                         │        │   conversation          │
│ All loaded skills       │   ──   │ - Only what I pass      │
│ and memory              │  IN    │   in the prompt         │
│                         │   ─▶   │ - Must pre-load skills  │
│ User's context and      │        │                         │
│ preferences             │        │ Dedicated task focus    │
│                         │  ◀──   │                         │
│ Continue with summary   │  OUT   │ Work stays here         │
│ only                    │   ─    │ (unless resumed)        │
└─────────────────────────┘        └─────────────────────────┘
```

**Key insight**: I am the orchestrator. Subagents are specialists I dispatch. They don't know about each other, don't share context with each other, and can only communicate back to me through summaries.

### Information Flow

What goes IN:
- My prompt (the task description I craft)
- Pre-loaded skills (specified in agent configuration)
- Tool access permissions
- Any context I explicitly include

What comes BACK:
- A summary of work completed
- Key findings or results
- An agent ID (for potential resumption)

What stays ISOLATED:
- All the files they read
- All the reasoning they did
- All the intermediate steps
- The full context of their work

This isolation is the point. Their heavy processing doesn't consume my context window.

---

## When I Should Spawn Subagents

### Context Isolation Needs

The primary reason to use a subagent: protecting my main context from pollution.

**Spawn when**:
- Research requires reading many files (dozens of file reads = context bloat)
- Deep codebase exploration (grep results, dependency chains)
- Comprehensive analysis that generates lots of intermediate data
- Work that would consume significant context but only needs a summary

**Don't spawn when**:
- I need the full details in my context for follow-up work
- The task is small enough that isolation provides no benefit
- The user wants to see my reasoning step-by-step

### Parallel Independent Tasks

When I have multiple independent tasks, I can dispatch subagents simultaneously.

```
ME
├── Spawn: security-reviewer → reviews auth module
├── Spawn: code-explorer → maps API endpoints
└── Spawn: test-analyzer → checks test coverage

[All three work in parallel]
[I synthesize their summaries]
```

**Good candidates for parallel dispatch**:
- Reviewing different modules independently
- Searching for different patterns across codebase
- Analyzing different aspects of the same code

**Not parallel candidates**:
- Sequential tasks where one depends on another's output
- Tasks that need coordination during execution

### Specialized Tool or Model Requirements

Sometimes a task needs different capabilities than my current configuration.

**Model selection**:
- **Haiku**: Fast searches, simple pattern matching, low-stakes exploration
- **Sonnet**: Default balance - code review, analysis, most tasks
- **Opus**: Complex reasoning, synthesis across many sources, critical decisions
- **Inherit**: Match whatever model I'm running as

**Tool restrictions**:
- Read-only agents for safe exploration: `tools: Read, Grep, Glob`
- Full access for implementation: `tools: Read, Write, Edit, Bash`
- Web-enabled for external research: `tools: Read, WebFetch, Bash`

---

## Orchestration Strategies

### Crafting Effective Subagent Prompts

The prompt I send to a subagent is their entire world. They don't know what I know, what the user wants, or what context matters. I must be explicit.

**Strong prompt structure**:
```
## Task
[Specific, actionable description of what to accomplish]

## Context
[Essential background they need - not everything, just essentials]

## Constraints
[What to avoid, boundaries, scope limits]

## Output Expected
[Exactly what format and content I need back]
```

**Example - Poor prompt**:
```
Review the auth code.
```

**Example - Strong prompt**:
```
## Task
Review the authentication module for security vulnerabilities
and code quality issues.

## Context
- Files are in src/auth/ and src/middleware/auth.ts
- We use JWT tokens with refresh rotation
- User reported potential session fixation issue

## Constraints
- Focus on security, not style
- Don't review test files
- Ignore the legacy endpoints in src/auth/deprecated/

## Output Expected
- List of security issues with severity (critical/high/medium/low)
- Specific file:line references
- Recommended fixes for each issue
```

### What Context to Pass vs. What to Let Them Discover

**Pass explicitly**:
- File paths relevant to the task
- Specific patterns or keywords to look for
- User requirements or constraints
- Known issues or areas of concern

**Let them discover**:
- Code structure and dependencies (they can explore)
- Implementation details (they'll read the files)
- Related patterns (their searches will find them)

**The balance**: Give them enough to start in the right place, but don't dump my entire context on them. That defeats the isolation purpose.

### Resuming vs. Starting Fresh

Subagents can be resumed, preserving their previous context.

**Resume when**:
- User asks follow-up about the same work
- New task directly builds on previous findings
- The subagent's accumulated context is valuable

**Start fresh when**:
- New independent task (even if same agent type)
- Previous context would bias or confuse
- Clean slate is explicitly needed

**Resumption pattern**:
```
First invocation:
> Use code-analyzer to review the auth module
[Returns agentId: "abc123", plus summary]

Later follow-up:
> Resume agent abc123 and now check the authorization logic
[Continues with full previous context intact]
```

### Coordinating Results from Multiple Subagents

When I dispatch multiple subagents, I'm responsible for synthesis.

**Coordination pattern**:
1. Dispatch subagents with clear, non-overlapping scopes
2. Collect all summaries
3. Identify connections, contradictions, or gaps
4. Synthesize into coherent response for user
5. Decide if follow-up subagent work is needed

**Watch for**:
- Conflicting findings (different agents, different conclusions)
- Overlapping work (wasted effort, potential inconsistency)
- Missing coverage (gaps between agent scopes)

---

## Key Constraints I Must Remember

### Subagents Cannot Spawn Other Subagents

```
ME ─────┬──▶ Subagent A ──╳──▶ (Cannot spawn Subagent C)
        │
        └──▶ Subagent B ──╳──▶ (Cannot spawn Subagent D)
```

I am always the orchestrator. If a task needs further delegation, I must:
1. Receive the subagent's summary
2. Decide what further work is needed
3. Dispatch new subagents myself

This is by design - it prevents runaway agent spawning and keeps me in control of coordination.

### Skills Are Not Inherited `[inferred]`

When I have skills loaded, my subagents don't automatically get them.

```yaml
# I have these skills active in my context
# But subagent starts fresh - it has NONE of these

# Subagent must explicitly pre-load [illustrative]:
---
name: security-reviewer
skills: owasp-checks, secure-coding-patterns  # Must list here
---
```

> **Note**: This skill inheritance behavior and the exact YAML configuration syntax are based on
> observed patterns and may not exactly match Claude Code's current implementation. Verify against
> official documentation for your Claude Code version.

**Implication**: When designing agent configurations, think about what knowledge the subagent needs. Include it in the `skills:` field, or embed essential guidance directly in the system prompt.

### Only Summaries Return

The subagent's full work - every file read, every search result, every reasoning step - stays in their isolated context. I only get back what they summarize.

**This means**:
- I cannot "look at" what they found in detail
- I must trust their summary or ask for more detail
- If I need specifics, I should request them in the output format
- Or I can resume the agent to ask follow-up questions

### Fresh Context Each Time (Unless Resumed)

Each new subagent invocation starts with zero history.

**Even if**:
- I used the same agent type before
- The task is related to previous work
- The same agent configuration exists

**The subagent knows nothing** unless:
- I pass context in the prompt
- I resume a previous agent session with its ID

---

## Common Mistakes in Orchestration

### Passing Too Much Context

**The mistake**: Dumping everything I know into the subagent prompt.

**Why it's wrong**:
- Defeats the purpose of context isolation
- Subagent context fills up before doing actual work
- Irrelevant information distracts from the task

**Better approach**: Pass only what's essential to start. Let them discover the rest through their own exploration.

### Not Being Specific Enough in Prompts

**The mistake**: Vague prompts like "review the code" or "explore the codebase."

**Why it's wrong**:
- Subagent doesn't know scope, priorities, or criteria
- Results will be unfocused or miss what matters
- Wastes subagent context on irrelevant work

**Better approach**: Specify exactly what to look for, where to look, and what format of output I need.

### Using Subagents When Skills Would Suffice

**The mistake**: Spawning a subagent just to "know" something.

**Why it's wrong**:
- Skills add knowledge to my context directly
- Subagent knowledge stays isolated - doesn't help me
- Overhead of subagent invocation for no benefit

**Better approach**:
- Need knowledge during conversation → Use skill
- Need isolated processing work → Use subagent
- Need isolated processing WITH knowledge → Subagent with pre-loaded skills

### Forgetting to Synthesize Results

**The mistake**: Passing subagent summaries directly to the user without synthesis.

**Why it's wrong**:
- Multiple subagents may have overlapping or conflicting findings
- User wants a coherent answer, not raw reports
- I'm the orchestrator - synthesis is my job

**Better approach**: Review all subagent outputs, identify themes and conflicts, synthesize into a coherent response that addresses the user's actual question.

### Not Specifying Output Format

**The mistake**: Letting subagents decide how to format their response.

**Why it's wrong**:
- Inconsistent formats across subagents make synthesis harder
- I may not get the specific information I need
- Wastes context on formatting I'll have to parse anyway

**Better approach**: Be explicit about output structure in the prompt:
```
## Output Expected
Return a JSON object with:
- issues: array of {file, line, severity, description}
- summary: one paragraph overview
- recommendations: prioritized list of next steps
```

---

## Subagent Selection: Matching Task to Agent

### Built-in Agents `[inferred]`

> **Note**: These agent types and their default configurations are based on observed Claude Code
> behavior and may vary across versions. Verify against current documentation.

| Agent | Model | Tools | Best For |
|-------|-------|-------|----------|
| **Explore** | Haiku | Read, Grep, Glob, Bash (read-only) | Fast codebase navigation, finding files |
| **Plan** | Sonnet | Read, Glob, Grep, Bash | Research for plan mode, understanding scope |
| **General** | Sonnet | All | Complex multi-step implementation work |

### When to Create Custom Agents

Create a custom agent when:
- Recurring task type needs consistent handling
- Specific skill combination is needed repeatedly
- Tool restrictions or model choice matters
- "Proactive" invocation would help (agent self-triggers)

### The Isolated Expert Pattern

When I need both **context isolation** AND **specialized knowledge**:

```yaml
# .claude/agents/security-reviewer.md [illustrative]
# Verify exact configuration syntax against current Claude Code documentation
---
name: security-reviewer
description: Security expert. Use proactively when reviewing security-sensitive code.
skills: owasp-checks, secure-coding-patterns
model: sonnet
tools: Read, Grep, Glob
---

You are a security specialist with deep knowledge of OWASP vulnerabilities
and secure coding patterns. Review code for security issues only.
```

This combines:
- Subagent isolation (heavy review work doesn't bloat main context)
- Skill expertise (pre-loaded security knowledge)
- Focused tools (read-only, can't accidentally modify)

---

## Summary: My Mental Model for Subagents

**What they are**: Other instances of me, starting fresh, doing focused work in isolation.

**When to use them**: Heavy processing, parallel tasks, different model/tool needs, context protection.

**How to orchestrate**: Clear prompts, explicit output formats, synthesis of results.

**Key constraints**: No nesting, no skill inheritance, summaries only, fresh context.

**Common traps**: Over-sharing context, vague prompts, using subagent when skill suffices, skipping synthesis.

**The core principle**: I am the orchestrator. Subagents are specialists I dispatch. I define their task, equip them with what they need, receive their findings, and synthesize everything for the user.

---

## References

For deeper understanding, consult:
- Official subagent documentation at code.claude.com
- Execution model details: `claude-code-advisor` plugin references
- Skill vs. subagent decisions: See `context-management.md` in this folder

---

## Sources and Confidence

| Section | Confidence | Source |
|---------|------------|--------|
| Subagent as isolated instance | VERIFIED | Claude Code subagent documentation |
| Information flow (in/out isolation) | VERIFIED | Observed behavior matches documentation |
| Context isolation benefits | VERIFIED | Documented design principle |
| Parallel subagent dispatch | VERIFIED | Task tool documentation |
| Model selection (Haiku/Sonnet/Opus) | VERIFIED | Task tool parameters |
| Built-in agent types (Explore, Plan, General) | INFERRED | Observed from system behavior |
| Skill inheritance behavior | INFERRED | Observed that subagents don't auto-inherit |
| Agent configuration YAML syntax | ILLUSTRATIVE | Example format, verify against current docs |
| Subagents cannot spawn subagents | VERIFIED | Architectural constraint, documented |
| Resumption with agent ID | VERIFIED | Task tool parameter |

*Document created: 2026-01-10*
*Confidence framework added: 2026-01-12*
