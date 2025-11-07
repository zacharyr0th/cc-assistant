# Claude Code Plugins Reference - Complete Content Summary

## Overview
This technical reference documents the Claude Code plugin system, covering five component types, manifest schemas, directory structures, debugging tools, and versioning guidelines.

## Five Plugin Component Types

**Commands**: Custom slash commands in `commands/` directory as Markdown files with frontmatter, integrating with Claude Code's command system.

**Agents**: Specialized subagents in `agents/` directory that Claude can invoke automatically. They include descriptions, capabilities lists, and contextual usage guidance.

**Skills**: Model-invoked capabilities in `skills/` directory within subdirectories containing `SKILL.md` files. "Claude autonomously decides when to use them based on the task context."

**Hooks**: Event handlers via `hooks/hooks.json` or inline configuration responding to nine event types including `PreToolUse`, `PostToolUse`, and `SessionStart`.

**MCP Servers**: Model Context Protocol integrations defined in `.mcp.json`, connecting external tools and services automatically when plugins are enabled.

## Plugin Manifest Structure

The `plugin.json` file requires only a `name` field (kebab-case format). Additional metadata includes version, description, author details, repository URL, license, and keywords for discovery.

Component path fields (`commands`, `agents`, `hooks`, `mcpServers`) can reference custom locations as strings or arrays, supplementing default directories rather than replacing them.

## Directory Organization

Standard layout places `.claude-plugin/plugin.json` at root, with `commands/`, `agents/`, `skills/`, and `hooks/` directories also at the plugin root. The environment variable `${CLAUDE_PLUGIN_ROOT}` provides absolute path references for cross-platform compatibility.

## Development Tools

Running `claude --debug` displays plugin loading information, manifest validation results, and registration details for commands, agents, hooks, and MCP servers.

Common troubleshooting addresses invalid JSON, incorrect directory placement, non-executable scripts, missing environment variables, and absolute path usage errors.
