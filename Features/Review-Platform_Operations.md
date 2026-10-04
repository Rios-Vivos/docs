# Feature: Platform operations, delivery, and secret management

**Status:** Partially implemented platform; target architecture and operational
runbooks are planned.

**Owning repositories:** `system-api`, `web-page`, root workspace.

**Source issues:** [health checks](https://github.com/Rios-Vivos/system-api/issues/3), [backup/restore](https://github.com/Rios-Vivos/system-api/issues/4), [Terraform state](https://github.com/Rios-Vivos/system-api/issues/51), [Amplify Terraform](https://github.com/Rios-Vivos/web-page/issues/95), [environment cleanup](https://github.com/Rios-Vivos/web-page/issues/112), and [secret manager](https://github.com/Rios-Vivos/web-page/issues/117).

## Required operational documentation

- Environment inventory: owner, purpose, allowed values, source of each secret,
  consumer, rotation procedure, and local-development substitute.
- Terraform state location, locking, access roles, recovery process, and change
  review requirements.
- Deployment runbook: build artifact, rollout, health checks, monitoring,
  rollback trigger, rollback steps, and responsible role.
- Backup/restore runbook: scope, encryption, retention, restore drill cadence,
  staging verification, and prohibited production commands.
- CI/CD contract: required checks, dependency/security scanning, deployment
  environments, approval gates, and incident response links.

## Rules

- Secrets never enter repositories, issue bodies, logs, generated artifacts, or
  client-side environment variables unless intentionally public.
- Production database changes use reviewed migration and backup procedures; a
  successful deploy is not proof that restore works.
- Infrastructure changes are versioned, reviewed, and applied from a known
  state; manual drift is recorded and reconciled.
