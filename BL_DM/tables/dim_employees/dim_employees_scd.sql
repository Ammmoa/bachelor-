CREATE TABLE IF NOT EXISTS BL_DM.DIM_EMPLOYEES_SCD (
EMPLOYEE_SURR_ID INT,
FIRSTNAME VARCHAR(30),
LASTNAME VARCHAR(30),
EMAIL VARCHAR(50),
BADGE VARCHAR(10),
START_DT DATE,
END_DT DATE,
IS_ACTIVE BOOL,
TA_INSERT_DT DATE,
TA_UPDATE_DT DATE,
SOURCE_SYSTEM VARCHAR(50),
SOURCE_ENTITY VARCHAR(50),
SOURCE_ID VARCHAR(50),
PRIMARY KEY (EMPLOYEE_SURR_ID, START_DT) -- 3nf
);