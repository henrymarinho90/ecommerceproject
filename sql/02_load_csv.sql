COPY thelook_raw.distribution_centers FROM 'C:\\dev\\ecommerceproject\\data\\raw\\distribution_centers.csv' WITH (FORMAT csv, HEADER true);
COPY thelook_raw.users               FROM 'C:\\dev\\ecommerceproject\\data\\raw\\users.csv'               WITH (FORMAT csv, HEADER true);
COPY thelook_raw.products            FROM 'C:\\dev\\ecommerceproject\\data\\raw\\products.csv'            WITH (FORMAT csv, HEADER true);
COPY thelook_raw.inventory_items     FROM 'C:\\dev\\ecommerceproject\\data\\raw\\inventory_items.csv'     WITH (FORMAT csv, HEADER true);
COPY thelook_raw.orders              FROM 'C:\\dev\\ecommerceproject\\data\\raw\\orders.csv'              WITH (FORMAT csv, HEADER true);
COPY thelook_raw.order_items         FROM 'C:\\dev\\ecommerceproject\\data\\raw\\order_items.csv'         WITH (FORMAT csv, HEADER true);
COPY thelook_raw.events              FROM 'C:\\dev\\ecommerceproject\\data\\raw\\events.csv'              WITH (FORMAT csv, HEADER true);
