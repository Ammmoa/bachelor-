BEGIN; 

-- dataset_1 insertion										
INSERT INTO BL_CL.T_MAP_BRANDS (BRAND_ID, BRAND_NAME, BRAND_SRC_NAME, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
SELECT nextval('bl_cl.t_map_brands_id_seq'), *
FROM (
	SELECT DISTINCT upper(make), make, current_date, current_date, 'SA_CARSALES_1', 'SRC_CARSALES_1', 'n. a.' 
	FROM sa_carsales_1.src_carsales_1 sd 
	WHERE make ~ '^[a-zA-Z -]+$'
) AS rows_list (BRAND_NAME, BRAND_SRC_NAME, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
WHERE NOT EXISTS (
SELECT * FROM BL_CL.T_MAP_BRANDS b WHERE b.BRAND_SRC_NAME = rows_list.BRAND_SRC_NAME 
)
UNION ALL 
-- dataset_2 insertion		
SELECT  nextval('bl_cl.t_map_brands_id_seq') AS BRAND_ID, 
		sd.BRAND_NAME, sd.BRAND_SRC_NAME, sd.TA_INSERT_DT, sd.TA_UPDATE_DT, sd.SOURCE_SYSTEM, sd.SOURCE_ENTITY, sd.SOURCE_ID
FROM (
	SELECT DISTINCT upper(make), make, current_date, current_date, 'SA_CARSALES_2', 'SRC_CARSALES_2', 'n. a.'
	FROM sa_carsales_2.src_carsales_2 sd 
	WHERE make ~ '^[a-zA-Z -]+$'
) AS sd (BRAND_NAME, BRAND_SRC_NAME, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
WHERE NOT EXISTS (
SELECT * FROM BL_CL.T_MAP_BRANDS b WHERE b.BRAND_SRC_NAME = sd.BRAND_SRC_NAME 
)
RETURNING *;

COMMIT;