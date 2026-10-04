# [Done] Feature: Monitoring data ingress

## Scope

Environmental data enters the platform through four supported paths: manual
administrative capture, CSV import, authenticated API integrations, and MQTT
telemetry from monitoring stations.

## Implemented behavior

- Authorized users can register supported samples manually.
- CSV imports provide a batch ingestion path with validation and traceability.
- API integrations can submit data through controlled endpoints.
- MQTT telemetry is normalized and persisted with station, parameter, time, and
  source context.

## Rules

- Every accepted measurement retains its station, parameter, timestamp, unit,
  and source/ingress path.
- Input validation rejects malformed or unauthorized data without partially
  corrupting a batch or creating duplicate records.
- MQTT payload changes are coordinated with firmware, API, and monitoring
  consumers; the message envelope remains compatible.
- Manual, CSV, API, and MQTT paths produce compatible data semantics even when
  their validation and audit details differ.

## Verification

Exercise one valid and one invalid sample through each ingress path, then
confirm the stored result is visible through the monitoring presentation flow.

## Related records

- Detailed monitoring foundation: [Monitoring](Done-Monitoring.md).
- Firmware contract: `monitoring-stations` repository documentation.
