CREATE SEQUENCE IF NOT EXISTS bl_cl.t_map_brands_id_seq START 1;

ALTER TABLE bl_cl.t_map_brands 
ALTER COLUMN brand_id SET DEFAULT nextval('bl_cl.t_map_brands_id_seq');