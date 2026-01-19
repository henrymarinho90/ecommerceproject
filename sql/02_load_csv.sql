\copy thelook_raw.distribution_centers FROM 'data/raw/distribution_centers.csv' WITH (FORMAT csv, HEADER true);
\copy thelook_raw.users               FROM 'data/raw/users.csv'               WITH (FORMAT csv, HEADER true);
\copy thelook_raw.products            FROM 'data/raw/products.csv'            WITH (FORMAT csv, HEADER true);
\copy thelook_raw.inventory_items     FROM 'data/raw/inventory_items.csv'     WITH (FORMAT csv, HEADER true);
\copy thelook_raw.orders              FROM 'data/raw/orders.csv'              WITH (FORMAT csv, HEADER true);
\copy thelook_raw.order_items         FROM 'data/raw/order_items.csv'         WITH (FORMAT csv, HEADER true);
\copy thelook_raw.events              FROM 'data/raw/events.csv'              WITH (FORMAT csv, HEADER true);
