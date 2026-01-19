CREATE TABLE IF NOT EXISTS thelook_raw.distribution_centers (
  id bigint PRIMARY KEY,
  name text,
  latitude double precision,
  longitude double precision
);

CREATE TABLE IF NOT EXISTS thelook_raw.users (
  id bigint PRIMARY KEY,
  first_name text,
  last_name text,
  email text,
  age int,
  gender text,
  state text,
  street_address text,
  postal_code text,
  city text,
  country text,
  latitude double precision,
  longitude double precision,
  traffic_source text,
  created_at timestamptz
);

CREATE TABLE IF NOT EXISTS thelook_raw.products (
  id bigint PRIMARY KEY,
  cost real,
  category text,
  name text,
  brand text,
  retail_price real,
  department text,
  sku text,
  distribution_center_id bigint
);

CREATE TABLE IF NOT EXISTS thelook_raw.inventory_items (
  id bigint PRIMARY KEY,
  product_id bigint,
  created_at timestamptz,
  sold_at timestamptz,
  cost real,
  product_category text,
  product_name text,
  product_brand text,
  product_retail_price real,
  product_department text,
  product_sku text,
  product_distribution_center_id bigint
);

CREATE TABLE IF NOT EXISTS thelook_raw.orders (
  order_id bigint PRIMARY KEY,
  user_id bigint,
  status text,
  gender text,
  created_at timestamptz,
  returned_at timestamptz,
  shipped_at timestamptz,
  delivered_at timestamptz,
  num_of_item int
);

CREATE TABLE IF NOT EXISTS thelook_raw.order_items (
  id bigint PRIMARY KEY,
  order_id bigint,
  user_id bigint,
  product_id bigint,
  inventory_item_id bigint,
  status text,
  created_at timestamptz,
  shipped_at timestamptz,
  delivered_at timestamptz,
  returned_at timestamptz,
  sale_price real
);

CREATE TABLE IF NOT EXISTS thelook_raw.events (
  id bigint PRIMARY KEY,
  user_id bigint,
  sequence_number bigint,
  session_id text,
  created_at timestamptz,
  ip_address text,
  city text,
  state text,
  postal_code text,
  browser text,
  traffic_source text,
  uri text,
  event_type text
);
