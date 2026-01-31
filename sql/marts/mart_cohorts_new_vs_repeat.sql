DROP TABLE IF EXISTS thelook_analytics.mart_cohorts_new_vs_repeat;

CREATE TABLE thelook_analytics.mart_cohorts_new_vs_repeat AS
WITH first_purchase AS (
  SELECT
    user_id,
    MIN(created_at)::timestamptz AS first_purchase_ts
  FROM thelook_analytics.mart_order_items_base
  GROUP BY 1
),
labeled AS (
  SELECT
    b.*,
    fp.first_purchase_ts,
    CASE
      WHEN b.created_at::timestamptz = fp.first_purchase_ts THEN 'new_customer'
      ELSE 'repeat_customer'
    END AS customer_type
  FROM thelook_analytics.mart_order_items_base b
  JOIN first_purchase fp USING (user_id)
)
SELECT
  date_trunc('month', created_at)::date AS month,
  customer_type,
  COUNT(*) AS order_items,
  COUNT(DISTINCT order_id) AS orders,
  COUNT(DISTINCT user_id) AS customers,
  (AVG(is_returned::numeric))::numeric(18,4) AS return_rate,
  SUM(sale_price)::numeric(18,2) AS revenue,
  SUM(margin_proxy)::numeric(18,2) AS margin_proxy
FROM labeled
GROUP BY 1,2
ORDER BY 1,2;
