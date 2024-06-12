-- in this case (for half million rows) setting table unlogged saves up 1000 ms
ALTER TABLE sa_carsales_2.src_carsales_2 SET UNLOGGED;


BEGIN;

INSERT INTO SA_CARSALES_2.src_carsales_2 (year, make, model, body, transmission,	vin, state, condition, odometer,
						   		   mmr, sellingprice, saledate, customer_fullname,	
						   		   customer_contact, employee, employee_contact, badge, profit)
						   
SELECT year, make, model, body, transmission,	vin, state, condition, 
	   odometer, mmr, sellingprice, saledate, customer_fullname,	
	   customer_contact, employee, employee_contact, badge, profit 
FROM SA_CARSALES_2.ext_carsales_2 AS ed
WHERE NOT EXISTS (
	SELECT * FROM SA_CARSALES_2.src_carsales_2 sd WHERE sd.vin = ed.vin
)AND ed.vin IS NOT NULL 
RETURNING *;
COMMIT;


ALTER TABLE sa_carsales_2.src_carsales_2 SET LOGGED;
