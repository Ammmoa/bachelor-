CREATE OR REPLACE PROCEDURE bl_cl.prc_load_init_bl_dm()
LANGUAGE plpgsql
AS $$
BEGIN 
	
	CALL bl_cl.prc_load_init_dim_dates();
	CALL bl_cl.prc_load_init_dim_products();
	CALL bl_cl.prc_load_init_dim_models();
	CALL bl_cl.prc_load_init_dim_customers();
	CALL bl_cl.prc_load_init_dim_employees_scd();
	CALL bl_cl.prc_load_init_fct_sales();
END;$$;