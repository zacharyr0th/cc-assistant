# Claude Code Security Documentation

## Security Foundation

Claude Code implements security as a core principle, built on Anthropic's comprehensive security program. The company maintains SOC 2 Type 2 compliance and ISO 27001 certification, available through the Anthropic Trust Center.

## Permission Architecture

The system employs a permission-based model where Claude Code operates with "strict read-only permissions by default." When additional capabilities are needed—such as file editing or command execution—explicit user approval is required before proceeding.

## Key Protections

**Write Access Restrictions**: Claude Code can only modify files within its starting directory and subdirectories. This creates a "clear security boundary" preventing unauthorized changes to parent directories.

**Sandboxed Execution**: The `/sandbox` command enables isolated bash operations with filesystem and network boundaries, reducing permission requests while maintaining security controls.

**Command Safeguards**: Potentially dangerous commands like `curl` and `wget` are blocklisted by default. Suspicious bash commands require manual approval even if previously allowlisted.

## Prompt Injection Defense

Claude Code protects against injection attacks through:

- Permission requirements for sensitive operations
- Context-aware analysis detecting harmful instructions
- Input sanitization preventing command injection
- Isolated context windows for web requests
- Trust verification for new codebases and MCP servers

## Data Protection

The system implements limited data retention, restricted access to session information, and user control over training preferences. Consumer users can adjust privacy settings directly in Claude.ai.

## Operational Best Practices

Users should review all suggested commands before approval, avoid piping untrusted content directly into Claude, and verify changes to critical files. Virtual machine execution is recommended when working with external services.

## Reporting Vulnerabilities

Security issues should be reported through Anthropic's HackerOne program rather than disclosed publicly, with detailed reproduction steps provided.
