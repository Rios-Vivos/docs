# Feature: Station lifecycle, provisioning, and OTA

**Status:** Planned. Firmware capabilities exist in parts of the stack, but the
end-to-end product contract is not yet documented as implemented.

**Owning repositories:** `monitoring-stations`, `system-api`, `system-admin`.

**Source issues:** [provisioning](https://github.com/Rios-Vivos/monitoring-stations/issues/10), [station registration](https://github.com/Rios-Vivos/monitoring-stations/issues/11), [dual MQTT](https://github.com/Rios-Vivos/monitoring-stations/issues/12), [connection resilience](https://github.com/Rios-Vivos/monitoring-stations/issues/7), and [admin OTA management](https://github.com/Rios-Vivos/system-admin/issues/35).

## Goal

A new air or water station can be configured without reflashing, receives a
stable identity and operational configuration, publishes valid telemetry, and
can be safely updated or diagnosed by authorized operators.

## Required flow

1. A device starts in a configuration-safe state and lets an operator provide
   network settings without exposing secrets in UI or logs.
2. The device creates or receives a stable station code and registers once.
3. The API authorizes registration, associates the station with its monitoring
   program, and returns only the firmware configuration it may receive.
4. The device publishes the standard MQTT envelope and handles Wi-Fi, broker,
   or credential failures with a retryable diagnostic state.
5. Administrators can view station identity, health, configuration, and OTA
   release status; only authorized roles can request an update.

## Rules

- Automatic registration must be explicitly configurable and idempotent.
- Station identity, program membership, topic, metric units, and timestamps are
  cross-repository contracts; change them together.
- Wi-Fi, GSM, and offline fallback must not silently discard telemetry.
- OTA artifacts use the firmware project's `VERSION` file as their version
  source. Publishing requires explicit local credentials and target bucket.

## Acceptance checks

- A factory-reset supported device completes provisioning and publishes a valid
  payload without a firmware rebuild.
- A duplicate or unauthorized registration cannot overwrite a station.
- Loss and recovery of connectivity produce useful diagnostics and resume
  delivery without manual database repair.
- An OTA update verifies project, version, artifact, result, and rollback or
  recovery behavior before broad rollout.
