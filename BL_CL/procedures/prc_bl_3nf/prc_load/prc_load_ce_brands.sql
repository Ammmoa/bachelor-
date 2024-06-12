CREATE OR REPLACE PROCEDURE BL_CL.prc_load_ce_brands()
LANGUAGE plpgsql
AS $$
DECLARE
	rows_affected int;
BEGIN 
		
	WITH load_query AS 
	(
		INSERT INTO BL_3NF.CE_BRANDS (BRAND_ID, BRAND, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID) 
		SELECT nextval('bl_3nf.ce_brands_id_seq'), * 
		FROM (
			SELECT DISTINCT brand_name, current_date, current_date, 'BL_CL', 'T_MAP_BRANDS', min(brand_id)
			FROM BL_CL.t_map_brands
			GROUP BY brand_name
		) AS brands_vals (BRAND, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID) 
		
		WHERE NOT EXISTS (
			SELECT * FROM BL_3NF.CE_BRANDS b WHERE b.brand = brands_vals.brand
			)
		RETURNING *
	)

	SELECT count (*) INTO rows_affected FROM load_query;
	
    CALL BL_CL.prc_load_log('prc_load_ce_brands', 'BL_3NF', 'CE_BRANDS', rows_affected);

	RETURN ;
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;