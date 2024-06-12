CALL bl_cl.prc_load_init_bl_3nf();
CALL bl_cl.prc_load_bl_3nf();
CALL bl_cl.prc_load_init_bl_dm();
CALL bl_cl.prc_load_bl_dm();




-- increment demonstration
	CALL bl_cl.prc_load_ce_states();
	CALL bl_cl.prc_load_ce_colors();
	CALL bl_cl.prc_load_ce_brands();
	CALL bl_cl.prc_load_ce_dates();
	CALL bl_cl.prc_load_ce_products();
	CALL bl_cl.prc_load_ce_models();
	CALL bl_cl.prc_load_ce_customers();
	CALL bl_cl.prc_load_ce_employees_scd_increment();

	CALL bl_cl.prc_load_dim_dates();
	CALL bl_cl.prc_load_dim_products();
	CALL bl_cl.prc_load_dim_models();
	CALL bl_cl.prc_load_dim_customers();
	CALL bl_cl.prc_load_dim_employees_scd();

CALL BL_CL.prc_load_ce_sales_increment('2024-03-30'::date);
SELECT count(*) FROM bl_3nf.ce_sales cs; -- 1156438 -- 1173173

CALL BL_CL.prc_load_fct_sales_increment('2024-03-30'::date);
SELECT count(*) FROM bl_dm.fct_sales; -- 1092855

SELECT count(*) FROM sa_carsales_1.src_carsales_1 sc; 

