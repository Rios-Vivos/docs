# [Done] Feature: Collaboration form

## Scope

Visitors can submit collaboration interest for in-kind support, monetary
donation intent, volunteering, alliances, or projects. Authorized staff can
review and follow up through the administrative workflow.

## Implemented behavior

- The public form captures the supported collaboration type and contact data.
- The API validates and stores the submission.
- Authorized administrative users can consult submissions for institutional
  follow-up.

## Rules

- This is an intention/contact workflow, not an automated payment processor.
- Collect only data necessary for follow-up, protect it with authenticated
  administrative access, and keep institutional notification channels
  configurable.
- Public success/error feedback must not disclose other submissions or internal
  operational details.

## Verification

Submit each collaboration type, validate required-field failures, confirm the
record appears for an authorized administrator, and verify anonymous users
cannot list stored submissions.

## Related records

- Current and future donation scope: [Donations](Review-Donations.md).
- Future payment/invoice automation: [Donation finance](Review-Donations_and_Finance.md).
