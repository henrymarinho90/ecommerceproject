DROP TABLE IF EXISTS thelook_analytics.mart_fulfillment_deciles;

CREATE TABLE thelook_analytics.mart_fulfillment_deciles AS
WITH clean AS (
  SELECT *
  FROM thelook_analytics.mart_order_items_base
  WHERE ship_to_deliver_days IS NOT NULL
    AND ship_to_deliver_days >= 0
),
ranked AS (
  SELECT
    *,
    NTILE(10) OVER (ORDER BY ship_to_deliver_days) AS delivery_decile
  FROM clean
)
SELECT
  delivery_decile,
  COUNT(*) AS items,
  SUM(is_returned)::int AS returned_items,
  (AVG(is_returned::numeric))::numeric(18,4) AS return_rate,
  AVG(ship_to_deliver_days)::numeric(18,2) AS avg_ship_to_deliver_days
FROM ranked
GROUP BY 1
ORDER BY 1;
