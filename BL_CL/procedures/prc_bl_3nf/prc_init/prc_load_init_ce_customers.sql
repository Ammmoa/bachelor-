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