# Claude Code Hooks Reference - Complete Content Summary

This comprehensive documentation covers implementing hooks in Claude Code, a CLI tool for Claude. Here are the key sections:

## Configuration & Structure

Hooks are defined in settings files (user, project, or local) using matchers that pattern-match tool names. The system supports regex patterns like `"Edit|Write"` or `"*"` for all tools. According to the documentation, "Hooks are organized by matchers, where each matcher can have multiple hooks."

## Hook Types

Two execution types exist:
- **Command hooks**: Execute bash scripts with optional timeouts
- **Prompt-based hooks**: Use an LLM to evaluate decisions via JSON responses

The documentation specifies that prompt-based hooks work best with Stop and SubagentStop events.

## Supported Events

The system supports multiple hook events including:
- PreToolUse / PostToolUse
- UserPromptSubmit
- Stop / SubagentStop
- SessionStart / SessionEnd
- Notification
- PreCompact

## Input/Output

Hooks receive JSON data via stdin containing session information and event-specific details. Output can use simple exit codes (0 for success, 2 for blocking errors) or structured JSON for sophisticated control.

## Plugin Integration

"Plugin hooks are defined in the plugin's `hooks/hooks.json` file" and automatically merge with user/project configurations when enabled.

## Security

The documentation includes explicit warnings: hooks "execute arbitrary shell commands on your system automatically" and users are "solely responsible for the commands" configured. Best practices include input validation, proper quoting, and using absolute paths.
