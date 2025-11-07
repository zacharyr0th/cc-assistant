# Claude Code Hooks Guide: Events and Automation

## Overview

Claude Code hooks are shell commands that execute at specific points in the tool's lifecycle, providing deterministic control over behavior. As stated in the documentation, "hooks provide deterministic control over Claude Code's behavior, ensuring certain actions always happen."

## Hook Events

The system supports nine trigger points:

- **PreToolUse**: Executes before tool calls and can block them
- **PostToolUse**: Runs after tool completion
- **UserPromptSubmit**: Triggers when users submit prompts
- **Notification**: Fires when Claude sends alerts
- **Stop**: Activates when Claude finishes responding
- **SubagentStop**: Runs when subagent tasks complete
- **PreCompact**: Executes before compacting operations
- **SessionStart**: Triggers on new or resumed sessions
- **SessionEnd**: Activates when sessions terminate

## Common Use Cases

The guide highlights five primary applications:

1. **Notifications**: Customizing how you receive input alerts
2. **Code Formatting**: Auto-running tools like prettier or gofmt post-edit
3. **Logging**: Tracking executed commands for compliance
4. **Feedback**: Providing automated code-style validation
5. **Permissions**: Blocking modifications to sensitive files

## Security Considerations

A critical warning emphasizes that "hooks run automatically during the agent loop with your current environment's credentials," making malicious implementations a data exfiltration risk. Users should review implementations thoroughly before registration.

## Practical Examples

The guide provides implementations for:
- Bash command logging
- TypeScript auto-formatting
- Markdown language detection and fixing
- Desktop notifications
- Production file protection
