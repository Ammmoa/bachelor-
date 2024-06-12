CREATE SEQUENCE IF NOT EXISTS bl_3nf.ce_sales_id_seq START 1;

ALTER TABLE bl_3nf.ce_sales 
ALTER COLUMN sale_id SET DEFAULT nextval('bl_3nf.ce_sales_id_seq'); 