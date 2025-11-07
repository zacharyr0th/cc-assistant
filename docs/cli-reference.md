# Claude Code CLI Reference - Complete Documentation Summary

## Overview
This documentation provides a comprehensive guide to Claude Code's command-line interface, covering all available commands, flags, and configuration options.

## Core Commands

The CLI supports several primary operations:

- **Interactive REPL**: Start with `claude` or `claude "query"` for an initial prompt
- **Print mode**: Use `-p` flag to query and exit without interactive continuation
- **Piped input**: Process file content directly via stdin with `cat file | claude -p "query"`
- **Session management**: Resume conversations with `-c` for recent sessions or `-r` with a specific session ID
- **Maintenance**: Update via `claude update` and configure MCP servers with `claude mcp`

## Essential Flags

Key customization options include:

**Workflow flags:**
- `--print` / `-p`: Execute query and return result without interactive mode
- `--continue`: Load the most recent conversation
- `--resume`: Restore a specific session by ID

**Tool control:**
- `--allowedTools` and `--disallowedTools`: Manage permissions beyond settings.json
- `--dangerously-skip-permissions`: Bypass permission prompts (cautionary use)

**System customization:**
- `--system-prompt`: "Replace the entire system prompt with custom text"
- `--append-system-prompt`: Add instructions while preserving defaults
- `--system-prompt-file`: Load prompts from files (print mode only)

**Advanced options:**
- `--output-format`: Choose text, json, or stream-json formatting
- `--verbose`: Enable detailed turn-by-turn logging
- `--max-turns`: Limit agentic iterations
- `--model`: Specify model version (sonnet, opus, or full name)

## Subagents Configuration

Custom subagents require JSON with required fields for description and prompt, plus optional tools and model specification, enabling specialized agent behavior for distinct tasks.

## Best Practices

The documentation recommends `--append-system-prompt` for most scenarios, as it maintains Claude Code's built-in capabilities while adding custom requirements. Use complete replacement only when full control is necessary.
