# Data Quality: CTA Link, UTM and Course Mapping

Matching ads to leads (done in Power BI) is only as good as the **CTA link of each ad**. This page records how the link is recovered, the coverage reached, and what to watch.

## 1. Recovering `cta_link`

Fallback order in `stg_ad_creatives` (first non-empty wins):

| # | Source |
|---|---|
| 1 | `link_url` |
| 2 | `object_story_spec.link_data.link` |
| 3 | `object_story_spec.video_data.call_to_action.value.link` |
| 4 | `object_story_spec.link_data.child_attached_media[0].link` (carousel) |
| 5 | **First URL found in the caption** (`REGEXP_EXTRACT(body, r'(https?://[^\s]+)')`) |

**Why step 5 exists.** Many image / carousel / status posts cannot put a link in the CTA button, so the link is typed in the caption. This pattern continues into 2026, it is not only old ads.

## 2. Extracting UTM

For each of `utm_source`, `utm_medium`, `utm_campaign`, `utm_content`, first match wins:

1. `url_tags` (Facebook already splits the tags)
2. `link_url`
3. The link found in the caption (step 5 above)

## 3. Coverage achieved

| Check | Count |
|---|---|
| Creatives total | 555 |
| No link in the official fields (`object_story_spec`) | 287 |
| No `url_tags` | 208 |
| No UTM **after** the caption fallback | 140 |
| ...of which actually appear in `ads_insights` (have data) | **20 ads** |
| ...of which belong to 2026 | **2 ads** |

The 2 remaining ads: one has no link in its caption, one uses a shortened link, so the UTM cannot be read. Both were known to have **no leads**, because they were run and monitored by hand. Work stopped here: 2 ads out of all 2026 ads is small enough that more effort would not change the analysis.

> The figures come from one snapshot. Re-run the check after any change in how ads are built.

## 4. Course mapping

Each ad gets a `course_name` from `dim_ad_course_mapping`. Rules are checked in this priority: `campaign_ad` > `exact` > `contains` > `prefix`, and longer keys win inside a type. An ad matching nothing gets `course_name = NULL`: add a rule when a new naming pattern appears.

## 5. Things to watch (not verified on production data)

These come from reading the models, so check them on the real data before relying on them.

| Risk | Where | Effect | Check |
|---|---|---|---|
| Ad renamed over time | `dim_ads` builds its base list with `SELECT DISTINCT ad_id, ad_set_id, ad_name, campaign_name` from insights | One `ad_id` can appear twice, which breaks the one-to-many join from `dim_ads` to the fact | `SELECT ad_id, COUNT(*) FROM dm_facebook_ads.dim_ads GROUP BY 1 HAVING COUNT(*) > 1` |
| Duplicate raw rows | Staging views do not de-duplicate by latest `_airbyte_extracted_at` | Duplicate rows in the fact if the Airbyte sync mode appends | `SELECT ad_id, date_start, COUNT(*) FROM dm_facebook_ads.fact_ad_performance GROUP BY 1, 2 HAVING COUNT(*) > 1` |
| Ad sets without a campaign | `dim_ad_sets` uses an inner `JOIN` to campaigns | Ad sets whose campaign is missing disappear | Compare row counts with `stg_ad_sets` |
| Short prefix codes | Prefix rule `DA` also matches names starting with `DA…` | A different course could be mapped | Review `course_name` for new ad names |
| Multiple `actions` rows of one type | `landing_page_views` uses a scalar subquery | Query error if one type appears twice in an array | Watch the first run after a schema change |
| Two ads sharing one UTM | The matching rule is **1 UTM = 1 ad** | Leads of that UTM cannot be assigned to one ad | `SELECT ad_utm_campaign, ad_utm_content, COUNT(*) FROM dm_facebook_ads.dim_ads WHERE ad_utm_content IS NOT NULL GROUP BY 1, 2 HAVING COUNT(*) > 1` |
| Shortened links | Caption links like `bit.ly` | UTM unreadable | Ask for full links with UTM |
