CREATE SEQUENCE IF NOT EXISTS bl_3nf.ce_customers_id_seq START 1;

ALTER TABLE bl_3nf.ce_customers 
ALTER COLUMN customer_id SET DEFAULT nextval('bl_3nf.ce_customers_id_seq');