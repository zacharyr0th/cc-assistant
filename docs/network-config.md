# Enterprise Network Configuration for Claude Code

This documentation covers configuring Claude Code for corporate environments with specialized network and security requirements.

## Key Configuration Areas

**Proxy Setup**: Claude Code supports standard proxy environment variables (HTTPS_PROXY, HTTP_PROXY, and NO_PROXY). The tool "does not support SOCKS proxies," and administrators can include credentials directly in proxy URLs while being warned to "avoid hardcoding passwords in scripts."

**Custom Certificate Authorities**: Organizations using proprietary CAs can configure trust through the NODE_EXTRA_CA_CERTS variable pointing to a PEM certificate file.

**mTLS Authentication**: Enterprise deployments requiring client certificate authentication use three environment variables: CLAUDE_CODE_CLIENT_CERT, CLAUDE_CODE_CLIENT_KEY, and optionally CLAUDE_CODE_CLIENT_KEY_PASSPHRASE.

**Network Allowlisting**: Four critical domains require firewall and proxy allowlisting:
- api.anthropic.com (API access)
- claude.ai (WebFetch security)
- statsig.anthropic.com (telemetry)
- sentry.io (error tracking)

All configurations can alternatively be stored in the settings.json file rather than as environment variables. The documentation recommends LLM Gateway services for proxies requiring advanced authentication methods like NTLM or Kerberos.
