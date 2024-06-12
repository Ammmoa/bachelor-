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