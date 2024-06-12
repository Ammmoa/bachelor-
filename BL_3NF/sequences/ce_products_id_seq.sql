CREATE SEQUENCE IF NOT EXISTS bl_3nf.ce_products_id_seq START 1;

ALTER TABLE bl_3nf.ce_products
ALTER COLUMN product_id SET DEFAULT nextval('bl_3nf.ce_products_id_seq');  