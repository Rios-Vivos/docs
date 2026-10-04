# [Done] Feature: Monitoring data presentation

## Scope

Operators can explore environmental monitoring data through native graphics,
station maps, queries, Grafana panels, station status views, and CSV export.
The public site may consume only the public monitoring contract; administrative
views use authenticated API and Grafana access.

## Implemented behavior

- Time-series graphics present measurements by parameter and selected period.
- A map displays stations and supports project/station filtering through station
  labels.
- Administrative users can query monitoring data, inspect configured Grafana
  panels, and export supported results as CSV.
- The operational view shows station state and supports investigation of current
  or historical monitoring information.

## Rules

- Preserve metric units, timezone handling, station identity, and the
  distinction between zero, missing, and delayed data.
- Grafana embeds use stable panel-specific URLs and must not expose credentials.
- Filters must produce consistent scope across API, graphics, map, and export.

## Verification

Check a known station/parameter across the query, chart, map, and export paths;
also test no-data, invalid-range, and unauthorized access behavior.

## Related records

- Foundation and detailed rules: [Monitoring](Done-Monitoring.md).
- Future analytical work: [Monitoring roadmap](Review-Monitoring_Roadmap.md).
