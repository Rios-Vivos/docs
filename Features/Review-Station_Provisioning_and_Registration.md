# Feature: Station provisioning and registration

**Status:** Proposed feature.

**Owning repositories:** `monitoring-stations`, `system-api`, `system-admin`.

**Source issues:** [plug-and-play provisioning](https://github.com/Rios-Vivos/monitoring-stations/issues/10), [station registration](https://github.com/Rios-Vivos/monitoring-stations/issues/11), [dual MQTT delivery](https://github.com/Rios-Vivos/monitoring-stations/issues/12), and [connection resilience](https://github.com/Rios-Vivos/monitoring-stations/issues/7).

## Goal

A supported air or water station moves from factory state to valid telemetry
without reflashing or manual database creation. It receives a stable identity,
network configuration, authorized operational configuration, and an observable
recovery path when connectivity fails.

## Required flow

1. A new device exposes a configuration-safe network setup flow without showing
   credentials in UI or logs.
2. It creates or receives a stable station code and submits an idempotent
   registration request.
3. The API authorizes the device, associates it with a monitoring program, and
   returns only the configuration the device may receive.
4. The station publishes compatible telemetry and diagnostic envelopes through
   supported MQTT delivery paths.
5. Operators can see identity, assignment, configuration state, and a useful
   reason when provisioning or reconnection fails.

## Rules

- Automatic registration is explicit, idempotent, and never lets an
  unauthorized device overwrite another station.
- Identity, program membership, topic, units, timestamps, and supported MQTT
  delivery behavior are cross-repository contracts.
- Wi-Fi, GSM, and offline fallback preserve diagnostics and must not silently
  discard telemetry.

## Acceptance checks

- A factory-reset supported device completes setup and publishes valid
  telemetry without a firmware rebuild.
- Duplicate, unauthorized, and incomplete registration attempts are safe.
- A network or broker failure is diagnosable and recovery resumes delivery
  without manual database repair.
