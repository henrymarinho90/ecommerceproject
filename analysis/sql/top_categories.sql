WITH bounds AS (
  SELECT MAX(created_at)::date AS max_dt
  FROM thelook_analytics.fact_order_items_enriched
),
base AS (
  SELECT *
  FROM thelook_analytics.fact_order_items_enriched
  WHERE created_at >= (SELECT max_dt - INTERVAL '12 months' FROM bounds)
)
SELECT
  category,
  SUM(sale_price) AS revenue,
  SUM(margin_proxy) AS margin_proxy,
  ROUND((SUM(margin_proxy) / NULLIF(SUM(sale_price),0))::numeric, 4) AS margin_rate_proxy
FROM base
GROUP BY 1
ORDER BY revenue DESC
LIMIT 15;
