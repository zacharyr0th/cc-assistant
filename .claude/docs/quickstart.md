# Quick Start Guide

Get up and running with Claude Starter Kit in 5 minutes.

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
- Auto-detect your framework and dependencies
- Copy relevant skills automatically
- Generate .env.example with your integrations
- Provide configuration recommendations

### Quick Preset Setup

```bash
# Next.js full stack
./setup.sh --preset nextjs-full

# E-commerce with Stripe
./setup.sh --preset stripe-commerce

# Production SaaS
./setup.sh --preset fullstack-saas
```

See [Preset System](../presets/README.md) for all available presets.

### Manual Setup

```bash
# Copy .claude/ directory to your project
cp -r /path/to/claude-starter/.claude /path/to/your/project/
cd /path/to/your/project
```

## Verify Setup

Start Claude Code:

```bash
claude
```

The core agents and commands are now available.

## Try Core Commands

**Run a safe build**
```bash
/build-safe
```

**Sync database types**
```bash
/sync-types
```

**Run migrations**
```bash
/db-migrate
```

## Core Agents

These agents work automatically:

- **security-auditor** - Scans for vulnerabilities when you work with auth, encryption, or PII
- **database-architect** - Helps with schema design and migrations
- **api-builder** - Assists when creating API endpoints

Begin development and they will activate when relevant.

## Adding Optional Features

### Using Setup Script (Recommended)

**Add specific skills:**
```bash
./setup.sh --stack next,stripe,supabase
```

**Enable hooks:**
```bash
/enable-hook quality-focused
/enable-hook security-focused
```

### Manual Method

**Enable a skill:**
```bash
cp -r .claude/examples/skills/next .claude/core/skills/
cp -r .claude/examples/skills/stripe .claude/core/skills/
```

**Enable hooks** - Edit `.claude/settings.json`:
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/examples/hooks/security_scan.ts"
          }
        ]
      }
    ]
  }
}
```

**Enable an agent:**
```bash
cp .claude/examples/agents/type-generator.md .claude/core/agents/
```

## Next Steps

- Browse `examples/` to see all available components
- Read `customization.md` for advanced configuration
- Check `reference/` for detailed documentation

## Tips

Start minimal. Don't enable everything at once.

Enable features as you need them:
- Working with React? Enable react/ skills
- Using Stripe? Enable stripe/ skills
- Need type safety? Enable type-generator agent

## Troubleshooting

**Commands not found**
- Verify `.claude/` is in project root
- Restart Claude Code

**Agents not activating**
- Check YAML frontmatter is valid
- Restart Claude Code

**Skills not working**
- Verify skill files are in correct location
- Check skill description includes usage triggers

## Getting Help

- [Full Documentation](README.md)
- [GitHub Issues](https://github.com/raintree-technology/claude-starter/issues)
- [Claude Code Docs](https://code.claude.com/docs)
