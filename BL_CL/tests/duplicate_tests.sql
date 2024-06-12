-- bl_3nf
SELECT (SELECT count(*) FROM (SELECT DISTINCT * FROM bl_3nf.ce_states)) = (SELECT count(*) FROM (SELECT  * FROM bl_3nf.ce_states));
SELECT (SELECT count(*) FROM (SELECT DISTINCT * FROM bl_3nf.ce_colors)) = (SELECT count(*) FROM (SELECT  * FROM bl_3nf.ce_colors));
SELECT (SELECT count(*) FROM (SELECT DISTINCT * FROM bl_3nf.ce_brands)) = (SELECT count(*) FROM (SELECT  * FROM bl_3nf.ce_brands));

SELECT (SELECT count(*) FROM (SELECT DISTINCT * FROM bl_3nf.ce_customers)) = (SELECT count(*) FROM (SELECT  * FROM bl_3nf.ce_customers));
SELECT (SELECT count(*) FROM (SELECT DISTINCT * FROM bl_3nf.ce_employees_scd)) = (SELECT count(*) FROM (SELECT  * FROM bl_3nf.ce_employees_scd));
SELECT (SELECT count(*) FROM (SELECT DISTINCT * FROM bl_3nf.ce_dates)) = (SELECT count(*) FROM (SELECT  * FROM bl_3nf.ce_dates));

SELECT (SELECT count(*) FROM (SELECT DISTINCT * FROM bl_3nf.ce_models)) = (SELECT count(*) FROM (SELECT  * FROM bl_3nf.ce_models));
SELECT (SELECT count(*) FROM (SELECT DISTINCT * FROM bl_3nf.ce_products)) = (SELECT count(*) FROM (SELECT  * FROM bl_3nf.ce_products));
SELECT (SELECT count(*) FROM (SELECT DISTINCT * FROM bl_3nf.ce_sales)) = (SELECT count(*) FROM (SELECT  * FROM bl_3nf.ce_sales));


-- bl_dm
SELECT (SELECT count(*) FROM (SELECT DISTINCT * FROM bl_dm.dim_customers)) = (SELECT count(*) FROM (SELECT  * FROM bl_dm.dim_customers));
SELECT (SELECT count(*) FROM (SELECT DISTINCT * FROM bl_dm.dim_employees_scd)) = (SELECT count(*) FROM (SELECT  * FROM bl_dm.dim_employees_scd));
SELECT (SELECT count(*) FROM (SELECT DISTINCT * FROM bl_dm.dim_dates)) = (SELECT count(*) FROM (SELECT  * FROM bl_dm.dim_dates));

SELECT (SELECT count(*) FROM (SELECT DISTINCT * FROM bl_dm.dim_models)) = (SELECT count(*) FROM (SELECT  * FROM bl_dm.dim_models));
SELECT (SELECT count(*) FROM (SELECT DISTINCT * FROM bl_dm.dim_products)) = (SELECT count(*) FROM (SELECT  * FROM bl_dm.dim_products));
SELECT (SELECT count(*) FROM (SELECT DISTINCT * FROM bl_dm.fct_sales)) = (SELECT count(*) FROM (SELECT  * FROM bl_dm.fct_sales));

