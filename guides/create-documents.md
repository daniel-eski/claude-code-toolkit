# Create Documents and Artifacts

> Generate professional Word, Excel, PowerPoint, and PDF documents directly from Claude Code

---

## When to Use This

You need to create formatted documents as part of your workflow - whether that's generating reports, building spreadsheets with data, creating presentation decks, or producing PDFs. These skills let Claude Code output professional documents without requiring external tools or manual formatting.

## Quick Start

1. Deploy the skill for your document type: `deploy-skill.sh library/skills/core-skills/document-creation/docx/`
2. Ask Claude Code to create your document (e.g., "Create a project status report as a Word document")
3. The skill handles formatting, structure, and file generation

---

## Resources

### Primary Tools

| Resource | Type | Location | Why |
|----------|------|----------|-----|
| docx skill | Skill | `library/skills/core-skills/document-creation/docx/` | Create Word documents with proper formatting, headers, styles |
| xlsx skill | Skill | `library/skills/core-skills/document-creation/xlsx/` | Generate Excel spreadsheets with formulas, charts, multiple sheets |
| pptx skill | Skill | `library/skills/core-skills/document-creation/pptx/` | Build PowerPoint presentations with slides, layouts, themes |
| pdf skill | Skill | `library/skills/core-skills/document-creation/pdf/` | Generate PDF files for reports, documentation, exports |
| doc-coauthoring skill | Skill | `library/skills/core-skills/document-creation/doc-coauthoring/` | Collaborative document editing with revision tracking |

### Supporting Resources

| Resource | Type | Location | Why |
|----------|------|----------|-----|
| Skill deployment script | Tool | `library/tools/deploy-skill.sh` | Deploy any skill with one command |
| Skill validation script | Tool | `library/tools/validate-skill.sh` | Verify skill format before deployment |

### Documentation

| Doc | Location | When to Read |
|-----|----------|--------------|
| Skills Guide | `docs/core-features/skills.md` | Understanding how skills work |
| Document Creation README | `library/skills/core-skills/document-creation/README.md` | Overview of all document skills |

---

## Recommended Workflow

1. **Identify document type** - Determine which format best suits your needs (Word for text-heavy docs, Excel for data, PowerPoint for presentations, PDF for final distribution)

2. **Deploy the skill** - Run the deployment script for your chosen document type:
   ```bash
   cd library/tools/
   ./deploy-skill.sh ../skills/core-skills/document-creation/docx/
   ```

3. **Describe your document** - Tell Claude Code what you need, including:
   - Document purpose and audience
   - Key sections or data to include
   - Any formatting preferences

4. **Review and iterate** - Check the generated document and request adjustments as needed

5. **For complex documents** - Consider combining skills (e.g., generate data in xlsx, then summarize in docx)

---

## Related Intents

- [start-feature](start-feature.md) - Create planning documents before implementation
