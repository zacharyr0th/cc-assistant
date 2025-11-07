# Claude Code CLI Reference

## Core Commands

The CLI offers several operational modes:

- **Interactive REPL**: `claude` launches an interactive session
- **Single Query**: `claude "query"` starts with an initial prompt
- **SDK Mode**: `claude -p "query"` processes and exits
- **Piped Input**: Accepts content via stdin for processing
- **Session Continuation**: `claude -c` resumes recent work; `claude -r "<id>"` restores specific sessions
- **Maintenance**: `claude update` and `claude mcp` for updates and protocol configuration

## Key Flags

**Execution Control:**
- `-p/--print` runs without interactive mode
- `--max-turns` limits agentic iterations
- `--continue` and `--resume` manage session state
- `--permission-mode` and `--permission-prompt-tool` handle access control

**Customization:**
- `--model` selects Claude version (sonnet, opus, haiku, or full model names)
- `--add-dir` expands accessible directories
- `--agents` defines custom subagents via JSON configuration

**System Prompt Options:**
- `--system-prompt` completely replaces default instructions
- `--system-prompt-file` loads from a file (print mode only)
- `--append-system-prompt` adds requirements while preserving defaults

**Output & Input:**
- `--output-format` specifies text, JSON, or stream-json
- `--input-format` configures input parsing
- `--verbose` enables detailed logging
- `--dangerously-skip-permissions` bypasses approval prompts

**Tool Management:**
- `--allowedTools` and `--disallowedTools` control tool access beyond settings files
