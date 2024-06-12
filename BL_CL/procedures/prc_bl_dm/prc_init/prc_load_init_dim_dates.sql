CREATE OR REPLACE PROCEDURE BL_CL.prc_load_init_dim_dates()
LANGUAGE plpgsql
AS $$
DECLARE rows_affected int;
BEGIN 
	
	CREATE TABLE IF NOT EXISTS BL_DM.DIM_DATES (
	DATE_SURR_ID DATE PRIMARY KEY,
	DAY SMALLINT NOT NULL,
	MONTH SMALLINT NOT NULL,
	YEAR int2 NOT NULL,
	SOURCE_SYSTEM VARCHAR(50),
	SOURCE_ENTITY VARCHAR(50)
	);
	
	WITH load_query AS 
	(
		INSERT INTO BL_DM.DIM_DATES (DATE_SURR_ID, DAY, MONTH, YEAR, SOURCE_SYSTEM, SOURCE_ENTITY)
		SELECT '1-1-1900', -1, -1, -1, 'MANUAL', 'MANUAL'
		WHERE NOT EXISTS (
		SELECT * FROM BL_DM.DIM_DATES d WHERE d.DATE_SURR_ID = '1-1-1900'
		)
		RETURNING *
	)

	SELECT count (*) INTO rows_affected FROM load_query;
	
    CALL BL_CL.prc_load_log('prc_load_init_dim_dates', 'BL_DM', 'DIM_DATES', rows_affected);

	RETURN ;

EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;
