# Metric Definitions

Which metrics to read depends on the **objective** the campaign was set up with. One definition per metric, so Marketing reads the same number everywhere.

> **Columns vs metrics:** the [Data Dictionary](./data-dictionary.md) describes columns. This file describes how a number is calculated and read.

All base counts come from `fact_ad_insights_daily` (one row per ad per day). **Ratios are never stored**: they are computed in Power BI as `SUM(numerator) / SUM(denominator)` over the selected filter, so they stay correct at any level (ad, campaign, course, period).

---

## 1. Awareness

Goal: brand / product recognition.

| Metric | Formula | Notes |
|---|---|---|
| **Reach** | People who saw the ad (each person counted once) | ⚠️ Not additive across days (see below) |
| **Impressions** | `SUM(impressions)` | Times the ad was shown. Roughly Reach × Frequency |
| **Frequency** | Impressions / Reach | Average times a person saw the ad. 2 = twice on average |
| **CPM** | `SUM(spend) / SUM(impressions) × 1000` | Cost per 1,000 impressions. Main cost metric for Awareness |

**Reach pitfall.** Reach is de-duplicated per day. Summing it over days counts the same person several times. Use the daily value, or ask Facebook for the reach of the whole period.

## 2. Engagement (messages)

Goal: start a conversation so Sales can advise and close by chat.

| Metric | Formula |
|---|---|
| **Messaging Conversations Started** | `SUM(messaging_conversations_started)` |
| **CPCM** (cost per conversation) | `SUM(spend) / SUM(messaging_conversations_started)` |

Not covered yet: conversations that Sales actually advised or closed.

## 3. Traffic

Goal: send people to a landing page, whatever they do next.

| Metric | Formula | Notes |
|---|---|---|
| **Link Clicks** | `SUM(link_clicks)` | Clicks on the link in the ad |
| **CTR** | `SUM(link_clicks) / SUM(impressions)` | Link-click CTR. `clicks_all` includes likes, comments and shares, so it gives a higher number |
| **CPC** | `SUM(spend) / SUM(link_clicks)` | |
| **Landing Page Views** | `SUM(landing_page_views)` | People who actually reached the page |
| **LPV rate** | Landing Page Views / Link Clicks | Separates real clicks from "ghost" clicks (user left before the page loaded) |

## 4. Sales (not built yet)

Needs the Facebook Pixel and a conversion event. Listed so the definitions are agreed in advance.

| Metric | Formula |
|---|---|
| **Conversions** | Number of conversion events |
| **Conversion Rate** | Conversions / Landing Page Views |
| **CPA** | `SUM(spend) / Conversions` |
| **ROAS** | Revenue / `SUM(spend)` |

---

## 5. Lead metrics (ad → CRM)

**Source:** `fact_ad_lead_daily` (leads per ad per day), joined with `fact_ad_insights_daily` through `dim_ad`.

| Metric | Formula | Notes |
|---|---|---|
| **Leads** | `SUM(leads)` | Can be a decimal: a lead shared by N ads counts 1/N for each |
| **CPL** | `SUM(spend) / SUM(leads)` | |
| **Lead Value** | `SUM(lead_value)` | Deal value of the leads |
| **Won Deals / Won Value** | `SUM(won_deals)`, `SUM(won_value)` | Outcome reported by the CRM |
| **Click → Lead rate** | `SUM(leads) / SUM(link_clicks)` | |
| **Funnel** | Impressions → Link Clicks → Landing Page Views → Leads | |

**Common misreadings**
- ❌ Reading **CPL on a campaign whose objective is Awareness or Messages**. Those ads were not built to send traffic, so a high CPL says nothing about quality.
- ❌ Adding up `reach` across days or ads.
- ❌ Comparing leads of an ad that ran 3 days with one that ran 3 weeks. Compare per day or per currency spent.
- ✅ Always check `fact_lead.attribution_status` before trusting a lead number: `unmatched` and `not_facebook_ads` leads are **not** in any ad's total.
