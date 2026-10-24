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

Each ad gets a `course_name` from `dim_ad_course_mapping`. From 2026 the course is read from the prefix of the ad name (`DI_<ad name>`). Before 2026 the ad names are free text, so a mapping table kept by hand in a Google Sheet pairs each course with its ad names. An ad that matches nothing has no course (`course_name` is empty).
