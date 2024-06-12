CREATE OR REPLACE PROCEDURE BL_CL.prc_load_dim_models()
LANGUAGE plpgsql
AS $$
DECLARE rows_affected int;
BEGIN 
	
	WITH load_query AS (
		INSERT INTO BL_DM.DIM_MODELS (MODEL_SURR_ID, MODEL, BRAND, BRAND_ID, YEAR, BODY, TRANSMISSION, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)

		SELECT nextval('bl_dm.dim_models_surr_id_seq'), *
		FROM (
			SELECT cm.model, cb2.brand, cb2.brand_id, cm.YEAR, COALESCE(cm.body, 'n. a.'), cm.transmission,
					current_date, current_date, 'BL_3NF', 'CE_BRANDS|CE_MODELS|CE_BMODELS', cm.model_id::varchar AS src_id
			
			FROM bl_3nf.ce_models cm 
			
			LEFT JOIN bl_3nf.ce_brands cb2 ON cm.brand_id = cb2.brand_id 
			
			-- WHERE NOT EXISTS (SELECT 1 FROM bl_dm.dim_models dm WHERE dm.model = cm.model AND dm.brand_id = cm.brand_id AND dm.YEAR = cm.YEAR AND dm.transmission = cm.transmission)
			WHERE NOT EXISTS (SELECT 1 FROM bl_dm.dim_models dm WHERE cm.model_id::varchar = dm.source_id)
				AND cm.model_id != -1

			
		) AS models_vals (MODEL, BRAND, BRAND_ID, YEAR, BODY, TRANSMISSION, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		
		RETURNING *
		
	)
	
	SELECT count(*) INTO rows_affected FROM load_query;

	CALL BL_CL.prc_load_log('prc_load_dim_models', 'BL_DM', 'DIM_MODELS', rows_affected);

	RETURN;

EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;