# Claude Code GitHub Actions: CI/CD Automation & PR Workflows

## Core Functionality

Claude Code GitHub Actions enables AI-powered automation through simple `@claude` mentions in pull requests and issues. The system analyzes code, creates PRs, implements features, and fixes bugs while adhering to project standards.

### Key Capabilities

The documentation highlights that with this integration, you can accomplish:

- **Instant PR creation**: "Describe what you need, and Claude creates a complete PR with all necessary changes"
- **Automated code implementation**: Converting issues into working code automatically
- **Standards adherence**: Following project guidelines defined in `CLAUDE.md`
- **Security**: Code remains on GitHub's infrastructure during processing

## Setup Process

### Quick Installation

The fastest approach uses the Claude CLI with the `/install-github-app` command, which guides users through GitHub app installation and secret configuration. Repository admin privileges are required.

### Manual Setup Steps

1. Install the Claude GitHub app with required permissions for Contents, Issues, and Pull Requests
2. Add `ANTHROPIC_API_KEY` to repository secrets
3. Copy the workflow file from the examples directory into `.github/workflows/`

## Configuration for v1.0

The latest version simplified workflow configuration:

```yaml
- uses: anthropics/claude-code-action@v1
  with:
    anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
    prompt: "Your instructions"
    claude_args: "--max-turns 5"
```

Key parameters include the prompt instruction, CLI arguments passthrough, and optional custom trigger phrases beyond the default `@claude` mention.

## Enterprise Cloud Integration

For AWS Bedrock and Google Vertex AI, the documentation provides workflows using:

- **AWS**: OIDC identity provider configuration with IAM roles
- **Google Cloud**: Workload Identity Federation with service account impersonation

Both approaches eliminate hardcoded credentials through temporary token exchange.

## Best Practices

- Create `CLAUDE.md` files defining coding standards and review criteria
- Use GitHub Secrets for all API credentials
- Configure appropriate `--max-turns` limits to control costs
- Set workflow timeouts to prevent runaway jobs
- Implement concurrency controls for parallel executions

## Cost Considerations

Users should monitor:

- GitHub Actions runner minutes consumed
- API token usage based on prompt/response length
- Task complexity and codebase size factors

The documentation recommends specific commands, appropriate turn limits, and workflow-level timeouts as optimization strategies.
