# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is the **claude-starter** repository - a template/starter kit for Claude Code configuration. It contains production-ready `.claude/` configuration that users copy into their projects. This is NOT an application to run, but a collection of reusable Claude Code components.

**Key features:**
- Automated setup script with framework detection
- 6 preset configurations for common stacks
- Environment template system
- Interactive configuration wizard
- Self-validation and health checking

## Architecture

### Two-Tier Structure: Core vs Examples

The architecture follows an **opt-in philosophy**:

- **`.claude/core/`** - Essential components enabled by default (minimal, always active)
- **`.claude/examples/`** - Optional components users copy as needed (~50+ features)
- **`setup.sh`** - Automated setup script (framework detection, presets, interactive mode)
- **`.claude/presets/`** - Predefined configurations for common stacks
- **`.env.example`** - Environment template with all integrations

Users have three setup paths:
1. **Automated** - Run `./setup.sh --interactive` for guided setup
2. **Preset** - Run `./setup.sh --preset <name>` for instant configuration
3. **Manual** - Copy `.claude/` and configure by hand

Core components work immediately. Optional features are enabled via setup script or manual copy from `examples/` to `core/`.

### Component Types

**Agents** (`.claude/{core,examples}/agents/*.md`):
- YAML frontmatter defines name, description, triggers
- Auto-invoked based on description keywords
- Markdown files with procedural instructions
- 3 core agents (always enabled) + 6 example agents (optional)

**Commands** (`.claude/{core,examples}/commands/*.md`):
- Markdown files invoked as `/command-name`
- Procedural instructions for Claude to execute
- Step-by-step bash commands with validation
- 9 core commands (always available) + 7 example commands (optional)

**Skills** (`.claude/examples/skills/*/skill.md`):
- Specialized knowledge domains with YAML frontmatter
- Auto-invoked when user mentions framework/library
- Organized by technology stack
- 39 skills across 12 categories (all placeholders removed)

**Hooks** (`.claude/examples/hooks/*.ts`):
- TypeScript files that run after tool use (PostToolUse event)
- Quality automation: linting, security, architecture checks
- Configured in `.claude/settings.json`
- 10 hooks + 2 utility files (cache, config)

## Complete Component Inventory

### Core Agents (Always Enabled)

| Agent | File Path | Purpose |
|-------|-----------|---------|
| security-auditor | `.claude/core/agents/security-auditor.md` | Vulnerability scanning, PII detection, security best practices |
| database-architect | `.claude/core/agents/database-architect.md` | Schema design, query optimization, migration assistance |
| api-builder | `.claude/core/agents/api-builder.md` | Structured endpoint creation with error handling |

### Example Agents (Optional)

| Agent | File Path | Purpose |
|-------|-----------|---------|
| type-generator | `.claude/examples/agents/type-generator.md` | TypeScript type generation and management |
| use-effect-less | `.claude/examples/agents/use-effect-less.md` | React optimization, remove unnecessary useEffect |
| plaid-expert | `.claude/examples/agents/plaid-expert.md` | Plaid API integration assistance |
| writer | `.claude/examples/agents/writer.md` | Content writing and documentation specialist |
| chief-of-staff | `.claude/examples/agents/chief-of-staff/` | Executive assistant with financial analyst, recruiter sub-agents |
| research-agent | `.claude/examples/agents/research-agent/` | Research lead and sub-agent coordination |

### Core Commands (Always Available)

| Command | File Path | Purpose |
|---------|-----------|---------|
| `/build-safe` | `.claude/core/commands/build-safe.md` | Full validation pipeline (lint, type-check, test, build) |
| `/sync-types` | `.claude/core/commands/sync-types.md` | Synchronize database types with schema |
| `/db-migrate` | `.claude/core/commands/db-migrate.md` | Run database migrations with validation |
| `/health-check` | `.claude/core/commands/health-check.md` | System health validation and diagnostics |
| `/commit` | `.claude/core/commands/commit.md` | Generate conventional commit messages from staged changes |
| `/create-pr` | `.claude/core/commands/create-pr.md` | Create PR with auto-generated description, labels, issue links |
| `/release` | `.claude/core/commands/release.md` | Semantic versioning, changelog, GitHub releases, npm publishing |
| `/enable-hook` | `.claude/core/commands/enable-hook.md` | Enable quality automation hooks with presets (quality/security/react-focused) |
| `/self-test` | `.claude/core/commands/self-test.md` | Comprehensive validation of entire Claude Code setup with auto-fix mode |

### Example Commands (Optional)

