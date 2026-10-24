-- Ad hoc analysis on the Facebook Ads mart (BigQuery).
-- Run these in the BigQuery console to answer a quick question without opening the dashboard.
-- Replace `your-project-id` and the dates. All queries read only the mart tables.

-- 1. Performance by course in a period
SELECT
  a.course_name,
  SUM(f.spend) AS spend,
  SUM(f.impressions) AS impressions,
  SUM(f.inline_link_clicks) AS link_clicks,
  SUM(f.landing_page_views) AS landing_page_views,
  SAFE_DIVIDE(SUM(f.inline_link_clicks), SUM(f.impressions)) AS ctr,
  SAFE_DIVIDE(SUM(f.spend), SUM(f.inline_link_clicks)) AS cpc
FROM `your-project-id.dm_facebook_ads.fact_ad_performance` f
JOIN `your-project-id.dm_facebook_ads.dim_ads` a USING (ad_id)
WHERE f.date_start BETWEEN '2026-03-01' AND '2026-03-31'
GROUP BY a.course_name
ORDER BY spend DESC;


-- 2. The funnel up to the landing page, per campaign objective
SELECT
  c.campaign_objective,
  SUM(f.impressions) AS impressions,
  SUM(f.inline_link_clicks) AS link_clicks,
  SUM(f.landing_page_views) AS landing_page_views,
  SAFE_DIVIDE(SUM(f.landing_page_views), SUM(f.inline_link_clicks)) AS lpv_rate
FROM `your-project-id.dm_facebook_ads.fact_ad_performance` f
JOIN `your-project-id.dm_facebook_ads.dim_ads` a USING (ad_id)
JOIN `your-project-id.dm_facebook_ads.dim_ad_sets` s USING (ad_set_id)
JOIN `your-project-id.dm_facebook_ads.dim_campaigns` c USING (campaign_id)
WHERE f.date_start >= '2026-01-01'
GROUP BY c.campaign_objective
ORDER BY impressions DESC;


-- 3. Ads that spent money but cannot be matched to leads (no UTM)
SELECT
  a.ad_id,
  a.ad_name,
  a.ad_cta_link,
  SUM(f.spend) AS spend
FROM `your-project-id.dm_facebook_ads.dim_ads` a
JOIN `your-project-id.dm_facebook_ads.fact_ad_performance` f USING (ad_id)
WHERE a.ad_utm_campaign IS NULL OR a.ad_utm_content IS NULL
GROUP BY a.ad_id, a.ad_name, a.ad_cta_link
ORDER BY spend DESC;


-- 4. Ads with no course (a new naming pattern that needs a row in dim_ad_course_mapping)
SELECT a.ad_id, a.ad_name
FROM `your-project-id.dm_facebook_ads.dim_ads` a
WHERE a.course_name IS NULL;
