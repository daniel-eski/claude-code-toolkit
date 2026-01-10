# Reference Index

Conditional reading guide for claude-code-advisor reference files.

---

## Quick Navigation by Question

### "How does Claude Code work?"
Start with **System Understanding**:
- `system-understanding/context-architecture.md` - Context window, token budgets
- `system-understanding/execution-model.md` - Agentic loop, tool flow
- `system-understanding/feature-interactions.md` - How features compose

### "What is [feature] and how does it work?"
Go to **Feature Mechanics**:
| Feature | File |
|---------|------|
| Skills | `feature-mechanics/skills-deep-dive.md` |
| Subagents | `feature-mechanics/subagents-deep-dive.md` |
| Hooks | `feature-mechanics/hooks-deep-dive.md` |
| Memory | `feature-mechanics/memory-deep-dive.md` |
| Commands | `feature-mechanics/commands-deep-dive.md` |
| MCP | `feature-mechanics/mcp-deep-dive.md` |

### "Should I use X or Y?"
Go to **Decision Guides**:
| Comparison | File |
|------------|------|
| Skills vs Subagents | `decision-guides/skills-vs-subagents.md` |
| Skills vs Commands | `decision-guides/skills-vs-commands.md` |
| Memory vs Skills | `decision-guides/memory-vs-skills.md` |
| When to use Hooks | `decision-guides/hooks-usage-guide.md` |
| Full architecture | `decision-guides/architecture-selection.md` |

### "What are the best practices?"
Go to **Patterns**:
- `patterns/composition-patterns.md` - 6 named feature combinations
- `patterns/anti-patterns.md` - 7 mistakes to avoid
- `patterns/workflow-patterns.md` - Development workflows
- `patterns/architecture-examples.md` - Real-world configurations

### "How do I create [component]?"
Go to **Implementation Guides**:
| Creating | File |
|----------|------|
| Skills | `implementation/skill-authoring.md` |
| Subagents | `implementation/subagent-design.md` |
| Hooks | `implementation/hook-implementation.md` |
| Plugins | `implementation/plugin-structure.md` |

---

## All Reference Files

### System Understanding (3 files)
| File | Topics |
|------|--------|
| `context-architecture.md` | Context window, token budgets, memory hierarchy |
| `execution-model.md` | Agentic loop, tool sequence, hook injection |
| `feature-interactions.md` | Context sharing, feature composition |

### Feature Mechanics (6 files)
| File | Topics |
|------|--------|
| `skills-deep-dive.md` | 3-level loading, discovery, configuration |
| `subagents-deep-dive.md` | Context isolation, built-in agents, models |
| `hooks-deep-dive.md` | Events, matchers, scripts, exit codes |
| `memory-deep-dive.md` | CLAUDE.md hierarchy, path-specific rules |
| `commands-deep-dive.md` | Types, arguments, frontmatter |
| `mcp-deep-dive.md` | Transports, scopes, resources |

### Decision Guides (5 files)
| File | Topics |
|------|--------|
| `skills-vs-subagents.md` | Context sharing vs isolation |
| `skills-vs-commands.md` | Auto-trigger vs explicit |
| `memory-vs-skills.md` | Every-session vs triggered |
| `hooks-usage-guide.md` | Event selection, when to use |
| `architecture-selection.md` | Full decision framework |

### Patterns (4 files)
| File | Topics |
|------|--------|
| `composition-patterns.md` | Isolated Expert, Coordinated Specialists, etc. |
| `anti-patterns.md` | Monolithic skills, redundant agents, etc. |
| `workflow-patterns.md` | Explore→Plan→Code, TDD, parallel agents |
| `architecture-examples.md` | Code review, API dev, security configs |

### Implementation Guides (4 files)
| File | Topics |
|------|--------|
| `skill-authoring.md` | Step-by-step skill creation |
| `subagent-design.md` | Agent configuration, model selection |
| `hook-implementation.md` | Script templates, exit codes |
| `plugin-structure.md` | Plugin directories, manifest |

---

## Reading Paths

### New to Claude Code
1. `system-understanding/context-architecture.md`
2. `system-understanding/feature-interactions.md`
3. Feature mechanics for each feature you'll use

### Designing a Configuration
1. `decision-guides/architecture-selection.md`
2. Specific comparison guides (skills-vs-subagents, etc.)
3. `patterns/composition-patterns.md`
4. `patterns/anti-patterns.md`

### Implementing a Specific Feature
1. Feature mechanics deep-dive
2. Relevant decision guide
3. Implementation guide

### Reviewing/Improving Existing Setup
1. `patterns/anti-patterns.md`
2. `decision-guides/architecture-selection.md`
3. Relevant feature mechanics for identified issues
