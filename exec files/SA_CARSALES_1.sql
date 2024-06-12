CREATE EXTENSION IF NOT EXISTS  file_fdw;
CREATE SERVER IF NOT EXISTS pglog FOREIGN DATA WRAPPER file_fdw;


-- extract data form business source 1
CREATE FOREIGN TABLE IF NOT EXISTS SA_CARSALES_1.ext_carsales_1 (
year varchar(4000),
make varchar(4000) ,
model varchar(4000),	
trim varchar(4000),
body varchar(4000),
transmission varchar(4000),	
vin varchar(4000),	
state varchar(4000),
condition varchar(4000),	
odometer varchar(4000) ,
color varchar(4000),
interior varchar(4000),	
mmr varchar(4000),
sellingprice varchar(4000),	
saledate varchar(4000),
customer_name varchar(4000) ,	
customer_surname varchar(4000),	
customer_contact varchar(4000),	
employee varchar(4000),
employee_contact varchar(4000),	
employee_badge varchar(4000)
) SERVER pglog
OPTIONS ( filename '../datasets/dataset1.csv', header 'true', format 'csv' ); -- SOURCE file PATH 


-- creating table for increment load. | simulation purpose only
CREATE FOREIGN TABLE IF NOT EXISTS SA_CARSALES_1.ext_carsales_1_increment (
year varchar(4000),
make varchar(4000) ,
model varchar(4000),	
trim varchar(4000),
body varchar(4000),
transmission varchar(4000),	
vin varchar(4000),	
state varchar(4000),
condition varchar(4000),	
odometer varchar(4000) ,
color varchar(4000),
interior varchar(4000),	
mmr varchar(4000),
sellingprice varchar(4000),	
saledate varchar(4000),
customer_name varchar(4000) ,	
customer_surname varchar(4000),	
customer_contact varchar(4000),	
employee varchar(4000),
employee_contact varchar(4000),	
employee_badge varchar(4000)
) SERVER pglog
OPTIONS ( filename '../datasets/dataset1_increment.csv', header 'true', format 'csv' ); -- SOURCE file PATH


-- creating source table
CREATE TABLE IF NOT EXISTS SA_CARSALES_1.src_carsales_1 (
year varchar(4000),
make varchar(4000) ,
model varchar(4000),	
trim varchar(4000),
body varchar(4000),
transmission varchar(4000),	
vin varchar(4000),	
state varchar(4000),
condition varchar(4000),	
odometer varchar(4000) ,
color varchar(4000),
interior varchar(4000),	
mmr varchar(4000),
sellingprice varchar(4000),	
saledate varchar(4000),
customer_name varchar(4000) ,	
customer_surname varchar(4000),	
customer_contact varchar(4000),	
employee varchar(4000),
employee_contact varchar(4000),	
employee_badge varchar(4000)
);


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

-- use to delete increment data for experimental purpose
--DELETE FROM sa_carsales_1.src_carsales_1 
--WHERE CAST(saledate AS TIMESTAMP)::DATE >= '2024-03-30'::date;
--VACUUM FULL sa_carsales_1.src_carsales_1;