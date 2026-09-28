# Monitoring sampling-points migration

This is the one-time PostgreSQL migration for the monitoring-sampling-points
model introduced in `system-api`. It was reconciled with `system-api` `main`
at commit `080f0e7` (PR #50) on 2026-09-27.

The executable migration is
[`monitoring-sampling-points-hard-cut.sql`](monitoring-sampling-points-hard-cut.sql).
The API implementation—not this document—is the source of truth when they
disagree.

## Target contract

- `sample_catalogs` and `sampling_points` have PostgreSQL `timestamp with time
  zone` audit columns, matching `MonitoringSampleCatalog` and
  `MonitoringSamplingPoints`.
- A sample belongs to exactly one of a station or sampling point. The API
  validates that rule during ingestion; the migration adds the corresponding
  database check.
- `sample_code` remains nullable and is **not** unique. The current API model
  and ingestion flow do not require global uniqueness.
- Settings use the `settings` table. The legacy `log_settings` table remains
  available because `SettingsService` reads it once to backfill log settings,
  and the current API still declares its model.

## Preconditions

1. Take a tested backup of the target database and run this migration against
   a current staging restore first.
2. This migration is for the legacy `samples` shape that contains
   `station_code`, `station_latitude`, `station_longitude`,
   `collection_latitude`, and `collection_longitude`.
3. Every legacy manual sample must resolve to a community. The migration stops
   before dropping old columns when a row cannot be assigned to exactly one
   station or sampling point.
4. Deploy the matching `system-api` version. Production Sails configuration
   uses `migrate: safe`; it will not apply this data migration automatically.

## Runbook

```bash
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f sql/monitoring-sampling-points-hard-cut.sql
```

Run it from the `docs/` repository or supply the script’s full path. A failed
statement rolls back the transaction; still investigate the failure before
trying again.

## Post-migration checks

```sql
-- Must return 0.
SELECT COUNT(*) AS invalid_sample_owners
FROM samples
WHERE ((station_id IS NOT NULL)::int + (sampling_point_id IS NOT NULL)::int) <> 1;

-- Confirm the current API contract uses timezone-aware timestamps.
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_name IN ('sample_catalogs', 'sampling_points')
  AND column_name IN ('createdAt', 'updatedAt')
ORDER BY table_name, column_name;

-- Confirm catalog and sampling-point records were created.
SELECT
  (SELECT COUNT(*) FROM sample_catalogs) AS catalog_count,
  (SELECT COUNT(*) FROM sampling_points) AS sampling_point_count;
```

Then run the API monitoring integration tests and manually verify a station
sample and a form-upload sampling-point sample.
