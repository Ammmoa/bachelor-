CREATE SEQUENCE IF NOT EXISTS bl_3nf.ce_colors_id_seq START 1;

ALTER TABLE bl_3nf.ce_colors
ALTER COLUMN color_id SET DEFAULT nextval('bl_3nf.ce_colors_id_seq');