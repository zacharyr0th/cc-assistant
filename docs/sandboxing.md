# Claude Code Sandboxing Documentation Summary

## Core Purpose
Claude Code implements native sandboxing to create a secure execution environment that balances security with operational efficiency, reducing constant permission prompts while maintaining protective boundaries.

## Key Security Mechanisms

**Filesystem Isolation:**
The system restricts file access to designated directories. By default, users can read system-wide but write only to their current working directory and subdirectories. Custom allowed and denied paths are configurable through settings.

**Network Isolation:**
A proxy server outside the sandbox controls domain access. "Only approved domains can be accessed" with new requests triggering permission prompts. All subprocess traffic inherits these restrictions.

**OS-Level Enforcement:**
Linux uses bubblewrap while macOS uses Seatbelt to enforce these boundaries at the operating system level.

## Implementation

Enable sandboxing via the `/sandbox` command. Configuration occurs through `settings.json` with customizable network and filesystem rules.

## Security Advantages

Sandboxing protects against prompt injection attacks, malicious dependencies, compromised scripts, and social engineering attempts. The system blocks unauthorized access at the OS level while providing immediate notifications of boundary violations.

## Notable Limitations

- Some tools (watchman, docker) require workarounds or exclusions
- "The network filtering system operates by restricting domains" without inspecting actual traffic
- Domain fronting and unix socket access present potential bypass risks
- Overly permissive filesystem rules can enable privilege escalation
- The weaker nested sandbox mode for Docker environments considerably reduces protection strength

## Availability

The sandbox runtime is available as an open-source npm package for broader agent development projects.
