-- dataset_1
INSERT INTO BL_3NF.CE_CUSTOMERS (CUSTOMER_ID, FIRSTNAME, LASTNAME, EMAIL, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID) 

	SELECT nextval('bl_3nf.ce_customers_id_seq'), *
	FROM (
		SELECT DISTINCT sd.customer_name, sd.customer_surname, sd.customer_contact, current_date, current_date, 
						'SA_CARSALES_1' AS SOURCE_SYSTEM, 'SRC_CARSALES_1' AS SOURCE_ENTITY, 'n. a.' AS SOURCE_ID
		FROM sa_carsales_1.src_carsales_1 sd
		WHERE sd.customer_contact LIKE '%@%'
			AND NOT EXISTS (SELECT * FROM BL_3NF.CE_CUSTOMERS c WHERE c.EMAIL = sd.customer_contact)
	)
	
RETURNING *;
	
-- dataset_2
INSERT INTO BL_3NF.CE_CUSTOMERS (CUSTOMER_ID, FIRSTNAME, LASTNAME, EMAIL, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID) 

	SELECT nextval('bl_3nf.ce_customers_id_seq'), *
	FROM (
		SELECT DISTINCT split_part(sd.customer_fullname, ' ', 1) AS first_name, split_part(sd.customer_fullname, ' ', 2) AS customer_surname, 
						sd.customer_contact, current_date, current_date, 
						'SA_CARSALES_2' AS SOURCE_SYSTEM, 'SRC_CARSALES_2' AS SOURCE_ENTITY, 'n. a.' AS SOURCE_ID
		FROM sa_carsales_2.src_carsales_2 sd
		WHERE sd.customer_contact LIKE '%@%'
			AND NOT EXISTS (SELECT * FROM BL_3NF.CE_CUSTOMERS c WHERE c.EMAIL = sd.customer_contact )
	)
	
RETURNING *;