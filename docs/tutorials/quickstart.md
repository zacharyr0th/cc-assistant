# Claude Code Quickstart Guide

## Prerequisites
Users need a terminal, a code project, and either a Claude.ai or Claude Console account before starting.

## Installation Methods

Claude Code offers multiple installation approaches. For macOS and Linux users, Homebrew provides the easiest path: `brew install --cask claude-code`. Alternatively, a curl-based installer works across macOS, Linux, and WSL systems. Windows users can choose between PowerShell or CMD installation scripts. Node.js developers can install via npm with version 18 or newer.

## Authentication Process

"When you start an interactive session with the `claude` command, you'll need to log in." Users authenticate using the `/login` command or during their initial session. Both Claude.ai subscriptions and Claude Console API accounts are supported, with credentials persisting after the first login for future sessions.

## Starting Your First Session

After authentication, users navigate to their project directory and launch the CLI with `claude`. The welcome screen displays session details and previous conversations. Users can type `/help` to discover available commands.

## Initial Interactions

Claude analyzes the codebase to answer questions about project functionality, technology stack, and structure. It can also explain its own capabilities without requiring users to manually provide context.

## Making Code Changes

The system proposes modifications and requests approval before editing files. Users can approve individual changes or enable batch acceptance mode.

## Git Integration

Claude handles version control conversationally, allowing users to check modified files, create commits, manage branches, and resolve conflicts through natural language requests.

## Essential Commands

Key operations include:
- `claude` - Interactive mode
- `claude "task"` - One-time execution
- `claude -c` - Continue recent conversation
- `claude commit` - Git operations
