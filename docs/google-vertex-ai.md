# Claude Code on Google Vertex AI - Complete Documentation Summary

## Overview
This guide covers configuring Claude Code through Google Vertex AI, including setup procedures, IAM configuration, and troubleshooting strategies.

## Key Prerequisites
Users need a GCP account with billing enabled, Vertex AI API access, appropriate Claude model access, Google Cloud SDK installed, and allocated quota in their desired region.

## Region Configuration
Claude Code supports both global and regional Vertex AI endpoints. However, "Vertex AI may not support the Claude Code default models on all regions," requiring users to potentially switch to supported alternatives.

## Setup Process (5 Steps)

**Step 1: Enable Vertex AI API**
Users must enable the Vertex AI API using gcloud commands with their project ID.

**Step 2: Request Model Access**
Access requires navigating to the Vertex AI Model Garden, searching for Claude models, and requesting approval (typically 24-48 hours).

**Step 3: Configure GCP Credentials**
Standard Google Cloud authentication is used, with automatic project ID detection from environment variables.

**Step 4: Environment Variables**
Critical settings include `CLAUDE_CODE_USE_VERTEX=1`, `CLOUD_ML_REGION`, and `ANTHROPIC_VERTEX_PROJECT_ID`, with optional region overrides for specific models.

**Step 5: Model Configuration**
Default models are Claude Sonnet 4.5 (primary) and Claude Haiku 4.5 (fast), customizable via environment variables.

## IAM Requirements
The `roles/aiplatform.user` role provides necessary permissions for model invocation and token counting.

## Advanced Features
Claude Sonnet models support the 1M token context window (currently in beta), requiring specific beta headers in requests.

## Troubleshooting Guide
- **Quota issues**: Check Cloud Console quotas
- **404 errors**: Verify model enablement and regional access
- **429 errors**: Ensure model support in selected regions or switch to global endpoints
