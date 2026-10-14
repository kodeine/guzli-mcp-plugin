# Shared operations

Read the exposed schema before supplying arguments to the Guzli tools.

## Contacts and tags

- [ ] Use `guzli:find_contacts` and `guzli:lookup_contact` to resolve an existing
  contact before creating one. Confirm ambiguous matches with the user.
- [ ] Use `guzli:create_contact` only for supplied facts; supply source_reason_code.
  For changes, use `guzli:update_contact` with contact_id and reason_code.
- [ ] Keep custom_attributes scalar. Inspect existing fields through
  `guzli:search_contacts` and `guzli:get_segment_field_catalog` before reuse.
- [ ] Read back the contact; correct rejected fields and verify again.
- [ ] For tags, inspect `guzli:browse_tags`, use `guzli:add_tag` for a missing
  definition or `guzli:edit_tag` for a requested definition change, then use
  `guzli:mutate_contact_tag` for the requested contact association.
- [ ] Re-read the tag and contact facts to verify the association or change.

Do not invent an email address, phone number or permission basis. For lifecycle
changes, inspect `guzli:list_lifecycle_stages` and the contact's
`guzli:get_contact_lifecycle_stage` before `guzli:set_contact_lifecycle_stage`;
re-read to verify the requested transition.


`guzli:create_contact` and `guzli:update_contact` define a previously unknown
custom attribute on first use of a valid, non-null scalar value; no separate
attribute-definition call is needed. The key must match `[a-z][a-z0-9_]{0,63}`.
The value infers the tenant schema type: boolean, number, valid `YYYY-MM-DD`
date, or otherwise text. Objects and arrays are refused. Existing schema types
are retained, with coercion; incompatible values and archived attributes are
refused. Per-key null never defines an attribute; for an existing attribute it
retracts the value. Supply only authorized contact facts.

`guzli:search_contacts` filters use existing visible schema names and refuse
unknown names with `attribute_unknown` before searching; search never defines
attributes. In `guzli:get_segment_field_catalog`, match that name against
`attribute_name`, then copy the returned `field_key` and allowed operators into
the segment predicate. The key remains `contact.custom_attribute.<schema_id.hex>`;
the schema name is metadata, not an alternate field key.

## Segments

- [ ] Read `guzli:get_segment_field_catalog` for field keys and allowed operators.
- [ ] Define the requested audience and preview it with `guzli:preview_segment`.
  Inspect matches; correct the expression and preview again before creating it.
- [ ] Use `guzli:create_segment` with the authorized expression. Each predicate
  carries a generated predicate_id; do not invent field keys or operators.
- [ ] Materialize the selected version with `guzli:materialize_segment`.
- [ ] Check `guzli:get_segment_readiness` and `guzli:list_segment_members`.
  Resolve failures and re-check before using the segment in a campaign.

Keep segment_id, segment_version_id and the materialization identifier distinct.
Reuse a matching segment rather than creating a duplicate for every contact list.

## Knowledge

- [ ] Confirm the agent and source. For a supplied URL, use
  `guzli:knowledge-ingest_url` with this argument shape after substituting facts:

```json
{"agent_id":"<agent UUID>","source":{"crawl_type":"single","urls":["<authorized absolute URL>"]}}
```

- [ ] Retain the task_id and use `guzli:check_ingestion_status` for that task,
  supplying the arguments in its exposed schema. Acceptance is not completion.
- [ ] On failure, inspect the returned error, correct its cause, and check state
  before submitting another ingestion. Do not broaden to a website crawl unasked.
- [ ] Once complete, use `guzli:knowledge_search` for a source-specific question;
  verify that the returned evidence supports the expected answer.

For a non-URL source, select the matching ingestion tool from the exposed schema
instead; preserve the same status and retrieval checks.

## Configuration and integrations

- [ ] Inspect `guzli:get_agent_tool_configuration` for a tool configuration request.
- [ ] For a system-prompt replacement, confirm the full requested text and agent;
  use `guzli:configure_agent_system_prompt` with agent_id and system_prompt.
- [ ] Follow its ask-first engine approval flow. A hold is not a saved change;
  verify the engine result before reporting completion.
- [ ] For an explicitly requested webhook, read `guzli:list_webhook_events`,
  confirm the destination and selected events, and inspect the schema of
  `guzli:create_webhook_integration` before creating it.
- [ ] Verify the returned integration details against the requested destination
  and events. Do not create another integration after an uncertain response.

## Conversations and issues

- [ ] Start catch-up with `guzli:list_customer_conversations`; select the relevant
  conversation before reading its messages or summary with the tools below.
- [ ] For an authorized bug report, collect observed behavior, expected behavior
  and reproduction context; exclude credentials and unnecessary contact data.
- [ ] Submit once through `guzli:report_issue` using its exposed schema.
- [ ] Report the returned outcome. If uncertain, investigate that submission;
  do not create duplicate reports to obtain a successful response.

| Read | Tool |
| --- | --- |
| Conversation messages | `guzli:read_conversation` |
| Conversation summary | `guzli:read_conversation_summary` |
