DROP TABLE IF EXISTS thelook_analytics.mart_order_items_base;

CREATE TABLE thelook_analytics.mart_order_items_base AS
WITH bounds AS (
  SELECT MAX(created_at)::timestamptz AS max_ts
  FROM thelook_analytics.v_fact_order_items_enriched
),
base AS (
  SELECT
    v.order_item_id,
    v.order_id,
    v.user_id,
    v.product_id,
    v.inventory_item_id,

    v.created_at::timestamptz   AS created_at,
    v.shipped_at::timestamptz   AS shipped_at,
    v.delivered_at::timestamptz AS delivered_at,
    v.returned_at::timestamptz  AS returned_at,

    v.sale_price::numeric      AS sale_price,
    v.inventory_cost::numeric  AS inventory_cost,
    (v.sale_price - v.inventory_cost)::numeric AS margin_proxy,

    v.category,
    v.department,
    v.brand,

    v.distribution_center_id,
    v.distribution_center_name,

    CASE WHEN v.returned_at IS NOT NULL THEN 1 ELSE 0 END AS is_returned,
    EXTRACT(EPOCH FROM (v.delivered_at::timestamptz - v.shipped_at::timestamptz))/86400.0 AS ship_to_deliver_days
  FROM thelook_analytics.v_fact_order_items_enriched v
  WHERE v.created_at::timestamptz >= (SELECT max_ts - INTERVAL '12 months' FROM bounds)
),
dim_users AS (
  SELECT id AS user_id, traffic_source
  FROM thelook_raw.users
),
dim_products AS (
  -- NOTE: your products table key is id (not product_id). name exists.
  SELECT id AS product_id, name AS product_name
  FROM thelook_raw.products
)
SELECT
  b.*,

  -- ✅ Add a persisted month key for trends + indexing
  date_trunc('month', b.created_at)::date AS month,

  u.traffic_source::text AS user_traffic_source,
  p.product_name::text   AS product_name
FROM base b
LEFT JOIN dim_users u     ON u.user_id = b.user_id
LEFT JOIN dim_products p  ON p.product_id = b.product_id
;
