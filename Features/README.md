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

## Implemented feature map

| Feature | Status | Canonical record |
| --- | --- | --- |
| Authentication, IAM, and user management | Implemented | [Identity and user management](Done-Authentication_IAM_and_User_Management.md) |
| Monitoring: data presentation | Implemented | [Monitoring presentation](Done-Monitoring_Data_Presentation.md) |
| Data ingress: CSV, manual, API, and MQTT | Implemented | [Monitoring data ingress](Done-Data_Ingress.md) |
| Translations | Implemented | [Translations](Done-Translations.md) |
| Content management | Implemented | [CMS](Done-Content_Management_System.md) |
| Collaboration form | Implemented | [Collaboration form](Done-Collaboration_Form.md) |
| Monitoring stations remote control | Implemented | [Remote control](Done-Monitoring_Stations_Remote_Control.md) |

## Proposed next features

These are distinct product capabilities proposed from the open task inventory.
They are not part of the implemented feature map until verified in the owning
repositories.

| Feature | Primary scope | Record |
| --- | --- | --- |
| Automated donations, invoicing, and financial administration | Payment, invoice, reconciliation, and restricted reporting lifecycle | [Donations and finance](Review-Donations_and_Finance.md) |
| Academic document repository | Authorized upload, download, metadata, filtering, and source access | [Document repository](Review-Document_Repository_and_RAG.md) |
| Self-hosted RAG for environmental documents | Internal, traceable question answering over authorized documents | [RAG technical design](Review-LLM_RAG.md) |
| Station provisioning and registration | Factory-to-operational setup, stable identity, configuration, and registration | [Station provisioning](Review-Station_Provisioning_and_Registration.md) |
| Managed OTA releases | Release integrity, staged rollout, device results, and recovery | [Managed OTA](Review-Managed_OTA_Releases.md) |
| Advanced monitoring analytics | Derived results, calibration, constants, formulas, and governed analytical views | [Advanced analytics](Review-Monitoring_Roadmap.md) |
| Community communications and blog | Submission, moderation, authorship, and publication workflow | [Communications and blog](Review-Communications.md) |

## Enhancements and enabling work

The following records improve an implemented feature or platform operation;
they are not separate product features at this time:

- Monitoring presentation enhancements: project/station filters, query UX,
  public dashboard, alerts, and Grafana view configuration.
- [CMS coverage audit](Review-Content_Management_Coverage.md)
- [Design and rebranding delivery](Review-Design_and_Rebranding.md)
- [Platform operations](Review-Platform_Operations.md)

## Maintenance checklist

When a feature changes, update its record with the owning issue/PR, affected
APIs or telemetry contracts, verification evidence, and any new operational or
rollback requirement. Do not use a closed issue alone as proof that runtime
behavior exists; check the owning repository first.
