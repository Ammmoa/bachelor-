CREATE OR REPLACE PROCEDURE BL_CL.prc_load_init_ce_dates()
LANGUAGE plpgsql
AS $$
DECLARE rows_affected int;
BEGIN 
	CREATE TABLE IF NOT EXISTS BL_3NF.CE_DATES(DATE_ID DATE PRIMARY KEY, DAY SMALLINT NOT NULL, MONTH SMALLINT NOT NULL, YEAR int2 NOT NULL); 
		
	WITH load_query AS 
	(
		INSERT INTO BL_3NF.CE_DATES (DATE_ID, DAY, MONTH, YEAR)
		SELECT '1-1-1900', -1, -1, -1
		WHERE NOT EXISTS (
		SELECT * FROM BL_3NF.CE_DATES d WHERE d.DATE_ID = '1-1-1900'
		)
		RETURNING *
	)

	SELECT count (*) INTO rows_affected FROM load_query;
	
    CALL BL_CL.prc_load_log('prc_load_init_ce_dates', 'BL_3NF', 'CE_DATES', rows_affected);

	RETURN ;
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;

