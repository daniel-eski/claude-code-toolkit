# Examples: Planning with Files in Action

Practical examples of file-based planning for different task types.

---

## Example 1: Research Task

**User Request:** "Research best practices for API rate limiting and write recommendations"

### Step 1: Create the Plan

```markdown
# task_plan.md

# Task Plan: API Rate Limiting Research

## Goal
Research API rate limiting best practices and create actionable recommendations for our service.

## Phases
- [x] Phase 1: Create plan ✓
- [ ] Phase 2: Research rate limiting patterns
- [ ] Phase 3: Analyze our current implementation
- [ ] Phase 4: Synthesize recommendations
- [ ] Phase 5: Document and deliver

## Key Questions
1. What are the common rate limiting algorithms?
2. What are the trade-offs of each approach?
3. What does our current implementation use?
4. What would work best for our use case?

## Decisions Made
(none yet)

## Status
**Currently in Phase 1** - Plan created
```

### Step 2: Research and Save Findings

After researching, update findings.md:

```markdown
# findings.md

# Findings: API Rate Limiting

## Rate Limiting Algorithms

### Token Bucket
- Tokens added at fixed rate, consumed per request
- Allows bursting up to bucket size
- Good for: APIs that tolerate occasional bursts

### Sliding Window
- Counts requests in rolling time window
- Smoother rate enforcement
- Good for: Strict rate enforcement

### Fixed Window
- Counts requests in fixed time periods
- Simple but has boundary issues
- Good for: Simple implementations

## Best Practices Found
- Return rate limit headers (X-RateLimit-*)
- Use 429 status code with Retry-After header
- Implement different limits per endpoint/user tier
- Consider distributed rate limiting for scaled services

## Sources
- [Stripe Engineering Blog]: Token bucket with Redis
- [Cloudflare Blog]: Sliding window approach
- [AWS Documentation]: API Gateway throttling
```

### Step 3: Update Progress

```markdown
# progress.md

# Progress Log: Rate Limiting Research

## Current Phase: 3 - Analyzing current implementation
## Overall Status: In Progress

## Session Log

### Session 1
**Completed:**
- Created task plan
- Researched three main algorithms
- Documented pros/cons of each

**Next:**
- Examine our current rate limiting code
- Compare with best practices

## Files Changed
| File | Action | Notes |
|------|--------|-------|
| task_plan.md | Created | Initial plan |
| findings.md | Created | Research findings |
```

---

## Example 2: Bug Fix Task

**User Request:** "Fix the authentication bug where users get randomly logged out"

### task_plan.md

```markdown
# Task Plan: Fix Random Logout Bug

## Goal
Identify and fix the bug causing users to be randomly logged out.

## Phases
- [x] Phase 1: Understand the symptoms ✓
- [x] Phase 2: Locate relevant code ✓
- [x] Phase 3: Identify root cause ✓
- [ ] Phase 4: Implement fix (CURRENT)
- [ ] Phase 5: Test and verify

## Key Questions
1. When does the logout happen? (timing, conditions)
2. Which component handles session management?
3. Are there relevant error logs?
4. What changed recently in auth code?

## Decisions Made
- Session handler is in `src/auth/session.ts`
- Root cause: Token refresh race condition
- Fix approach: Add mutex lock around token refresh

## Errors Encountered
- [Initial investigation] Couldn't reproduce locally
  → Solution: Found it only happens under load
- [First fix attempt] Added simple flag - didn't work
  → Race condition still occurred between check and set

## Status
**Currently in Phase 4** - Implementing mutex-based fix
```

### findings.md

```markdown
# Findings: Random Logout Bug

## Symptoms
- Users logged out mid-session
- Happens more frequently during peak hours
- No consistent reproduction steps

## Root Cause Analysis

### Session Flow
1. User makes request
2. Middleware checks token expiry
3. If expired, triggers refresh
4. Multiple concurrent requests can trigger multiple refreshes
5. Race condition: Second refresh invalidates first's new token

### The Bug
```
Request A: Token expired → Start refresh
Request B: Token expired → Start refresh (before A completes)
Request A: Gets new token T1, stores it
Request B: Gets new token T2, stores it (invalidates T1)
Request A: Continues with T1... but T1 is now invalid!
→ User logged out
```

## Solution
Implement mutex lock around token refresh:
- Only one refresh at a time
- Other requests wait for refresh to complete
- All requests use the same new token
```

