# Claude Code Documentation

Comprehensive documentation for Claude Code, Anthropic's terminal-based agentic coding tool.

## Table of Contents

- [Overview](#overview)
- [Getting Started](#getting-started)
- [Core Concepts](#core-concepts)
- [API & Configuration](#api--configuration)
- [Advanced Topics](#advanced-topics)
- [Resources](#resources)

## Overview

- [Claude Code Overview](./overview.md) - What Claude Code is and its core capabilities
- [Documentation Map](./claude_code_docs_map.md) - Complete index of all official documentation

## Getting Started

### Tutorials
- [Quickstart Guide](./tutorials/quickstart.md) - Installation, authentication, and first session
- [Common Workflows](./tutorials/common-workflows.md) - Codebase analysis, bug fixes, refactoring, testing, PRs
- [Troubleshooting](./tutorials/troubleshooting.md) - Installation, performance, and IDE issues

## Core Concepts

### Agents
- [Subagents Overview](./agents/overview.md) - Specialized AI assistants with dedicated contexts
  - Configuration and delegation
  - Built-in agents
  - Creating custom agents
  - Resumable agents

### Skills
- [Skills Overview](./skills/overview.md) - Model-invoked capabilities
  - Personal vs Project skills
  - Creating skills
  - Tool restrictions
  - Team sharing
- [Create Skills Through Conversation](./tutorials/create-skill-through-conversation.md) - Tutorial on building skills conversationally

### Commands
- [Slash Commands](./commands/slash-commands.md) - Interactive control
  - Built-in commands (30+)
  - Custom user-defined commands
  - MCP commands
  - Skills vs Slash Commands comparison

### Hooks
- [Hooks Overview](./hooks/overview.md) - Event system and automation
  - Configuration system
  - Event types (PreToolUse, PostToolUse, etc.)
  - Command-based vs Prompt-based hooks
  - Security framework
- [Hooks Guide](./hooks/hooks-guide.md) - Practical examples and use cases
  - Common automation patterns
  - Security considerations
  - Code formatting examples

### MCP (Model Context Protocol)
- [MCP Overview](./mcp/overview.md) - External tool integration
  - Installation methods (HTTP, SSE, Stdio)
  - Server management
  - Authentication
  - Resource & prompt features

## API & Configuration

- [CLI Reference](./api/cli-reference.md) - Complete command-line interface
  - Core commands and flags
  - Execution control
  - System prompt options
  - Tool management

- [Settings](./api/settings.md) - Configuration hierarchy
  - File locations and precedence
  - Permission system
  - Sandboxing
  - Environment variables

- [Memory Management](./api/memory.md) - CLAUDE.md and context
  - Memory hierarchy
  - Import functionality
  - Best practices

- [Headless Mode](./api/headless.md) - Programmatic execution
  - CLI automation
  - JSON I/O
  - Multi-turn conversations
  - Integration patterns

- [Plugins](./api/plugins.md) - Extending Claude Code
  - Plugin creation
  - Installation & management
  - Team workflows
  - Development & testing

- [Security](./api/security.md) - Security best practices
  - Permission architecture
  - Prompt injection defense
  - Data protection
  - Vulnerability reporting

## Advanced Topics

### CI/CD Integration
- [GitHub Actions](./tutorials/github-actions.md) - Automated PR workflows
  - Setup and configuration
  - Enterprise cloud integration
  - Best practices
  - Cost considerations

## Resources

### Official Documentation
All documentation is sourced from the official Claude Code documentation at [code.claude.com/docs](https://code.claude.com/docs/en/).

### Additional Resources
- [Claude Code Support](https://support.claude.com/)
- [Anthropic Trust Center](https://trust.anthropic.com/) - Security & compliance
- [HackerOne Program](https://hackerone.com/anthropic) - Security vulnerability reporting

## Directory Structure

```
docs/claude/
├── README.md (this file)
├── claude_code_docs_map.md
├── overview.md
├── agents/
│   └── overview.md
├── api/
│   ├── cli-reference.md
│   ├── headless.md
│   ├── memory.md
│   ├── plugins.md
│   ├── security.md
│   └── settings.md
├── commands/
│   └── slash-commands.md
├── hooks/
│   ├── hooks-guide.md
│   └── overview.md
├── mcp/
│   └── overview.md
├── skills/
│   └── overview.md
└── tutorials/
    ├── common-workflows.md
    ├── create-skill-through-conversation.md
    ├── github-actions.md
    ├── quickstart.md
    └── troubleshooting.md
```

## Quick Links

### Essential Commands
- `/help` - Get help with available commands
- `/config` - Access settings
- `/agents` - Manage subagents
- `/mcp` - Manage MCP servers
- `/memory` - Edit CLAUDE.md files
- `/permissions` - Control tool access

### Key Concepts
- **Agents** are specialized AI assistants that Claude delegates tasks to
- **Skills** are model-invoked capabilities that Claude automatically uses when relevant
- **Slash Commands** are user-invoked shortcuts for common operations
- **Hooks** are automated scripts that run at specific lifecycle events
- **MCP** connects Claude to external tools and data sources

---

Last updated: 2025-11-06
