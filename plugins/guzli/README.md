# Guzli

Remote [Model Context Protocol](https://modelcontextprotocol.io) connector for [Guzli](https://guzli.com) — no-code AI chat and voice agents with a unified inbox.

## MCP endpoint

- **URL:** `https://mcp.guzli.com/mcp`
- **Auth:** OAuth 2.0 via `https://gateway.guzli.com` (authorization code + PKCE)
- **Transport:** streamable HTTP

## Install

### Claude Code

```sh
claude plugin marketplace add kodeine/guzli-mcp-plugin
claude plugin install guzli@guzli-plugins
```

The plugin adds one remote MCP server and three skills: `guzli-mcp-core`, `guzli-mcp-email-outreach`, and `guzli-mcp-voice-campaigns`. A Guzli account is required. On first use, complete Guzli's OAuth sign-in and consent for `guzli:copilot:read` and `guzli:copilot:act`.

Guzli is not listed in the Claude connectors directory. That separate directory is not required for installation from this repository's plugin marketplace.

### Cursor and Grok

1. In Cursor, install **Guzli** from the Marketplace when available, or add the remote server URL above as a custom MCP connector. In Grok, select the Guzli connector when available, or add the same URL where custom remote MCP connectors are supported. Availability depends on your client/account.
2. Complete the Guzli OAuth sign-in when prompted.
3. Tools appear after authentication and consent. No local command, environment variables, or API key are configured by this plugin.

The endpoint's unauthenticated 401 challenge advertises `resource_metadata=https://mcp.guzli.com/.well-known/oauth-protected-resource/mcp`.

For Cursor custom MCP configuration:

```json
{
  "mcpServers": {
    "guzli": {
      "url": "https://mcp.guzli.com/mcp"
    }
  }
}
```

## Copilot catalog

The released 1.0.22 catalog captured September 15, 2026 contains **101 copilot tools** using default scopes `guzli:copilot:read` and `guzli:copilot:act`. Plugin version 1.1.0 is independent of the service release. Representative families:

| Family | Example tools |
| --- | --- |
| Contacts and lifecycle | `find_contacts`, `create_contact`, `set_contact_lifecycle_stage` |
| Tags and permissions | `browse_tags`, `mutate_contact_tag`, `capture_operator_permission` |
| Segments | `preview_segment`, `materialize_segment`, `list_segment_members` |
| Email campaigns | `create_email_campaign`, `update_campaign_draft_step`, `enroll_campaign_contacts` |
| Voice campaigns | `create_voice_campaign`, `publish_voice_campaign`, `run_voice_campaign` |
| Campaign monitoring | `campaign_measurement`, `get_campaign`, `pause_campaign_now` |
| Direct outreach | `send_email`, `send_sms`, `call_contact_now` |
| Calls and voices | `list_calls`, `get_call`, `list_voice_profiles` |
| Managed numbers | `search_managed_phone_numbers`, `buy_managed_phone_number`, `list_owned_phone_numbers` |
| Conversations | `list_customer_conversations`, `read_conversation`, `conversation_metrics` |
| Knowledge | `knowledge_search`, `knowledge-ingest_url`, `list_knowledge_issues` |
| Agent configuration | `get_agent_tool_configuration`, `configure_agent_system_prompt`, `propose_agent_configuration_change` |
| Opportunities | `list_opportunities`, `create_opportunity` |
| Recurring duties | `list_standing_items`, `propose_standing_item_create`, `propose_standing_item_pause` |
| Memory | `memory_list`, `memory_save`, `memory_forget` |
| Web and integrations | `web_search`, `web_fetch`, `create_webhook_integration` |

Use `report_issue` for product bugs. The snapshot has **96 automatic / 5 ask-first** tools. The five ask-first tools are:

- `configure_agent_system_prompt`
- `create_opportunity`
- `propose_agent_configuration_change`
- `propose_tool_posture_change`
- `release_managed_phone_number`

Ask-first calls use the engine's approval flow. Automatic posture is not blanket permission for unrelated actions; live authorization, policy, and tool schemas still govern each call.

The separate **tenant-operations** catalog offers **130 REST-projected tools** with `guzli:read` / `guzli:write` scopes on request. The separate **webchat** catalog has **9 tools**; neither count is added to the default copilot catalog.

## Included skills

- [`guzli-mcp-core`](skills/guzli-mcp-core/SKILL.md): shared discovery, contacts, tags, knowledge, managed numbers, configuration and issue reports.
- [`guzli-mcp-email-outreach`](skills/guzli-mcp-email-outreach/SKILL.md): one-off email and permission, draft, publish, enroll and run workflows.
- [`guzli-mcp-voice-campaigns`](skills/guzli-mcp-voice-campaigns/SKILL.md): one-off calls, voice campaigns and structured answers.

Each skill includes its own references. They add guidance only, with no hooks or background automation.

## Local alternative

For a local stdio MCP (CLI + `guzli-mcp`), see [`kodeine/guzli-cli`](https://github.com/kodeine/guzli-cli).

## Validation

From the repository root, with Node.js and the Claude Code CLI on `PATH`, run:

```sh
node scripts/validate-template.mjs
bash scripts/validate-claude.sh
```

The Claude gate validates both this plugin and the marketplace root with `--strict` (warnings fail). The Cursor validator's missing-hooks warning is expected because no hooks are bundled.

## Privacy & terms

- [Privacy Policy](https://guzli.com/privacy/)
- [Terms](https://guzli.com/terms/)
- [Support](mailto:dev@guzli.com)

## License

Apache-2.0. See the repository [LICENSE](../../LICENSE).
