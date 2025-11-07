# Claude Code Headless Mode Documentation

## Core Functionality

Headless mode enables programmatic execution of Claude Code without interactive UI. The primary interface uses the `claude` command with the `--print` (`-p`) flag for "non-interactive mode and print the final result."

## Key CLI Options

Essential flags for automation include:

- **`--print` / `-p`**: Activates non-interactive operation
- **`--output-format`**: Supports `text`, `json`, or `stream-json` formats
- **`--resume` / `--continue`**: Manages multi-turn conversation sessions
- **`--allowedTools` / `--disallowedTools`**: Controls which tools the model can access
- **`--append-system-prompt`**: Injects custom instructions (print mode only)
- **`--verbose`**: Enables detailed logging
- **`--mcp-config`**: Loads MCP server configurations from JSON files

## JSON Input/Output Handling

JSON responses include structured metadata: operation cost, execution duration, turn count, and session identifiers. The system supports three output approaches:

1. **Text output** (default): Direct response text
2. **JSON output**: Complete response object with metadata
3. **Streaming JSON**: Iterative message emission via `jsonl` format

Input similarly accepts text or streaming JSON via stdin, enabling real-time guidance during processing.

## Multi-Turn Conversation Management

Sessions persist via unique identifiers, allowing resumed interactions: "Resume a specific conversation by session ID" and continue previous discussions without restarting the binary.

## Integration Patterns

Example use cases demonstrate SRE incident response automation, security PR audits, and legal document review with persistent context across multiple analytical steps.
