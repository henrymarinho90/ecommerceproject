WITH order_item_enriched AS (
  SELECT
    oi.id AS order_item_id,
    oi.order_id,
    oi.user_id,
    oi.product_id,
    oi.inventory_item_id,
    oi.status AS order_item_status,
    oi.created_at::date AS order_item_date,
    oi.sale_price,
    ii.cost AS inventory_cost,
    p.category,
    p.department,
    p.brand,
    p.retail_price
  FROM thelook_raw.order_items oi
  LEFT JOIN thelook_raw.inventory_items ii ON ii.id = oi.inventory_item_id
  LEFT JOIN thelook_raw.products p ON p.id = oi.product_id
),
monthly AS (
  SELECT
    DATE_TRUNC('month', order_item_date)::date AS month,
    COUNT(DISTINCT order_id) AS orders,
    COUNT(*) AS order_items,
    SUM(sale_price)::numeric AS revenue,
    AVG(sale_price)::numeric AS avg_item_price,
    SUM(
      CASE WHEN inventory_cost IS NOT NULL THEN (sale_price - inventory_cost) END
    )::numeric AS gross_margin_proxy,
    AVG(
      CASE WHEN inventory_cost IS NOT NULL THEN (sale_price - inventory_cost) END
    )::numeric AS avg_margin_per_item_proxy,
    COUNT(*) FILTER (WHERE order_item_status ILIKE '%return%') AS returned_items
  FROM order_item_enriched
  GROUP BY 1
)
SELECT
  month,
  orders,
  order_items,
  revenue,
  ROUND((revenue / NULLIF(orders,0))::numeric, 2) AS aov,
  gross_margin_proxy,
  ROUND(avg_margin_per_item_proxy, 2) AS avg_margin_per_item_proxy,
  returned_items,
  ROUND((100.0 * returned_items / NULLIF(order_items,0))::numeric, 2) AS return_rate_items_pct,
  ROUND(
    (
      100.0 * (revenue - LAG(revenue) OVER (ORDER BY month))
      / NULLIF(LAG(revenue) OVER (ORDER BY month),0)
    )::numeric
  , 2) AS revenue_mom_pct
FROM monthly
ORDER BY month;