| Command | File Path | Purpose |
|---------|-----------|---------|
| `/clear-cache` | `.claude/examples/commands/clear-cache.md` | Clear build caches and temporary files |
| `/use-effect-less` | `.claude/examples/commands/use-effect-less.md` | Refactor React components to remove unnecessary useEffect |
| `/review-pr` | `.claude/examples/commands/review-pr.md` | Comprehensive PR review (security, quality, performance) |
| `/code-review` | `.claude/examples/commands/code-review.md` | File-based code review with quality checks |
| `/link-review` | `.claude/examples/commands/link-review.md` | Review and validate links in documentation |
| `/model-check` | `.claude/examples/commands/model-check.md` | Check which Claude model is being used |
| `/new-agent` | `.claude/examples/commands/new-agent.md` | Create new agent from template |

### Skills - Complete Inventory (39 Skills)

#### Next.js Skills (8 skills)

| Skill | File Path | Purpose |
|-------|-----------|---------|
| next-app-router | `.claude/examples/skills/next/next-app-router/skill.md` | Next.js App Router architecture and patterns |
| next-pages-router | `.claude/examples/skills/next/next-pages-router/skill.md` | Next.js Pages Router (legacy) patterns |
| next-api-architect | `.claude/examples/skills/next/next-api-architect/skill.md` | API route creation and best practices |
| next-cache-architect | `.claude/examples/skills/next/next-cache-architect/skill.md` | Caching strategies and revalidation |
| next-data-rendering | `.claude/examples/skills/next/next-data-rendering/skill.md` | SSR, SSG, ISR data fetching patterns |
| next-config-optimization | `.claude/examples/skills/next/next-config-optimization/skill.md` | next.config.js optimization |
| streaming-architect | `.claude/examples/skills/next/streaming-architect/skill.md` | Streaming and suspense patterns |
| nextjs-16-audit | `.claude/examples/skills/next/nextjs-16-audit/skill.md` | Next.js 16 + React 19 compliance audit |

#### React Skills (2 skills)

| Skill | File Path | Purpose |
|-------|-----------|---------|
| react-server-components | `.claude/examples/skills/react/react-server-components/skill.md` | React Server Components patterns |
| form-actions-architect | `.claude/examples/skills/react/form-actions-architect/skill.md` | React form actions and progressive enhancement |

#### Stripe Skills (5 skills)

| Skill | File Path | Purpose |
|-------|-----------|---------|
| stripe-api-integration | `.claude/examples/skills/stripe/stripe-api-integration/skill.md` | Core Stripe API integration |
| stripe-payments | `.claude/examples/skills/stripe/stripe-payments/skill.md` | Payment processing implementation |
| stripe-billing-subscriptions | `.claude/examples/skills/stripe/stripe-billing-subscriptions/skill.md` | Subscription billing and management |
| stripe-connect | `.claude/examples/skills/stripe/stripe-connect/skill.md` | Stripe Connect marketplace patterns |
| stripe-terminal-issuing | `.claude/examples/skills/stripe/stripe-terminal-issuing/skill.md` | Terminal and card issuing |

#### Supabase Skills (1 skill)

| Skill | File Path | Purpose |
|-------|-----------|---------|
| supabase-expert | `.claude/examples/skills/supabase/supabase-expert/skill.md` | Supabase auth, RLS, storage, edge functions (6 guides included) |

#### D3 Skills (5 skills)

| Skill | File Path | Purpose |
|-------|-----------|---------|
| d3-core-data | `.claude/examples/skills/d3/d3-core-data/skill.md` | D3 data binding and selections |
| d3-shapes-paths | `.claude/examples/skills/d3/d3-shapes-paths/skill.md` | D3 shapes, paths, and generators |
| d3-layouts-hierarchies | `.claude/examples/skills/d3/d3-layouts-hierarchies/skill.md` | D3 layouts and hierarchical data |
| d3-interaction-animation | `.claude/examples/skills/d3/d3-interaction-animation/skill.md` | D3 interactions, transitions, animations |
| d3-geo | `.claude/examples/skills/d3/d3-geo/skill.md` | D3 geographic projections and maps |

#### Bun Skills (5 skills)

| Skill | File Path | Purpose |
|-------|-----------|---------|
| bun-quickstart | `.claude/examples/skills/bun/bun-quickstart/skill.md` | Bun runtime quickstart and basics |
| bun-runtime | `.claude/examples/skills/bun/bun-runtime/skill.md` | Bun runtime APIs and patterns |
| bun-bundler | `.claude/examples/skills/bun/bun-bundler/skill.md` | Bun bundler configuration |
| bun-package-manager | `.claude/examples/skills/bun/bun-package-manager/skill.md` | Bun as package manager |
| bun-test | `.claude/examples/skills/bun/bun-test/skill.md` | Bun test runner and testing |

