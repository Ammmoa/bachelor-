CREATE SEQUENCE IF NOT EXISTS bl_3nf.ce_brands_id_seq START 1;

ALTER TABLE bl_3nf.ce_brands 
ALTER COLUMN brand_id SET DEFAULT nextval('bl_3nf.ce_brands_id_seq');