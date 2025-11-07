# Claude Code Slash Commands Documentation

## Overview

This comprehensive guide covers slash commands in Claude Code—tools that control Claude's behavior during interactive sessions. The documentation is organized into several key sections:

**Built-in Commands**: The system includes 40+ native commands like `/clear` (clearing conversation history), `/cost` (showing token usage), `/model` (changing AI models), and `/sandbox` (enabling isolated execution environments).

**Custom Slash Commands**: Users can create personalized commands as Markdown files stored in project-specific (`.claude/commands/`) or personal (`~/.claude/commands/`) directories. These support "argument placeholders like `$ARGUMENTS` or `$1`, `$2` for positional parameters."

**Advanced Features Include**:

- Namespacing through subdirectories for organization
- Bash command execution using the `!` prefix
- File references with the `@` symbol
- Extended thinking mode activation
- Frontmatter metadata (allowed tools, descriptions, model selection)

**Plugin Commands**: "Plugin commands work exactly like user-defined commands but are distributed through plugin marketplaces" and use the format `/plugin-name:command-name` when disambiguation is needed.

**MCP Slash Commands**: Commands exposed by connected MCP servers follow the pattern `/mcp__<server-name>__<prompt-name>` and are dynamically discovered.

**SlashCommand Tool**: Claude can programmatically execute custom slash commands during conversations, subject to permission rules and character budget limits (default 15,000 characters).

**Comparison with Skills**: The documentation distinguishes slash commands (simple, single-file prompts) from Agent Skills (complex, multi-file capabilities with structured workflows).
