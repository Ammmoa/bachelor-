-- dataset_1 insertion		
BEGIN; 								
INSERT INTO BL_CL.T_MAP_STATES (STATE_ID, STATE_NAME, STATE_SRC_NAME, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)

SELECT nextval('bl_cl.t_map_states_id_seq'), *
FROM (
	SELECT DISTINCT upper(state), state, current_date, current_date, 'SA_CARSALES_1', 'SRC_CARSALES_1', 'n. a.' 
	FROM sa_carsales_1.src_carsales_1 sd 
	WHERE length(sd.state) = 2
) AS rows_list (STATE_NAME, STATE_SRC_NAME, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
WHERE NOT EXISTS (
	SELECT * FROM BL_CL.T_MAP_STATES s WHERE s.STATE_SRC_NAME = rows_list.STATE_SRC_NAME 
)

UNION ALL 
-- dataset_2 insertion		
SELECT  nextval('bl_cl.t_map_states_id_seq'), *
FROM (
	SELECT DISTINCT upper(state), state, current_date, current_date, 'SA_CARSALES_2', 'SRC_CARSALES_2', 'n. a.' 
	FROM sa_carsales_2.src_carsales_2 sd 
	WHERE length(sd.state) = 2
) AS sd (STATE_NAME, STATE_SRC_NAME, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
WHERE NOT EXISTS (
SELECT * FROM BL_CL.T_MAP_STATES s WHERE s.STATE_SRC_NAME = sd.STATE_SRC_NAME 
)
RETURNING *;
COMMIT;
