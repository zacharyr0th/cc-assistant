# Claude Code Cost Management Documentation

## Overview
Claude Code charges by token consumption. The typical expense averages "$6 per developer per day," with "daily costs remaining below $12 for 90% of users." Teams using Sonnet 4.5 can expect approximately $100-200 monthly per developer, though usage patterns significantly affect actual expenses.

## Cost Tracking Methods

**The `/cost` Command**: This tool displays detailed session metrics including total expenditure, API duration, wall-clock time, and code modification statistics. Note: this feature excludes Claude Max and Pro subscribers.

**Console Access**: Users with appropriate permissions can review historical usage in the Claude Console and establish workspace spending caps for organizational Claude Code deployments.

## Team Rate Limit Guidelines

Organizations should configure Token Per Minute (TPM) and Request Per Minute (RPM) allowances based on team size:

- Small teams (1-5): 200k-300k TPM, 5-7 RPM per user
- Mid-size (5-20): 100k-150k TPM, 2.5-3.5 RPM per user
- Larger teams (500+): 10k-15k TPM, 0.25-0.35 RPM per user

These allocations account for varying concurrent usage patterns across differently-sized organizations.

## Token Reduction Strategies

- Enable automatic context compaction at 95% capacity threshold
- Craft targeted queries rather than broad requests
- Segment large projects into smaller focused interactions
- Reset context between unrelated tasks using `/clear`

## Background Operations

Even during idle periods, Claude Code consumes minimal tokens for conversation summarization and command processing—typically under $0.04 per session.
