# Claude Code Settings Documentation

## Configuration File Hierarchy

Claude Code uses a tiered settings system with this precedence order:

1. **Enterprise managed policies** (highest priority) - deployed by IT/DevOps at system level
2. **Command line arguments** - temporary session overrides
3. **Local project settings** (`.claude/settings.local.json`) - personal, not version-controlled
4. **Shared project settings** (`.claude/settings.json`) - team configurations in source control
5. **User settings** (`~/.claude/settings.json`) - global personal preferences

## Settings File Locations

**User level:** `~/.claude/settings.json`

**Project level:**
- `.claude/settings.json` (shared with team)
- `.claude/settings.local.json` (personal, git-ignored)

**Enterprise level:**
- macOS: `/Library/Application Support/ClaudeCode/managed-settings.json`
- Linux/WSL: `/etc/claude-code/managed-settings.json`
- Windows: `C:\ProgramData\ClaudeCode\managed-settings.json`

## Core Configuration Options

Key settings available in `settings.json` include:

| Setting | Purpose |
|---------|---------|
| `permissions` | Control tool access via allow/ask/deny rules |
| `env` | Define environment variables for all sessions |
| `model` | Override default Claude model |
| `sandbox` | Configure bash command isolation |
| `hooks` | Run custom commands before/after tool execution |
| `companyAnnouncements` | Display startup messages to users |
| `apiKeyHelper` | Script for generating authentication tokens |

## Permission System

The permission framework uses three directive types:

- **allow**: Grant specific tool access
- **ask**: Prompt for confirmation before tool use
- **deny**: Prevent tool access or file reads

Example permission structure for sensitive files:

```json
"permissions": {
  "deny": [
    "Read(./.env)",
    "Read(./.env.*)",
    "Read(./secrets/**)"
  ]
}
```

## Sandboxing Configuration

Bash sandboxing isolates commands from filesystem and network. Key options:

- `enabled` - Activate sandboxing (macOS/Linux)
- `excludedCommands` - Commands running outside sandbox
- `network.allowUnixSockets` - Accessible socket paths
- `allowUnsabledCommands` - Toggle escape hatch capability

## Environment Variables

Notable environment variables for configuration:

| Variable | Function |
|----------|----------|
| `ANTHROPIC_API_KEY` | Authentication token |
| `ANTHROPIC_MODEL` | Model selection |
| `DISABLE_TELEMETRY` | Opt out of analytics |
| `MAX_THINKING_TOKENS` | Enable extended thinking mode |
| `BASH_MAX_TIMEOUT_MS` | Command timeout limit |

All environment variables can be defined in `settings.json` for automatic session application.

## Tool Access & Permissions

Claude Code operates with 12 primary tools (Bash, Edit, Read, Write, etc.). Each requires explicit permission configuration. Use the `/allowed-tools` command to manage access or configure rules in settings.

## Plugin & Subagent Management

- **User subagents:** `~/.claude/agents/`
- **Project subagents:** `.claude/agents/`
- **Plugin configuration:** Enable/disable via `enabledPlugins` in `settings.json`
- **Marketplaces:** Configure additional plugin sources with `extraKnownMarketplaces`
