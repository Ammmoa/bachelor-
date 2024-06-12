CREATE OR REPLACE PROCEDURE BL_CL.prc_load_ce_colors()
LANGUAGE plpgsql
AS $$
DECLARE
	rows_affected int;
BEGIN 
		
	WITH load_query AS 
	(
		INSERT INTO BL_3NF.CE_COLORS (COLOR_ID, COLOR, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)

		SELECT nextval('bl_3nf.ce_colors_id_seq'), * 
		FROM (
			SELECT DISTINCT color, current_date, current_date, 'BL_CL', 'T_MAP_COLORS', min(color_id)
			FROM BL_CL.t_map_colors 
			GROUP BY color
		) AS colors_vals (COLOR, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		WHERE NOT EXISTS (
		SELECT * FROM BL_3NF.CE_COLORS c WHERE c.color = colors_vals.color
		)
		RETURNING *
	)

	SELECT count (*) INTO rows_affected FROM load_query;
	
    CALL BL_CL.prc_load_log('prc_load_ce_colors', 'BL_3NF', 'CE_COLORS', rows_affected);

	RETURN ;
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;