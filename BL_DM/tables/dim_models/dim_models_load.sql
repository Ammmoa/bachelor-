BEGIN;
	
INSERT INTO BL_DM.DIM_MODELS (MODEL_SURR_ID, MODEL, BRAND, BRAND_ID, YEAR, BODY, TRANSMISSION, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)

SELECT nextval('bl_dm.dim_models_surr_id_seq'), *
FROM (
	SELECT cm.model, cb2.brand, cb2.brand_id, cm."YEAR", COALESCE(cm.body, 'n. a.'), cm.transmission,
			current_date, current_date, 'BL_3NF', 'CE_BRANDS|CE_MODELS|CE_BMODELS', cm.model_id::varchar AS src_id
	
	FROM bl_3nf.ce_models cm 
	
	LEFT JOIN bl_3nf.ce_brands cb2 ON cm.brand_id = cb2.brand_id 
	
	WHERE NOT EXISTS (SELECT 1 FROM bl_dm.dim_models dm WHERE cm.model_id::varchar = dm.source_id)
				AND cm.model_id != -1
	
) AS models_vals (MODEL, BRAND, BRAND_ID, YEAR, BODY, TRANSMISSION, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)

RETURNING *;
	
COMMIT;
-- DATA VOLUME CHECK
SELECT count(*) FROM bl_3nf.ce_models; --12514
SELECT count(*) FROM bl_dm.dim_models; --12514