# Claude Code Advisor - Project Context

> **This document is the single source of truth for the claude-code-advisor plugin.**
> Read this FIRST before doing any implementation work.
> This document is IMMUTABLE - do not modify after initial creation.

---

## What We're Building

A comprehensive Claude Code advisor plugin that helps Claude deeply understand its own extensibility features (skills, subagents, hooks, memory, commands, MCP) and make informed architectural recommendations for users.

The core novel value is the **decision layer** - synthesized knowledge about *when* to use each feature, *why* one is better than another for specific use cases, and especially *how* to combine them effectively. This meta-knowledge doesn't exist in any current skill or documentation in a synthesized, actionable form.

The plugin uses **progressive disclosure** to avoid context bloat: a strategic SKILL.md loads first, then specific reference files load on-demand, and specialized subagents handle heavy tasks in isolated contexts.

---

## Why This Matters

**The Problem**: Claude Code has many powerful extensibility features, but Claude itself often struggles with:
- Understanding how its own features work at an operational level
- Knowing when to use each feature (skills vs subagents vs hooks, etc.)
- Combining features effectively for user goals
- Following best practices when generating configuration files
- Knowing where to find authoritative documentation

**The Solution**: A skill that embodies this decision-making knowledge and:
1. Provides mental models for how Claude Code works as a system
2. Guides feature selection with comparison matrices and decision trees
3. Offers composition patterns for combining features
4. Points to authoritative sources for implementation details
5. Dispatches specialized subagents for verification, analysis, and generation

---

## Architecture Decisions (Final)

These decisions were made with the user and should not be changed:

| Decision | Choice | Rationale |
|----------|--------|-----------|
| **Plugin location** | `11-external-resources/plugins/claude-code-advisor/` | Keeps plugin separate from docs |
| **Structure** | Plugin bundling skill + agents + commands | Need to distribute subagents with the skill |
| **Subagent models** | Opus for complex synthesis, Sonnet for focused extraction | Balance quality and cost |
| **Doc handling** | Curate and save locally, verify with subagent | Enables offline use, tracks versions |
| **Priority** | Quality over speed | Sequential review, max 2 parallel subagents |
| **Handoff system** | Three documents: _PROJECT-CONTEXT, _PROGRESS, _HANDOFF-GUIDE | Clean separation of static vs dynamic content |

---

## Complete File Tree

