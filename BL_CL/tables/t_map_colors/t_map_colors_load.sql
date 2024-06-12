-- color values are also in interior attribute, so we extract values by 2 select statements for 1 dataset

-- dataset_1 insertion		
BEGIN;
								
INSERT INTO BL_CL.T_MAP_COLORS (COLOR_ID, COLOR, COLOR_SRC_NAME, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
SELECT nextval('bl_cl.t_map_colors_id_seq'), *
FROM (
	SELECT DISTINCT upper(color), color, current_date, current_date, 'SA_CARSALES_1', 'SRC_CARSALES_1', 'n. a.' 
	FROM sa_carsales_1.src_carsales_1 sd 
	WHERE color ~ '^[a-zA-Z]+$'
	
	UNION
	
	SELECT DISTINCT upper(interior), interior, current_date, current_date, 'SA_CARSALES_1', 'SRC_CARSALES_1', 'n. a.' 
	FROM sa_carsales_1.src_carsales_1 sd 
	WHERE interior ~ '^[a-zA-Z]+$'
) AS rows_list (COLOR, COLOR_SRC_NAME, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
WHERE NOT EXISTS (
SELECT * FROM BL_CL.T_MAP_COLORS c WHERE c.COLOR_SRC_NAME = rows_list.COLOR_SRC_NAME 
)
RETURNING *;

COMMIT;
-- dataset_2 insertion		
-- no colors attribute in dataset_2	