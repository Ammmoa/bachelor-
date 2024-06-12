SELECT 
(SELECT count(*) FROM (
	SELECT DISTINCT color FROM (
		SELECT color FROM sa_carsales_1.src_carsales_1 WHERE color ~ '^[a-zA-Z]+$'
		UNION ALL 
		SELECT interior FROM sa_carsales_1.src_carsales_1 WHERE interior ~ '^[a-zA-Z]+$'
		-- no color for dataset 2
	)
)) = (SELECT count(*) FROM (SELECT DISTINCT color_src_name FROM bl_cl.t_map_colors));


SELECT 
(SELECT count(*) FROM (
SELECT state FROM (
		SELECT DISTINCT state FROM sa_carsales_1.src_carsales_1 WHERE state ~ '^[a-zA-Z]+$'
		UNION ALL 
		SELECT DISTINCT state FROM sa_carsales_2.src_carsales_2 WHERE state ~ '^[a-zA-Z]+$'
	)
)) = (SELECT count(*) FROM (SELECT DISTINCT state_src_name, source_entity FROM bl_cl.t_map_states ));


SELECT 
(SELECT count(*) FROM (
SELECT make FROM (
		SELECT DISTINCT make FROM sa_carsales_1.src_carsales_1 WHERE make ~ '^[a-zA-Z -]+$'
		UNION ALL 
		SELECT DISTINCT make FROM sa_carsales_2.src_carsales_2 WHERE make ~ '^[a-zA-Z -]+$'
	)
)) = (SELECT count(*) FROM (SELECT DISTINCT brand_src_name, source_entity FROM bl_cl.t_map_brands ));


SELECT 
(SELECT count(*) FROM (
SELECT model FROM (
		SELECT DISTINCT model FROM sa_carsales_1.src_carsales_1 WHERE model IS NOT NULL 
		UNION ALL 
		SELECT DISTINCT model FROM sa_carsales_2.src_carsales_2 WHERE model IS NOT NULL 
	)
)) = (SELECT count(*) FROM (SELECT DISTINCT bmodel_src_name, source_entity FROM bl_cl.t_map_bmodels ));


SELECT 
(SELECT count(*) FROM (
	SELECT DISTINCT customer_contact FROM (
		SELECT customer_contact FROM sa_carsales_1.src_carsales_1
		UNION ALL
		SELECT customer_contact FROM sa_carsales_2.src_carsales_2 
	)
)) = (SELECT count(*) FROM (SELECT DISTINCT customer_id FROM bl_3nf.ce_customers WHERE customer_id != -1)); 


SELECT 
(SELECT count(*) FROM (
	SELECT DISTINCT vin FROM (
		SELECT vin FROM sa_carsales_1.src_carsales_1 WHERE length(vin) = 17 AND vin ~ '^[a-zA-Z0-9]+$'
		UNION ALL 
		SELECT vin FROM sa_carsales_2.src_carsales_2 WHERE length(vin) = 17 AND vin ~ '^[a-zA-Z0-9]+$'
	)
)) = (SELECT count(*) FROM (SELECT DISTINCT product_id FROM bl_3nf.ce_products cp WHERE product_id != -1)); 


SELECT 
(SELECT count(*) FROM (
	SELECT DISTINCT employee_contact FROM (
	SELECT employee_contact FROM sa_carsales_1.src_carsales_1 
	UNION ALL
	SELECT employee_contact FROM sa_carsales_2.src_carsales_2 
	) 
)) = (SELECT count(*) FROM (SELECT DISTINCT employee_id FROM bl_3nf.ce_employees_scd WHERE employee_id != -1));


SELECT 
(SELECT count(*) FROM sa_carsales_1.src_carsales_1) + (SELECT count(*) FROM sa_carsales_2.src_carsales_2) 
= (SELECT count(*) FROM bl_3nf.ce_sales);


