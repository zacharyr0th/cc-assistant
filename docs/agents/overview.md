# Subagents in Claude Code: Complete Documentation

## Overview

Subagents are specialized AI assistants with dedicated contexts that Claude Code can delegate tasks to. Each subagent operates independently with its own configuration, tool access, and system prompt.

### Key Characteristics

Subagents provide four main advantages:

1. **Context Preservation**: "Each subagent operates in its own context, preventing pollution of the main conversation"
2. **Specialized Expertise**: Fine-tuned configurations enable higher success rates on designated tasks
3. **Reusability**: Once created, subagents work across projects and teams
4. **Flexible Permissions**: Individual tool access can be restricted per subagent

## Configuration Details

### File Storage Locations

| Type | Location | Scope | Priority |
|------|----------|-------|----------|
| Project subagents | `.claude/agents/` | Current project only | Highest |
| User subagents | `~/.claude/agents/` | All projects | Lower |
| Plugin agents | Plugin `agents/` directory | Via plugin integration | Varies |

### File Format Structure

Subagents use Markdown with YAML frontmatter:

```markdown
---
name: unique-identifier
description: When to invoke this subagent
tools: Tool1, Tool2, Tool3  # Optional
model: sonnet  # Optional
---

System prompt describing role and behavior...
```

### Required Configuration Fields

- **name**: Lowercase identifier with hyphens
- **description**: Natural language purpose statement
- **tools** (optional): Comma-separated list; omitting inherits all tools
- **model** (optional): `sonnet`, `opus`, `haiku`, or `'inherit'` for main conversation's model

### CLI Configuration

Dynamic subagent definition via `--agents` flag:

```bash
claude --agents '{"subagent-name": {"description": "...", "prompt": "...", "tools": [...], "model": "sonnet"}}'
```

## Delegation Methods

### Automatic Delegation

Claude Code proactively assigns tasks based on:
- Task description relevance
- Subagent `description` field matching
- Current context and tool availability

### Explicit Invocation

Request specific subagents directly:
- "Use the code-reviewer subagent to check my recent changes"
- "Have the debugger subagent investigate this error"

## Built-in Subagents

### Plan Subagent

- **Purpose**: Research and information gathering during plan mode
- **Tools**: Read, Glob, Grep, Bash
- **Model**: Sonnet
- **Automatic**: Invoked when Claude needs codebase context in plan mode

### Example Custom Subagents

**Code Reviewer**: Quality, security, and maintainability analysis
**Debugger**: Root cause analysis and error resolution
**Data Scientist**: SQL queries and BigQuery operations

## Management

The `/agents` command provides interactive management:
- View all available subagents
- Create new subagents (project or user-level)
- Edit existing configurations
- Manage tool access permissions
- Delete custom subagents

## Advanced Features

### Subagent Chaining

Sequence multiple subagents for complex workflows by requesting them sequentially in commands.

### Resumable Agents

Continue previous agent work with stored context:
- Each execution receives unique `agentId`
- Transcripts stored as `agent-{agentId}.jsonl`
- Resume with: "Resume agent [id] and [continue task]"

**Use cases**: Long-running research, iterative refinement, multi-step workflows

## Best Practices

- Generate initial subagents with Claude, then customize
- Design focused subagents with single responsibilities
- Write detailed system prompts with specific instructions
- Restrict tool access to necessary tools only
- Version control project subagents for team collaboration
- Include action-oriented language in descriptions to encourage proactive use
