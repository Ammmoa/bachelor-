CREATE OR REPLACE PROCEDURE bl_cl.prc_load_init_bl_3nf()
LANGUAGE plpgsql
AS $$
BEGIN 
	
	CALL bl_cl.prc_load_init_log();
	CALL bl_cl.prc_load_init_ce_brands();	
	CALL bl_cl.prc_load_init_ce_states();	
	CALL bl_cl.prc_load_init_ce_colors();	
	CALL bl_cl.prc_load_init_ce_dates();	
	CALL bl_cl.prc_load_init_ce_products();	
	CALL bl_cl.prc_load_init_ce_models();	
	CALL bl_cl.prc_load_init_ce_customers();	
	CALL bl_cl.prc_load_init_ce_employees_scd();	
	CALL bl_cl.prc_load_init_ce_sales();

END;$$;