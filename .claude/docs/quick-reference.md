# Quick Reference Guide

Fast reference for Claude Starter Kit components.

## Slash Commands

| Command | Usage | Description |
|---------|-------|-------------|
| `/build-safe` | `/build-safe` | Full validation: typecheck → lint → build |
| `/health-check` | `/health-check` | Verify project configuration and dependencies |
| `/self-test` | `/self-test` | Comprehensive validation of Claude Code setup |
| `/enable-hook` | `/enable-hook <preset>` | Enable quality automation hooks (quality-focused, security-focused, all) |
| `/review-pr` | `/review-pr [number\|branch]` | Comprehensive PR review (security, types, perf, a11y) |
| `/db-migrate` | `/db-migrate` | Run database migrations |
| `/sync-types` | `/sync-types` | Sync TypeScript types from Supabase |
| `/clear-cache` | `/clear-cache` | Clear Next.js build cache |
| `/use-effect-less` | `/use-effect-less` | Refactor unnecessary useEffect hooks |
| `/new-agent` | `/new-agent <name>` | Create new specialized agent interactively |

## Agents

| Agent | Auto-invokes when... | Use for... |
|-------|---------------------|-----------|
| **api-builder** | "create API", "add endpoint" | Next.js API routes, REST endpoints |
| **database-architect** | "database", "migration", "schema" | Drizzle ORM, schema design |
| **security-auditor** | Code touches auth/encryption | Security scanning, PII detection |
| **type-generator** | "sync types", "type error" | TypeScript type management |
| **writer** | "write docs", "blog post" | Technical writing, documentation |
| **use-effect-less** | "refactor useEffect" | React 19 optimizations |
| **plaid-expert** | "plaid", "banking data" | Plaid integration, transactions |

## Skills by Category

### Next.js (8 skills)
- `next-app-router` - App Router patterns
- `next-api-architect` - API route creation
- `next-cache-architect` - Caching strategies (Cache Components)
- `next-config-optimization` - Config tuning
- `next-data-rendering` - SSR/SSG/ISR patterns
- `next-pages-router` - Pages Router (legacy)
- `nextjs-16-audit` - Next.js 16 migration
- `streaming-architect` - Streaming responses

### React (2 skills)
- `react-server-components` - RSC patterns
- `form-actions-architect` - Form handling with Server Actions

### Stripe (11 skills)
- `stripe-api-integration` - Core API patterns
- `stripe-billing-subscriptions` - Recurring billing
- `stripe-payments` - One-time payments
- `stripe-connect` - Marketplace platforms
- `stripe-terminal-issuing` - Physical terminals, card issuing
- _+ 6 more_

### Database & Backend
- `supabase-expert` - Auth, RLS, storage, real-time
- `plaid-expert` - Banking data sync (agent + skill)

### UI & Visualization
- `d3-core-data` - Data binding, scales, axes
- `d3-geo` - Maps and geographic projections
- `d3-interaction-animation` - Transitions, events
- `d3-layouts-hierarchies` - Trees, force graphs
- `d3-shapes-paths` - SVG generation

### Tooling
- `bun-runtime` - Bun runtime features
- `bun-bundler` - Bundling with Bun
- `bun-package-manager` - Package management
- `bun-test` - Testing with Bun
- `skill-builder` - Create new skills

### Blockchain (5 skills)
- Aptos dApp development, Move language, indexing

## Hooks

| Hook | Checks | Severity | Blocks on... |
|------|--------|----------|-------------|
| **check_after_edit** | TypeScript, lint, format | Error | Type errors, lint errors |
| **security_scan** | Secrets, XSS, injection | Critical/High | Hardcoded keys, unsafe patterns |
| **code_quality** | Complexity, function length | Warning | Configurable thresholds |
| **architecture_check** | Layers, naming, imports | Error | Layer violations, type duplication |
| **react_quality** | Props, hooks, performance | Error | Missing keys, bad deps |
| **accessibility** | WCAG compliance | Error | Missing alt, aria-labels |
| **import_organization** | Unused imports | Warning | Unused/unorganized (optional) |
| **bundle_size_check** | File size | Warning | Size thresholds |
| **advanced_analysis** | Leaks, race conditions | Warning | Memory leaks, caching issues |

## Common Workflows

