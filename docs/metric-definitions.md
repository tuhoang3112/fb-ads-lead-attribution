# Metric Definitions

Which metrics to read depends on the **objective** the campaign was set up with. One definition per metric, so Marketing reads the same number everywhere.

> **Columns vs metrics:** the [Data Dictionary](./data-dictionary.md) describes columns. This file describes how a number is calculated and read.

**Ratios are never stored.** They are computed in Power BI as `SUM(numerator) / SUM(denominator)` over the current filter, so they stay correct at any level (ad, campaign, course, period).

**Availability** shows what `fact_ad_performance` holds today. Metrics marked *staging only* exist in `stg_ads_insights` and need to be added to the fact table.

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

| Metric | Formula | Availability |
|---|---|---|
| **Messaging Conversations Started** | Conversations started from the ad | ❌ Not extracted yet |
| **CPCM** | `SUM(spend) / Messaging Conversations Started` | ❌ |

Not covered yet: conversations that Sales actually advised or closed.

## 3. Traffic

Goal: send people to a landing page, whatever they do next.

| Metric | Formula | Availability |
|---|---|---|
| **Link Clicks** | Clicks on the link in the ad | *staging only* (`inline_link_clicks`) |
| **CTR** | Link Clicks / Impressions | *staging only*. `clicks` in the fact includes likes and shares, so it overstates CTR |
| **CPC** | `SUM(spend) / Link Clicks` | *staging only* |
| **Landing Page Views** | People who actually reached the page | ✅ |
| **LPV rate** | Landing Page Views / Link Clicks. Separates real clicks from "ghost" clicks (user left before the page loaded) | needs Link Clicks |

## 4. Sales (not built yet)

Needs the Facebook Pixel and a conversion event. Listed so the definitions are agreed in advance.

| Metric | Formula |
|---|---|
| **Conversions** | Number of conversion events |
| **Conversion Rate** | Conversions / Landing Page Views |
| **CPA** | `SUM(spend) / Conversions` |
| **ROAS** | Revenue / `SUM(spend)` |

---

## 5. Lead metrics (planned: ad → CRM)

Needs the CRM join on UTM (see the Roadmap in the README).

| Metric | Formula |
|---|---|
| **Leads** | CRM leads matched to the ad through UTM |
| **CPL** | `SUM(spend) / Leads` |
| **Lead Value** | Deal value of those leads |
| **Funnel** | Impressions → Link Clicks → Landing Page Views → Leads |

**Common misreadings**
- ❌ Reading **CPL on a campaign whose objective is Awareness or Messages**. Those ads were not built to send traffic, so a high CPL says nothing about quality.
- ❌ Adding up `reach` across days or ads.
- ❌ Comparing totals of an ad that ran 3 days with one that ran 3 weeks. Compare per day or per currency spent.
