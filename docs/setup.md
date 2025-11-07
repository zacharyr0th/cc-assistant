# Claude Code Setup Documentation Summary

## System Requirements
Claude Code needs macOS 10.15+, Ubuntu 20.04+/Debian 10+, or Windows 10+ with WSL or Git Bash. The tool requires 4GB+ RAM, Node.js 18+ (for NPM only), internet connectivity, and Bash/Zsh/Fish shells. Users must be in an "Anthropic supported country."

## Installation Methods

**Native Installation (Recommended):**
The primary approach uses platform-specific installers via Homebrew, bash, or PowerShell scripts. This method provides "one self-contained executable" without Node.js dependencies and improved auto-update reliability.

**NPM Installation:**
Alternatively, users with Node.js can run `npm install -g @anthropic-ai/claude-code`. The documentation warns against using `sudo` with npm, citing permission and security concerns.

## Authentication Options

Three pathways exist:
1. Claude Console with OAuth (requires active billing)
2. Claude App (Pro/Max subscription)
3. Enterprise platforms (Amazon Bedrock or Google Vertex AI)

## Windows-Specific Setup

The tool runs within WSL (versions 1 or 2) or native Windows using Git Bash. For portable Git installations, users must specify the bash executable path via environment variable.

## Updates

Claude Code automatically checks for updates at startup and periodically during use. Updates download and install silently, taking effect on next restart. Users can disable this with the `DISABLE_AUTOUPDATER` environment variable or manually update via `claude update`.

## Getting Started

After installation, navigate to your project directory and launch with `claude`. Run `claude doctor` to verify installation status and version information.
