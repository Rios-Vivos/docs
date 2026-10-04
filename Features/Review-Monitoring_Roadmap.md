# Feature: Advanced monitoring analytics

**Status:** Proposed feature built on the implemented monitoring foundation.

**Owning repositories:** `system-api`, `system-admin`, `web-page`, and
`monitoring-stations` where telemetry contracts change.

**Source issues:** [Grafana database views](https://github.com/Rios-Vivos/system-api/issues/52), [formula engine](https://github.com/Rios-Vivos/system-api/issues/53), [constants](https://github.com/Rios-Vivos/system-api/issues/54), and [data normalization](https://github.com/Rios-Vivos/system-api/issues/55).

## Scope

- Versioned Grafana views backed by provisioned data sources and parameterized
  queries; browsers must not submit arbitrary SQL.
- Formal data-model work for calibration curves and derived results, including
  migration, backfill, compatibility, and rollback plans.
- A safe formula model for approved KPIs: typed inputs, units, versioning,
  bounded evaluation, and no arbitrary code or external requests.

## Rules

- Preserve raw measurements separately from derived results and document the
  source, units, station scope, and calculation version of every result.
- Mathematical constants require a stable name, value, unit, scope, validity
  period, audit history, and a migration before deletion when in use.
- Grafana, API, admin, public site, and firmware must agree on metric names,
  timezones, units, station identifiers, and missing-data semantics.

## Acceptance checks

- Each dashboard/view can be recreated from versioned configuration in a clean
  environment.
- Formula validation rejects missing variables, invalid syntax, incompatible
  units, unbounded work, and code execution.
- Derived results remain traceable to their raw measurements, formula version,
  constants, calibration inputs, and calculation scope.

## Related enhancements

Project/station filtering, query UX, alerts, public dashboards, and Grafana
embed configuration improve **Monitoring: Data Presentation**. They are tracked
as enhancements rather than separate features: [query UX](https://github.com/Rios-Vivos/system-admin/issues/36), [project scoping](https://github.com/Rios-Vivos/system-admin/issues/37), [alerts](https://github.com/Rios-Vivos/web-page/issues/84), and [public air-quality dashboard](https://github.com/Rios-Vivos/web-page/issues/136).
