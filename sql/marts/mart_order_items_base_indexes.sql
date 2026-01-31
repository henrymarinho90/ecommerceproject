CREATE INDEX IF NOT EXISTS idx_mart_base_created_at
  ON thelook_analytics.mart_order_items_base (created_at);

CREATE INDEX IF NOT EXISTS idx_mart_base_month
  ON thelook_analytics.mart_order_items_base (month);

CREATE INDEX IF NOT EXISTS idx_mart_base_product_id
  ON thelook_analytics.mart_order_items_base (product_id);

CREATE INDEX IF NOT EXISTS idx_mart_base_user_id
  ON thelook_analytics.mart_order_items_base (user_id);

CREATE INDEX IF NOT EXISTS idx_mart_base_order_id
  ON thelook_analytics.mart_order_items_base (order_id);

CREATE INDEX IF NOT EXISTS idx_mart_base_traffic_source
  ON thelook_analytics.mart_order_items_base (user_traffic_source);
