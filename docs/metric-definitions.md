# Metric Definitions

Which metrics to read depends on the **objective** the campaign was set up with. One definition per metric, so Marketing reads the same number everywhere.

> **Columns vs metrics:** the [Data Dictionary](./data-dictionary.md) describes columns. This file describes how a number is calculated and read.

**Ratios are never stored.** They are computed in Power BI as `SUM(numerator) / SUM(denominator)` over the current filter, so they stay correct at any level (ad, campaign, course, period).

**Focus:** every ad is set up with an objective, which decides the metrics to read, so this file is grouped by objective. Most ads run for **leads**: Traffic to a landing page (LDP), with a **form fill** as the conversion. Their core funnel is Impressions → Link Clicks → Landing Page Views → Leads. Awareness ads are a smaller share, and Engagement (messages) is out of scope.

**Availability** shows what `fact_ad_performance` holds today. *Staging only* means the metric exists in `stg_ads_insights` but not in the fact table.

---

## 1. Awareness

Goal: brand / product recognition.

| Metric | Formula | Availability |
|---|---|---|
| **Reach** | People who saw the ad (each person counted once) | ✅ ⚠️ Not additive across days |
| **Impressions** | `SUM(impressions)`. Roughly Reach × Frequency | ✅ |
| **Frequency** | Impressions / Reach. 2 means each person saw the ad twice on average | ✅ |
| **CPM** | `SUM(spend) / SUM(impressions) × 1000`. Main cost metric for Awareness | ✅ |

**Reach pitfall.** Reach is de-duplicated per day. Summing it over days counts the same person several times. Use the daily value, or ask Facebook for the reach of the whole period.

## 2. Engagement (messages)

Goal: start a conversation so Sales can advise and close by chat.

> **Out of scope for now:** messaging metrics are not extracted into the data mart.

| Metric | Formula | Availability |
|---|---|---|
| **Messaging Conversations Started** | Conversations started from the ad | ➖ Out of scope |
| **CPCM** | `SUM(spend) / Messaging Conversations Started` | ➖ Out of scope |


## 3. Traffic

Goal: send people to a landing page, whatever they do next.

| Metric | Formula | Availability |
|---|---|---|
| **Link Clicks** | `SUM(inline_link_clicks)`: clicks on the link in the ad | ✅ |
| **CTR** | Link Clicks / Impressions. `clicks` includes likes and shares, so it overstates CTR | ✅ |
| **CPC** | `SUM(spend) / Link Clicks` | ✅ |
| **Landing Page Views** | People who actually reached the page | ✅ |
| **LPV rate** | Landing Page Views / Link Clicks. Separates real clicks from "ghost" clicks (user left before the page loaded) | ✅ |

## 4. Conversion = form fill

The conversion happens on the landing page and can be counted two ways:

| Source | What it gives | Availability |
|---|---|---|
| **Facebook Pixel** event (the event set on the ad set, see `dim_ad_sets.pixel_custom_event`) | Conversions as Facebook counts them, per ad per day | ❌ Not in `fact_ad_performance` yet |
| **CRM leads** matched to ads through UTM in Power BI (section 5) | The real lead: course, value, won / lost | ✅ via Power BI |

The two numbers can differ (attribution window, tracking loss), so compare them rather than assume they match. Definitions for the Pixel side:

| Metric | Formula |
|---|---|
| **Conversions** | Number of conversion events |
| **Conversion Rate** | Conversions / Landing Page Views |
| **CPA** | `SUM(spend) / Conversions` |
| **ROAS** | Revenue / `SUM(spend)` |

---

## 5. Lead metrics (ad → CRM, in Power BI)

Leads come from the CRM and are matched to ads **in the Power BI model** through UTM (`dim_ads.ad_utm_*`). These measures are defined in Power BI, not in Dataform.

| Metric | Formula |
|---|---|
| **Leads** | CRM leads matched to the ad through UTM |
| **Lead rate** | Leads / Landing Page Views (how well the landing page converts) |
| **CPL** | `SUM(spend) / Leads` |
| **Lead Value** | Deal value of those leads |
| **Funnel** | Impressions → Link Clicks → Landing Page Views → Leads |

**Common misreadings**
- ❌ Reading **CPL on a campaign whose objective is Awareness or Messages**. Those ads were not built to send traffic, so a high CPL says nothing about quality.
- ❌ Adding up `reach` across days or ads.
- ❌ Comparing totals of an ad that ran 3 days with one that ran 3 weeks. Compare per day or per currency spent.
