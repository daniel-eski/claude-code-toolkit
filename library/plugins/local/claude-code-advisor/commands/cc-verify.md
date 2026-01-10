---
description: Verify understanding of a Claude Code feature against official documentation
argument-hint: [claim or feature to verify]
---

# Verify Claude Code Understanding

Verify claims about Claude Code features against current official documentation.

## When Invoked

Use the cc-understanding-verifier subagent to fact-check claims like:
- "Subagents can spawn other subagents"
- "Skills inherit context from the main conversation"
- "Hooks can modify tool inputs before execution"

## Your Task

1. **Identify the claim** in $ARGUMENTS
2. **Dispatch the cc-understanding-verifier subagent** to check official docs
3. **Report the verdict** with evidence

## Verification Sources

In priority order:
1. Official docs at code.claude.com
2. Platform docs at platform.claude.com
3. Local reference files if available

## Output Format

```
CLAIM: [The claim being verified]

VERDICT: CONFIRMED | REFUTED | PARTIALLY TRUE | CANNOT VERIFY

EVIDENCE:
Source: [URL or file]
Quote: "[Relevant excerpt]"

EXPLANATION:
[Why this verdict was reached]

CURRENT BEHAVIOR:
[What the documentation says the actual behavior is]
```

## Use Cases

- Before making architectural decisions based on assumptions
- When documentation may have changed
- To resolve confusion about feature behavior
- When advice differs from expectations
