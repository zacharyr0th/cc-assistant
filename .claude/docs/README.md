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

**Automated Setup (Recommended):**
```bash
./setup.sh --interactive
# or
./setup.sh --preset nextjs-full
```

**Manual Setup:**
1. Copy `.claude/` to your project
2. Start Claude Code
3. Core components work out of the box
4. Enable optional features from `examples/` as needed

See [Quick Start](quickstart.md) for detailed instructions.

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

**Enable skills (automated)**
```bash
./setup.sh --stack next,stripe,supabase
```

**Enable hooks**
```bash
/enable-hook quality-focused
```

**View all available components**
```bash
ls examples/agents
ls examples/skills
ls examples/hooks
```

**Manual skill enablement**
```bash
cp -r examples/skills/next core/skills/
```

See [Customization Guide](customization.md) for more options.

## Advanced Topics

- [TOON Format](toon/) - Token-efficient data format (40-61% savings)
- [Release Notes](releases/) - Version history and changelogs

## Development

- [Contributing](development/CONTRIBUTING.md) - Contribution guidelines
- [Plugin Development](development/PLUGIN_DEVELOPMENT.md) - Extend the plugin
- [Changelog](development/CHANGELOG.md) - Version history

## Support

- Issues: [GitHub Issues](https://github.com/raintree-technology/claude-starter/issues)
- Claude Code Docs: [Official Documentation](https://docs.claude.com/en/docs/claude-code/)
