CREATE OR REPLACE PROCEDURE BL_CL.prc_load_init_dim_employees_scd()
LANGUAGE plpgsql
AS $$
DECLARE rows_affected int;
BEGIN 
	
	CREATE TABLE IF NOT EXISTS BL_DM.DIM_EMPLOYEES_SCD (
	EMPLOYEE_SURR_ID INT,
	FIRSTNAME VARCHAR(30),
	LASTNAME VARCHAR(30),
	EMAIL VARCHAR(50),
	BADGE VARCHAR(10),
	START_DT DATE,
	END_DT DATE,
	IS_ACTIVE BOOL,
	TA_INSERT_DT DATE,
	TA_UPDATE_DT DATE,
	SOURCE_SYSTEM VARCHAR(50),
	SOURCE_ENTITY VARCHAR(50),
	SOURCE_ID VARCHAR(50),
	PRIMARY KEY (EMPLOYEE_SURR_ID, START_DT) -- 3nf
	);

	CREATE SEQUENCE IF NOT EXISTS bl_dm.dim_employees_scd_surr_id_seq START 1;

	ALTER TABLE bl_dm.dim_employees_scd 
	ALTER COLUMN employee_surr_id SET DEFAULT nextval('bl_dm.dim_employees_scd_surr_id_seq'); 
	
	WITH load_query AS (
		INSERT INTO BL_DM.DIM_EMPLOYEES_SCD (EMPLOYEE_SURR_ID, FIRSTNAME, LASTNAME, EMAIL, BADGE, START_DT, END_DT, 
										IS_ACTIVE, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		SELECT -1, 'n. a.', 'n. a.', 'n. a.', 'n. a.', '1-1-1900', '9999-12-31'::date, True, '1-1-1900', '1-1-1900', 'MANUAL', 'MANUAL', 'n. a.'
		WHERE NOT EXISTS (
		SELECT * FROM BL_DM.DIM_EMPLOYEES_SCD e WHERE e.EMPLOYEE_SURR_ID = -1
		)
		RETURNING *
	)
	
	SELECT count(*) INTO rows_affected FROM load_query;

	CALL BL_CL.prc_load_log('prc_load_init_dim_employees_scd', 'BL_DM', 'DIM_EMPLOYEES_SCD', rows_affected);

	RETURN;

EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;
