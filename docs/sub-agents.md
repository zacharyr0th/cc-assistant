# Claude Code Subagents Documentation Summary

## Core Concept
Subagents are specialized AI assistants that Claude Code can delegate tasks to. Each operates with its own context window, custom system prompt, and configurable tool access.

## Key Features

**Context Management**: "Each subagent operates in its own context, preventing pollution of the main conversation" while maintaining focus on primary objectives.

**Specialized Functions**: Subagents can be fine-tuned with detailed instructions for specific domains, improving success rates on designated tasks.

**Reusability & Permissions**: Once created, these agents work across projects and teams with flexible tool access controls tailored to their purpose.

## Quick Setup

Access the subagents interface via `/agents` command, then:
1. Choose project-level or user-level creation
2. Define purpose and tools (can auto-generate with Claude)
3. Save and use automatically or invoke explicitly

## Storage & Configuration

**Locations**:
- Project subagents: `.claude/agents/` (highest priority)
- User subagents: `~/.claude/agents/` (lower priority)
- Plugin agents: integrated through plugin manifests

**File Format**: Markdown with YAML frontmatter including name, description, tools, and model specifications.

## Advanced Features

- **CLI-based configuration**: Define subagents dynamically using `--agents` flag
- **Subagent chaining**: Sequence multiple agents for complex workflows
- **Resumable agents**: Continue previous conversations with stored context via `agentId`
- **Built-in Plan subagent**: Researches codebases in plan mode

## Best Practices

Design focused agents with single responsibilities, detailed prompts, limited tool access, and version control integration for team collaboration.
