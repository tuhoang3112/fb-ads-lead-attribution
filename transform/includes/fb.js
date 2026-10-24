// Helpers shared by the staging models.

// Reads one UTM parameter for an ad creative.
// Looks in `url_tags` first (the "URL parameters" box in Ads Manager), then in the
// query string of `cta_link`. The character class excludes { and }, so an
// unresolved dynamic macro such as utm_content={{ad.name}} is NOT extracted
// as a value (it returns NULL and the next fallback is used).
function utmParam(name) {
  const pattern = `(?:^|[?&])${name}=([^&#\\s{}]+)`;
  return `LOWER(TRIM(COALESCE(
    REGEXP_EXTRACT(url_tags, r'${pattern}'),
    REGEXP_EXTRACT(cta_link, r'${pattern}')
  )))`;
}

// Sums the `value` of the given action types inside the `actions` JSON array
// of ads_insights. Returns 0 when the ad has none of those actions that day.
function actionValue(actionTypes) {
  const list = actionTypes.map((t) => `'${t}'`).join(", ");
  return `COALESCE((
    SELECT SUM(SAFE_CAST(JSON_VALUE(a, '$.value') AS FLOAT64))
    FROM UNNEST(JSON_QUERY_ARRAY(actions)) AS a
    WHERE JSON_VALUE(a, '$.action_type') IN (${list})
  ), 0)`;
}

module.exports = { utmParam, actionValue };
