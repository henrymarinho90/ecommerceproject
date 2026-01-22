SELECT
  PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY (delivered_at::date - created_at::date)) AS p50_days_to_deliver,
  PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY (delivered_at::date - created_at::date)) AS p90_days_to_deliver,
  AVG((delivered_at::date - created_at::date)) AS avg_days_to_deliver
FROM thelook_analytics.fact_order_items_enriched
WHERE delivered_at IS NOT NULL AND created_at IS NOT NULL;