```
claude-code-advisor/
│
├── _PROJECT-CONTEXT.md          # This file - immutable project context
├── _PROGRESS.md                 # Dynamic progress tracking
├── _HANDOFF-GUIDE.md            # Instructions for new agents
├── CLAUDE.md                    # Claude Code agent instructions
│
├── .claude-plugin/
│   └── plugin.json              # Plugin manifest (~100 tokens)
│
├── skills/
│   └── claude-code-advisor/
│       │
│       ├── SKILL.md             # Strategic layer (~2500 tokens)
│       │                         # - Mental model of Claude Code
│       │                         # - Feature relationship map
│       │                         # - Design principles
│       │                         # - Subagent dispatch guidance
│       │                         # - Navigation index
│       │
│       └── references/
│           │
│           ├── INDEX.md         # Master navigation (~800 tokens)
│           │                     # - "Read X when Y" conditional guide
│           │
│           ├── system-understanding/
│           │   ├── context-architecture.md    (~1200 tokens)
│           │   │   # Context window mechanics, token competition
│           │   ├── execution-model.md         (~1000 tokens)
│           │   │   # Agentic loop, tool flow, hook injection
│           │   └── feature-interactions.md    (~1500 tokens)
│           │       # How features compose, context sharing models
│           │
│           ├── feature-mechanics/
│           │   ├── skills-deep-dive.md        (~1500 tokens)
│           │   │   # 3-level loading, discovery, activation
│           │   ├── subagents-deep-dive.md     (~1400 tokens)
│           │   │   # Context isolation, information flow
│           │   ├── hooks-deep-dive.md         (~1200 tokens)
│           │   │   # Event lifecycle, matchers, outputs
│           │   ├── memory-deep-dive.md        (~1100 tokens)
│           │   │   # CLAUDE.md hierarchy, path-specific rules
│           │   ├── commands-deep-dive.md      (~800 tokens)
│           │   │   # Built-in vs custom, $ARGUMENTS
│           │   └── mcp-deep-dive.md           (~900 tokens)
│           │       # Server types, scopes, tool availability
│           │
│           ├── decision-guides/
│           │   ├── skills-vs-subagents.md     (~1000 tokens)
│           │   ├── skills-vs-commands.md      (~700 tokens)
│           │   ├── memory-vs-skills.md        (~800 tokens)
│           │   ├── hooks-usage-guide.md       (~900 tokens)
│           │   └── architecture-selection.md  (~1200 tokens)
│           │       # Full decision flowchart
│           │
│           ├── patterns/
│           │   ├── composition-patterns.md    (~1500 tokens)
│           │   │   # Feature amplification patterns
│           │   ├── anti-patterns.md           (~1200 tokens)
│           │   │   # What NOT to do
│           │   ├── workflow-patterns.md       (~1100 tokens)
│           │   │   # Explore→Plan→Code→Commit, TDD
│           │   └── architecture-examples.md   (~1400 tokens)
│           │       # Real-world configurations
│           │
│           ├── implementation/
│           │   ├── skill-authoring.md         (~1300 tokens)
│           │   ├── subagent-design.md         (~1100 tokens)
│           │   ├── hook-implementation.md     (~900 tokens)
│           │   └── plugin-structure.md        (~1000 tokens)
│           │
│           └── source-documentation/
│               ├── SOURCE-REGISTRY.md         (~600 tokens)
│               │   # Master index with URLs and dates
│               ├── cc-skills-reference.md     (~1200 tokens)
│               ├── cc-subagents-reference.md  (~1100 tokens)
│               ├── cc-hooks-reference.md      (~900 tokens)
│               ├── cc-memory-reference.md     (~800 tokens)
│               ├── platform-skills-overview.md      (~1000 tokens)
│               ├── platform-skills-best-practices.md (~1200 tokens)
│               └── engineering-best-practices.md    (~900 tokens)
│
├── agents/
│   ├── cc-understanding-verifier.md   (~500 tokens)
│   │   # Verify understanding against current docs
│   │   # Tools: WebFetch, Read, Grep | Model: haiku
│   ├── cc-config-analyzer.md          (~600 tokens)
│   │   # Analyze existing Claude Code configurations
│   │   # Tools: Read, Glob, Grep | Model: sonnet
│   ├── cc-deep-researcher.md          (~550 tokens)
│   │   # Deep research on complex topics
│   │   # Tools: WebFetch, WebSearch, Read | Model: sonnet
│   ├── cc-architecture-designer.md    (~600 tokens)
│   │   # Design feature combinations for goals
│   │   # Tools: Read, Glob, Grep, Write | Model: sonnet
│   │   # Skills: claude-code-advisor
│   ├── cc-file-generator.md           (~500 tokens)
│   │   # Generate configuration files
│   │   # Tools: Read, Write | Model: sonnet
│   └── cc-implementation-reviewer.md  (~550 tokens)
│       # Review generated configs for issues
│       # Tools: Read, Glob | Model: sonnet
│
├── commands/
│   ├── cc-advisor.md       (~200 tokens) # /cc-advisor - Main entry
│   ├── cc-analyze.md       (~200 tokens) # /cc-analyze - Review setup
│   ├── cc-verify.md        (~200 tokens) # /cc-verify - Check understanding
│   └── cc-design.md        (~200 tokens) # /cc-design - Design architecture
│
└── docs/
    ├── README.md
    ├── INSTALLATION.md
    ├── USAGE-GUIDE.md
    └── CHANGELOG.md
```

---

## Mental Models

