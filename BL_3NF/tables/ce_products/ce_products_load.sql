BEGIN;

-- dataset 1
INSERT INTO BL_3NF.CE_PRODUCTS (PRODUCT_ID, VIN, COLOR_ID, INTERIOR_ID, CONDITION, ODOMETER, STATE_ID, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)

	SELECT nextval('bl_3nf.ce_products_id_seq'), *
	FROM (	
		SELECT sd.vin, COALESCE(c.color_id, -1), COALESCE(c2.color_id, -1), COALESCE(sd.CONDITION::decimal, -1), 
					sd.odometer::decimal, s.state_id, current_date, current_date, 'SA_CARSALES_1', 'SRC_CARSALES_1', 'n. a.'
							
		FROM sa_carsales_1.src_carsales_1 sd
		LEFT JOIN BL_3NF.CE_STATES s ON upper(sd.state) = s.state
		LEFT JOIN BL_3NF.CE_COLORS c ON upper(sd.color) = c.color
		LEFT JOIN BL_3NF.CE_COLORS c2 ON upper(sd.interior) = c2.color
		
		-- there duplicate vin codes in the query, so we need to extract vins with their most current dates according to the business logic (SCD type 1)
		INNER JOIN (SELECT vin, max(TO_TIMESTAMP(saledate , 'YYYY/MM/DD HH24:MI')) AS max_date  
					FROM sa_carsales_1.src_carsales_1 sc 
					GROUP BY vin
					) AS mxdates ON sd.vin = mxdates.vin AND TO_TIMESTAMP(sd.saledate , 'YYYY/MM/DD HH24:MI') = mxdates.max_date
						
		WHERE length(sd.vin) = 17 AND sd.vin ~ '^[a-zA-Z0-9]+$'
			
	) AS products_val (VIN, COLOR_ID, INTERIOR_ID, CONDITION, ODOMETER, STATE_ID, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		
	WHERE NOT EXISTS (
		SELECT * FROM BL_3NF.CE_PRODUCTS p WHERE p.VIN = products_val.vin AND p.color_id = products_val.color_id AND p.CONDITION = products_val.CONDITION AND p.odometer = products_val.odometer
	)
		
	-- scd 1 logic
	ON CONFLICT (vin)
	DO UPDATE
	SET "condition" = EXCLUDED."condition" ,
	    odometer = EXCLUDED.odometer,
	    color_id = (SELECT color_id FROM bl_3nf.ce_colors WHERE color_id = EXCLUDED.color_id),
	    interior_id = (SELECT color_id FROM bl_3nf.ce_colors WHERE color_id = EXCLUDED.interior_id),
		ta_update_dt = current_date
		
RETURNING *;
	
COMMIT;

-- dataset 2
BEGIN;

INSERT INTO BL_3NF.CE_PRODUCTS (PRODUCT_ID, VIN, COLOR_ID, INTERIOR_ID, CONDITION, ODOMETER, STATE_ID, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		
	SELECT nextval('bl_3nf.ce_products_id_seq'), *
	FROM (
		SELECT DISTINCT sd.vin, -1, -1, COALESCE(sd.CONDITION::decimal, -1), sd.odometer::decimal, COALESCE(s.state_id, -1),
					current_date, current_date, 'SA_CARSALES_2' AS SOURCE_SYSTEM, 'SRC_CARSALES_2' AS SOURCE_ENTITY, 'n. a.' AS SOURCE_ID
						
		FROM sa_carsales_2.src_carsales_2 sd
		LEFT JOIN BL_3NF.CE_STATES s ON upper(sd.state) = s.state
			
		INNER JOIN (SELECT vin, max(TO_TIMESTAMP(saledate , 'YYYY/MM/DD HH24:MI')) AS max_date  
					FROM sa_carsales_2.src_carsales_2 sc 
					GROUP BY vin
					) AS mxdates ON sd.vin = mxdates.vin AND TO_TIMESTAMP(sd.saledate , 'YYYY/MM/DD HH24:MI') = mxdates.max_date
						
		WHERE length(sd.vin) = 17 AND sd.vin ~ '^[a-zA-Z0-9]+$'
			
	) AS products_val (VIN, COLOR_ID, INTERIOR_ID, CONDITION, ODOMETER, STATE_ID, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		
	WHERE NOT EXISTS (
		SELECT * FROM BL_3NF.CE_PRODUCTS p WHERE p.VIN = products_val.vin AND p.CONDITION = products_val.CONDITION AND p.odometer = products_val.odometer
	)
		
	ON CONFLICT (vin)
	DO UPDATE
	SET "condition" = EXCLUDED."condition" ,
	    odometer = EXCLUDED.odometer,
		ta_update_dt = current_date
		
RETURNING *;

COMMIT;