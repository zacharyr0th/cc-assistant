# Claude Code Common Workflows

## Core Workflows

**Codebase Understanding**
Start by navigating to your project root and launching Claude Code with `claude`. Request "an overview of this codebase," then ask targeted questions about architecture patterns, data models, and authentication handling. The documentation suggests: "Start with broad questions, then narrow down to specific areas."

**Bug Fixing**
Share error messages and reproduction steps with Claude. Ask for fix recommendations, then apply changes incrementally. The guide notes: "Tell Claude the command to reproduce the issue and get a stack trace."

**Code Refactoring**
Identify deprecated patterns, request modernization suggestions, and apply changes safely while maintaining backward compatibility. Verify improvements with tests afterward.

**Testing Workflows**
Find untested functions, generate test scaffolding, add edge case coverage, and run verification. The documentation recommends: "Ask for tests that cover edge cases and error conditions."

**Pull Request Creation**
Summarize your modifications, have Claude generate PR descriptions with context, and enhance documentation with security considerations.

## Advanced Features

**Specialized Subagents**: Use `/agents` to view available agents or create custom ones for security reviews, performance optimization, and debugging.

**Plan Mode**: Enable with `claude --permission-mode plan` to analyze code safely without making changes—ideal for complex architectural planning.

**Extended Thinking**: Toggle with Tab or use prompts like "think hard" for deep reasoning on complex problems.

**Session Resuming**: Use `claude --continue` for recent conversations or `claude --resume` to select specific past sessions.

**Git Worktrees**: Run parallel Claude instances with isolated codebases using `git worktree add`.

**File References**: Use `@` syntax to include files (e.g., `@src/utils/auth.js`) or directories in conversations without manual copying.

## Practical Integration

**Build Script Integration**: Add Claude as a linter in `package.json` with custom prompts for automated code review.

**Custom Slash Commands**: Create reusable project commands in `.claude/commands/` (shared) or `~/.claude/commands/` (personal).

**Output Formatting**: Control responses with `--output-format text` (default), `--output-format json`, or `--output-format stream-json` for pipeline integration.
