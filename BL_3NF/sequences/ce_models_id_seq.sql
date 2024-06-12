CREATE SEQUENCE IF NOT EXISTS bl_3nf.ce_models_id_seq START 1;

ALTER TABLE bl_3nf.ce_models
ALTER COLUMN model_id SET DEFAULT nextval('bl_3nf.ce_models_id_seq');