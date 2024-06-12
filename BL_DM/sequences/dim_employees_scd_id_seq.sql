CREATE SEQUENCE IF NOT EXISTS bl_dm.dim_employees_scd_id_seq START 1;

ALTER TABLE bl_dm.dim_employees_scd 
ALTER COLUMN employee_surr_id SET DEFAULT nextval('bl_dm.dim_employees_scd_id_seq'); 