#### Shelby Skills (4 skills)

| Skill | File Path | Purpose |
|-------|-----------|---------|
| shelby-quickstart | `.claude/examples/skills/shelby/shelby-quickstart/skill.md` | Shelby Protocol onboarding and setup |
| shelby-cli-helper | `.claude/examples/skills/shelby/shelby-cli-helper/skill.md` | Shelby CLI operations and troubleshooting |
| shelby-sdk-integration | `.claude/examples/skills/shelby/shelby-sdk-integration/skill.md` | Shelby TypeScript SDK integration |
| shelby-media-player | `.claude/examples/skills/shelby/shelby-media-player/skill.md` | Shelby React video player components |

#### DevOps Skills (3 skills)

| Skill | File Path | Purpose |
|-------|-----------|---------|
| github-actions-architect | `.claude/examples/skills/devops/github-actions-architect/skill.md` | Generate GitHub Actions CI/CD workflows |
| git-hooks-architect | `.claude/examples/skills/devops/git-hooks-architect/skill.md` | Configure git hooks (Husky, lint-staged, commitlint) |
| vercel-deploy-architect | `.claude/examples/skills/devops/vercel-deploy-architect/skill.md` | Vercel deployment configuration and optimization |

#### Tools Skills (3 skills)

| Skill | File Path | Purpose |
|-------|-----------|---------|
| code-auditor | `.claude/examples/skills/tools/code-auditor/skill.md` | General code quality auditing |
| mcp-optimization | `.claude/examples/skills/tools/mcp-optimization/skill.md` | MCP server token optimization (95%+ reduction) |
| clarity-dal-architect | `.claude/examples/skills/tools/clarity-dal-architect/skill.md` | Clarity architecture Data Access Layer patterns |

#### Meta Skills (1 skill)

| Skill | File Path | Purpose |
|-------|-----------|---------|
| skill-builder | `.claude/examples/skills/meta/skill-builder/skill.md` | Meta-skill for creating new Claude Code skills with YAML frontmatter |

#### Other Skills (2 skills)

| Skill | File Path | Purpose |
|-------|-----------|---------|
| resend-email-architect | `.claude/examples/skills/resend/resend-email-architect/skill.md` | Resend email service integration |
| complextropy | `.claude/examples/skills/qc/complextropy/skill.md` | Quantum computing complexity analysis |

### Hooks - Quality Automation (10 hooks + 2 utilities)

**Hooks (10):**

| Hook | File Path | Purpose |
|------|-----------|---------|
| check_after_edit | `.claude/examples/hooks/check_after_edit.ts` | TypeScript/lint/format validation after edits |
| security_scan | `.claude/examples/hooks/security_scan.ts` | Security vulnerability scanning (secrets, XSS, SQL injection) |
| code_quality | `.claude/examples/hooks/code_quality.ts` | Code quality metrics and complexity analysis |
| architecture_check | `.claude/examples/hooks/architecture_check.ts` | Architecture compliance and layer boundaries |
| react_quality | `.claude/examples/hooks/react_quality.ts` | React best practices and patterns |
| accessibility | `.claude/examples/hooks/accessibility.ts` | WCAG compliance and accessibility checks |
| import_organization | `.claude/examples/hooks/import_organization.ts` | Auto-organize and sort imports |
| bundle_size_check | `.claude/examples/hooks/bundle_size_check.ts` | Bundle size monitoring and warnings |
| advanced_analysis | `.claude/examples/hooks/advanced_analysis.ts` | Memory leaks, race conditions, cache usage |
| gwern-checklist | `.claude/examples/hooks/gwern-checklist.ts` | Gwern-style quality checklist |

**Utility Files (2):**

| File | File Path | Purpose |
|------|-----------|---------|
| cache | `.claude/examples/hooks/cache.ts` | File-based caching for hook results |
| config | `.claude/examples/hooks/config.ts` | Central configuration for all hooks |

### GitHub Workflows (3 workflows)

| Workflow | File Path | Purpose |
|----------|-----------|---------|
| CI | `.github/workflows/ci.yml` | Test, lint, type-check on push/PR (Node 18, 20, 22 matrix) |
| Deploy | `.github/workflows/deploy.yml` | Vercel deployment with preview URLs on PR |
| Release | `.github/workflows/release.yml` | Automated releases on tag push with changelog |

### GitHub Templates (2 templates)

| Template | File Path | Purpose |
|----------|-----------|---------|
| Pull Request Template | `.github/pull_request_template.md` | PR checklist with summary, testing, type of change |
| CODEOWNERS | `.github/CODEOWNERS` | Auto-assign reviewers based on file paths |

