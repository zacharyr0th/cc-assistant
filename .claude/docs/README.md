# Documentation

Complete guide for Claude Starter Kit.

## Quick Links

- [Quick Start](quickstart.md) - Get started in 5 minutes
- [Quick Reference](quick-reference.md) - Command tables and cheatsheets
- [Customization](customization.md) - Extend and configure

## What is Claude Starter Kit?

A production-ready configuration for Claude Code featuring:

- Core agents for security, database, and API development
- 40+ optional skills for frameworks and libraries
- Quality automation hooks
- Slash commands for common workflows

## Getting Started

1. Copy `.claude/` to your project
2. Start Claude Code
3. Core components work out of the box
4. Enable optional features from `examples/` as needed

## Structure

```
.claude/
├── core/              # Essential components (always enabled)
│   ├── agents/        # Security, database, API agents
│   └── commands/      # Build-safe, sync-types, db-migrate
├── examples/          # Optional components
│   ├── agents/        # Specialized agents
│   ├── commands/      # Additional commands
│   ├── skills/        # Framework-specific skills
│   └── hooks/         # Quality automation
├── docs/              # Documentation
└── settings.json      # Configuration
```

## Common Tasks

**Enable a skill**
```bash
cp -r examples/skills/next core/skills/
```

**Enable a hook**
Edit `settings.json` to reference the hook from examples.

**Add custom agent**
Create `.claude/core/agents/my-agent.md` with YAML frontmatter.

**View all available components**
```bash
ls examples/agents
ls examples/skills
ls examples/hooks
```

## Development

- [Contributing](development/CONTRIBUTING.md) - Contribution guidelines
- [Plugin Development](development/PLUGIN_DEVELOPMENT.md) - Extend the plugin
- [Changelog](development/CHANGELOG.md) - Version history

## Support

- Issues: [GitHub Issues](https://github.com/raintree-technology/claude-starter/issues)
- Claude Code Docs: [Official Documentation](https://docs.claude.com/en/docs/claude-code/)
