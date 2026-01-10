# Backlog: Additional Local Copies

> Consider adding local copies of frequently-referenced external content.

---

## Goal

Evaluate whether certain external content should be stored locally for:
- Offline access
- Faster reference
- Full-text search within the repo
- Protection against link rot

## Current Approach

The repository uses **pointer-first** design:
- Default to indexes with links
- Local copies only for owned content

This is intentional - keeps the repo lean and reduces maintenance burden.

## When Local Copies Make Sense

Consider local copies when:
- Content is referenced very frequently
- Offline access is important
- Content is stable (doesn't change often)
- Link rot is a concern

Avoid local copies when:
- Content changes frequently (will get stale)
- Source is reliable and always accessible
- Duplication adds maintenance burden

## Content Available in Old Repo

From `12-best-practices/`:
- claude-code-best-practices.md
- building-effective-agents.md
- context-engineering.md
- multi-agent-research-system.md
- writing-tools-for-agents.md
- think-tool.md
- claude-4-prompting.md
- prompt-engineering-overview.md
- tool-use-overview.md

From `01-10/` folders:
- 49 official Claude Code documentation files

## Evaluation Criteria

For each piece of content, consider:

| Factor | Weight |
|--------|--------|
| Frequency of reference | High |
| Stability of source | Medium |
| Offline access need | Medium |
| Search-ability benefit | Low |

## Trade-offs

### Benefits of Local Copies
- Works offline
- Searchable in repo
- Won't disappear
- Can annotate/enhance

### Costs of Local Copies
- Gets stale over time
- Maintenance overhead
- Storage size
- Sync tracking needed

## Suggested Process

1. **Track usage** - Note what gets referenced frequently during development
2. **Evaluate candidates** - Apply criteria above
3. **Copy selectively** - Only what truly benefits
4. **Track freshness** - Use .source files like skills do

## Source Tracking Pattern

If we add local copies, use the `.source` file pattern:
```yaml
source_url: https://anthropic.com/engineering/...
fetched_at: 2026-01-XX
content_hash: [for change detection]
```

This enables freshness checking.

---

## Status

DEFERRED - Evaluate based on actual usage patterns during implementation.
