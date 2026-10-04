# Feature: Identity, access, and audit policy

**Status:** Partially implemented; IAM and user-management records require one
canonical policy and role matrix.

**Owning repositories:** `system-api`, `system-admin`, `web-page` for public
versus protected-route boundaries.

**Related records:** [IAM](Review-IAM.md) and [User Management](Review-User_Management.md).

## Canonical policy requirements

- Define roles, permitted modules/actions, data scopes, and who can grant or
  revoke each role. Resolve terminology differences such as General, Staff,
  Admin, Operator, and Superadmin in one matrix.
- Define account creation, invitation, activation, disablement, password reset,
  session duration, cookie/token handling, and emergency access procedures.
- Define security audit events: successful/failed login, reset request/use,
  role change, account status change, privileged configuration change, and
  access-denied event where appropriate.

## Rules

- API policies enforce permissions; UI guards only improve user experience.
- Privilege escalation, self-assignment of higher roles, and user deletion have
  explicit authorization and audit requirements.
- Deactivation preserves historical attribution and safely revokes sessions.
- Public monitoring and content endpoints are documented separately from admin
  authorization; no client receives a privileged token for convenience.

## Acceptance checks

- Every admin route and API capability maps to a role/policy decision.
- Tests cover permitted and denied access for sensitive actions.
- Audit records let an operator determine who changed a role or critical
configuration and when.
