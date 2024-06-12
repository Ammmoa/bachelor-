CREATE OR REPLACE PROCEDURE BL_CL.prc_load_dim_products()
LANGUAGE plpgsql
AS $$
DECLARE rows_affected int;
BEGIN 
	
	WITH load_query AS (
	
	INSERT INTO BL_DM.DIM_PRODUCTS (PRODUCT_SURR_ID, VIN, COLOR, COLOR_ID, INTERIOR, INTERIOR_ID, ODOMETER, CONDITION, STATE, STATE_ID, 
									TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)

	SELECT nextval('bl_dm.dim_products_surr_id_seq'), *
	FROM (
	SELECT  cp.vin, cc.color, cc.color_id, cc2.color AS inte, cc2.color_id AS inte_id, cp.odometer, cp."condition",
			cs.state, cs.state_id, current_date, current_date, 'BL_3NF', 'CE_SATATES|CE_COLORS|CE_PRODUCTS', cp.product_id::varchar
	FROM bl_3nf.ce_products cp 
	LEFT JOIN bl_3nf.ce_states cs ON cp.state_id = cs.state_id 
	LEFT JOIN bl_3nf.ce_colors cc ON cp.color_id = cc.color_id 
	LEFT JOIN bl_3nf.ce_colors cc2 ON cp.interior_id = cc2.color_id 
	-- WHERE NOT EXISTS (SELECT 1 FROM bl_dm.dim_products dp WHERE cp.product_id = dp.product_surr_id AND cp.vin = dp.vin)
	WHERE NOT EXISTS (SELECT 1 FROM bl_dm.dim_products dp WHERE cp.product_id::varchar = dp.source_id)
		AND cp.product_id != -1
		
	) AS products_vals (VIN, COLOR, COLOR_ID, INTERIOR, INTERIOR_ID, ODOMETER, CONDITION, STATE, STATE_ID, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
	
	ON CONFLICT (vin)
	DO UPDATE
	SET "condition" = EXCLUDED."condition" ,
		odometer = EXCLUDED.odometer,
		color_id = (SELECT color_id FROM bl_3nf.ce_colors WHERE color_id = EXCLUDED.color_id),
		interior_id = (SELECT color_id FROM bl_3nf.ce_colors WHERE color_id = EXCLUDED.interior_id),
		ta_update_dt = current_date
			
	RETURNING *
	)
	
	SELECT count(*) INTO rows_affected FROM load_query;

	CALL BL_CL.prc_load_log('prc_load_dim_products', 'BL_DM', 'DIM_PRODUCTS', rows_affected);

	RETURN;

EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;
