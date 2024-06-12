CREATE OR REPLACE PROCEDURE BL_CL.prc_load_ce_employees_scd()
LANGUAGE plpgsql
AS $$
DECLARE 
	rows_affected1 int;
	rows_affected2 int;
BEGIN 
	
	-- scd 2 logic
	WITH update_emps AS 
	(
		UPDATE bl_3nf.ce_employees_scd ces
		SET end_dt = current_date, is_active = FALSE, ta_update_dt = current_date
		WHERE EXISTS 
		(
			SELECT 1 
			FROM (
				SELECT DISTINCT split_part(sd.employee, ' ', 1) AS name, split_part(sd.employee, ' ', 2) AS surname, employee_contact, employee_badge, 
								'1-1-2010'::date AS start_date, '9999-12-31'::date AS end_date, TRUE AS is_active, 
										current_date, current_date, 'SA_CARSALES_1' AS SOURCE_SYSTEM, 'SRC_CARSALES_1' AS SOURCE_ENTITY, 'n. a.' AS SOURCE_ID
				FROM sa_carsales_1.src_carsales_1 sd
			) AS emp_vals	
		
		WHERE ces.badge = emp_vals.employee_badge AND ces.email != emp_vals.employee_contact AND ces.start_dt < emp_vals.start_date 
		)
		RETURNING *
	)
	
	SELECT count (*) INTO rows_affected2 FROM update_emps;


	WITH load_emps AS 
	(
		INSERT INTO bl_3nf.ce_employees_scd (EMPLOYEE_ID, LASTNAME, FIRSTNAME, EMAIL, BADGE, START_DT, END_DT, IS_ACTIVE, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		
		SELECT nextval('bl_3nf.ce_employees_scd_id_seq'), *
		FROM (
		
			SELECT name, surname, employee_contact, employee_badge, start_date, end_date, is_active, current_date, current_date, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID	
			FROM (SELECT DISTINCT split_part(sd.employee, ' ', 1) AS name, split_part(sd.employee, ' ', 2) AS surname, employee_contact, employee_badge, 
							'1-1-2010'::date AS start_date, '9999-12-31'::date AS end_date, TRUE AS is_active, 
									current_date, current_date, 'SA_CARSALES_1' AS SOURCE_SYSTEM, 'SRC_CARSALES_1' AS SOURCE_ENTITY, 'n. a.' AS SOURCE_ID
				FROM sa_carsales_1.src_carsales_1 sd
			)
			WHERE NOT EXISTS (SELECT 1 FROM bl_3nf.ce_employees_scd ces WHERE ces.email = employee_contact AND ces.badge = employee_badge)
		
		) AS new_emp_vals (LASTNAME, FIRSTNAME, EMAIL, BADGE, START_DT, END_DT, IS_ACTIVE, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		RETURNING *
	)
	
	SELECT count (*) INTO rows_affected1 FROM load_emps;

	

    CALL BL_CL.prc_load_log('prc_load_ce_employees_scd', 'BL_3NF', 'CE_EMPLOYEES_SCD', rows_affected1 + rows_affected2);

	RETURN ;
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;