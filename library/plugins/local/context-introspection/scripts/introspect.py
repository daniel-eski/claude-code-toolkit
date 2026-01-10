#!/usr/bin/env python3
"""
Context Introspection Script for Claude Code

Enumerates all context sources that influence Claude Code sessions
and generates a comprehensive markdown report.

Usage:
    python introspect.py [project_dir] [output_file]
"""
from __future__ import annotations

import json
import os
import platform
import re
import sys
from datetime import datetime
from pathlib import Path


# === Constants ===

def get_enterprise_claude_path():
    """Get platform-specific enterprise CLAUDE.md path."""
    system = platform.system()
    if system == "Darwin":
        return Path("/Library/Application Support/ClaudeCode/CLAUDE.md")
    elif system == "Linux":
        return Path("/etc/claude-code/CLAUDE.md")
    elif system == "Windows":
        return Path("C:/Program Files/ClaudeCode/CLAUDE.md")
    return None


def get_enterprise_settings_dir():
    """Get platform-specific enterprise settings directory."""
    system = platform.system()
    if system == "Darwin":
        return Path("/Library/Application Support/ClaudeCode")
    elif system == "Linux":
        return Path("/etc/claude-code")
    elif system == "Windows":
        return Path("C:/Program Files/ClaudeCode")
    return None


HOME = Path.home()
USER_CLAUDE_DIR = HOME / ".claude"
USER_CLAUDE_MD = USER_CLAUDE_DIR / "CLAUDE.md"
USER_RULES_DIR = USER_CLAUDE_DIR / "rules"
USER_SKILLS_DIR = USER_CLAUDE_DIR / "skills"
USER_AGENTS_DIR = USER_CLAUDE_DIR / "agents"
USER_COMMANDS_DIR = USER_CLAUDE_DIR / "commands"
USER_SETTINGS = USER_CLAUDE_DIR / "settings.json"
USER_CLAUDE_JSON = HOME / ".claude.json"

PREVIEW_LINES = 15


# === Utility Functions ===

def get_file_stats(path: Path) -> dict:
    """Get file statistics if the file exists."""
    if not path.exists():
        return {"exists": False, "path": str(path)}

    stat = path.stat()
    return {
        "exists": True,
        "path": str(path),
        "size": stat.st_size,
        "modified": datetime.fromtimestamp(stat.st_mtime).strftime("%Y-%m-%d %H:%M"),
        "size_human": format_size(stat.st_size),
    }


def format_size(size: int) -> str:
    """Format file size in human-readable form."""
    for unit in ["B", "KB", "MB"]:
        if size < 1024:
            return f"{size:.0f} {unit}" if unit == "B" else f"{size:.1f} {unit}"
        size /= 1024
    return f"{size:.1f} GB"


def get_preview(content: str, lines: int = PREVIEW_LINES) -> str:
    """Get first N lines of content as preview."""
    content_lines = content.split("\n")
    preview = "\n".join(content_lines[:lines])
    if len(content_lines) > lines:
        preview += f"\n... ({len(content_lines) - lines} more lines)"
    return preview


def extract_frontmatter(content: str) -> tuple[dict | None, str]:
    """Extract YAML frontmatter from markdown content."""
    if not content.startswith("---"):
        return None, content

    # Find the closing ---
    end_match = re.search(r"\n---\s*\n", content[3:])
    if not end_match:
        return None, content

    frontmatter_str = content[4:end_match.start() + 3]
    body = content[end_match.end() + 3:]

    # Simple YAML parsing (key: value pairs)
    frontmatter = {}
    for line in frontmatter_str.strip().split("\n"):
        if ":" in line:
            key, _, value = line.partition(":")
            frontmatter[key.strip()] = value.strip()

    return frontmatter, body


def read_file_safe(path: Path) -> str | None:
    """Safely read file content, returning None on error."""
    try:
        return path.read_text(encoding="utf-8")
    except Exception:
        return None


def load_json_safe(path: Path) -> dict | None:
    """Safely load JSON file, returning None on error."""
    try:
        content = path.read_text(encoding="utf-8")
        return json.loads(content)
    except Exception:
        return None


