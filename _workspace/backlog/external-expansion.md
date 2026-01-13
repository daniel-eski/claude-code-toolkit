# Backlog: External Resources Expansion

> Search for and evaluate additional external skills, plugins, and resources.

---

## Goal

Expand the repository's indexed resources by evaluating and adding high-quality external skills, plugins, and documentation.

## External Sources to Evaluate

### Skills Collections

#### ComposioHQ/awesome-claude-skills
- **URL**: https://github.com/ComposioHQ/awesome-claude-skills
- **What's known**: ~60 skills across 9 categories
- **Categories**: Document Processing, Development & Code Tools, Data & Analysis, Business & Marketing, Communication & Writing, Creative & Media, Productivity & Organization, Collaboration & Project Management, Security & Systems
- **Status**: Active community curation
- **Priority**: High - Large collection worth systematic evaluation

#### Other Skills Sources
- VoltAgent/awesome-claude-skills - Fork/similar collection
- muratcankoylan/Agent-Skills-for-Context-Engineering - Context engineering education

### Plugins

#### EveryInc/compound-engineering-plugin
- **URL**: https://github.com/EveryInc/compound-engineering-plugin
- **What's known**: 4.3k stars, 361 forks
- **Commands**: /workflows:plan, /workflows:work, /workflows:review, /workflows:compound
- **Philosophy**: "80% planning and review, 20% execution"
- **Status**: Actively maintained

#### CloudAI-X/claude-workflow-v2
- **URL**: https://github.com/CloudAI-X/claude-workflow-v2
- **What's known**: 7 agents, 17 commands, 6 skills, 9 hooks
- **Features**: Comprehensive workflow plugin with output modes
- **Requirements**: Claude Code v1.0.33+, Python 3, Git

#### jarrodwatts/claude-hud - CURRENTLY USING
- **URL**: https://github.com/jarrodwatts/claude-hud
- **What it does**: Real-time session info in terminal statusline
- **Features**: Context usage bar (color-coded), tool activity tracking, git status, usage monitoring (Pro/Max), todo progress
- **Configuration**: Three presets (Full/Essential/Minimal) + granular control via `/claude-hud:configure`
- **Status**: ✅ Installed and active in user's setup
- **Notes**: Integrates via `statusLine.command` in settings.json

#### Other Plugin Sources
- jarrodwatts/claude-code-config - Configuration examples, pending evaluation
- vibeforge1111/vibeship-spawner-skills - Skill spawning, pending evaluation

### Official Anthropic Plugins
- **URL**: https://github.com/anthropics/claude-plugins-official
- **What's known**: 36 plugins total in curated marketplace
- **Status**: 13 already documented in `library/plugins/official/CATALOG.md`; remaining 23 pending documentation

## Evaluation Criteria

**See `library/EVALUATION-FRAMEWORK.md` for the complete evaluation framework.**

Quick checklist:
- [ ] Works without errors
- [ ] Well-documented (README)
- [ ] Actively maintained
- [ ] No security concerns
- [ ] Non-redundant with existing content

Decision matrix:
- Score 25-30 → Add to library/
- Score 18-24 → Index only (reference here)
- Score 12-17 → Defer
- Score <12 → Skip

## Process for Adding Resources

### For Skills
1. Evaluate against criteria
2. Verify the source URL works
3. Add to `library/skills/community/` (if stored locally) or index
4. Update CATALOG.md
5. Document maturity/status

### For Plugins
1. Evaluate against criteria
2. Test if possible
3. Add to `library/plugins/community/` index
4. Note trust level and any caveats

### For Indexes Only
1. Verify URL works
2. Write one-line description
3. Add to appropriate section
4. Include any evaluation notes

## How to Update Indexes

When new resources are found:
1. Check if they meet criteria
2. Add to appropriate index file
3. Include source URL, description, evaluation notes
4. Note any trust/quality caveats

## Connection to Other Deferred Work

- New resources should follow `skills-organization.md` patterns
- Should inform `purpose-navigation.md` pathways
- May become candidates for `local-copies.md`

---

## Status

**ACTIVE** - Evaluation framework created (`library/EVALUATION-FRAMEWORK.md`). Resources above are candidates for evaluation using the framework.

**Already in use**: claude-hud (installed in user's setup)
**Next priority**: compound-engineering-plugin (4.3k stars), ComposioHQ skills collection
