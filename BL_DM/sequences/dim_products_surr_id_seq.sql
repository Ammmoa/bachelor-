CREATE SEQUENCE IF NOT EXISTS bl_dm.dim_products_surr_id_seq START 1;

ALTER TABLE bl_dm.dim_products
ALTER COLUMN product_surr_id SET DEFAULT nextval('bl_dm.dim_products_surr_id_seq'); 