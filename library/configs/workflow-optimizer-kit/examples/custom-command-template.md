# Custom Command Templates

This file provides templates for creating your own Claude Code slash commands. Commands are saved as `.md` files in `~/.claude/commands/` (user-level) or `.claude/commands/` (project-level).

---

## Basic Command Template

```markdown
---
description: Brief description shown in /help
---

Your prompt content here. This is what Claude receives when the command is invoked.
```

## Command with Arguments

```markdown
---
description: Brief description shown in /help
argument-hint: [expected arguments]
---

# Command Title

Context or instructions for Claude.

## User Input
$ARGUMENTS

## What to Do
Instructions for how Claude should handle the input.
```

---

## Example Commands

### /review - Code Review Command

```markdown
---
description: Review code changes with focus on quality and best practices
argument-hint: [file path or 'staged' for git staged changes]
---

# Code Review Request

Review the specified code for:
1. **Correctness**: Logic errors, edge cases, potential bugs
2. **Security**: Injection vulnerabilities, auth issues, data exposure
3. **Performance**: N+1 queries, unnecessary computation, memory leaks
4. **Maintainability**: Readability, naming, code organization
5. **Testing**: Missing test cases, test quality

## Target
$ARGUMENTS

If "staged" is specified, review all staged git changes.
If a file path is provided, review that specific file.
If nothing is provided, ask what to review.

## Output Format
For each issue found:
- **Severity**: Critical / Warning / Suggestion
- **Location**: File and line number
- **Issue**: What's wrong
- **Fix**: How to address it

Summarize with an overall assessment at the end.
```

### /explain - Code Explanation Command

```markdown
---
description: Explain code in detail with context
argument-hint: [file path or code block]
---

# Code Explanation Request

Explain the specified code thoroughly:

## Target
$ARGUMENTS

## Explanation Should Include
1. **Purpose**: What does this code accomplish?
2. **How it works**: Step-by-step walkthrough
3. **Key concepts**: Important patterns or techniques used
4. **Dependencies**: What this code relies on
5. **Side effects**: External state changes
6. **Potential issues**: Edge cases or limitations

Use clear language appropriate for someone familiar with the tech stack but new to this codebase.
```

### /test - Test Generation Command

```markdown
---
description: Generate tests for specified code
argument-hint: [file path]
---

# Test Generation Request

Generate comprehensive tests for the specified code.

## Target
$ARGUMENTS

## Requirements
1. Follow existing test patterns in the codebase
2. Include:
   - Happy path tests
   - Edge cases
   - Error conditions
   - Boundary values
3. Use descriptive test names: "should [behavior] when [condition]"
4. Mock external dependencies appropriately
5. Aim for high coverage of logic branches

## Output
Provide the complete test file content, ready to save.
```

### /docs - Documentation Command

```markdown
---
description: Generate or update documentation for code
argument-hint: [file path or 'readme']
---

# Documentation Request

Generate documentation for the specified target.

## Target
$ARGUMENTS

## If file path provided:
- Generate JSDoc/docstrings for all exported functions/classes
- Include parameter descriptions, return values, examples
- Note any side effects or important behaviors

## If 'readme' specified:
- Generate/update README.md for the current project
- Include: overview, setup, usage, API reference, contributing

## Style
- Clear and concise
- Include code examples where helpful
- Match existing documentation style in the project
```

### /debug - Debugging Assistant Command

```markdown
---
description: Help debug an issue with structured analysis
argument-hint: [error message or description of issue]
---

# Debugging Session

Help diagnose and fix the reported issue.

## Problem
$ARGUMENTS

## Debugging Process

### Step 1: Understand the Problem
- What is the expected behavior?
- What is the actual behavior?
- When did this start happening?
- Is it reproducible?

### Step 2: Gather Context
- Check relevant code files
- Look at recent changes (git log)
- Check error logs if available

### Step 3: Form Hypotheses
List possible causes ranked by likelihood.

### Step 4: Investigate
For each hypothesis, explain:
- How to verify it
- What evidence supports/refutes it

### Step 5: Solution
Provide the fix with explanation of why it works.

### Step 6: Prevention
Suggest how to prevent similar issues (tests, validation, etc.)
```

---

## Tips for Writing Commands

1. **Clear description**: Users see this in `/help` - make it informative
2. **Use $ARGUMENTS**: Placeholder for user input after the command
3. **Structured prompts**: Use headers and lists for complex instructions
4. **Be specific**: Tell Claude exactly what output format you want
5. **Include context**: Reference project conventions or patterns
6. **Test your commands**: Try them with various inputs
