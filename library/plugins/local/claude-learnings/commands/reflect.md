---
description: Use mid-workflow to analyze what went well/poorly, capturing learnings that can be saved and survive rewind for downstream improvement
argument-hint: [optional: focus area, e.g., "Phase 1 of auth refactor"]
---

# Thoughtful Reflection

## Overview

Reflection is not summary. Reflection is understanding WHY things happened and WHAT would make them better.

**Core principle:** Every learning must be traceable to something specific (a file, an instruction, a conversation moment) or it's not actionable.

Focus area: $ARGUMENTS

## When to Use

Use `/reflect` when:
- You (the user) had to correct Claude's approach
- Claude struggled, got confused, or asked clarifying questions
- A phase or significant chunk of work completed
- You want to capture learnings before rewinding
- Something worked particularly well and should be preserved

## The Reflection Process

Follow these steps in order. Do not skip any section, but you may note "None identified" if a section is genuinely empty.

### Step 1: Scope Determination

If focus area was specified above:
- Concentrate reflection on that area
- Still note other significant observations briefly

If no focus area specified:
- Reflect on the entire conversation since session start
- Organize by natural phases or task groupings

### Step 2: Structured Analysis

For EACH section below, be specific. You MUST cite files, quote text, and reference conversation turns.

**Specificity requirements (MANDATORY):**
- BAD: "The instructions were unclear"
- GOOD: "Line 45 of `library/skills/kickoff.md` says 'handle errors appropriately' which doesn't specify try-catch vs error boundaries vs validation"
- Include: file path, line number when possible, quoted text

#### Section A: Corrections Received

Think about: What did the user correct you on?

For each correction identified:

1. **What happened**: Describe the specific mistake you made
2. **What you were trying to do**: Your intent at the time
3. **What led you astray**: Quote the specific file/instruction/context that was unclear, missing, or misinterpreted. Include file path and line number.
4. **What would have prevented it**: Specific change to a file, instruction, or context. Be precise about what text to add/change and where.

Format each correction as:

```
### Correction: [Brief title]

**What happened**: [Description]

**What I was trying to do**: [Intent]

**What led me astray**: In `[file path]` (line [N]), the text "[quoted text]" [explain why this was problematic - missing info, ambiguous, etc.]

**What would have prevented it**:
Add to `[file path]`:
> [Exact text to add]

Or modify `[file path]` line [N] from:
> [Old text]
To:
> [New text]
```

#### Section B: Gaps Revealed by Questions

Think about: What questions did the user ask that revealed something you didn't know or couldn't find?

User questions are signals of missing context. Each question implies: "This should have been obvious or documented."

For each revealing question:

1. **The question**: What the user asked (quote or paraphrase)
2. **What it revealed**: What context or information you were missing
3. **Where it should live**: Which specific file should contain this information
4. **Suggested addition**: The exact text to add, and where in the file

#### Section C: Points of Confusion

Think about: What were you uncertain about? What made you pause or ask for clarification?

For each point of confusion:

1. **What was confusing**: The specific instruction, file, or situation (cite file and line)
2. **Why it was confusing**: Ambiguous wording? Missing context? Contradictory information? Multiple valid interpretations?
3. **How it was resolved**: What clarified it (if resolved)
4. **Suggested improvement**: How to make it clearer for future. Include specific text changes.

Be honest. If something in the workflow instructions didn't make sense, say exactly what and why.

#### Section D: What Worked Well

Think about: What went smoothly? What was well-documented or well-structured?

For each positive (identify at least one if anything went well):

1. **What worked**: The specific instruction, file, or pattern (cite file path)
2. **Why it worked**: What made it effective
3. **Preserve/replicate note**: Flag this as something to NOT change, or suggest applying the same pattern elsewhere

This prevents the downstream agent from "fixing" things that aren't broken.

### Step 3: Open Reflection

After completing the structured sections, think more broadly. Consider:

- What patterns do you notice across the corrections and confusions?
- What surprised you about this work?
- What assumptions did you make that turned out wrong?
- What would you do differently if starting over?
- Are there structural issues (not just content issues) in the workflow or instructions?
- What did you learn that doesn't fit the categories above?

This section is for unexpected insights. Write freely, but still be specific when referencing files or instructions.

### Step 4: Summary for Downstream Agent

Compile a structured summary that a future agent can act on:

```markdown
## Actionable Items

| Priority | File | Line(s) | Change Type | Description |
|----------|------|---------|-------------|-------------|
| High | path/to/file.md | 45-52 | Add section | [Brief description] |
| Medium | path/to/other.md | 12 | Clarify | [Brief description] |
| Low | CLAUDE.md | - | Add pattern | [Brief description] |

## Files Referenced

- `path/to/file.md:45-52` — [why referenced]
- `path/to/other.md:12` — [why referenced]
```

---

## Self-Check Before Output

Before generating the final reflection, verify each learning against these criteria:

| Criterion | Required? | Example |
|-----------|-----------|---------|
| File path | Yes | `CLAUDE.md`, `src/auth.ts` |
| Line numbers | When referencing content | `lines 45-52` |
| Quoted text | When referencing instructions | `"Always use GraphQL"` |
| Actionable suggestion | Yes | Specific text to add/change |

**If a learning fails these criteria:**
- Enhance it with specific citations, OR
- Move it to "Open Reflection" as a general observation, OR
- Remove it if not valuable without specifics

Quality over quantity. Vague learnings are not actionable.

## Output Format

Present the reflection using this structure:

```markdown
# Reflection: [Focus Area or "Full Session"]

*Generated: [timestamp]*
*Workflow: [workflow name if identifiable]*
*Project: [repo/project name]*

---

## Corrections Received

[Each correction with full details. If none: "None identified"]

## Gaps Revealed

[Each gap with suggested additions. If none: "None identified"]

## Points of Confusion

[Each confusion point with improvements. If none: "None identified"]

## What Worked Well

[What to preserve. If none: "None identified"]

## Open Reflection

[Step 3 content - broader insights]

---

## Actionable Items

[Summary table from Step 4]

## Files Referenced

[File list from Step 4]

---

*Ready to save? Use `/save-learnings` or `/save-learnings path/to/folder`*
```

## Critical Requirements

1. **Every learning must cite a specific file path** — no vague references
2. **Include line numbers when possible** — precision enables action
3. **Quote the problematic text** — show exactly what was confusing or wrong
4. **Provide exact suggested changes** — not "clarify this" but the actual text to add
5. **Be brutally honest** — diplomatic phrasing reduces value
6. **Quantity isn't quality** — 3 specific, traceable learnings beat 10 vague observations
7. **Don't invent** — if a section is genuinely empty, say "None identified" and move on

## After Reflection

Once you've output the reflection:
1. Wait for user to review
2. User may edit, add comments, or approve as-is
3. When ready, user runs `/save-learnings` to persist the reflection
4. The saved file survives rewind and can be processed by a downstream agent
