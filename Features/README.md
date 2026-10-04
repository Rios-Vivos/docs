# Feature catalog and traceability

This catalog is the durable index for product features. GitHub Projects and
issues manage work; this directory records the agreed scope, rules,
dependencies, acceptance checks, and implementation status.

## How to use this catalog

- **Implemented** means the behavior is present in the owning codebase and has
  been verified against code/tests. It does not mean every future extension is
  complete.
- **Planned** means the feature has an approved or groomed requirement but no
  implementation claim is made here.
- Every feature record must link its owning issue(s), owning repositories, and
  cross-project dependencies. Update it in the same change that alters the
  contract or marks the work complete.

## Current coverage

| Area | Status | Record |
| --- | --- | --- |
| Dynamic public content and media | Implemented, coverage audit pending | [CMS](Done-Content_Management_System.md), [coverage matrix](Review-Content_Management_Coverage.md) |
| Monitoring core | Implemented with planned extensions | [Monitoring](Done-Monitoring.md), [roadmap](Review-Monitoring_Roadmap.md) |
| Station provisioning and OTA | Planned | [Station lifecycle](Review-Station_Lifecycle_and_OTA.md) |
| Donations and financial workflow | Collaboration form implemented; payments/invoices planned | [Donations](Review-Donations.md), [finance](Review-Donations_and_Finance.md) |
| Identity and user administration | Partially implemented; policy consolidation pending | [Identity and access](Review-Identity_and_Access.md) |
| Document repository and RAG | Planned | [Repository and RAG](Review-Document_Repository_and_RAG.md) |
| Public design and rebranding | Planned/review | [Design and rebranding](Review-Design_and_Rebranding.md) |
| Communications and blog | Planned | [Communications](Review-Communications.md) |
| Platform operations | Partially implemented; runbooks and target design pending | [Platform operations](Review-Platform_Operations.md) |

## Maintenance checklist

When a feature changes, update its record with the owning issue/PR, current
status, affected APIs or telemetry contracts, verification evidence, and any
new operational or rollback requirement. Do not use a closed issue alone as
proof that runtime behavior exists; check the owning repository first.
