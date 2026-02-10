DROP TABLE IF EXISTS thelook_analytics.mart_top_products;

CREATE TABLE thelook_analytics.mart_top_products AS
SELECT
  product_id,
  COALESCE(product_name, 'Unknown') AS product_name,
  COALESCE(product_name, 'Unknown') || ' (ID ' || product_id::text || ')' AS product_label,
  category, -- Adding category for better filtering
  brand, -- Adding brand for better filtering
  department, -- Adding department for better filtering (if needed)

  COUNT(*) AS order_items,
  COUNT(DISTINCT order_id) AS orders,
  SUM(sale_price)::numeric(18,2) AS revenue,
  SUM(margin_proxy)::numeric(18,2) AS margin_proxy,
  (SUM(margin_proxy) / NULLIF(SUM(sale_price),0))::numeric(18,4) AS margin_rate_proxy,
  (AVG(is_returned::numeric))::numeric(18,4) AS return_rate
FROM thelook_analytics.mart_order_items_base
GROUP BY product_id, product_name, category, brand, department -- Ensure grouping by these columns for easier filtering
ORDER BY revenue DESC
LIMIT 200;
