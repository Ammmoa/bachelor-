-- logic - select previous owner, seller, current owner, sale, color, sale info and model info for model. (sold twice by business)

-- 3nf bulk search
EXPLAIN ANALYSE  
WITH SoldTwice AS (
    SELECT product_id
    FROM bl_3nf.ce_sales
    GROUP BY product_id
    HAVING COUNT(*) = 2
)
SELECT sal1.product_id,
       cus1.firstname||' '||cus1.lastname AS previous_owner, cus2.firstname||' '||cus2.lastname AS current_owner,
       emp1.firstname || ' ' || emp1.lastname AS previous_seller, emp2.firstname || ' ' || emp2.lastname AS current_seller,
       col1.color, col2.color  AS interior_color, 
       st.state  AS origin_state, mdl.model
       
FROM bl_3nf.ce_sales sal1
JOIN bl_3nf.ce_sales sal2 ON sal1.product_id = sal2.product_id AND sal1.sale_id < sal2.sale_id
LEFT JOIN bl_3nf.ce_products pro ON sal1.product_id = pro.product_id
LEFT JOIN SoldTwice sol2 ON sal1.product_id = sol2.product_id
LEFT JOIN bl_3nf.ce_colors col1 ON pro.color_id = col1.color_id 
LEFT JOIN bl_3nf.ce_colors col2 ON pro.interior_id  = col2.color_id 
LEFT JOIN bl_3nf.ce_states st ON pro.state_id = st.state_id 
LEFT JOIN bl_3nf.ce_customers cus1 ON sal1.customer_id = cus1.customer_id  
LEFT JOIN bl_3nf.ce_customers cus2 ON sal2.customer_id = cus2.customer_id  
LEFT JOIN bl_3nf.ce_models mdl ON sal1.model_id = mdl.model_id 
LEFT JOIN bl_3nf.ce_employees_scd emp1 ON sal1.employee_id = emp1.employee_id 
LEFT JOIN bl_3nf.ce_employees_scd emp2 ON sal2.employee_id = emp2.employee_id 

ORDER BY sal1.product_id;


-- 3nf layer specific row search
EXPLAIN ANALYSE 
SELECT sal1.product_id,
       cus1.firstname||' '||cus1.lastname AS previous_owner, cus2.firstname||' '||cus2.lastname AS current_owner,
       emp1.firstname || ' ' || emp1.lastname AS previous_seller, emp2.firstname || ' ' || emp2.lastname AS current_seller,
       col1.color, col2.color  AS interior_color, 
       st.state  AS origin_state, mdl.model
       
FROM bl_3nf.ce_sales sal1
JOIN bl_3nf.ce_sales sal2 ON sal1.product_id = sal2.product_id AND sal1.sale_id < sal2.sale_id
LEFT JOIN bl_3nf.ce_products pro ON sal1.product_id = pro.product_id
LEFT JOIN bl_3nf.ce_colors col1 ON pro.color_id = col1.color_id 
LEFT JOIN bl_3nf.ce_colors col2 ON pro.interior_id  = col2.color_id 
LEFT JOIN bl_3nf.ce_states st ON pro.state_id = st.state_id 
LEFT JOIN bl_3nf.ce_customers cus1 ON sal1.customer_id = cus1.customer_id  
LEFT JOIN bl_3nf.ce_customers cus2 ON sal2.customer_id = cus2.customer_id  
LEFT JOIN bl_3nf.ce_models mdl ON sal1.model_id = mdl.model_id 
LEFT JOIN bl_3nf.ce_employees_scd emp1 ON sal1.employee_id = emp1.employee_id 
LEFT JOIN bl_3nf.ce_employees_scd emp2 ON sal2.employee_id = emp2.employee_id 
WHERE pro.product_id = 80383



-- dm layer bulk search
EXPLAIN ANALYZE 
WITH SoldTwice AS (
    SELECT product_surr_id
    FROM bl_dm.fct_sales
    GROUP BY product_surr_id
    HAVING COUNT(*) = 2
)
SELECT sal1.product_surr_id,
       cus1.firstname || ' ' || cus1.lastname AS previous_owner, 
       cus2.firstname || ' ' || cus2.lastname AS current_owner,
       emp1.firstname || ' ' || emp1.lastname AS previous_seller, 
       emp2.firstname || ' ' || emp2.lastname AS current_seller,
       pro.color AS exterior_color, 
       pro.interior, 
       pro.state AS origin_state, 
       mdl.model,
       mdl.brand
       
FROM bl_dm.fct_sales sal1
JOIN bl_dm.fct_sales sal2 ON sal1.product_surr_id = sal2.product_surr_id AND sal1.date_surr_id < sal2.date_surr_id
LEFT JOIN bl_dm.dim_products pro ON sal1.product_surr_id = pro.product_surr_id
LEFT JOIN SoldTwice sol2 ON sal1.product_surr_id = sol2.product_surr_id
LEFT JOIN bl_dm.dim_customers cus1 ON sal1.customer_surr_id = cus1.customer_surr_id  
LEFT JOIN bl_dm.dim_customers cus2 ON sal2.customer_surr_id = cus2.customer_surr_id  
LEFT JOIN bl_dm.dim_models mdl ON sal1.model_surr_id = mdl.model_surr_id 
LEFT JOIN bl_dm.dim_employees_scd emp1 ON sal1.employee_surr_id = emp1.employee_surr_id 
LEFT JOIN bl_dm.dim_employees_scd emp2 ON sal2.employee_surr_id = emp2.employee_surr_id


-- dm layer specific data search
EXPLAIN ANALYZE 
SELECT sal1.product_surr_id,
       cus1.firstname || ' ' || cus1.lastname AS previous_owner, 
       cus2.firstname || ' ' || cus2.lastname AS current_owner,
       emp1.firstname || ' ' || emp1.lastname AS previous_seller, 
       emp2.firstname || ' ' || emp2.lastname AS current_seller,
       pro.color AS exterior_color, 
       pro.interior, 
       pro.state AS origin_state, 
       mdl.model,
       mdl.brand
       
FROM bl_dm.fct_sales sal1
JOIN bl_dm.fct_sales sal2 ON sal1.product_surr_id = sal2.product_surr_id AND sal1.date_surr_id < sal2.date_surr_id
LEFT JOIN bl_dm.dim_products pro ON sal1.product_surr_id = pro.product_surr_id
LEFT JOIN bl_dm.dim_customers cus1 ON sal1.customer_surr_id = cus1.customer_surr_id  
LEFT JOIN bl_dm.dim_customers cus2 ON sal2.customer_surr_id = cus2.customer_surr_id  
LEFT JOIN bl_dm.dim_models mdl ON sal1.model_surr_id = mdl.model_surr_id 
LEFT JOIN bl_dm.dim_employees_scd emp1 ON sal1.employee_surr_id = emp1.employee_surr_id 
LEFT JOIN bl_dm.dim_employees_scd emp2 ON sal2.employee_surr_id = emp2.employee_surr_id
WHERE pro.source_id  = '80383'