CREATE TABLE IF NOT EXISTS BL_DM.DIM_DATES (
DATE_SURR_ID DATE PRIMARY KEY,
DAY SMALLINT NOT NULL,
MONTH SMALLINT NOT NULL,
YEAR int2 NOT NULL,
SOURCE_SYSTEM VARCHAR(50),
SOURCE_ENTITY VARCHAR(50)
);