# Claude Code Checkpointing Documentation Summary

## Core Functionality

Claude Code provides automatic checkpoint tracking that captures code state before each edit. As stated in the documentation, "checkpointing automatically captures the state of your code before each edit," enabling users to recover from unwanted modifications.

## Key Features

**Automatic Tracking:**
The system creates a new checkpoint with each user prompt and maintains these across sessions for up to 30 days. This allows recovery points to persist beyond individual conversations.

**Rewind Mechanism:**
Users access the rewind menu by pressing Esc twice or typing `/rewind`. This presents three restoration options: reverting only the conversation, only code changes, or both together.

## Primary Use Cases

The documentation identifies three main applications:
- Testing different implementation strategies while preserving the original approach
- Quickly undoing changes that introduce bugs
- Experimenting with feature variations safely

## Important Limitations

**Bash Operations:** Commands like `rm`, `mv`, and `cp` executed through the terminal aren't tracked by checkpoints, so their effects cannot be undone through rewinding.

**External Modifications:** Changes made outside Claude Code or from concurrent sessions typically aren't captured unless they modify files already edited in the current session.

**Scope Boundaries:** The documentation emphasizes that "Checkpoints are designed for quick, session-level recovery," not permanent version control, recommending Git for long-term history and collaboration.
