CREATE OR REPLACE PROCEDURE BL_CL.prc_load_init_ce_employees_scd()
LANGUAGE plpgsql
AS $$
DECLARE rows_default int;
BEGIN 
	
	CREATE TABLE IF NOT EXISTS BL_3NF.CE_EMPLOYEES_SCD (
	EMPLOYEE_ID int,
	LASTNAME VARCHAR(30),
	FIRSTNAME VARCHAR(30),
	EMAIL VARCHAR(50),
	BADGE VARCHAR(10),
	START_DT DATE, 
	END_DT DATE,
	IS_ACTIVE BOOL,
	TA_INSERT_DT date,
	TA_UPDATE_DT date,
	SOURCE_SYSTEM varchar(50),
	SOURCE_ENTITY varchar(50),
	SOURCE_ID varchar(50),
	PRIMARY KEY (EMPLOYEE_ID, START_DT)
	);

	CREATE SEQUENCE IF NOT EXISTS bl_3nf.ce_employees_scd_id_seq START 1;

	ALTER TABLE bl_3nf.ce_employees_scd
	ALTER COLUMN employee_id SET DEFAULT nextval('bl_3nf.ce_employees_scd_id_seq');

	WITH load_default AS 
	(
		INSERT INTO BL_3NF.CE_EMPLOYEES_SCD (EMPLOYEE_ID, LASTNAME, FIRSTNAME, EMAIL, BADGE, START_DT, END_DT, IS_ACTIVE, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		SELECT -1, 'n. a.', 'n. a.', 'n. a.', 'n. a.', '1-1-1900', '9999-12-31'::date, True, '1-1-1900', '1-1-1900', 'MANUAL', 'MANUAL', 'n. a.'
		WHERE NOT EXISTS (
		SELECT * FROM BL_3NF.CE_EMPLOYEES_SCD e WHERE e.EMPLOYEE_ID = -1
		)
		RETURNING *
	)
	
	SELECT count (*) INTO rows_default FROM load_default;

	

    CALL BL_CL.prc_load_log('prc_load_init_ce_employees_scd', 'BL_3NF', 'CE_EMPLOYEES_SCD', rows_default);

	RETURN ;
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;