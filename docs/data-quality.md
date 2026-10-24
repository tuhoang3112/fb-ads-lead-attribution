# Data Quality: CTA Link, UTM and Matching

Lead attribution is only as good as the **CTA link of each ad**. This page records how the link is recovered, what coverage was reached, and where the match is still uncertain.

## 1. Recovering `cta_link`

Fallback order in `stg_ad_creative` (first non-empty wins):

| # | Source | `cta_link_source` |
|---|---|---|
| 1 | `link_url` | `link_url` |
| 2 | `object_story_spec.link_data.link` | `object_story_spec` |
| 3 | `object_story_spec.video_data.call_to_action.value.link` | `object_story_spec` |
| 4 | `object_story_spec.link_data.child_attached_media[0].link` | `object_story_spec` |
| 5 | **First URL found in the caption** (regex `https?://[^\s]+`) | `caption_regex` |

**Why step 5 exists.** Many older posts are images or carousels, where the link cannot sit in the CTA button, so people typed it in the caption instead.

## 2. Extracting UTM

`utm_source`, `utm_medium`, `utm_campaign`, `utm_content` are read from `url_tags` first, then from the query string of `cta_link`. A value like `{{ad.name}}` (an unresolved dynamic macro) is ignored. Shortened links (`bit.ly`, `fb.me`...) hide the UTM and are flagged `is_short_link = TRUE`.

## 3. Coverage achieved

| Check | Count |
|---|---|
| Creatives total | 555 |
| No link in official fields (`object_story_spec`) | 287 |
| No `url_tags` | 208 |
| No UTM **after** the caption fallback | 140 |
| ...of which actually appear in `ads_insights` (have data) | **20 ads** |
| ...of which belong to 2026 | **2 ads** |

The 2 remaining ads: one has no link in its caption, one uses a shortened link. Both were known to have **no leads**, because they were run and monitored by hand. Work stopped here: 2 ads out of all 2026 ads is small enough that further effort would not change the analysis.

> Re-run this check after any change in how ads are built. The figures above come from one snapshot.

## 4. Matching leads to ads

A lead is attributed to an ad when:

1. the lead is from a **Facebook** UTM source and its medium is not an after-the-fact Sales tag (`inbox`, `zalo`), and
2. the lead's `utm_campaign|utm_content` equals the ad's, and
3. the ad had delivered (had impressions) on or before the lead date.

`utm_source` and `utm_medium` are not part of the key on purpose: Sales can edit them later, campaign and content are stable.

| `attribution_status` | Meaning |
|---|---|
| `matched` | Exactly one ad fits |
| `ambiguous` | Several ads share the same UTM. The lead is split equally (weight 1/N) |
| `unmatched` | Facebook UTM, but no ad with that UTM and delivery date |
| `not_facebook_ads` | Other channels, or no usable UTM |

## 5. Known gaps

| Gap | Effect | Mitigation |
|---|---|---|
| Two ads reusing one UTM | Leads split equally, which may be wrong | Give every ad a unique `utm_content` |
| Shortened links in captions | UTM unreadable | Use full links with UTM |
| Lead date vs ad date | The ad may have been paused before a late lead | The rule uses first-delivery date only, so late leads still match |
| Time zone | CRM timestamps are converted to Asia/Ho_Chi_Minh; Facebook dates follow the ad account's time zone | Make sure both are the same zone |

## 6. Automatic checks (Dataform assertions)

- Unique and non-null keys on every mart
- Weights of one lead always sum to 1
- Total leads in `fact_ad_lead_daily` equals the number of `matched` + `ambiguous` leads
