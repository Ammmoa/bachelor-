BEGIN;

INSERT INTO BL_3NF.CE_COLORS (COLOR_ID, COLOR, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)

	SELECT nextval('bl_3nf.ce_colors_id_seq'), * 
	FROM (
		SELECT DISTINCT color, current_date, current_date, 'BL_CL', 'T_MAP_COLORS', min(color_id)
		FROM BL_CL.t_map_colors 
		GROUP BY color
	) AS colors_vals (COLOR, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
	
	WHERE NOT EXISTS (SELECT * FROM BL_3NF.CE_COLORS c WHERE c.color = colors_vals.color)
	
RETURNING *;

COMMIT;

-- colors