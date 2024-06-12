CREATE EXTENSION IF NOT EXISTS  file_fdw;
CREATE SERVER IF NOT EXISTS pglog FOREIGN DATA WRAPPER file_fdw;


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
OPTIONS ( filename 'E:\archive\dataset2.csv', header 'true', format 'csv' );
