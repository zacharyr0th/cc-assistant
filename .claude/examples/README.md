# Examples

Optional components you can enable by copying to the appropriate location.

## Structure

```
examples/
├── agents/          # Specialized agents for specific domains
├── commands/        # Additional slash commands
├── skills/          # Framework and library-specific skills
└── hooks/           # Quality automation hooks
```

## Enabling Components

### Agents

Copy to `.claude/core/agents/`:

```bash
cp examples/agents/type-generator.md core/agents/
```

### Commands

Copy to `.claude/core/commands/`:

```bash
cp examples/commands/clear-cache.md core/commands/
```

### Skills

Copy to `.claude/core/skills/` (create if needed):

```bash
mkdir -p core/skills
cp -r examples/skills/next core/skills/
```

### Hooks

Update `.claude/settings.json` to reference hooks from examples:

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

## Available Components

### Agents (4)
- `type-generator.md` - TypeScript type management
- `use-effect-less.md` - React optimization
- `plaid-expert.md` - Plaid API integration
- `writer.md` - Content writing specialist

### Commands (2)
- `clear-cache.md` - Cache clearing utility
- `use-effect-less.md` - React refactoring command

### Skills (41)
Organized by technology stack:
- mcp-optimization/ - MCP code execution optimization (95%+ token reduction)
- next/ - Next.js patterns (9 skills)
- react/ - React patterns (2 skills)
- stripe/ - Payment processing (6 skills)
- supabase/ - Backend-as-a-service (1 skill)
- d3/ - Data visualization (5 skills)
- bun/ - JavaScript runtime (5 skills)
- aptos/ - Blockchain development (5 skills)
- And more...

### Hooks (9)
Quality automation:
- `check_after_edit.ts` - TypeScript/lint validation
- `security_scan.ts` - Security vulnerability scanning
- `code_quality.ts` - Code quality metrics
- `architecture_check.ts` - Architecture compliance
- `react_quality.ts` - React best practices
- `accessibility.ts` - WCAG compliance
- `import_organization.ts` - Import cleanup
- `bundle_size_check.ts` - Bundle size monitoring
- `advanced_analysis.ts` - Deep code analysis

## Best Practices

Start minimal and add components as needed. Don't enable everything at once.

For framework-specific projects:
- Next.js: Enable next/ and react/ skills
- Stripe integration: Enable stripe/ skills
- Database-heavy: Enable database-architect agent

See `docs/customization.md` for detailed guidance.
