CREATE OR REPLACE PROCEDURE BL_CL.prc_load_dim_employees_scd()
LANGUAGE plpgsql
AS $$
DECLARE 
	rows_affected int;
	rows_affected2 int;
BEGIN 
	
	WITH update_query AS (
		UPDATE bl_dm.dim_employees_scd des
		SET is_active = FALSE, end_dt = current_date, ta_update_dt = current_date
		WHERE EXISTS (
				SELECT 1 FROM bl_3nf.ce_employees_scd ces WHERE des.badge = ces.badge AND des.email != ces.email AND des.start_dt < ces.start_dt
		)
		RETURNING *
	)
	
	SELECT count(*) INTO rows_affected2 FROM update_query;
	
	WITH load_query AS (
		INSERT INTO BL_DM.DIM_EMPLOYEES_SCD (EMPLOYEE_SURR_ID, FIRSTNAME, LASTNAME, EMAIL, BADGE, START_DT, END_DT, IS_ACTIVE, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
	
		SELECT  nextval('bl_dm.dim_employees_scd_surr_id_seq'), *
		FROM (
			SELECT FIRSTNAME, LASTNAME, EMAIL, BADGE, START_DT, END_DT, IS_ACTIVE, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, EMPLOYEE_ID::varchar AS SOURCE_ID
			FROM bl_3nf.ce_employees_scd ces 
			-- WHERE NOT EXISTS (SELECT 1 FROM bl_dm.dim_employees_scd des WHERE des.email = ces.email AND des.badge = ces.badge)
			WHERE NOT EXISTS (SELECT 1 FROM bl_dm.dim_employees_scd des WHERE ces.employee_id::varchar = des.source_id)
				AND ces.employee_id != -1
		)
		RETURNING *
	)
	
	SELECT count(*) INTO rows_affected FROM load_query;

	CALL BL_CL.prc_load_log('prc_load_dim_employees_scd', 'BL_DM', 'DIM_EMPLOYEES_SCD', rows_affected + rows_affected2);

	RETURN;

EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;
