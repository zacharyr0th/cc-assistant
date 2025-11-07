# Claude Code OpenTelemetry Monitoring Documentation

## Overview

Claude Code supports OpenTelemetry for collecting metrics and events. Users must ensure their backends are properly configured to handle the exported data.

## Quick Start Configuration

Enable telemetry via environment variables:

```bash
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_METRICS_EXPORTER=otlp
export OTEL_LOGS_EXPORTER=otlp
export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
```

The documentation notes that "default export intervals are 60 seconds for metrics and 5 seconds for logs."

## Administrator Setup

System administrators can centralize configuration through managed settings files located at platform-specific paths (macOS `/Library/Application Support/ClaudeCode/managed-settings.json`, Linux/WSL `/etc/claude-code/managed-settings.json`, Windows `C:\ProgramData\ClaudeCode\managed-settings.json`).

## Key Configuration Options

**Core Variables:**
- `CLAUDE_CODE_ENABLE_TELEMETRY`: Activates telemetry
- `OTEL_METRICS_EXPORTER`: Console, OTLP, or Prometheus
- `OTEL_LOGS_EXPORTER`: Console or OTLP
- `OTEL_EXPORTER_OTLP_ENDPOINT`: Collector address
- `OTEL_METRIC_EXPORT_INTERVAL`: Timing in milliseconds

**Cardinality Controls:**
- `OTEL_METRICS_INCLUDE_SESSION_ID` (default: true)
- `OTEL_METRICS_INCLUDE_VERSION` (default: false)
- `OTEL_METRICS_INCLUDE_ACCOUNT_UUID` (default: true)

## Metrics Exported

Eight primary metrics track:
- Session initiation
- Code modifications
- Pull requests and commits
- Usage costs and token consumption
- Code editing tool decisions
- Active session duration

## Events Tracked

The system logs five event types:
1. **User Prompt** - captures submission with optional content logging
2. **Tool Result** - documents execution success/failure
3. **API Request** - records model interactions with token data
4. **API Error** - logs failures with status information
5. **Tool Decision** - tracks accept/reject actions

"User prompt content is redacted by default - only prompt length is recorded."

## Standard Attributes

All telemetry includes session ID, app version, organization ID, account UUID, and terminal type when available.

## Authentication

Supports static headers via `OTEL_EXPORTER_OTLP_HEADERS` or dynamic generation through scripts configured in settings, though headers are fetched only at startup.

## Multi-Team Support

Organizations can use `OTEL_RESOURCE_ATTRIBUTES` to add custom identifiers for departments and cost centers, following W3C Baggage specification formatting (no spaces, comma-separated key=value pairs).

## Privacy Features

Telemetry requires explicit opt-in, excludes sensitive data like credentials, and redacts prompts by default unless `OTEL_LOG_USER_PROMPTS=1` is set.

## Backend Recommendations

Different backend types suit different needs—Prometheus for rate calculations, ClickHouse for complex queries, and full observability platforms for advanced correlation analysis.

## Additional Resources

The documentation references a [Claude Code ROI Measurement Guide](https://github.com/anthropics/claude-code-monitoring-guide) with Docker Compose configurations and reporting templates, plus Amazon Bedrock-specific guidance.
