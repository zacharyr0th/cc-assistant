# Claude Code Troubleshooting Documentation Summary

This comprehensive troubleshooting guide addresses common issues across installation, permissions, performance, IDE integration, and markdown formatting.

## Installation Issues

**Windows/WSL Problems:**
The guide notes that WSL may incorrectly use Windows npm, recommending users run `"npm config set os linux"` before installation. Node.js path conflicts can occur when WSL imports Windows PATH settings, causing `/mnt/c/` paths to take priority over Linux installations.

The documentation suggests ensuring nvm loads properly by adding initialization code to shell configuration files (`~/.bashrc`, `~/.zshrc`), or explicitly prepending Linux paths to the system PATH variable.

**Linux/Mac Solutions:**
For permission and PATH issues, the guide recommends the native Claude Code installer (currently in beta), which doesn't require npm or Node.js. Installation uses: `"curl -fsSL https://claude.ai/install.sh | bash"`

Alternatively, users can migrate existing installations locally using `"claude migrate-installer"`, moving Claude Code to `~/.claude/local/` without requiring sudo privileges.

## Authentication & Permissions

Users experiencing repeated permission prompts can configure specific tools via the `/permissions` command. For authentication failures, the documentation suggests signing out with `/logout`, restarting Claude Code, and if problems persist, removing stored credentials: `"rm -rf ~/.config/claude-code/auth.json"`

## Performance Optimization

High resource consumption when processing large codebases can be mitigated by regularly using `/compact` to reduce context, restarting between major tasks, and adding large directories to `.gitignore`.

Search functionality issues require installing system `ripgrep` and setting the `"USE_BUILTIN_RIPGREP=0"` environment variable. WSL users may experience slower search results due to filesystem performance differences.

## IDE Integration

JetBrains IDE detection issues on WSL2 stem from networking configuration. Solutions include configuring Windows Firewall rules for the WSL2 subnet or switching `.wslconfig` to `"networkingMode=mirrored"`.

For ESC key issues in JetBrains terminals, users should disable or reconfigure the `"Move focus to the editor with Escape"` setting in terminal preferences.

## Markdown Formatting

The guide addresses missing language tags in code blocks, recommending either direct requests to Claude for corrections or implementing automated post-processing hooks using tools like `prettier`.
