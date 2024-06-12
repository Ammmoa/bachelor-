CREATE OR REPLACE PROCEDURE BL_CL.prc_load_init_dim_customers()
LANGUAGE plpgsql
AS $$
DECLARE rows_affected int;
BEGIN 
	
	CREATE TABLE IF NOT EXISTS BL_DM.DIM_CUSTOMERS (
	CUSTOMER_SURR_ID INT PRIMARY KEY,
	FIRSTNAME VARCHAR(30),
	LASTNAME VARCHAR(30),
	EMAIL VARCHAR(50),
	TA_INSERT_DT DATE,
	TA_UPDATE_DT DATE,
	SOURCE_SYSTEM VARCHAR(50),
	SOURCE_ENTITY VARCHAR(50),
	SOURCE_ID VARCHAR(50)
	);

	CREATE SEQUENCE IF NOT EXISTS bl_dm.dim_customers_surr_id_seq START 1;

	ALTER TABLE bl_dm.dim_customers
	ALTER COLUMN customer_surr_id SET DEFAULT nextval('bl_dm.dim_customers_surr_id_seq');

	WITH load_query AS (
		INSERT INTO BL_DM.DIM_CUSTOMERS (CUSTOMER_SURR_ID, FIRSTNAME, LASTNAME, EMAIL, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
	
		SELECT -1, 'n. a.', 'n. a.', 'n. a.', '1-1-1900', '1-1-1900', 'MANUAL', 'MANUAL', 'n. a.'
		WHERE NOT EXISTS (SELECT 1 FROM bl_dm.dim_customers WHERE customer_surr_id = -1)
		RETURNING *
	)
	
	SELECT count(*) INTO rows_affected FROM load_query;

	CALL BL_CL.prc_load_log('prc_load_init_dim_customers', 'BL_DM', 'DIM_CUSTOMERS', rows_affected);

	RETURN;

EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;


CREATE OR REPLACE PROCEDURE BL_CL.prc_load_init_dim_dates()
LANGUAGE plpgsql
AS $$
DECLARE rows_affected int;
BEGIN 
	
	CREATE TABLE IF NOT EXISTS BL_DM.DIM_DATES (
	DATE_SURR_ID DATE PRIMARY KEY,
	DAY SMALLINT NOT NULL,
	MONTH SMALLINT NOT NULL,
	YEAR int2 NOT NULL,
	SOURCE_SYSTEM VARCHAR(50),
	SOURCE_ENTITY VARCHAR(50)
	);
	
	WITH load_query AS 
	(
		INSERT INTO BL_DM.DIM_DATES (DATE_SURR_ID, DAY, MONTH, YEAR, SOURCE_SYSTEM, SOURCE_ENTITY)
		SELECT '1-1-1900', -1, -1, -1, 'MANUAL', 'MANUAL'
		WHERE NOT EXISTS (
		SELECT * FROM BL_DM.DIM_DATES d WHERE d.DATE_SURR_ID = '1-1-1900'
		)
		RETURNING *
	)

	SELECT count (*) INTO rows_affected FROM load_query;
	
    CALL BL_CL.prc_load_log('prc_load_init_dim_dates', 'BL_DM', 'DIM_DATES', rows_affected);

	RETURN ;

EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;


CREATE OR REPLACE PROCEDURE BL_CL.prc_load_init_dim_employees_scd()
LANGUAGE plpgsql
AS $$
DECLARE rows_affected int;
BEGIN 
	
	CREATE TABLE IF NOT EXISTS BL_DM.DIM_EMPLOYEES_SCD (
	EMPLOYEE_SURR_ID INT,
	FIRSTNAME VARCHAR(30),
	LASTNAME VARCHAR(30),
	EMAIL VARCHAR(50),
	BADGE VARCHAR(10),
	START_DT DATE,
	END_DT DATE,
	IS_ACTIVE BOOL,
	TA_INSERT_DT DATE,
	TA_UPDATE_DT DATE,
	SOURCE_SYSTEM VARCHAR(50),
	SOURCE_ENTITY VARCHAR(50),
	SOURCE_ID VARCHAR(50),
	PRIMARY KEY (EMPLOYEE_SURR_ID, START_DT) -- 3nf
	);

	CREATE SEQUENCE IF NOT EXISTS bl_dm.dim_employees_scd_surr_id_seq START 1;

	ALTER TABLE bl_dm.dim_employees_scd 
	ALTER COLUMN employee_surr_id SET DEFAULT nextval('bl_dm.dim_employees_scd_surr_id_seq'); 
	
	WITH load_query AS (
		INSERT INTO BL_DM.DIM_EMPLOYEES_SCD (EMPLOYEE_SURR_ID, FIRSTNAME, LASTNAME, EMAIL, BADGE, START_DT, END_DT, 
										IS_ACTIVE, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		SELECT -1, 'n. a.', 'n. a.', 'n. a.', 'n. a.', '1-1-1900', '9999-12-31'::date, True, '1-1-1900', '1-1-1900', 'MANUAL', 'MANUAL', 'n. a.'
		WHERE NOT EXISTS (
		SELECT * FROM BL_DM.DIM_EMPLOYEES_SCD e WHERE e.EMPLOYEE_SURR_ID = -1
		)
		RETURNING *
	)
	
	SELECT count(*) INTO rows_affected FROM load_query;

	CALL BL_CL.prc_load_log('prc_load_init_dim_employees_scd', 'BL_DM', 'DIM_EMPLOYEES_SCD', rows_affected);

	RETURN;

EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;


CREATE OR REPLACE PROCEDURE BL_CL.prc_load_init_dim_models()
LANGUAGE plpgsql
AS $$
DECLARE rows_affected int;
BEGIN 
	
	CREATE TABLE IF NOT EXISTS BL_DM.DIM_MODELS (
	MODEL_SURR_ID INT PRIMARY KEY,
	MODEL VARCHAR(50),
	BRAND VARCHAR(50),
	BRAND_ID SMALLINT,
	YEAR SMALLINT,
	BODY VARCHAR(30),
	TRANSMISSION VARCHAR(30),
	TA_INSERT_DT DATE,
	TA_UPDATE_DT DATE,
	SOURCE_SYSTEM VARCHAR(50),
	SOURCE_ENTITY VARCHAR(50),
	SOURCE_ID VARCHAR(50)
	);	

	CREATE SEQUENCE IF NOT EXISTS bl_dm.dim_models_surr_id_seq START 1;

	ALTER TABLE bl_dm.dim_models
	ALTER COLUMN model_surr_id SET DEFAULT nextval('bl_dm.dim_models_surr_id_seq'); 

	WITH load_query AS (
		INSERT INTO BL_DM.DIM_MODELS (MODEL_SURR_ID, MODEL, BRAND, BRAND_ID, YEAR, BODY, TRANSMISSION, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		SELECT -1, 'n. a.', 'n. a.', -1, -1, 'n. a.', 'n. a.', '1-1-1900', '1-1-1900', 'MANUAL', 'MANUAL', 'n. a.'
		WHERE NOT EXISTS (SELECT * FROM BL_DM.DIM_MODELS m WHERE m.MODEL_SURR_ID = -1)
		RETURNING *
	)
	
	SELECT count(*) INTO rows_affected FROM load_query;

	CALL BL_CL.prc_load_log('prc_load_init_dim_models', 'BL_DM', 'DIM_MODELS', rows_affected);

	RETURN;

EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;


CREATE OR REPLACE PROCEDURE BL_CL.prc_load_init_dim_products()
LANGUAGE plpgsql
AS $$
DECLARE rows_affected int;
BEGIN 
	
	CREATE TABLE IF NOT EXISTS BL_DM.DIM_PRODUCTS (
	PRODUCT_SURR_ID INT PRIMARY KEY,
	VIN VARCHAR(17) UNIQUE,
	COLOR VARCHAR(20),
	COLOR_ID SMALLINT,
	INTERIOR VARCHAR(20),
	INTERIOR_ID SMALLINT,
	ODOMETER INT,
	CONDITION SMALLINT,
	STATE VARCHAR(10),
	STATE_ID SMALLINT,
	TA_INSERT_DT DATE,
	TA_UPDATE_DT DATE,
	SOURCE_SYSTEM VARCHAR(50),
	SOURCE_ENTITY VARCHAR(50),
	SOURCE_ID VARCHAR(50)
	);

	CREATE SEQUENCE IF NOT EXISTS bl_dm.dim_products_surr_id_seq START 1;
	
	ALTER TABLE bl_dm.dim_products
	ALTER COLUMN product_surr_id SET DEFAULT nextval('bl_dm.dim_products_surr_id_seq'); 
	
	WITH load_query AS (
		INSERT INTO BL_DM.DIM_PRODUCTS (PRODUCT_SURR_ID, VIN, COLOR, COLOR_ID, INTERIOR, INTERIOR_ID, ODOMETER, CONDITION, STATE, 
								STATE_ID, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		SELECT -1, 'n. a.', 'n. a.', -1, 'n. a.', -1, -1, -1, 'n. a.', -1, '1-1-1900', '1-1-1900', 'MANUAL', 'MANUAL', 'n. a.'
		WHERE NOT EXISTS (
		SELECT * FROM BL_DM.DIM_PRODUCTS p WHERE p.PRODUCT_SURR_ID = -1
		)
		RETURNING *
	)
	
	SELECT count(*) INTO rows_affected FROM load_query;

	CALL BL_CL.prc_load_log('prc_load_init_dim_products', 'BL_DM', 'DIM_PRODUCTS', rows_affected);

	RETURN;

EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;


CREATE OR REPLACE PROCEDURE BL_CL.prc_load_init_fct_sales()
LANGUAGE plpgsql
AS $$
BEGIN 
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES (
	AMOUNT INT,
	MMR INT,
	PROFIT INT,
	EMPLOYEE_SURR_ID INT,
	CUSTOMER_SURR_ID INT,
	MODEL_SURR_ID INT,
	PRODUCT_SURR_ID INT,
	DATE_SURR_ID DATE,
	TIME TIME,
	TA_INSERT_DT DATE,
	TA_UPDATE_DT DATE,
	SOURCE_SYSTEM VARCHAR(50),
	SOURCE_ENTITY VARCHAR(50),
	SOURCE_ID VARCHAR(50)
	) 
	PARTITION BY RANGE (date_surr_id);
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES_2010_1st_semiyear
	PARTITION OF BL_DM.FCT_SALES FOR VALUES FROM ('2010-01-01'::date) TO ('2010-07-01'::date);
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES_2010_2nd_semiyear
	PARTITION OF BL_DM.FCT_SALES FOR VALUES FROM ('2010-07-01'::date) TO ('2011-01-01'::date);
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES_2011_1st_semiyear
	PARTITION OF BL_DM.FCT_SALES FOR VALUES FROM ('2011-01-01'::date) TO ('2011-07-01'::date);
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES_2011_2nd_semiyear
	PARTITION OF BL_DM.FCT_SALES FOR VALUES FROM ('2011-07-01'::date) TO ('2012-01-01'::date);
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES_2012_1st_semiyear
	PARTITION OF BL_DM.FCT_SALES FOR VALUES FROM ('2012-01-01'::date) TO ('2012-07-01'::date);
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES_2012_2nd_semiyear
	PARTITION OF BL_DM.FCT_SALES FOR VALUES FROM ('2012-07-01'::date) TO ('2013-01-01'::date);
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES_2013_1st_semiyear
	PARTITION OF BL_DM.FCT_SALES FOR VALUES FROM ('2013-01-01'::date) TO ('2013-07-01'::date);
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES_2013_2nd_semiyear
	PARTITION OF BL_DM.FCT_SALES FOR VALUES FROM ('2013-07-01'::date) TO ('2014-01-01'::date);
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES_2014_1st_semiyear
	PARTITION OF BL_DM.FCT_SALES FOR VALUES FROM ('2014-01-01'::date) TO ('2014-07-01'::date);
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES_2014_2nd_semiyear
	PARTITION OF BL_DM.FCT_SALES FOR VALUES FROM ('2014-07-01'::date) TO ('2015-01-01'::date);
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES_2015_1st_semiyear
	PARTITION OF BL_DM.FCT_SALES FOR VALUES FROM ('2015-01-01'::date) TO ('2015-07-01'::date);
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES_2015_2nd_semiyear
	PARTITION OF BL_DM.FCT_SALES FOR VALUES FROM ('2015-07-01'::date) TO ('2016-01-01'::date);
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES_2016_1st_semiyear
	PARTITION OF BL_DM.FCT_SALES FOR VALUES FROM ('2016-01-01'::date) TO ('2016-07-01'::date);
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES_2016_2nd_semiyear
	PARTITION OF BL_DM.FCT_SALES FOR VALUES FROM ('2016-07-01'::date) TO ('2017-01-01'::date);
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES_2017_1st_semiyear
	PARTITION OF BL_DM.FCT_SALES FOR VALUES FROM ('2017-01-01'::date) TO ('2017-07-01'::date);
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES_2017_2nd_semiyear
	PARTITION OF BL_DM.FCT_SALES FOR VALUES FROM ('2017-07-01'::date) TO ('2018-01-01'::date);
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES_2018_1st_semiyear
	PARTITION OF BL_DM.FCT_SALES FOR VALUES FROM ('2018-01-01'::date) TO ('2018-07-01'::date);
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES_2018_2nd_semiyear
	PARTITION OF BL_DM.FCT_SALES FOR VALUES FROM ('2018-07-01'::date) TO ('2019-01-01'::date);
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES_2019_1st_semiyear
	PARTITION OF BL_DM.FCT_SALES FOR VALUES FROM ('2019-01-01'::date) TO ('2019-07-01'::date);
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES_2019_2nd_semiyear
	PARTITION OF BL_DM.FCT_SALES FOR VALUES FROM ('2019-07-01'::date) TO ('2020-01-01'::date);
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES_2020_1st_semiyear
	PARTITION OF BL_DM.FCT_SALES FOR VALUES FROM ('2020-01-01'::date) TO ('2020-07-01'::date);
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES_2020_2nd_semiyear
	PARTITION OF BL_DM.FCT_SALES FOR VALUES FROM ('2020-07-01'::date) TO ('2021-01-01'::date);
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES_2021_1st_semiyear
	PARTITION OF BL_DM.FCT_SALES FOR VALUES FROM ('2021-01-01'::date) TO ('2021-07-01'::date);
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES_2021_2nd_semiyear
	PARTITION OF BL_DM.FCT_SALES FOR VALUES FROM ('2021-07-01'::date) TO ('2022-01-01'::date);
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES_2022_1st_semiyear
	PARTITION OF BL_DM.FCT_SALES FOR VALUES FROM ('2022-01-01'::date) TO ('2022-07-01'::date);
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES_2022_2nd_semiyear
	PARTITION OF BL_DM.FCT_SALES FOR VALUES FROM ('2022-07-01'::date) TO ('2023-01-01'::date);
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES_2023_1st_semiyear
	PARTITION OF BL_DM.FCT_SALES FOR VALUES FROM ('2023-01-01'::date) TO ('2023-07-01'::date);
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES_2023_2nd_semiyear
	PARTITION OF BL_DM.FCT_SALES FOR VALUES FROM ('2023-07-01'::date) TO ('2024-01-01'::date);
	
	CREATE TABLE IF NOT EXISTS BL_DM.FCT_SALES_2024_1st_semiyear
	PARTITION OF BL_DM.FCT_SALES FOR VALUES FROM ('2024-01-01'::date) TO ('2024-07-01'::date);
	
	--ALTER TABLE BL_DM.FCT_SALES DETACH PARTITION FCT_SALES_1st_semiyear;
	--DROP TABLE  FCT_SALES_1st_semiyear;

	RETURN;
END;$$;


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


CREATE OR REPLACE PROCEDURE BL_CL.prc_load_dim_dates()
LANGUAGE plpgsql
AS $$
DECLARE rows_affected int;
BEGIN 
	
	
	WITH load_query AS 
	(
		INSERT INTO BL_DM.DIM_DATES (DATE_SURR_ID, DAY, MONTH, YEAR, SOURCE_SYSTEM, SOURCE_ENTITY)
		SELECT d::DATE, EXTRACT(DAY FROM d), EXTRACT(MONTH FROM d), EXTRACT(YEAR FROM d), 'MANUAL', 'MANUAL'
		FROM generate_series('2010-01-01'::DATE, '2025-01-01'::DATE, '1 day') d
		LEFT JOIN BL_DM.DIM_DATES t ON d::DATE = t.DATE_SURR_ID
		WHERE t.DATE_SURR_ID IS NULL
		RETURNING *
	)

	SELECT count (*) INTO rows_affected FROM load_query;
	
    CALL BL_CL.prc_load_log('prc_load_dim_dates', 'BL_DM', 'DIM_DATES', rows_affected);

	RETURN ;

EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;


CREATE OR REPLACE PROCEDURE BL_CL.prc_load_dim_employees_scd()
LANGUAGE plpgsql
AS $$
DECLARE 
	rows_affected int;
	rows_affected2 int;
BEGIN 
	
	WITH update_query AS (
		UPDATE bl_dm.dim_employees_scd des
		SET is_active = FALSE, end_dt = current_date, ta_update_dt = current_date
		WHERE EXISTS (
				SELECT 1 FROM bl_3nf.ce_employees_scd ces WHERE des.badge = ces.badge AND des.email != ces.email AND des.start_dt < ces.start_dt
		)
		RETURNING *
	)
	
	SELECT count(*) INTO rows_affected2 FROM update_query;
	
	WITH load_query AS (
		INSERT INTO BL_DM.DIM_EMPLOYEES_SCD (EMPLOYEE_SURR_ID, FIRSTNAME, LASTNAME, EMAIL, BADGE, START_DT, END_DT, IS_ACTIVE, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
	
		SELECT  nextval('bl_dm.dim_employees_scd_surr_id_seq'), *
		FROM (
			SELECT FIRSTNAME, LASTNAME, EMAIL, BADGE, START_DT, END_DT, IS_ACTIVE, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, EMPLOYEE_ID::varchar AS SOURCE_ID
			FROM bl_3nf.ce_employees_scd ces 
			-- WHERE NOT EXISTS (SELECT 1 FROM bl_dm.dim_employees_scd des WHERE des.email = ces.email AND des.badge = ces.badge)
			WHERE NOT EXISTS (SELECT 1 FROM bl_dm.dim_employees_scd des WHERE ces.employee_id::varchar = des.source_id)
				AND ces.employee_id != -1
		)
		RETURNING *
	)
	
	SELECT count(*) INTO rows_affected FROM load_query;

	CALL BL_CL.prc_load_log('prc_load_dim_employees_scd', 'BL_DM', 'DIM_EMPLOYEES_SCD', rows_affected + rows_affected2);

	RETURN;

EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;


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


CREATE OR REPLACE PROCEDURE BL_CL.prc_load_fct_sales()
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

		RETURNING *
	)
	
	SELECT count(*) INTO rows_affected FROM load_query;

	CALL BL_CL.prc_load_log('prc_load_fct_sales', 'BL_DM', 'FCT_SALES', rows_affected);

	RETURN;

EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;


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


CREATE OR REPLACE PROCEDURE bl_cl.prc_load_bl_dm()
LANGUAGE plpgsql
AS $$
BEGIN 
	
	CALL bl_cl.prc_load_dim_dates();
	CALL bl_cl.prc_load_dim_products();
	CALL bl_cl.prc_load_dim_models();
	CALL bl_cl.prc_load_dim_customers();
	CALL bl_cl.prc_load_dim_employees_scd();
	-- CALL bl_cl.prc_load_fct_sales();
	CALL bl_cl.prc_load_fct_sales_increment('2010-01-01'::date);

END;$$;


CREATE OR REPLACE PROCEDURE bl_cl.prc_load_init_bl_dm()
LANGUAGE plpgsql
AS $$
BEGIN 
	
	-- CALL bl_cl.prc_load_init_log_bl_dm();
	CALL bl_cl.prc_load_init_dim_dates();
	CALL bl_cl.prc_load_init_dim_products();
	CALL bl_cl.prc_load_init_dim_models();
	CALL bl_cl.prc_load_init_dim_customers();
	CALL bl_cl.prc_load_init_dim_employees_scd();
	CALL bl_cl.prc_load_init_fct_sales();
END;$$;