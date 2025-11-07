# Identity and Access Management - Complete Content Summary

## Authentication Methods

Claude Code supports three authentication approaches for team access:

1. **Claude API via Console** - Users are invited through the Console with either "Claude Code" role (API keys only) or "Developer" role (any API key type). Each user must accept the invite, check system requirements, install Claude Code, and login with Console credentials.

2. **Amazon Bedrock** - Teams follow Bedrock documentation, distribute environment variables and credential generation instructions, then users install Claude Code.

3. **Google Vertex AI** - Similar to Bedrock, teams reference Vertex documentation and distribute configuration details.

## Access Control & Permissions

Claude Code employs a tiered permission system with three tool categories:

- **Read-only tools** (file reads, LS, Grep) require no approval
- **Bash commands** require approval per project directory and command
- **File modification** (edit/write) requires approval until session end

### Permission Rules

The system supports three rule types with hierarchical precedence:

- **Allow rules** grant unrestricted tool usage
- **Ask rules** prompt for confirmation (override Allow)
- **Deny rules** prevent usage entirely (highest precedence)

Users manage permissions via the `/permissions` command, which displays all active rules sourced from settings.json.

### Permission Modes

Claude Code offers four operational modes configurable as `defaultMode`:

- `default` - Standard prompting on first tool use
- `acceptEdits` - Auto-accepts file editing permissions
- `plan` - Analysis-only mode without file modifications or command execution
- `bypassPermissions` - Skips all prompts in controlled environments

### Fine-Grained Controls

**Bash patterns** use prefix matching with wildcard support:
- `Bash(npm run test:*)` matches commands starting with "npm run test"
- Documentation warns that patterns can be bypassed through options, protocol changes, redirects, variables, or spacing variations

**Read/Edit rules** follow gitignore specifications with path patterns:
- `//path` for absolute filesystem paths
- `~/path` for home directory paths
- `/path` relative to settings file location
- `path` relative to current working directory

**WebFetch** supports domain-specific rules: `WebFetch(domain:example.com)`

**MCP tools** use format `mcp__servername` or `mcp__servername__toolname` (wildcards unsupported)

## Enterprise & Precedence

Enterprise administrators can deploy managed policies at system level that override all user and project settings:

- macOS: `/Library/Application Support/ClaudeCode/managed-settings.json`
- Linux/WSL: `/etc/claude-code/managed-settings.json`
- Windows: `C:\ProgramData\ClaudeCode\managed-settings.json`

Settings precedence (highest to lowest):
1. Enterprise policies
2. Command line arguments
3. Local project settings
4. Shared project settings
5. User settings

## Credential Management

Credentials are securely stored in the encrypted macOS Keychain, supporting "Claude API credentials, Bedrock Auth, and Vertex Auth" among other types. The `apiKeyHelper` setting enables custom shell scripts for API key retrieval with default 5-minute refresh intervals, configurable via `CLAUDE_CODE_API_KEY_HELPER_TTL_MS` environment variable.
