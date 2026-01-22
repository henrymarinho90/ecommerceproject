-- C:\dev\ecommerceproject\sql\returns_profitability\10_returns_profitability.sql
-- Returns & Profitability outputs (Postgres)
-- Uses the stable "last 12 months from max date" window.

-- IMPORTANT:
-- This script assumes you have this view:
--   thelook_analytics.v_fact_order_items_enriched
-- If your view is still in thelook_raw, change the FROM clause everywhere.

-- C:\dev\ecommerceproject\sql\returns_profitability\10_returns_profitability.sql
-- 1) Overall Returns KPIs (Last 12 months from max date)

WITH bounds AS (
  SELECT MAX(created_at)::timestamptz AS max_ts
  FROM thelook_analytics.v_fact_order_items_enriched
),
base AS (
  SELECT *
  FROM thelook_analytics.v_fact_order_items_enriched
  WHERE created_at >= (SELECT max_ts - INTERVAL '12 months' FROM bounds)
)
SELECT
  COUNT(*) AS order_items,
  COUNT(*) FILTER (WHERE returned_at IS NOT NULL) AS returned_items,
  ROUND((COUNT(*) FILTER (WHERE returned_at IS NOT NULL))::numeric / NULLIF(COUNT(*), 0), 4) AS return_rate,

  SUM(sale_price) AS revenue,
  SUM(inventory_cost) AS cost,

  SUM(sale_price - inventory_cost) AS margin_proxy,
  ROUND((SUM(sale_price - inventory_cost) / NULLIF(SUM(sale_price), 0))::numeric, 4) AS margin_rate_proxy
FROM base;


-- 2) Returns by Month (trend)
WITH bounds AS (
  SELECT MAX(created_at)::timestamptz AS max_ts
  FROM thelook_analytics.v_fact_order_items_enriched
),
base AS (
  SELECT *
  FROM thelook_analytics.v_fact_order_items_enriched
  WHERE created_at >= (SELECT max_ts - INTERVAL '12 months' FROM bounds)
),
monthly AS (
  SELECT
    DATE_TRUNC('month', created_at) AS month,
    COUNT(*) AS order_items,
    COUNT(*) FILTER (WHERE returned_at IS NOT NULL) AS returned_items,
    ROUND(
      (COUNT(*) FILTER (WHERE returned_at IS NOT NULL))::numeric / NULLIF(COUNT(*),0),
      4
    ) AS return_rate,
    SUM(sale_price) AS revenue,
    SUM(inventory_cost) AS cost,
    SUM(sale_price - inventory_cost) AS margin_proxy,
    ROUND(
      (SUM(sale_price - inventory_cost) / NULLIF(SUM(sale_price),0))::numeric,
      4
    ) AS margin_rate_proxy
  FROM base
  GROUP BY 1
)
SELECT *
FROM monthly
ORDER BY month;

-- 3) Returns by Category (top 25 by revenue)
WITH bounds AS (
  SELECT MAX(created_at)::timestamptz AS max_ts
  FROM thelook_analytics.v_fact_order_items_enriched
),
base AS (
  SELECT *
  FROM thelook_analytics.v_fact_order_items_enriched
  WHERE created_at::timestamptz >= (SELECT max_ts - INTERVAL '12 months' FROM bounds)
),
cat AS (
  SELECT
    category,
    COUNT(*) AS order_items,
    COUNT(*) FILTER (WHERE returned_at IS NOT NULL) AS returned_items,
    ROUND((COUNT(*) FILTER (WHERE returned_at IS NOT NULL))::numeric / NULLIF(COUNT(*),0), 4) AS return_rate,
    SUM(sale_price) AS revenue,
    SUM(sale_price - inventory_cost) AS margin_proxy,
    ROUND((SUM(sale_price - inventory_cost) / NULLIF(SUM(sale_price),0))::numeric, 4) AS margin_rate_proxy
  FROM base
  GROUP BY 1
)
SELECT *
FROM cat
ORDER BY revenue DESC
LIMIT 25;