### Documentation (12 docs)

| Document | File Path | Purpose |
|----------|-----------|---------|
| Quick Start | `.claude/docs/quickstart.md` | Get started in 5 minutes |
| Customization | `.claude/docs/customization.md` | Extend and configure the starter kit |
| Quick Reference | `.claude/docs/quick-reference.md` | Quick command/feature reference |
| Git Workflows | `.claude/docs/workflows.md` | Complete git automation guide |
| Contributing | `.claude/docs/development/CONTRIBUTING.md` | Contribution guidelines |
| Plugin Development | `.claude/docs/development/PLUGIN_DEVELOPMENT.md` | Extend the plugin system |
| Changelog | `.claude/docs/development/CHANGELOG.md` | Version history |
| Release Notes v1.0.0 | `.claude/docs/releases/RELEASE_NOTES_v1.0.0.md` | Initial release notes |
| Toon README | `.claude/docs/toon/README.md` | Toon utility documentation |
| Toon Integration | `.claude/docs/toon/TOON_INTEGRATION_STRATEGY.md` | Toon integration strategy |
| Toon Quick Start | `.claude/docs/toon/TOON_QUICK_START.md` | Toon setup and usage |
| Docs Index | `.claude/docs/README.md` | Documentation index |

### Output Patterns (2 patterns)

| Pattern | File Path | Purpose |
|---------|-----------|---------|
| Executive Style | `.claude/examples/patterns/output-styles/executive.md` | Executive summary output format |
| Technical Style | `.claude/examples/patterns/output-styles/technical.md` | Technical documentation output format |

### Plugin Configuration (2 files)

| File | File Path | Purpose |
|------|-----------|---------|
| Plugin Manifest | `.claude/plugin/plugin.json` | Claude Code plugin configuration |
| Marketplace Metadata | `.claude/plugin/marketplace.json` | Marketplace listing metadata |

### Scripts (1 script)

| Script | File Path | Purpose |
|--------|-----------|---------|
| Verify | `.claude/scripts/verify.sh` | Verification script for setup |

## Configuration Philosophy

**Minimal by default, maximum flexibility:**

1. **Core components** - Framework-agnostic, work with any stack
2. **Examples** - Framework-specific expertise (Next.js, React, Stripe, etc.)
3. **Enable by copying** - `cp -r examples/skills/next core/skills/`
4. **Settings minimal** - Hooks disabled by default in `.claude/settings.json`

### Settings Pattern

Default `.claude/settings.json`:
```json
{
  "hooks": {
    "PostToolUse": []
  },
  "comment": "Minimal starter. Copy from examples/ as needed."
}
```

Enable hooks by updating settings:
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

## Git Workflow Automation

Recently added comprehensive git automation (Nov 2024):

### Commands Added
- `/commit` - Analyzes staged changes, generates conventional commit messages
- `/create-pr` - Auto-generates PR title/description from commits, links issues, adds labels
- `/release` - Semantic versioning, changelog generation, GitHub releases, npm publishing

### Skills Added
- `github-actions-architect` - Generate CI/CD workflow files with best practices
- `git-hooks-architect` - Configure Husky, lint-staged, commitlint
- `vercel-deploy-architect` - Vercel deployment configuration and optimization

### Workflows Added
- `ci.yml` - Parallel test, lint, type-check on push/PR
- `deploy.yml` - Vercel deployment with preview URLs
- `release.yml` - Automated releases on tag push

### Templates Added
- `pull_request_template.md` - PR checklist template
- `CODEOWNERS` - Auto-reviewer assignment

All git automation uses **conventional commits** format:
```
type(scope): subject

body

footer
```

Types: `feat`, `fix`, `refactor`, `perf`, `style`, `test`, `docs`, `build`, `ci`, `chore`

## Development Patterns

### Skill Creation Pattern

Reference: `.claude/examples/skills/meta/skill-builder/skill.md`

```markdown
---
name: skill-name
description: Clear WHAT and WHEN to invoke (critical for auto-invocation)
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
model: sonnet
---

# Skill Name

## Purpose
[What it does]

## When to Use
- Specific trigger 1
- Specific trigger 2

## Process
1. Step 1
2. Step 2

## Examples
[Real-world scenarios]
```

**Critical:** The `description` field determines when Claude invokes the skill. Include specific keywords users will say.

### Command Creation Pattern

Commands are procedural markdown:

```markdown
Command description and usage

Usage: /command-name [args]

Execute the following workflow:

1. **Step Name**
   ```bash
   # Commands to run
   git status
   ```
   - Validation checks
   - Error handling

2. **Next Step**
   ...
```

