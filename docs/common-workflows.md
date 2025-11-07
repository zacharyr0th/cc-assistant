# Claude Code Common Workflows Documentation

This comprehensive guide covers practical workflows for Claude Code, Anthropic's CLI tool for developers.

## Core Workflows Covered

**Understanding Codebases**: Start with broad overview questions, then narrow to specific components. Ask about architecture patterns, data models, and authentication mechanisms.

**Bug Fixing**: Share error messages and stack traces with Claude, request fix recommendations, and apply solutions. The guide emphasizes reproducing errors consistently.

**Code Refactoring**: Identify legacy patterns, get modernization suggestions, apply changes incrementally, and verify with tests.

**Specialized Subagents**: Access dedicated agents via `/agents` command for security reviews, testing, and custom workflows tailored to project needs.

**Plan Mode**: Use read-only analysis for safe exploration. Enable via Shift+Tab or `--permission-mode plan` flag for complex changes requiring extensive planning.

**Testing**: Identify untested functions, generate test scaffolding, add edge case coverage, and verify with test runs.

**Pull Requests**: Summarize changes, generate PR descriptions, and highlight potential risks using the `create a pr` command.

**Documentation**: Find undocumented code, generate appropriate comments (JSDoc, docstrings), and ensure consistency with project standards.

**Image Analysis**: Drag, paste, or reference images for UI analysis, error investigation, and design-to-code conversion.

**File References**: Use @ syntax to include specific files or directories without waiting for automatic processing.

**Extended Thinking**: Enable with Tab or environment variables for complex architectural decisions and multi-step debugging.

**Conversation Resumption**: Use `--continue` for recent sessions or `--resume` for interactive selection of past conversations.

**Parallel Sessions**: Leverage Git worktrees for simultaneous independent Claude instances across different branches.

**Unix Integration**: Pipe data through Claude in scripts using headless mode (`-p` flag) with customizable output formats.

**Custom Slash Commands**: Create reusable project-specific or personal commands in `.claude/commands/` directories with `$ARGUMENTS` support.
