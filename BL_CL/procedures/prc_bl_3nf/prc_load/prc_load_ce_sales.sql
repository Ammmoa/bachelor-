CREATE OR REPLACE PROCEDURE BL_CL.prc_load_ce_sales()
LANGUAGE plpgsql
AS $$
DECLARE
	rows_affected1 int;
	rows_affected2 int;
BEGIN 
	
	WITH load_query1 AS 
	(
		INSERT INTO BL_3NF.CE_SALES (SALE_ID, CUSTOMER_ID, EMPLOYEE_ID, MODEL_ID, PRODUCT_ID, MMR, AMOUNT,
							DATE_ID, TIME, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		SELECT nextval('bl_3nf.ce_sales_id_seq'), *
		FROM (
			SELECT DISTINCT c.customer_id, e.employee_id, m.model_id, p.product_id, sd.mmr::decimal, sd.sellingprice::decimal, d.date_id, CAST(TO_TIMESTAMP(sd.saledate, 'YYYY/MM/DD HH24:MI:SS AM') AS TIME) AS hour, 
				   current_date, current_date, 'SA_CARSALES_1' AS SOURCE_SYSTEM, 'SRC_CARSALES_1' AS SOURCE_ENTITY, 'n. a.' AS SOURCE_ID
			FROM sa_carsales_1.src_carsales_1 sd
			LEFT JOIN BL_3NF.CE_CUSTOMERS c ON sd.customer_contact = c.email
			LEFT JOIN BL_3NF.CE_EMPLOYEES_SCD e ON sd.employee_contact = e.email
			LEFT JOIN BL_3NF.CE_DATES d ON CAST(sd.saledate AS TIMESTAMP)::DATE = d.date_id
			LEFT JOIN bl_3nf.ce_states cs ON cs.state = upper(sd.state)
			LEFT JOIN bl_3nf.ce_colors cc ON cc.color = upper(sd.color)
			LEFT JOIN bl_3nf.ce_colors cc2 ON cc2.color = upper(sd.interior)
			LEFT JOIN BL_3NF.CE_PRODUCTS p ON sd.vin = p.vin AND sd.odometer::decimal = p.odometer AND sd.CONDITION::decimal = p.CONDITION AND cs.state_id = p.state_id 
				AND cc.color_id = p.color_id AND cc2.color_id = p.interior_id
			LEFT JOIN bl_3nf.ce_brands cb ON cb.brand = upper(sd.make)
			LEFT JOIN BL_3NF.CE_MODELS m ON upper(sd.model) = m.model AND sd.year = m.YEAR::VARCHAR AND upper(sd.body) = m.body AND sd.transmission = m.transmission
				AND cb.brand_id = m.brand_id
			WHERE NOT EXISTS (
				SELECT * FROM BL_3NF.CE_SALES s WHERE d.date_id = s.date_id AND CAST(TO_TIMESTAMP(sd.saledate, 'YYYY/MM/DD HH24:MI:SS AM') AS TIME) = s.time AND p.product_id = s.product_id AND m.model_id = s.model_id
			)
		)
		
		RETURNING *
		
	)

	SELECT count (*) INTO rows_affected1 FROM load_query1;

	WITH load_query2 AS 
	(
		-- dataset_2
		INSERT INTO BL_3NF.CE_SALES (SALE_ID, CUSTOMER_ID, EMPLOYEE_ID, MODEL_ID, PRODUCT_ID, MMR, AMOUNT,
							DATE_ID, TIME, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		SELECT nextval('bl_3nf.ce_sales_id_seq'), *
		FROM (
			SELECT c.customer_id, e.employee_id, m.model_id, p.product_id, sd.mmr::decimal, sd.sellingprice::decimal, d.date_id, CAST(TO_TIMESTAMP(sd.saledate, 'YYYY/MM/DD HH24:MI:SS AM') AS TIME) AS hour, 
				   current_date, current_date, 'SA_CARSALES_1' AS SOURCE_SYSTEM, 'SRC_CARSALES_1' AS SOURCE_ENTITY, 'n. a.' AS SOURCE_ID
			FROM sa_carsales_2.src_carsales_2 sd
			LEFT JOIN BL_3NF.CE_CUSTOMERS c ON sd.customer_contact = c.email
			LEFT JOIN BL_3NF.CE_EMPLOYEES_SCD e ON sd.employee_contact = e.email
			LEFT JOIN BL_3NF.CE_DATES d ON CAST(sd.saledate AS TIMESTAMP)::DATE = d.date_id
			LEFT JOIN BL_3NF.CE_PRODUCTS p ON sd.vin = p.vin AND sd.odometer = p.odometer::varchar
			LEFT JOIN bl_3nf.ce_brands cb ON upper(sd.make) = cb.brand
			LEFT JOIN BL_3NF.CE_MODELS m ON upper(sd.model) = m.model AND sd.year = m.YEAR::VARCHAR AND upper(sd.body) = m.body AND sd.transmission = m.transmission AND cb.brand_id = m.brand_id
			WHERE NOT EXISTS (
				SELECT * FROM BL_3NF.CE_SALES s WHERE d.date_id = s.date_id AND CAST(TO_TIMESTAMP(sd.saledate, 'YYYY/MM/DD HH24:MI:SS AM') AS TIME) = s.time
			)
		)
		RETURNING *
	)

	SELECT count (*) INTO rows_affected2 FROM load_query2;

    CALL BL_CL.prc_load_log('prc_load_ce_sales', 'BL_3NF', 'CE_SALES', rows_affected1 + rows_affected2);

	RETURN ;
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;