### Agent Creation Pattern

Agents are like skills but with different invocation:

```markdown
---
name: agent-name
description: When to invoke (keywords that trigger agent)
---

# Agent Name

[Procedural instructions for Claude to follow]
```

### Hook Creation Pattern

Hooks are TypeScript files that export validation logic:

```typescript
// .claude/examples/hooks/example.ts
export async function validate(context) {
  // Check for issues
  if (issue) {
    return {
      level: 'error',
      message: 'Issue description'
    }
  }
}
```

## File Organization

```
claude-starter/
├── setup.sh                   # Automated setup script (executable)
├── .env.example              # Environment template with all integrations
│
├── .claude/
│   ├── core/                 # Always enabled
│   │   ├── agents/          # 3 core agents
│   │   └── commands/        # 9 core commands
│   ├── examples/             # Optional components
│   │   ├── agents/          # 6 example agents
│   │   ├── commands/        # 7 example commands
│   │   ├── skills/          # 39 skills across 12 categories
│   │   │   ├── next/       # 8 Next.js skills
│   │   │   ├── react/      # 2 React skills
│   │   │   ├── stripe/     # 5 Stripe skills
│   │   │   ├── supabase/   # 1 Supabase skill
│   │   │   ├── d3/         # 5 D3 skills
│   │   │   ├── bun/        # 5 Bun skills
│   │   │   ├── shelby/     # 4 Shelby skills
│   │   │   ├── devops/     # 3 DevOps skills
│   │   │   ├── tools/      # 3 Tools skills
│   │   │   ├── meta/       # 1 Meta skill
│   │   │   ├── resend/     # 1 Resend skill
│   │   │   └── qc/         # 1 QC skill
│   │   ├── hooks/          # 10 quality automation hooks + 2 utilities
│   │   └── patterns/       # 2 output style patterns
│   ├── presets/              # Preset configurations (NEW)
│   │   ├── minimal.json
│   │   ├── nextjs-full.json
│   │   ├── stripe-commerce.json
│   │   ├── fullstack-saas.json
│   │   ├── react-focused.json
│   │   ├── devops-complete.json
│   │   └── README.md       # Preset documentation
│   ├── docs/                # 12 documentation files
│   ├── plugin/              # 2 plugin config files
│   ├── scripts/             # 1 verification script
│   └── settings.json       # Minimal configuration
│
└── .github/
    ├── workflows/           # 3 CI/CD workflows
    ├── CODEOWNERS          # Reviewer assignment
    └── pull_request_template.md # PR template
```

## Skill Categories Explained

### Framework Skills (15 skills)
- **Next.js** (8 skills) - Complete Next.js 13+ App Router coverage
- **React** (2 skills) - React 19 Server Components and form actions
- **Bun** (5 skills) - Bun runtime, bundler, test runner

### Integration Skills (10 skills)
- **Stripe** (5 skills) - Payment processing and integrations
- **Supabase** (1 skill) - Backend-as-a-service with 6 guides
- **Shelby** (4 skills) - Decentralized storage protocol

### Visualization Skills (5 skills)
- **D3** (5 skills) - Complete D3.js data visualization

### DevOps Skills (3 skills)
- **GitHub Actions** - CI/CD workflow generation
- **Git Hooks** - Pre-commit, pre-push automation
- **Vercel** - Deployment configuration

### Tools Skills (3 skills)
- **Code Auditor** - Quality auditing
- **MCP Optimization** - Token reduction for MCP servers
- **Clarity DAL** - Data Access Layer patterns

### Meta Skills (1 skill)
- **Skill Builder** - Meta-skill for creating skills with YAML frontmatter auto-generation

### Other Skills (2 skills)
- **Resend** (1 skill) - Email service integration
- **Complextropy** (1 skill) - Quantum computing complexity analysis

## Setup Automation

### Using setup.sh

The repository includes an automated setup script that handles framework detection, preset application, and environment configuration.

**Interactive mode:**
```bash
./setup.sh --interactive
```

Prompts for:
- Framework/stack selection
- Integration choices
- Hook preferences
- Generates .env.example

**Preset mode:**
```bash
./setup.sh --preset nextjs-full
./setup.sh --preset fullstack-saas
```

Available presets: minimal, nextjs-full, stripe-commerce, fullstack-saas, react-focused, devops-complete

**Stack mode:**
```bash
./setup.sh --stack next,stripe,supabase
```

**Auto-detection:**
```bash
./setup.sh  # Detects from package.json
```

### Preset System

