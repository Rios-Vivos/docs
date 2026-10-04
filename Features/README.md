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
| RAG | Implemented | [RAG](Review-LLM_RAG.md) |
| Translations | Implemented | [Translations](Done-Translations.md) |
| Content management | Implemented | [CMS](Done-Content_Management_System.md) |
| Collaboration form | Implemented | [Collaboration form](Done-Collaboration_Form.md) |
| Monitoring stations remote control | Implemented | [Remote control](Done-Monitoring_Stations_Remote_Control.md) |

## Roadmap and proposals

The following records describe work that is planned, exploratory, or needs a
separate completion review. They are not part of the implemented feature map:

- [Station lifecycle and OTA](Review-Station_Lifecycle_and_OTA.md)
- [Monitoring analytical roadmap](Review-Monitoring_Roadmap.md)
- [Document repository](Review-Document_Repository_and_RAG.md)
- [Donation finance automation](Review-Donations_and_Finance.md)
- [CMS coverage audit](Review-Content_Management_Coverage.md)
- [Design and rebranding delivery](Review-Design_and_Rebranding.md)
- [Communications and blog](Review-Communications.md)
- [Platform operations](Review-Platform_Operations.md)

## Maintenance checklist

When a feature changes, update its record with the owning issue/PR, affected
APIs or telemetry contracts, verification evidence, and any new operational or
rollback requirement. Do not use a closed issue alone as proof that runtime
behavior exists; check the owning repository first.
