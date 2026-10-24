# Facebook Ads Data System: From Ads Manager Exports to a Trusted Ads Dashboard

> An end-to-end data system (**Airbyte → BigQuery → Dataform → Power BI**) that pulls Facebook Ads data every day, flattens the nested API fields, recovers each ad's landing-page link and **UTM**, and labels each ad with its course. The UTM is the key that lets ads be matched to CRM leads.

> **Status:** ingestion → staging → data mart are built (this repo). Matching ads with CRM leads happens in the Power BI model, which is not part of this repository yet. Demo data and the live dashboard come later (see [Roadmap](#roadmap)).

---

## The problem

The company runs Facebook Ads as **traffic to landing pages** (not Lead Ads), and the conversion is a **form fill on the landing page**. Facebook never sees that lead. Leads land in the CRM with a UTM tag but no link to a specific ad.

- The existing dashboard showed only daily impressions, reach and spend. Totals per campaign still required opening Ads Manager.
- Nothing connected **an ad to the leads it produced**, so "which ad creates the most leads, for which course?" had no answer.
- The database did not hold each ad's CTA link, so the link between an ad and its UTM would have to be a **hand-maintained Google Sheet**.

**Goal:** daily, automatic ad performance **per campaign objective**, with every ad carrying its **CTA link, UTM and course**, so ads can be joined to CRM leads without manual mapping.

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

`dim_ads` exposes `ad_utm_source / medium / campaign / content` and `ad_cta_link`. **The join itself is done in Power BI**, between `dim_ads` and the lead counts per UTM per day from the CRM. Because one UTM can map to several ads (and the reverse), bridge tables are used in the Power BI model to avoid many-to-many relationships. The pipeline's hard part is making the UTM columns reliable → [docs/data-quality.md](docs/data-quality.md).

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
| `fact_ad_performance` | 1 row per ad per day | Measures only: spend, reach, impressions, frequency, clicks, link clicks, landing page views |
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

- [ ] Document the Power BI model: ads ↔ CRM leads through UTM, bridge tables, lead measures
- [ ] Demo data generator (random data, same tables) so the dashboard can be shared
- [ ] Publish the Power BI dashboard (GitHub Pages, like the CRM project)
- [ ] Lead rate and CPL per ad as Power BI measures. Facebook Pixel / ROAS is not used: the conversion is a form fill counted in the CRM

## Related

- [crm-data-warehouse](https://github.com/tuhoang3112/crm-data-warehouse): the CRM side. Leads come from its `fact_deal` (UTM columns).

## Data privacy

The structure and logic come from the real pipeline. In this public copy:

- The GCP project ID is a placeholder (`your-project-id`).
- Course names, ad names and campaign names in [`dim_ad_course_mapping`](transform/definitions/marts/dim_ad_course_mapping.sqlx) are **fictional**; the matching rules (prefix / exact / contains / campaign + ad) are unchanged.
- No ad account IDs, tokens, customer records or spend values are included.