### Initial Setup
```bash
# Auto-detect and configure
./setup.sh --interactive

# Or use a preset
./setup.sh --preset nextjs-full
./setup.sh --preset fullstack-saas

# Enable hooks after setup
/enable-hook quality-focused

# Verify everything works
/self-test
```

### Starting a New Feature
```bash
# 1. Check project health
/health-check

# 2. Create feature branch
git checkout -b feature/my-feature

# 3. Start coding (agents/skills auto-invoke)

# 4. Before committing
/build-safe

# 5. Create PR
/review-pr feature/my-feature
```

### Fixing Type Errors
```bash
# 1. Sync types from database
/sync-types

# 2. Let type-generator agent fix duplicates
"Fix TypeScript type errors in lib/api"

# 3. Verify
/build-safe
```

### Security Review
```bash
# Security-auditor agent auto-invokes when:
# - Code touches authentication
# - Working with encryption
# - Handling PII/sensitive data

# Manual invocation:
"Review this code for security issues"
```

### API Development
```bash
# api-builder agent auto-invokes for:
"Create API route for user preferences"
"Add rate limiting to /api/auth"
"Implement pagination for /api/posts"

# Uses patterns from .claude/agents/api-builder.md
```

### Database Changes
```bash
# 1. Modify schema in lib/db/schema.ts

# 2. Generate migration
/db-migrate

# 3. Sync types
/sync-types

# 4. Verify
/build-safe
```

## Configuration

### Hook Configuration
Edit `.claude/hooks/config.ts`:

```typescript
export const config = {
  quality: {
    enabled: true,
    maxFileLines: 500,
    maxFunctionLines: 50,
    maxCyclomaticComplexity: 15,
  },
  security: {
    enabled: true,
    failOnCritical: true,
    failOnHigh: true,
  },
  react: {
    enabled: true,
    enforcePropTypes: true,
  },
  // ... more options
};
```

### Enable/Disable Hooks
Edit `.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          { "type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/check_after_edit.ts" },
          // Comment out hooks you don't want
          // { "type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/security_scan.ts" }
        ]
      }
    ]
  }
}
```

## Troubleshooting

### Agent not auto-invoking
1. Check description has trigger keywords
2. Verify agent file in `.claude/agents/`
3. Try explicit: "Use the [agent-name] agent to..."
4. Restart Claude Code

### Skill not activating
1. Check YAML frontmatter is valid
2. Verify description has "when to use" section
3. Use `/skills` to see if loaded
4. Restart Claude Code

### Hook not running
1. Check `.claude/settings.json` registration
2. Verify hook file is executable: `chmod +x .claude/hooks/*.ts`
3. Check config: `.claude/hooks/config.ts`
4. Look for errors in Claude Code console

### Command not found
1. Verify file exists: `.claude/commands/cmd-name.md`
2. Check YAML frontmatter
3. Restart Claude Code
4. Use `/help` to see available commands

## Documentation Links

- [Main README](README.md) - Installation and overview
- [Plugin Development](PLUGIN_DEVELOPMENT.md) - Extending the plugin
- [Contributing](CONTRIBUTING.md) - How to contribute
- [Changelog](CHANGELOG.md) - Version history
- [Agents Docs](.claude/agents/docs/) - Detailed agent reference
- [Hooks Guide](.claude/hooks/README.md) - Hook configuration
- [Claude Code Docs](https://code.claude.com/docs) - Official documentation

## Tips

### Auto-Invocation
Trigger agents/skills by using keywords from their descriptions:
- "Create API endpoint" → api-builder agent
- "Add GraphQL resolver" → (future GraphQL agent)
- "Security audit this code" → security-auditor agent

### Explicit Invocation
Force a specific agent/skill:
```
Use the api-builder agent to create a REST endpoint for user settings
```

### Multiple Agents
Agents can delegate to each other:
```
Create a secure API endpoint for sensitive user data
→ api-builder (creates endpoint)
→ security-auditor (reviews security)
```

### Quality Standards
Default thresholds:
- File: 500 lines max
- Function: 50 lines max
- Complexity: 15 max
- Parameters: 4 max
- Nesting: 3 levels max

Adjust in `.claude/hooks/config.ts`.

---

**Recommended**: Use /health-check and /build-safe before every commit.
