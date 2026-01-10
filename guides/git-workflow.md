# Git/GitHub Workflow

> Streamline your Git operations from commits to pull requests with automated commands and best practices.

---

## When to Use This

Use this pathway when working with version control: creating commits with good messages, opening pull requests, reviewing and merging PRs, or managing multiple parallel work streams with worktrees. These resources help you maintain clean Git history and efficient GitHub collaboration.

## Quick Start

1. **Quick commit**: Run `/commit` from the commit-commands plugin for conventional commit messages
2. **Full workflow**: Run `/commit-push-pr` to commit, push, and create a PR in one command
3. **For complex PRs**: Use the github-pr-creation skill for detailed PR descriptions

---

## Resources

### Primary Tools

| Resource | Type | Location | Why |
|----------|------|----------|-----|
| commit-commands | Plugin (official) | [library/plugins/official/CATALOG.md](../library/plugins/official/CATALOG.md) | /commit and /commit-push-pr commands for fast workflows |
| git-commit | Skill | [library/skills/core-skills/git-workflow/fvadicamo-dev-agent/git-commit/](../library/skills/core-skills/git-workflow/fvadicamo-dev-agent/git-commit/) | Conventional commit message formatting |
| github-pr-creation | Skill | [library/skills/core-skills/git-workflow/fvadicamo-dev-agent/github-pr-creation/](../library/skills/core-skills/git-workflow/fvadicamo-dev-agent/github-pr-creation/) | Create well-structured pull requests |
| github-pr-review | Skill | [library/skills/core-skills/git-workflow/fvadicamo-dev-agent/github-pr-review/](../library/skills/core-skills/git-workflow/fvadicamo-dev-agent/github-pr-review/) | Conduct thorough PR reviews |

### Supporting Resources

| Resource | Type | Location | Why |
|----------|------|----------|-----|
| github-pr-merge | Skill | [library/skills/core-skills/git-workflow/fvadicamo-dev-agent/github-pr-merge/](../library/skills/core-skills/git-workflow/fvadicamo-dev-agent/github-pr-merge/) | Merge PRs following best practices |
| finishing-a-development-branch | Skill | [library/skills/core-skills/obra-development/finishing-a-development-branch/](../library/skills/core-skills/obra-development/finishing-a-development-branch/) | Complete branch work cleanly before merge |
| using-git-worktrees | Skill | [library/skills/core-skills/obra-development/using-git-worktrees/](../library/skills/core-skills/obra-development/using-git-worktrees/) | Work on multiple branches simultaneously |

### Documentation

| Doc | Location | When to Read |
|-----|----------|--------------|
| GitHub Actions | [docs/cicd-automation/github-actions.md](../docs/cicd-automation/github-actions.md) | Setting up CI/CD for your PRs |
| CLI Reference | [docs/reference/cli-reference.md](../docs/reference/cli-reference.md) | Understanding built-in Git-related commands |

---

## Recommended Workflow

1. **Make changes**: Develop your feature on a dedicated branch
2. **Stage and commit**: Use git-commit skill or `/commit` for conventional commit messages
3. **Review your work**: Use finishing-a-development-branch skill to ensure completeness
4. **Create PR**: Use github-pr-creation skill or `/commit-push-pr` for the full workflow
5. **Review others' PRs**: Apply github-pr-review skill for thorough reviews
6. **Merge**: Use github-pr-merge skill to complete the PR lifecycle

### For Parallel Work

1. **Set up worktrees**: Use using-git-worktrees skill to work on multiple features simultaneously
2. **Manage independently**: Each worktree maintains its own working state
3. **Finish each branch**: Apply finishing-a-development-branch before merging each worktree's work

---

## Related Intents

- [improve-quality.md](improve-quality.md) - For code review before merging your PRs
- [start-feature.md](start-feature.md) - When beginning new feature development that will need Git workflow
