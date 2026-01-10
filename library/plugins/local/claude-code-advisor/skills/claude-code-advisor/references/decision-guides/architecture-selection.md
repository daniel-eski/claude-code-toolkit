# Architecture Selection: Complete Decision Framework

A comprehensive guide for choosing the right Claude Code features.

## Master Decision Flowchart

```
START: What capability do you need?
│
├─ KNOWLEDGE/GUIDANCE
│  │
│  └─ Needed every session?
│     ├─YES─▶ CLAUDE.md
│     └─NO──▶ Only for certain files?
│             ├─YES─▶ PATH RULES (.claude/rules/)
│             └─NO──▶ SKILL
│
├─ TRIGGER SPECIFIC ACTION
│  │
│  └─ Should Claude auto-detect?
│     ├─YES─▶ SKILL (with good description)
│     └─NO──▶ SLASH COMMAND (explicit /trigger)
│
├─ ISOLATED PROCESSING
│  │
│  └─ Needs specialized knowledge?
│     ├─YES─▶ SUBAGENT + SKILL (Isolated Expert)
│     └─NO──▶ SUBAGENT alone
│
├─ AUTOMATIC VALIDATION/REACTION
│  │
│  └─ When should it happen?
│     ├─ Before tool runs ─▶ PreToolUse HOOK
│     ├─ After tool runs ──▶ PostToolUse HOOK
│     ├─ On user prompt ───▶ UserPromptSubmit HOOK
│     └─ Session lifecycle ─▶ SessionStart/End HOOK
│
└─ EXTERNAL TOOLS/DATA
   │
   └─ Need knowledge for using tools?
      ├─YES─▶ MCP + SKILL (Tool Teacher pattern)
      └─NO──▶ MCP alone
```

## Quick Reference Table

| Need | Primary Feature | Combine With |
|------|-----------------|--------------|
| Always-present standards | CLAUDE.md | - |
| File-type-specific rules | Path Rules | - |
| Domain expertise | Skill | Subagent for heavy work |
| Explicit user action | Slash Command | Skill for guidance |
| Heavy isolated work | Subagent | Skill for knowledge |
| Automatic validation | Hook (Pre) | Subagent for complex logic |
| Auto-react to changes | Hook (Post) | - |
| External tools | MCP | Skill for usage patterns |

## Common Architecture Patterns

### 1. Foundation Only
```
CLAUDE.md: Project standards
```
Use when: Simple project, just needs basic context.

### 2. Standards + Expertise
```
CLAUDE.md: Standards
Skill: Domain expertise (auto-triggers)
```
Use when: Need situational knowledge beyond basics.

### 3. Layered Context
```
CLAUDE.md: Global standards
Path Rules: File-type-specific rules
Skill: Deep domain expertise
```
Use when: Different rules for different parts of codebase.

### 4. Isolated Expert
```
Subagent: Context isolation
└── Pre-loaded Skill: Domain knowledge
```
Use when: Heavy work needs expertise but shouldn't bloat main context.

### 5. Event-Triggered Specialist
```
Hook: Detects event (PostToolUse)
└── Spawns Subagent: Complex analysis
```
Use when: Automatic quality gates with deep reasoning.

### 6. Tool Teacher
```
MCP: Provides database tools
Skill: Teaches query patterns
```
Use when: External tools need usage guidance.

### 7. Full Stack
```
CLAUDE.md: Foundation
Path Rules: Targeted rules
Skills: Domain expertise
Hooks: Automatic validation
Subagents: Heavy tasks
MCP: External integrations
```
Use when: Complex project with many needs.

## Feature Selection Matrix

| Scenario | Recommended |
|----------|-------------|
| New team member onboarding | CLAUDE.md with standards |
| Code review automation | Skill (auto-triggers) or Command (/review) |
| Security scanning | Subagent + security skill |
| Auto-format on save | PostToolUse hook |
| Database integration | MCP + query patterns skill |
| API development rules | Path rules (src/api/**) |
| Deployment workflow | Slash command (/deploy) |
| Complex refactoring | Subagent (isolated context) |

## Decision Checklist

Before finalizing architecture, verify:

- [ ] CLAUDE.md is minimal (only always-needed content)
- [ ] Skills have clear, trigger-rich descriptions
- [ ] Heavy work uses subagents (context isolation)
- [ ] Hooks are lightweight (complex logic → subagent)
- [ ] Path rules target specific file patterns
- [ ] Commands are for explicit user actions
- [ ] MCP tools have accompanying skill guidance

## Starting Point Recommendation

For most projects, start with:

1. **CLAUDE.md**: Essential project context
2. **One skill**: Primary domain expertise
3. **Add more as needed**: Don't over-engineer initially

Then evolve based on actual needs:
- Add path rules when different areas need different rules
- Add subagents when heavy tasks bloat context
- Add hooks when automation becomes necessary

See also:
- Individual decision guides in this directory
- `../patterns/composition-patterns.md` for pattern details
- `../patterns/anti-patterns.md` for what to avoid
