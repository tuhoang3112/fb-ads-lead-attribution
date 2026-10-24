# Facebook Ads Data System: From Ads Manager Exports to Ad-Level Lead Attribution

> An end-to-end data system (**Airbyte → BigQuery → Dataform → Power BI**) that pulls Facebook Ads data every day, cleans it, and matches each ad to the leads it generated through the **UTM** in its landing-page link.

Built in two rounds, each documented in a blog post:

1. [How I rebuilt the Facebook Ads dashboard for the Marketing team](https://zoedatalens.substack.com/p/rebuild-facebook-ads-dashboard): metrics per campaign objective, manual exports, a hand-made UTM mapping table.
2. [Facebook Ads data system](https://zoedatalens.substack.com/p/facebook-ads-data-system): the automated pipeline, including the API route that removes the manual UTM mapping.

> **Status:** work in progress. Ingestion and staging are described from the posts; the Dataform models in [`transform/`](transform/) are a **draft** to be aligned with the production code. Demo data and the live dashboard come later. See [Roadmap](#roadmap).

---

## The problem

The company runs Facebook Ads as **traffic to landing pages** (not Lead Ads), so Facebook never sees the lead. Leads land in the CRM, with a UTM tag but no link to a specific ad.

- The first dashboard showed only daily impressions, reach and spend. Totals per campaign still required opening Ads Manager.
- Nothing connected **an ad to the leads it produced**, so "which ad creates the most leads, for which course?" had no answer.
- In round one the link between an ad and its UTM was a **hand-maintained Google Sheet**, because the database did not hold each ad's CTA link.

**Goal:** daily, automatic ad performance **per campaign objective**, plus lead count and value **per ad**, with no manual mapping.

---

## How an ad is matched to a lead

```text
Ad creative                                CRM
-----------                                ---
CTA link  https://…/program?                Lead form on the landing page
  utm_source=facebook                         stores the UTM of the link
  utm_medium=fanpage            ──UTM──►      the visitor arrived through
  utm_campaign=mc16_digital_marketing
  utm_content=launching_post
```

The UTM is the only shared key. The whole pipeline exists to (1) recover each ad's CTA link and UTM reliably, (2) match them to CRM leads, and (3) say honestly when a match is not certain. → [docs/data-quality.md](docs/data-quality.md)

---

## Architecture decisions

| Decision | Choice | Why |
|---|---|---|
| **Warehouse** | **BigQuery** | Same warehouse as the CRM project. Both marts can be joined |
| **ETL or ELT** | **ELT** | Facebook data arrives with nested JSON (targeting, creatives). It is loaded raw and flattened in SQL, so a logic fix is re-applied to all history |
| **Ingestion tool** | **Airbyte (self-hosted)**, built-in *Facebook Marketing* source | The source already has every stream needed. No custom connector (unlike the CRM project) |
| **Transformation** | **Dataform** | SQLX + Git, dependency graph with `ref()`, runs inside BigQuery |
| **BI** | **Power BI** | Same tool as the previous dashboard |
| **Schema** | Fact + dimension tables, one row per ad per day | Matches the grain of the Facebook insights data |

---

## Sources & ingestion

| Stream | What it holds |
|---|---|
| `campaigns` | Objective, budget, status |
| `ad_sets` | Targeting, optimisation goal, budget |
| `ads` | Ad name, status, link to the creative |
| `ad_creatives` | Caption, CTA link, `url_tags`, `object_story_spec` |
| `ads_insights` | Daily performance per ad (spend, impressions, reach, clicks, `actions`) |

→ [ingestion/README.md](ingestion/README.md) (token permissions, API rate limits)

---

## Data model

| Table | Grain | Notes |
|---|---|---|
| `fact_ad_insights_daily` | 1 row per ad per day | Additive counts only. Ratios are computed in Power BI |
| `fact_lead` | 1 row per CRM lead | Attribution status: matched / ambiguous / unmatched / not Facebook |
| `fact_lead_attribution` | 1 row per lead × candidate ad | Weight splits a lead when several ads share one UTM |
| `fact_ad_lead_daily` | 1 row per ad per day | Leads and lead value, same grain as insights |
| `dim_ad`, `dim_ad_set`, `dim_campaign`, `dim_account` | 1 row per entity | `dim_ad` carries `cta_link` and UTM; `dim_ad_set` carries flattened targeting |
| `dim_course` | 1 row per course | Maintained by hand in a Google Sheet |

→ [Data Dictionary](docs/data-dictionary.md) · [Metric Definitions](docs/metric-definitions.md)

---

## Transformation & data quality

Dataform builds **6 staging views → 9 mart tables**, with assertions on keys and on lead counts. The hard part is the CTA link: out of 555 creatives, 287 had no link in the official fields. A caption-regex fallback cut the creatives without UTM from 208 to 140, and only **2 ads from 2026** (the ones with real data) remained without a usable UTM.
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
├── transform/        # Dataform: staging and mart models (draft)
├── orchestration/    # daily schedule
└── docs/
    ├── metric-definitions.md   # metrics per campaign objective + lead metrics
    ├── data-dictionary.md      # column definitions
    └── data-quality.md         # UTM coverage, matching rules, known gaps
```

## Roadmap

- [ ] Align `transform/` with the production Dataform code
- [ ] Demo data generator (random data, same tables) so the dashboard can be shared
- [ ] Publish the Power BI dashboard (GitHub Pages, like the CRM project)
- [ ] Sales objective: conversions, conversion rate, CPA, ROAS (Pixel events not set up yet)
- [ ] Join with CRM beyond lead count: sales outcome per ad (the next blog post)

## Related

- [crm-data-warehouse](https://github.com/tuhoang3112/crm-data-warehouse): the CRM side. Leads come from its `fact_deal`.

## Data privacy

All figures and names in this repository are either public structure or randomly generated. No ad account IDs, tokens, customer records or spend values are included.
