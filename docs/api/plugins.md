# Claude Code Plugins: Complete Documentation

## Overview

Plugins extend Claude Code with custom functionality shareable across projects and teams. Users can install pre-built plugins from marketplaces or create custom ones to automate workflows.

## Plugin Creation

### Basic Structure

A plugin requires:
- **Plugin manifest** (`.claude-plugin/plugin.json`) containing metadata like name, description, version, and author
- **Commands directory** with markdown files defining slash commands
- Optional: agents, skills, hooks, and MCP server configurations

### Creating Your First Plugin

The quickstart involves establishing a marketplace folder, creating a plugin directory, adding a manifest file, defining a command in `commands/hello.md`, and creating a marketplace manifest at the parent level. After installation via `/plugin install my-first-plugin@test-marketplace`, users test functionality with `/hello`.

### Complex Plugin Development

Advanced plugins can include:
- **Skills**: Placed in `skills/` directories with `SKILL.md` files for autonomous Claude execution
- **Agents**: Custom agent definitions in `agents/`
- **Hooks**: Event handlers via `hooks/hooks.json`
- **MCP servers**: External tool integration through `.mcp.json`

## Plugin Installation & Management

### Discovery and Installation

Users access plugins through:
- Interactive menu: `/plugin` → "Browse Plugins" for discovery
- Direct commands: `/plugin install formatter@your-org`
- Management options: enable, disable, or uninstall plugins as needed

### Marketplace Configuration

"Add marketplaces as catalogs of available plugins using `/plugin marketplace add`" to expand discovery options. Teams can configure repositories with `.claude/settings.json` for automatic installation.

## Team Workflows

Repository-level configuration ensures consistent tooling when team members trust the folder. Plugins install automatically based on specified marketplace and plugin settings, standardizing team development environments.

## Development & Testing

Local marketplaces enable iterative testing. Developers create a `dev-marketplace` directory, configure marketplace.json, and cycle through install-test-uninstall-reinstall workflows. Debugging involves verifying directory structures, testing components individually, and consulting validation tools.

## Distribution

Ready plugins require documentation (README.md), semantic versioning in plugin.json, marketplace selection, and community testing before wider rollout.