Presets are JSON files in `.claude/presets/` that define:
- Skills to enable
- Recommended hooks
- Required environment variables
- Framework configuration

**Creating a custom preset:**
```json
{
  "name": "my-preset",
  "description": "Custom stack",
  "skills": ["next", "stripe"],
  "agents": [],
  "commands": [],
  "hooks": ["security_scan"],
  "env": {
    "FRAMEWORK": "nextjs",
    "ENABLE_STRIPE": "true"
  },
  "recommended": {
    "hooks": "security-focused",
    "envVars": ["STRIPE_SECRET_KEY"]
  }
}
```

Save as `.claude/presets/my-preset.json` and use with `./setup.sh --preset my-preset`

## Common Tasks

### Adding a New Skill

```bash
# 1. Create skill directory
mkdir -p .claude/examples/skills/category/skill-name

# 2. Create skill.md with YAML frontmatter
cat > .claude/examples/skills/category/skill-name/skill.md << 'EOF'
---
name: skill-name
description: What it does and when to invoke (critical!)
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
model: sonnet
---

# Skill Name
[Content...]
EOF

# 3. Update README.md to list the skill

# 4. Update .claude/examples/README.md

# 5. Add to relevant preset in .claude/presets/ if applicable
```

### Adding a New Command

```bash
# 1. Create command file
vim .claude/core/commands/new-command.md

# 2. Write procedural instructions

# 3. Update README.md command list

# 4. Test: /new-command
```

### Adding a New Agent

```bash
# 1. Create agent file
vim .claude/core/agents/new-agent.md

# 2. Write YAML frontmatter + instructions

# 3. Update README.md agent list

# 4. Restart Claude Code to load
```

### Adding a New Hook

```bash
# 1. Create hook file
vim .claude/examples/hooks/new_hook.ts

# 2. Export validate function

# 3. Update .claude/examples/README.md

# 4. Users enable via settings.json
```

### Enabling Optional Features (User Instructions)

**Automated (recommended):**
```bash
# Use setup script
./setup.sh --interactive
# or
./setup.sh --stack stripe,supabase

# Enable hooks
/enable-hook quality-focused
```

**Manual:**
```bash
# Enable a skill
cp -r .claude/examples/skills/stripe .claude/core/skills/

# Enable an agent
cp .claude/examples/agents/type-generator.md .claude/core/agents/

# Enable a hook
/enable-hook security_scan
# or edit .claude/settings.json manually

# Enable a command
cp .claude/examples/commands/review-pr.md .claude/core/commands/
```

## Repository Size

This is a template repository users clone:
- **Git clone size**: ~12 MB
- **Tracked files**: 2.4 MB
- **Recent optimization**: Removed Aptos skills (1.1 MB, Nov 2024)
- **Balance**: Comprehensive examples vs reasonable clone size

Size breakdown:
- `.claude/` directory: 2.4 MB
- `.git/` directory: 12 MB
- Root files: < 100 KB

## Testing Changes

Since this is a template, test by:

1. **Test setup script**: `./setup.sh --help` to verify all options work
2. **Test preset application**: `./setup.sh --preset minimal` (in a temp directory)
3. **Test framework detection**: Create package.json with dependencies, run `./setup.sh`
4. **Test core commands**: `/build-safe`, `/commit`, `/create-pr`, `/release`, `/self-test`
5. **Test agents**: Trigger with relevant keywords
6. **Test skills**: Mention framework names (Next.js, Stripe, etc.)
7. **Test hooks**: `/enable-hook quality-focused` and edit files
8. **Test workflows**: Push to GitHub and verify CI runs
9. **Validate environment**: Verify .env.example has all integrations documented

## User Workflow (Typical Journey)

### Modern Workflow (Recommended)

1. **Clone**: `git clone https://github.com/raintree-technology/claude-starter`
2. **Navigate to project**: `cd /my-project`
3. **Run setup**: `/path/to/claude-starter/setup.sh --interactive`
4. **Configure environment**: `cp .env.example .env` and fill in values
5. **Validate**: `/self-test` to check configuration
6. **Start coding**: `claude` to begin
7. **Commit config**: Git commit `.claude/core/`, `.claude/settings.json`
8. **Gitignore**: `.env`, `.claude/settings.local.json`, `.claude/**/.cache/`

### Classic Workflow (Manual)

1. **Clone**: `git clone https://github.com/raintree-technology/claude-starter`
2. **Copy**: `cp -r claude-starter/.claude /my-project/`
3. **Use immediately**: Core commands and agents work
4. **Enable as needed**: `cp -r .claude/examples/skills/X .claude/core/skills/`
5. **Configure hooks**: `/enable-hook quality-focused`
6. **Customize**: Modify agents/commands for specific stack
7. **Commit**: `.claude/core/`, `.claude/settings.json` (version control)
8. **Gitignore**: `.claude/settings.local.json`, `.claude/**/.cache/`

