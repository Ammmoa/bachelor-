-- create tables
CREATE TABLE IF NOT EXISTS BL_CL.T_MAP_STATES (STATE_ID int NOT NULL, STATE_NAME varchar, STATE_SRC_NAME varchar, TA_INSERT_DT date, TA_UPDATE_DT date, SOURCE_SYSTEM varchar, SOURCE_ENTITY varchar, SOURCE_ID varchar);

CREATE TABLE IF NOT EXISTS BL_CL.T_MAP_COLORS (COLOR_ID int NOT NULL, COLOR varchar, COLOR_SRC_NAME varchar, TA_INSERT_DT date, TA_UPDATE_DT date, SOURCE_SYSTEM varchar, SOURCE_ENTITY varchar, SOURCE_ID varchar);

CREATE TABLE IF NOT EXISTS BL_CL.T_MAP_BRANDS (BRAND_ID int NOT NULL, BRAND_NAME varchar, BRAND_SRC_NAME varchar, TA_INSERT_DT date, TA_UPDATE_DT date, SOURCE_SYSTEM varchar, SOURCE_ENTITY varchar, SOURCE_ID varchar);

CREATE TABLE IF NOT EXISTS BL_CL.T_MAP_BMODELS (BMODEL_ID int NOT NULL, BMODEL_NAME varchar(50), BMODEL_SRC_NAME varchar(50), TA_INSERT_DT date, TA_UPDATE_DT date, SOURCE_SYSTEM varchar(50), SOURCE_ENTITY varchar(50), SOURCE_ID varchar(50));


-- create sequences
CREATE SEQUENCE IF NOT EXISTS bl_cl.t_map_states_id_seq START 1;
ALTER TABLE bl_cl.t_map_states 
ALTER COLUMN state_id SET DEFAULT nextval('bl_cl.t_map_states_id_seq');

CREATE SEQUENCE IF NOT EXISTS bl_cl.t_map_colors_id_seq START 1;
ALTER TABLE bl_cl.t_map_colors 
ALTER COLUMN color_id SET DEFAULT nextval('bl_cl.t_map_colors_id_seq'); 

CREATE SEQUENCE IF NOT EXISTS bl_cl.t_map_brands_id_seq START 1;
ALTER TABLE bl_cl.t_map_brands 
ALTER COLUMN brand_id SET DEFAULT nextval('bl_cl.t_map_brands_id_seq');

CREATE SEQUENCE IF NOT EXISTS bl_cl.t_map_bmodels_id_seq START 1;
ALTER TABLE bl_cl.t_map_bmodels 
ALTER COLUMN bmodel_id SET DEFAULT nextval('bl_cl.t_map_bmodels_id_seq'); 


-- deduplicate states

-- dataset_1 insertion		
BEGIN; 								
INSERT INTO BL_CL.T_MAP_STATES (STATE_ID, STATE_NAME, STATE_SRC_NAME, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)

