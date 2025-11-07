# Claude Code Analytics Documentation Summary

## Overview
Claude Code offers an analytics dashboard enabling organizations to examine developer usage patterns, monitor productivity, and enhance Claude Code adoption. Currently, this feature is limited to organizations leveraging Claude Code via the Claude API through the Claude Console.

## Access Requirements
The analytics dashboard is located at console.anthropic.com/claude-code. Access is restricted to users holding these roles: Primary Owner, Owner, Billing, Admin, or Developer. Users with User, Claude Code User, or Membership Admin roles cannot view analytics.

## Key Metrics Available

**Code Acceptance Data**: Organizations can track "total lines of code written by Claude Code that users have accepted in their sessions," excluding rejected suggestions and subsequent deletions.

**Suggestion Accept Rate**: This metric measures the percentage of accepted code editing tool usage across Edit, Write, and NotebookEdit functions.

**Activity & Spend Tracking**: Dashboards display daily active users and sessions, plus daily spending totals. Team insights provide per-user spend and accepted code lines for the current month.

## Strategic Applications
Teams can use analytics to identify active members who exemplify best practices, assess overall adoption progression, evaluate developer satisfaction with suggestions, and spot areas requiring training or workflow enhancements.

## Additional Resources
Organizations seeking deeper insights can explore OpenTelemetry integration for custom metrics or consult identity and access management documentation for role configuration details.
