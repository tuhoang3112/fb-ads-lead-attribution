# Orchestration

The Facebook Ads pipeline runs **every day at 12:00 (noon)**. It reuses the VM and the schedule pattern of the [CRM project](https://github.com/tuhoang3112/crm-data-warehouse).

## Flow

```text
Daily, 12:00:
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

Order matters: Dataform runs **after** the Airbyte window, so the transform reads a fully loaded raw layer, and Power BI refreshes **after** Dataform.
