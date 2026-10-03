# Documentation contributor guide

## Purpose and orientation

This repository records requirements, architecture decisions, feature scope,
diagrams, and migration drafts. It does not override runtime behavior: compare
the active `../system-api/` code before documenting implementation details.

Start with `SRS.md`, `Glossary.md`, `Features/`, and `plantuml/`. Migration
drafts live in `sql/` and must be coordinated with `system-api`.

## Change rules

- Keep requirements, decisions, diagrams, and terminology internally
  consistent; update linked records when behavior changes affect them.
- Describe decisions and rationale without duplicating volatile code details.
- Use API routes, models, services, and tests as the source of truth for
  runtime behavior and data contracts.
- Treat SQL as reviewed migration drafts. Never present destructive SQL as safe
  without a current staging backup and explicit execution plan.
- Preserve file organization and links. Never add credentials, customer data,
  exports, generated binaries, or environment files.

## Related projects

- API and infrastructure: `../system-api/`.
- Admin interface: `../system-admin/`; public interface: `../web-page/`.
- Firmware telemetry contract: `../monitoring-stations/`.
