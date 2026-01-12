# Self-Knowledge Documentation Accuracy Review

> Detailed analysis of claims made in the self-knowledge documents
> **Review Date**: 2026-01-12
> **Reviewer**: Claude Opus 4.5 (PR review agent)

---

## Executive Summary

The three self-knowledge documents provide **genuine value** as practitioner guides. They synthesize information well and offer useful mental models. However, they present some **inferred or speculative claims as verified facts**, which could mislead users who treat them as authoritative technical references.

**Recommendation**: Keep the documents but add confidence levels, source citations, or caveats to distinguish verified information from architectural inference.

---

## Document 1: context-management.md

**Location**: `docs/self-knowledge/context-management.md`
**Lines**: 365

### What Works Well

1. **Context layer model** (always-present vs. conditionally-loaded vs. growth-during-session) - useful framework not explicitly organized this way in official docs
2. **"Every Session?" decision tree** - immediately practical for users
3. **Path-specific rules example** with `paths:` frontmatter - concrete and actionable
4. **Hierarchy visualization** of CLAUDE.md precedence levels

### Accuracy Concerns

| Claim | Location | Issue | Confidence |
|-------|----------|-------|------------|
| "5 levels deep" import recursion limit | Line ~71 | Unverified; not mentioned in available official docs | LOW |
| "13k tokens before any conversation begins" | Line ~122 | Calculation assumes facts not verified | MEDIUM |
| "When context approaches capacity, history compacts automatically" | Line ~71 | Plausible but mechanism stated as fact without source | MEDIUM |
| Token budget estimates (2-3k for system, 100 tokens per skill) | Various | Reasonable but no stated source | MEDIUM |

### Specific Examples

**Unverified claim (Line ~71)**:
> "When the context approaches capacity, history compacts automatically"

This states a mechanism as architectural fact. The actual compaction behavior may vary by implementation.

**Calculation without basis (Line ~122)**:
> "13k tokens before any conversation begins"

This presents a calculation as if the underlying numbers are verified, but they're estimates.

### Recommended Fixes

1. Add a "Note on Sources" section explaining this is practitioner synthesis
2. Change language from "X happens" to "X typically happens" where unverified
3. Cite specific sources for verifiable claims
4. Add footnotes for the token estimates explaining they're approximate

---

## Document 2: subagent-mechanics.md

**Location**: `docs/self-knowledge/subagent-mechanics.md`
**Lines**: 410

### What Works Well

1. **Isolation model explanation** - clearly explains that subagents have fresh context
2. **Orchestrator vs. specialist framing** - valuable mental model
3. **Prompt structure framework** (Task/Context/Constraints/Output) - immediately useful
4. **"Don't spawn" criteria** - practical decision guidance
5. **Common mistakes section** - domain-specific wisdom

### Accuracy Concerns

| Claim | Location | Issue | Confidence |
|-------|----------|-------|------------|
| "Skills Are Not Inherited" by subagents | Lines 235-250 | May not match actual Claude Code behavior | LOW |
| YAML agent configuration with `skills:` field | Lines 373-380 | Syntax may not exist in Claude Code | LOW |
| Built-in agents: "Explore," "Plan," "General" | Line 352 | Should be verified against official agent definitions | MEDIUM |
| Model selection (Haiku/Sonnet/Opus for tasks) | Lines 102-103 | Reasonable but presented as established practice | MEDIUM |

### Specific Examples

**Unverified syntax (Lines 373-380)**:
```yaml
# Example from document
subagent:
  name: researcher
  skills:
    - systematic-debugging
    - code-analysis
```

This YAML structure is presented as valid Claude Code configuration, but the exact syntax may not match how subagents are actually configured.

**Unverified claim (Lines 235-250)**:
> "Skills add knowledge to my context directly"
> "Subagent knowledge stays isolated"

This contrasts two models without explaining that it's the author's understanding of the architecture, not documented behavior.

### Recommended Fixes

