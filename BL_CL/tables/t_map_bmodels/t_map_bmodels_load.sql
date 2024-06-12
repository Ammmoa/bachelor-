BEGIN;
-- dataset_1 insertion										
INSERT INTO BL_CL.T_MAP_BMODELS (BMODEL_ID, BMODEL_NAME, BMODEL_SRC_NAME, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
SELECT nextval('bl_cl.t_map_bmodels_id_seq'), *
FROM (

	SELECT DISTINCT upper(model), model, current_date, current_date, 'SA_CARSALES_1', 'SRC_CARSALES_1', 'n. a.' 
	FROM sa_carsales_1.src_carsales_1  
	WHERE model IS NOT NULL 
	
) AS rows_list (BMODEL_NAME, BMODEL_SRC_NAME, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)

WHERE NOT EXISTS (
SELECT * FROM BL_CL.T_MAP_BMODELS b WHERE b.BMODEL_SRC_NAME = rows_list.BMODEL_SRC_NAME 
)

UNION ALL 
-- dataset_2 insertion		

SELECT  NEXTVAL('bl_cl.t_map_bmodels_id_seq'), *
FROM (
	SELECT DISTINCT upper(model), model, current_date, current_date, 'SA_CARSALES_2', 'SRC_CARSALES_2', 'n. a.'
	FROM sa_carsales_2.src_carsales_2 sd 
	WHERE model IS NOT NULL
	
) AS rows_list2 (BMODEL_NAME, BMODEL_SRC_NAME, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)

WHERE NOT EXISTS (
SELECT * FROM BL_CL.T_MAP_BMODELS b WHERE b.BMODEL_SRC_NAME = rows_list2.BMODEL_SRC_NAME 									
)
RETURNING *;

COMMIT;

SELECT count(*) FROM bl_cl.t_map_bmodels; -- 1946