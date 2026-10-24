# Orchestration

The Facebook Ads pipeline reuses the VM and the schedule pattern of the CRM project. The VM setup is described in [Build Data Systems from Scratch #01](https://zoedatalens.substack.com/p/schedule-pipeline).

## Flow

```text
Daily:
Cloud Scheduler → start VM
systemd         → Airbyte starts on boot
Airbyte         → scheduled sync (Facebook Marketing) → BigQuery raw
Cloud Scheduler → stop VM
Dataform        → "production" release: staging → marts
Power BI        → scheduled refresh, after Dataform finishes
```

| Step | Tool | Where it is set up |
|---|---|---|
| VM on/off | Cloud Scheduler | Cloud Scheduler console |
| Extract & load | Airbyte connection schedule | Airbyte UI → Connection → Settings |
| Transform | Dataform release `production` on branch `main` + scheduled workflow | BigQuery → Dataform |
| BI refresh | Power BI Service | Power BI Service |

Order matters: Dataform runs **after** the Airbyte window, and it must also run **after the CRM pipeline**, because `fact_lead` reads the CRM mart (`dm_rework_crm`).

> **TODO:** the exact run times for this pipeline are not written down yet. Add them once the schedule is fixed.
