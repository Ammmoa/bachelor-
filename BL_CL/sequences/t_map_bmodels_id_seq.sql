CREATE SEQUENCE IF NOT EXISTS bl_cl.t_map_bmodels_id_seq START 1;

ALTER TABLE bl_cl.t_map_bmodels 
ALTER COLUMN bmodel_id SET DEFAULT nextval('bl_cl.t_map_bmodels_id_seq'); 