def make_file_link(path: Path) -> str:
    """Create a clickable file:// link for markdown."""
    abs_path = path.resolve() if path.exists() else path
    return f"[`{path}`](file://{abs_path})"


def make_relative_link(path: Path, project_dir: Path) -> str:
    """Create a relative path display with file link."""
    try:
        rel = path.relative_to(project_dir)
        display = f"./{rel}"
    except ValueError:
        display = str(path)
    abs_path = path.resolve() if path.exists() else path
    return f"[`{display}`](file://{abs_path})"


# === Discovery Functions ===

def find_memory_files(project_dir: Path) -> list[dict]:
    """Find all CLAUDE.md files in the hierarchy."""
    memory_files = []

    # Enterprise
    enterprise_path = get_enterprise_claude_path()
    if enterprise_path:
        stats = get_file_stats(enterprise_path)
        stats["scope"] = "Enterprise Policy"
        stats["description"] = "Organization-wide instructions (IT-managed)"
        if stats["exists"]:
            content = read_file_safe(enterprise_path)
            stats["preview"] = get_preview(content) if content else None
        memory_files.append(stats)

    # User
    stats = get_file_stats(USER_CLAUDE_MD)
    stats["scope"] = "User Memory"
    stats["description"] = "Personal preferences for all projects"
    if stats["exists"]:
        content = read_file_safe(USER_CLAUDE_MD)
        stats["preview"] = get_preview(content) if content else None
    memory_files.append(stats)

    # User rules
    if USER_RULES_DIR.exists():
        for rule_file in sorted(USER_RULES_DIR.rglob("*.md")):
            stats = get_file_stats(rule_file)
            stats["scope"] = "User Rules"
            rel_path = rule_file.relative_to(USER_RULES_DIR)
            stats["description"] = f"User rule: {rel_path}"
            if stats["exists"]:
                content = read_file_safe(rule_file)
                fm, _ = extract_frontmatter(content) if content else (None, "")
                stats["frontmatter"] = fm
                stats["preview"] = get_preview(content) if content else None
            memory_files.append(stats)

    # Project hierarchy (walk up from project_dir)
    # Track paths we've already added to avoid duplicates
    seen_paths = {USER_CLAUDE_MD.resolve()} if USER_CLAUDE_MD.exists() else set()

    current = project_dir.resolve()
    project_claude_files = []
    while current != current.parent:
        # Check both ./CLAUDE.md and ./.claude/CLAUDE.md
        for claude_path in [current / "CLAUDE.md", current / ".claude" / "CLAUDE.md"]:
            resolved = claude_path.resolve()
            if claude_path.exists() and resolved not in seen_paths:
                seen_paths.add(resolved)
                stats = get_file_stats(claude_path)
                stats["scope"] = "Project Memory"
                try:
                    rel = claude_path.relative_to(project_dir)
                    stats["description"] = f"Project instructions: ./{rel}"
                except ValueError:
                    stats["description"] = f"Parent project instructions: {claude_path}"
                content = read_file_safe(claude_path)
                stats["preview"] = get_preview(content) if content else None
                project_claude_files.append(stats)
        current = current.parent

    # Add in reverse order (root to local) for proper hierarchy display
    memory_files.extend(reversed(project_claude_files))

    # Project rules
    project_rules_dir = project_dir / ".claude" / "rules"
    if project_rules_dir.exists():
        for rule_file in sorted(project_rules_dir.rglob("*.md")):
            stats = get_file_stats(rule_file)
            stats["scope"] = "Project Rules"
            rel_path = rule_file.relative_to(project_rules_dir)
            stats["description"] = f"Project rule: {rel_path}"
            if stats["exists"]:
                content = read_file_safe(rule_file)
                fm, _ = extract_frontmatter(content) if content else (None, "")
                stats["frontmatter"] = fm
                stats["preview"] = get_preview(content) if content else None
            memory_files.append(stats)

    # Local CLAUDE.md
    local_claude = project_dir / "CLAUDE.local.md"
    stats = get_file_stats(local_claude)
    stats["scope"] = "Local Memory"
    stats["description"] = "Personal project-specific preferences (gitignored)"
    if stats["exists"]:
        content = read_file_safe(local_claude)
        stats["preview"] = get_preview(content) if content else None
    memory_files.append(stats)

    return memory_files


