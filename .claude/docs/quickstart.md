# Quick Start Guide

Get up and running with Claude Starter Kit in 5 minutes.

## Installation

Copy the `.claude/` directory to your project:

```bash
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

Just start coding and they'll activate when relevant.

## Adding Optional Features

### Enable a Skill

For Next.js projects:

```bash
mkdir -p .claude/core/skills
cp -r .claude/examples/skills/next .claude/core/skills/
```

For Stripe:

```bash
cp -r .claude/examples/skills/stripe .claude/core/skills/
```

### Enable a Hook

Edit `.claude/settings.json`:

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

### Enable an Agent

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
