# Claude Code Agent Skills Documentation

## Overview
Agent Skills extend Claude's capabilities through modular, organized folders containing instructions, scripts, and resources. Unlike slash commands (user-invoked), Skills are "model-invoked"—Claude autonomously decides when to use them based on relevance to your request.

## Skill Types

**Personal Skills** (`~/.claude/skills/`)
- Available across all projects
- Ideal for individual workflows and experimental capabilities

**Project Skills** (`.claude/skills/`)
- Team-shared and version-controlled
- Embedded in project repositories for automatic availability

**Plugin Skills**
- Bundled within Claude Code plugins
- Function identically to personal and project variants

## Creating Skills

Each Skill requires a `SKILL.md` file with YAML frontmatter:

```markdown
---
name: [lowercase, hyphens, max 64 characters]
description: [what it does + when to use it, max 1024 characters]
---

# Skill Instructions

Your detailed instructions here...
```

The description is critical: "Brief description of what this Skill does and when to use it."

Supporting files (scripts, templates, documentation) can accompany the core file and are loaded progressively to manage context efficiently.

## Tool Restrictions

The `allowed-tools` field limits Claude's capabilities for security-sensitive workflows, enabling read-only or restricted-scope Skills without requiring explicit permission prompts each time.

## Discovery & Troubleshooting

Skills are automatically discovered from all three sources. Claude activates them based on matching descriptions to user requests.

Common issues include:
- Vague descriptions lacking specific trigger terms
- Invalid YAML syntax in frontmatter
- Incorrect file paths (use Unix-style forward slashes)
- Missing dependencies

## Team Sharing

The recommended approach distributes Skills through plugins. Alternatively, commit project Skills to git repositories; team members automatically access them upon pulling updates.
