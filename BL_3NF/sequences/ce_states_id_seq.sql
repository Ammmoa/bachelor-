CREATE SEQUENCE IF NOT EXISTS bl_3nf.ce_states_id_seq START 1;

ALTER TABLE bl_3nf.ce_states 
ALTER COLUMN state_id SET DEFAULT nextval('bl_3nf.ce_states_id_seq'); 