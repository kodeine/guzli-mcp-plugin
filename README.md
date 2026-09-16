# Guzli MCP plugins

[Guzli](https://guzli.com) provides no-code AI chat and voice agents with a unified inbox. This repository packages its remote MCP connector and shared copilot guidance for Cursor and Claude Code, with connection instructions for Grok.

## Install and authenticate

### Claude Code

```sh
claude plugin marketplace add kodeine/guzli-mcp-plugin
claude plugin install guzli@guzli-plugins
```

The plugin adds one remote MCP server and three skills: `guzli-mcp-core`, `guzli-mcp-email-outreach`, and `guzli-mcp-voice-campaigns`. A Guzli account is required. OAuth sign-in completes on first use.

Guzli is not listed in the Claude connectors directory. That separate directory is not required for installation from this repository's plugin marketplace.

### Cursor and Grok

In Cursor, install **Guzli** from the Marketplace when available, or add a custom remote MCP server with URL `https://mcp.guzli.com/mcp`. The exact URL-only configuration is in [`plugins/guzli/mcp.json`](plugins/guzli/mcp.json).

In Grok, select the Guzli connector when available, or use the same URL where custom remote MCP connectors are supported. Connector availability depends on your client/account. Complete Guzli's OAuth sign-in and consent flow in either client.

The endpoint uses **streamable HTTP** and **OAuth 2.0 authorization code + PKCE**, with authorization through `https://gateway.guzli.com`. Its 401 challenge advertises `resource_metadata=https://mcp.guzli.com/.well-known/oauth-protected-resource/mcp`. No local server command or environment variables are required.

## Available operations

The service's 1.0.22 catalog captured September 15, 2026 provides **101 copilot tools**. Examples by family:

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

Use `report_issue` for product bugs. The snapshot has **96 automatic / 5 ask-first** tools. The five ask-first tools are `configure_agent_system_prompt`, `create_opportunity`, `propose_agent_configuration_change`, `propose_tool_posture_change`, and `release_managed_phone_number`. Live engine approval and authorization controls apply; automatic posture does not grant permission for unrelated actions.

See the [plugin README](plugins/guzli/README.md), [general skill](plugins/guzli/skills/guzli-mcp-core/SKILL.md), [email skill](plugins/guzli/skills/guzli-mcp-email-outreach/SKILL.md), and [voice skill](plugins/guzli/skills/guzli-mcp-voice-campaigns/SKILL.md) for workflow guidance.

## Repository and submission

This repository shares one plugin body between Cursor and Claude Code marketplace layouts:

```text
.cursor-plugin/marketplace.json
.claude-plugin/marketplace.json
plugins/guzli/.cursor-plugin/plugin.json
plugins/guzli/.claude-plugin/plugin.json
plugins/guzli/mcp.json
plugins/guzli/.mcp.json
plugins/guzli/assets/logo.svg
plugins/guzli/README.md
plugins/guzli/skills/guzli-mcp-core/SKILL.md
plugins/guzli/skills/guzli-mcp-email-outreach/SKILL.md
plugins/guzli/skills/guzli-mcp-voice-campaigns/SKILL.md
scripts/validate-template.mjs
scripts/validate-claude.sh
LICENSE
```

The marketplace registers `guzli` from `./plugins/guzli`. Plugin and marketplace version: **1.1.0**. The service catalog version is separate. The production logo is committed and referenced relative to the plugin directory. No dependencies, hooks, rules, agents, or commands are bundled.

Submit the repository URL to the Cursor team through its submission channel; this layout does not itself imply Marketplace approval or publication.

## Validation

From the repository root, with Node.js and the Claude Code CLI on `PATH`, run:

```sh
node scripts/validate-template.mjs
bash scripts/validate-claude.sh
```

The Claude gate runs `claude plugin validate --strict` on both `plugins/guzli` and the marketplace root; warnings fail the gate. The Cursor validator's missing-hooks warning is expected because this plugin has no automation hooks.

## Privacy, terms, and support

- [Privacy Policy](https://guzli.com/privacy/)
- [Terms](https://guzli.com/terms/)
- [Support](mailto:dev@guzli.com)
- Local stdio alternative: [`kodeine/guzli-cli`](https://github.com/kodeine/guzli-cli)

## License

[Apache-2.0](LICENSE).
