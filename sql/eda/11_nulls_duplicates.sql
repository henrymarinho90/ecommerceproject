-- Duplicate primary keys (should be 0 rows)
SELECT 'users' AS table, id, COUNT(*) c
FROM thelook_raw.users
GROUP BY 1,2
HAVING COUNT(*) > 1;

SELECT 'orders' AS table, order_id, COUNT(*) c
FROM thelook_raw.orders
GROUP BY 1,2
HAVING COUNT(*) > 1;

SELECT 'order_items' AS table, id, COUNT(*) c
FROM thelook_raw.order_items
GROUP BY 1,2
HAVING COUNT(*) > 1;

SELECT 'products' AS table, id, COUNT(*) c
FROM thelook_raw.products
GROUP BY 1,2
HAVING COUNT(*) > 1;

SELECT 'inventory_items' AS table, id, COUNT(*) c
FROM thelook_raw.inventory_items
GROUP BY 1,2
HAVING COUNT(*) > 1;

SELECT 'distribution_centers' AS table, id, COUNT(*) c
FROM thelook_raw.distribution_centers
GROUP BY 1,2
HAVING COUNT(*) > 1;

SELECT 'events' AS table, id, COUNT(*) c
FROM thelook_raw.events
GROUP BY 1,2
HAVING COUNT(*) > 1;
