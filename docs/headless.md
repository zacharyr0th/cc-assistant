# Claude Code Headless Mode Documentation Summary

## Core Functionality

Claude Code's headless mode enables programmatic execution without interactive interfaces. The primary command uses the `--print` or `-p` flag to "Run in non-interactive mode" and display final results.

## Essential Configuration Options

Key flags for automation include:

- **`--output-format`**: Supports text, JSON, or stream-json formats for structured data retrieval
- **`--resume`/`--continue`**: Enable multi-turn conversations by resuming previous sessions
- **`--allowedTools`/`--disallowedTools`**: Control which tools the model can access
- **`--append-system-prompt`**: Inject custom instructions (print mode only)
- **`--mcp-config`**: Load external MCP servers from configuration files
- **`--verbose`**: Enable detailed logging for debugging

## Output Formats

**JSON responses** include metadata like execution duration, token costs, session IDs, and turn counts. **Stream-JSON format** emits individual messages as received, starting with initialization and ending with statistical summaries.

## Input Methods

The tool accepts direct text arguments, stdin input, or **structured JSON via streaming format**, allowing multi-turn conversations without relaunching the process.

## Integration Examples

Three practical demonstrations showcase SRE incident response automation, security pull-request auditing, and legal document review with session persistence using jq parsing utilities.

## Recommended Practices

- Parse JSON responses programmatically for reliable data extraction
- Implement error handling via exit codes and stderr monitoring
- Manage conversation context through session identifiers
- Apply timeout constraints for extended operations
- Observe rate-limiting intervals between sequential requests
