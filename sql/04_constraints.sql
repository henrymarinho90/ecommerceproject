ALTER TABLE thelook_raw.orders
  ADD CONSTRAINT orders_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES thelook_raw.users(id) NOT VALID;

ALTER TABLE thelook_raw.order_items
  ADD CONSTRAINT order_items_order_id_fkey
  FOREIGN KEY (order_id) REFERENCES thelook_raw.orders(order_id) NOT VALID;

ALTER TABLE thelook_raw.order_items
  ADD CONSTRAINT order_items_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES thelook_raw.users(id) NOT VALID;

ALTER TABLE thelook_raw.order_items
  ADD CONSTRAINT order_items_product_id_fkey
  FOREIGN KEY (product_id) REFERENCES thelook_raw.products(id) NOT VALID;

ALTER TABLE thelook_raw.order_items
  ADD CONSTRAINT order_items_inventory_item_id_fkey
  FOREIGN KEY (inventory_item_id) REFERENCES thelook_raw.inventory_items(id) NOT VALID;

ALTER TABLE thelook_raw.inventory_items
  ADD CONSTRAINT inventory_items_product_id_fkey
  FOREIGN KEY (product_id) REFERENCES thelook_raw.products(id) NOT VALID;

ALTER TABLE thelook_raw.products
  ADD CONSTRAINT products_distribution_center_id_fkey
  FOREIGN KEY (distribution_center_id) REFERENCES thelook_raw.distribution_centers(id) NOT VALID;

ALTER TABLE thelook_raw.inventory_items
  ADD CONSTRAINT inventory_items_product_distribution_center_id_fkey
  FOREIGN KEY (product_distribution_center_id) REFERENCES thelook_raw.distribution_centers(id) NOT VALID;

ALTER TABLE thelook_raw.events
  ADD CONSTRAINT events_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES thelook_raw.users(id) NOT VALID;