1. Mark the YAML examples as "illustrative" rather than "copy-paste ready"
2. Add caveat: "This reflects Claude's understanding of how subagents work, not necessarily how Claude Code officially documents it"
3. Verify the built-in agents list against current Claude Code behavior
4. Add source citations for model selection guidance

---

## Document 3: tool-execution.md

**Location**: `docs/self-knowledge/tool-execution.md`
**Lines**: 382

### What Works Well

1. **Agentic loop explanation** (observe-think-act) - conceptually sound
2. **Tool invocation flow diagram** with hooks - matches official docs structure
3. **Tool selection table** - helpful for choosing between tools
4. **PreToolUse/PostToolUse hook documentation** - likely accurate based on code.claude.com

### Accuracy Concerns

| Claim | Location | Issue | Confidence |
|-------|----------|-------|------------|
| Permission decision `allow/deny/ask` JSON structure | Lines 127-130 | Exact format unverified | MEDIUM |
| "Reads typically don't require approval, writes do" | Lines 137-153 | Context-dependent, may vary by configuration | MEDIUM |
| "Specialized tools bypass permission model" | Lines 268-272 | Misleading - all tools go through permission flow | LOW |
| Filesystem/network constraints | Lines 138-153 | Framed vaguely; real constraints are config-specific | MEDIUM |

### Specific Examples

**Misleading claim (Lines 268-272)**:
> "Specialized tools bypass the permission model"

This is misleading. Tools like Read, Edit, Glob integrate WITH the permission system - they don't bypass it. The distinction is that some operations are pre-approved based on type, not that they skip the system entirely.

**Permission model variance (Lines 137-153)**:
> "Reads typically don't require approval"

This is generally true but varies by:
- Hook configuration
- Enterprise policies
- Sandbox settings
- File sensitivity

The document doesn't acknowledge this variance.

### Recommended Fixes

1. Replace "bypass" language with "integrate with" or "leverage"
2. Add caveat that permission behavior is environment-dependent
3. Clarify that the JSON structures are illustrative
4. Add section acknowledging hook configuration affects all this

---

## Cross-Document Patterns

### What Works Well Across All Three

1. **Practical decision frameworks** - each document provides actionable guidance
2. **Clear mental models** - context layers, isolation model, agentic loop
3. **Progressive disclosure** - main concepts first, details available
4. **Examples included** - not just theory, concrete usage

### What's Problematic Across All Three

1. **Authority without grounding** - documents read with technical authority but lack source citations
2. **Inference presented as fact** - architectural details presented as documented behavior
3. **Missing caveats** - no acknowledgment that some claims are inferred
4. **No confidence indicators** - reader can't distinguish verified from speculated

---

## The Core Issue

These documents are valuable because they synthesize and organize information in ways that aren't available elsewhere. The problem is they don't distinguish between:

| Type | Example | How to identify |
|------|---------|-----------------|
| **Verified fact** | "CLAUDE.md is read at session start" | Documented at code.claude.com |
| **Reasonable inference** | "Context compacts when full" | Observed behavior, not documented |
| **Author's mental model** | "5 levels deep import limit" | Architecture inference |
| **Illustrative example** | YAML config syntax | May or may not be exact syntax |

---

## Recommendation Summary

### Keep the Documents

They provide genuine value for practitioners:
- Organize complex topics clearly
- Provide actionable frameworks
- Fill gaps in official documentation

### Add Confidence Indicators

Options:

**Option A: Section-level caveats**
```markdown
> **Note**: This section describes the author's understanding based on
> observed behavior. Official documentation may differ.
```

**Option B: Inline confidence markers**
```markdown
When context fills, history compacts automatically [observed, not documented].
```

**Option C: Source appendix**
```markdown
## Sources and Confidence

| Section | Based On | Confidence |
|---------|----------|------------|
| Context layers | Official docs + inference | HIGH |
| 5-level import limit | Unverified | LOW |
| Token estimates | Author calculation | MEDIUM |
```

### Priority

This is a **medium-priority** follow-up item. The documents work fine for most users, but improvements would make them more trustworthy as references.

---

*Assessment completed: 2026-01-12*
