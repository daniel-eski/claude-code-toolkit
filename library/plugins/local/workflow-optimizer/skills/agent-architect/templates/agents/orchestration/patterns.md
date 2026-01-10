# Orchestration Patterns

Strategies for coordinating multiple agents effectively.

## Overview

When tasks are complex, using multiple specialized agents can be more effective than a single general-purpose agent. This guide covers patterns for orchestrating multi-agent workflows.

---

## Pattern 1: Parallel Execution

Run multiple agents simultaneously when tasks are independent.

### When to Use
- Multiple independent analysis tasks
- Gathering information from different sources
- Reviews that don't depend on each other
- Speed is important

### How It Works

The orchestrator (main Claude agent) calls multiple `Task` tools in a single message. Claude Code executes them in parallel.

```
┌─────────────┐
│ Orchestrator│
└──────┬──────┘
       │ (single message with multiple Task calls)
       ├──────────────┬──────────────┐
       ▼              ▼              ▼
┌──────────┐   ┌──────────┐   ┌──────────┐
│ Agent A  │   │ Agent B  │   │ Agent C  │
└──────────┘   └──────────┘   └──────────┘
       │              │              │
       └──────────────┴──────────────┘
                      │
                      ▼
              [Consolidated results]
```

### Example: Multi-Perspective Code Review

```
User: "Review this PR thoroughly"

Orchestrator spawns in parallel:
├── security-auditor → Security vulnerabilities
├── code-reviewer → Quality and maintainability
└── researcher → Check for similar patterns elsewhere

Results consolidated into comprehensive review.
```

### Implementation Tips
- Each agent gets isolated context
- Results return when all complete
- Orchestrator synthesizes findings
- Works best when tasks are truly independent

---

## Pattern 2: Pipeline

Sequential handoff where each agent's output feeds the next.

### When to Use
- Multi-stage processing
- When later stages depend on earlier analysis
- Refinement workflows
- Quality gates between stages

### How It Works

```
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│ Research │ ─► │ Implement│ ─► │   Test   │ ─► │  Review  │
└──────────┘    └──────────┘    └──────────┘    └──────────┘
     │               │               │               │
     ▼               ▼               ▼               ▼
 [findings]      [code]         [results]       [feedback]
```

### Example: Feature Implementation Pipeline

```
Phase 1: researcher
├── Input: "Understand authentication patterns in codebase"
└── Output: findings about existing auth implementation

Phase 2: implementer
├── Input: Research findings + "Add OAuth support"
└── Output: New OAuth implementation

Phase 3: test-runner
├── Input: "Verify OAuth implementation works"
└── Output: Test results

Phase 4: code-reviewer
├── Input: "Review the OAuth changes"
└── Output: Final review and approval
```

### Implementation Tips
- Each agent receives previous agent's output as context
- Can include quality gates (fail pipeline if tests fail)
- Orchestrator manages handoffs
- Document expected inputs/outputs for each stage

---

## Pattern 3: Fan-Out/Fan-In

Distribute work to multiple agents, then consolidate results.

### When to Use
- Large codebase analysis
- Parallel processing with consolidation
- When same task applies to multiple areas
- Divide-and-conquer scenarios

### How It Works

```
                    ┌─────────────┐
                    │ Orchestrator│
                    └──────┬──────┘
                           │ (fan-out)
          ┌────────────────┼────────────────┐
          ▼                ▼                ▼
    ┌──────────┐     ┌──────────┐     ┌──────────┐
    │ Agent A  │     │ Agent B  │     │ Agent C  │
    │ (area 1) │     │ (area 2) │     │ (area 3) │
    └──────────┘     └──────────┘     └──────────┘
          │                │                │
          └────────────────┼────────────────┘
                           │ (fan-in)
                    ┌──────▼──────┐
                    │ Consolidator│
                    └─────────────┘
```

### Example: Security Audit

