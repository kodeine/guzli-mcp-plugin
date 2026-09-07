# Guzli MCP plugin for Cursor / Grok Bot

Remote [Model Context Protocol](https://modelcontextprotocol.io) connector for [Guzli](https://guzli.com) — no-code AI chat and voice agents with a unified inbox.

## MCP endpoint

- **URL:** `https://mcp.guzli.com/mcp`
- **Auth:** OAuth 2.0 via `https://gateway.guzli.com` (authorization code + PKCE)
- **Transport:** streamable HTTP

## Install

1. Install this plugin from the Cursor Marketplace / Grok Bot connectors catalog, **or** add the remote server URL above as a custom MCP connector.
2. Complete the Guzli OAuth sign-in when prompted.
3. Tools appear after auth (calls, campaigns, number pools, voices, conversations, and related Guzli operations).

## Local alternative

For a local stdio MCP (CLI + `guzli-mcp`), see [`kodeine/guzli-cli`](https://github.com/kodeine/guzli-cli).

## Privacy & terms

- [Privacy Policy](https://guzli.com/privacy/)
- [Terms](https://guzli.com/terms/)
- Support: `dev@guzli.com`

## License

Apache-2.0
