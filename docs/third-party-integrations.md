# Enterprise Deployment Overview for Claude Code

## Key Documentation Summary

Claude Code offers flexible enterprise deployment through multiple cloud providers and infrastructure options.

### Provider Options

The documentation outlines three primary deployment pathways:

1. **Anthropic Direct** – "API key" authentication with dashboard cost tracking
2. **Amazon Bedrock** – AWS-native with "IAM-based authentication and AWS-native monitoring"
3. **Google Vertex AI** – GCP deployment with "enterprise-grade security and compliance"

### Infrastructure Configurations

Organizations can deploy Claude Code using:

- **Direct provider access** for simplest setup with existing cloud infrastructure
- **Corporate proxy** for traffic monitoring, routing through "HTTP/HTTPS proxy for routing traffic"
- **LLM Gateway** for centralized control with "usage tracking across teams" and dynamic model switching

### Critical Configuration Distinction

The guide emphasizes an important difference: "Corporate proxy" handles traffic routing, while "LLM Gateway" manages authentication and provides "provider-compatible endpoints."

### Key Recommendations

For organizational success, the documentation advises:
- Deploying documentation files (CLAUDE.md) at multiple levels for codebase understanding
- Implementing managed security policies through configuration
- Using MCP servers for system integrations like ticketing and error logs
- Starting users with guided usage before agentive operations

### Debugging Tools

Teams can use the `claude /status` command for observability and set `ANTHROPIC_LOG=debug` for detailed request logging.
