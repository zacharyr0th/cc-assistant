# Claude Code Visual Studio Code Integration

## Overview
Claude Code integrates with VS Code through a native extension (beta) and CLI integration, enabling developers to leverage AI-powered code assistance directly within their IDE.

## VS Code Extension Features

The beta extension offers several capabilities:

- **Native IDE Experience**: A dedicated sidebar panel accessed via the Spark icon
- **Plan Review**: Users can "Review and edit Claude's plans before accepting them"
- **Auto-accept Mode**: Automatically applies changes as they're generated
- **Extended Thinking**: Toggleable feature accessible from the prompt input area
- **File Management**: Support for @-mentions and file/image attachments
- **MCP Server Integration**: Uses Model Context Protocol servers configured via CLI
- **Multi-session Support**: Run multiple Claude Code sessions simultaneously
- **Keyboard Shortcuts**: Terminal-equivalent shortcuts supported
- **Slash Commands**: CLI commands accessible within the extension

## Requirements & Installation

VS Code 1.98.0 or higher is required. The extension installs from the Visual Studio Code Extension Marketplace.

## Third-Party Provider Support

The extension supports Amazon Bedrock and Google Vertex AI through environment variable configuration in VS Code settings. Key variables include `CLAUDE_CODE_USE_BEDROCK`, `ANTHROPIC_API_KEY`, `AWS_REGION`, and `ANTHROPIC_VERTEX_PROJECT_ID`.

## Limitations

Currently unavailable features include MCP/Plugin configuration UI (available via CLI commands), subagents, checkpoints, conversation rewinding, advanced shortcuts, and tab completion.

## Security Guidance

The documentation warns that "Claude Code runs in VS Code with auto-edit permissions enabled, it may be able to modify IDE configuration files." Recommendations include enabling Restricted Mode for untrusted workspaces and using manual approval mode.

## Legacy CLI Integration

Terminal-based integration auto-installs when running `claude` from VS Code's integrated terminal, providing selection context sharing and diff viewing capabilities.
