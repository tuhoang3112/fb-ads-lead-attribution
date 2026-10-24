# Data Dictionary

The mart is a star schema at **ad** grain: both fact tables (`fact_ad_insights_daily`, `fact_ad_lead_daily`) join to `dim_ad`, which avoids many-to-many relationships in Power BI. `dim_date` is created in Power BI (DAX).

> **Columns vs metrics:** this file describes columns. How metrics are calculated is in [Metric Definitions](./metric-definitions.md).

---

## `fact_ad_insights_daily`

**Grain:** one row per ad per day · partitioned by `report_date`

| Field | Definition | Data Quality Consideration |
|---|---|---|
| `ad_id` | Ad | FK to `dim_ad.ad_id`. With `report_date`, unique and non-null |
| `ad_set_id`, `campaign_id`, `account_id` | Parents of the ad | FK to the matching dimension |
| `report_date` | Day of the data (ad account time zone) | |
| `objective` | Campaign objective on that day | Decides which metrics to read |
| `spend` | Amount spent (account currency) | |
| `impressions` | Times the ad was shown | |
| `reach` | People reached that day | **Not additive across days** |
| `clicks_all` | All clicks (likes, comments, shares, links) | Not the same as link clicks |
| `link_clicks` | Clicks on the link in the ad | Falls back to the `link_click` action |
| `landing_page_views` | People who reached the landing page | From the `landing_page_view` action |
| `messaging_conversations_started` | Conversations started from the ad | Confirm the exact `action_type` in the account |

## `fact_ad_lead_daily`

**Grain:** one row per ad per lead date · partitioned by `report_date`

| Field | Definition | Data Quality Consideration |
|---|---|---|
| `ad_id`, `report_date` | Ad and the date the lead was created (Asia/Ho_Chi_Minh) | Unique together |
| `leads` | Leads attributed to the ad | Weighted, can be decimal |
| `lead_value` | Sum of `deal_value` of those leads (weighted) | |
| `won_deals`, `won_value` | Same, for won deals only | Outcome as of the last CRM sync |

## `fact_lead`

**Grain:** one row per CRM lead (deal in the Sales and Nurturing pipelines)

| Field | Definition | Data Quality Consideration |
|---|---|---|
| `deal_id` | CRM deal ID | Unique, non-null |
| `created_at`, `lead_date` | Lead creation time, and its date in Asia/Ho_Chi_Minh | |
| `deal_status` | `open`, `won` or `lost` | From the CRM mart |
| `deal_value` | Deal value | May be null |
| `course_selected` | Course chosen by the lead | |
| `utm_source`, `utm_medium`, `utm_campaign`, `utm_content` | Lower-cased UTM from the CRM | `utm_campaign` comes from the CRM column `utm_product` |
| `utm_key` | `utm_campaign\|utm_content` | Null if either is missing |
| `candidate_ad_count` | Number of ads that fit the lead | |
| `attribution_status` | `matched`, `ambiguous`, `unmatched`, `not_facebook_ads` | See [Data Quality](./data-quality.md) |

## `fact_lead_attribution`

**Grain:** one row per (lead, candidate ad)

| Field | Definition | Data Quality Consideration |
|---|---|---|
| `deal_id` | Lead | FK to `fact_lead.deal_id` |
| `ad_id` | Candidate ad | FK to `dim_ad.ad_id` |
| `attribution_weight` | `1 / number of candidate ads` | Weights of one lead sum to 1 |

---

## `dim_ad`

**Grain:** one row per ad

| Field | Definition | Data Quality Consideration |
|---|---|---|
| `ad_id` | Ad | Unique, non-null |
| `ad_set_id`, `campaign_id`, `account_id` | Parents | |
| `ad_name` | Ad name | Convention: `<COURSE_CODE> \| <content name>` |
| `course_code`, `content_name` | The two parts of `ad_name` | FK to `dim_course.course_code`. Null if the convention was not followed |
| `status`, `effective_status` | Ad status | |
| `creative_id` | Creative | |
| `cta_link` | Landing page link | Null for ads without a recoverable link |
| `cta_link_source` | Where the link was found: `link_url`, `object_story_spec`, `caption_regex`, `none` | |
| `is_short_link` | Link is a shortened URL | UTM cannot be read when true |
| `utm_source`, `utm_medium`, `utm_campaign`, `utm_content` | UTM of the link | Lower-cased. Dynamic macros are ignored |
| `utm_key` | `utm_campaign\|utm_content` | Join key to leads |
| `created_time`, `updated_time` | Timestamps | |

## `dim_ad_set`

| Field | Definition |
|---|---|
| `ad_set_id`, `campaign_id`, `account_id`, `ad_set_name` | Identifiers and name |
| `optimization_goal`, `billing_event` | How Facebook optimises and bills |
| `status`, `effective_status`, `start_time`, `end_time` | Status and schedule |
| `budget_type` | `CBO` (budget on the campaign) or `ABO` (budget on the ad set) |
| `applied_daily_budget`, `applied_lifetime_budget` | The budget that actually applies, taken from the campaign for CBO and the ad set for ABO |
| `targeting_age_range`, `targeting_locations` | Age range; countries, regions and cities in one string |
| `targeting_display_positions` | Facebook and Instagram placements in one string |
| `targeting_devices`, `targeting_interests`, `targeting_custom_audiences` | Lists flattened to one string |

## `dim_campaign`

| Field | Definition |
|---|---|
| `campaign_id`, `account_id`, `campaign_name` | Identifiers and name |
| `objective` | Campaign objective (Awareness, Traffic, Engagement, Sales...) |
| `buying_type`, `status`, `effective_status` | Setup and status |
| `budget_type`, `daily_budget`, `lifetime_budget` | Campaign-level budget (empty for ABO) |
| `start_time`, `stop_time`, `created_time` | Schedule |

## `dim_account`

| Field | Definition |
|---|---|
| `account_id`, `account_name` | Ad account. Used to filter the dashboard |

## `dim_course`

| Field | Definition |
|---|---|
| `course_code` | Short code at the start of the ad name. Unique |
| `course_name` | Full course name |
