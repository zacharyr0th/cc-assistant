# Claude Starter Kit

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Production-ready Claude Code configuration for any project. Framework-agnostic, extensible, and following best practices.

## Overview

A complete Claude Code setup with core components enabled by default and 50+ optional features you can enable as needed.

**Core Features (Enabled)**
- 3 essential agents: Security auditor, database architect, API builder
- 9 core commands: Build, types, migrations, git workflows, validation
- Minimal configuration

**Optional Features (Examples)**
- 6 specialized agents
- 39 skills across 12 categories
- 10 quality automation hooks
- 7 additional commands

## Installation

### Automated Setup (Recommended)

```bash
# Clone the starter kit
git clone https://github.com/raintree-technology/claude-starter
cd claude-starter

# Run setup in your project directory
cd /path/to/your/project
/path/to/claude-starter/setup.sh --interactive
```

The setup script will:
- Detect your framework and dependencies
- Copy relevant skills automatically
- Generate environment template
- Provide next steps

### Quick Setup with Presets

```bash
# Next.js full stack
./setup.sh --preset nextjs-full

# E-commerce with Stripe
./setup.sh --preset stripe-commerce

# Production SaaS (Next.js + Stripe + Supabase + DevOps)
./setup.sh --preset fullstack-saas

# See all presets
./setup.sh --help
```

### Manual Setup

```bash
# Copy .claude/ directory to your project
cp -r /path/to/claude-starter/.claude /path/to/your/project/

# Manually enable skills as needed
cp -r .claude/examples/skills/next .claude/core/skills/
```

## Quick Start

**Auto-detected setup**
```bash
# If you have package.json with Next.js, Stripe, etc.
./setup.sh  # Detects and asks to auto-configure
```

**Use core commands**
```bash
/build-safe    # Validate and build
/sync-types    # Sync database types
/db-migrate    # Run migrations
/self-test     # Validate entire setup
```

**Core agents activate automatically**
- Security auditor scans when you work with auth or sensitive data
- Database architect helps with schema design
- API builder assists with endpoint creation

**Enable optional features**
```bash
# Using setup script (recommended)
./setup.sh --stack next,stripe,supabase

# Or enable specific presets
/enable-hook quality-focused

# Manual method
cp -r .claude/examples/skills/next .claude/core/skills/
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
- `/build-safe` - Full validation pipeline (lint, type-check, test, build)
- `/sync-types` - Synchronize database types with schema
- `/db-migrate` - Run database migrations with validation
- `/health-check` - System health validation and diagnostics
- `/commit` - Smart commit messages with conventional commits
- `/create-pr` - Create PR with auto-generated description, labels, issue links
- `/release` - Automated releases with changelog generation, npm publishing
- `/enable-hook` - Enable quality automation hooks with presets
- `/self-test` - Comprehensive validation of entire Claude Code setup

## Git Workflows

**Automated Git Operations**
- `/create-pr` - Generate PR with description from commits, auto-label, link issues
- `/release` - Semantic versioning, changelog, GitHub releases, npm publishing
- `/commit` - Analyze changes and create conventional commit messages

**CI/CD Workflows** (.github/workflows/)
- `ci.yml` - Test, lint, type-check on push/PR
- `deploy.yml` - Automatic Vercel deployment with preview URLs
- `release.yml` - Automated releases on tag push

**Skills for Automation** (examples/skills/)
- `github-actions-architect` - Generate CI/CD workflows
- `git-hooks-architect` - Set up Husky, lint-staged, commitlint
- `vercel-deploy-architect` - Configure Vercel deployments

See [.claude/docs/workflows.md](.claude/docs/workflows.md) for complete workflow guide.

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
- Shelby (4 skills) - Decentralized storage, media streaming

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

### Using Setup Script (Easiest)

```bash
# Interactive mode - guided Q&A
./setup.sh --interactive

# Preset configurations
./setup.sh --preset fullstack-saas

# Stack-based selection
./setup.sh --stack next,stripe,supabase

# View all options
./setup.sh --help
```

### Available Presets

- **minimal** - Core only (default)
- **nextjs-full** - Complete Next.js setup
- **stripe-commerce** - E-commerce with Stripe
- **fullstack-saas** - Next.js + Stripe + Supabase + DevOps
- **react-focused** - React development
- **devops-complete** - CI/CD automation

See [.claude/presets/README.md](.claude/presets/README.md) for details.

### Manual Configuration

**Enable a skill**
```bash
cp -r .claude/examples/skills/stripe .claude/core/skills/
```

**Enable hooks**
```bash
/enable-hook quality-focused
# or
/enable-hook security-focused
```

**Environment configuration**
```bash
cp .env.example .env
# Edit .env with your API keys and settings
```

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
