# LLM Gateway Configuration Guide

## Overview
This documentation covers configuring Claude Code with LLM gateway solutions. Gateways function as centralized proxy layers offering "centralized authentication," "usage tracking," "cost controls," "audit logging," and "model routing" capabilities.

## Key LiteLLM Setup Information

**Important Disclaimer**: The guide explicitly notes that "LiteLLM is a third-party proxy service. Anthropic doesn't endorse, maintain, or audit LiteLLM's security or functionality."

### Authentication Approaches

**Static API Key Method**:
Users can set `ANTHROPIC_AUTH_TOKEN` as an environment variable or through Claude Code settings, passed as an Authorization header.

**Dynamic Key Helper**:
For rotating credentials, administrators can create bash scripts that fetch keys from vaults or generate JWT tokens. This method supports per-user authentication with configurable refresh intervals via `CLAUDE_CODE_API_KEY_HELPER_TTL_MS`.

### Endpoint Configuration

The recommended approach uses LiteLLM's unified Anthropic format endpoint (`ANTHROPIC_BASE_URL=https://litellm-server:4000`), which supports load balancing and cost tracking.

Alternative pass-through endpoints exist for:
- Claude API
- Amazon Bedrock (requires `CLAUDE_CODE_SKIP_BEDROCK_AUTH` and `CLAUDE_CODE_USE_BEDROCK`)
- Google Vertex AI (requires multiple configuration variables)

## Prerequisites
- Updated Claude Code installation
- Deployed LiteLLM Proxy Server
- Provider access to Claude models
