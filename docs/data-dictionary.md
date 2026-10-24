# Data Dictionary

Star schema at **ad** grain: `fact_ad_performance` joins to `dim_ads`, which joins to `dim_ad_sets` and `dim_campaigns`. `dim_date` is created in Power BI (DAX).

> **Columns vs metrics:** this file describes columns. How metrics are calculated is in [Metric Definitions](./metric-definitions.md).
>
> Public-copy note: course names in `dim_ads.course_name` and `dim_ad_course_mapping` are fictional.

---

## `fact_ad_performance`

**Grain:** one row per ad per day (data from 2026-01-01)

| Field | Definition | Data Quality Consideration |
|---|---|---|
| `ad_id` | Ad | FK to `dim_ads.ad_id`. With `date_start`, should be unique |
| `date_start`, `date_stop` | Day of the data (ad account time zone) | Daily rows, so both are the same day |
| `spend` | Amount spent (account currency) | |
| `reach` | People reached that day | **Not additive across days** |
| `impressions` | Times the ad was shown | |
| `frequency` | Average times a person saw the ad that day | Do not average it across rows; use Impressions / Reach |
| `clicks` | All clicks (links, likes, comments, shares) | Not the same as link clicks |
| `inline_link_clicks` | Clicks on the link in the ad (the Traffic metric) | Use this for CTR / CPC, not `clicks` |
| `landing_page_views` | People who reached the landing page | From the `landing_page_view` action. NULL when the ad had none that day |

## `dim_ads`

**Grain:** one row per ad that has insights data

| Field | Definition | Data Quality Consideration |
|---|---|---|
| `ad_id` | Ad | Should be unique and non-null |
| `ad_set_id` | Ad set | FK to `dim_ad_sets.ad_set_id` |
| `ad_name` | Ad name | Names start with a course code, which drives the course mapping |
| `ad_status` | Ad status | |
| `ad_type` | Creative object type (link, video, photo, status...) | |
| `ad_link` | Link to the Facebook post (`facebook.com/<page>/posts/<post>`) | NULL when the creative has no story ID |
| `ad_cta_type` | Call-to-action button type | |
| `ad_cta_link` | Landing page link | Recovered through fallbacks, see [Data Quality](./data-quality.md) |
| `ad_utm_source`, `ad_utm_medium`, `ad_utm_campaign`, `ad_utm_content` | UTM of the link | NULL when the link is missing or has no UTM |
| `ad_copy_text` | Caption text | |
| `course_name` | Standard course name from `dim_ad_course_mapping` | NULL when no mapping rule matches |

## `dim_ad_sets`

**Grain:** one row per ad set

| Field | Definition |
|---|---|
| `ad_set_id`, `campaign_id`, `ad_set_name` | Identifiers and name |
| `ad_set_status` | Effective status |
| `budget_level` | `ABO` (budget set on the ad set) or `CBO` (budget on the campaign) |
| `daily_budget`, `lifetime_budget` | The budget that applies: the ad set's, else the campaign's |
| `pixel`, `pixel_custom_event` | Pixel and custom event the ad set promotes |
| `targeting_age_range` | The age range actually set |
| `targeting_gender` | `Male`, `Female`, or `All` (an empty list means all genders) |
| `targeting_display_positions` | Facebook and Instagram placements, one line each |
| `targeting_interests`, `targeting_locations`, `targeting_custom_audiences` | Lists flattened to one string. Interests are NULL for fully open Advantage+ targeting |
| `ad_set_date_start`, `ad_set_date_stop` | Schedule |

## `dim_campaigns`

**Grain:** one row per campaign

| Field | Definition |
|---|---|
| `campaign_id`, `campaign_name` | Identifier and name |
| `account_name` | Ad account name (taken from insights, the campaigns API does not return it) |
| `campaign_status` | Status |
| `campaign_objective` | Objective (Awareness, Traffic, Engagement, Sales...). Decides which metrics to read |
| `campaign_start_date`, `campaign_stop_date` | Schedule |

## `dim_ad_course_mapping`

**Grain:** one row per mapping rule (maintained by hand)

| Field | Definition |
|---|---|
| `mapping_type` | `prefix`, `exact`, `contains` or `campaign_ad` |
| `ad_key` | Text the ad name is compared with |
| `campaign_pattern` | Campaign name, used only by `campaign_ad` rules |
| `course_selected` | Standard course name returned |
