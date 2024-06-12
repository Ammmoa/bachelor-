CREATE EXTENSION IF NOT EXISTS  file_fdw;
CREATE SERVER IF NOT EXISTS pglog FOREIGN DATA WRAPPER file_fdw;


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
OPTIONS ( filename 'E:\archive\dataset1.csv', header 'true', format 'csv' );
