# Claude Code JetBrains IDE Integration

## Overview
Claude Code integrates with JetBrains IDEs through a dedicated plugin, enabling developers to access Claude directly from their editor while maintaining full context awareness.

## Supported Platforms
The plugin is compatible with IntelliJ IDEA, PyCharm, Android Studio, WebStorm, PhpStorm, and GoLand.

## Key Features
The integration offers several productivity enhancements:

- **Quick access**: "Use `Cmd+Esc` (Mac) or `Ctrl+Esc` (Windows/Linux) to open Claude Code directly" from your editor
- **Diff integration**: Code modifications display in the IDE's native diff viewer
- **Automatic context sharing**: Your current selection and active tabs transfer automatically to Claude
- **File shortcuts**: Insert file references using keyboard combinations
- **Diagnostic integration**: Linting and syntax errors are automatically communicated to Claude

## Installation Methods
Users can install the plugin through the JetBrains marketplace or allow automatic installation when running Claude in the integrated terminal. The documentation emphasizes that "you must restart your IDE completely for it to take effect."

## Configuration Options
Settings are available in two locations:
1. Claude Code's own settings menu (accessible via `/config` command)
2. Plugin settings at Settings → Tools → Claude Code [Beta]

For WSL users, the documentation recommends specifying a custom command like `wsl -d Ubuntu -- bash -lic "claude"`.

## Important Warnings
Remote Development deployments require installing the plugin on the remote host, not the local machine. WSL users should consult dedicated troubleshooting resources for proper setup.
