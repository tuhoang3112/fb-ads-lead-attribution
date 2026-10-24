# Data Dictionary

Star schema at **ad** grain: `fact_ad_performance` joins to `dim_ads`, which joins to `dim_ad_sets` and `dim_campaigns`. `dim_date` is created in Power BI (DAX).

> **Columns vs metrics:** this file describes columns. How metrics are calculated is in [Metric Definitions](./metric-definitions.md).
>
> Public-copy note: course names in `dim_ads.course_name` and `dim_ad_course_mapping` are fictional.

---

## `fact_ad_performance`

**Grain:** one row per ad per day (data from 2026-01-01)

| Field | Definition |
|---|---|
| `ad_id` | Ad |
| `date_start`, `date_stop` | Day of the data (ad account time zone) |
| `spend` | Amount spent (account currency) |
| `reach` | People reached that day |
| `impressions` | Times the ad was shown |
| `frequency` | Average times a person saw the ad that day |
| `clicks` | All clicks (links, likes, comments, shares) |
| `inline_link_clicks` | Clicks on the link in the ad (the Traffic metric) |
| `landing_page_views` | People who reached the landing page |

## `dim_ads`

**Grain:** one row per ad that has insights data

| Field | Definition |
|---|---|
| `ad_id` | Ad |
| `ad_set_id` | Ad set |
| `ad_name` | Ad name |
| `ad_status` | Ad status |
| `ad_type` | Creative object type (link, video, photo, status...) |
| `ad_link` | Link to the Facebook post (`facebook.com/<page>/posts/<post>`) |
| `ad_cta_type` | Call-to-action button type |
| `ad_cta_link` | Landing page link |
| `ad_utm_source`, `ad_utm_medium`, `ad_utm_campaign`, `ad_utm_content` | UTM of the link |
| `ad_copy_text` | Caption text |
| `course_name` | Standard course name from `dim_ad_course_mapping`. The portfolio (AI, Data, EE, MKT) is derived from it in Power BI, it is not a column of the mart |

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

