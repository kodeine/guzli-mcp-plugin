# Email campaign checklist

Replace angle-bracket placeholders with verified facts.
Numeric examples are illustrative: use the authorized cap and latest lock value.

## Prepare and create

- [ ] Resolve contacts with `guzli:find_contacts` and `guzli:lookup_contact`.
  Confirm the agent, audience, sender, purpose, postal address and cap with the
  user. Do not infer the agent from an unrelated campaign.
- [ ] Capture send authorization and complete the permission checklist linked
  from SKILL.md. For required permission, re-check every recipient before enroll.
- [ ] Create the draft with `guzli:create_email_campaign`:

```json
{
  "name":"Requested follow-up", "agent_id":"<agent UUID>",
  "audience_policy":{"kind":"explicit"},
  "subject":"Your requested information", "body_text":"Here is your follow-up.",
  "body_html":"<p>Here is your follow-up.</p>",
  "tenant_postal_address":"<confirmed mailing address>", "purpose":"transactional",
  "permission_requirement":"required", "unsubscribe_requirement":"required",
  "admission_policy":{"subject_key":"organization","effect_key":"email.send:follow-up"},
  "cap_policy":{"maximum_daily_channel_units":50,"maximum_enrollments":50}
}
```

- [ ] Keep campaign_id, revision_id and lock_version. Read the draft with
  `guzli:get_campaign_revision` using campaign_id and revision_id. Verify its
  audience, plain text, HTML, purpose and policies before publish.

The sample selects permission and unsubscribe requirements explicitly; it does
not describe a server default. Use the user's authorized policy, never a weaker
policy to bypass a failure. Purpose is marketing or transactional. Preserve
independent body_text when supplying body_html; author HTML inside the body_html argument.

An attributed reply to a campaign email automatically unenrolls its source
enrollment and pauses other marketing automation for that contact on the email
channel pending disposition. There is no `stop_on_reply` flag.
`continuation_policy` (`advance_on_success` or `stop_on_failure`) governs step
failure, not replies.

Revisions support duration and fact-deadline waits and branch steps. The
compact `guzli:add_campaign_draft_email_step` and
`guzli:add_campaign_draft_wait_step` tools author email steps and duration
waits only; there is no compact add-branch tool. Author fact-deadline waits
and branches through the full draft revision update.

### Day 1, 3, 7 and 20 sequence

Use verified content, sender, audience, permission and postal address. The
first send is created by `guzli:create_email_campaign`; each wait starts after
the previous send. Read back the draft and use the latest returned
`expected_lock_version` for each next call. Replace each placeholder with the
returned identifier or current lock value. The attributed-reply stop is automatic.

