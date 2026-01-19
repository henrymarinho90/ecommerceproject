-- Null profiling for key columns
SELECT
  'orders.user_id' AS field,
  COUNT(*) FILTER (WHERE user_id IS NULL) AS null_rows,
  COUNT(*) AS total_rows,
  ROUND(100.0 * COUNT(*) FILTER (WHERE user_id IS NULL) / NULLIF(COUNT(*),0), 2) AS null_pct
FROM thelook_raw.orders
UNION ALL
SELECT
  'order_items.order_id',
  COUNT(*) FILTER (WHERE order_id IS NULL),
  COUNT(*),
  ROUND(100.0 * COUNT(*) FILTER (WHERE order_id IS NULL) / NULLIF(COUNT(*),0), 2)
FROM thelook_raw.order_items
UNION ALL
SELECT
  'order_items.user_id',
  COUNT(*) FILTER (WHERE user_id IS NULL),
  COUNT(*),
  ROUND(100.0 * COUNT(*) FILTER (WHERE user_id IS NULL) / NULLIF(COUNT(*),0), 2)
FROM thelook_raw.order_items
UNION ALL
SELECT
  'order_items.product_id',
  COUNT(*) FILTER (WHERE product_id IS NULL),
  COUNT(*),
  ROUND(100.0 * COUNT(*) FILTER (WHERE product_id IS NULL) / NULLIF(COUNT(*),0), 2)
FROM thelook_raw.order_items
UNION ALL
SELECT
  'order_items.inventory_item_id',
  COUNT(*) FILTER (WHERE inventory_item_id IS NULL),
  COUNT(*),
  ROUND(100.0 * COUNT(*) FILTER (WHERE inventory_item_id IS NULL) / NULLIF(COUNT(*),0), 2)
FROM thelook_raw.order_items
UNION ALL
SELECT
  'inventory_items.product_id',
  COUNT(*) FILTER (WHERE product_id IS NULL),
  COUNT(*),
  ROUND(100.0 * COUNT(*) FILTER (WHERE product_id IS NULL) / NULLIF(COUNT(*),0), 2)
FROM thelook_raw.inventory_items
UNION ALL
SELECT
  'products.distribution_center_id',
  COUNT(*) FILTER (WHERE distribution_center_id IS NULL),
  COUNT(*),
  ROUND(100.0 * COUNT(*) FILTER (WHERE distribution_center_id IS NULL) / NULLIF(COUNT(*),0), 2)
FROM thelook_raw.products
UNION ALL
SELECT
  'events.user_id',
  COUNT(*) FILTER (WHERE user_id IS NULL),
  COUNT(*),
  ROUND(100.0 * COUNT(*) FILTER (WHERE user_id IS NULL) / NULLIF(COUNT(*),0), 2)
FROM thelook_raw.events
ORDER BY null_pct DESC;
