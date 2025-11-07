# Claude Code Output Styles Documentation

## Overview
Output styles customize Claude Code's behavior beyond standard software engineering tasks by modifying the system prompt while preserving core capabilities like script execution and file management.

## Built-in Styles

**Default**: The standard system prompt designed for efficient software engineering work.

**Explanatory**: Includes educational insights between coding tasks to help users understand implementation choices and patterns.

**Learning**: A collaborative mode where Claude shares insights and requests user contributions through `TODO(human)` markers, creating a learn-by-doing experience.

## How They Function

Output styles work by directly altering the system prompt. Non-default styles remove code-generation-specific instructions and add custom guidance instead, as they "exclude instructions specific to code generation and efficient output normally built into Claude Code."

## Switching Styles

Users can select output styles via:
- `/output-style` command (opens menu)
- `/output-style [style]` for direct switching
- `/config` menu

Settings save locally in `.claude/settings.local.json`.

## Creating Custom Styles

Run `/output-style:new I want an output style that ...` to create personalized styles. Custom styles are stored as markdown files at the user level (`~/.claude/output-styles`) or project level (`.claude/output-styles`) with defined name, description, and custom instructions.

## Related Features

**vs. CLAUDE.md**: Output styles modify the core system prompt; CLAUDE.md operates as a user message after the default prompt.

**vs. Agents**: Output styles affect the main agent loop's system prompt, while agents handle specific tasks with customizable models and tools.

**vs. Custom Slash Commands**: Output styles function as stored system prompts; slash commands serve as stored user prompts.
