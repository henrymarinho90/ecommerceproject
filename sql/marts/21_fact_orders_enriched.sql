CREATE OR REPLACE VIEW thelook_raw.v_fact_orders_enriched AS
SELECT
  o.order_id,
  o.user_id,
  o.status AS order_status,
  o.gender,
  o.created_at,
  o.shipped_at,
  o.delivered_at,
  o.returned_at,
  o.num_of_item,
  u.country,
  u.state,
  u.city,
  u.traffic_source AS user_traffic_source,
  u.created_at AS user_created_at
FROM thelook_raw.orders o
LEFT JOIN thelook_raw.users u ON u.id = o.user_id;
