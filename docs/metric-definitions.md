# Metric Definitions

Which metrics to read depends on the **objective** the campaign was set up with. One definition per metric, so Marketing reads the same number everywhere.

> **Columns vs metrics:** the [Data Dictionary](./data-dictionary.md) describes columns. This file describes how a number is calculated and read.

**Impressions, Reach and Frequency are taken as reported by Facebook**, not calculated. **The other ratios are not stored**: they are computed in Power BI as `SUM(numerator) / SUM(denominator)` over the current filter, so they stay correct at any level (ad, campaign, course, period).

**Focus:** every ad is set up with an objective, which decides the metrics to read, so this file is grouped by objective. Most ads run for **leads**: Traffic to a landing page (LDP), with a **form fill** as the conversion. Their core funnel is Impressions → Link Clicks → Landing Page Views → Leads. Awareness and Engagement (messages) ads run in a smaller share.

---

## 1. Awareness

Goal: brand / product recognition.

| Metric | Formula |
|---|---|
| **Reach** | People who saw the ad (each person counted once). ⚠️ Not additive across days |
| **Impressions** | As reported by Facebook, summed over the period. Roughly Reach × Frequency |
| **Frequency** | As reported by Facebook: the average number of times a person saw the ad. 2 means each person saw the ad twice on average |
| **CPM** | `SUM(spend) / SUM(impressions) × 1000`. Main cost metric for Awareness |

**Reach pitfall.** Reach is de-duplicated per day. Summing it over days counts the same person several times. Use the daily value, or ask Facebook for the reach of the whole period.

## 2. Engagement (messages)

Goal: start a conversation so Sales can advise and close by chat.

Ads for messages still run, in a smaller share than the lead ads. The dashboard shows both metrics: in the Ads Detail table and in the Top Messaging Started Ads chart.

| Metric | Formula |
|---|---|
| **Messaging Conversations Started** | Conversations started from the ad |
| **CPCM** | `SUM(spend) / Messaging Conversations Started` |


## 3. Traffic

Goal: send people to a landing page, whatever they do next.

| Metric | Formula |
|---|---|
| **Link Clicks** | `SUM(inline_link_clicks)`: clicks on the link in the ad |
| **CTR** | Link Clicks / Impressions. `clicks` includes likes and shares, so it overstates CTR |
| **CPC** | `SUM(spend) / Link Clicks` |
| **Landing Page Views** | People who actually reached the page |
| **LPV rate** | Landing Page Views / Link Clicks. Separates real clicks from "ghost" clicks (user left before the page loaded) |

## 4. Lead metrics (ad → CRM, in Power BI)

The conversion is a form fill on the landing page. Leads come from the CRM and are matched to ads **in the Power BI model** through UTM (`dim_ads.ad_utm_*`). These measures are defined in Power BI, not in Dataform.

| Metric | Formula |
|---|---|
| **Leads (from ads)** | CRM leads with `utm_medium = cpc`, matched to the ad through UTM |
| **Total leads** | All CRM leads in the period, whatever the UTM. Used to compare with the leads from ads |
| **Conversion Rate** | Leads / Landing Page Views (how well the landing page converts) |
| **CPL** | `SUM(spend) / Leads` |
| **Lead Value** | Deal value of those leads |
| **Funnel** | Impressions → Link Clicks → Landing Page Views → Leads |
