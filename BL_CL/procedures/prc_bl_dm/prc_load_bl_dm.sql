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