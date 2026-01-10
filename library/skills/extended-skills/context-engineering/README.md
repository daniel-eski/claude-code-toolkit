# Context Engineering Skills (Reference Links)

Educational content on context engineering for AI agents from [muratcankoylan/Agent-Skills-for-Context-Engineering](https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering).

These skills are available as reference links. To use them, visit the linked repository or install the plugin directly.

## Available Skills

| Skill | Description | Link |
|-------|-------------|------|
| context-fundamentals | What context is, why it matters, anatomy of context | [View](https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering/tree/main/skills/context-fundamentals) |
| context-degradation | Patterns of context failure: lost-in-middle, poisoning, distraction | [View](https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering/tree/main/skills/context-degradation) |
| context-compression | Compression strategies for long-running sessions | [View](https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering/tree/main/skills/context-compression) |
| context-optimization | Compaction, masking, and caching strategies | [View](https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering/tree/main/skills/context-optimization) |
| multi-agent-patterns | Orchestrator, peer-to-peer, hierarchical architectures | [View](https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering/tree/main/skills/multi-agent-patterns) |
| memory-systems | Short-term, long-term, graph-based memory architectures | [View](https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering/tree/main/skills/memory-systems) |
| tool-design | Building effective tools for agents | [View](https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering/tree/main/skills/tool-design) |
| evaluation | Evaluation frameworks for agent systems | [View](https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering/tree/main/skills/evaluation) |

## Key Concepts

From the context-fundamentals skill:

- Context engineering is about finding the **smallest high-signal token set** that maximizes desired outcomes
- Tool outputs can consume **83.9% of total context** in agent systems
- Multi-agent systems consume **~15x baseline tokens** vs 1x for simple queries
- Context windows are constrained by **attention mechanics**, not raw token capacity

## Installation

To install the full plugin:

```bash
# Via Claude Code plugin marketplace
/plugin marketplace add muratcankoylan/Agent-Skills-for-Context-Engineering
```

Or clone the repository and install manually:

```bash
git clone https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering.git
# Follow instructions in their README
```

## Future Enhancement

To download these skills locally, use the fetch script:

```bash
cd ../tools/
./fetch-skill.sh https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering/tree/main/skills/context-fundamentals ../../extended-skills/context-engineering/context-fundamentals
```
