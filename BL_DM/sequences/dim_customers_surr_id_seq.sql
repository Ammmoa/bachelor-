CREATE SEQUENCE IF NOT EXISTS bl_dm.dim_customers_surr_id_seq START 1;

ALTER TABLE bl_dm.dim_customers
ALTER COLUMN customer_surr_id SET DEFAULT nextval('bl_dm.dim_customers_surr_id_seq');