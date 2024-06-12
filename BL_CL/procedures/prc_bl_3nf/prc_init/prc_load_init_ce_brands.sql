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