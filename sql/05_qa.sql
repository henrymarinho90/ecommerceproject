SELECT 'users' t, COUNT(*) c FROM thelook_raw.users
UNION ALL SELECT 'orders', COUNT(*) FROM thelook_raw.orders
UNION ALL SELECT 'order_items', COUNT(*) FROM thelook_raw.order_items
UNION ALL SELECT 'products', COUNT(*) FROM thelook_raw.products
UNION ALL SELECT 'inventory_items', COUNT(*) FROM thelook_raw.inventory_items
UNION ALL SELECT 'distribution_centers', COUNT(*) FROM thelook_raw.distribution_centers
UNION ALL SELECT 'events', COUNT(*) FROM thelook_raw.events;

SELECT COUNT(*) AS orphan_orders_users
FROM thelook_raw.orders o
LEFT JOIN thelook_raw.users u ON u.id = o.user_id
WHERE o.user_id IS NOT NULL AND u.id IS NULL;

SELECT COUNT(*) AS orphan_order_items_orders
FROM thelook_raw.order_items oi
LEFT JOIN thelook_raw.orders o ON o.order_id = oi.order_id
WHERE oi.order_id IS NOT NULL AND o.order_id IS NULL;

SELECT COUNT(*) AS orphan_order_items_products
FROM thelook_raw.order_items oi
LEFT JOIN thelook_raw.products p ON p.id = oi.product_id
WHERE oi.product_id IS NOT NULL AND p.id IS NULL;