```text
1. guzli:create_email_campaign
   {"name":"Requested follow-up","agent_id":"<agent UUID>","audience_policy":{"kind":"explicit"},"subject":"Day 1 update","body_text":"<confirmed Day 1 text>","tenant_postal_address":"<confirmed mailing address>","purpose":"marketing","permission_requirement":"required","unsubscribe_requirement":"required","admission_policy":{"subject_key":"contact","effect_key":"campaign.followup"},"cap_policy":{"maximum_daily_channel_units":40}}
2. guzli:add_campaign_draft_wait_step
   {"campaign_id":"<campaign UUID>","revision_id":"<draft UUID>","expected_lock_version":1,"position":{"index":1},"semantic_key":"wait_to_day_3","duration_seconds":172800}
3. guzli:add_campaign_draft_email_step
   {"campaign_id":"<campaign UUID>","revision_id":"<draft UUID>","expected_lock_version":2,"position":{"index":2},"semantic_key":"day_3_email","purpose":"marketing","subject":"Day 3 update","body_text":"<confirmed Day 3 text>","tenant_postal_address":"<confirmed mailing address>"}
4. guzli:add_campaign_draft_wait_step
   {"campaign_id":"<campaign UUID>","revision_id":"<draft UUID>","expected_lock_version":3,"position":{"index":3},"semantic_key":"wait_to_day_7","duration_seconds":345600}
5. guzli:add_campaign_draft_email_step
   {"campaign_id":"<campaign UUID>","revision_id":"<draft UUID>","expected_lock_version":4,"position":{"index":4},"semantic_key":"day_7_email","purpose":"marketing","subject":"Day 7 update","body_text":"<confirmed Day 7 text>","tenant_postal_address":"<confirmed mailing address>"}
6. guzli:add_campaign_draft_wait_step
   {"campaign_id":"<campaign UUID>","revision_id":"<draft UUID>","expected_lock_version":5,"position":{"index":5},"semantic_key":"wait_to_day_20","duration_seconds":1123200}
7. guzli:add_campaign_draft_email_step
   {"campaign_id":"<campaign UUID>","revision_id":"<draft UUID>","expected_lock_version":6,"position":{"index":6},"semantic_key":"day_20_email","purpose":"marketing","subject":"Day 20 update","body_text":"<confirmed Day 20 text>","tenant_postal_address":"<confirmed mailing address>"}
8. guzli:publish_email_campaign
   {"campaign_id":"<campaign UUID>","revision_id":"<draft UUID>","expected_lock_version":7}
9. guzli:enroll_campaign_contacts
   {"campaign_id":"<campaign UUID>","contact_ids":["<authorized contact UUID>"],"requested_at":"<current ISO timestamp>"}
```

The lock values above illustrate successive edits; use each actual returned
lock value. Publish only after the readiness and authorization checks below,
then verify enrollment and run as directed there.

## Edit a draft without publishing

- [ ] Read the draft with `guzli:get_campaign_revision`; use its step_id and lock.
- [ ] Call `guzli:update_campaign_draft_step` with only the requested changes in its patch argument:

```json
{"campaign_id":"<campaign UUID>","revision_id":"<draft UUID>","step_id":"<draft step UUID>","expected_lock_version":1,"patch":{"subject":"Updated follow-up","body_text":"Updated information.","body_html":"<p>Updated information.</p>"}}
```

- [ ] Re-read and verify the saved draft. On a stale lock or uncertain response,
  re-read, reconcile the requested edit with the saved state, then retry only
  the remaining change using the latest lock. Editing does not publish.

## Readiness, publish, enroll, run

- [ ] Check the saved draft against the confirmed audience, content and cap.
- [ ] When publication is authorized, call `guzli:publish_email_campaign`:

```json
{"campaign_id":"<campaign UUID>","revision_id":"<draft UUID>","expected_lock_version":1}
```

- [ ] Establish readiness only from the publish workflow's result. Fix the
  failures it reports, re-read saved state with `guzli:get_campaign_revision`,
  then publish again with the latest lock. For an uncertain result, resolve saved
  state before retrying; stop if unresolved. Proceed only after readiness passes
  and publication is confirmed. A hold remains pending; do not poll for approval.
- [ ] For an explicit audience, use `guzli:enroll_campaign_contacts`:

```json
{"campaign_id":"<campaign UUID>","contact_ids":["<authorized contact UUID>"],"requested_at":"<current ISO timestamp>"}
```

- [ ] Verify accepted enrollments with `guzli:get_campaign_enrollment_summary`.
  Resolve discrepancies before run. For a segment audience, skip explicit enroll;
  inspect automation's enrollment results instead.
- [ ] Run only the authorized enrollments with `guzli:run_email_campaign`:

```json
{"campaign_id":"<campaign UUID>","revision_id":"<published UUID>","enrollment_ids":["<accepted enrollment UUID>"]}
```

- [ ] Use all_active:true instead of enrollment_ids only when the user authorizes
  all active enrollments; never supply both. Inspect accepted_enrollment_ids and
  status. Queued is not delivered; read campaign results rather than run again.