### Claude Code as a System

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    CLAUDE CODE RUNTIME                                   │
│                                                                          │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                   MAIN CONTEXT WINDOW                            │   │
│  │   (Shared resource - everything competes for space)              │   │
│  │                                                                  │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐           │   │
│  │  │ System Prompt│  │ CLAUDE.md    │  │ Conversation │           │   │
│  │  │ (fixed)      │  │ (always)     │  │ History      │           │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘           │   │
│  │                                                                  │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐           │   │
│  │  │ All Skill    │  │ Active Skill │  │ Path Rules   │           │   │
│  │  │ Metadata     │  │ Body (when   │  │ (when file   │           │   │
│  │  │ (names+desc) │  │ triggered)   │  │ matches)     │           │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘           │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                          │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │              SUBAGENT CONTEXTS (Isolated)                        │   │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐             │   │
│  │  │Explore  │  │Plan     │  │General  │  │Custom   │             │   │
│  │  │(haiku)  │  │(sonnet) │  │Purpose  │  │Agents   │             │   │
│  │  └─────────┘  └─────────┘  └─────────┘  └─────────┘             │   │
│  │  • Separate context window for each                              │   │
│  │  • Only receives what's passed to it                             │   │
│  │  • Returns summary to main conversation                          │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                          │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                    EVENT HOOKS                                   │   │
│  │  PreToolUse → [Tool Execution] → PostToolUse                     │   │
│  │  UserPromptSubmit → SessionStart → Notification → Stop           │   │
│  │  • Run automatically on events                                   │   │
│  │  • Can modify, block, or allow tool calls                        │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                          │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                    MCP SERVERS                                   │   │
│  │  • External tools available via Model Context Protocol           │   │
│  │  • HTTP, SSE, or stdio transports                                │   │
│  │  • Tool availability, not knowledge injection                    │   │
│  └─────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────┘
```

**Key Insight**: The main context window is a SHARED RESOURCE. Everything competes for space:
- System prompt (fixed, ~2-3k tokens)
- CLAUDE.md (always loaded)
- All skill metadata (~100 tokens per skill)
- Active skill body (when triggered, <5k recommended)
- Conversation history (grows over session)

**Subagents have ISOLATED context** - this is the critical differentiator. They don't pollute the main conversation and can do heavy work without context bloat.

### Feature Relationship Map

```
                            INVOCATION MODEL
                    ┌───────────────────────────────┐
                    │                               │
        Always      │   Model         User          │   Event
        Loaded      │   Invoked       Explicit      │   Driven
            │       │       │             │         │       │
            ▼       │       ▼             ▼         │       ▼
    ┌───────────┐   │   ┌───────┐   ┌─────────┐    │   ┌───────┐
    │ CLAUDE.md │   │   │Skills │   │Commands │    │   │ Hooks │
    │ + Rules   │   │   │       │   │         │    │   │       │
    └───────────┘   │   └───────┘   └─────────┘    │   └───────┘
                    │       │             │         │       │
                    │       │             │         │       │
                    │       ▼             │         │       │
                    │   ┌───────────────┐ │         │       │
                    │   │  Subagents    │◄┘         │       │
                    │   │  (isolated)   │           │       │
                    │   └───────────────┘           │       │
                    │                               │       │
                    └───────────────────────────────┘       │
                                    │                       │
                                    ▼                       │
                            ┌─────────────┐                 │
                            │ MCP Servers │ ◄───────────────┘
                            │ (tools)     │   Can be monitored
                            └─────────────┘   by hooks


                         CONTEXT SHARING MODEL

    ┌──────────────────┬────────────────────┬──────────────────┐
    │   SHARED WITH    │    ISOLATED FROM   │   NOT APPLICABLE │
    │   MAIN CONTEXT   │    MAIN CONTEXT    │                  │
    ├──────────────────┼────────────────────┼──────────────────┤
    │ CLAUDE.md        │ Subagents          │ Hooks            │
    │ Path rules       │                    │ MCP              │
    │ Skills (active)  │                    │                  │
    │ Slash Commands   │                    │                  │
    └──────────────────┴────────────────────┴──────────────────┘
```

### Progressive Disclosure Architecture

```
USER REQUEST
    │
    ▼
┌─────────────────────────────────────────────────────────────┐
│ SKILL.MD (Strategic Layer)                                   │
│ ~2500 tokens loaded when skill triggers                      │
│                                                              │
│ Contains:                                                    │
│ • Mental model overview                                      │
│ • Feature relationship summary                               │
│ • Design principles                                          │
│ • Navigation index → "Read X when Y"                         │
│ • Subagent dispatch guidance                                 │
└─────────────────────────────────────────────────────────────┘
    │
    │ Navigates to specific reference based on need
    ▼
