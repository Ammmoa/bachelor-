BEGIN;

INSERT INTO BL_DM.DIM_PRODUCTS1 (PRODUCT_SURR_ID, VIN, COLOR, COLOR_ID, INTERIOR, INTERIOR_ID, ODOMETER, CONDITION, STATE, STATE_ID, 
									TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)

SELECT nextval('bl_dm.dim_products_surr_id_seq'), *
FROM (
SELECT  cp.vin, cc.color, cc.color_id, cc2.color AS inte, cc2.color_id AS inte_id, cp.odometer, cp."condition",
		cs.state, cs.state_id, current_date, current_date, 'BL_3NF', 'CE_SATATES|CE_COLORS|CE_PRODUCTS', cp.product_id::varchar
FROM bl_3nf.ce_products1 cp 
LEFT JOIN bl_3nf.ce_states cs ON cp.state_id = cs.state_id 
LEFT JOIN bl_3nf.ce_colors cc ON cp.color_id = cc.color_id 
LEFT JOIN bl_3nf.ce_colors cc2 ON cp.interior_id = cc2.color_id 
WHERE NOT EXISTS (SELECT 1 FROM bl_dm.dim_products dp WHERE cp.product_id::varchar = dp.source_id)
		AND cp.product_id != -1

) AS products_vals (VIN, COLOR, COLOR_ID, INTERIOR, INTERIOR_ID, ODOMETER, CONDITION, STATE, STATE_ID, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)

RETURNING *;

COMMIT;


-- TEST DATA VOLUME. VALUE SHOULD BE THE SAME FOR BL_3NF AND BL_DM PRODUCT TABLES
--SELECT count(*) FROM bl_3nf.ce_products;-- 1109133
--SELECT count(*) FROM bl_dm.dim_products;-- 1109133
--
--TRUNCATE bl_dm.dim_products1;