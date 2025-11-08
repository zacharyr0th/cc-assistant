# Customization Guide

Extend and configure Claude Starter Kit for your needs.

## Philosophy

The starter kit follows a minimal core + optional examples approach:

- **core/** - Essential components enabled by default
- **examples/** - Optional features you enable as needed
- **presets/** - Predefined configurations for common stacks
- **setup.sh** - Automated configuration tool

## Quick Setup

### Using Automated Setup (Recommended)

The fastest way to get started:

```bash
# Interactive mode with guided questions
./setup.sh --interactive

# Use a preset configuration
./setup.sh --preset nextjs-full
./setup.sh --preset fullstack-saas

# Select specific technologies
./setup.sh --stack next,stripe,supabase

# Auto-detect from your package.json
./setup.sh
```

See [Preset System](#preset-system) below for details on available presets.

## Adding Components

### Using Setup Script

**For skills:**
```bash
./setup.sh --stack next,stripe,d3
```

**For hooks:**
```bash
/enable-hook quality-focused
/enable-hook security-focused
```

### Manual Method

Copy from examples directory:

```bash
# Enable an agent
cp examples/agents/type-generator.md core/agents/

# Enable a skill category
cp -r examples/skills/next core/skills/

# Enable multiple skills
cp -r examples/skills/stripe core/skills/
cp -r examples/skills/react core/skills/
```

### Custom Agents

Create `.claude/core/agents/my-agent.md`:

```yaml
---
name: my-agent
description: Use when [trigger]. Handles [capabilities].
tools: Read, Write, Edit, Bash, Grep
model: sonnet
---

## Purpose

What this agent does and when to use it.

## Capabilities

- Capability 1
- Capability 2

## Patterns

Best practices and patterns this agent follows.
```

### Custom Skills

Create `.claude/core/skills/my-skill/skill.md`:

```yaml
---
name: my-skill
description: Auto-invoked when [trigger]. Used for [use cases].
---

## When to Use

Describe when this skill should activate.

## Instructions

Detailed instructions for Claude to follow.

## Examples

Show usage examples.
```

Add resources in `my-skill/resources/` if needed.

### Custom Commands

Create `.claude/core/commands/my-command.md`:

```markdown
---
description: What this command does
---

# Implementation

Instructions for Claude to execute this command.

Can include:
- Running bash commands
- Reading/writing files
- Calling agents
- Executing workflows
```

## Configuring Hooks

Hooks run automatically after tool use (Edit/Write).

### Enable Example Hooks

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
            "command": "$CLAUDE_PROJECT_DIR/.claude/examples/hooks/check_after_edit.ts"
          },
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

### Custom Hook Configuration

Edit `examples/hooks/config.ts` to adjust thresholds:

```typescript
export const config = {
  quality: {
    maxFileLines: 500,
    maxFunctionLines: 50,
    maxCyclomaticComplexity: 15,
  },
  security: {
    failOnCritical: true,
    failOnHigh: false,
  },
  accessibility: {
    checkWCAG: true,
    level: "AA",
  },
};
```

## Settings

### Model Selection

Set default model in `settings.json`:

```json
{
  "defaultModel": "sonnet",
  "agents": {
    "security-auditor": {
      "model": "opus"
    }
  }
}
```

### Tool Permissions

Manage allowed operations in `settings.local.json`:

```json
{
  "permissions": {
    "allow": [
      "Bash(bun run:*)",
      "Bash(git:*)",
      "WebFetch(domain:stripe.com)"
    ]
  }
}
```

## Project-Specific Configuration

For project-specific setup, create `.claude/CLAUDE.md`:

```markdown
# Project Memory

## Architecture

Describe your project's architecture patterns.

## Development Workflow

Common commands and workflows for this project.

## Quality Standards

Project-specific quality requirements.
```

This file persists context across Claude Code sessions.

## Preset System

The starter kit includes 6 predefined configurations:

### Available Presets

**minimal** - Core components only
- 3 core agents
- 9 core commands
- No additional skills

**nextjs-full** - Complete Next.js development
- All Next.js skills (8)
- React skills (2)
- Recommended: quality-focused hooks

**stripe-commerce** - E-commerce platform
- Next.js + React + Stripe skills
- Recommended: security-focused hooks
- Environment variables: STRIPE_*

**fullstack-saas** - Production SaaS
- Next.js + React + Stripe + Supabase + DevOps
- Recommended: all hooks
- Environment variables: STRIPE_*, SUPABASE_*

**react-focused** - React development
- React skills
- use-effect-less agent
- Recommended: react-focused hooks

**devops-complete** - CI/CD automation
- GitHub Actions + git hooks + Vercel skills
- Recommended: security-focused hooks

### Creating Custom Presets

Create `.claude/presets/my-preset.json`:

```json
{
  "name": "my-preset",
  "description": "Custom configuration for my stack",
  "skills": ["next", "stripe", "d3"],
  "agents": [],
  "commands": [],
  "hooks": ["security_scan", "code_quality"],
  "env": {
    "FRAMEWORK": "nextjs",
    "ENABLE_STRIPE": "true",
    "ENABLE_D3": "true"
  },
  "recommended": {
    "hooks": "security-focused",
    "envVars": ["STRIPE_SECRET_KEY", "D3_API_KEY"]
  }
}
```

Apply with:
```bash
./setup.sh --preset my-preset
```

## Environment Configuration

### Using .env.example

The setup script generates `.env.example` with placeholders for all integrations:

```bash
# After setup
cp .env.example .env
# Edit .env with your actual values
```

### Required Variables by Integration

**Stripe:**
- STRIPE_SECRET_KEY
- STRIPE_PUBLISHABLE_KEY
- STRIPE_WEBHOOK_SECRET

**Supabase:**
- SUPABASE_URL
- SUPABASE_ANON_KEY
- SUPABASE_SERVICE_ROLE_KEY

**Vercel:**
- VERCEL_TOKEN
- VERCEL_ORG_ID
- VERCEL_PROJECT_ID

The `/self-test` command validates environment configuration.

## Best Practices

### Start Minimal

Don't enable everything. Start with core only, add as needed.

### Enable by Framework

For Next.js:
```bash
cp -r examples/skills/next core/skills/
cp -r examples/skills/react core/skills/
```

For Django:
```bash
# Claude Starter Kit is framework-agnostic
# Use core agents, skip framework-specific skills
```

### Selective Hooks

Hooks add overhead. Enable only what you need:

- **Always useful**: security_scan, check_after_edit
- **Team projects**: code_quality, architecture_check
- **Accessibility focused**: accessibility
- **React projects**: react_quality

### Version Control

Add to `.gitignore`:
```
.claude/settings.local.json
.claude/**/.cache/
.claude/**/*.log
```

Commit:
```
.claude/core/
.claude/examples/
.claude/docs/
.claude/settings.json
```

## Migration from Old Structure

If you have the old flat structure:

```bash
# Backup first
cp -r .claude .claude.backup

# Old agents/ -> core/agents/ (for core) or examples/agents/
# Old commands/ -> core/commands/ or examples/commands/
# Old skills/ -> examples/skills/
# Old hooks/ -> examples/hooks/
```

See examples/README.md for which components are core vs optional.

## Advanced: Plugin Development

To distribute your configuration as a plugin:

1. Create `.claude-plugin/manifest.json`
2. Define plugin metadata
3. Use marketplace for distribution

See reference/plugin-development.md for details.

## Troubleshooting

**Changes not taking effect**
- Restart Claude Code after configuration changes
- Clear cache: `/clear-cache` or `rm -rf .claude/.cache`

**Conflicts between components**
- Check agent names are unique
- Verify skill descriptions don't overlap
- Review hook ordering

**Performance issues**
- Reduce number of enabled hooks
- Use lighter model (haiku) for simple agents
- Disable unused skills

## Getting Help

- [Full Documentation](README.md)
- [GitHub Issues](https://github.com/raintree-technology/claude-starter/issues)
- [Claude Code Docs](https://code.claude.com/docs)
