# [Done] Feature: Authentication, IAM, and user management

## Scope

The platform supports account registration, sign-in, password recovery,
role-based access control, and administrative user management. The API is the
authority for authentication and authorization; the admin dashboard presents
the authorized workflows.

## Implemented behavior

- Users can authenticate and recover access through the supported account flow.
- Authorized administrators can create, update, enable/disable, and manage
  roles for user accounts.
- Protected administrative/API actions use authentication and role/policy
  checks.
- Security-relevant account changes and access events are available for
  operational review.

## Rules

- UI visibility never replaces API authorization.
- Role changes, password actions, and account deactivation must preserve
  attribution and auditability.
- Deactivation revokes access without erasing historical ownership of actions.
- Public routes must not require or expose privileged credentials.

## Verification

Test successful and denied access for each protected operation, registration
and recovery failure states, and role/account changes from the admin workflow.

## Related records

- Historical detail: [IAM](Review-IAM.md) and [User Management](Review-User_Management.md).
- Future policy consolidation: [Identity and access roadmap](Review-Identity_and_Access.md).