---

## Example 3: Feature Development

**User Request:** "Add dark mode toggle to the settings page"

### The 3-File Pattern

**task_plan.md:**
```markdown
# Task Plan: Dark Mode Feature

## Goal
Add functional dark mode toggle to settings that persists user preference.

## Phases
- [x] Phase 1: Research existing theme system ✓
- [x] Phase 2: Design implementation approach ✓
- [ ] Phase 3: Implement toggle component (CURRENT)
- [ ] Phase 4: Add theme switching logic
- [ ] Phase 5: Style dark theme
- [ ] Phase 6: Test and polish

## Decisions Made
- Using CSS custom properties (already in place)
- Storing preference in localStorage
- Toggle component in SettingsPage.tsx
- Theme context for app-wide access

## Status
**Currently in Phase 3** - Building toggle component
```

**findings.md:**
```markdown
# Findings: Dark Mode Implementation

## Existing Theme System
- Location: `src/styles/theme.ts`
- Uses: CSS custom properties
- Current themes: light only
- Already has ThemeProvider but unused

## Files to Modify
1. `src/styles/theme.ts` - Add dark theme colors
2. `src/components/Settings/SettingsPage.tsx` - Add toggle
3. `src/contexts/ThemeContext.tsx` - Create context
4. `src/App.tsx` - Wrap with ThemeProvider

## Color Palette (Dark)
- Background: #1a1a2e
- Surface: #16213e
- Text primary: #eaeaea
- Text secondary: #a0a0a0
- Accent: #4f9cf9 (same as light)
```

**progress.md:**
```markdown
# Progress Log: Dark Mode

## Current Phase: 3
## Overall Status: In Progress

## Session Log

### Session 1
**Completed:**
- Researched existing theme.ts
- Found existing ThemeProvider (unused)
- Designed color palette for dark mode
- Planned file modifications

**Next:**
- Create ThemeContext with toggle function
- Build toggle component

## Files Changed
| File | Action | Notes |
|------|--------|-------|
| task_plan.md | Created | Initial plan |
| findings.md | Created | Research notes |
```

---

## Example 4: Error Recovery Pattern

When errors occur, document them—don't hide them.

### Wrong Approach (Don't Do This)

```
Action: Read config.json
Error: File not found

Action: Read config.json  # Silent retry - WRONG
Action: Read config.json  # Another retry - WRONG
```

### Correct Approach

```
Action: Read config.json
Error: File not found
```

Update task_plan.md:
```markdown
## Errors Encountered
- config.json not found
  → Will create default configuration file
  → Note: This might mean setup script wasn't run
```

Then proceed with a DIFFERENT action:
```
Action: Write config.json (with default values)
Action: Read config.json
Success!
```

---

## Example 5: Using with Agent-Architect

After establishing your plan, you can use `agent-architect` to design optimal tooling.

**task_plan.md exists with:**
- Multi-phase debugging task
- Findings about complex system
- Clear phase breakdown

**Then invoke agent-architect:**

The architect sees your planning files and recommends:
- A `debugger` subagent for isolated error analysis
- A `test-runner` subagent for verification
- CLAUDE.md additions based on your findings
- Hooks for automated test running

This is more powerful than generic configuration because it's informed by your specific task context.

---

## The Read-Before-Decide Pattern

**Critical for long tasks:**

```
[Many tool calls have happened...]
[Context is getting long...]
[Original goal might be forgotten...]

→ Read task_plan.md          # Brings goals back into attention!
→ Now make the decision       # Goals are fresh in context
```

This is why Manus can handle ~50 tool calls without losing track. The plan file acts as a "goal refresh" mechanism, combating the "lost in the middle" effect.

---

## Anti-Patterns to Avoid

### 1. Not Creating Files for "Simple" Tasks
If it turns out to be complex, you'll lose context. When in doubt, create the files.

### 2. Updating Files Too Infrequently
The 2-Action Rule exists for a reason. Don't wait until you've forgotten what you found.

### 3. Not Reading Before Decisions
"I remember the goal" is often wrong after many actions. Read the file.

### 4. Hiding Errors
Errors are valuable information. Document them. The next approach must be different.

### 5. Overly Detailed Plans
The plan should be scannable. Put details in findings.md, not task_plan.md.
