# Model Context Protocol (MCP) Documentation

## Overview

MCP is "an open-source standard for AI-tool integrations" that enables Claude Code to connect with external tools, databases, and APIs through MCP servers.

## Capabilities

With MCP servers connected, you can:

- Implement features from issue trackers and create pull requests
- Analyze monitoring data from error tracking services
- Query databases with natural language
- Integrate design systems into development workflows
- Automate multi-step processes across applications

## Installation Methods

Claude Code supports three configuration approaches:

**HTTP Servers (Recommended)**
Remote cloud-based services use HTTP transport:
```bash
claude mcp add --transport http notion https://mcp.notion.com/mcp
```

**SSE Servers (Deprecated)**
Server-Sent Events transport, phased out in favor of HTTP.

**Stdio Servers**
Local processes for tools requiring system access:
```bash
claude mcp add --transport stdio airtable --env AIRTABLE_API_KEY=YOUR_KEY -- npx -y airtable-mcp-server
```

The `--` separator distinguishes Claude's flags from the server command.

## Configuration Scopes

- **Local**: Project-specific, private configurations
- **Project**: Team-shared via `.mcp.json` in version control
- **User**: Cross-project personal tools

## Server Management

Core commands include:
```bash
claude mcp list          # View all servers
claude mcp get [name]    # Details for specific server
claude mcp remove [name] # Delete configuration
/mcp                     # Check status within Claude Code
```

## Authentication

Many cloud services use OAuth 2.0. Within Claude Code, run `/mcp` to authenticate through your browser. Tokens are stored securely and auto-refresh.

## Resource & Prompt Features

- **@mentions**: Reference MCP resources using `@server:protocol://resource/path`
- **Slash commands**: Execute MCP prompts as `/mcp__servername__promptname`

## Enterprise Management

Administrators can deploy centralized configurations via `managed-mcp.json` with allowlist/denylist controls in `managed-settings.json` to standardize MCP access across organizations.
