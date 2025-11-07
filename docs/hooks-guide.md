# Claude Code Hooks: Complete Documentation Summary

## Overview
Claude Code hooks are customizable shell commands executing at designated lifecycle points. They provide deterministic behavior control, ensuring specific actions execute reliably rather than depending on LLM decisions.

## Primary Use Cases
The documentation highlights five key applications:
- **Notifications**: Customize how alerts appear when Claude awaits user input
- **Automatic formatting**: Apply code formatters (prettier, gofmt) after edits
- **Logging**: Track executed commands for compliance/debugging purposes
- **Feedback**: Deliver automated responses when code violates conventions
- **Custom permissions**: "Block modifications to production files or sensitive directories"

## Hook Events Available
Nine distinct event types trigger at different workflow moments:
- PreToolUse, PostToolUse, UserPromptSubmit, Notification, Stop, SubagentStop, PreCompact, SessionStart, SessionEnd

Each receives different data and controls Claude's behavior differently.

## Critical Security Warning
The documentation emphasizes: "hooks run automatically during the agent loop with your current environment's credentials." Malicious hooks could exfiltrate data, requiring careful review before registration.

## Practical Examples Provided
1. **Bash command logging**: Uses `jq` to extract and log commands
2. **TypeScript formatting**: Applies Prettier post-edit
3. **Markdown enhancement**: Python script auto-detects code languages and fixes formatting
4. **Desktop notifications**: Cross-platform alert system
5. **File protection**: Prevents edits to sensitive files like `.env`

Each example includes complete implementation details and configuration structures.