def find_skills(project_dir: Path) -> list[dict]:
    """Find all skills (user and project level)."""
    skills = []

    # User skills
    if USER_SKILLS_DIR.exists():
        for skill_dir in sorted(USER_SKILLS_DIR.iterdir()):
            skill_md = skill_dir / "SKILL.md"
            if skill_md.exists():
                stats = get_file_stats(skill_md)
                stats["scope"] = "User"
                stats["name"] = skill_dir.name
                content = read_file_safe(skill_md)
                if content:
                    fm, body = extract_frontmatter(content)
                    stats["frontmatter"] = fm
                    stats["preview"] = get_preview(body, lines=10)
                skills.append(stats)

    # Project skills
    project_skills_dir = project_dir / ".claude" / "skills"
    if project_skills_dir.exists():
        for skill_dir in sorted(project_skills_dir.iterdir()):
            skill_md = skill_dir / "SKILL.md"
            if skill_md.exists():
                stats = get_file_stats(skill_md)
                stats["scope"] = "Project"
                stats["name"] = skill_dir.name
                content = read_file_safe(skill_md)
                if content:
                    fm, body = extract_frontmatter(content)
                    stats["frontmatter"] = fm
                    stats["preview"] = get_preview(body, lines=10)
                skills.append(stats)

    return skills


def find_hooks(project_dir: Path) -> list[dict]:
    """Find hooks from all settings files."""
    hooks_info = []

    settings_files = [
        (USER_SETTINGS, "User"),
        (project_dir / ".claude" / "settings.json", "Project"),
        (project_dir / ".claude" / "settings.local.json", "Local"),
    ]

    # Enterprise settings
    enterprise_dir = get_enterprise_settings_dir()
    if enterprise_dir:
        settings_files.insert(0, (enterprise_dir / "managed-settings.json", "Enterprise"))

    for settings_path, scope in settings_files:
        if not settings_path.exists():
            continue

        data = load_json_safe(settings_path)
        if not data or "hooks" not in data:
            continue

        hooks_info.append({
            "scope": scope,
            "path": str(settings_path),
            "hooks": data["hooks"],
        })

    return hooks_info


def find_mcp_servers(project_dir: Path) -> list[dict]:
    """Find MCP server configurations."""
    mcp_info = []

    # User MCP config (~/.claude.json)
    if USER_CLAUDE_JSON.exists():
        data = load_json_safe(USER_CLAUDE_JSON)
        if data and "mcpServers" in data:
            mcp_info.append({
                "scope": "User",
                "path": str(USER_CLAUDE_JSON),
                "servers": data["mcpServers"],
            })

    # Project MCP config (.mcp.json)
    project_mcp = project_dir / ".mcp.json"
    if project_mcp.exists():
        data = load_json_safe(project_mcp)
        if data and "mcpServers" in data:
            mcp_info.append({
                "scope": "Project",
                "path": str(project_mcp),
                "servers": data["mcpServers"],
            })
        elif data:
            # Might be top-level servers
            mcp_info.append({
                "scope": "Project",
                "path": str(project_mcp),
                "servers": data,
            })

    # Enterprise MCP
    enterprise_dir = get_enterprise_settings_dir()
    if enterprise_dir:
        managed_mcp = enterprise_dir / "managed-mcp.json"
        if managed_mcp.exists():
            data = load_json_safe(managed_mcp)
            if data:
                servers = data.get("mcpServers", data)
                mcp_info.append({
                    "scope": "Enterprise",
                    "path": str(managed_mcp),
                    "servers": servers,
                })

    return mcp_info


