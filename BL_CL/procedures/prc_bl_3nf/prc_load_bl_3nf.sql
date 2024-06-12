CREATE OR REPLACE PROCEDURE bl_cl.prc_load_bl_3nf()
LANGUAGE plpgsql
AS $$
BEGIN 
		
	CALL bl_cl.prc_load_ce_states();
	CALL bl_cl.prc_load_ce_colors();
	CALL bl_cl.prc_load_ce_brands();
	CALL bl_cl.prc_load_ce_dates();
	CALL bl_cl.prc_load_ce_products();
	CALL bl_cl.prc_load_ce_models();
	CALL bl_cl.prc_load_ce_customers();
	-- CALL bl_cl.prc_load_ce_employees_scd();
	CALL bl_cl.prc_load_ce_employees_scd_increment();
	-- CALL bl_cl.prc_load_ce_sales();
	CALL bl_cl.prc_load_ce_sales_increment('2010-01-01'::date);

END;$$;