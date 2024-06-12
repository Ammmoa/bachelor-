CREATE OR REPLACE PROCEDURE BL_CL.prc_load_fct_sales_cursor()
LANGUAGE plpgsql
AS $$
DECLARE 
    rows_affected int;
    sale_record RECORD;
    dynamic_sql TEXT;
BEGIN
	
    DECLARE sale_cursor CURSOR FOR
        SELECT cs.amount, cs.mmr, cs.sale_id, cs.employee_id, cs.customer_id, cs.date_id, cs.model_id, cs.product_id, cs.time
        FROM bl_3nf.ce_sales cs
        WHERE NOT EXISTS (SELECT 1 FROM bl_dm.fct_sales fsa WHERE cs.sale_id::varchar = fsa.source_id);
	

    OPEN sale_cursor;

    LOOP
        FETCH sale_cursor INTO sale_record;
        EXIT WHEN NOT FOUND;

        dynamic_sql := 'INSERT INTO BL_DM.FCT_SALES (AMOUNT, MMR, PROFIT, EMPLOYEE_SURR_ID, CUSTOMER_SURR_ID, MODEL_SURR_ID, PRODUCT_SURR_ID, 
                DATE_SURR_ID, TIME, TA_INSERT_DT, TA_UPDATE_DT, SOURCE_SYSTEM, SOURCE_ENTITY, SOURCE_ID)
            VALUES (' || sale_record.amount || ', ' || sale_record.mmr || ', ' || (sale_record.amount - sale_record.mmr) || ', ' ||
                '(SELECT employee_surr_id FROM bl_dm.dim_employees_scd WHERE employee_surr_id = ' || sale_record.employee_id || '), ' ||
                '(SELECT customer_surr_id FROM bl_dm.dim_customers WHERE customer_surr_id = ' || sale_record.customer_id || '), ' ||
                '(SELECT model_surr_id FROM bl_dm.dim_models WHERE model_surr_id = ' || sale_record.model_id || '), ' ||
                '(SELECT product_surr_id FROM bl_dm.dim_products WHERE product_surr_id = ' || sale_record.product_id || '), ' ||
                '(SELECT date_surr_id FROM bl_dm.dim_dates WHERE date_surr_id = ' || sale_record.date_id || '), ' ||
                'TIMESTAMP ''' || sale_record.time || ''', CURRENT_DATE, CURRENT_DATE, ''BL_3NF'', ''CE_SALES'', ''' || sale_record.sale_id || ''')';

        EXECUTE dynamic_sql;
    END LOOP;

    CLOSE sale_cursor;

    GET DIAGNOSTICS rows_affected = ROW_COUNT;

    CALL BL_CL.prc_load_log('prc_load_fct_sales_cursor', 'BL_DM', 'FCT_SALES', rows_affected);

    RETURN;
EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'No data found.';
    WHEN OTHERS THEN
        RAISE NOTICE 'Error occurred: %', SQLERRM;
END;
$$;