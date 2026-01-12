---
name: prompt-optimizer
description: Clarifies objectives, surfaces assumptions, and ensures alignment before executing complex tasks. Use when receiving multi-step tasks, unfamiliar domains, ambiguous requirements, or when the user says "help me plan", "complex task", "I want to build", or asks for thorough analysis before execution.
allowed-tools: Read, Grep, Glob
---

# Prompt Optimizer Skill

You are helping ensure clear understanding and alignment before executing a complex task. This skill activates early in complex workflows to prevent wasted effort from misaligned understanding or unclear objectives.

## When This Skill Activates

This skill should activate when:
- The user describes a multi-step or complex task
- The task involves unfamiliar code, domains, or systems
- The user explicitly asks for planning or thorough analysis
- Requirements seem ambiguous or could be interpreted multiple ways
- The task has significant scope or potential for rework

## Complexity Check

Before running full analysis, quickly assess if it's warranted. See [COMPLEXITY-GUIDE.md](COMPLEXITY-GUIDE.md) for detailed criteria.

**Skip full analysis for simple tasks**:
- Single-file changes with clear requirements
- Specific, bounded fixes ("change X to Y")
- Familiar patterns with no ambiguity

For simple tasks, briefly note:
```
This task appears straightforward. Proceeding directly.
[Brief summary of what you'll do]
```

## Analysis Process

For complex tasks, copy this checklist and track your progress:

```
Analysis Progress:
- [ ] Step 1: Restate the Objective
- [ ] Step 2: Surface Assumptions
- [ ] Step 3: Identify Critical Context
- [ ] Step 4: Flag Risks and Ambiguities
- [ ] Step 5: Propose Approach
- [ ] Step 6: Clarifying Questions
```

Follow these steps systematically. Output each section clearly labeled.

### 1. Restate the Objective

Distill the user's request into 1-3 clear sentences that capture:
- **What** they want to accomplish (the deliverable)
- **Why** they want it (the underlying goal, if stated or inferable)
- **Constraints** mentioned (approach preferences, limitations, etc.)

This restatement should be specific enough that the user can confirm "yes, that's exactly what I want" or correct any misunderstanding.

**Format**:
```
**Objective**: [Your restatement]
```

### 2. Surface Assumptions

List assumptions you're making that, if wrong, would change your approach. Be specific and focus on assumptions that matter.

Good assumptions to surface:
- Technical assumptions ("Assuming this is a React application based on file structure")
- Behavioral assumptions ("Assuming backward compatibility is required")
- Scope assumptions ("Assuming this should handle edge case X")
- Quality assumptions ("Assuming tests should pass before completion")

**Format**:
```
**Assumptions**:
- [Assumption 1]
- [Assumption 2]
- [Assumption 3]
...
```

### 3. Identify Critical Context

List specific files, directories, or information needed before execution. Prioritize by importance.

**Categories**:
- **Must read**: Files essential to understanding the task
- **Should check**: Files likely containing relevant patterns or constraints
- **Need from user**: Information only the user can provide

**Format**:
```
**Critical Context**:

Must read:
- `path/to/file.ts` — [why this matters]
- `path/to/directory/` — [what you expect to find]

Should check:
- `path/to/file` — [what you're looking for]

Need from user:
- [Specific question or information needed]
```

### 4. Flag Risks and Ambiguities

Identify what could go wrong or cause rework:

- **Ambiguities**: Where the objective could be interpreted multiple ways
- **Risks**: What could fail or have unintended consequences
- **Dependencies**: External factors that could block progress
- **Scope concerns**: Where "small" changes might cascade into larger ones

**Format**:
```
**Risks & Ambiguities**:

Ambiguities:
- [Ambiguity and the different possible interpretations]

Risks:
- [Risk and potential mitigation]

Dependencies:
- [External dependency and its status if known]

Scope concerns:
- [Where scope might expand unexpectedly]
```

### 5. Propose Approach

Outline your high-level approach. This is conceptual—focus on the "what" and "why", not detailed steps.

**Format**:
```
**Proposed Approach**:

1. [Phase 1: What and why]
2. [Phase 2: What and why]
3. [Phase 3: What and why]

**Key decision points**: [Where you'll need to make choices or get feedback]
```

