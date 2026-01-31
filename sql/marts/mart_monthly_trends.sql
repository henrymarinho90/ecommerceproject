DROP TABLE IF EXISTS thelook_analytics.mart_monthly_overall;
DROP TABLE IF EXISTS thelook_analytics.mart_monthly_by_category;
DROP TABLE IF EXISTS thelook_analytics.mart_monthly_by_traffic_source;

-- Overall
CREATE TABLE thelook_analytics.mart_monthly_overall AS
SELECT
  date_trunc('month', created_at)::date AS month,
  COUNT(*) AS order_items,
  COUNT(DISTINCT order_id) AS orders,
  SUM(is_returned)::int AS returned_items,
  (AVG(is_returned::numeric))::numeric(18,4) AS return_rate,
  SUM(sale_price)::numeric(18,2) AS revenue,
  SUM(margin_proxy)::numeric(18,2) AS margin_proxy,
  (SUM(margin_proxy)/NULLIF(SUM(sale_price),0))::numeric(18,4) AS margin_rate_proxy,
  (SUM(sale_price)/NULLIF(COUNT(DISTINCT order_id),0))::numeric(18,2) AS aov
FROM thelook_analytics.mart_order_items_base
GROUP BY 1
ORDER BY 1;

-- By Category
CREATE TABLE thelook_analytics.mart_monthly_by_category AS
SELECT
  date_trunc('month', created_at)::date AS month,
  COALESCE(category,'Unknown') AS category,
  COUNT(*) AS order_items,
  COUNT(DISTINCT order_id) AS orders,
  (AVG(is_returned::numeric))::numeric(18,4) AS return_rate,
  SUM(sale_price)::numeric(18,2) AS revenue,
  SUM(margin_proxy)::numeric(18,2) AS margin_proxy,
  (SUM(margin_proxy)/NULLIF(SUM(sale_price),0))::numeric(18,4) AS margin_rate_proxy
FROM thelook_analytics.mart_order_items_base
GROUP BY 1,2
ORDER BY 1,2;

-- By Traffic Source
CREATE TABLE thelook_analytics.mart_monthly_by_traffic_source AS
SELECT
  date_trunc('month', created_at)::date AS month,
  COALESCE(user_traffic_source,'UNKNOWN') AS user_traffic_source,
  COUNT(*) AS order_items,
  COUNT(DISTINCT order_id) AS orders,
  (AVG(is_returned::numeric))::numeric(18,4) AS return_rate,
  SUM(sale_price)::numeric(18,2) AS revenue,
  SUM(margin_proxy)::numeric(18,2) AS margin_proxy,
  (SUM(margin_proxy)/NULLIF(SUM(sale_price),0))::numeric(18,4) AS margin_rate_proxy,
  (SUM(sale_price)/NULLIF(COUNT(DISTINCT order_id),0))::numeric(18,2) AS aov
FROM thelook_analytics.mart_order_items_base
GROUP BY 1,2
ORDER BY 1,2;
