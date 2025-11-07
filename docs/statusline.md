# Claude Code Status Line Configuration Documentation

## Overview
This documentation explains how to create custom status lines for Claude Code that display contextual information at the bottom of the interface, similar to shell prompts like PS1 in Oh-my-zsh.

## Setup Methods

Users can configure status lines through two approaches:

1. **Interactive command**: Running `/statusline` allows Claude Code to assist with setup, including reproducing terminal prompts or custom behaviors
2. **Direct configuration**: Add a `statusLine` command to `.claude/settings.json` that points to a script file

## Operational Details

The status line system works by executing a user-defined command that receives session data via stdin as JSON. Key characteristics include:

- Updates trigger when conversation messages change
- Updates occur at maximum intervals of 300 milliseconds
- "The first line of stdout from your command becomes the status line text"
- ANSI color codes enable styling capabilities
- Sessions pass contextual data including model information, directory paths, and usage costs

## Available Data Structure

Scripts receive comprehensive JSON input containing:
- Session identifiers and transcript locations
- Current and project directories
- Model specifications (ID and display name)
- Cost metrics (total expenditure, duration, API duration, code modifications)
- Version and styling information

## Implementation Examples

The documentation provides sample implementations in:
- **Bash** (simple and git-aware versions with jq parsing)
- **Python** (using json and os modules)
- **Node.js** (with stdin event handling)
- **Helper function pattern** (for complex bash requirements)

## Best Practices

Users should maintain concise, single-line output and test scripts using mock JSON input before deployment. Scripts require executable permissions and proper stdout output to function correctly.
