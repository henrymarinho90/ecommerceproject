-- Row counts
SELECT 'users' AS table, COUNT(*) AS rows FROM thelook_raw.users
UNION ALL SELECT 'events', COUNT(*) FROM thelook_raw.events
UNION ALL SELECT 'orders', COUNT(*) FROM thelook_raw.orders
UNION ALL SELECT 'order_items', COUNT(*) FROM thelook_raw.order_items
UNION ALL SELECT 'products', COUNT(*) FROM thelook_raw.products
UNION ALL SELECT 'inventory_items', COUNT(*) FROM thelook_raw.inventory_items
UNION ALL SELECT 'distribution_centers', COUNT(*) FROM thelook_raw.distribution_centers
ORDER BY rows DESC;

-- Date ranges (sanity)
SELECT 'events' AS table, MIN(created_at) AS min_dt, MAX(created_at) AS max_dt FROM thelook_raw.events
UNION ALL SELECT 'orders', MIN(created_at), MAX(created_at) FROM thelook_raw.orders
UNION ALL SELECT 'order_items', MIN(created_at), MAX(created_at) FROM thelook_raw.order_items
UNION ALL SELECT 'inventory_items', MIN(created_at), MAX(created_at) FROM thelook_raw.inventory_items
UNION ALL SELECT 'users', MIN(created_at), MAX(created_at) FROM thelook_raw.users;
