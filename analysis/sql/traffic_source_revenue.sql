SELECT
  o.user_traffic_source,
  SUM(oi.sale_price) AS revenue,
  COUNT(DISTINCT oi.order_id) AS orders,
  ROUND((SUM(oi.sale_price) / NULLIF(COUNT(DISTINCT oi.order_id),0))::numeric, 2) AS aov
FROM thelook_analytics.fact_orders_enriched o
JOIN thelook_analytics.fact_order_items_enriched oi
  ON oi.order_id = o.order_id
GROUP BY 1
ORDER BY revenue DESC;
