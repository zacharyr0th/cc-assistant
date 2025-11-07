# Claude Code Security Documentation Summary

## Core Security Architecture

Claude Code implements security through multiple layers. The platform uses "strict read-only permissions by default" and requires explicit approval before executing sensitive actions like file editing or command execution.

## Key Protections

**Permission-based controls** form the foundation. Users maintain direct oversight—"Claude Code can only write to the folder where it was started and its subfolders," preventing unintended modifications to parent directories.

**Sandboxing capabilities** isolate bash commands with filesystem and network restrictions, reducing permission prompts while maintaining security boundaries.

The system includes "risky commands that fetch arbitrary content from the web like `curl` and `wget`" on a blocklist by default to prevent prompt injection attacks.

## Prompt Injection Safeguards

Claude Code defends against injection attacks through:
- Permission requirements for sensitive operations
- Context-aware instruction analysis
- Input sanitization and command blocklisting
- Isolated context windows for web fetching
- Trust verification for new codebases and MCP servers
- Encrypted credential storage

## Additional Protections

Network requests require user approval. Complex bash commands include natural language explanations. The system applies "fail-closed matching"—unrecognized commands default to requiring manual approval.

## Windows-Specific Warning

WebDAV is deprecated and creates security risks on Windows systems, potentially allowing Claude Code to bypass permission controls.

## Cloud Security

Isolated virtual machines, network access controls, credential protection via secure proxy, branch restrictions on git operations, audit logging, and automatic session cleanup protect cloud-based usage.

## Best Practices

Users should review all suggested commands, avoid piping untrusted content directly, verify critical file changes, and consider virtual machines for external service interactions.
