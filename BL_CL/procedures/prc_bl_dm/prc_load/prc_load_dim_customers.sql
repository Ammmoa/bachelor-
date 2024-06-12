CREATE OR REPLACE PROCEDURE BL_CL.prc_load_dim_customers()
LANGUAGE plpgsql
AS $$
DECLARE rows_affected int;
BEGIN 
	
	WITH load_query AS (
		INSERT INTO BL_DM.DIM_CUSTOMERS (CUSTOMER_SURR_ID, FIRSTNAME, LASTNAME, EMAIL, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		
		SELECT nextval('bl_dm.dim_customers_surr_id_seq'), *
		FROM (
			
			SELECT FIRSTNAME, LASTNAME, EMAIL, current_date AS ins_dt, current_date AS upd_dt, 'BL_3NF', 'CE_CUSTOMERS', CUSTOMER_ID::VARCHAR AS SOURCE_ID  
			FROM bl_3nf.ce_customers cc 
			
			-- WHERE NOT EXISTS (SELECT 1 FROM bl_dm.dim_customers dc WHERE cc.EMAIL = dc.EMAIL)
			WHERE NOT EXISTS (SELECT 1 FROM bl_dm.dim_customers dc WHERE cc.customer_id::varchar = dc.SOURCE_ID)
				AND cc.customer_id != -1 -- FOR DEFAULT row

		) 
		RETURNING *
	)
	
	SELECT count(*) INTO rows_affected FROM load_query;

	CALL BL_CL.prc_load_log('prc_load_dim_customers', 'BL_DM', 'DIM_CUSTOMERS', rows_affected);

	RETURN;

EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;