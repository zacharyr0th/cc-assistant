# Claude Code Troubleshooting Guide

## Installation Issues

### Windows/WSL Problems
WSL environments may encounter OS detection failures. Solutions include running `npm config set os linux` before installation or using `npm install -g @anthropic-ai/claude-code --force --no-os-check` without sudo.

Node.js path conflicts occur when WSL uses Windows installations instead of Linux versions. Verify paths with `which npm` and `which node`—they should reference `/usr/` locations, not `/mnt/c/`. Install Node through your Linux package manager or `nvm` to resolve this.

When nvm exists in both WSL and Windows, version switching can fail because WSL imports Windows PATH by default. The primary fix involves loading nvm in shell configuration files. Add this to `~/.bashrc` or `~/.zshrc`:

```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
```

### Linux/Mac Installation
Permission errors typically stem from npm's global prefix being non-writable. The recommended approach uses native installation:

**macOS/Linux/WSL:**
```bash
curl -fsSL https://claude.ai/install.sh | bash
```

**Windows PowerShell:**
```powershell
irm https://claude.ai/install.ps1 | iex
```

Alternatively, migrate existing installations locally using `claude migrate-installer`, which moves Claude Code to `~/.claude/local/` without requiring sudo.

## Authentication & Permissions

Repeated approval prompts can be managed through the `/permissions` command. For authentication failures, use `/logout`, restart Claude Code, then attempt login again. If problems persist, remove cached credentials with `rm -rf ~/.config/claude-code/auth.json`.

## Performance & Stability

High resource consumption with large codebases improves through:
- Using `/compact` regularly
- Restarting between major tasks
- Adding build directories to `.gitignore`

Search functionality (Search tool, `@file` mentions, custom agents) requires system `ripgrep` installation across platforms (Homebrew for macOS, winget for Windows, apt for Ubuntu, etc.). Set `USE_BUILTIN_RIPGREP=0` afterward.

WSL disk performance penalties may reduce search matches. Solutions include specifying directories in searches, relocating projects to Linux filesystems (`/home/`), or running Claude Code natively on Windows.

## IDE Integration

### JetBrains on WSL2
"No available IDEs detected" errors relate to NAT networking. Find your WSL2 IP with `wsl hostname -I`, then create a Windows Firewall rule allowing that subnet. Alternatively, add `networkingMode=mirrored` to `.wslconfig` and restart WSL.

### JetBrains Terminal ESC Key
The ESC key fails to interrupt operations due to keybinding conflicts. Navigate to Settings → Tools → Terminal and uncheck "Move focus to the editor with Escape."

## Markdown Issues

Generated markdown sometimes lacks language tags on code fences. Request "Please add appropriate language tags to all code blocks" for correction. Set up post-processing hooks using tools like `prettier` for automated formatting validation.

## Diagnostic Help

Run `/doctor` to assess installation health. Use `/bug` for direct issue reporting to Anthropic, or check the GitHub repository for documented problems.
