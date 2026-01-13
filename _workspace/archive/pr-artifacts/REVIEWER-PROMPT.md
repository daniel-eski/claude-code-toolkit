# Initial Prompt for PR Reviewer

> Copy this prompt to start a fresh Claude Code session for unbiased review.
>
> **Important**: Start Claude Code in this directory:
> `/Users/danieleskenazi/Desktop/Repos/claude-code-toolkit`

---

## The Prompt

```
I need you to conduct a critical review of proposed changes to this repository before they are merged to main. This is a Claude Code toolkit repository containing skills, plugins, documentation, and tools.

**Your task**: Critically evaluate whether the proposed changes (on branch `feature/strategic-roadmap-implementation`) should be merged to main. Be thorough and skeptical - I want genuine critical analysis, not rubber-stamp approval.

**Before you begin reviewing, please take time to familiarize yourself with this repository:**

1. **Read the orientation documents first** (in this order):
   - `CLAUDE.md` - Understand what this repository is and how it's organized
   - `_workspace/planning/repo-vision.md` - Understand the design principles and goals
   - `_workspace/planning/strategic-roadmap.md` - Understand what problems the changes were meant to solve
   - `_workspace/assessments/comprehensive-review-2026-01-09.md` - Understand the assessment that drove the changes

2. **Understand the changes being proposed**:
   - Run: `git log --oneline main..feature/strategic-roadmap-implementation` to see the 4 commits
   - Run: `git diff main..feature/strategic-roadmap-implementation --stat` to see scope
   - Read `_workspace/planning/PR-DESCRIPTION.md` for structured context about each commit

3. **Consider deploying relevant skills for this review**:
   - `library/skills/core-skills/git-workflow/pr-review-toolkit/` - Structured PR review methodology
   - The `claude-code-advisor` plugin is available at `library/plugins/local/claude-code-advisor/`

4. **Use the repository's own validation tools**:
   ```bash
   cd library/tools
   ./validate-links.sh          # Check for broken internal links
   ./validate-skill.sh <path>   # Validate skill format
   ./freshness-report.sh        # Check skill sources
   ```

**What I want you to evaluate**:

1. **Technical accuracy**: Do all paths resolve? Are file counts accurate? Do scripts work?
2. **Content quality**: Is new content (self-knowledge docs, graduated plugins) genuinely valuable?
3. **Consistency**: Do descriptions match reality? Are catalogs accurate?
4. **Shareability**: Any remaining hardcoded paths or user-specific content?
5. **Vision alignment**: Do changes serve the stated repository purposes?
6. **Gaps**: What did the implementation miss or get wrong?

**Success criteria** are documented in `_workspace/planning/strategic-roadmap.md` - verify each one.

**Branch preservation**: The original main is preserved as `initial-commit` branch if we need to roll back.

**GitHub PR**: https://github.com/daniel-eski/claude-code-toolkit/pull/new/feature/strategic-roadmap-implementation
(The PR may need to be created first - check if it exists)

Please be thorough. Deploy subagents strategically if useful for parallel analysis. I'd rather you find problems now than after merging.
```

---

## Why This Approach

1. **Local repo access**: The agent can run validation scripts, read all files, and use the tools/skills we've built.

2. **Structured ramp-up**: Reading orientation docs first gives context without the bias of our conversational history.

3. **Self-referential tooling**: The repo contains its own review tools (pr-review-toolkit, validate-links.sh) - using them is both practical and a test of whether they work.

4. **Critical stance encouraged**: The prompt explicitly asks for skepticism and critical analysis.

5. **Success criteria reference**: Points to the roadmap's success criteria as the benchmark.

---

## Alternative: Shorter Version

If you want a more concise prompt:

```
I need a critical review of the PR on branch `feature/strategic-roadmap-implementation` before merging to main. This is a Claude Code toolkit repo.

Start by reading:
1. `CLAUDE.md` - orientation
2. `_workspace/planning/strategic-roadmap.md` - what the changes were meant to achieve
3. `_workspace/planning/PR-DESCRIPTION.md` - summary of the 4 commits

Then use `git diff main..feature/strategic-roadmap-implementation` and the validation tools in `library/tools/` to verify the changes are correct and complete.

Be critical. Find problems. The original main is preserved as `initial-commit` if we need to roll back.
```