```
Fan-out: security-auditor instances for each area
├── security-auditor → /src/auth/
├── security-auditor → /src/api/
├── security-auditor → /src/utils/
└── security-auditor → /src/database/

Fan-in: Consolidate all findings
├── Merge vulnerability lists
├── Deduplicate issues
├── Prioritize by severity
└── Create unified report
```

### Implementation Tips
- Define clear boundaries for each agent's scope
- Use same agent type for consistency
- Consolidation can be done by orchestrator or dedicated agent
- Consider dependencies between areas

---

## Pattern 4: Conditional Routing

Choose agents based on task characteristics.

### When to Use
- Different task types need different specialists
- Dynamic workflow based on context
- Triage and delegation scenarios
- When task type isn't known upfront

### How It Works

```
┌─────────────┐
│    Task     │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Router    │ ─── Analyze task characteristics
└──────┬──────┘
       │
       ├─── Bug? ──────────► debugger
       │
       ├─── Feature? ──────► implementer
       │
       ├─── Question? ─────► researcher
       │
       └─── Review? ───────► code-reviewer
```

### Example: Intelligent Task Routing

```
Orchestrator receives: "The login isn't working"

Analysis:
- Contains error symptom → Bug
- Affects authentication → Security-relevant
- User-reported → May need clarification

Routing decision:
1. First: researcher (understand the issue)
2. Then: debugger (fix root cause)
3. Finally: security-auditor (verify no security regression)
```

### Implementation Tips
- Define clear routing criteria
- Allow for multi-agent routing when needed
- Include fallback for unclear cases
- Log routing decisions for debugging

---

## Pattern 5: Supervisor

One agent coordinates and reviews others' work.

### When to Use
- Quality assurance on agent output
- Complex multi-step tasks
- When human-like oversight is needed
- Critical operations requiring verification

### How It Works

```
┌────────────────┐
│   Supervisor   │ ─── Reviews all output
└───────┬────────┘     before completion
        │
        ├──── Assigns task ────► Worker Agent
        │                              │
        ◄──── Reviews output ──────────┘
        │
        ├─── Approved? ─► Done
        │
        └─── Rejected? ─► Feedback + Retry
```

### Example: Code Review Supervisor

```
Supervisor: code-reviewer (senior)
├── Delegates to: implementer
│   └── Implementer writes code
├── Reviews implementation
│   ├── Checks correctness
│   ├── Checks patterns
│   └── Checks security
├── If issues found:
│   └── Returns feedback, implementer revises
└── If approved:
    └── Implementation complete
```

---

## Combining Patterns

Patterns can be combined for complex workflows.

### Example: Full Feature Development

```
┌─────────────────────────────────────────────────────────┐
│                      PIPELINE                           │
│                                                         │
│  ┌──────────┐    ┌─────────────────┐    ┌──────────┐   │
│  │ Research │ ─► │   Implement     │ ─► │  Review  │   │
│  └──────────┘    │   (supervised)  │    └──────────┘   │
│                  │                 │         ▲         │
│                  │   ┌──────────┐  │         │         │
│                  │   │supervisor│──┼─────────┘         │
│                  │   └────┬─────┘  │   (parallel)      │
│                  │        │        │                   │
│                  │   ┌────▼────┐   │   ┌──────────┐   │
│                  │   │implement│   │   │ security │   │
│                  │   └─────────┘   │   └──────────┘   │
│                  └─────────────────┘                   │
└─────────────────────────────────────────────────────────┘
```

---

## Best Practices

### 1. Clear Boundaries
- Each agent should have a well-defined scope
- Avoid overlapping responsibilities
- Document expected inputs/outputs

### 2. Appropriate Model Selection
- Use `haiku` for simple, fast tasks
- Use `sonnet` for complex reasoning
- Use `inherit` when parent's model is sufficient

### 3. Context Management
- Agents have isolated context by default
- Pass necessary context explicitly
- Avoid passing excessive context

### 4. Error Handling
- Define what happens when an agent fails
- Include retry logic for transient failures
- Have fallback strategies

### 5. Observability
- Log agent activities for debugging
- Track which agents were used and why
- Measure agent effectiveness over time
