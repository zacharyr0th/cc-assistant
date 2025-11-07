# Claude Code Hooks: Complete Documentation

## Configuration System

Claude Code hooks are managed through settings files at multiple levels:
- User-level: `~/.claude/settings.json`
- Project-level: `.claude/settings.json`
- Local overrides: `.claude/settings.local.json`

Hooks are organized by event type, with each event containing matchers and hook arrays. The matcher system uses case-sensitive patterns—supporting exact strings, regex patterns, and wildcards to identify which tools trigger specific hooks.

## Event Types

The system supports eight primary hook events:

**PreToolUse** and **PostToolUse** fire before and after tool execution respectively, supporting matchers for tools like Bash, Read, Write, Edit, and web operations.

**UserPromptSubmit** activates when users submit prompts, enabling validation and context injection before Claude processes requests.

**Stop** and **SubagentStop** trigger when agents finish responding, allowing intelligent decisions about whether work should continue.

**SessionStart** and **SessionEnd** manage session lifecycle, with SessionStart supporting environment variable persistence through `CLAUDE_ENV_FILE`.

**Notification** and **PreCompact** handle system notifications and memory optimization.

## Hook Execution Types

Two execution models exist:

**Command-based hooks** execute bash scripts, providing deterministic rule application. They receive JSON input via stdin and communicate through exit codes and structured output.

**Prompt-based hooks** (currently limited to Stop/SubagentStop/UserPromptSubmit/PreToolUse) query an LLM for context-aware decisions. The hook sends a prompt to Claude Haiku, which returns structured JSON with approval/block decisions.

## Input/Output Schema

Hooks receive JSON containing session metadata: "session_id, transcript_path, cwd, permission_mode, and hook_event_name" along with event-specific fields. Different events populate different input structures—PreToolUse includes tool_name and tool_input, while UserPromptSubmit provides the prompt text.

Output mechanisms include exit codes (0 for success, 2 for blocking errors) and advanced JSON responses enabling granular control over tool execution, permission decisions, and context injection.

## Advanced Features

**MCP Tool Integration** allows hooks to target Model Context Protocol tools using patterns like `mcp__memory__.*` to match entire server namespaces.

**Plugin Hooks** merge automatically when plugins are enabled, using `${CLAUDE_PLUGIN_ROOT}` for file references and running in parallel with user-configured hooks.

**Environment Variables** including `CLAUDE_PROJECT_DIR` and `CLAUDE_CODE_REMOTE` enable hooks to reference project files and detect execution context.

## Security Framework

The system requires explicit acknowledgment that "hooks execute arbitrary shell commands automatically" and users bear sole responsibility for configured commands. Best practices include input validation, proper variable quoting, path traversal blocking, and absolute path usage.

Hook modifications don't apply mid-session—Claude Code snapshots hooks at startup, warning of external changes and requiring menu review before updates take effect.
