# Complete Content Extraction: Claude Code MCP Documentation

## Overview
This documentation explains how to connect Claude Code to external tools and data sources using the Model Context Protocol (MCP), an open-source standard for AI-tool integrations.

## Key Capabilities
Claude Code can leverage MCP servers to:
- Implement features from issue trackers with automated PR creation
- Analyze monitoring and usage data across multiple platforms
- Query databases and retrieve specific information
- Integrate design assets from prototyping tools
- Automate multi-step workflows across applications

## Installation Methods

**Three transport options exist:**

1. **HTTP Servers** - Recommended for remote cloud-based services, using syntax: `claude mcp add --transport http <name> <url>`

2. **SSE Servers** - Deprecated Server-Sent Events transport, invoked via: `claude mcp add --transport sse <name> <url>`

3. **Stdio Servers** - Local processes requiring the format: `claude mcp add --transport stdio <name> -- <command>`

The double-dash (`--`) separator distinguishes Claude CLI flags from server command arguments.

## Server Management Commands
- `claude mcp list` - Display all configured servers
- `claude mcp get <name>` - View specific server details
- `claude mcp remove <name>` - Delete a server configuration
- `/mcp` - Check status and authenticate within Claude Code

## Configuration Scopes

Three scope levels organize MCP accessibility:

- **Local** (default) - Personal project-specific configurations
- **Project** - Team-shared settings via `.mcp.json` in version control
- **User** - Cross-project personal utilities

## Available MCP Servers

The documentation includes 40+ pre-configured servers across categories:
- Development & Testing Tools
- Project Management & Documentation
- Databases & Data Management
- Payments & Commerce
- Design & Media
- Infrastructure & DevOps
- Automation & Integration

## Advanced Features

**Authentication:** OAuth 2.0 support through `/mcp` command for secure connections

**Environment Variables:** Support for `${VAR}` and `${VAR:-default}` expansion in configurations

**Resource References:** Use `@servername:protocol://path` syntax to reference MCP resources

**Slash Commands:** Execute MCP prompts as `/mcp__servername__promptname`

**Output Management:** Configure token limits via `MAX_MCP_OUTPUT_TOKENS` environment variable (default 25,000)

## Enterprise Management

System administrators can deploy:
- Centralized server configurations via `managed-mcp.json`
- Access controls using allowlists and denylists in `managed-settings.json`
- Complete MCP restrictions or selective server permissions

## Security Considerations

The documentation emphasizes: "Use third party MCP servers at your own risk - Anthropic has not verified the correctness or security of all these servers."

Users should exercise caution with servers fetching untrusted content due to prompt injection risks and verify trust before installation.
