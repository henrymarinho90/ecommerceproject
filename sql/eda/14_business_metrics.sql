-- Price sanity
SELECT
  COUNT(*) FILTER (WHERE sale_price IS NULL) AS null_sale_price,
  COUNT(*) FILTER (WHERE sale_price < 0) AS negative_sale_price,
  MIN(sale_price) AS min_sale_price,
  PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY sale_price) AS p50_sale_price,
  PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY sale_price) AS p95_sale_price,
  MAX(sale_price) AS max_sale_price
FROM thelook_raw.order_items;

-- Delivery timeline sanity (impossible sequences)
SELECT
  COUNT(*) FILTER (WHERE shipped_at IS NOT NULL AND created_at IS NOT NULL AND shipped_at < created_at) AS shipped_before_created,
  COUNT(*) FILTER (WHERE delivered_at IS NOT NULL AND shipped_at IS NOT NULL AND delivered_at < shipped_at) AS delivered_before_shipped,
  COUNT(*) FILTER (WHERE returned_at IS NOT NULL AND created_at IS NOT NULL AND returned_at < created_at) AS returned_before_created
FROM thelook_raw.order_items;

-- Orders status distribution
SELECT status, COUNT(*) AS orders
FROM thelook_raw.orders
GROUP BY 1
ORDER BY orders DESC;
