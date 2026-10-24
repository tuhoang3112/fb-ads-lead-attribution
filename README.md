# Facebook Ads Data System: From Ads Manager Exports to a Trusted Ads Dashboard

> An end-to-end data system (**Airbyte → BigQuery → Dataform → Power BI**) that pulls Facebook Ads data every day, flattens the nested API fields, recovers each ad's landing-page link and **UTM**, and labels each ad with its course. The UTM is the key that lets ads be matched to CRM leads.

Built in two rounds, each documented in a blog post:

1. [How I rebuilt the Facebook Ads dashboard for the Marketing team](https://zoedatalens.substack.com/p/rebuild-facebook-ads-dashboard): metrics per campaign objective, manual exports, a hand-made UTM mapping table.
2. [Facebook Ads data system](https://zoedatalens.substack.com/p/facebook-ads-data-system): the automated pipeline, including the API route that removes the manual UTM mapping.

> **Status:** ingestion → staging → data mart are built (this repo). Matching with CRM leads is the next step (see [Roadmap](#roadmap)). Demo data and the live dashboard come later.

---

## The problem

The company runs Facebook Ads as **traffic to landing pages** (not Lead Ads), so Facebook never sees the lead. Leads land in the CRM with a UTM tag but no link to a specific ad.

- The first dashboard showed only daily impressions, reach and spend. Totals per campaign still required opening Ads Manager.
- Nothing connected **an ad to the leads it produced**, so "which ad creates the most leads, for which course?" had no answer.
- In round one the link between an ad and its UTM was a **hand-maintained Google Sheet**, because the database did not hold each ad's CTA link.

**Goal:** daily, automatic ad performance **per campaign objective**, with every ad carrying its **CTA link, UTM and course**, so ads can be joined to CRM leads without manual mapping.

---

## How an ad will be matched to a lead

```text
Ad creative                                CRM
-----------                                ---
CTA link  https://…/program?                Lead form on the landing page
  utm_source=facebook                         stores the UTM of the link
  utm_medium=fanpage            ──UTM──►      the visitor arrived through
  utm_campaign=mc16_digital_marketing
  utm_content=launching_post
```

`dim_ads` already exposes `ad_utm_source / medium / campaign / content` and `ad_cta_link`. The pipeline's hard part is making those columns reliable → [docs/data-quality.md](docs/data-quality.md).

---

## Architecture decisions

| Decision | Choice | Why |
|---|---|---|
| **Warehouse** | **BigQuery** | Same warehouse as the CRM project, so both marts can be joined |
| **ETL or ELT** | **ELT** | Facebook data arrives with nested JSON (targeting, creatives, actions). It is loaded raw and flattened in SQL, so a logic fix is re-applied to all history |
| **Ingestion tool** | **Airbyte (self-hosted)**, built-in *Facebook Marketing* source | The source already has every stream needed. No custom connector (unlike the CRM project) |
| **Transformation** | **Dataform** | SQLX + Git, dependency graph with `ref()`, runs inside BigQuery |
| **BI** | **Power BI** | Same tool as the previous dashboard |
| **Schema** | Fact + dimensions, fact at 1 row per ad per day | Matches the grain of the Facebook insights data |

---

## Sources & ingestion

| Stream | What it holds |
|---|---|
| `campaigns` | Objective, budget, status |
| `ad_sets` | Targeting, budget, promoted pixel / event |
| `ads` | Ad name, status, link to the creative |
| `ad_creatives` | Caption, CTA link, `url_tags`, `object_story_spec` |
| `ads_insights` | Daily performance per ad (spend, impressions, reach, clicks, `actions`) |

→ [ingestion/README.md](ingestion/README.md) (token permissions, API rate limits)

---

## Data model

| Table | Grain | Notes |
|---|---|---|
| `fact_ad_performance` | 1 row per ad per day | Measures only: spend, reach, impressions, frequency, clicks, landing page views |
| `dim_ads` | 1 row per ad | CTA link, UTM, ad type, post link, **course name** |
| `dim_ad_sets` | 1 row per ad set | Effective budget (CBO / ABO) and flattened targeting |
| `dim_campaigns` | 1 row per campaign | Objective, status, account name |
| `dim_ad_course_mapping` | 1 row per mapping rule | Maps ad names to a standard course name. Maintained by hand |

→ [Data Dictionary](docs/data-dictionary.md) · [Metric Definitions](docs/metric-definitions.md)

---

## Transformation & data quality

Dataform builds **5 staging views → 5 mart tables**. The hard part is the CTA link: out of 555 creatives, 287 had no link in the official fields. A caption-regex fallback cut the creatives without UTM from 208 to 140, and only **2 ads from 2026** (the ones with real data) remained without a usable UTM.
→ [docs/data-quality.md](docs/data-quality.md) · [transform/README.md](transform/README.md)

---

## Orchestration

Runs on the same VM and the same pattern as the CRM project: Airbyte sync → Dataform run → Power BI refresh.
→ [orchestration/README.md](orchestration/README.md)

---

## Repository structure

```text
fb-ads-lead-attribution/
├── ingestion/        # Airbyte source setup, permissions, rate limits
├── transform/        # Dataform: declarations, staging, marts
├── orchestration/    # daily schedule
└── docs/
    ├── metric-definitions.md   # metrics per campaign objective
    ├── data-dictionary.md      # column definitions
    └── data-quality.md         # CTA link / UTM recovery, coverage, known gaps
```

## Roadmap

- [ ] Join `dim_ads` UTM with CRM leads: leads and lead value per ad (the next blog post)
- [ ] Add link clicks to `fact_ad_performance` (already in staging as `inline_link_clicks`)
- [ ] Demo data generator (random data, same tables) so the dashboard can be shared
- [ ] Publish the Power BI dashboard (GitHub Pages, like the CRM project)
- [ ] Sales objective: conversions, conversion rate, CPA, ROAS (Pixel events not set up yet)

## Related

- [crm-data-warehouse](https://github.com/tuhoang3112/crm-data-warehouse): the CRM side. Leads will come from its `fact_deal`.

## Data privacy

The structure and logic come from the real pipeline. In this public copy:

- The GCP project ID is a placeholder (`your-project-id`).
- Course names, ad names and campaign names in [`dim_ad_course_mapping`](transform/definitions/marts/dim_ad_course_mapping.sqlx) are **fictional**; the matching rules (prefix / exact / contains / campaign + ad) are unchanged.
- No ad account IDs, tokens, customer records or spend values are included.