def find_agents(project_dir: Path) -> list[dict]:
    """Find custom agents/subagents."""
    agents = []

    # User agents
    if USER_AGENTS_DIR.exists():
        for agent_file in sorted(USER_AGENTS_DIR.glob("*.md")):
            stats = get_file_stats(agent_file)
            stats["scope"] = "User"
            stats["name"] = agent_file.stem
            content = read_file_safe(agent_file)
            if content:
                fm, body = extract_frontmatter(content)
                stats["frontmatter"] = fm
                stats["preview"] = get_preview(body, lines=10)
            agents.append(stats)

    # Project agents
    project_agents_dir = project_dir / ".claude" / "agents"
    if project_agents_dir.exists():
        for agent_file in sorted(project_agents_dir.glob("*.md")):
            stats = get_file_stats(agent_file)
            stats["scope"] = "Project"
            stats["name"] = agent_file.stem
            content = read_file_safe(agent_file)
            if content:
                fm, body = extract_frontmatter(content)
                stats["frontmatter"] = fm
                stats["preview"] = get_preview(body, lines=10)
            agents.append(stats)

    return agents


def find_commands(project_dir: Path) -> list[dict]:
    """Find custom slash commands."""
    commands = []

    # User commands
    if USER_COMMANDS_DIR.exists():
        for cmd_file in sorted(USER_COMMANDS_DIR.rglob("*.md")):
            stats = get_file_stats(cmd_file)
            stats["scope"] = "User"
            rel_path = cmd_file.relative_to(USER_COMMANDS_DIR)
            stats["name"] = f"/{cmd_file.stem}"
            stats["namespace"] = str(rel_path.parent) if str(rel_path.parent) != "." else None
            content = read_file_safe(cmd_file)
            if content:
                fm, body = extract_frontmatter(content)
                stats["frontmatter"] = fm
                stats["preview"] = get_preview(body, lines=8)
            commands.append(stats)

    # Project commands
    project_commands_dir = project_dir / ".claude" / "commands"
    if project_commands_dir.exists():
        for cmd_file in sorted(project_commands_dir.rglob("*.md")):
            stats = get_file_stats(cmd_file)
            stats["scope"] = "Project"
            rel_path = cmd_file.relative_to(project_commands_dir)
            stats["name"] = f"/{cmd_file.stem}"
            stats["namespace"] = str(rel_path.parent) if str(rel_path.parent) != "." else None
            content = read_file_safe(cmd_file)
            if content:
                fm, body = extract_frontmatter(content)
                stats["frontmatter"] = fm
                stats["preview"] = get_preview(body, lines=8)
            commands.append(stats)

    return commands


# === Report Generation ===

