BEGIN;

INSERT INTO BL_DM.DIM_CUSTOMERS (CUSTOMER_SURR_ID, FIRSTNAME, LASTNAME, EMAIL, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)

SELECT nextval('bl_dm.dim_customers_surr_id_seq'), *
	FROM (
	
	SELECT FIRSTNAME, LASTNAME, EMAIL, current_date AS ins_dt, current_date AS upd_dt, 'BL_3NF', 'CE_CUSTOMERS', CUSTOMER_ID::VARCHAR AS SOURCE_ID  
	FROM bl_3nf.ce_customers cc 
	
	WHERE NOT EXISTS (SELECT 1 FROM bl_dm.dim_customers dc WHERE cc.customer_id::varchar = dc.SOURCE_ID)
	AND cc.customer_id != -1 -- FOR DEFAULT row
) 
RETURNING *;

COMMIT;

