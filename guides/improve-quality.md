# Improve Code Quality

> Leverage automated reviews, security scanning, and development best practices to write better code.

---

## When to Use This

Use this pathway when you want to improve code before merging, catch security issues early, or establish quality-focused development practices. Whether you're preparing a PR for review, processing feedback from teammates, or adopting test-driven development, these resources help ensure your code meets high standards.

## Quick Start

1. **Before submitting a PR**: Run `/cc-review` from the code-review plugin to get automated feedback
2. **Process the feedback**: Use the receiving-code-review skill to systematically address comments
3. **Final check**: Apply verification-before-completion skill before marking work done

---

## Resources

### Primary Tools

| Resource | Type | Location | Why |
|----------|------|----------|-----|
| code-review | Plugin (official) | [library/plugins/official/CATALOG.md](../library/plugins/official/CATALOG.md) | Automated PR review with actionable feedback |
| pr-review-toolkit | Plugin (official) | [library/plugins/official/CATALOG.md](../library/plugins/official/CATALOG.md) | 6 specialized review agents for deep analysis |
| security-guidance | Plugin (official) | [library/plugins/official/CATALOG.md](../library/plugins/official/CATALOG.md) | Security patterns and vulnerability detection |
| test-driven-development | Skill | [library/skills/core-skills/obra-development/test-driven-development/](../library/skills/core-skills/obra-development/test-driven-development/) | TDD workflow for building quality in from the start |

### Supporting Resources

| Resource | Type | Location | Why |
|----------|------|----------|-----|
| requesting-code-review | Skill | [library/skills/core-skills/obra-development/requesting-code-review/](../library/skills/core-skills/obra-development/requesting-code-review/) | Prepare and initiate effective code reviews |
| receiving-code-review | Skill | [library/skills/core-skills/obra-development/receiving-code-review/](../library/skills/core-skills/obra-development/receiving-code-review/) | Process feedback constructively and systematically |
| verification-before-completion | Skill | [library/skills/core-skills/obra-development/verification-before-completion/](../library/skills/core-skills/obra-development/verification-before-completion/) | Pre-completion checklist to catch issues early |

### Documentation

| Doc | Source | When to Read |
|-----|--------|--------------|
| Claude Code Best Practices | [anthropic.com/engineering](https://www.anthropic.com/engineering/claude-code-best-practices) | Understanding quality patterns in agentic coding |
| Writing Tools for Agents | [anthropic.com/engineering](https://www.anthropic.com/engineering/writing-tools-for-agents) | When building tools that need to be maintainable |

> **Tip**: See [docs/best-practices/](../docs/best-practices/) for a full index with summaries.

---

## Recommended Workflow

1. **Adopt TDD early**: Use test-driven-development skill when starting new features to build quality in from the beginning
2. **Run automated review**: Before requesting human review, run the code-review plugin to catch obvious issues
3. **Security scan**: Use security-guidance plugin to identify potential vulnerabilities
4. **Request review**: Use requesting-code-review skill to prepare a clear, reviewable PR
5. **Process feedback**: Apply receiving-code-review skill to systematically address all comments
6. **Final verification**: Before completing, run verification-before-completion checklist
7. **Deep analysis (optional)**: For critical code, use pr-review-toolkit's specialized agents

---

## Related Intents

- [debug-problems.md](debug-problems.md) - When code review reveals bugs that need systematic debugging
- [git-workflow.md](git-workflow.md) - For creating quality commits and managing PRs effectively
