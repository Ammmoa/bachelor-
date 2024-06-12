CREATE OR REPLACE PROCEDURE BL_CL.prc_load_dim_dates()
LANGUAGE plpgsql
AS $$
DECLARE rows_affected int;
BEGIN 
	
	
	WITH load_query AS 
	(
		INSERT INTO BL_DM.DIM_DATES (DATE_SURR_ID, DAY, MONTH, YEAR, SOURCE_SYSTEM, SOURCE_ENTITY)
		SELECT d::DATE, EXTRACT(DAY FROM d), EXTRACT(MONTH FROM d), EXTRACT(YEAR FROM d), 'MANUAL', 'MANUAL'
		FROM generate_series('2010-01-01'::DATE, '2025-01-01'::DATE, '1 day') d
		LEFT JOIN BL_DM.DIM_DATES t ON d::DATE = t.DATE_SURR_ID
		WHERE t.DATE_SURR_ID IS NULL
		RETURNING *
	)

	SELECT count (*) INTO rows_affected FROM load_query;
	
    CALL BL_CL.prc_load_log('prc_load_dim_dates', 'BL_DM', 'DIM_DATES', rows_affected);

	RETURN ;

EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;
