# Claude Code Settings Documentation - Complete Content Summary

## Overview
Claude Code provides comprehensive configuration options through settings files, environment variables, and command-line tools to customize behavior across global, project, and enterprise levels.

## Settings Files Architecture

The system uses a hierarchical structure with four configuration layers:

1. **User settings** (`~/.claude/settings.json`) - Apply globally across projects
2. **Project settings** - Two types:
   - `.claude/settings.json` - Team-shared, version-controlled settings
   - `.claude/settings.local.json` - Personal preferences, git-ignored
3. **Enterprise managed policies** - Override all other settings on managed deployments
4. **Managed MCP servers** - Enterprise-controlled integrations

## Core Configuration Options

The settings.json file supports numerous parameters including:

- `apiKeyHelper` - Custom authentication script
- `cleanupPeriodDays` - Chat transcript retention (default: 30 days)
- `companyAnnouncements` - User-facing messages
- `env` - Environment variables for sessions
- `includeCoAuthoredBy` - Git commit attribution toggle
- `permissions` - Access control rules
- `hooks` - Pre/post tool execution commands
- `model` - Default model override
- `statusLine` - Custom context display
- `outputStyle` - System prompt adjustments

## Permission Configuration

Permissions follow specific rules:

- "Allow lists specify permitted actions like `Bash(npm run lint)`"
- "Deny rules block file access and command execution including sensitive paths"
- "Ask rules prompt for confirmation before tool use"
- Bash patterns use prefix matching, not regex

Sensitive files can be excluded: `Read(./.env)`, `Read(./secrets/**)`, etc.

## Sandboxing Settings

Available for macOS/Linux with configurable:
- Filesystem isolation via Read/Edit rules
- Network restrictions via WebFetch rules
- Unix socket access
- Local binding permissions
- Proxy configuration options

## Subagent & Plugin Configuration

**Subagents** are stored as Markdown files with YAML frontmatter:
- User level: `~/.claude/agents/`
- Project level: `.claude/agents/`

**Plugins** extend functionality through:
- `enabledPlugins` - Control which plugins are active
- `extraKnownMarketplaces` - Register custom plugin sources

## Settings Precedence (Highest to Lowest)

1. Enterprise managed policies
2. Command-line arguments
3. Local project settings
4. Shared project settings
5. User settings

## Environment Variables

"All environment variables can also be configured in settings.json"

Notable variables include:
- `ANTHROPIC_API_KEY` / `ANTHROPIC_AUTH_TOKEN` - Authentication
- `ANTHROPIC_MODEL` - Model selection
- Model-specific timeout and output limits
- Proxy configuration (`HTTP_PROXY`, `HTTPS_PROXY`)
- Telemetry and update controls
- Extended thinking token budget via `MAX_THINKING_TOKENS`

## Available Tools

Claude Code accesses twelve primary tools:

- **Bash** - Shell command execution (requires permission)
- **Edit/Write** - File modifications (requires permission)
- **Read** - File content access
- **Glob/Grep** - File discovery and searching
- **WebFetch/WebSearch** - Network operations (requires permission)
- **NotebookEdit/NotebookRead** - Jupyter notebook handling
- **SlashCommand** - Custom command execution
- **Task** - Multi-step subagent operations
- **TodoWrite** - Task list management

## Key Implementation Notes

- "Use the `/config` command when using the interactive REPL, which opens a tabbed Settings interface"
- Memory files (CLAUDE.md) load at startup for contextual instructions
- System prompt not published; use CLAUDE.md or `--append-system-prompt` for customization
- Hook system enables custom commands around tool execution
- MCP servers extend functionality with additional integrations

## Security Considerations

Enterprise deployments can enforce:
- Managed policy lockdowns preventing user overrides
- MCP server allowlists/denylists
- Sandbox requirements for bash execution
- File access restrictions for credentials and secrets
