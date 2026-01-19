-- Orphan checks (should be 0 if fully consistent; if not, document counts)

-- orders -> users
SELECT COUNT(*) AS orphan_orders_users
FROM thelook_raw.orders o
LEFT JOIN thelook_raw.users u ON u.id = o.user_id
WHERE o.user_id IS NOT NULL AND u.id IS NULL;

-- order_items -> orders
SELECT COUNT(*) AS orphan_order_items_orders
FROM thelook_raw.order_items oi
LEFT JOIN thelook_raw.orders o ON o.order_id = oi.order_id
WHERE oi.order_id IS NOT NULL AND o.order_id IS NULL;

-- order_items -> users
SELECT COUNT(*) AS orphan_order_items_users
FROM thelook_raw.order_items oi
LEFT JOIN thelook_raw.users u ON u.id = oi.user_id
WHERE oi.user_id IS NOT NULL AND u.id IS NULL;

-- order_items -> products
SELECT COUNT(*) AS orphan_order_items_products
FROM thelook_raw.order_items oi
LEFT JOIN thelook_raw.products p ON p.id = oi.product_id
WHERE oi.product_id IS NOT NULL AND p.id IS NULL;

-- order_items -> inventory_items
SELECT COUNT(*) AS orphan_order_items_inventory_items
FROM thelook_raw.order_items oi
LEFT JOIN thelook_raw.inventory_items ii ON ii.id = oi.inventory_item_id
WHERE oi.inventory_item_id IS NOT NULL AND ii.id IS NULL;

-- inventory_items -> products
SELECT COUNT(*) AS orphan_inventory_items_products
FROM thelook_raw.inventory_items ii
LEFT JOIN thelook_raw.products p ON p.id = ii.product_id
WHERE ii.product_id IS NOT NULL AND p.id IS NULL;

-- products -> distribution_centers
SELECT COUNT(*) AS orphan_products_distribution_centers
FROM thelook_raw.products p
LEFT JOIN thelook_raw.distribution_centers dc ON dc.id = p.distribution_center_id
WHERE p.distribution_center_id IS NOT NULL AND dc.id IS NULL;

-- events -> users
SELECT COUNT(*) AS orphan_events_users
FROM thelook_raw.events e
LEFT JOIN thelook_raw.users u ON u.id = e.user_id
WHERE e.user_id IS NOT NULL AND u.id IS NULL;
