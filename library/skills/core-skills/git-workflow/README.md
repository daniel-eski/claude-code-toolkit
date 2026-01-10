# Git Workflow Skills

Git and GitHub automation skills from [fvadicamo/dev-agent-skills](https://github.com/fvadicamo/dev-agent-skills).

## Skills

| Directory | Skill | Description |
|-----------|-------|-------------|
| fvadicamo-dev-agent/git-commit | git-commit | Conventional Commits format |
| fvadicamo-dev-agent/github-pr-creation | github-pr-creation | Create pull requests |
| fvadicamo-dev-agent/github-pr-merge | github-pr-merge | Merge pull requests |
| fvadicamo-dev-agent/github-pr-review | github-pr-review | Review pull requests |
| fvadicamo-dev-agent/creating-skills | creating-skills | Guide for creating Claude Code skills |
| changelog-generator | changelog-generator | Transform git commits into release notes (placeholder) |

## Conventional Commits

The git-commit skill follows [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`

## PR Workflow

1. **Create**: `github-pr-creation` - Opens PR with proper formatting
2. **Review**: `github-pr-review` - Reviews PR code and provides feedback
3. **Merge**: `github-pr-merge` - Merges PR following best practices

## Note

The `changelog-generator` from ComposioHQ was not accessible and has a placeholder.
