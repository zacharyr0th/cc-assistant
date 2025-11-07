# Claude Code Data Usage Documentation Summary

## Key Data Policies

**Consumer Users (Free, Pro, Max):**
Starting August 28, 2025, users can opt-in to allow data use for model improvement. The deadline to select preferences is October 8, 2025. Users choosing to allow data sharing face a 5-year retention period, while those declining experience 30-day retention.

**Commercial Users (Team, Enterprise, API):**
"Anthropic does not train generative models using code or prompts sent to Claude Code under" standard commercial terms. Standard retention is 30 days, with zero-retention options available for API configurations.

## Data Handling Specifics

Claude Code operates locally on user machines, encrypting data in transit via TLS. For web-based sessions, code runs in Anthropic-managed virtual machines with automatic deletion post-session. GitHub credentials use secure proxies rather than entering sandboxes directly.

## Telemetry and Feedback

Three optional telemetry services connect from user machines:

1. **Statsig**: Logs operational metrics without code or file paths
2. **Sentry**: Records error data with encryption
3. **Bug reporting** (`/bug`): Sends full conversation history; transcripts retained 5 years

Users can disable these via environment variables. Bedrock and Vertex APIs disable non-essential traffic by default.

## Session Quality Surveys

Quality surveys collect only numeric ratings without storing conversation content, inputs, or outputs—they don't affect training preferences.
