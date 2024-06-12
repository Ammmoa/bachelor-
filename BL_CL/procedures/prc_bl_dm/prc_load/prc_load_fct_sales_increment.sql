CREATE OR REPLACE PROCEDURE BL_CL.prc_load_fct_sales_increment(inc_start_dt date DEFAULT current_date - interval '7 days')
LANGUAGE plpgsql
AS $$
DECLARE rows_affected int;
BEGIN 
	
	WITH load_query AS (
		INSERT INTO BL_DM.FCT_SALES (AMOUNT, MMR, PROFIT, EMPLOYEE_SURR_ID, CUSTOMER_SURR_ID, MODEL_SURR_ID, PRODUCT_SURR_ID, 
				DATE_SURR_ID, TIME, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)

		SELECT cs.amount, cs.mmr, cs.amount - cs.mmr AS profit, des.employee_surr_id, dc.customer_surr_id, dm.model_surr_id, dp.product_surr_id, 
				dd.date_surr_id, cs.time, current_date AS ins_dt, current_date AS upd_dt, 'BL_3NF', 'CE_SALES', cs.sale_id::varchar AS source_id 
		FROM bl_3nf.ce_sales cs
		LEFT JOIN bl_dm.dim_customers dc ON cs.customer_id = dc.customer_surr_id
		LEFT JOIN bl_dm.dim_employees_scd des ON cs.employee_id = des.employee_surr_id
		LEFT JOIN bl_dm.dim_dates dd ON cs.date_id = dd.date_surr_id
		LEFT JOIN bl_dm.dim_models dm ON cs.model_id = dm.model_surr_id
		LEFT JOIN bl_dm.dim_products dp ON cs.product_id = dp.product_surr_id
		-- WHERE NOT EXISTS (SELECT 1 FROM bl_dm.fct_sales fsa WHERE fsa.product_surr_id = dp.product_surr_id AND fsa.time = cs.time) AND dp.product_surr_id IS NOT NULL
		WHERE NOT EXISTS (SELECT 1 FROM bl_dm.fct_sales fsa WHERE cs.sale_id::varchar = fsa.source_id) 
			AND cs.date_id >= inc_start_dt -- INCREMENT filter
		
		RETURNING *
	)
	
	SELECT count(*) INTO rows_affected FROM load_query;

	CALL BL_CL.prc_load_log('prc_load_fct_sales_increment', 'BL_DM', 'FCT_SALES', rows_affected);

	RETURN;

EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;
