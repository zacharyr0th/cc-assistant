# Agent Skills Documentation Summary

## Overview
Agent Skills extend Claude's capabilities in Claude Code through modular packages containing instructions, scripts, and resources organized in folders with a required `SKILL.md` file.

## Key Concepts

**Model-Invoked vs User-Invoked**: Unlike slash commands that require explicit user action, "Skills are **model-invoked**—Claude autonomously decides when to use them based on your request and the Skill's description."

**Storage Locations**:
- Personal Skills: `~/.claude/skills/` (available across all projects)
- Project Skills: `.claude/skills/` (shared with team via git)
- Plugin Skills: bundled with installed plugins

## Creating a Skill

1. Create a directory with a `SKILL.md` file containing YAML frontmatter and Markdown content
2. Required frontmatter fields:
   - `name`: lowercase letters, numbers, hyphens (max 64 characters)
   - `description`: explains what the Skill does and when to use it (max 1024 characters)

3. Optional supporting files: reference documentation, examples, scripts, templates

## Discovery and Usage

Skills are automatically discovered from all three sources. Users can ask Claude directly: "What Skills are available?" or "List all available Skills."

Claude activates Skills based on request context—no explicit invocation needed. Testing involves asking questions matching the Skill's description.

## Best Practices

- Keep Skills focused on single capabilities
- Write specific descriptions with trigger terms users would mention
- Test with team members for feedback
- Document version history for tracking changes
- Use `allowed-tools` frontmatter to restrict tool access for read-only or security-sensitive workflows

## Troubleshooting

Common issues include vague descriptions preventing discovery, invalid YAML syntax, incorrect file paths, and missing dependencies. Debug mode (`claude --debug`) reveals loading errors.

## Team Sharing

Recommended approach: distribute through plugins. Alternative: commit project Skills to git; team members gain automatic access upon pulling updates.
