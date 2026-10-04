# Feature: Managed OTA releases

**Status:** Proposed feature.

**Owning repositories:** `monitoring-stations`, `system-admin`, `system-api`.

**Source issue:** [managed OTA updates](https://github.com/Rios-Vivos/system-admin/issues/35).

## Goal

Authorized station managers can create, target, monitor, and recover firmware
releases without treating a successful artifact upload as proof of a successful
device update.

## Scope

- The sole release version source is `projects/<project>/VERSION` in the
  firmware repository.
- A release has project compatibility, manifest/artifact integrity, target
  station/group, rollout stage, and publish audit information.
- Devices report previous version, target version, verification result, and
  failure reason through the supported monitoring contract.
- Rollouts support a pilot group before broader deployment and retain a
  recovery/rollback plan for a failed update.

## Rules

- Only an authorized station-manager role can publish or target a release.
- Devices install only compatible, newer, integrity-verified artifacts.
- Credentials, artifact storage details, and device secrets never appear in the
  admin UI, client bundle, or telemetry logs.
- A failed update must preserve a bootable firmware path or present an explicit
  field-recovery procedure.

## Acceptance checks

- A pilot station verifies the artifact before activation and reports outcome.
- An incompatible, tampered, or older release is rejected.
- Operators can see rollout state by station/group and safely stop a rollout.
- Recovery behavior is tested before a broad production deployment.
