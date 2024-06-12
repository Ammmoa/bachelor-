BEGIN;

INSERT INTO BL_3NF.CE_STATES (STATE_ID, STATE, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)	

	SELECT nextval('bl_3nf.ce_states_id_seq') AS STATE_ID, *
	FROM (
	SELECT tms.state_name , current_date, current_date, 'BL_CL', 'T_MAP_STATES', min(tms.state_id)
	FROM bl_cl.t_map_states tms 
	GROUP BY tms.state_name 
	) AS states_map (STATE, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)	
	
	WHERE NOT EXISTS (SELECT * FROM BL_3NF.CE_STATES s WHERE s.state = states_map.state)
		
RETURNING *;

COMMIT;

-- 38 states
