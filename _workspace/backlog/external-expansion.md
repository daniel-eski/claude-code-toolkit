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
- **Notes**: User said "Need to evaluate - looks promising"

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

#### Other Plugin Sources
- jarrodwatts/claude-code-config - "Maybe some?" (user's note)
- vibeforge1111/vibeship-spawner-skills - "Maybe a few" (user's note)

### Official Anthropic Plugins
- **URL**: https://github.com/anthropics/claude-plugins-official
- **What's known**: 36 plugins total in curated marketplace
- **Status**: User wants all official ones "explained and made easy to navigate"

## Evaluation Criteria

Before adding a resource:

### Quality
- [ ] Well-documented
- [ ] Actually works
- [ ] Actively maintained
- [ ] Good code quality

### Usefulness
- [ ] Solves a real problem
- [ ] Not redundant with existing resources
- [ ] Worth the index space

### Trust/Safety
- [ ] No obvious security issues
- [ ] Known/reputable source
- [ ] Appropriate permissions model

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

DEFERRED - Focus on migrating existing content first; expansion comes after.