-- 4) Returns by Brand (top 25 by revenue)
WITH bounds AS (
  SELECT MAX(created_at)::timestamptz AS max_ts
  FROM thelook_analytics.v_fact_order_items_enriched
),
base AS (
  SELECT *
  FROM thelook_analytics.v_fact_order_items_enriched
  WHERE created_at::timestamptz >= (SELECT max_ts - INTERVAL '12 months' FROM bounds)
),
b AS (
  SELECT
    brand,
    COUNT(*) AS order_items,
    COUNT(*) FILTER (WHERE returned_at IS NOT NULL) AS returned_items,
    ROUND((COUNT(*) FILTER (WHERE returned_at IS NOT NULL))::numeric / NULLIF(COUNT(*),0), 4) AS return_rate,
    SUM(sale_price) AS revenue,
    SUM(sale_price - inventory_cost) AS margin_proxy,
    ROUND((SUM(sale_price - inventory_cost) / NULLIF(SUM(sale_price),0))::numeric, 4) AS margin_rate_proxy
  FROM base
  GROUP BY 1
)
SELECT *
FROM b
ORDER BY revenue DESC
LIMIT 25;

-- 5) Returns by Traffic Source (join users to get traffic_source)
WITH bounds AS (
  SELECT MAX(created_at)::timestamptz AS max_ts
  FROM thelook_analytics.v_fact_order_items_enriched
),
base AS (
  SELECT
    f.*,
    u.traffic_source AS user_traffic_source
  FROM thelook_analytics.v_fact_order_items_enriched f
  LEFT JOIN thelook_raw.users u
    ON u.id = f.user_id
  WHERE f.created_at::timestamptz >= (SELECT max_ts - INTERVAL '12 months' FROM bounds)
)
SELECT
  COALESCE(user_traffic_source, 'Unknown') AS user_traffic_source,
  COUNT(*) AS order_items,
  COUNT(*) FILTER (WHERE returned_at IS NOT NULL) AS returned_items,
  ROUND((COUNT(*) FILTER (WHERE returned_at IS NOT NULL))::numeric / NULLIF(COUNT(*),0), 4) AS return_rate,
  SUM(sale_price) AS revenue,
  SUM(inventory_cost) AS cost,
  SUM(sale_price - inventory_cost) AS margin_proxy,
  ROUND((SUM(sale_price - inventory_cost) / NULLIF(SUM(sale_price),0))::numeric, 4) AS margin_rate_proxy
FROM base
GROUP BY 1
ORDER BY revenue DESC;


-- 6) Fulfillment vs Returns (delivery-time deciles)
WITH bounds AS (
  SELECT MAX(created_at)::timestamptz AS max_ts
  FROM thelook_analytics.v_fact_order_items_enriched
),
base AS (
  SELECT
    *,
    EXTRACT(EPOCH FROM (delivered_at::timestamptz - shipped_at::timestamptz))/86400.0 AS ship_to_deliver_days,
    CASE WHEN returned_at IS NOT NULL THEN 1 ELSE 0 END AS is_returned
  FROM thelook_analytics.v_fact_order_items_enriched
  WHERE created_at::timestamptz >= (SELECT max_ts - INTERVAL '12 months' FROM bounds)
    AND shipped_at IS NOT NULL
    AND delivered_at IS NOT NULL
),
scored AS (
  SELECT
    *,
    NTILE(10) OVER (ORDER BY ship_to_deliver_days) AS delivery_decile
  FROM base
)
SELECT
  delivery_decile,
  COUNT(*) AS items,
  SUM(is_returned) AS returned_items,
  ROUND(SUM(is_returned)::numeric / NULLIF(COUNT(*), 0), 4) AS return_rate,
  ROUND(AVG(ship_to_deliver_days)::numeric, 2) AS avg_ship_to_deliver_days
FROM scored
GROUP BY delivery_decile
ORDER BY delivery_decile;
