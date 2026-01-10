# Extended Skills

Specialized domain skills and educational resources.

## Categories

| Directory | Content | Type |
|-----------|---------|------|
| [aws-skills/](aws-skills/) | AWS infrastructure and development | Downloaded (4 skills) |
| [context-engineering/](context-engineering/) | AI agent context engineering | Reference links only |

## AWS Skills

From [zxkane/aws-skills](https://github.com/zxkane/aws-skills):

| Skill | Description |
|-------|-------------|
| aws-agentic-ai | Agentic AI development on AWS |
| aws-cdk-development | AWS CDK infrastructure development |
| aws-cost-operations | Cost optimization and operations |
| aws-serverless-eda | Serverless event-driven architecture |

## Context Engineering

Educational content from [muratcankoylan/Agent-Skills-for-Context-Engineering](https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering).

This is provided as **reference links only** because:
- Content is educational rather than executable
- The full repository is better consumed as a cohesive course
- Keeps local storage minimal

See [context-engineering/README.md](context-engineering/README.md) for the full list of topics and links.

## Adding More Extended Skills

Extended skills are for specialized domains that may not be needed by all users. To add a new extended skill:

```bash
cd ../tools/
./fetch-skill.sh <github-url> ../extended-skills/<category>/<skill-name>
```
