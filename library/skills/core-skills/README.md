# Core Skills

Production-ready skills downloaded locally for immediate deployment.

## Categories

| Directory | Skills | Description |
|-----------|--------|-------------|
| [obra-workflow/](obra-workflow/) | 6 | Strategic planning and workflow methodology |
| [obra-development/](obra-development/) | 9 | Software development workflows |
| [git-workflow/](git-workflow/) | 6 | Git and GitHub automation |
| [testing/](testing/) | 2 | Testing and quality assurance |
| [document-creation/](document-creation/) | 5 | Document generation (Word, Excel, PowerPoint, PDF) |
| [skill-authoring/](skill-authoring/) | 2 | Meta skills for creating new skills |

## Quick Deploy

```bash
# Deploy all core skills
cd ../tools/
./deploy-all.sh

# Deploy a specific category
for skill in obra-workflow/*/; do
    ./deploy-skill.sh "../core-skills/$skill"
done
```

## Skill Count

- **Total core skills**: 30 (28 available + 2 placeholders)
- **From obra/superpowers**: 15 skills
- **From fvadicamo/dev-agent-skills**: 5 skills
- **From anthropics/skills**: 8 skills
