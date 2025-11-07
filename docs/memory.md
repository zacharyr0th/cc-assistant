# Claude Code Memory Management Documentation

## Overview
Claude Code retains user preferences across sessions through a hierarchical memory system. This documentation outlines the four memory types, their locations, purposes, and best practices for implementation.

## Memory Hierarchy

The system uses four tiers of memory:

1. **Enterprise Policy** - Organization-wide instructions deployed by IT/DevOps teams across platforms (macOS, Linux, Windows)

2. **Project Memory** - Team-shared guidelines stored in `./CLAUDE.md` or `./.claude/CLAUDE.md`, distributed via version control

3. **User Memory** - Personal preferences stored in `~/.claude/CLAUDE.md` applicable to all projects

4. **Project Memory (Local)** - Deprecated personal preferences using `./CLAUDE.local.md`

Higher-tier memories take precedence, with enterprise policies providing foundational context.

## Key Features

**Import Functionality**: Memory files support importing additional resources using `@path/to/import` syntax, enabling modular organization. Imports support relative and absolute paths with a maximum recursion depth of five levels.

**Discovery Process**: Claude scans from the current working directory upward (excluding root) for memory files, plus discovers nested files within subtrees when accessed.

**Quick Addition**: Users can prefix input with `#` to rapidly add memories with a prompt to select the destination file.

## Setup and Management

The `/init` command bootstraps a new CLAUDE.md file. The `/memory` command opens existing memory files for editing. Users can view loaded memories via the `/memory` command.

## Recommended Practices

Effective memories should be specific rather than vague, organized with markdown structure and bullet points, and periodically reviewed as projects evolve. Documentation recommends including frequently-used commands, coding style preferences, and architectural patterns.