┌─────────────────────────────────────────────────────────────┐
│ REFERENCE FILES (Knowledge Layer)                            │
│ ~800-1500 tokens each, loaded on-demand                      │
│                                                              │
│ Options:                                                     │
│ • system-understanding/* - How things work                   │
│ • feature-mechanics/*    - Deep dives per feature            │
│ • decision-guides/*      - When to use what                  │
│ • patterns/*             - How to combine                    │
│ • implementation/*       - How to build                      │
│ • source-documentation/* - Authoritative excerpts            │
└─────────────────────────────────────────────────────────────┘
    │
    │ Spawns for heavy lifting (isolated context)
    ▼
┌─────────────────────────────────────────────────────────────┐
│ SUBAGENTS (Execution Layer)                                  │
│ Isolated context, returns summary                            │
│                                                              │
│ Available:                                                   │
│ • cc-understanding-verifier - Check against current docs     │
│ • cc-config-analyzer        - Review existing setup          │
│ • cc-deep-researcher        - Multi-source synthesis         │
│ • cc-architecture-designer  - Design for goals               │
│ • cc-file-generator         - Create configs                 │
│ • cc-implementation-reviewer - Quality gate                  │
└─────────────────────────────────────────────────────────────┘
```

---

## Key Research Insights

From extensive research of official documentation:

### Skills Mechanics
1. Skills use **3-level loading**: metadata (always) → body (triggered) → resources (on-demand)
2. Metadata costs ~100 tokens per skill - you can have many skills without penalty
3. Skill body recommended under 500 lines / 5000 tokens
4. Skills are **filesystem-based** - Claude reads them via bash commands
5. Description field is CRITICAL for discovery - must include "when to use" triggers
6. Descriptions must be **third-person voice** ("Processes PDFs" not "I process PDFs")
7. Resources (scripts, templates) are EXECUTED, not loaded into context
8. References should be **one level deep** - no nested chains

### Subagents Mechanics
1. Subagents have **ISOLATED context** - this is the key differentiator from skills
2. Information flows TO subagents via the prompt/passed context
3. Information flows FROM subagents via return value only
4. Built-in subagents: Explore (haiku), Plan (sonnet), general-purpose (all tools)
5. Custom subagents can have: different model, restricted tools, pre-loaded skills
6. Subagents CAN have skills pre-loaded via `skills:` field in config
7. Subagents CANNOT spawn other subagents (main conversation orchestrates)
8. Subagents can be **resumed** with their full context preserved

### Hooks Mechanics
1. Hooks run at specific events: PreToolUse, PostToolUse, UserPromptSubmit, etc.
2. Hooks operate OUTSIDE the conversation (pre/post processing)
3. PreToolUse hooks can **block or modify** tool calls
4. Hooks should be **lightweight** - complex logic should spawn subagents
5. Hook output format controls behavior (exit codes, JSON responses)
6. Hooks can be command-based or prompt-based

### Memory/CLAUDE.md Mechanics
1. Memory hierarchy: Enterprise → Project → User → Local
2. Higher levels override lower levels on conflict
3. CLAUDE.md is **always loaded** - put only essential content there
4. Path-specific rules (`.claude/rules/`) activate based on file paths
5. Import syntax allows referencing other files
6. "Every session?" test: If yes → CLAUDE.md; If no → Skill

### Slash Commands
1. Commands are **user-explicit** triggers (unlike skills which auto-trigger)
2. Use `$ARGUMENTS` placeholder for parameters
3. Commands share the main context (unlike subagents)
4. Best for: repeatable prompts, explicit user control

### MCP
1. MCP provides **tool availability**, not knowledge
2. Three transport types: HTTP, SSE, stdio
3. Three scopes: local (project), project (shared via .mcp.json), user (global)
4. Plugin MCP servers auto-start when plugin is enabled

---

## Pattern Discoveries

### Composition Patterns (How Features Amplify Each Other)

**Pattern 1: Isolated Expert (Subagent + Skills)**
```yaml
# .claude/agents/security-reviewer.md
---
name: security-reviewer
skills: owasp-top-10, secure-coding-patterns
model: sonnet
---
```
- Subagent provides context isolation
- Skills provide specialized knowledge
- Result: Deep expertise without polluting main conversation

**Pattern 2: Event-Triggered Specialist (Hook + Subagent)**
```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{ "type": "prompt", "prompt": "Evaluate if security review needed..." }]
    }]
  }
}
```
- Hook detects relevant events
- Complex analysis delegated to subagent
- Result: Automated quality gates with deep reasoning

**Pattern 3: Layered Context (CLAUDE.md + Rules + Skills)**
```
CLAUDE.md: "We use TypeScript strict mode"
.claude/rules/api.md (paths: src/api/**): "All endpoints need auth middleware"
Skill: api-design (loaded when designing APIs)
```
- Global standards always present
- Path-specific rules activate by context
- Skills add situational expertise

**Pattern 4: Explicit Capability (Command + Skill)**
- User types `/security-review`
- Command triggers security skill
- Result: User control + deep capability

**Pattern 5: Tool Teacher (MCP + Skill)**
- MCP provides database tools
- Skill teaches effective query patterns
- Result: Tools + expertise for using them

### Anti-Patterns (What NOT to Do)

1. **Monolithic CLAUDE.md**: Everything in CLAUDE.md → bloats every session
   - Fix: Move situational content to skills

2. **Skills for Simple Triggers**: Creating skill just for a prompt
   - Fix: Use slash command for explicit, simple triggers

3. **Subagents for Knowledge Sharing**: Using subagent to "teach" main context
   - Fix: Subagent context doesn't flow back - use skills for knowledge

4. **Everything Skill**: One skill with all references
   - Fix: Separate skills by domain, clear descriptions

5. **Hook Logic Overload**: Complex business logic in hooks
   - Fix: Hook spawns subagent for complex work

6. **Blind File Generation**: Generating configs without checking docs
   - Fix: Verify understanding first, use templates

7. **Deeply Nested References**: SKILL.md → A.md → B.md → actual content
   - Fix: Keep references one level deep

### Workflow Patterns

1. **Explore→Plan→Code→Commit**: Research first, plan second, code third
2. **TDD with Claude**: Tests provide clear evaluation targets
3. **Multi-Instance Workflows**: Parallel Claude sessions for throughput
4. **Subagent-Driven Development**: Fresh subagent per task + review loops

---

## Source Documentation Locations

### Local Files (In This Repository)

| Source | Location | Primary Use |
|--------|----------|-------------|
| Skills docs | `02-core-features/skills.md` | skills-deep-dive, cc-skills-reference |
| Subagents docs | `02-core-features/subagents.md` | subagents-deep-dive, cc-subagents-reference |
| Hooks docs | `02-core-features/hooks.md` | hooks-deep-dive |
| Hooks guide | `02-core-features/hooks-guide.md` | Hook patterns, cc-hooks-reference |
| Memory docs | `02-core-features/memory.md` | memory-deep-dive, cc-memory-reference |
| Commands docs | `02-core-features/slash-commands.md` | commands-deep-dive |
| MCP docs | `02-core-features/mcp.md` | mcp-deep-dive |
| Plugins docs | `07-plugins/plugins.md` | plugin-structure |
| Plugins reference | `07-plugins/plugins-reference.md` | Plugin specification |
| Community skills | `11-external-resources/core-skills/` | Pattern examples |

### External URLs (Fetch When Needed)

| Source | URL | Primary Use |
|--------|-----|-------------|
| Platform skills overview | `https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview` | Architecture deep-dive |
| Platform best practices | `https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices` | Authoring guidance |
| Engineering blog | `https://www.anthropic.com/engineering/claude-code-best-practices` | Workflow patterns |
| Skills quickstart | `https://platform.claude.com/docs/en/agents-and-tools/agent-skills/quickstart` | Tutorial reference |

### Key External Content (Already Synthesized)

**Platform Skills Overview** (platform.claude.com):
- Three loading levels: metadata (always) → body (triggered) → resources (on-demand)
- Skills are filesystem-based, Claude reads via bash
- Progressive disclosure is architectural, not optional
- ~100 tokens per skill for metadata, <5k for body
- Resources effectively unlimited (not loaded until accessed)
- Skills share context; subagents isolate context

**Platform Best Practices**:
- SKILL.md body under 500 lines
- References one level deep (no nested chains)
- Use gerund form for names (processing-pdfs)
- Descriptions must be third-person, specific, include triggers
- Workflows with checklists for complex tasks
- Evaluation-driven development: test before writing docs
- Degrees of freedom: high (text) → medium (pseudocode) → low (exact scripts)

**Engineering Best Practices** (anthropic.com):
- CLAUDE.md for core project context (shared with team)
- Explore→Plan→Code→Commit pattern for complex problems
- TDD works well with Claude (clear evaluation targets)
- Multi-instance workflows for throughput (git worktrees)
- Visual inputs dramatically improve UI implementation
- Use `#` to let Claude update CLAUDE.md automatically

---

## What Each Reference File Should Contain

### system-understanding/

**context-architecture.md**:
- Explain context window as shared resource
- Token budget breakdown (system prompt, CLAUDE.md, skills, conversation)
- What's always loaded vs on-demand
- Memory hierarchy and conflict resolution
- Practical implications for design

**execution-model.md**:
- Agentic loop: observe → think → act → observe
- Tool invocation flow
- Where hooks inject (before/after tools)
- Subagent spawn and return cycle
- Session lifecycle events

**feature-interactions.md**:
- Context sharing model per feature (table)
- Invocation model per feature (who triggers)
- What can trigger what (skills can spawn subagents, etc.)
- Feature layering visualization

### feature-mechanics/

Each deep-dive should cover:
- How the feature works internally
- Configuration format and options
- Activation/triggering mechanism
- Context implications
- Common use cases
- Limitations and constraints

### decision-guides/

Each guide should have:
- Clear decision criteria (questions to ask)
- Comparison table
- "Choose X when..." lists
- "Don't choose X when..." lists
- Real examples

### patterns/

**composition-patterns.md**: The 5+ patterns with code examples
**anti-patterns.md**: The 7+ anti-patterns with fixes
**workflow-patterns.md**: Development workflows with Claude
**architecture-examples.md**: Complete real-world setups

### implementation/

Each guide should provide:
- File format/structure
- Required vs optional fields
- Best practices checklist
- Common mistakes to avoid
- Example templates

### source-documentation/

Curated excerpts (NOT full copies) of authoritative content:
- Focus on mechanics and examples
- ~800-1200 tokens each
- Include source URL and sync date
- Section headers for navigation

---

## Subagent Coordination

**Main Conversation Orchestrates**: Subagents cannot spawn other subagents. The main conversation coordinates all subagent calls.

**Sequential for Dependencies**:
1. Verify understanding (cc-understanding-verifier)
2. Design architecture (cc-architecture-designer)
3. USER APPROVAL CHECKPOINT
4. Generate files (cc-file-generator)
5. Review quality (cc-implementation-reviewer)

**Parallel When Independent**:
- Multiple verification tasks
- Multiple research tasks
- But: max 2 subagents in parallel for quality review

**Information Handoff**:
- Each subagent returns a summary
- Main conversation synthesizes across subagents
- User checkpoints before generation

---

## Quality Standards

All files in this plugin must:

1. **Be grounded in official documentation** - No speculation
2. **Respect token budgets** - See file tree for targets
3. **Use third-person voice** - "Processes" not "I process"
4. **Include cross-references** - "See X for details"
5. **Follow progressive disclosure** - SKILL.md → references → subagents
6. **Test before finalizing** - Verify references load correctly

---

## Version Information

| Item | Value |
|------|-------|
| Context created | 2026-01-08 |
| Based on docs from | 2026-01-06 (code.claude.com) |
| Platform docs fetched | 2026-01-08 |
| Engineering blog fetched | 2026-01-08 |

---

*This document should NOT be modified after creation. Update _PROGRESS.md for status changes.*
