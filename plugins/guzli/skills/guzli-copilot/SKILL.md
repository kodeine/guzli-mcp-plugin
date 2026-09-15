---
name: guzli-copilot
description: Use Guzli MCP tools for contacts, campaigns, customer conversations, knowledge, and managed phone numbers when the user requests Guzli operations.
---

# Guzli copilot

Use the authenticated Guzli MCP connection. Discover live tool schemas before supplying arguments; this guidance describes the 1.0.22 catalog captured September 15, 2026, not a fixed runtime contract.

## Choose a family

- Contacts and lifecycle: `find_contacts`, `lookup_contact`, `set_contact_lifecycle_stage`.
- Tags and permissions: `browse_tags`, `mutate_contact_tag`, `list_contact_permission_heads`.
- Segments: `preview_segment`, `materialize_segment`, `get_segment_readiness`.
- Email campaigns: `create_email_campaign`, `update_campaign_draft_step`, `publish_email_campaign`.
- Voice campaigns: `create_voice_campaign`, `publish_voice_campaign`, `run_voice_campaign`.
- Campaign monitoring: `get_campaign`, `campaign_measurement`, `pause_campaign_now`.
- Direct outreach: `send_email`, `send_sms`, `call_contact_now`.
- Calls and voice configuration: `list_calls`, `get_call`, `list_voice_profiles`.
- Phone inventory: `search_managed_phone_numbers`, `buy_managed_phone_number`, `list_owned_phone_numbers`.
- Conversations: `list_customer_conversations`, `read_conversation`, `read_conversation_summary`.
- Knowledge: `knowledge_search`, `knowledge-ingest_url`, `check_ingestion_status`.
- Configuration: `get_agent_tool_configuration`, `propose_agent_configuration_change`, `propose_tool_posture_change`.
- Opportunities: `list_opportunities`, `create_opportunity`.
- Recurring duties: `list_standing_items`, `propose_standing_item_create`, `propose_standing_item_pause`.
- Memory: `memory_list`, `memory_save`, `memory_forget`.
- Web and integrations: `web_search`, `web_fetch`, `create_webhook_integration`.

## Email campaign flow

1. Resolve the requested audience, sender, content, schedule, and policy. Create the draft with `create_email_campaign`.
2. Use returned identifiers and the expected lock version with `update_campaign_draft_step`. Editing never publishes.
3. When the user authorizes publication, use `publish_email_campaign`. The daily channel-unit cap must be set; report readiness or remediation returned by the engine rather than assuming success.
4. Use `enroll_campaign_contacts` only for an active, published campaign. Use `run_email_campaign` when the requested workflow requires queuing a published revision. Do not enroll or run again merely because delivery is pending.
5. Read `get_campaign_enrollment_summary` or `campaign_measurement` for results. Queued is not delivered.

## Managed phone number flow

1. Search eligible inventory with `search_managed_phone_numbers` using the user's requirements.
2. Present the selected number and returned purchase details. Purchase only within the user's explicit spending authorization with `buy_managed_phone_number`.
3. Verify inventory with `list_owned_phone_numbers`. An ambiguous purchase response is not a reason to purchase another number; inspect state and stop if the outcome cannot be established.
4. Releasing a number uses `release_managed_phone_number` and the engine approval flow.

## Conversations and issues

Start conversation catch-up with `list_customer_conversations`; read a selected transcript with `read_conversation` only when needed. The list returns a digest, not transcripts.

For a requested product bug report, use `report_issue` with relevant observed behavior and reproduction context allowed by its live schema. Exclude credentials and unnecessary customer data. Report the returned result; do not repeatedly submit the same issue after an ambiguous response.

## Authorization and posture

Default copilot scopes are `guzli:copilot:read` and `guzli:copilot:act`. Tenant-operations scopes `guzli:read` / `guzli:write` are separate and available on request; do not assume they are granted.

The snapshot's five ask-first tools are `configure_agent_system_prompt`, `create_opportunity`, `propose_agent_configuration_change`, `propose_tool_posture_change`, and `release_managed_phone_number`. Respect live engine holds and decisions. For an authorized posture-change request, invoke the proposal tool so the engine can present its approval card; chat permission does not replace that approval.

Automatic posture is not permission to expand the user's request. Stop on denial or unresolved approval, and never route through another tool to bypass a hold. Contact capture alone is not commercial intent: `create_opportunity` requires the structured origin event described by its schema.
