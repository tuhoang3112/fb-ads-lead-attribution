# Transform (Dataform)

Dataform builds **5 staging views → 5 mart tables** on top of the raw Airbyte tables.

```text
declarations (raw)         staging (views)             marts (tables)
──────────────────         ───────────────             ──────────────
campaigns       ─────────► stg_campaigns   ──┬───────► dim_campaigns
ad_sets         ─────────► stg_ad_sets     ──┼───────► dim_ad_sets
ads             ─────────► stg_ads         ──┤
ad_creatives    ─────────► stg_ad_creatives┴─┬───────► dim_ads ◄── dim_ad_course_mapping
ads_insights    ─────────► stg_ads_insights ─┴───────► fact_ad_performance
```

`dim_campaigns` takes `account_name` from `stg_ads_insights`, and `dim_ads` takes its base list of ads from it, because the campaign API does not return the account name and only ads with data matter.

## Staging

| Model | What it does |
|---|---|
| `stg_campaigns` | Flattens JSON labels / issues. Infers **CBO vs ABO** (the API has no such field): budget set on the campaign → CBO, otherwise ABO |
| `stg_ad_sets` | Opposite budget inference (budget on the ad set → ABO). Flattens `targeting`: the **real** age range (not `age_min` / `age_max`, which is a fixed ceiling with Advantage+), gender mapping, locations (regions + cities), placements, devices, interests, custom audiences. Lists are aggregated, never "first element only" |
| `stg_ads` | Flattens labels, bid info, targeting basics. Extracts `creative_id` to join creatives. Keeps `tracking_specs` / `conversion_specs` as JSON to avoid losing data |
| `stg_ad_creatives` | Recovers `cta_link` and UTM through fallbacks (see [data quality](../docs/data-quality.md)) |
| `stg_ads_insights` | One row per ad per day from `2026-01-01`. Casts metrics. Pulls `landing_page_views`, `view_content` and the video milestones out of the `actions` arrays |

## Marts

| Model | Notes |
|---|---|
| `fact_ad_performance` | Measures only, grain ad × day |
| `dim_ads` | Ad attributes + course. Course comes from `dim_ad_course_mapping` |
| `dim_ad_sets` | Effective budget = ad set budget, else campaign budget |
| `dim_campaigns` | Objective, status, dates, account name |
| `dim_ad_course_mapping` | Hand-maintained rules in 4 types. Priority: `campaign_ad` > `exact` > `contains` > `prefix` (longer key first) |

See the [data dictionary](../docs/data-dictionary.md).

## Course mapping rules

| Type | Matches when |
|---|---|
| `campaign_ad` | Ad name **and** campaign name both equal the rule (for generic ad names reused across campaigns) |
| `exact` | Ad name equals the rule (curly quotes are normalised) |
| `contains` | Ad name contains the text |
| `prefix` | Ad name starts with the code (e.g. `DA - …`), with or without a leading quote |

A new ad that matches no rule gets `course_name = NULL`. Add a row to the mapping.

## Before the first run

- `workflow_settings.yaml` and `declarations/*.sqlx`: replace `your-project-id` with your GCP project.
- Raw tables are expected in dataset `dw_facebook_ads` (the Airbyte destination).

## Local check

```bash
cd transform
npx @dataform/cli@3.0.52 compile
```