SELECT nextval('bl_cl.t_map_states_id_seq'), *
FROM (
	SELECT DISTINCT upper(state), state, current_date, current_date, 'SA_CARSALES_1', 'SRC_CARSALES_1', 'n. a.' 
	FROM sa_carsales_1.src_carsales_1 sd 
	WHERE length(sd.state) = 2
) AS rows_list (STATE_NAME, STATE_SRC_NAME, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
WHERE NOT EXISTS (
	SELECT * FROM BL_CL.T_MAP_STATES s WHERE s.STATE_SRC_NAME = rows_list.STATE_SRC_NAME 
)

UNION ALL 
-- dataset_2 insertion		
SELECT  nextval('bl_cl.t_map_states_id_seq'), *
FROM (
	SELECT DISTINCT upper(state), state, current_date, current_date, 'SA_CARSALES_2', 'SRC_CARSALES_2', 'n. a.' 
	FROM sa_carsales_2.src_carsales_2 sd 
	WHERE length(sd.state) = 2
) AS sd (STATE_NAME, STATE_SRC_NAME, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
WHERE NOT EXISTS (
SELECT * FROM BL_CL.T_MAP_STATES s WHERE s.STATE_SRC_NAME = sd.STATE_SRC_NAME 
)
RETURNING *;
COMMIT;


-- deduplicate colors
-- color values are also in interior attribute, so we extract values by 2 select statements for 1 dataset

-- dataset_1 insertion		
BEGIN;
								
INSERT INTO BL_CL.T_MAP_COLORS (COLOR_ID, COLOR, COLOR_SRC_NAME, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
SELECT nextval('bl_cl.t_map_colors_id_seq'), *
FROM (
	SELECT DISTINCT upper(color), color, current_date, current_date, 'SA_CARSALES_1', 'SRC_CARSALES_1', 'n. a.' 
	FROM sa_carsales_1.src_carsales_1 sd 
	WHERE color ~ '^[a-zA-Z]+$'
	
	UNION
	
	SELECT DISTINCT upper(interior), interior, current_date, current_date, 'SA_CARSALES_1', 'SRC_CARSALES_1', 'n. a.' 
	FROM sa_carsales_1.src_carsales_1 sd 
	WHERE interior ~ '^[a-zA-Z]+$'
) AS rows_list (COLOR, COLOR_SRC_NAME, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
WHERE NOT EXISTS (
SELECT * FROM BL_CL.T_MAP_COLORS c WHERE c.COLOR_SRC_NAME = rows_list.COLOR_SRC_NAME 
)
RETURNING *;

COMMIT;
-- dataset_2 insertion		
-- no colors attribute in dataset_2	


-- deduplicate brands

BEGIN; 
-- dataset_1 insertion										
INSERT INTO BL_CL.T_MAP_BRANDS (BRAND_ID, BRAND_NAME, BRAND_SRC_NAME, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
SELECT nextval('bl_cl.t_map_brands_id_seq'), *
FROM (
	SELECT DISTINCT upper(make), make, current_date, current_date, 'SA_CARSALES_1', 'SRC_CARSALES_1', 'n. a.' 
	FROM sa_carsales_1.src_carsales_1 sd 
	WHERE make ~ '^[a-zA-Z -]+$'
) AS rows_list (BRAND_NAME, BRAND_SRC_NAME, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
WHERE NOT EXISTS (
SELECT * FROM BL_CL.T_MAP_BRANDS b WHERE b.BRAND_SRC_NAME = rows_list.BRAND_SRC_NAME 
)
UNION ALL 
-- dataset_2 insertion		
SELECT  nextval('bl_cl.t_map_brands_id_seq') AS BRAND_ID, 
		sd.BRAND_NAME, sd.BRAND_SRC_NAME, sd.TA_INSERT_DT, sd.TA_UPDATE_DT, sd.SOURCE_SYSTEM, sd.SOURCE_ENTITY, sd.SOURCE_ID
FROM (
	SELECT DISTINCT upper(make), make, current_date, current_date, 'SA_CARSALES_2', 'SRC_CARSALES_2', 'n. a.'
	FROM sa_carsales_2.src_carsales_2 sd 
	WHERE make ~ '^[a-zA-Z -]+$'
) AS sd (BRAND_NAME, BRAND_SRC_NAME, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
WHERE NOT EXISTS (
SELECT * FROM BL_CL.T_MAP_BRANDS b WHERE b.BRAND_SRC_NAME = sd.BRAND_SRC_NAME 
)
RETURNING *;

COMMIT;


-- deduplicate bmodels

BEGIN;
-- dataset_1 insertion										
INSERT INTO BL_CL.T_MAP_BMODELS (BMODEL_ID, BMODEL_NAME, BMODEL_SRC_NAME, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
SELECT nextval('bl_cl.t_map_bmodels_id_seq'), *
FROM (

	SELECT DISTINCT upper(model), model, current_date, current_date, 'SA_CARSALES_1', 'SRC_CARSALES_1', 'n. a.' 
	FROM sa_carsales_1.src_carsales_1  
	WHERE model IS NOT NULL 
	
) AS rows_list (BMODEL_NAME, BMODEL_SRC_NAME, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)

WHERE NOT EXISTS (
SELECT * FROM BL_CL.T_MAP_BMODELS b WHERE b.BMODEL_SRC_NAME = rows_list.BMODEL_SRC_NAME 
)

UNION ALL 
-- dataset_2 insertion		
SELECT  NEXTVAL('bl_cl.t_map_bmodels_id_seq'), *
FROM (
	SELECT DISTINCT upper(model), model, current_date, current_date, 'SA_CARSALES_2', 'SRC_CARSALES_2', 'n. a.'
	FROM sa_carsales_2.src_carsales_2 sd 
	WHERE model IS NOT NULL
	
) AS rows_list2 (BMODEL_NAME, BMODEL_SRC_NAME, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)

WHERE NOT EXISTS (
SELECT * FROM BL_CL.T_MAP_BMODELS b WHERE b.BMODEL_SRC_NAME = rows_list2.BMODEL_SRC_NAME 									
)
RETURNING *;

COMMIT;

