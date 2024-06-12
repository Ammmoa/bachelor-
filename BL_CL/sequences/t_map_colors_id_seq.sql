CREATE SEQUENCE IF NOT EXISTS bl_cl.t_map_colors_id_seq START 1;

ALTER TABLE bl_cl.t_map_colors 
ALTER COLUMN color_id SET DEFAULT nextval('bl_cl.t_map_colors_id_seq'); 