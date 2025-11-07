# Claude Code GitHub Actions Documentation Summary

## Overview
Claude Code GitHub Actions enables AI-powered automation in GitHub workflows through simple `@claude` mentions in PRs and issues. The system allows Claude to analyze code, create pull requests, implement features, and fix bugs while adhering to project standards.

## Key Capabilities
According to the documentation, users can leverage Claude to:
- Generate complete pull requests from descriptions
- Transform issues into functional code implementations
- Maintain alignment with established project guidelines via `CLAUDE.md`
- Complete setup within minutes
- Keep code secure on GitHub runners

## Setup Options

**Quick Setup**: The terminal command `/install-github-app` streamlines configuration for direct Claude API users.

**Manual Setup** involves:
1. Installing the Claude GitHub app with Contents, Issues, and Pull Requests permissions
2. Adding `ANTHROPIC_API_KEY` to repository secrets
3. Copying workflow files from the examples directory

## Major Version Changes
The transition from beta to v1.0 introduced significant modifications:
- Mode auto-detection replaces manual configuration
- `direct_prompt` parameter renamed to `prompt`
- CLI options consolidated under `claude_args`
- Removal of explicit mode specification

## Cloud Provider Integration
For enterprise deployments, the action supports AWS Bedrock and Google Vertex AI through secure authentication methods:
- AWS uses GitHub OIDC Identity Provider configuration
- Google Cloud implements Workload Identity Federation
- Both approaches eliminate hardcoded credentials

## Best Practices
The documentation emphasizes creating `CLAUDE.md` files for style guidelines, using GitHub Secrets for API keys, configuring appropriate workflow timeouts, and reviewing Claude's suggestions before merging changes.
