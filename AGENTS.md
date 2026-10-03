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

## Documentation workflow

1. Identify the owning implementation repository and verify the current code,
   tests, and configuration before documenting runtime behavior.
2. Choose the durable record: product scope in `SRS.md`, terminology in
   `Glossary.md`, feature-specific decisions in `Features/`, and editable
   diagrams in `plantuml/`.
3. Link to the source file or repository when a detail changes frequently,
   instead of copying a fragile implementation snapshot.
4. Review every changed relative link and ensure the wording distinguishes a
   proposal, an approved decision, and current implemented behavior.

## Change playbooks

### Document a feature or behavior change

1. Read the owning API, web, admin, or firmware implementation and its tests.
2. Update the feature record, SRS, glossary, and diagram only where each is
   affected; do not create duplicate sources of truth.
3. State user impact, rules, dependencies, and acceptance checks in language a
   developer and reviewer can act on.
4. Cross-link related pull requests, migrations, or diagrams when that context
   is necessary for safe follow-up work.

### Add or revise a migration draft

1. Compare table and column names with the active API models and services.
2. Describe preconditions, backup expectations, execution order, and
   verification/rollback steps.
3. Keep destructive statements explicit and separate from exploratory queries.
4. Do not claim a draft has been run in an environment without evidence.

## Definition of done

Documentation is ready when terminology is consistent, links work, the owning
code has been checked, and implementation-sensitive statements identify their
source. A documentation change that alters an API, telemetry, or migration
contract must be reviewed with the corresponding implementation owner.

## Related projects

- API and infrastructure: `../system-api/`.
- Admin interface: `../system-admin/`; public interface: `../web-page/`.
- Firmware telemetry contract: `../monitoring-stations/`.
