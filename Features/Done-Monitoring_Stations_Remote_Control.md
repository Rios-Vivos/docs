# [Done] Feature: Monitoring stations remote control

## Scope

Operators can inspect and manage supported remote station behavior through the
monitoring administration workflow and the station's MQTT/diagnostic contract.

## Implemented behavior

- Station records, operational state, and monitoring configuration can be
  managed through the platform.
- Operators can use the supported MQTT test/diagnostic flow to validate broker
  connectivity and telemetry handling.
- Firmware reports trusted telemetry, status snapshots, and error-log data that
  can be used for remote operational support.

## Rules

- Only authorized users may issue administrative control or diagnostic actions.
- Commands use the established MQTT envelope and topic conventions; never place
  credentials or private configuration in payloads or UI logs.
- Remote control must preserve firmware fallback behavior and cannot assume a
  device is online.

## Verification

Use a known station or controlled test device to verify authentication, command
publication, status/error-log receipt, offline handling, and audit visibility.

## Boundary

This record covers currently supported remote operation. Factory provisioning,
automatic registration, and managed release workflows remain proposed in
[Station provisioning](Review-Station_Provisioning_and_Registration.md) and
[Managed OTA releases](Review-Managed_OTA_Releases.md).
