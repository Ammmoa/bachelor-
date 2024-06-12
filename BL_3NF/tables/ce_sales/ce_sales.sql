CREATE TABLE IF NOT EXISTS BL_3NF.CE_SALES (
SALE_ID INT PRIMARY KEY, 
CUSTOMER_ID INT REFERENCES BL_3NF.CE_CUSTOMERS(CUSTOMER_ID), 
EMPLOYEE_ID INT, 
MODEL_ID INT REFERENCES BL_3NF.CE_MODELS(MODEL_ID), 
PRODUCT_ID INT REFERENCES BL_3NF.CE_PRODUCTS(PRODUCT_ID), 
MMR decimal, 
AMOUNT decimal, 
DATE_ID DATE REFERENCES BL_3NF.CE_DATES(DATE_ID), 
TIME TIME, 
TA_INSERT_DT date, 
TA_UPDATE_DT date, 
SOURCE_SYSTEM varchar(50), 
SOURCE_ENTITY varchar(50), 
SOURCE_ID varchar(50));
