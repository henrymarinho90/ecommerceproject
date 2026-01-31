DROP TABLE IF EXISTS thelook_analytics.mart_traffic_source_quality;

CREATE TABLE thelook_analytics.mart_traffic_source_quality AS
SELECT
  COALESCE(user_traffic_source, 'UNKNOWN') AS user_traffic_source,
  COUNT(*) AS order_items,
  COUNT(DISTINCT order_id) AS orders,
  COUNT(DISTINCT user_id) AS customers,
  SUM(sale_price)::numeric(18,2) AS revenue,
  (SUM(sale_price) / NULLIF(COUNT(DISTINCT order_id),0))::numeric(18,2) AS aov,
  SUM(margin_proxy)::numeric(18,2) AS margin_proxy,
  (SUM(margin_proxy) / NULLIF(SUM(sale_price),0))::numeric(18,4) AS margin_rate_proxy,
  (AVG(is_returned::numeric))::numeric(18,4) AS return_rate
FROM thelook_analytics.mart_order_items_base
GROUP BY 1
ORDER BY revenue DESC;
