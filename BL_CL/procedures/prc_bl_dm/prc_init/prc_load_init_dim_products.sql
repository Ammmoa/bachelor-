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