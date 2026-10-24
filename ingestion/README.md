# Ingestion

One source lands in BigQuery: the Facebook Marketing API, through Airbyte.

| Source | Method | Destination |
|---|---|---|
| **Facebook Marketing** (Graph API) | Airbyte built-in *Facebook Marketing* source, self-hosted | BigQuery dataset `dw_facebook_ads` (raw) |
| **Courses** (Google Sheet, kept by hand) | BigQuery external table `course` | `dw_facebook_ads.course` |

No custom connector is needed: the built-in source already offers every stream used here. Airbyte runs on the same VM as the CRM project, so no new infrastructure was set up.

## 1. Access token

A token from the Facebook Graph API with:

| Permission | Why |
|---|---|
| `ads_read` | Read campaigns, ad sets, ads and Insights from the ad account |
| `business_management` | Needed when the ad account sits inside a Business Manager |

The Facebook account that owns the Meta Developer App must also have access to the ad account (Business Manager → Users / Assets).

> Tokens and account IDs are never committed. Put them in the Airbyte source form only.

## 2. Streams

Facebook Marketing exposes many streams. Only five are synced:

| Stream | Used for |
|---|---|
| `campaigns` | `dim_campaign`: objective, budget level |
| `ad_sets` | `dim_ad_set`: targeting, optimisation goal |
| `ads` | `dim_ad`: ad name, status, creative ID |
| `ad_creatives` | `dim_ad`: CTA link and UTM (see [data quality](../docs/data-quality.md)) |
| `ads_insights` | `fact_ad_insights_daily`: daily metrics per ad |

## 3. Rate limits (the one real problem)

On the first full sync, Airbyte appeared frozen and its UI stopped responding. The logs showed:

```text
Utilization is too high (85%), pausing for 2 minutes
```

The connector was sending requests close to Facebook's API quota, so Facebook throttled it. Airbyte did not fail: it **paused 2 minutes, resumed, paused again**. Small tables finished first, large ones kept going, and after a few hours (once the quota relaxed) the sync completed. It was not a VM memory problem, although that was the first guess.

| What to do | Effect |
|---|---|
| Wait. Check the job logs over SSH instead of cancelling | The job is slow, not dead |
| Request **Advanced Access** for the Facebook App (App Review) | Higher quota. With about 50 active ads, roughly 20,600 → 210,000 API calls per hour (10x) |
| Run the heavy first sync overnight, incremental syncs afterwards | Avoids a long first-load window during the day |

## 4. Duplicates & schema changes

- Every `stg_*` model keeps the **latest version of each record** (`QUALIFY ROW_NUMBER() OVER (PARTITION BY id ORDER BY _airbyte_extracted_at DESC) = 1`).
- Nested fields (`targeting`, `object_story_spec`, `actions`) stay as JSON in raw. A new field does not change the raw schema; it is used only once mapped in staging.

## 5. Courses Google Sheet

`course_code` → `course_name`, kept by hand. Ads follow the naming rule `<COURSE_CODE> | <content name>`, and the code before `|` is joined to this sheet. The Dataform service account needs viewer access to the sheet.
