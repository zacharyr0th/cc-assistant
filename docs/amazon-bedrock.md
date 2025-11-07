# Claude Code on Amazon Bedrock: Complete Documentation Summary

## Overview
This guide details configuring Claude Code with Amazon Bedrock, covering setup procedures, authentication methods, IAM permissions, and troubleshooting approaches.

## Key Prerequisites
Users need "an AWS account with Bedrock access enabled" and appropriate IAM permissions before proceeding.

## Setup Process

**Initial Steps:**
First-time users must complete a use case submission through the Amazon Bedrock console's Chat/Text playground with any Anthropic model.

**Credential Configuration Options:**
The documentation outlines four authentication pathways:
- AWS CLI configuration via `aws configure`
- Direct environment variables for access keys and session tokens
- SSO profile integration with credential refresh
- Bedrock API keys for simplified authentication

**Advanced Credential Management:**
Claude Code supports automatic credential refreshing through configuration settings. The system detects expired credentials and runs specified commands to obtain new ones before retrying requests.

## Core Configuration
Two essential environment variables activate Bedrock integration:
- `CLAUDE_CODE_USE_BEDROCK=1`
- `AWS_REGION` (required; not read from AWS config files)

## Model Defaults
- Primary: Claude Sonnet 4.5
- Fast model: Claude Haiku 4.5

Customization uses inference profile IDs or application inference profile ARNs.

## Recommended Token Settings
"`CLAUDE_CODE_MAX_OUTPUT_TOKENS=4096`" prevents throttling issues, while "`MAX_THINKING_TOKENS=1024`" balances reasoning with tool availability.

## IAM Requirements
The documentation specifies permissions for invoking models and accessing inference profiles, with optional marketplace subscription capabilities.

## Troubleshooting
Common solutions include verifying model availability through AWS CLI commands, switching to supported regions, and using inference profiles for cross-region access.
