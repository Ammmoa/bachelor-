CREATE OR REPLACE PROCEDURE BL_CL.prc_load_init_ce_brands()
LANGUAGE plpgsql
AS $$
DECLARE
	rows_affected int;
BEGIN 
	
	CREATE TABLE IF NOT EXISTS BL_3NF.CE_BRANDS(BRAND_ID int PRIMARY KEY, BRAND varchar(20), TA_INSERT_DT date, TA_UPDATE_DT date, SOURCE_SYSTEM varchar(50), SOURCE_ENTITY varchar(50), SOURCE_ID varchar(50)); 
		
	CREATE SEQUENCE IF NOT EXISTS bl_3nf.ce_brands_id_seq START 1;
	
	ALTER TABLE bl_3nf.ce_brands 
	ALTER COLUMN brand_id SET DEFAULT nextval('bl_3nf.ce_brands_id_seq');

	WITH load_query AS 
	(
		INSERT INTO BL_3NF.CE_BRANDS (BRAND_ID, BRAND, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		SELECT -1, 'n. a.', '1-1-1900', '1-1-1900', 'MANUAL', 'MANUAL', 'n. a.'
		WHERE NOT EXISTS (SELECT * FROM BL_3NF.CE_BRANDS c WHERE c.BRAND_ID = -1)
		RETURNING *
	)

	SELECT count (*) INTO rows_affected FROM load_query;
	
    CALL BL_CL.prc_load_log('prc_load_init_ce_brands', 'BL_3NF', 'CE_BRANDS', rows_affected);

	RETURN ;
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;


CREATE OR REPLACE PROCEDURE BL_CL.prc_load_init_ce_states()
LANGUAGE plpgsql
AS $$
DECLARE
	rows_affected int;
BEGIN 
	CREATE TABLE IF NOT EXISTS BL_3NF.CE_STATES (STATE_ID int PRIMARY KEY, STATE varchar(10), TA_INSERT_DT date, TA_UPDATE_DT date, SOURCE_SYSTEM varchar(50), SOURCE_ENTITY varchar(50), SOURCE_ID varchar(50)); 
		
	CREATE SEQUENCE IF NOT EXISTS bl_3nf.ce_states_id_seq START 1;

	ALTER TABLE bl_3nf.ce_states 
	ALTER COLUMN state_id SET DEFAULT nextval('bl_3nf.ce_states_id_seq'); 

	WITH load_query AS 
	(
		INSERT INTO BL_3NF.CE_STATES (STATE_ID, STATE, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		SELECT -1, 'n. a.', '1-1-1900', '1-1-1900', 'MANUAL', 'MANUAL', 'n. a.'
		WHERE NOT EXISTS (SELECT * FROM BL_3NF.CE_STATES s WHERE s.STATE_ID = -1)

		RETURNING *
	)

	SELECT count (*) INTO rows_affected FROM load_query;
	
    CALL BL_CL.prc_load_log('prc_load_init_ce_states', 'BL_3NF', 'CE_STATES', rows_affected);

	RETURN ;
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;


CREATE OR REPLACE PROCEDURE BL_CL.prc_load_init_ce_colors()
LANGUAGE plpgsql
AS $$
DECLARE
	rows_affected int;
BEGIN 
	CREATE TABLE IF NOT EXISTS BL_3NF.CE_COLORS(COLOR_ID int PRIMARY KEY, COLOR varchar(20), TA_INSERT_DT date, TA_UPDATE_DT date, SOURCE_SYSTEM varchar(50), SOURCE_ENTITY varchar(50), SOURCE_ID varchar(50)); 
		
	CREATE SEQUENCE IF NOT EXISTS bl_3nf.ce_colors_id_seq START 1;

	ALTER TABLE bl_3nf.ce_colors
	ALTER COLUMN color_id SET DEFAULT nextval('bl_3nf.ce_colors_id_seq');

	WITH load_query AS 
	(
		INSERT INTO BL_3NF.CE_COLORS (COLOR_ID, COLOR, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID) 
		SELECT -1, 'n. a.', '1-1-1900', '1-1-1900', 'MANUAL', 'MANUAL', 'n. a.'
		WHERE NOT EXISTS (SELECT * FROM BL_3NF.CE_COLORS c WHERE c.COLOR_ID = -1)
		RETURNING *
	)

	SELECT count (*) INTO rows_affected FROM load_query;
	
    CALL BL_CL.prc_load_log('prc_load_init_ce_colors', 'BL_3NF', 'CE_COLORS', rows_affected);

	RETURN ;
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;


CREATE OR REPLACE PROCEDURE BL_CL.prc_load_init_ce_customers()
LANGUAGE plpgsql
AS $$
DECLARE rows_default int;
BEGIN 
	
	CREATE TABLE IF NOT EXISTS BL_3NF.CE_CUSTOMERS (
	CUSTOMER_ID int PRIMARY KEY,
	FIRSTNAME varchar(30),
	LASTNAME varchar(30),
	EMAIL varchar(50),
	TA_INSERT_DT date,
	TA_UPDATE_DT date,
	SOURCE_SYSTEM varchar(50),
	SOURCE_ENTITY varchar(50),
	SOURCE_ID varchar(50)
	);

	CREATE SEQUENCE IF NOT EXISTS bl_3nf.ce_customers_id_seq START 1;
	
	ALTER TABLE bl_3nf.ce_customers 
	ALTER COLUMN customer_id SET DEFAULT nextval('bl_3nf.ce_customers_id_seq');

	WITH load_default AS 
	(
		INSERT INTO BL_3NF.CE_CUSTOMERS (CUSTOMER_ID, FIRSTNAME, LASTNAME, EMAIL, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		SELECT -1, 'n. a.', 'n. a.', 'n. a.', '1-1-1900', '1-1-1900', 'MANUAL', 'MANUAL', 'n. a.'
		WHERE NOT EXISTS (
		SELECT * FROM BL_3NF.CE_CUSTOMERS c WHERE c.CUSTOMER_ID = -1
		)
		RETURNING *
	)
	
	SELECT count (*) INTO rows_default FROM load_default;

    CALL BL_CL.prc_load_log('prc_load_init_ce_customers', 'BL_3NF', 'CE_CUSTOMERS', rows_default);

	RETURN ;
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;


CREATE OR REPLACE PROCEDURE BL_CL.prc_load_init_ce_dates()
LANGUAGE plpgsql
AS $$
DECLARE rows_affected int;
BEGIN 
	CREATE TABLE IF NOT EXISTS BL_3NF.CE_DATES(DATE_ID DATE PRIMARY KEY, DAY SMALLINT NOT NULL, MONTH SMALLINT NOT NULL, YEAR int2 NOT NULL); 
		
	WITH load_query AS 
	(
		INSERT INTO BL_3NF.CE_DATES (DATE_ID, DAY, MONTH, YEAR)
		SELECT '1-1-1900', -1, -1, -1
		WHERE NOT EXISTS (
		SELECT * FROM BL_3NF.CE_DATES d WHERE d.DATE_ID = '1-1-1900'
		)
		RETURNING *
	)

	SELECT count (*) INTO rows_affected FROM load_query;
	
    CALL BL_CL.prc_load_log('prc_load_init_ce_dates', 'BL_3NF', 'CE_DATES', rows_affected);

	RETURN ;
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;


CREATE OR REPLACE PROCEDURE BL_CL.prc_load_init_ce_employees_scd()
LANGUAGE plpgsql
AS $$
DECLARE rows_default int;
BEGIN 
	
	CREATE TABLE IF NOT EXISTS BL_3NF.CE_EMPLOYEES_SCD (
	EMPLOYEE_ID int,
	LASTNAME VARCHAR(30),
	FIRSTNAME VARCHAR(30),
	EMAIL VARCHAR(50),
	BADGE VARCHAR(10),
	START_DT DATE, 
	END_DT DATE,
	IS_ACTIVE BOOL,
	TA_INSERT_DT date,
	TA_UPDATE_DT date,
	SOURCE_SYSTEM varchar(50),
	SOURCE_ENTITY varchar(50),
	SOURCE_ID varchar(50),
	PRIMARY KEY (EMPLOYEE_ID, START_DT)
	);

	CREATE SEQUENCE IF NOT EXISTS bl_3nf.ce_employees_scd_id_seq START 1;

	ALTER TABLE bl_3nf.ce_employees_scd
	ALTER COLUMN employee_id SET DEFAULT nextval('bl_3nf.ce_employees_scd_id_seq');

	WITH load_default AS 
	(
		INSERT INTO BL_3NF.CE_EMPLOYEES_SCD (EMPLOYEE_ID, LASTNAME, FIRSTNAME, EMAIL, BADGE, START_DT, END_DT, IS_ACTIVE, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		SELECT -1, 'n. a.', 'n. a.', 'n. a.', 'n. a.', '1-1-1900', '9999-12-31'::date, True, '1-1-1900', '1-1-1900', 'MANUAL', 'MANUAL', 'n. a.'
		WHERE NOT EXISTS (
		SELECT * FROM BL_3NF.CE_EMPLOYEES_SCD e WHERE e.EMPLOYEE_ID = -1
		)
		RETURNING *
	)
	
	SELECT count (*) INTO rows_default FROM load_default;

	

    CALL BL_CL.prc_load_log('prc_load_init_ce_employees_scd', 'BL_3NF', 'CE_EMPLOYEES_SCD', rows_default);

	RETURN ;
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;


CREATE OR REPLACE PROCEDURE BL_CL.prc_load_init_ce_models()
LANGUAGE plpgsql
AS $$
DECLARE
	rows_default int;
BEGIN 
	
	CREATE TABLE IF NOT EXISTS BL_3NF.CE_MODELS (
	MODEL_ID int PRIMARY KEY,
	MODEL varchar(50),
	BRAND_ID SMALLINT REFERENCES BL_3NF.CE_BRANDS(BRAND_ID) NOT NULL,
	BODY varchar(50),
	TRANSMISSION varchar(50),
	YEAR int2,
	TA_INSERT_DT date,
	TA_UPDATE_DT date,
	SOURCE_SYSTEM varchar(50),
	SOURCE_ENTITY varchar(50),
	SOURCE_ID varchar(50)
	);

	CREATE SEQUENCE IF NOT EXISTS bl_3nf.ce_models_id_seq START 1;
	
	ALTER TABLE bl_3nf.ce_models
	ALTER COLUMN model_id SET DEFAULT nextval('bl_3nf.ce_models_id_seq');

	WITH load_default AS 
	(
		INSERT INTO BL_3NF.CE_MODELS (MODEL_ID, MODEL, BRAND_ID, BODY, TRANSMISSION, YEAR, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		SELECT -1, 'n. a.', -1, 'n. a.', 'n. a.', -1, '1-1-1900', '1-1-1900', 'MANUAL', 'MANUAL', 'n. a.'
		WHERE NOT EXISTS (
		SELECT * FROM BL_3NF.CE_MODELS m WHERE m.MODEL_ID = -1
		)
		RETURNING *
	)
	
	SELECT count (*) INTO rows_default FROM load_default;


    CALL BL_CL.prc_load_log('prc_load_init_ce_models', 'BL_3NF', 'CE_MODELS', rows_default);

	RETURN ;
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;


CREATE OR REPLACE PROCEDURE BL_CL.prc_load_init_ce_products()
LANGUAGE plpgsql
AS $$
DECLARE
	rows_default int;
BEGIN 
	CREATE TABLE IF NOT EXISTS BL_3NF.CE_PRODUCTS (
	PRODUCT_ID int PRIMARY KEY,
	VIN varchar(17) UNIQUE,
	COLOR_ID int REFERENCES BL_3NF.CE_COLORS(COLOR_ID) NOT NULL,
	INTERIOR_ID int REFERENCES BL_3NF.CE_COLORS(COLOR_ID) NOT NULL,
	CONDITION decimal,
	ODOMETER decimal,
	STATE_ID SMALLINT REFERENCES BL_3NF.CE_STATES(STATE_ID) NOT NULL,
	TA_INSERT_DT date,
	TA_UPDATE_DT date,
	SOURCE_SYSTEM varchar(50),
	SOURCE_ENTITY varchar(50),
	SOURCE_ID varchar(50)
	);

	CREATE SEQUENCE IF NOT EXISTS bl_3nf.ce_products_id_seq START 1;

	ALTER TABLE bl_3nf.ce_products
	ALTER COLUMN product_id SET DEFAULT nextval('bl_3nf.ce_products_id_seq');  

	WITH load_default AS 
	(
		INSERT INTO BL_3NF.CE_PRODUCTS (PRODUCT_ID, VIN, COLOR_ID, INTERIOR_ID, CONDITION, ODOMETER, STATE_ID, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		SELECT -1, 'n. a.', -1, -1, -1, -1, -1, '1-1-1900', '1-1-1900', 'MANUAL', 'MANUAL', 'n. a.'
		WHERE NOT EXISTS (
		SELECT * FROM BL_3NF.CE_PRODUCTS p WHERE p.PRODUCT_ID = -1
		)
		RETURNING *
	)
	
	SELECT count (*) INTO rows_default FROM load_default;


    CALL BL_CL.prc_load_log('prc_load_init_ce_products', 'BL_3NF', 'CE_PRODUCTS', rows_default);

	RETURN ;
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;


-- procedure of load sales fact
CREATE OR REPLACE PROCEDURE BL_CL.prc_load_init_ce_sales()
LANGUAGE plpgsql
AS $$
BEGIN 
	
	CREATE TABLE IF NOT EXISTS BL_3NF.CE_SALES (
	SALE_ID INT PRIMARY KEY,
	CUSTOMER_ID INT REFERENCES BL_3NF.CE_CUSTOMERS(CUSTOMER_ID),
	EMPLOYEE_ID INT,
	MODEL_ID INT REFERENCES BL_3NF.CE_MODELS(MODEL_ID),
	PRODUCT_ID INT REFERENCES BL_3NF.CE_PRODUCTS(PRODUCT_ID),
	MMR decimal,
	AMOUNT decimal,
	DATE_ID DATE REFERENCES BL_3NF.CE_DATES(DATE_ID),
	TIME TIME,
	TA_INSERT_DT date,
	TA_UPDATE_DT date,
	SOURCE_SYSTEM varchar(50),
	SOURCE_ENTITY varchar(50),
	SOURCE_ID varchar(50)
	);

	CREATE SEQUENCE IF NOT EXISTS bl_3nf.ce_sales_id_seq START 1;
	
	ALTER TABLE bl_3nf.ce_sales 
	ALTER COLUMN sale_id SET DEFAULT nextval('bl_3nf.ce_sales_id_seq'); 

	RETURN;
END;$$;


CREATE OR REPLACE PROCEDURE BL_CL.prc_load_ce_states()
LANGUAGE plpgsql
AS $$
DECLARE
	rows_affected int;
BEGIN 
		
	WITH load_query AS 
	(
		INSERT INTO BL_3NF.CE_STATES (STATE_ID, STATE, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		
		SELECT nextval('bl_3nf.ce_states_id_seq') AS STATE_ID, *
		FROM (
		SELECT tms.state_name , current_date, current_date, 'BL_CL', 'T_MAP_STATES', min(tms.state_id)
		FROM bl_cl.t_map_states tms 
		GROUP BY tms.state_name 
		) AS states_map (STATE, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		
		WHERE NOT EXISTS (
		SELECT * FROM BL_3NF.CE_STATES s WHERE s.state = states_map.state
		)
		
		RETURNING *
	)

	SELECT count (*) INTO rows_affected FROM load_query;
	
    CALL BL_CL.prc_load_log('prc_load_ce_states', 'BL_3NF', 'CE_STATES', rows_affected);

	RETURN ;
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;


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


CREATE OR REPLACE PROCEDURE BL_CL.prc_load_ce_colors()
LANGUAGE plpgsql
AS $$
DECLARE
	rows_affected int;
BEGIN 
		
	WITH load_query AS 
	(
		INSERT INTO BL_3NF.CE_COLORS (COLOR_ID, COLOR, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)

		SELECT nextval('bl_3nf.ce_colors_id_seq'), * 
		FROM (
			SELECT DISTINCT color, current_date, current_date, 'BL_CL', 'T_MAP_COLORS', min(color_id)
			FROM BL_CL.t_map_colors 
			GROUP BY color
		) AS colors_vals (COLOR, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		WHERE NOT EXISTS (
		SELECT * FROM BL_3NF.CE_COLORS c WHERE c.color = colors_vals.color
		)
		RETURNING *
	)

	SELECT count (*) INTO rows_affected FROM load_query;
	
    CALL BL_CL.prc_load_log('prc_load_ce_colors', 'BL_3NF', 'CE_COLORS', rows_affected);

	RETURN ;
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;


CREATE OR REPLACE PROCEDURE BL_CL.prc_load_ce_customers()
LANGUAGE plpgsql
AS $$
DECLARE
	rows_affected1 int;
	rows_affected2 int;
BEGIN 
		
	WITH load_query1 AS 
	(
		-- dataset_1
		INSERT INTO BL_3NF.CE_CUSTOMERS (CUSTOMER_ID, FIRSTNAME, LASTNAME, EMAIL, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID) 

		SELECT nextval('bl_3nf.ce_customers_id_seq'), *
		FROM (
			SELECT DISTINCT sd.customer_name, sd.customer_surname, sd.customer_contact, current_date, current_date, 
							'SA_CARSALES_1' AS SOURCE_SYSTEM, 'SRC_CARSALES_1' AS SOURCE_ENTITY, 'n. a.' AS SOURCE_ID
			FROM sa_carsales_1.src_carsales_1 sd
			WHERE sd.customer_contact LIKE '%@%'
				AND NOT EXISTS (
				SELECT * FROM BL_3NF.CE_CUSTOMERS c WHERE c.EMAIL = sd.customer_contact
				)
		)
		RETURNING *
	)

	SELECT count (*) INTO rows_affected1 FROM load_query1;


	WITH load_query2 AS 
	(
		-- dataset_2
		INSERT INTO BL_3NF.CE_CUSTOMERS (CUSTOMER_ID, FIRSTNAME, LASTNAME, EMAIL, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID) 

		SELECT nextval('bl_3nf.ce_customers_id_seq'), *
		FROM (
			SELECT DISTINCT split_part(sd.customer_fullname, ' ', 1) AS first_name, split_part(sd.customer_fullname, ' ', 2) AS customer_surname, 
							sd.customer_contact, current_date, current_date, 
							'SA_CARSALES_2' AS SOURCE_SYSTEM, 'SRC_CARSALES_2' AS SOURCE_ENTITY, 'n. a.' AS SOURCE_ID
			FROM sa_carsales_2.src_carsales_2 sd
			WHERE sd.customer_contact LIKE '%@%'
				AND NOT EXISTS (
				SELECT * FROM BL_3NF.CE_CUSTOMERS c WHERE c.EMAIL = sd.customer_contact 
				)
		)
		RETURNING *
	)

	SELECT count (*) INTO rows_affected2 FROM load_query2;

    CALL BL_CL.prc_load_log('prc_load_ce_customers', 'BL_3NF', 'CE_CUSTOMERS', rows_affected1 + rows_affected2);

   
	RETURN ;
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;


CREATE OR REPLACE PROCEDURE BL_CL.prc_load_ce_dates()
LANGUAGE plpgsql
AS $$
DECLARE rows_affected int;
BEGIN 
		
	WITH load_query AS 
	(
		INSERT INTO BL_3NF.CE_DATES (DATE_ID, DAY, MONTH, YEAR)
		SELECT d::DATE, EXTRACT(DAY FROM d), EXTRACT(MONTH FROM d), EXTRACT(YEAR FROM d)
		FROM generate_series('2010-01-01'::DATE, '2025-01-01'::DATE, '1 day') d
		LEFT JOIN BL_3NF.CE_DATES t ON d::DATE = t.DATE_ID
		WHERE t.DATE_ID IS NULL
		RETURNING *
	)

	SELECT count (*) INTO rows_affected FROM load_query;
	
    CALL BL_CL.prc_load_log('prc_load_ce_dates', 'BL_3NF', 'CE_DATES', rows_affected);

	RETURN ;
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;


CREATE OR REPLACE PROCEDURE BL_CL.prc_load_ce_employees_scd()
LANGUAGE plpgsql
AS $$
DECLARE 
	rows_affected1 int;
	rows_affected2 int;
BEGIN 
	
	-- scd 2 logic
	WITH update_emps AS 
	(
		UPDATE bl_3nf.ce_employees_scd ces
		SET end_dt = current_date, is_active = FALSE, ta_update_dt = current_date
		WHERE EXISTS 
		(
			SELECT 1 
			FROM (
				SELECT DISTINCT split_part(sd.employee, ' ', 1) AS name, split_part(sd.employee, ' ', 2) AS surname, employee_contact, employee_badge, 
								'1-1-2010'::date AS start_date, '9999-12-31'::date AS end_date, TRUE AS is_active, 
										current_date, current_date, 'SA_CARSALES_1' AS SOURCE_SYSTEM, 'SRC_CARSALES_1' AS SOURCE_ENTITY, 'n. a.' AS SOURCE_ID
				FROM sa_carsales_1.src_carsales_1 sd
			) AS emp_vals	
		
		WHERE ces.badge = emp_vals.employee_badge AND ces.email != emp_vals.employee_contact AND ces.start_dt < emp_vals.start_date 
		)
		RETURNING *
	)
	
	SELECT count (*) INTO rows_affected2 FROM update_emps;


	WITH load_emps AS 
	(
		INSERT INTO bl_3nf.ce_employees_scd (EMPLOYEE_ID, LASTNAME, FIRSTNAME, EMAIL, BADGE, START_DT, END_DT, IS_ACTIVE, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		
		SELECT nextval('bl_3nf.ce_employees_scd_id_seq'), *
		FROM (
		
			SELECT name, surname, employee_contact, employee_badge, start_date, end_date, is_active, current_date, current_date, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID	
			FROM (SELECT DISTINCT split_part(sd.employee, ' ', 1) AS name, split_part(sd.employee, ' ', 2) AS surname, employee_contact, employee_badge, 
							'1-1-2010'::date AS start_date, '9999-12-31'::date AS end_date, TRUE AS is_active, 
									current_date, current_date, 'SA_CARSALES_1' AS SOURCE_SYSTEM, 'SRC_CARSALES_1' AS SOURCE_ENTITY, 'n. a.' AS SOURCE_ID
				FROM sa_carsales_1.src_carsales_1 sd
			)
			WHERE NOT EXISTS (SELECT 1 FROM bl_3nf.ce_employees_scd ces WHERE ces.email = employee_contact AND ces.badge = employee_badge)
		
		) AS new_emp_vals (LASTNAME, FIRSTNAME, EMAIL, BADGE, START_DT, END_DT, IS_ACTIVE, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		RETURNING *
	)
	
	SELECT count (*) INTO rows_affected1 FROM load_emps;

	

    CALL BL_CL.prc_load_log('prc_load_ce_employees_scd', 'BL_3NF', 'CE_EMPLOYEES_SCD', rows_affected1 + rows_affected2);

	RETURN ;
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;


-- increment |same logic but newly added employees start date is defined explicitly|
CREATE OR REPLACE PROCEDURE BL_CL.prc_load_ce_employees_scd_increment()
LANGUAGE plpgsql
AS $$
DECLARE 
	rows_affected1 int;
	rows_affected2 int;
BEGIN 
	
	-- scd 2 logic
	WITH update_emps AS 
	(
		UPDATE bl_3nf.ce_employees_scd ces
		SET end_dt = current_date, is_active = FALSE, ta_update_dt = current_date
		WHERE EXISTS 
		(
			SELECT 1 
			FROM (
				SELECT DISTINCT split_part(sd.employee, ' ', 1) AS name, split_part(sd.employee, ' ', 2) AS surname, employee_contact, employee_badge, 
								CASE WHEN sd.employee IN ('Eka Eradze', 'Lursam Ninidze') THEN '2-2-2024'::date ELSE '1-1-2010'::date END AS start_date, 
								'9999-12-31'::date AS end_date, TRUE AS is_active, 
										current_date, current_date, 'SA_CARSALES_1' AS SOURCE_SYSTEM, 'SRC_CARSALES_1' AS SOURCE_ENTITY, 'n. a.' AS SOURCE_ID
				FROM sa_carsales_1.src_carsales_1 sd
			) AS emp_vals	
		
		WHERE ces.badge = emp_vals.employee_badge AND ces.email != emp_vals.employee_contact AND ces.start_dt < emp_vals.start_date 
		)
		RETURNING *
	)
	
	SELECT count (*) INTO rows_affected2 FROM update_emps;


	WITH load_emps AS 
	(
		INSERT INTO bl_3nf.ce_employees_scd (EMPLOYEE_ID, LASTNAME, FIRSTNAME, EMAIL, BADGE, START_DT, END_DT, IS_ACTIVE, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		
		SELECT nextval('bl_3nf.ce_employees_scd_id_seq'), *
		FROM (
		
			SELECT name, surname, employee_contact, employee_badge, start_date, end_date, is_active, current_date, current_date, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID	
			FROM (SELECT DISTINCT split_part(sd.employee, ' ', 1) AS name, split_part(sd.employee, ' ', 2) AS surname, employee_contact, employee_badge, 
							CASE WHEN sd.employee IN ('Eka Eradze', 'Lursam Ninidze') THEN '2-2-2024'::date ELSE '1-1-2010'::date END AS start_date, 
							'9999-12-31'::date AS end_date, TRUE AS is_active, 
									current_date, current_date, 'SA_CARSALES_1' AS SOURCE_SYSTEM, 'SRC_CARSALES_1' AS SOURCE_ENTITY, 'n. a.' AS SOURCE_ID
				FROM sa_carsales_1.src_carsales_1 sd
			)
			WHERE NOT EXISTS (SELECT 1 FROM bl_3nf.ce_employees_scd ces WHERE ces.email = employee_contact AND ces.badge = employee_badge)
		
		) AS new_emp_vals (LASTNAME, FIRSTNAME, EMAIL, BADGE, START_DT, END_DT, IS_ACTIVE, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
		RETURNING *
	)
	
	SELECT count (*) INTO rows_affected1 FROM load_emps;

	

    CALL BL_CL.prc_load_log('prc_load_ce_employees_scd_increment', 'BL_3NF', 'CE_EMPLOYEES_SCD', rows_affected1 + rows_affected2);

	RETURN ;
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;


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


CREATE OR REPLACE PROCEDURE BL_CL.prc_load_ce_products()
LANGUAGE plpgsql
AS $$
DECLARE
	rows_affected1 int;
	rows_affected2 int;
BEGIN 	
	
	WITH load_query1 AS 
	(
		-- dataset_1
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
		
		ON CONFLICT (vin)
		DO UPDATE
		SET "condition" = EXCLUDED."condition" ,
		    odometer = EXCLUDED.odometer,
		    color_id = (SELECT color_id FROM bl_3nf.ce_colors WHERE color_id = EXCLUDED.color_id),
		    interior_id = (SELECT color_id FROM bl_3nf.ce_colors WHERE color_id = EXCLUDED.interior_id),
			ta_update_dt = current_date
		RETURNING *
	)

	SELECT count (*) INTO rows_affected1 FROM load_query1;

	WITH load_query2 AS 
	(
		-- dataset_2
		
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
		RETURNING *
	)

	SELECT count (*) INTO rows_affected2 FROM load_query2;

    CALL BL_CL.prc_load_log('prc_load_ce_products', 'BL_3NF', 'CE_PRODUCTS', rows_affected1 + rows_affected2);

	RETURN ;
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'no data found';
    WHEN OTHERS THEN
        RAISE NOTICE 'error occurred: %', SQLERRM;
END;$$;


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


CREATE OR REPLACE PROCEDURE BL_CL.prc_load_ce_sales_increment(inc_start_dt date DEFAULT current_date - interval '7 days')
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
			LEFT JOIN BL_3NF.CE_MODELS m ON upper(sd.model) = m.model AND sd.year = m.YEAR::varchar AND upper(sd.body) = m.body AND sd.transmission = m.transmission
				AND cb.brand_id = m.brand_id
			WHERE NOT EXISTS (
				SELECT * FROM BL_3NF.CE_SALES s WHERE d.date_id = s.date_id AND CAST(TO_TIMESTAMP(sd.saledate, 'YYYY/MM/DD HH24:MI:SS AM') AS TIME) = s.time AND p.product_id = s.product_id AND m.model_id = s.model_id 
			)
			AND  CAST(sd.saledate AS TIMESTAMP)::DATE >= inc_start_dt -- filter by date PARAMETER. INCREMENT logic
		)
		RETURNING *
		
	)

	SELECT count(*) INTO rows_affected1 FROM load_query1;

	WITH load_query2 AS 
	(
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
			LEFT JOIN BL_3NF.CE_MODELS m ON upper(sd.model) = m.model AND sd.year = m.YEAR::varchar AND upper(sd.body) = m.body AND sd.transmission = m.transmission AND cb.brand_id = m.brand_id
			WHERE NOT EXISTS (
				SELECT * FROM BL_3NF.CE_SALES s WHERE d.date_id = s.date_id AND CAST(TO_TIMESTAMP(sd.saledate, 'YYYY/MM/DD HH24:MI:SS AM') AS TIME) = s.time
			)
			AND CAST(sd.saledate AS TIMESTAMP)::DATE >= inc_start_dt -- filter by date PARAMETER. INCREMENT logic
		)
		
		RETURNING *
	)
	SELECT count(*) INTO rows_affected2 FROM load_query2;

    CALL BL_CL.prc_load_log('prc_load_ce_sales_increment', 'BL_3NF', 'CE_SALES', rows_affected1 + rows_affected2);

	RETURN;
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'No data found.';
    WHEN OTHERS THEN
        RAISE NOTICE 'Error occurred: %', SQLERRM;
END;
$$;


CREATE OR REPLACE PROCEDURE bl_cl.prc_load_init_bl_3nf()
LANGUAGE plpgsql
AS $$
BEGIN 
	
	CALL bl_cl.prc_load_init_log();
	CALL bl_cl.prc_load_init_ce_brands();	
	CALL bl_cl.prc_load_init_ce_states();	
	CALL bl_cl.prc_load_init_ce_colors();	
	CALL bl_cl.prc_load_init_ce_dates();	
	CALL bl_cl.prc_load_init_ce_products();	
	CALL bl_cl.prc_load_init_ce_models();	
	CALL bl_cl.prc_load_init_ce_customers();	
	CALL bl_cl.prc_load_init_ce_employees_scd();	
	CALL bl_cl.prc_load_init_ce_sales();

END;$$;


CREATE OR REPLACE PROCEDURE bl_cl.prc_load_bl_3nf()
LANGUAGE plpgsql
AS $$
BEGIN 
		
	CALL bl_cl.prc_load_ce_states();
	CALL bl_cl.prc_load_ce_colors();
	CALL bl_cl.prc_load_ce_brands();
	CALL bl_cl.prc_load_ce_dates();
	CALL bl_cl.prc_load_ce_products();
	CALL bl_cl.prc_load_ce_models();
	CALL bl_cl.prc_load_ce_customers();
	-- CALL bl_cl.prc_load_ce_employees_scd();
	CALL bl_cl.prc_load_ce_employees_scd_increment();
	-- CALL bl_cl.prc_load_ce_sales();
	CALL bl_cl.prc_load_ce_sales_increment('2010-01-01'::date);

END;$$;