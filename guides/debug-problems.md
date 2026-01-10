# Debug and Fix Problems

> Systematically diagnose issues, find root causes, and verify fixes with confidence.

---

## When to Use This

Something is broken and you need to fix it. This could be a runtime error, unexpected behavior, a failing test, or a mysterious bug that only appears in certain conditions. Use these resources when you need a methodical approach to debugging rather than trial-and-error.

## Quick Start

1. Run `/systematic-debugging` to activate structured debugging methodology
2. Use `/context-introspection:report` to see what context Claude has loaded (catches missing info)
3. Apply `/verification-before-completion` before declaring the fix complete

---

## Resources

### Primary Tools

| Resource | Type | Location | Why |
|----------|------|----------|-----|
| systematic-debugging | Skill | `library/skills/core-skills/obra-development/systematic-debugging/` | Methodical debugging: reproduce, isolate, hypothesize, test, fix |
| context-introspection | Plugin (local) | `library/plugins/local/context-introspection/` | See exactly what context is loaded in your session - catches when Claude is missing critical files |
| pr-review-toolkit (silent-failure-hunter) | Plugin (official) | `library/plugins/official/CATALOG.md` | Find hidden errors: swallowed exceptions, missing error handling, silent failures |
| claude-code-advisor (cc-troubleshooter) | Plugin (local) | `library/plugins/local/claude-code-advisor/` | Specialized agent for Claude Code-specific issues and configuration problems |

### Supporting Resources

| Resource | Type | Location | Why |
|----------|------|----------|-----|
| verification-before-completion | Skill | `library/skills/core-skills/obra-development/verification-before-completion/` | Validate fixes actually work before marking done - prevents regression |

### Documentation

| Doc | Location | When to Read |
|-----|----------|--------------|
| The "think" Tool | `docs/best-practices/think-tool-blog.md` | When debugging complex issues requiring deep reasoning and multi-step analysis |

---

## Recommended Workflow

1. **Reproduce the issue** - Use `/systematic-debugging` to establish a reliable reproduction case
2. **Check your context** - Run `/context-introspection:report` to ensure Claude has all relevant files loaded
3. **Hunt for hidden failures** - Use the silent-failure-hunter from pr-review-toolkit to find swallowed errors
4. **Form and test hypotheses** - Systematic debugging guides you through hypothesis-driven investigation
5. **Apply the fix** - Make targeted changes based on confirmed root cause
6. **Verify thoroughly** - Use `/verification-before-completion` to confirm the fix works and doesn't break other things
7. **For Claude-specific issues** - Use cc-troubleshooter agent when the problem involves Claude Code configuration or behavior

---

## Related Intents

- [improve-quality.md](improve-quality.md) - Add tests and guards to prevent similar bugs
- [learn-claude-code.md](learn-claude-code.md) - Understand Claude Code features to debug configuration issues
