CREATE SEQUENCE IF NOT EXISTS bl_cl.t_map_states_id_seq START 1;

ALTER TABLE bl_cl.t_map_states 
ALTER COLUMN state_id SET DEFAULT nextval('bl_cl.t_map_states_id_seq');