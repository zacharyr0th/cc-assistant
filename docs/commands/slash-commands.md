# Claude Code Slash Commands Documentation

## Overview

Slash commands enable interactive control over Claude's behavior during sessions. They fall into three categories: built-in commands, custom user-defined commands, and MCP server-exposed commands.

## Built-in Commands

Claude Code provides 30+ built-in commands for essential operations:

**Conversation Management**: `/clear` (remove history), `/compact` (condense with focus), `/rewind` (undo changes), `/export` (save to file)

**Model & Settings**: `/model` (switch AI model), `/config` (access settings), `/status` (view version/connectivity), `/output-style` (adjust formatting)

**Code Operations**: "/review" (request assessment), "/sandbox" (isolated execution), "/context" (visualize token usage)

**System Tools**: "/help" (command reference), "/doctor" (diagnose installation), "/exit" (quit REPL)

**Advanced Features**: "/mcp" (manage MCP servers), "/memory" (edit CLAUDE.md), "/permissions" (control access), "/usage" (check plan limits)

## Custom Slash Commands

Users can create personalized commands as Markdown files for frequently-used prompts.

**Project Commands** (`.claude/commands/`): Team-shared commands stored in repositories
**Personal Commands** (`~/.claude/commands/`): Individual commands available across all projects

### Key Features

**Arguments**: Pass dynamic values using `$ARGUMENTS` (all arguments) or `$1`, `$2` (positional parameters)

**Bash Integration**: Execute shell commands with `!` prefix; requires "allowed-tools" specification in frontmatter

**File References**: Include file contents using `@` prefix for direct references

**Namespacing**: Organize via subdirectories; conflicts between project/personal levels aren't supported

**Frontmatter Options**: Specify `description`, `allowed-tools`, `model`, `argument-hint`, and `disable-model-invocation`

## MCP Commands

MCP servers expose slash commands following the pattern: `/mcp__<server-name>__<prompt-name>`

Commands are automatically discovered when servers connect successfully. "MCP permissions support exact and prefix matching," but wildcards aren't permitted—use `mcp__servername` for all tools or list specific tools individually.

## SlashCommand Tool

Claude can programmatically invoke custom commands via the SlashCommand tool during conversations. This requires:
- User-defined commands only (built-ins excluded)
- Populated `description` frontmatter field
- Character budget limit (default 15,000 characters)

Disable via `/permissions` or individual commands using `disable-model-invocation: true`.

## Skills vs. Slash Commands

**Slash commands** suit quick, single-file prompts with manual invocation; "use for simple prompt snippets you use often."

**Agent Skills** handle complex, multi-file workflows with automatic discovery and standardized team processes.

---

**Key Resources**: `/help` lists all available commands; `/mcp` manages server connections; `/context` monitors token consumption
