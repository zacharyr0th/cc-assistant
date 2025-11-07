# Claude Code on the Web - Documentation Summary

## Overview
Claude Code on the web allows developers to execute Claude Code tasks asynchronously on secure cloud infrastructure. Currently in research preview, it's available to Pro and Max users, with Team and Enterprise premium seat availability coming soon.

## Key Capabilities
The service excels at several use cases:
- Code architecture questions and feature implementation inquiries
- Bug fixes and routine coding tasks
- Parallel work on multiple issues simultaneously
- Working with repositories not locally available
- Backend modifications with test-driven development

## Getting Started
Users begin by visiting claude.ai/code, connecting their GitHub account, installing the Claude GitHub app, selecting a default environment, and submitting their coding task. Changes can then be reviewed and converted into pull requests.

## Execution Process
When launching a task, the system clones your repository to an Anthropic-managed virtual machine, prepares a secure cloud environment, configures network access according to your settings, executes the task (with Claude analyzing code and running tests), and notifies you upon completion.

## Cloud Environment
"The universal image includes pre-configured environments for popular programming languages" including Python, Node.js, Java, Go, Rust, and C++. Users can verify available tools by requesting the `check-tools` command.

## Configuration Options
Developers can configure SessionStart hooks for automatic dependency installation, manage environment variables, and adjust network access levels between limited (default allowlist) and full internet access.

## Network Security
All outbound traffic passes through an HTTP/HTTPS proxy for security. GitHub operations use a dedicated proxy service with scoped credentials, restricting push operations to the current working branch.

## Security Features
Sessions run in isolated virtual machines with credential protection—sensitive data never enters the sandbox directly. Authentication is handled through secure proxies using scoped credentials.

## Limitations
- Web sessions only work with GitHub-hosted repositories
- Moving sessions between web and local requires account authentication parity
