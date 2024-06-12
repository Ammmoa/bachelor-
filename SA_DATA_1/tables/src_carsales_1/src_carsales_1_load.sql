-- in this case (for half million rows) setting table unlogged saves up 1000 ms
ALTER TABLE sa_carsales_1.src_carsales_1 SET UNLOGGED;


BEGIN;

INSERT INTO SA_CARSALES_1.src_carsales_1 (year, make, model, trim, body, transmission,	vin, state, condition, odometer,
						   		   color, interior,	mmr, sellingprice, saledate, customer_name,	customer_surname,	
						   		   customer_contact, employee, employee_contact, employee_badge)
						   		   
SELECT year, make, model, trim, body, transmission,	vin, state, condition, odometer,
	   color, interior,	mmr, sellingprice, saledate, customer_name,	customer_surname,	
	   customer_contact, employee, employee_contact, employee_badge 
FROM SA_CARSALES_1.ext_carsales_1 AS ed
WHERE NOT EXISTS (
	SELECT * FROM SA_CARSALES_1.src_carsales_1 sd WHERE sd.vin = ed.vin AND sd.customer_contact  = ed.customer_contact AND sd.saledate = ed.saledate
) AND ed.vin IS NOT NULL 
RETURNING *;

COMMIT;


ALTER TABLE sa_carsales_1.src_carsales_1 SET LOGGED;

SELECT count(*) FROM sa_carsales_1.src_carsales_1; -- 558841


-- increment load
ALTER TABLE sa_carsales_1.src_carsales_1 SET UNLOGGED;

BEGIN;

INSERT INTO SA_CARSALES_1.src_carsales_1 (year, make, model, trim, body, transmission,	vin, state, condition, odometer,
						   		   color, interior,	mmr, sellingprice, saledate, customer_name,	customer_surname,	
						   		   customer_contact, employee, employee_contact, employee_badge)
			   
SELECT year, make, model, trim, body, transmission,	vin, state, condition, odometer,
	   color, interior,	mmr, sellingprice, saledate, customer_name,	customer_surname,	
	   customer_contact, employee, employee_contact, employee_badge 
FROM SA_CARSALES_1.ext_carsales_1_increment AS ed
WHERE NOT EXISTS (
	SELECT * FROM SA_CARSALES_1.src_carsales_1 sd WHERE sd.vin = ed.vin AND sd.customer_contact  = ed.customer_contact AND sd.saledate = ed.saledate
) AND ed.vin IS NOT NULL 
RETURNING *;

COMMIT;

ALTER TABLE sa_carsales_1.src_carsales_1 SET LOGGED;

SELECT count(*) FROM sa_carsales_1.src_carsales_1; -- 598841


DELETE FROM sa_carsales_1.src_carsales_1 
WHERE CAST(saledate AS TIMESTAMP)::DATE >= '2024-03-30'::date;
VACUUM FULL sa_carsales_1.src_carsales_1;