### 6. Clarifying Questions

If ambiguities would significantly affect your approach, ask focused questions. Limit to 3-5 questions maximum. Prioritize questions where the answer would change what you do.

**Format**:
```
**Questions for Clarification**:

1. [Question]? — [Why this matters for the approach]
2. [Question]? — [Why this matters for the approach]
```

If no questions are blocking, state: "No blocking questions. Ready to proceed upon your confirmation."

## Output Format

Structure your complete output as:

```
## Prompt Optimization Analysis

### Objective
[Section 1 content]

### Assumptions
[Section 2 content]

### Critical Context
[Section 3 content]

### Risks & Ambiguities
[Section 4 content]

### Proposed Approach
[Section 5 content]

### Clarifying Questions
[Section 6 content]

---

**Ready to proceed?** Once we're aligned, I recommend [specific next step based on task].
```

## Guidelines

1. **Be specific** — Name specific files, questions, and risks. Avoid vague statements.
2. **Bias toward action** — If the task is clear, say so. Don't over-analyze.
3. **Focus on the task** — This skill is for understanding tasks, not configuring tools.
4. **Invite correction** — Frame as "here's my understanding, please correct me."

## Examples

Follow these examples for the expected output format and level of detail:

**Example 1: Feature Request**

Input: "I want to add user authentication to our API"

Output:
```
## Prompt Optimization Analysis

### Objective
Add user authentication to the existing API, enabling secure access control for endpoints.

### Assumptions
- REST API based on typical project structure
- JWT or session-based auth is acceptable
- Need both login and registration endpoints
- Existing endpoints should require auth

### Critical Context

Must read:
- `src/api/` — Current API structure and routing patterns
- `package.json` — Existing auth-related dependencies

Need from user:
- Preferred authentication method (JWT, sessions, OAuth)?
- Should some endpoints remain public?

### Risks & Ambiguities

Ambiguities:
- "Authentication" could mean user auth, API key auth, or both

Risks:
- Adding auth to existing endpoints may break current integrations

Scope concerns:
- Auth often leads to needing password reset, email verification, etc.

### Proposed Approach

1. Research current API structure and identify integration points
2. Design authentication flow and data model
3. Implement auth middleware and endpoints
4. Update existing routes to use authentication

### Clarifying Questions

1. JWT or session-based authentication? — Affects implementation and dependencies
2. Need role-based access control? — Affects data model complexity

---

**Ready to proceed?** Once aligned, I recommend entering Plan Mode for detailed implementation steps.
```

**Example 2: Simple Task (Skip Full Analysis)**

Input: "Change the button color from blue to green"

Output:
```
This task appears straightforward. Proceeding directly.

I'll locate the button component and update its color styling from blue to green.
```

## After Alignment

Once the user confirms alignment:

1. **For complex, multi-step tasks** → Recommend `planning-with-files` to establish persistent context (task_plan.md, findings.md, progress.md). This prevents context loss during extended work.

2. **For detailed implementation planning** → Recommend Plan Mode (Shift+Tab) for step-by-step planning.

3. **If the approach is clear** → Begin execution directly.

4. **If questions remain** → Wait for answers before proceeding.

The goal is to reach confident execution as quickly as possible while avoiding costly misalignment.

## Integration with Workflow

This skill is part of the workflow-optimizer plugin. For complex projects, the recommended flow is:

1. **prompt-optimizer** (this skill) — Clarify objectives and align
2. **planning-with-files** — Establish persistent context for extended work
3. **agent-architect** — Design CLAUDE.md and agent architecture based on context

Each skill works independently, but they chain naturally for comprehensive project setup.

## Escalation Note

If during your analysis you identify that this task would benefit from:
- **Persistent context management** (extended work, many tool calls) → Mention `planning-with-files`
- **Specialized tooling** (subagents, hooks, automation) → Mention `agent-architect`

Example:
```
**Workflow consideration**: This task involves multiple phases and
extended work. Consider using `planning-with-files` to establish
persistent context, then `agent-architect` to design specialized
subagents for each phase.
```

This is optional and should only appear when genuinely relevant—not for every task.
