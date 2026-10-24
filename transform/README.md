# Transform (Dataform)

> **Draft.** These models were written from the two blog posts and compile with the Dataform CLI (`dataform compile`), but have **not been run on BigQuery** and are meant to be aligned with the production code.

Dataform builds **6 staging views → 9 mart tables**, plus 2 custom assertions and key assertions on every mart.

```text
declarations (raw)            staging (views)            marts (tables)
─────────────────             ───────────────            ──────────────
campaigns          ─────────► stg_campaign   ─────────► dim_campaign
ad_sets            ─────────► stg_ad_set     ─────────► dim_ad_set
ads                ─────────► stg_ad         ─┐
ad_creatives       ─────────► stg_ad_creative ┴────────► dim_ad
ads_insights       ─────────► stg_ads_insights ───────► fact_ad_insights_daily, dim_account
course (Sheet)     ────────────────────────────────────► dim_course
CRM fact_deal      ─────────► stg_lead ───────────────► fact_lead_attribution → fact_lead → fact_ad_lead_daily
CRM dim_stage      ─────────►
```

## Staging

| Model | What it does |
|---|---|
| `stg_campaign` | Latest version per ID. Detects `CBO` vs `ABO` budget |
| `stg_ad_set` | Flattens the `targeting` JSON: age range, locations, placements, devices, interests, custom audiences. **Every list is joined, never "first element only"** (an earlier version lost data this way) |
| `stg_ad` | Latest version per ID. Extracts `creative_id` |
| `stg_ad_creative` | Recovers `cta_link` through 5 fallbacks and extracts the UTM. See [data quality](../docs/data-quality.md) |
| `stg_ads_insights` | One row per ad per day. Flattens the `actions` array into columns |
| `stg_lead` | CRM leads of the Sales pipelines with a normalised UTM key |

## Marts

See the [data dictionary](../docs/data-dictionary.md). Matching rules: [data quality](../docs/data-quality.md#4-matching-leads-to-ads).

## Things to check before the first real run

- `workflow_settings.yaml`: replace `defaultProject` and check the datasets.
- Declarations point to the raw dataset `dw_facebook_ads` (Airbyte destination) and to the CRM mart `dm_rework_crm`.
- The `action_type` names in `includes/fb.js` and `stg_ads_insights` (the messaging one carries an attribution-window suffix).
- `stg_lead` assumes the CRM columns `utm_product` (campaign-level UTM), `utm_source`, `utm_medium`, `utm_content` and pipeline IDs `2042` and `2754`.
- Time zone: leads are converted to `Asia/Ho_Chi_Minh`.

## Local check

```bash
cd transform
npx @dataform/cli@3.0.52 compile
```