def generate_report(project_dir: Path) -> str:
    """Generate the full markdown report."""
    lines = []

    # Header
    lines.append("# Context Introspection Report")
    lines.append("")
    lines.append(f"**Generated:** {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    lines.append(f"**Project:** `{project_dir}`")
    lines.append(f"**Platform:** {platform.system()}")
    lines.append("")

    # Gather all data
    memory_files = find_memory_files(project_dir)
    skills = find_skills(project_dir)
    hooks = find_hooks(project_dir)
    mcp_servers = find_mcp_servers(project_dir)
    agents = find_agents(project_dir)
    commands = find_commands(project_dir)

    # Summary
    lines.append("## Summary")
    lines.append("")
    memory_found = sum(1 for m in memory_files if m.get("exists"))
    lines.append(f"| Category | Found |")
    lines.append(f"|----------|-------|")
    lines.append(f"| Memory files | {memory_found} |")
    lines.append(f"| Skills | {len(skills)} |")
    lines.append(f"| Hook sources | {len(hooks)} |")
    lines.append(f"| MCP server sources | {len(mcp_servers)} |")
    lines.append(f"| Custom agents | {len(agents)} |")
    lines.append(f"| Custom commands | {len(commands)} |")
    lines.append("")

    # Memory Files Section
    lines.append("---")
    lines.append("")
    lines.append("## Memory Files (CLAUDE.md)")
    lines.append("")
    lines.append("Memory files are loaded in order from enterprise → user → project → local.")
    lines.append("Higher specificity takes precedence.")
    lines.append("")

    for mem in memory_files:
        lines.append(f"### {mem['scope']}")
        lines.append("")

        path = Path(mem["path"])
        if mem.get("exists"):
            lines.append(f"**Path:** [{path}](file://{path})")
            lines.append(f"**Status:** Found ({mem['size_human']}, modified {mem['modified']})")
        else:
            lines.append(f"**Path:** `{path}`")
            lines.append(f"**Status:** Not found")

        if mem.get("description"):
            lines.append(f"**Purpose:** {mem['description']}")

        if mem.get("frontmatter"):
            fm = mem["frontmatter"]
            if fm.get("paths"):
                lines.append(f"**Path filter:** `{fm['paths']}`")

        if mem.get("preview"):
            lines.append("")
            lines.append("<details>")
            lines.append("<summary>Preview</summary>")
            lines.append("")
            lines.append("```markdown")
            lines.append(mem["preview"])
            lines.append("```")
            lines.append("")
            lines.append("</details>")

        lines.append("")

    # Skills Section
    lines.append("---")
    lines.append("")
    lines.append("## Skills")
    lines.append("")

    if skills:
        lines.append("Skills are auto-invoked by Claude when requests match their descriptions.")
        lines.append("")

        for skill in skills:
            fm = skill.get("frontmatter", {}) or {}
            name = fm.get("name", skill.get("name", "unknown"))
            desc = fm.get("description", "No description")

            lines.append(f"### {name} ({skill['scope']})")
            lines.append("")
            lines.append(f"**Path:** [{skill['path']}](file://{skill['path']})")
            lines.append(f"**Description:** {desc}")

            if fm.get("allowed-tools"):
                lines.append(f"**Allowed tools:** `{fm['allowed-tools']}`")
            if fm.get("model"):
                lines.append(f"**Model:** `{fm['model']}`")

            if skill.get("preview"):
                lines.append("")
                lines.append("<details>")
                lines.append("<summary>Instructions preview</summary>")
                lines.append("")
                lines.append("```markdown")
                lines.append(skill["preview"])
                lines.append("```")
                lines.append("")
                lines.append("</details>")

            lines.append("")
    else:
        lines.append("*No skills found.*")
        lines.append("")
        lines.append("Skills location:")
        lines.append(f"- User: `~/.claude/skills/*/SKILL.md`")
        lines.append(f"- Project: `.claude/skills/*/SKILL.md`")
        lines.append("")

    # Hooks Section
    lines.append("---")
    lines.append("")
    lines.append("## Hooks")
    lines.append("")

    if hooks:
        lines.append("Hooks run commands in response to Claude Code events.")
        lines.append("")

        for hook_source in hooks:
            lines.append(f"### {hook_source['scope']} Hooks")
            lines.append("")
            lines.append(f"**Source:** [{hook_source['path']}](file://{hook_source['path']})")
            lines.append("")

            lines.append("```json")
            lines.append(json.dumps(hook_source["hooks"], indent=2))
            lines.append("```")
            lines.append("")
    else:
        lines.append("*No hooks configured.*")
        lines.append("")
        lines.append("Hooks are configured in `settings.json` under the `hooks` key.")
        lines.append("")

    # MCP Servers Section
    lines.append("---")
    lines.append("")
    lines.append("## MCP Servers")
    lines.append("")

    if mcp_servers:
        lines.append("MCP servers provide additional tools and data sources.")
        lines.append("")

        for mcp_source in mcp_servers:
            lines.append(f"### {mcp_source['scope']} MCP Servers")
            lines.append("")
            lines.append(f"**Source:** [{mcp_source['path']}](file://{mcp_source['path']})")
            lines.append("")

            servers = mcp_source.get("servers", {})
            if isinstance(servers, dict):
                for name, config in servers.items():
                    lines.append(f"**{name}**")
                    if isinstance(config, dict):
                        if config.get("type"):
                            lines.append(f"- Type: `{config['type']}`")
                        if config.get("url"):
                            lines.append(f"- URL: `{config['url']}`")
                        if config.get("command"):
                            lines.append(f"- Command: `{config['command']}`")
                    lines.append("")
    else:
        lines.append("*No MCP servers configured.*")
        lines.append("")
        lines.append("MCP servers location:")
        lines.append(f"- User: `~/.claude.json` (mcpServers key)")
        lines.append(f"- Project: `.mcp.json`")
        lines.append("")

    # Agents Section
    lines.append("---")
    lines.append("")
    lines.append("## Custom Agents")
    lines.append("")

    if agents:
        lines.append("Custom agents are specialized AI assistants for specific tasks.")
        lines.append("")

        for agent in agents:
            fm = agent.get("frontmatter", {}) or {}
            name = fm.get("name", agent.get("name", "unknown"))
            desc = fm.get("description", "No description")

            lines.append(f"### {name} ({agent['scope']})")
            lines.append("")
            lines.append(f"**Path:** [{agent['path']}](file://{agent['path']})")
            lines.append(f"**Description:** {desc}")

            if fm.get("tools"):
                lines.append(f"**Tools:** `{fm['tools']}`")
            if fm.get("model"):
                lines.append(f"**Model:** `{fm['model']}`")

            if agent.get("preview"):
                lines.append("")
                lines.append("<details>")
                lines.append("<summary>System prompt preview</summary>")
                lines.append("")
                lines.append("```markdown")
                lines.append(agent["preview"])
                lines.append("```")
                lines.append("")
                lines.append("</details>")

            lines.append("")
    else:
        lines.append("*No custom agents found.*")
        lines.append("")
        lines.append("Agents location:")
        lines.append(f"- User: `~/.claude/agents/*.md`")
        lines.append(f"- Project: `.claude/agents/*.md`")
        lines.append("")

    # Commands Section
    lines.append("---")
    lines.append("")
    lines.append("## Custom Commands")
    lines.append("")

    if commands:
        lines.append("Custom slash commands for frequently used prompts.")
        lines.append("")

        for cmd in commands:
            fm = cmd.get("frontmatter", {}) or {}
            name = cmd.get("name", "/unknown")
            namespace = cmd.get("namespace")
            desc = fm.get("description", "No description")

            scope_display = f"{cmd['scope']}"
            if namespace:
                scope_display += f":{namespace}"

            lines.append(f"### {name} ({scope_display})")
            lines.append("")
            lines.append(f"**Path:** [{cmd['path']}](file://{cmd['path']})")
            lines.append(f"**Description:** {desc}")

            if fm.get("allowed-tools"):
                lines.append(f"**Allowed tools:** `{fm['allowed-tools']}`")
            if fm.get("model"):
                lines.append(f"**Model:** `{fm['model']}`")
            if fm.get("argument-hint"):
                lines.append(f"**Arguments:** `{fm['argument-hint']}`")

            if cmd.get("preview"):
                lines.append("")
                lines.append("<details>")
                lines.append("<summary>Command preview</summary>")
                lines.append("")
                lines.append("```markdown")
                lines.append(cmd["preview"])
                lines.append("```")
                lines.append("")
                lines.append("</details>")

            lines.append("")
    else:
        lines.append("*No custom commands found.*")
        lines.append("")
        lines.append("Commands location:")
        lines.append(f"- User: `~/.claude/commands/*.md`")
        lines.append(f"- Project: `.claude/commands/*.md`")
        lines.append("")

    # Footer
    lines.append("---")
    lines.append("")
    lines.append("## Additional Resources")
    lines.append("")
    lines.append("- Use `/memory` to edit memory files interactively")
    lines.append("- Use `/context` to see token usage breakdown")
    lines.append("- Use `/mcp` to manage MCP servers")
    lines.append("- Use `/agents` to manage custom agents")
    lines.append("- Use `/hooks` to manage hooks")
    lines.append("")

    return "\n".join(lines)


def main():
    """Main entry point."""
    project_dir = Path.cwd()
    output_file = None

    if len(sys.argv) > 1:
        project_dir = Path(sys.argv[1])
    if len(sys.argv) > 2:
        output_file = Path(sys.argv[2])

    report = generate_report(project_dir)

    if output_file:
        output_file.write_text(report, encoding="utf-8")
        print(f"Report written to: {output_file}")
    else:
        print(report)


if __name__ == "__main__":
    main()
