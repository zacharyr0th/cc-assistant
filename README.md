# Claude Starter Kit

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Production-ready Claude Code configuration for any project. Framework-agnostic, extensible, and following best practices.

## Overview

A complete Claude Code setup with core components enabled by default and 50+ optional features you can enable as needed.

**Core Features (Enabled)**
- 3 essential agents: Security auditor, database architect, API builder
- 3 core commands: Build-safe, sync-types, db-migrate
- Minimal configuration

**Optional Features (Examples)**
- 4 specialized agents
- 40+ framework-specific skills
- 9 quality automation hooks
- Additional commands

## Installation

```bash
# Copy to your project
cp -r .claude /path/to/your/project/

# Start Claude Code
cd /path/to/your/project
claude
```

Core components work immediately. Enable optional features as needed.

## Quick Start

**Use core commands**
```bash
/build-safe    # Validate and build
/sync-types    # Sync database types
/db-migrate    # Run migrations
```

**Core agents activate automatically**
- Security auditor scans when you work with auth or sensitive data
- Database architect helps with schema design
- API builder assists with endpoint creation

**Enable optional features**
```bash
# Add Next.js skills
cp -r .claude/examples/skills/next .claude/core/skills/

# Add type generator agent
cp .claude/examples/agents/type-generator.md .claude/core/agents/

# Enable security hook
# Edit .claude/settings.json (see docs)
```

## Structure

```
.claude/
├── core/              # Essential components (enabled)
│   ├── agents/        # Security, database, API
│   └── commands/      # Build-safe, sync-types, db-migrate
├── examples/          # Optional features
│   ├── agents/        # Type generator, React optimizer, etc.
│   ├── skills/        # Next.js, Stripe, React, D3, Bun, etc.
│   ├── hooks/         # Quality automation
│   └── commands/      # Additional utilities
├── docs/              # Documentation
│   ├── quickstart.md
│   ├── customization.md
│   └── reference/     # Detailed docs
└── settings.json      # Configuration
```

## Core Components

**Agents**
- `security-auditor` - Vulnerability scanning, PII detection
- `database-architect` - Schema design, query optimization
- `api-builder` - Structured endpoints with error handling

**Commands**
- `/build-safe` - Full validation pipeline
- `/sync-types` - Type synchronization
- `/db-migrate` - Database migrations

## Optional Features

**Agents** (examples/agents/)
- Type generator - TypeScript type management
- React optimizer - Remove unnecessary useEffect
- Plaid expert - Banking integration
- Content writer - Documentation

**Skills** (examples/skills/)
- Next.js (8 skills) - App Router, caching, streaming, SSR
- React (2 skills) - Server components, form actions
- Stripe (11 skills) - Payments, subscriptions, webhooks
- Supabase (2 skills) - Auth, RLS, storage
- D3 (5 skills) - Visualizations, geo, layouts
- Bun (5 skills) - Runtime, bundler, testing
- Aptos (5 skills) - Blockchain development

**Hooks** (examples/hooks/)
- TypeScript/lint validation
- Security scanning
- Code quality metrics
- Architecture compliance
- React best practices
- Accessibility checking
- Import organization
- Bundle size monitoring

**Commands** (examples/commands/)
- Clear cache
- React refactoring

See [examples/README.md](.claude/examples/README.md) for complete list and enablement instructions.

## Customization

**Enable a skill**
```bash
mkdir -p .claude/core/skills
cp -r .claude/examples/skills/stripe .claude/core/skills/
```

**Enable a hook**
Edit `.claude/settings.json`:
```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Edit|Write",
      "hooks": [{
        "type": "command",
        "command": "$CLAUDE_PROJECT_DIR/.claude/examples/hooks/security_scan.ts"
      }]
    }]
  }
}
```

**Create custom agent**
Create `.claude/core/agents/my-agent.md` with YAML frontmatter.

See [docs/customization.md](.claude/docs/customization.md) for complete guide.

## Use Cases

- **Multi-framework projects** - Core works with any stack
- **Next.js apps** - Enable next/ and react/ skills
- **API development** - Core API builder + optional skills
- **Database-heavy** - Core database architect + migrations
- **Security-critical** - Core security auditor + security hook
- **Team projects** - Enable quality hooks for consistency

## Best Practices

**Start minimal**
Use core only initially. Add features as needed.

**Enable by domain**
Working with payments? Enable stripe/ skills.
Working with auth? Enable security hooks.

**Framework-specific**
- Next.js: Enable next/, react/ skills
- Django/Rails: Use core only (framework-agnostic)
- Microservices: Enable API builder, security auditor

**Team settings**
- Commit: .claude/core/, .claude/examples/, .claude/settings.json
- Gitignore: .claude/settings.local.json, .claude/**/.cache/

## Documentation

- [Quick Start](.claude/docs/quickstart.md) - Get started in 5 minutes
- [Customization](.claude/docs/customization.md) - Extend and configure
- [Examples](.claude/examples/README.md) - All optional features
- [Contributing](.claude/docs/development/CONTRIBUTING.md) - Contribution guidelines
- [Plugin Development](.claude/docs/development/PLUGIN_DEVELOPMENT.md) - Extend the plugin
- [Changelog](.claude/docs/development/CHANGELOG.md) - Version history

## Requirements

- Claude Code >= 0.8.0
- Node.js >= 18 (for hooks)
- TypeScript >= 5.0 (recommended)

## Troubleshooting

**Commands not found**
- Verify .claude/ in project root
- Restart Claude Code

**Agents not activating**
- Check YAML frontmatter
- Verify description includes usage triggers
- Restart Claude Code

**Hooks not running**
- Check settings.json configuration
- Verify hook paths are correct
- Check hooks are executable

See [docs/customization.md](.claude/docs/customization.md) for more troubleshooting.

## Contributing

Contributions welcome. Guidelines:

1. Keep core minimal
2. Add new features to examples/
3. Include documentation
4. Follow existing patterns
5. Test thoroughly

## License

MIT - See [LICENSE](LICENSE)

## Support

- [Documentation](.claude/docs/)
- [GitHub Issues](https://github.com/raintree-technology/claude-starter/issues)
- [Claude Code Docs](https://code.claude.com/docs)

---

Minimal core, maximum flexibility. Enable what you need, when you need it.