## Important Conventions

### Naming
- **Agents**: `lowercase-with-hyphens.md`
- **Commands**: `lowercase-with-hyphens.md` (invoked as `/command-name`)
- **Skills**: Directory `skill-name/` with `skill.md` inside
- **Hooks**: `snake_case.ts`

### YAML Frontmatter (Skills/Agents)
```yaml
---
name: skill-name               # Required, lowercase-with-hyphens
description: What and when     # Required, critical for invocation
allowed-tools: [list]         # Optional, restricts tool access
model: sonnet                  # Optional, sonnet/opus/haiku
---
```

### Conventional Commits
All commits in this repo follow:
```
type(scope): subject

body

footer
```

Examples:
- `feat(skills): add github-actions-architect skill`
- `fix(commands): resolve /release tag creation issue`
- `docs(readme): update workflow section`

### Documentation
- **User-facing**: `.claude/docs/` (quickstart, customization, workflows)
- **Skill READMEs**: Each skill has README.md for installation/usage
- **Main README**: Overview, quick start, structure
- **This file**: Architecture and development guide

## Key Files Reference

| File | Purpose |
|------|---------|
| `README.md` | Main user documentation, features, installation |
| `CLAUDE.md` | This file - development guide for Claude instances |
| `.claude/settings.json` | Minimal configuration (hooks disabled) |
| `.claude/core/` | Always-enabled components (agents, commands) |
| `.claude/examples/` | Opt-in library (skills, hooks, patterns) |
| `.claude/docs/workflows.md` | Complete git workflow automation guide |
| `.gitignore` | Excludes .claude/settings.local.json, node_modules, etc. |
| `LICENSE` | MIT license |

## Recent Changes (November 2024)

1. **Removed Aptos skills** (10 skills, 1.1 MB) - Size optimization
2. **Added git workflow automation**:
   - Commands: `/commit`, `/create-pr`, `/release`
   - Skills: github-actions-architect, git-hooks-architect, vercel-deploy-architect
   - Workflows: ci.yml, deploy.yml, release.yml
   - Templates: PR template, CODEOWNERS
3. **Documentation**: Added `.claude/docs/workflows.md` (comprehensive guide)
4. **Updated README**: New "Git Workflows" section
5. **Skill organization overhaul**:
   - Removed 5 empty Stripe placeholder directories
   - Created 3 new categories: devops/, tools/, meta/
   - Reorganized 7 top-level skills into categories
   - Total: 39 skills across 12 organized categories
6. **Hook activation automation**:
   - Added `/enable-hook` command with presets
   - Automatic settings.json updating
   - Support for individual hooks or presets (quality-focused, security-focused, react-focused, all)
7. **Setup validation**:
   - Added `/self-test` command for comprehensive validation
   - 13-step validation including directory structure, settings, agents, commands, skills, hooks, framework detection, environment configuration
   - Auto-fix mode with `--fix` flag
8. **Automated setup system** (NEW):
   - Interactive setup script (`setup.sh`) with framework auto-detection
   - 6 preset configurations (minimal, nextjs-full, stripe-commerce, fullstack-saas, react-focused, devops-complete)
   - Environment template (`.env.example`) with all integrations documented
   - Stack-based selection (--stack next,stripe,supabase)
   - Integration detection from package.json
   - Setup wizard with guided Q&A

## Advanced Features & FAQs

### Skill Builder: YAML Frontmatter Auto-Generation

The `skill-builder` meta-skill (`.claude/examples/skills/meta/skill-builder/skill.md`) **does** generate YAML frontmatter automatically when creating new skills:

```yaml
---
name: skill-name
description: Clear description of what and when (critical for auto-invocation)
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
model: sonnet
---
```

**Key capabilities:**
- Auto-generates name from user's request
- Creates description with invocation triggers
- Sets up directory structure (`category/skill-name/skill.md`)
- Includes README.md with installation instructions
- Provides example content based on skill type (code-reviewer, api-builder, test-generator, etc.)

**Usage:** Mention "create a skill for X" and the skill-builder automatically activates.

### Hook Caching: Persistence and Cache Management

The hook caching system (`.claude/examples/hooks/cache.ts`) provides performance optimization:

**Cache Persistence:**
- Cache stored in `.claude/examples/hooks/.cache/` (file-based)
- TTL (Time To Live): Configurable per hook in `.claude/examples/hooks/config.ts`
- Default TTL: 5 minutes for most checks, 1 hour for expensive operations
- Survives Claude Code restarts (persisted to disk)

