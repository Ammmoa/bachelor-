CREATE EXTENSION IF NOT EXISTS  file_fdw;
CREATE SERVER IF NOT EXISTS pglog FOREIGN DATA WRAPPER file_fdw;


-- extract data form business source 2
CREATE FOREIGN TABLE IF NOT EXISTS SA_CARSALES_2.ext_carsales_2 (
year varchar(4000),
make varchar(4000),
model varchar(4000),	
body varchar(4000),
transmission varchar(4000),	
vin varchar(4000),	
state varchar(4000),
condition varchar(4000),	
odometer varchar(4000) ,
mmr varchar(4000),
sellingprice varchar(4000),	
saledate varchar(4000),
customer_fullname varchar(4000) ,	
customer_contact varchar(4000),	
employee varchar(4000),
employee_contact varchar(4000),	
badge varchar(4000),
profit varchar(4000)
) SERVER pglog
OPTIONS ( filename '../datasets/dataset2.csv', header 'true', format 'csv' ); -- SOURCE file PATH 


-- creating souce table
CREATE TABLE IF NOT EXISTS SA_CARSALES_2.src_carsales_2 (
year varchar(4000),
make varchar(4000),
model varchar(4000),	
body varchar(4000),
transmission varchar(4000),	
vin varchar(4000),	
state varchar(4000),
condition varchar(4000),	
odometer varchar(4000) ,
mmr varchar(4000),
sellingprice varchar(4000),	
saledate varchar(4000),
customer_fullname varchar(4000) ,	
customer_contact varchar(4000),	
employee varchar(4000),
employee_contact varchar(4000),	
badge varchar(4000),
profit varchar(4000)
);


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
