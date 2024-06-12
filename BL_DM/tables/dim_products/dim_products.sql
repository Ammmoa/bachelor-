CREATE TABLE IF NOT EXISTS BL_DM.DIM_PRODUCTS (
PRODUCT_SURR_ID INT PRIMARY KEY,
VIN VARCHAR(17),
COLOR VARCHAR(20),
COLOR_ID SMALLINT,
INTERIOR VARCHAR(20),
INTERIOR_ID SMALLINT,
ODOMETER INT,
CONDITION SMALLINT,
STATE VARCHAR(10),
STATE_ID SMALLINT,
TA_INSERT_DT DATE,
TA_UPDATE_DT DATE,
SOURCE_SYSTEM VARCHAR(50),
SOURCE_ENTITY VARCHAR(50),
SOURCE_ID VARCHAR(50)
);