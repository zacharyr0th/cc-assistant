# Claude Code Model Configuration Documentation

This page explains how to configure models in Claude Code, including aliases and settings options.

## Model Aliases Available

Claude Code offers several convenient aliases:

- **`default`**: Recommended model based on account type
- **`sonnet`**: Latest Sonnet model (4.5) for typical coding work
- **`opus`**: Opus 4.1 for complex reasoning tasks
- **`haiku`**: Fast, lightweight model for simpler tasks
- **`sonnet[1m]`**: "Sonnet with a 1 million token context window for long sessions"
- **`opusplan`**: Hybrid mode using Opus for planning, Sonnet for execution

## Configuration Methods

You can set your model through four approaches in order of precedence:

1. During an active session using `/model <alias|name>`
2. At startup with the `--model` flag
3. Via the `ANTHROPIC_MODEL` environment variable
4. Permanently in your settings file's `model` field

## Special Features

The `opusplan` alias provides "an automated hybrid approach" where Opus handles architectural decisions while Sonnet manages implementation tasks. For API users, appending `[1m]` to full model names enables extended context windows with separate pricing.

## Monitoring and Control

Users can check their current model via the status line or `/status` command. Additionally, specific environment variables customize which full model names map to each alias, and separate controls allow disabling prompt caching globally or per model tier.
