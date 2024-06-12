CREATE OR REPLACE PROCEDURE BL_CL.prc_load_ce_models()
LANGUAGE plpgsql
AS $$
DECLARE
	rows_affected1 int;
	rows_affected2 int;
BEGIN 
	
	WITH load_query1 AS 
	(
		INSERT INTO BL_3NF.CE_MODELS (MODEL_ID, MODEL, BRAND_ID, BODY, TRANSMISSION, YEAR, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)

		SELECT nextval('bl_3nf.ce_models_id_seq'), *
		FROM (
			SELECT DISTINCT bmodels_names.bmodel_name, bb.brand_id, COALESCE(upper(sc.body), 'n. a.'), coalesce(sc.transmission, 'n. a.'), sc.year::int,  current_date, current_date, 
							'BL_CL', 'T_MAP_BMODELS', bmodels_names.bmodel_id
				
			FROM (SELECT bmodel_name, min(bmodel_id) AS bmodel_id
				  FROM bl_cl.t_map_bmodels GROUP BY  bmodel_name
			     ) AS bmodels_names
			
			LEFT JOIN sa_carsales_1.src_carsales_1 sc ON bmodels_names.bmodel_name = upper(sc.model)
			
			LEFT JOIN bl_3nf.ce_brands bb ON upper(sc.make) = bb.brand
			
			WHERE bb.brand_id IS NOT NULL
		
		) AS bmodels (MODEL, BRAND_ID, BODY, TRANSMISSION, YEAR, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		
		WHERE NOT EXISTS (
			SELECT * FROM BL_3NF.CE_MODELS m WHERE m.MODEL = bmodels.model AND bmodels.BRAND_ID IS NOT NULL AND m.YEAR = bmodels.YEAR AND m.body = bmodels.body AND m.transmission = bmodels.transmission
			)
		RETURNING *
	)

	SELECT count (*) INTO rows_affected1 FROM load_query1;


	WITH load_query2 AS 
	(
		INSERT INTO BL_3NF.CE_MODELS (MODEL_ID, MODEL, BRAND_ID, BODY, TRANSMISSION, YEAR, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)

		SELECT nextval('bl_3nf.ce_models_id_seq'), *
		FROM (
			SELECT DISTINCT bmodels_names.bmodel_name, bb.brand_id, COALESCE(upper(sc.body), 'n. a.'), coalesce(sc.transmission, 'n. a.'), sc.year::int,  current_date, current_date, 
							'BL_CL', 'T_MAP_BMODELS', bmodels_names.bmodel_id
				
			FROM (SELECT bmodel_name, min(bmodel_id) AS bmodel_id
				  FROM bl_cl.t_map_bmodels GROUP BY  bmodel_name
			     ) AS bmodels_names
			
			LEFT JOIN sa_carsales_2.src_carsales_2 sc ON bmodels_names.bmodel_name = upper(sc.model)
			
			LEFT JOIN bl_3nf.ce_brands bb ON upper(sc.make) = bb.brand
			
			WHERE bb.brand_id IS NOT NULL
		
		) AS bmodels (MODEL, BRAND_ID, BODY, TRANSMISSION, YEAR, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		
		WHERE NOT EXISTS (
			SELECT * FROM BL_3NF.CE_MODELS m WHERE m.MODEL = bmodels.model AND bmodels.BRAND_ID IS NOT NULL AND m.YEAR = bmodels.YEAR AND m.body = bmodels.body AND m.transmission = bmodels.transmission
			)
		RETURNING *
	)

	SELECT count (*) INTO rows_affected2 FROM load_query2;

    CALL BL_CL.prc_load_log('prc_load_ce_models', 'BL_3NF', 'CE_MODELS', rows_affected1 + rows_affected2);

	RETURN ;
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;