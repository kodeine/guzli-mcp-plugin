# Email monitoring and personalization

Read the Guzli tools' exposed argument schemas.

| Need | Tool |
| --- | --- |
| Campaign inventory and state | `guzli:list_campaigns`, `guzli:get_campaign` |
| Enrollment details | `guzli:list_campaign_enrollments`, `guzli:get_campaign_enrollment_summary` |
| Measurement | `guzli:campaign_measurement` |
| Pause or resume | `guzli:pause_campaign_now`, `guzli:resume_campaign_now` |
| Replies | `guzli:list_customer_conversations`, `guzli:read_conversation` |
| Contact fields | `guzli:update_contact`, `guzli:search_contacts`, `guzli:get_segment_field_catalog` |

## Monitor or pause

- [ ] Resolve the campaign and read `guzli:get_campaign` plus
  `guzli:get_campaign_enrollment_summary` and `guzli:campaign_measurement`.
- [ ] Distinguish accepted enrollment, queued dispatch, held work and completed
  results. Report the returned facts; do not infer delivery from a queue result.
- [ ] For an authorized pause or resume, use `guzli:pause_campaign_now` or
  `guzli:resume_campaign_now`, respectively, with the exposed argument shape.
- [ ] Re-read campaign state. Resolve a refusal or uncertain response before
  repeating the mutation; do not resume an approval-held send through another tool.

## Per-contact content

- [ ] Inspect `guzli:search_contacts` and `guzli:get_segment_field_catalog` for
  existing attribute definitions. Use scalar custom_attributes for per-contact
  text and `guzli:update_contact` with contact_id and reason_code.
- [ ] Read back the values before enrollment. Keep markup in body_html, not in
  contact attributes intended as plain text.
- [ ] Use only merge fields supported by the exposed campaign schema. Confirm
  personalized content before publish and enrollment; do not assume later
  contact edits update content already attached to an enrollment.


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

## Replies

- [ ] Use `guzli:list_customer_conversations` to locate relevant conversations.
- [ ] Read the selected conversation with the tool below and report
  the actual reply. Do not infer a reply from campaign enrollment state.

| Read | Tool |
| --- | --- |
| Conversation messages | `guzli:read_conversation` |
