CREATE OR REPLACE VIEW thelook_raw.v_fact_order_items_enriched AS
SELECT
  oi.id AS order_item_id,
  oi.order_id,
  oi.user_id,
  oi.product_id,
  oi.inventory_item_id,
  oi.status AS order_item_status,
  oi.created_at,
  oi.shipped_at,
  oi.delivered_at,
  oi.returned_at,
  oi.sale_price::numeric AS sale_price,
  ii.cost::numeric AS inventory_cost,
  (oi.sale_price - ii.cost)::numeric AS margin_proxy,
  p.category,
  p.department,
  p.brand,
  p.retail_price::numeric AS retail_price,
  p.distribution_center_id,
  dc.name AS distribution_center_name,
  dc.latitude AS dc_latitude,
  dc.longitude AS dc_longitude
FROM thelook_raw.order_items oi
LEFT JOIN thelook_raw.inventory_items ii ON ii.id = oi.inventory_item_id
LEFT JOIN thelook_raw.products p ON p.id = oi.product_id
LEFT JOIN thelook_raw.distribution_centers dc ON dc.id = p.distribution_center_id;