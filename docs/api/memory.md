# Claude Code Memory Management Guide

## Memory Types and Hierarchy

Claude Code organizes memory across four levels:

1. **Enterprise Policy** - Organization-wide rules deployed by IT/DevOps to all users
2. **Project Memory** - Team instructions shared via source control
3. **User Memory** - Personal preferences applying to all projects
4. **Project Local Memory** - Deprecated; use imports instead for individual preferences

The system loads memories hierarchically, with enterprise policies at the foundation and project-level settings taking precedence for specificity.

## Setup and Usage

Initialize project memory with `/init` command, which creates a CLAUDE.md file. The fastest way to capture new information is using the `#` shortcut—simply start input with `#` followed by your instruction, then select the target memory file.

For larger edits, the `/memory` command opens memory files in your system editor. You can verify what's loaded by running `/memory` to see the complete list.

## Import Functionality

Memory files support importing additional content using `@path/to/import` syntax. This feature accepts both relative and absolute paths, allowing teams to reference shared documentation or personal instruction files without committing them to repositories. Imports support recursion up to five levels deep.

## Best Practices

Keep memories concise and specific—"Use 2-space indentation" beats vague guidance. Organize related items under clear markdown headings and review periodically as projects evolve. Store frequently used commands, architectural patterns, and coding conventions to provide ongoing context.
