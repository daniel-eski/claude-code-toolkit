---
name: workflow-reflection
description: >
  Analyzes completed work sessions and generates Claude Code workflow optimizations.
  Identifies friction points, missing context, and repeated patterns. Produces
  actionable recommendations for CLAUDE.md additions, custom commands, skills,
  and automation hooks. Activates when discussing session retrospectives,
  workflow improvements, capturing learnings, or optimizing future similar tasks.
allowed-tools: Read, Glob, Grep
---

# Workflow Reflection

Analyze the current session to identify optimization opportunities and generate actionable recommendations.

## Instructions

### Step 1: Session Retrospective
- What was the main task and outcome?
- Which files were touched (read, modified, created)?
- What tools and approaches were used?
- How many iterations or corrections were needed?

### Step 2: Identify Friction Points
- Missing context or documentation that slowed progress
- Repetitive actions that could be automated
- Incorrect assumptions requiring correction
- Patterns not discoverable from codebase

### Step 3: Generate Recommendations
For each identified issue, produce a specific optimization:
- **Type**: CLAUDE.md | Command | Skill | Hook
- **Scope**: User-level (`~/.claude/`) or Project-level (`.claude/`)
- **Rationale**: How it addresses the friction
- **Implementation**: Complete, copy-ready file content

See [reference.md](reference.md) for detailed documentation of each optimization type.
See [examples.md](examples.md) for concrete recommendation examples.

## Output Format

```
### Session Summary
[1-2 sentences: what was accomplished]

### What Worked Well
- [Effective approaches to preserve]

### Friction Points
- [Specific inefficiencies encountered]

### Recommended Optimizations

#### 1. [Name]
- **Type**: [CLAUDE.md | Command | Skill | Hook]
- **Scope**: [User-level | Project-level]
- **Rationale**: [Why this helps]
- **Implementation**:
\`\`\`
[Complete file content]
\`\`\`

### Priority Order
[Rank by impact/effort ratio]
```

## Best Practices
- Only recommend optimizations with clear, repeatable value
- Prefer simple solutions over elaborate configurations
- Consider user-level (personal) vs project-level (team-shared) scope
- Only suggest hooks for genuinely automatable checks