**Cache Key Structure:**
```typescript
cacheKey = hash(filePath + fileContent + hookName + hookVersion)
```

**Clearing Cache:**
- Manual: Delete `.claude/examples/hooks/.cache/` directory
- Programmatic: Use cache.clear() in hooks
- **No dedicated `/clear-cache` for hooks** - The `/clear-cache` command (`.claude/examples/commands/clear-cache.md`) clears build caches (node_modules/.cache, .next, etc.), not hook caches

**Cache invalidation:**
- File content changes → new hash → cache miss
- Hook version changes → cache miss
- TTL expires → cache miss

### Multi-Agent Coordination Patterns

The `chief-of-staff` and `research-agent` demonstrate multi-agent patterns:

**Pattern 1: Hierarchical Delegation** (chief-of-staff)
```
Chief Agent
├── Financial Analyst Sub-Agent (budget analysis)
├── Recruiter Sub-Agent (hiring workflows)
└── Coordinator (orchestrates sub-agents)
```

**Pattern 2: Research Coordination** (research-agent)
```
Research Lead
├── Define research questions
├── Spawn specialized researchers
├── Aggregate findings
└── Synthesize report
```

**Coordination mechanisms:**
1. **Explicit handoffs**: Main agent delegates specific tasks
2. **Context sharing**: Sub-agents receive scoped context
3. **Result aggregation**: Main agent synthesizes outputs
4. **Sequential execution**: Sub-agents run in order, each building on previous results

**Documentation location:** See agent markdown files for detailed workflows:
- `.claude/examples/agents/chief-of-staff/`
- `.claude/examples/agents/research-agent/`

### Conventional Commits: Pre-Commit Hook Enforcement

**Yes, there is enforcement available** through the `git-hooks-architect` skill:

**Setup process:**
1. Enable git-hooks skill: `cp -r .claude/examples/skills/devops/git-hooks-architect .claude/core/skills/`
2. Ask Claude: "Set up git hooks with commitlint"
3. Skill configures:
   - Husky for git hooks
   - commitlint for message validation
   - lint-staged for pre-commit checks

**Validation rules (commitlint.config.js):**
```javascript
{
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [2, 'always', [
      'feat', 'fix', 'refactor', 'perf', 'style',
      'test', 'docs', 'build', 'ci', 'chore'
    ]],
    'subject-case': [2, 'always', 'lower-case'],
    'subject-max-length': [2, 'always', 72]
  }
}
```

**Pre-commit validation flow:**
1. User attempts commit
2. Husky triggers commit-msg hook
3. commitlint validates message format
4. Commit succeeds or fails with helpful error

**Example enforcement:**
```bash
git commit -m "updated stuff"
# Error: Subject must start with type (feat, fix, etc.)

git commit -m "feat(auth): add two-factor authentication"
# Success: Valid conventional commit
```

**Bypass option:** `git commit --no-verify` (for emergencies only)

### Skill Conflicts: Priority and Resolution

**Current behavior:** Skills do NOT conflict. Multiple skills for the same framework can coexist.

**Invocation priority:**
1. **Most specific description wins**: Skill with more specific keywords in description
2. **Manual invocation**: User can explicitly reference skill name
3. **Context relevance**: Claude chooses based on conversation context

**Example scenario:**
```
User: "Help me with Next.js caching"

Available skills:
- next-cache-architect (description: "Next.js caching strategies...")
- next-app-router (description: "Next.js App Router including caching...")

Result: next-cache-architect invoked (more specific)
```

**No priority system exists** because:
- Skills are domain-specific, not overlapping
- Claude's invocation is context-aware
- Users can explicitly invoke: "Use the next-cache-architect skill to..."

**Best practice for skill authors:**
- Write precise, unique descriptions
- Include specific trigger keywords
- Avoid generic descriptions like "Helps with Next.js"

**Handling true conflicts:**
If two skills genuinely overlap:
1. Merge them into one comprehensive skill
2. Keep one enabled, disable the other (don't copy to core/)
3. Use agent description to route: "Use X skill for Y, Z skill for W"

## References for Common Patterns

- **Skill template**: `.claude/examples/skills/meta/skill-builder/skill.md`
- **Command template**: `.claude/core/commands/commit.md` (well-structured example)
- **Agent template**: `.claude/core/agents/security-auditor.md`
- **Hook template**: `.claude/examples/hooks/security_scan.ts`
- **Workflow template**: `.github/workflows/ci.yml`
- **Settings example**: `.claude/examples/hooks/README.md` (shows configuration)
