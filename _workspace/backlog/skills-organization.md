# Backlog: Skills Organization Enhancement

> Improve skills organization beyond source-based grouping.

---

## Goal

Enhance how skills are organized, indexed, and discovered beyond the current source-based approach.

## Current Organization

Skills are organized by **source** (who created them):
- `obra/` - Jesse Vincent's skills
- `anthropic/` - Official Anthropic skills
- `community/` - Other community skills

This works but doesn't help users find skills by **purpose**.

## Enhancement Ideas

### Purpose-Based Grouping

Organize by what the skill helps you do:
- Workflow & Planning (brainstorming, writing-plans, executing-plans)
- Development (TDD, debugging, code-review)
- Git & GitHub (commits, PRs, merges)
- Documents (docx, xlsx, pdf, pptx)
- Testing (webapp-testing, etc.)

### Cross-References

Skills that work well together:
- "If you use X, also consider Y"
- Skill combinations for common workflows
- Prerequisites and dependencies

### Enhanced CATALOG.md

Richer metadata:
- Tags/categories
- Complexity level
- Use cases
- Related skills

### When-to-Use Guidance

For each skill:
- Ideal scenarios
- Comparison with similar skills
- Example invocations

## Trade-offs

### Keep Source-Based
**Pros**: Simple, clear provenance, easy to update from upstream
**Cons**: Hard to find skills by purpose

### Add Purpose-Based
**Pros**: Better discoverability, helps users find what they need
**Cons**: More maintenance, might conflict with source grouping

### Hybrid Approach
Have both views:
- Physical organization by source (for maintenance)
- Virtual organization by purpose (in CATALOG.md or separate index)

## Implementation Options

1. **Enhance CATALOG.md** - Add categories, tags, use-case sections
2. **Create purpose index** - Separate file organizing skills by goal
3. **Add to purpose-navigation** - Part of broader intent-based navigation

## Connection to Other Deferred Work

- Closely related to `purpose-navigation.md` - both enhance discoverability
- Should be consistent with how plugins are organized
- Informs `external-expansion.md` - how to categorize new skills

## Quality Standards

Any enhancement should:
- Not break existing organization
- Be maintainable as skills change
- Actually help users find what they need
- Not create duplicate information that can drift

---

## Status

DEFERRED - Current organization works; enhance after base is stable.
