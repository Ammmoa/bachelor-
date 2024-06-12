CREATE SEQUENCE IF NOT EXISTS bl_3nf.ce_employees_scd_id_seq START 1;

ALTER TABLE bl_3nf.ce_employees_scd 
ALTER COLUMN employee_id SET DEFAULT nextval('bl_3nf.ce_employees_scd_id_seq');